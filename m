Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28A96C04A95
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Sep 2022 23:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiI1XJt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 19:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbiI1XJr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 19:09:47 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B6BDF26
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 16:09:44 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id u12so5083776pjj.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 16:09:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=t6sUjaVxR1/rlbPyobLScL49vXgd/S8vFNF34sazTVs=;
        b=l4ToyrcQ+6v3J9kTzihDjDfAAoY6Zx53+Ea9UMOhlDANhQRxP2zNr92sJMGIOIZufi
         KE0mjX2HlPXh9JOl3bbAedJX3GYgbvXrFqcG1yhbkB8N9yG2OTCRRt7sPbs8K6uulcDJ
         9TbsHZb8JQ37v7fgyyNpqbpFMVDT8mMjjxAUDdwpjU5RflPZkOGuxd5p+OYVslwUwaG6
         NVj75elWBFjrjnF8K6tQ1o0lelYiOXKkUfB3Pz3BWEDlFrkwlSJIV8nJgzFBsotJeo7V
         lVcmRFuKGoFeLjo+q3NQ4VSoA1pGFiJKun1VelR35VDYaCiWScFkOgituoiIHCpe+gMI
         O6HA==
X-Gm-Message-State: ACrzQf1WkOyyjNJdddMvGcNB0PvOG/sdvtLBZwkPEMHTr9jdzZbs5TjA
        VekdbVRpUJOZWYUe4aXLT1k=
X-Google-Smtp-Source: AMsMyM5+a/Wr5HHzoIQMsjFOhSJLpPFpbgOXm7f+oeNCI2M+JkUfYnEmLndCRJr2AJrGnkvME9QTQQ==
X-Received: by 2002:a17:902:7241:b0:179:eafe:bd89 with SMTP id c1-20020a170902724100b00179eafebd89mr342164pll.116.1664406583871;
        Wed, 28 Sep 2022 16:09:43 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:2e63:ed10:2841:950e? ([2620:15c:211:201:2e63:ed10:2841:950e])
        by smtp.gmail.com with ESMTPSA id u9-20020a1709026e0900b001754a3c5404sm1535989plk.212.2022.09.28.16.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 16:09:43 -0700 (PDT)
Message-ID: <8261e86c-4e0d-0ec0-e0fb-0552964f6c5b@acm.org>
Date:   Wed, 28 Sep 2022 16:09:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2 8/8] scsi: ufs: Fix a deadlock between PM and the SCSI
 error handler
Content-Language: en-US
To:     Asutosh Das <quic_asutoshd@quicinc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220927184309.2223322-1-bvanassche@acm.org>
 <20220927184309.2223322-9-bvanassche@acm.org>
 <20220927193012.GE15228@asutoshd-linux1.qualcomm.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220927193012.GE15228@asutoshd-linux1.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/27/22 12:30, Asutosh Das wrote:
> On Tue, Sep 27 2022 at 11:45 -0700, Bart Van Assche wrote:
>> +static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
>> +{
>> +    struct ufs_hba *hba = shost_priv(scmd->device->host);
>> +    bool reset_controller = false;
>> +    int tag, ret;
>> +
>> +    if (!hba->system_suspending) {
>> +        /* Activate the error handler in the SCSI core. */
>> +        return SCSI_EH_NOT_HANDLED;
>> +    }
>> +
>> +    /*
>> +     * Handle errors directly to prevent a deadlock between
>> +     * ufshcd_set_dev_pwr_mode() and ufshcd_err_handler().
>> +     */
>> +    for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs) {
>> +        ret = ufshcd_try_to_abort_task(hba, tag);
>> +        dev_info(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
>> +             hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
>> +             ret == 0 ? "succeeded" : "failed");
>> +        if (ret != 0) {
>> +            reset_controller = true;
>> +            break;
>> +        }
>> +    }
>> +    for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) {
>> +        ret = ufshcd_clear_tm_cmd(hba, tag);
> 
> If reset_controller is true, then the HC would be reset and it would
> anyway clear up all resources. Would this be needed if reset_controller is true?

Probably not.

>> +        dev_info(hba->dev, "Aborting TMF %d %s\n", tag,
>> +             ret == 0 ? "succeeded" : "failed");
>> +        if (ret != 0) {
>> +            reset_controller = true;
>> +            break;
>> +        }
>> +    }
>> +    if (reset_controller) {
>> +        dev_info(hba->dev, "Resetting controller\n");
>> +        ufshcd_reset_and_restore(hba);
>> +        if (ufshcd_clear_cmds(hba, 0xffffffff))
>
> ufshcd_reset_and_restore() would reset the host and the device.
> So is the ufshcd_clear_cmds() needed after that?

I will leave out this ufshcd_clear_cmds() call.

Thanks for the feedback.

Bart.
