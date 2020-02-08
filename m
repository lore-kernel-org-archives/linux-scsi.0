Return-Path: <SRS0=yjur=34=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB6AC35242
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Feb 2020 19:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72F952253D
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Feb 2020 19:39:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="CC/EzITl";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="CC/EzITl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbgBHTjf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Feb 2020 14:39:35 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44578 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727471AbgBHTjf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Feb 2020 14:39:35 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 8F8EC8EE07B;
        Sat,  8 Feb 2020 11:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1581190774;
        bh=jKK0QTtjZCZO5mlfdM04hkHTfc78SwOLsTEq3kqfgiE=;
        h=Subject:From:To:Cc:Date:From;
        b=CC/EzITliRqvuhQsFnB5HcncxwC5Zg4ODfkbqYVa17xb8WpyEzALxT1fHVFqel8du
         6FzBOlX5WU+mpnlcvU7L8JCU7AtK0bwvdb1VxVO2fbYF69hd91cOC/B6Do7J1L+pbB
         5aQI44tmDJxYrPNcyBj2zRy/aRbiQfx0jOsRC2b0=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gbZUqiU6eH4C; Sat,  8 Feb 2020 11:39:34 -0800 (PST)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 24ED28EE079;
        Sat,  8 Feb 2020 11:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1581190774;
        bh=jKK0QTtjZCZO5mlfdM04hkHTfc78SwOLsTEq3kqfgiE=;
        h=Subject:From:To:Cc:Date:From;
        b=CC/EzITliRqvuhQsFnB5HcncxwC5Zg4ODfkbqYVa17xb8WpyEzALxT1fHVFqel8du
         6FzBOlX5WU+mpnlcvU7L8JCU7AtK0bwvdb1VxVO2fbYF69hd91cOC/B6Do7J1L+pbB
         5aQI44tmDJxYrPNcyBj2zRy/aRbiQfx0jOsRC2b0=
Message-ID: <1581190772.31918.4.camel@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 5.5+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 08 Feb 2020 11:39:32 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Five small patches, all in drivers or doc, which missed the initial
pull request. The qla2xxx and megaraid_sas are actual fixes and the
rest are spelling and doc changes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Arun Easi (1):
      scsi: qla2xxx: Fix unbound NVME response length

Bean Huo (1):
      scsi: MAINTAINERS: ufs: remove pedrom.sousa@synopsys.com

Colin Ian King (2):
      scsi: ufs: fix spelling mistake "initilized" -> "initialized"
      scsi: pm80xx: fix spelling mistake "to" -> "too"

Hannes Reinecke (1):
      scsi: megaraid_sas: fixup MSIx interrupt setup during resume


And the diffstat:

 MAINTAINERS                               |  1 -
 drivers/scsi/megaraid/megaraid_sas_base.c | 20 +++++++++-----------
 drivers/scsi/pm8001/pm80xx_hwi.c          |  2 +-
 drivers/scsi/qla2xxx/qla_dbg.c            |  6 ------
 drivers/scsi/qla2xxx/qla_dbg.h            |  6 ++++++
 drivers/scsi/qla2xxx/qla_isr.c            | 12 ++++++++++++
 drivers/scsi/ufs/ufs.h                    |  2 +-
 7 files changed, 29 insertions(+), 20 deletions(-)

James

