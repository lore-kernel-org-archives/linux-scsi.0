From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/6] cxlflash: Reset command ioasc
Date: Mon, 8 Jan 2018 10:59:45 -0600
Message-ID: <1550366B-5A79-4BB9-9881-B3E11137F36F@linux.vnet.ibm.com>
References: <1515020002-43551-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1515020042-43590-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <be8c1d08-f78a-a7f0-d912-e638646db80e@au1.ibm.com>
 <20180107193604.GB45065@p8tul1-build.aus.stglabs.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36092 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933713AbeAHQ7u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2018 11:59:50 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.21) with SMTP id w08GxjmK013813
        for <linux-scsi@vger.kernel.org>; Mon, 8 Jan 2018 11:59:50 -0500
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2fcat9paff-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jan 2018 11:59:48 -0500
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Mon, 8 Jan 2018 09:59:48 -0700
In-Reply-To: <20180107193604.GB45065@p8tul1-build.aus.stglabs.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: Andrew Donnellan <andrew.donnellan@au1.ibm.com>, James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Christophe Lombard <clombard@linux.vnet.ibm.com>


> On Jan 7, 2018, at 1:36 PM, Matthew R. Ochs <mrochs@linux.vnet.ibm.com> wrote:
> 
> On Thu, Jan 04, 2018 at 05:33:48PM +1100, Andrew Donnellan wrote:
>> On 04/01/18 09:54, Uma Krishnan wrote:
>>> In the event of a command failure, cxlflash returns the failure to the
>>> upper layers to process. After processing the error, when the command is
>>> queued again, the private command structure will not be zeroed and the
>>> ioasc could be stale. Per the SISLite specification, the AFU only sets the
>>> ioasc in the presence of a failure. Thus, even though the original command
>>> succeeds the second time, the command is considered a failure due to stale
>>> ioasc. This cycle repeats indefinitely and can cause a hang or IO failure.
>>> 
>>> To fix the issue, clear the ioasc before queuing any command.
>>> 
>>> Fixes: 479ad8e9d48c ("scsi: cxlflash: Remove zeroing of private command
>>> data")
>>> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
>> 
>> Should this go to stable?
> 
> Not a bad idea.
> 

I will forward the patch to stable once the patch is in next/master. 
Unless there is a need to send a V2. Thanks for pointing out Andrew !!
