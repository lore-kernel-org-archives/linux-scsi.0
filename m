Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A229C433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Oct 2021 07:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA719619E9
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Oct 2021 07:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhJCHMr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Oct 2021 03:12:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:31385 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhJCHMq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 3 Oct 2021 03:12:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10125"; a="248378444"
X-IronPort-AV: E=Sophos;i="5.85,343,1624345200"; 
   d="scan'208";a="248378444"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2021 00:10:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,343,1624345200"; 
   d="scan'208";a="557397481"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Oct 2021 00:10:50 -0700
Subject: Re: [PATCH 2/2] scsi: ufs: Do not exit ufshcd_err_handler() unless
 operational or dead
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20211002154550.128511-1-adrian.hunter@intel.com>
 <20211002154550.128511-3-adrian.hunter@intel.com>
 <DM6PR04MB6575003C0D1D2A31878B952CFCAD9@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <4be2d6be-fffb-a2e0-aa40-c1bf5fa0fc0e@intel.com>
Date:   Sun, 3 Oct 2021 10:10:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB6575003C0D1D2A31878B952CFCAD9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/10/2021 09:47, Avri Altman wrote:
>> Callers of ufshcd_err_handler() expect it to return in an operational
>> state. However, the code does not check the state before exiting.
>>
>> Add a check for the state and perform retries until either success or the
>> maximum number of retries is reached.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 30 +++++++++++++++++++++++++-----
>>  1 file changed, 25 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 16492779d3a6..33f55ecf43de 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -64,6 +64,9 @@
>>  /* maximum number of reset retries before giving up */
>>  #define MAX_HOST_RESET_RETRIES 5
>>
>> +/* Maximum number of error handler retries before giving up */
>> +#define MAX_ERR_HANDLER_RETRIES 5
>> +
>>  /* Expose the flag value from utp_upiu_query.value */
>>  #define MASK_QUERY_UPIU_FLAG_LOC 0xFF
>>
>> @@ -6070,12 +6073,14 @@ static bool
>> ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
>>  static void ufshcd_err_handler(struct Scsi_Host *host)
>>  {
>>         struct ufs_hba *hba = shost_priv(host);
>> +       int retries = MAX_ERR_HANDLER_RETRIES;
>>         unsigned long flags;
>> -       bool err_xfer = false;
>> -       bool err_tm = false;
>> -       int err = 0, pmc_err;
>> -       int tag;
>> -       bool needs_reset = false, needs_restore = false;
>> +       bool needs_restore;
>> +       bool needs_reset;
>> +       bool err_xfer;
>> +       bool err_tm;
>> +       int pmc_err;
>> +       int tag;
>>
>>         down(&hba->host_sem);
>>         spin_lock_irqsave(hba->host->host_lock, flags);
>> @@ -6093,6 +6098,12 @@ static void ufshcd_err_handler(struct Scsi_Host
>> *host)
>>         /* Complete requests that have door-bell cleared by h/w */
>>         ufshcd_complete_requests(hba);
>>         spin_lock_irqsave(hba->host->host_lock, flags);
>> +again:
>> +       needs_restore = false;
>> +       needs_reset = false;
>> +       err_xfer = false;
>> +       err_tm = false;
>> +
>>         if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
>>                 hba->ufshcd_state = UFSHCD_STATE_RESET;
>>         /*
>> @@ -6213,6 +6224,8 @@ static void ufshcd_err_handler(struct Scsi_Host
>> *host)
>>  do_reset:
>>         /* Fatal errors need reset */
>>         if (needs_reset) {
>> +               int err;
>> +
>>                 hba->force_reset = false;
>>                 spin_unlock_irqrestore(hba->host->host_lock, flags);
>>                 err = ufshcd_reset_and_restore(hba);
>> @@ -6232,6 +6245,13 @@ static void ufshcd_err_handler(struct Scsi_Host
>> *host)
>>                         dev_err_ratelimited(hba->dev, "%s: exit: saved_err 0x%x
>> saved_uic_err 0x%x",
>>                             __func__, hba->saved_err, hba->saved_uic_err);
>>         }
>> +       /* Exit in an operational state or dead */
>> +       if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL &&
>> +           hba->ufshcd_state != UFSHCD_STATE_ERROR) {
>> +               if (--retries)
>> +                       goto again;
> Why do you need to retry here as well?

Thanks for looking at this.

It shouldn't hurt to retry bringing the device back to life.  The
alternative is UFSHCD_STATE_ERROR which means dead.

> ufshcd_reset_and_restore() already exists only if operational or dead?

ufshcd_reset_and_restore() isn't the only path.  There are also
ufshcd_quirk_dl_nac_errors() and ufshcd_config_pwr_mode() and in
the future perhaps others.

This seems the right place to ensure that the error handler
guarantees operational (or dead) status.

> 
> Thanks,
> Avri
> 
>> +               hba->ufshcd_state = UFSHCD_STATE_ERROR;
>> +       }
>>         ufshcd_clear_eh_in_progress(hba);
>>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>>         ufshcd_err_handling_unprepare(hba);
>> --
>> 2.25.1
> 

