Return-Path: <SRS0=ZYS2=Z6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4044CC43603
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Dec 2019 04:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DF3520828
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Dec 2019 04:59:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="MPkLeMGF";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="MPkLeMGF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfLHE7y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Dec 2019 23:59:54 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57782 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726425AbfLHE7y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Dec 2019 23:59:54 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id C980E8EE111;
        Sat,  7 Dec 2019 20:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1575781193;
        bh=9s/vfuX5tttdahA0XSA9ZqHD4uf4SZXOXeg/oBdGVq0=;
        h=Subject:From:To:Cc:Date:From;
        b=MPkLeMGFgDGMVgI8yJw3kjW5yf6EJU886uWLP7xwg/xzbegsSDEActOLiEWVNN0TO
         QJWUnsVovDF1hpLUSAE8nwhDRCFxIWh1z4MLWJGUoTcny0OT7l74f3jcQLFkupcbCE
         wObmZ1pxxgkh2R5Z6z2k7BdcsAKHSAb0MlbAhlwo=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Gx-eJyIAAO32; Sat,  7 Dec 2019 20:59:53 -0800 (PST)
Received: from jarvis.lan (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id EA6EC8EE109;
        Sat,  7 Dec 2019 20:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1575781193;
        bh=9s/vfuX5tttdahA0XSA9ZqHD4uf4SZXOXeg/oBdGVq0=;
        h=Subject:From:To:Cc:Date:From;
        b=MPkLeMGFgDGMVgI8yJw3kjW5yf6EJU886uWLP7xwg/xzbegsSDEActOLiEWVNN0TO
         QJWUnsVovDF1hpLUSAE8nwhDRCFxIWh1z4MLWJGUoTcny0OT7l74f3jcQLFkupcbCE
         wObmZ1pxxgkh2R5Z6z2k7BdcsAKHSAb0MlbAhlwo=
Message-ID: <1575781191.14069.3.camel@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 5.4+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 07 Dec 2019 20:59:51 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

11 patches, all in drivers (no core changes) that are either minor
cleanups or small fixes.  They were late arriving, but still safe for
-rc1.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Colin Ian King (1):
      scsi: pm80xx: fix logic to break out of loop when register value is 2 or 3

Damien Le Moal (1):
      scsi: sd_zbc: Improve report zones error printout

Gabriel Krisman Bertazi (1):
      scsi: MAINTAINERS: Add the linux-scsi mailing list to the ISCSI entry

Huacai Chen (1):
      scsi: qla2xxx: Fix qla2x00_request_irqs() for MSI

James Smart (1):
      scsi: lpfc: size cpu map by last cpu id set

John Garry (1):
      scsi: scsi_transport_sas: Fix memory leak when removing devices

Martin Wilck (2):
      scsi: qla2xxx: unregister ports after GPN_FT failure
      scsi: qla2xxx: fix rports not being mark as lost in sync fabric scan

Saurav Girepunje (1):
      scsi: ibmvscsi_tgt: Remove unneeded variable rc

YueHaibing (2):
      scsi: megaraid_sas: Make poll_aen_lock static
      scsi: pm80xx: Remove unused include of linux/version.h

And the diffstat:

MAINTAINERS                               |  1 +
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c  |  3 +--
 drivers/scsi/lpfc/lpfc_init.c             |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |  2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c          |  3 +--
 drivers/scsi/qla2xxx/qla_gs.c             | 16 ++++++++++++++--
 drivers/scsi/qla2xxx/qla_init.c           |  6 +++---
 drivers/scsi/qla2xxx/qla_isr.c            |  6 +++---
 drivers/scsi/scsi_transport_sas.c         |  9 +--------
 drivers/scsi/sd.c                         |  9 ++-------
 drivers/scsi/sd.h                         |  3 +++
 drivers/scsi/sd_zbc.c                     |  8 +++++---
 12 files changed, 36 insertions(+), 32 deletions(-)

James

