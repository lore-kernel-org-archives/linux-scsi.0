From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 04/14] cxlflash: Avoid command room violation
Date: Thu, 17 Nov 2016 13:36:41 -0600
Message-ID: <1A9CB955-077B-4B81-840D-9E268DE9B914@linux.vnet.ibm.com>
References: <1479251530-22573-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1479251665-22816-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51910 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753099AbcKQTgu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Nov 2016 14:36:50 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAHJXala023549
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2016 14:36:50 -0500
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26seujw1t7-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2016 14:36:50 -0500
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
        Thu, 17 Nov 2016 12:36:49 -0700
In-Reply-To: <1479251665-22816-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

Hi Uma,

I do see a potential hang issue with this patch. See my comments below.


-matt
 
> On Nov 15, 2016, at 5:14 PM, Uma Krishnan <ukrishn@linux.vnet.ibm.com> wrote:
> 
> During test, a command room violation interrupt is occasionally seen
> for the master context when the CXL flash devices are stressed.
> 
> After studying the code, there could be gaps in the way command room
> value is being cached in cxlflash. When the cached command room is zero
> the thread attempting to send becomes burdened with updating the cached
> value with the actual value from the AFU. Today, this is handled with
> an atomic set operation of the raw value read. Following the atomic
> update, the thread proceeds to send.
> 
> This behavior is incorrect on two counts:
> 
>   - The update fails to take into account the current thread and its
>     consumption of one of the hardware commands.
> 
>   - The update does not take into account other threads also atomically
>     updating. Per design, a worker thread updates the cached value when
>     a send thread times out. By not performing an atomic compare/exchange,
>     the cached value can be incorrectly clobbered.
> 
> To correct these issues, the runtime updates of the cached command room
> are updated to use atomic64_cmpxchg() and the send routine is updated to
> take into account the current thread consuming a hardware command.
> 
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
> ---
> drivers/scsi/cxlflash/main.c | 16 ++++++++++------
> 1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index 6d33d8c..1a32e8b 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -322,9 +322,10 @@ static int send_cmd(struct afu *afu, struct afu_cmd *cmd)
> 	if (!newval) {

When this path is invoked, the current thread is consuming the last entry
available entry before the room must be read again. While the change
below is fine for circumstances where the hardware queue has room for
more than one command, consider a scenario where the queue has room
for only 1 command (the command that you just consumed via the atomic
but are not really consuming with a MMIO due to the revised goto).

In such a scenario this code would loop endlessly, bypassing the timeout
logic completely, until the read room reflected a value greater than 1.

> 		do {
> 			room = readq_be(&afu->host_map->cmd_room);
> -			atomic64_set(&afu->room, room);
> -			if (room)
> -				goto write_ioarrin;
> +			if (room) {
> +				atomic64_cmpxchg(&afu->room, 0, room);
> +				goto retry;
> +			}

If you instead fully consume the entry (goto write_ioarrin - similar as it was
before) and take into account the consumption when you update the cached
value (i.e.: cmpxchg(..., 0, room - 1) the scenario described above will not occur.


