Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A47C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 10:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFD0D61166
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 10:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238488AbhDSKPZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 06:15:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53781 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235536AbhDSKPY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 06:15:24 -0400
Received: from mail-oi1-f197.google.com ([209.85.167.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <chris.chiu@canonical.com>)
        id 1lYQve-000760-C7
        for linux-scsi@vger.kernel.org; Mon, 19 Apr 2021 10:14:54 +0000
Received: by mail-oi1-f197.google.com with SMTP id a12-20020a056808128cb029010262e5ebd2so11207329oiw.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 03:14:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=AFGQXRTkm+Wz/d9byiqmpLrhi68ol481g+XnsvV8E3Y=;
        b=BJyDMz2AQZSQyI0IZl/v4vwYOIrReCsytS4KxSyb6wpf6ZI6xUKYVpbGiQx79tNxKt
         wbe9dWPAMyw9sWOst8YD8DO2rtF0Q9lEHEUAKW4AegsayMO3d8NXWOenkE6dDPp+LE0u
         7Tj9tOKXchQZN/7G2+HNUOj1JKXf0SyQduLWTn1JJUAqUxjKhZQrU66gl+ytZ2bg8cpE
         oN+bTAPKlK6qMmBk5NEXNlrX76Qoru2uZPxjwPGeP3D77WbnmDeQpkkLnmHmuMGhdk3X
         h6IKGsU+qOJTpnwXy3z+Zi8u0pvPbR+B4YFOYzeY5JCU+q3AurSMK56o1pRcR2ycpAcK
         AamA==
X-Gm-Message-State: AOAM532qGzWl3IIh7jPlVvwWniD/EBm7VbBzIb5saItsia2/jVS+wFSR
        XSD2xmoLyw3LbTPHPXwjWYpu6EbO7QRgqLzTVqI+M1S1eHYhY49ooIgPdjbdIECbwd6WGpN6huM
        0ddUca0rCHdST8b+gsOqPWsil9c7FidOVi63uWbJMRMnxRvV2MDyZCOg=
X-Received: by 2002:aca:3d86:: with SMTP id k128mr15405658oia.86.1618827293199;
        Mon, 19 Apr 2021 03:14:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZ3H/MPVrkZPdrf0JMRaUd5nUx31rAGnUgSwEHkFfbZTUMhJhlgUCnD3bx/Kq6qun+RMwDKY8j0d0G21mIxk4=
X-Received: by 2002:aca:3d86:: with SMTP id k128mr15405642oia.86.1618827293014;
 Mon, 19 Apr 2021 03:14:53 -0700 (PDT)
MIME-Version: 1.0
From:   Chris Chiu <chris.chiu@canonical.com>
Date:   Mon, 19 Apr 2021 18:14:42 +0800
Message-ID: <CABTNMG0C7_1xYvgethtdPNTBLAfQEy5xu7q-MG=BbpqF2TwY5A@mail.gmail.com>
Subject: Broadcom 9460 raid card takes too long at system resuming
To:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        megaraidlinux.pdl@broadcom.com
Cc:     linux-scsi@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,
    We found that the Broadcom 9460 RAID card will take ~40 seconds in
 megasas_resume. It is mainly waiting for the FW to come to ready
state, please refer to the following kernel log. The FW version is
"megasas: 07.714.04.00-rc1". It seems that the
megasas_transition_to_ready() loop costs ~40 seconds in
megasas_resume. However, the same megasas_transition_to_ready()
function only takes a few milliseconds to complete in
megasas_init_fw(). The .read_fw_status_reg maps to
megasas_read_fw_status_reg_fusion. I tried to add
pci_enable_device_mem() and pci_set_master before
megasas_transition_to_ready() in megasas_resume() but it makes no
difference.

I don't really know what makes the difference between driver probe and
resume. The lspci information of the raid controller is here
https://gist.github.com/mschiu77/e74ec084cc925643add845fa4dc31ab6. Any
suggestions about what I can do to find out the cause? Thanks.

[   62.357688] megaraid_sas 0000:45:00.0: megasas_resume is called
[   62.357719] megaraid_sas 0000:45:00.0: Waiting for FW to come to ready state
[  104.382571] megaraid_sas 0000:45:00.0: FW now in Ready state
[  104.382576] megaraid_sas 0000:45:00.0: 63 bit DMA mask and 63 bit
consistent mask
[  104.383350] megaraid_sas 0000:45:00.0: requested/available msix 33/33
[  104.383669] megaraid_sas 0000:45:00.0: Performance mode :Latency
[  104.383671] megaraid_sas 0000:45:00.0: FW supports sync cache        : Yes
[  104.383677] megaraid_sas 0000:45:00.0: megasas_disable_intr_fusion
is called outbound_intr_mask:0x40000009
[  104.550570] megaraid_sas 0000:45:00.0: FW provided
supportMaxExtLDs: 1       max_lds: 64
[  104.550574] megaraid_sas 0000:45:00.0: controller type       : MR(4096MB)
[  104.550575] megaraid_sas 0000:45:00.0: Online Controller Reset(OCR)
 : Enabled
[  104.550577] megaraid_sas 0000:45:00.0: Secure JBOD support   : Yes
[  104.550579] megaraid_sas 0000:45:00.0: NVMe passthru support : Yes
[  104.550581] megaraid_sas 0000:45:00.0: FW provided TM
TaskAbort/Reset timeout        : 6 secs/60 secs
[  104.550583] megaraid_sas 0000:45:00.0: JBOD sequence map support     : Yes
[  104.550585] megaraid_sas 0000:45:00.0: PCI Lane Margining support    : No
[  104.550999] megaraid_sas 0000:45:00.0: megasas_enable_intr_fusion
is called outbound_intr_mask:0x40000000

Chris
