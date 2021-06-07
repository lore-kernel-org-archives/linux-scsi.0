Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDBE6C47095
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 15:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4E8B61107
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 15:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbhFGPOc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 11:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbhFGPOb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 11:14:31 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57D2C061766
        for <linux-scsi@vger.kernel.org>; Mon,  7 Jun 2021 08:12:25 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id z3-20020a17090a3983b029016bc232e40bso198932pjb.4
        for <linux-scsi@vger.kernel.org>; Mon, 07 Jun 2021 08:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cm3qgzi23mBbzxMJsLrt1zLbD3zvIpRVy2R0h23ZSjQ=;
        b=qaYOnxFry+kMfTwY/EVosRlumn8TNOy8t7GjsXlgJk9ZspsdfY3jvPwPRo+jE+3i1M
         Dk0elceUF1xG8G8FApSP3SnaUnAJbSt2Y1Gw3rHkUmA5Z2GSJWzx5V08XJHbwRwIcilI
         gcCwj2beB4sJtxb9zTwE0Ris0/q99aVMixMnItRG6zccBE0MopqNXNKEnBYqCnsbqvfY
         CClwwXG7YUFVWwhLap0KVkxtvZ7gMQpxqAiY/2WcO+DT6iXlLTpYWr+1hIwrmvvA67YM
         5asze7WqJZJndtLaWFLDRFCGqMwp0D2PX71R9ZwOeMXdAMeNgP1ppug9JkLMvgGC89w3
         CLHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cm3qgzi23mBbzxMJsLrt1zLbD3zvIpRVy2R0h23ZSjQ=;
        b=g27SRfy3w2AFbM902i95OIK37eSnO1GpphlUNMXpqNsOaJ1AYIs6G7tWu+JcBgqCyQ
         G4jCtpLTvGSwJXXd/lCEi6BDjIo31flho2PyKuZpTgB0JuyYpz67Z8nICvmoZvN7ITMI
         sHBSBvPtyW7MuZ29lzw5eSa9T+mnTUZDVVAl2k3XUWVyrMQztFaTPCQfyO/X609g8ez4
         gr29adRtgXX1atMhR2LrqmTZqz1NABZ9NTRwjHrYMsWnup5WgHoVY9uzgtQkEsHlNEc2
         3jezGGYrKHXeNiNbHMRwzyWbZByBXz7EzmN0nifHbLMn5AD2QyESi60rXoh3er8VF5Kd
         MjUA==
X-Gm-Message-State: AOAM5312Ds/i/k3PEmNJqoIMQBUG70vW559LwI6oh4koNx3uNW9w9XT2
        +5siYqH//4K0wg0VdnzGpLVI3D8Ohgg=
X-Google-Smtp-Source: ABdhPJxg+6YZYMltoTRHI4uCE8KRPeEFnd9FxbXKEU/Y52U4Is4h3SMiTID5bm93NFM3eHpuFL4w5g==
X-Received: by 2002:a17:902:8e86:b029:10f:44bb:2c42 with SMTP id bg6-20020a1709028e86b029010f44bb2c42mr17130706plb.67.1623078743567;
        Mon, 07 Jun 2021 08:12:23 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 21sm8192413pfh.103.2021.06.07.08.12.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 08:12:23 -0700 (PDT)
Subject: Re: [PATCH v2 02/15] lpfc: Fix auto sli_mode and its effect on
 CONFIG_PORT for SLI3
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
References: <20210104180240.46824-1-jsmart2021@gmail.com>
 <20210104180240.46824-3-jsmart2021@gmail.com>
 <20210607110630.kwn74yfrbsrrrhsm@beryllium.lan>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <06b1d757-9046-8b94-265b-c6c760cd8749@gmail.com>
Date:   Mon, 7 Jun 2021 08:12:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210607110630.kwn74yfrbsrrrhsm@beryllium.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/7/2021 4:06 AM, Daniel Wagner wrote:
> Hi James,
> 
> On Mon, Jan 04, 2021 at 10:02:27AM -0800, James Smart wrote:
>> A very long time ago, there was a feature: auto sli mode. It gave the
>> user the ability to auto select the SLI mode (SLI2 or SLI3) to run the
>> port in, or even force SLI2 mode if configured.  Because of the
>> convoluted logic, the CONFIG_PORT mbox command ends up being called 2 or
>> 3 times. It should have been called only once.  Additionally, the driver
>> no longer supports SLI-2, so only SLI-3 mode should be allowed.
>>
>> The following changes were made:
>> - Force module parameter to SLI3 only.
>> - Rip out redundant CONFIG_PORT mbox commands.
>> - Force CONFIG_PORT mbox command to be in beginning of enable ISR routine.
>> - Added changes for offline to online behavior
> 
> We got a regression report for this patch. The problem seems to be
> related with older Emulex HBAs. The symptom is in this case one port is
> not enabled. A revert of this patch fixed the problem. This was
> observed with:
> 
>    Emulex LPe11000 FV2.72X2 DV12.8.0.7 HN:FR2AS6AP2-0001 OS:Linux
> 
> Here some ramblings from my debugging:
> 
> In the logs I found:
> 
>> 0000:0b:00.0: 0:0431 Failed to enable interrupt.
>> 0000:0b:00.0: 0:0431 Failed to enable interrupt.
>> 0000:0b:00.0: 0:0431 Failed to enable interrupt.
> 
> cfg_sli_mode used to be 0 (auto) and the config port setup
> used to try first mode = 3 and then fall back to mode = 2
> 
>> -       rc = lpfc_sli_config_port(phba, mode);
>> -
>> -       if (rc && phba->cfg_sli_mode == 3)
>> -               lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
>> -                               "1820 Unable to select SLI-3.  "
>> -                               "Not supported by adapter.\n");
>> -       if (rc && mode != 2)
>> -               rc = lpfc_sli_config_port(phba, 2);
> 
> the port config is now in lpfc_sli_enable_intr which is hardcoded
> to LPFC_SLI_REV3 and I think this fails and the HBA_NEEDS_CFG_PORT
> flag is not resetted, hence in lpfc_sli_hba_setup() the new
> code tries to enable the port again with:
> 
>> +       /* Enable ISR already does config_port because of config_msi mbx */
>> +       if (phba->hba_flag & HBA_NEEDS_CFG_PORT) {
>> +               rc = lpfc_sli_config_port(phba, LPFC_SLI_REV3);
>> +               if (rc)
>> +                       return -EIO;
>> +               phba->hba_flag &= ~HBA_NEEDS_CFG_PORT;
> 
> Though I think this should something like
> 
>     lpfc_sli_config_port(phba, LPFC_SLI_REV2);
> 
> for the specific case.
> 
> HTH!
> 
> Thanks,
> Daniel
> 

ouch - What you are describing is likely true, but sli-2 firmware is 
*extremely* old - 2 decades or more. If a change wont work first shot, 
it likely won't be worth the effort to try to fix it. Other 
functionality may be hanging on by a thread.  That adapter certainly 
runs SLI-3 (even that is 10-15 yrs old), so the best solution is a fw 
upgrade that picks up the sli3 interface. Is that possible?

Given that the error message you quoted was a failure of interrupt, that 
may be a clue. It may well be the adapter has sli3 firmware and it's 
failing on setting the interrupt vector type.  The older adapters 
supported MSI and INTx. SLI-2 may have been limited to INTx only. There 
used to be hiccups in some platforms with MSI support (platform said it 
did, but was broken) which is why the driver had "set it, test it, 
revert it" logic. I believe the driver has a lpfc_use_msi module 
parameter that when set to 0 should use only INTx, which may be what the 
sli2 downgrade is effectively doing. Try setting that and seeing if the 
card loads the sli3 image and runs.


-- james
