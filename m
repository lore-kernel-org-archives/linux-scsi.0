From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 03/30] cxlflash: Fix read capacity timeout
Date: Mon, 21 Sep 2015 17:11:57 -0500
Message-ID: <62052676-EEC9-4B42-A5BA-BFADC628A18F@linux.vnet.ibm.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com> <1442438806-49198-1-git-send-email-mrochs@linux.vnet.ibm.com> <55FFEBC0.5020507@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:36533 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529AbbIUWMB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2015 18:12:01 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Mon, 21 Sep 2015 16:12:00 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 636073E4003E
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 16:11:58 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8LMAnLG14680256
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 15:10:49 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8LMBuBE022767
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 16:11:57 -0600
In-Reply-To: <55FFEBC0.5020507@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, Manoj Kumar <kumarmn@us.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Sep 21, 2015, at 6:36 AM, Tomas Henzl <thenzl@redhat.com> wrote:
> On 16.9.2015 23:26, Matthew R. Ochs wrote:
>> From: Manoj Kumar <kumarmn@us.ibm.com>
>> 
>> The timeout value for read capacity is too small. Certain devices
>> may take longer to respond and thus the command may prematurely
>> timeout. Additionally the literal used for the timeout is stale.
>> 
>> Update the timeout to 30 seconds (matches the value used in sd.c)
>> and rework the timeout literal to a more appropriate description.
>> 
>> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
>> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
>> Suggested-by: Brian King <brking@linux.vnet.ibm.com>
>> ---
>> drivers/scsi/cxlflash/superpipe.c | 9 ++++-----
>> drivers/scsi/cxlflash/superpipe.h | 2 +-
>> drivers/scsi/cxlflash/vlun.c      | 4 ++--
>> 3 files changed, 7 insertions(+), 8 deletions(-)
>> 
>> diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
>> index 7df985d..fa513ba 100644
>> --- a/drivers/scsi/cxlflash/superpipe.c
>> +++ b/drivers/scsi/cxlflash/superpipe.c
>> @@ -296,7 +296,7 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
>> 	int rc = 0;
>> 	int result = 0;
>> 	int retry_cnt = 0;
>> -	u32 tout = (MC_DISCOVERY_TIMEOUT * HZ);
>> +	u32 to = (CMD_TIMEOUT * HZ);
> 
> In V3 please remove the parenthesis here^

Sure.

> 
>> 
>> retry:
>> 	cmd_buf = kzalloc(CMD_BUFSIZE, GFP_KERNEL);
> ...
> 
>> @@ -1376,8 +1375,8 @@ out_attach:
>> 	attach->block_size = gli->blk_len;
>> 	attach->mmio_size = sizeof(afu->afu_map->hosts[0].harea);
>> 	attach->last_lba = gli->max_lba;
>> -	attach->max_xfer = (sdev->host->max_sectors * MAX_SECTOR_UNIT) /
>> -		gli->blk_len;
>> +	attach->max_xfer = (sdev->host->max_sectors * MAX_SECTOR_UNIT);
> 
> and here^ too.

done.

