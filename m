Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B9DC2D0CE
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 23:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CED12071A
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 23:01:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Il7/DS7C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbgAXXBX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 18:01:23 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41762 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729346AbgAXXBX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2020 18:01:23 -0500
Received: by mail-pf1-f193.google.com with SMTP id w62so1809551pfw.8
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2020 15:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7EQvuat1eILlCJhLAdpVXQTuZ3gQRm6GVJQnW/cUndA=;
        b=Il7/DS7CZuhDWVtOwCIKtGLB9y9HXl2AsZvJtn/oFeHBfm2k2BW21jg4xWWGMn35uN
         CqpmQov8TP+ybbplB7Yp3Iq2bpdbBKtPQWZDF0pQQKZ/F04twG8aiIwHCcEb7fmGGGqJ
         dEK55TfbfC4ShK5+oLAVELcZmsfJMOgqvIBd7krSEe7AnrFBU/eQX+Ektc8OMgtPbE9k
         Fl9ESGHgKbWNaveJixP7FnXNiNXwbo/nifhcVp94bgZxmQPY3+4FwAduCR6DqrprbERy
         s1BwP2d+w45t+EvUpm7fnpUw4z6swVq6reWmOYxGT15V2qL//RbJuAThmp8Z8Wv5gJQr
         kMHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7EQvuat1eILlCJhLAdpVXQTuZ3gQRm6GVJQnW/cUndA=;
        b=sC2asn+JVo5tozD9zhqqeA0CNeefLajUwdnFZbgWQQvAper7lcbNBwPSs791tbAeIc
         nHqR+Dr/HzvKZeC5lge3+lyNMwN2RXGSXPOx15ezl0HDNfNLRQxZBzf7WNF25e5KY8qz
         z2vbPNQMuMp+uYH2rBWpSVLknWAtnN4M+UHfM1SLfJ+QS8Hjd8KIdKCpvmDQB1Vl9cuu
         ASR11lM7jQGNf/3yyelh3opmQRrxjGsxBLWPW2ESdJsd9TTBTncb71uBCf4539iz9lQZ
         7wZix22rj99VKruKuWjiJxxDr+cmLGAYoyyZfdvYUmmGv+wJUY9mZspQuq4HhlhqFtVH
         PA9g==
X-Gm-Message-State: APjAAAWL2MSftQiglvrLACS8oSU5wMqfzmfkbUyfZXGkV/lfzUbPk907
        aX6QA/2r4ml7iUfx0EhR+iqZvmPy
X-Google-Smtp-Source: APXvYqybD8U2BfYZpw84V86v6mkufGjoTJN1V5AA6FXkE9FAtCzDqA3XEzDqeJnnm9yHX/v96Vfm4g==
X-Received: by 2002:a63:9d0f:: with SMTP id i15mr6562766pgd.240.1579906882339;
        Fri, 24 Jan 2020 15:01:22 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d4sm7406784pjz.12.2020.01.24.15.01.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 Jan 2020 15:01:21 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     bvanassche@acm.org, James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 0/3] scsi: add attribute to set lun queue depth on all luns on shost
Date:   Fri, 24 Jan 2020 15:01:12 -0800
Message-Id: <20200124230115.14562-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There has been a desire to set the lun queue depth on all luns on an
shost. Today that is done by an external script looping through
discovered sdevs and set an sdev attribute. The desire is to have a
single shost attribute that performs this work removing the requirement
for scripting.

This patch:
- Refactors the existing sdev change max queue depth attribute so the
  meat of it becomes a service routine.
- Creates a shost helper routine, lldd callable, which cycles though
  all sdevs on the shost and changes their max queue depth. Uses the
  new service routine.
- Adds a new shost attribute which calls the new shost helper routine.

v2:
Reworked the patch with recommendations on error returns and breaking into
smaller patches. I also had a request to make the shost change routine to
be lldd callable. So switched up how that was implemented as well.

v3:
Revert use of -ENOTSUPP. Use -EINVAL or -ENXIO instead.
Clean up spacing and unnecessary parens.
Use kstrtouint
Specify attribute permissions in octl

-- james


James Smart (3):
  scsi: refactor sdev lun queue depth setting via sysfs
  scsi: add shost helper to set max queue depth on all of its devices
  scsi: add shost attribute to set max queue depth on all devices on the
    shost

 drivers/scsi/scsi.c        | 54 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_priv.h   |  1 +
 drivers/scsi/scsi_sysfs.c  | 28 +++++++++++++++++++-----
 include/scsi/scsi_device.h |  1 +
 4 files changed, 79 insertions(+), 5 deletions(-)

-- 
2.13.7

