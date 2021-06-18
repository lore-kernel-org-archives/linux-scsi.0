Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D357FC48BDF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 08:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC099613B9
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 08:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhFRIzH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 04:55:07 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:39266 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbhFRIzH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2021 04:55:07 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 88F881FDE7;
        Fri, 18 Jun 2021 08:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624006377; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=olGiIaMCgGhdIxOpJ72VqWOqc2xN2kYdZ90fvIDLVy0=;
        b=eWK0mHC1HJLZlvtCKWTjOWxMljnnpb9j47EXi4/tV4SDfLtMOIG2oNZRvaDVUPPNFI/3qU
        jU6H0Ryx9iulKnwU/mbpeDPbI2sZInTy5lXrnaqRj9FQRQk/FpM3QSc2XS37EZGdP/wdqW
        S3GDK/1zhC5vaKF2Y9XphGN0L1Q5YpQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624006377;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=olGiIaMCgGhdIxOpJ72VqWOqc2xN2kYdZ90fvIDLVy0=;
        b=mI2E1pn1eoZkrPFM7Q6DEid8JTo54ZK2GHuuC/iJRgBwdTbE4ujljU9CPJyUwIaBsr7/3j
        ebFmqQYVrTd43uBg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 6F7AB118DD;
        Fri, 18 Jun 2021 08:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624006377; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=olGiIaMCgGhdIxOpJ72VqWOqc2xN2kYdZ90fvIDLVy0=;
        b=eWK0mHC1HJLZlvtCKWTjOWxMljnnpb9j47EXi4/tV4SDfLtMOIG2oNZRvaDVUPPNFI/3qU
        jU6H0Ryx9iulKnwU/mbpeDPbI2sZInTy5lXrnaqRj9FQRQk/FpM3QSc2XS37EZGdP/wdqW
        S3GDK/1zhC5vaKF2Y9XphGN0L1Q5YpQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624006377;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=olGiIaMCgGhdIxOpJ72VqWOqc2xN2kYdZ90fvIDLVy0=;
        b=mI2E1pn1eoZkrPFM7Q6DEid8JTo54ZK2GHuuC/iJRgBwdTbE4ujljU9CPJyUwIaBsr7/3j
        ebFmqQYVrTd43uBg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id fd43GulezGCHIQAALh3uQQ
        (envelope-from <dwagner@suse.de>); Fri, 18 Jun 2021 08:52:57 +0000
Date:   Fri, 18 Jun 2021 10:52:57 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH v2 02/15] lpfc: Fix auto sli_mode and its effect on
 CONFIG_PORT for SLI3
Message-ID: <20210618085257.ouah6xsjv3akkjhz@beryllium.lan>
References: <20210104180240.46824-1-jsmart2021@gmail.com>
 <20210104180240.46824-3-jsmart2021@gmail.com>
 <20210607110630.kwn74yfrbsrrrhsm@beryllium.lan>
 <06b1d757-9046-8b94-265b-c6c760cd8749@gmail.com>
 <20210615124502.yzmudtm22pjzwqxj@beryllium.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615124502.yzmudtm22pjzwqxj@beryllium.lan>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

On Tue, Jun 15, 2021 at 02:45:02PM +0200, Daniel Wagner wrote:
> I haven't heard back yet if the lpfc_use_msi=0 setting fixes the problem
> (waiting for the next maintenance window for the experiment).

lpfc_use_msi=0 did not help in this case. Only a complete revert of the
patch fixes the issue.

Anyway, I was thinking about adding something a workaround to our
downstream version. I figured that sli_mode is unused and we could abuse
it to select SLI version for lpfc_sli_config_port(). Something like:


diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 1ad1beb2a8a8..cf8538ca8402 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5355,7 +5355,10 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba)
 
        /* Enable ISR already does config_port because of config_msi mbx */
        if (phba->hba_flag & HBA_NEEDS_CFG_PORT) {
-               rc = lpfc_sli_config_port(phba, LPFC_SLI_REV3);
+               if (phba->cfg_sli_mode == 2)
+                       rc = lpfc_sli_config_port(phba, LPFC_SLI_REV2);
+               else
+                       rc = lpfc_sli_config_port(phba, LPFC_SLI_REV3);
                if (rc)
                        return -EIO;
                phba->hba_flag &= ~HBA_NEEDS_CFG_PORT;


Thanks,
Daniel
