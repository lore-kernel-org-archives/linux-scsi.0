Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8EB2CA9EC0
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 02:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9324221835
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 02:11:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SaFeHVwT";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="e+kZSsC9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbfJ2CLI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 22:11:08 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47852 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfJ2CLI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 22:11:08 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1CF8A60D93; Tue, 29 Oct 2019 02:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572315067;
        bh=Afg2ZB0Ny7/9nO5a+P8vyHoOw/fBrPUC0+z5jmTbZpg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SaFeHVwTm6hca0SBB+7L2FdB+k4dtvpXYljauLFK1nyBC8YxLgHA6tqtaS6xUkpZf
         8hcLRsBYOt3uObIcVyugAtBQqXFz80YTDMkLhao7oqOXLJ/FHQS3e+l/WtdZ6I1UEE
         mJ+9+71icZlYEmkvWtq/AqZ5AG9ciqG6Uh+YYsuI=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 60AF860D77;
        Tue, 29 Oct 2019 02:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572315065;
        bh=Afg2ZB0Ny7/9nO5a+P8vyHoOw/fBrPUC0+z5jmTbZpg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e+kZSsC95ZomIt4Ot4nGXsn7rCEwPDXMHuEFb0UH0DYBInIZjTXbofoYNkZAwZTCm
         0xwDmRWw80q0wAzqojMfafNtkV9GPhQoOhArecDnMwwNLu/aqeZdAk8R8OrKM0KPnk
         QbuQS5PY690J9aO+sbcAVNCOd78gSP0MMY7hdZp0=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 29 Oct 2019 10:11:05 +0800
From:   cang@codeaurora.org
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] [PATCH v1 1/2] scsi: ufs: Introduce a vops for resetting
 host controller
In-Reply-To: <BN7PR08MB568444BD52F49775D7EEB363DB6B0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1571804009-29787-1-git-send-email-cang@codeaurora.org>
 <1571804009-29787-2-git-send-email-cang@codeaurora.org>
 <BN7PR08MB568444BD52F49775D7EEB363DB6B0@BN7PR08MB5684.namprd08.prod.outlook.com>
Message-ID: <ebd83f54b99a544a15fca681196bb8f3@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-23 18:39, Bean Huo (beanhuo) wrote:
> Hi, Can Guo
> Actually, we already have DME_RESET,  this is not enough for Qualcomm 
> host?
> Thanks,
> 
> //Bean
> 

Hi Bean,

Yes, for Qualcomm hosts, we need this to fully reset the whole UFS 
controller block

Can Guo

>> 
>> Some UFS host controllers need their specific implementations of 
>> resetting to
>> get them into a good state. Provide a new vops to allow the platform 
>> driver to
>> implement this own reset operation.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 16 ++++++++++++++++  
>> drivers/scsi/ufs/ufshcd.h | 10
>> ++++++++++
>>  2 files changed, 26 insertions(+)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c 
>> index
>> c28c144..161e3c4 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -3859,6 +3859,14 @@ static int ufshcd_link_recovery(struct ufs_hba 
>> *hba)
>>  	ufshcd_set_eh_in_progress(hba);
>>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>> 
>> +	ret = ufshcd_vops_full_reset(hba);
>> +	if (ret)
>> +		dev_warn(hba->dev, "%s: full reset returned %d\n",
>> +				  __func__, ret);
>> +
>> +	/* Reset the attached device */
>> +	ufshcd_vops_device_reset(hba);
>> +
>>  	ret = ufshcd_host_reset_and_restore(hba);
>> 
>>  	spin_lock_irqsave(hba->host->host_lock, flags); @@ -6241,6 +6249,11
>> @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
>>  	int retries = MAX_HOST_RESET_RETRIES;
>> 
>>  	do {
>> +		err = ufshcd_vops_full_reset(hba);
>> +		if (err)
>> +			dev_warn(hba->dev, "%s: full reset returned %d\n",
>> +					__func__, err);
>> +
>>  		/* Reset the attached device */
>>  		ufshcd_vops_device_reset(hba);
>> 
>> @@ -8384,6 +8397,9 @@ int ufshcd_init(struct ufs_hba *hba, void 
>> __iomem
>> *mmio_base, unsigned int irq)
>>  		goto exit_gating;
>>  	}
>> 
>> +	/* Reset controller to power on reset (POR) state */
>> +	ufshcd_vops_full_reset(hba);
>> +
>>  	/* Reset the attached device */
>>  	ufshcd_vops_device_reset(hba);
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h 
>> index
>> e0fe247..253b9ea 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -296,6 +296,8 @@ struct ufs_pwr_mode_info {
>>   * @apply_dev_quirks: called to apply device specific quirks
>>   * @suspend: called during host controller PM callback
>>   * @resume: called during host controller PM callback
>> + * @full_reset: called for handling variant specific implementations 
>> of
>> + *              resetting the hci
>>   * @dbg_register_dump: used to dump controller debug information
>>   * @phy_initialization: used to initialize phys
>>   * @device_reset: called to issue a reset pulse on the UFS device @@ 
>> -325,6
>> +327,7 @@ struct ufs_hba_variant_ops {
>>  	int	(*apply_dev_quirks)(struct ufs_hba *);
>>  	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
>>  	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
>> +	int	(*full_reset)(struct ufs_hba *hba);
>>  	void	(*dbg_register_dump)(struct ufs_hba *hba);
>>  	int	(*phy_initialization)(struct ufs_hba *);
>>  	void	(*device_reset)(struct ufs_hba *hba);
>> @@ -1076,6 +1079,13 @@ static inline int ufshcd_vops_resume(struct 
>> ufs_hba
>> *hba, enum ufs_pm_op op)
>>  	return 0;
>>  }
>> 
>> +static inline int ufshcd_vops_full_reset(struct ufs_hba *hba) {
>> +	if (hba->vops && hba->vops->full_reset)
>> +		return hba->vops->full_reset(hba);
>> +	return 0;
>> +}
>> +
>>  static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba) 
>>  {
>>  	if (hba->vops && hba->vops->dbg_register_dump)
>> --
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
>> Forum,
>> a Linux Foundation Collaborative Project
