From: Dan Carpenter <error27@gmail.com>
Subject: Re: [patch] off by one in FlashPoint.c
Date: Mon, 28 Dec 2009 20:03:48 +0200
Message-ID: <20091228180348.GH17645@bicker>
References: <20091227131446.GI6075@bicker> <4B38E77F.2070201@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:50828 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbZL1SEK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Dec 2009 13:04:10 -0500
Received: by fxm25 with SMTP id 25so4737962fxm.21
        for <linux-scsi@vger.kernel.org>; Mon, 28 Dec 2009 10:04:06 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <4B38E77F.2070201@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On Mon, Dec 28, 2009 at 12:14:39PM -0500, Joe Eykholt wrote:
>
>
> Dan Carpenter wrote:
>> The check should be >= instead of > or we could go past the end of the
>> array.
>
> What about the LUN check?   I'm not sure either way, but usually MAX LUN
> is the max number of LUNs, not the max LU number, although that's been
> in flux lately.
>

No no.  You're clearly correct.  That matches how MAX_LUN is used throughout 
the file.

Will send an updated patch.

regards,
dan carpenter

>>
>> Signed-off-by: Dan Carpenter <error27@gmail.com>
>>
>> --- orig/drivers/scsi/FlashPoint.c	2009-12-27 11:35:58.000000000 +0200
>> +++ devel/drivers/scsi/FlashPoint.c	2009-12-27 11:36:19.000000000 +0200
>> @@ -3924,7 +3924,7 @@
>>  {
>>  	struct sccb_mgr_tar_info *currTar_Info;
>>  -	if ((p_sccb->TargID > MAX_SCSI_TAR) || (p_sccb->Lun > MAX_LUN)) {
>> +	if ((p_sccb->TargID >= MAX_SCSI_TAR) || (p_sccb->Lun > MAX_LUN)) {
>>  		return;
>>  	}
>>  	currTar_Info = &FPT_sccbMgrTbl[p_card][p_sccb->TargID];
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
