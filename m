Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92060C33CAA
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 22:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B96B20718
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 22:21:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gsKez/Zw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbgAWWVL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 17:21:11 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33816 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgAWWVK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jan 2020 17:21:10 -0500
Received: by mail-pg1-f195.google.com with SMTP id r11so2109056pgf.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jan 2020 14:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=r5rkiRFTsN2YIwDJcW0g2ZGeGiQB95roqjWtqCRrMfs=;
        b=gsKez/ZwTjeVphvfW8hNhQSkNgpvKvdQVUllODwFWn1LnETKDNojPtmMj1dUvi0Vbs
         49yrlvXPqDSlAOnC4Ppbl5i8iLrIo4iLYm+Ijm/CwhcmQPdnpr2+ftUr40+fSd8BRDy9
         szEJcT/KXzxNuScK5j9TZJls2v9AFmGvAMdsnJzGb0M4Q/lhsoejyzVBrX4D6/VTMVw0
         mBejd6CjUYQrWdy+/Ykk4OAYDrhhFssl/NtOn4zSQWXjtXQQLfiwdsToDA4dLcyJQH1w
         RfRHhiGiBibeuIJzIf+uEcCPP2+YS4Fu+ttgquIVm2bGrgSoziMKvAj5v9BkBCAS4D2E
         Fkmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=r5rkiRFTsN2YIwDJcW0g2ZGeGiQB95roqjWtqCRrMfs=;
        b=deZ1epsTY7T2d1zOU27R2MVVk/rfxpBEdQtv9H+R0mBTEuUgwNXSoZRlRk7P1vBcR+
         cibMV6gxQ6Nd9fUhzPWZgN3Fxv+Fm5zC+U7LGYg0Sm9Ae8zSiRgshz9jbZ5UO2ufb2e+
         oxcGgWpFitQo9TFRCTYARRvQUTAloLj8V9F3wXWk7oHYNlAkq0V5RxMbbDovZ7jtKflY
         c2gXY+i9Sme/4c6KJiKmAeyDhlZflo4oNV4W64gqzy36/e+g2rcfqtMUPTrueZmyPmbp
         0sEcaihe2TguPEI7qWRHmpTTELmnfCaqydRCJ9Rha098qZi9N+L4mC2BtDnF9cr+e6a4
         THEQ==
X-Gm-Message-State: APjAAAW0y8O1Ke4Ue990x3ndMcFoktGLb+TSh8bEWe9QS+GjqOpU+C+N
        SDxMoWDrmQuPrY+0Z47XLWrGNEHs
X-Google-Smtp-Source: APXvYqzyWlk5SPinyaOe4F+i61ZCZO6dxSVFUlhlh0fFiH5p055uRBGIDVV0htn6pXF0+IfNKYvKTw==
X-Received: by 2002:a63:2901:: with SMTP id p1mr591204pgp.396.1579818070085;
        Thu, 23 Jan 2020 14:21:10 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g8sm3616660pfh.43.2020.01.23.14.21.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 23 Jan 2020 14:21:09 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 0/3] scsi: add attribute to set lun queue depth on all luns on shost
Date:   Thu, 23 Jan 2020 14:20:59 -0800
Message-Id: <20200123222102.23383-1-jsmart2021@gmail.com>
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

-- james

James Smart (3):
  scsi: refactor sdev lun queue depth setting via sysfs
  scsi: add shost helper to set max queue depth on all of its devices
  scsi: add shost attribute to set max queue depth on all devices on the
    shost

 drivers/scsi/scsi.c        | 54 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_priv.h   |  1 +
 drivers/scsi/scsi_sysfs.c  | 27 +++++++++++++++++------
 include/scsi/scsi_device.h |  1 +
 4 files changed, 77 insertions(+), 6 deletions(-)

-- 
2.13.7

