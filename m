Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C76C47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 11:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8C5760FDA
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 11:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhFGLIX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 07:08:23 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33264 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhFGLIX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 07:08:23 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2AC6121A59;
        Mon,  7 Jun 2021 11:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623063991; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GHYTT534j1CyXuVjlW+dmJdW1mhRIl30E7ZHgn5NbCI=;
        b=SuPyxBWtCPEH6kWLNRw5XWJeIhW6o7+OoN8rrfvwND2IgNdi9ytchWkjCAgyeVoRrbtd6Y
        oVdFmfRRo2jZ89NzUu8VFFpfFXVVUz3VDX9g0Wlo4atdgEIY6TQXuJtXC8mUOwQbk1ddET
        R6ON6wDiZaSTSLtAFFoNBgZWBo9O9m4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623063991;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GHYTT534j1CyXuVjlW+dmJdW1mhRIl30E7ZHgn5NbCI=;
        b=toirQodYRyYLg7v9MGC8BZKI9Hj9p+XMZROnH48zTvvlvAeW2+kT6kYPICoAd0wxsBHV1z
        YbbMTE1mJc4Xs5Dw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 0C4E8118DD;
        Mon,  7 Jun 2021 11:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623063991; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GHYTT534j1CyXuVjlW+dmJdW1mhRIl30E7ZHgn5NbCI=;
        b=SuPyxBWtCPEH6kWLNRw5XWJeIhW6o7+OoN8rrfvwND2IgNdi9ytchWkjCAgyeVoRrbtd6Y
        oVdFmfRRo2jZ89NzUu8VFFpfFXVVUz3VDX9g0Wlo4atdgEIY6TQXuJtXC8mUOwQbk1ddET
        R6ON6wDiZaSTSLtAFFoNBgZWBo9O9m4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623063991;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GHYTT534j1CyXuVjlW+dmJdW1mhRIl30E7ZHgn5NbCI=;
        b=toirQodYRyYLg7v9MGC8BZKI9Hj9p+XMZROnH48zTvvlvAeW2+kT6kYPICoAd0wxsBHV1z
        YbbMTE1mJc4Xs5Dw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id RSyEArf9vWA6TAAALh3uQQ
        (envelope-from <dwagner@suse.de>); Mon, 07 Jun 2021 11:06:31 +0000
Date:   Mon, 7 Jun 2021 13:06:30 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH v2 02/15] lpfc: Fix auto sli_mode and its effect on
 CONFIG_PORT for SLI3
Message-ID: <20210607110630.kwn74yfrbsrrrhsm@beryllium.lan>
References: <20210104180240.46824-1-jsmart2021@gmail.com>
 <20210104180240.46824-3-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104180240.46824-3-jsmart2021@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

On Mon, Jan 04, 2021 at 10:02:27AM -0800, James Smart wrote:
> A very long time ago, there was a feature: auto sli mode. It gave the
> user the ability to auto select the SLI mode (SLI2 or SLI3) to run the
> port in, or even force SLI2 mode if configured.  Because of the
> convoluted logic, the CONFIG_PORT mbox command ends up being called 2 or
> 3 times. It should have been called only once.  Additionally, the driver
> no longer supports SLI-2, so only SLI-3 mode should be allowed.
> 
> The following changes were made:
> - Force module parameter to SLI3 only.
> - Rip out redundant CONFIG_PORT mbox commands.
> - Force CONFIG_PORT mbox command to be in beginning of enable ISR routine.
> - Added changes for offline to online behavior

We got a regression report for this patch. The problem seems to be
related with older Emulex HBAs. The symptom is in this case one port is
not enabled. A revert of this patch fixed the problem. This was
observed with:

  Emulex LPe11000 FV2.72X2 DV12.8.0.7 HN:FR2AS6AP2-0001 OS:Linux

Here some ramblings from my debugging:

In the logs I found:

> 0000:0b:00.0: 0:0431 Failed to enable interrupt.
> 0000:0b:00.0: 0:0431 Failed to enable interrupt.
> 0000:0b:00.0: 0:0431 Failed to enable interrupt.

cfg_sli_mode used to be 0 (auto) and the config port setup
used to try first mode = 3 and then fall back to mode = 2

> -       rc = lpfc_sli_config_port(phba, mode);
> -
> -       if (rc && phba->cfg_sli_mode == 3)
> -               lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
> -                               "1820 Unable to select SLI-3.  "
> -                               "Not supported by adapter.\n");
> -       if (rc && mode != 2)
> -               rc = lpfc_sli_config_port(phba, 2);

the port config is now in lpfc_sli_enable_intr which is hardcoded
to LPFC_SLI_REV3 and I think this fails and the HBA_NEEDS_CFG_PORT
flag is not resetted, hence in lpfc_sli_hba_setup() the new
code tries to enable the port again with:

> +       /* Enable ISR already does config_port because of config_msi mbx */
> +       if (phba->hba_flag & HBA_NEEDS_CFG_PORT) {
> +               rc = lpfc_sli_config_port(phba, LPFC_SLI_REV3);
> +               if (rc)
> +                       return -EIO;
> +               phba->hba_flag &= ~HBA_NEEDS_CFG_PORT;

Though I think this should something like

   lpfc_sli_config_port(phba, LPFC_SLI_REV2);

for the specific case.

HTH!

Thanks,
Daniel
