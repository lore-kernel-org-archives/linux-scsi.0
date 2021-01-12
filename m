Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20382C4332E
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 09:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0A0E23100
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 09:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392656AbhALJfA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 04:35:00 -0500
Received: from comms.puri.sm ([159.203.221.185]:33640 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731123AbhALJe7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Jan 2021 04:34:59 -0500
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id 8BBC8DFDE2;
        Tue, 12 Jan 2021 01:33:49 -0800 (PST)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bBp79AYO0gXz; Tue, 12 Jan 2021 01:33:48 -0800 (PST)
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        stern@rowland.harvard.edu, bvanassche@acm.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: [PATCH v2 0/3] scsi: add runtime PM workaround for SD cardreaders
Date:   Tue, 12 Jan 2021 10:33:26 +0100
Message-Id: <20210112093329.3639-1-martin.kepplinger@puri.sm>
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

revision history
----------------
v2:
 * move module parameter to sd
 * add Documentation

v1:
https://lore.kernel.org/linux-scsi/20210111152029.28426-1-martin.kepplinger@puri.sm/T/#t



hi,

In short: there are SD cardreaders that send MEDIA_CHANGED on
runtime resume. We cannot use runtime PM with these devices as
I/O basically always fails. I'd like to discuss a way to fix this
or at least allow users to work around this problem:

For the full background, the discussion started in June 2020 here:
https://lore.kernel.org/linux-scsi/20200623111018.31954-1-martin.kepplinger@puri.sm/

and I sent the first of these patches in August, as a reference:
https://lore.kernel.org/linux-scsi/20200824190400.12339-1-martin.kepplinger@puri.sm/
so this is where I'm following up on.

I'm not sure whether maintaining an in-kernel quirk for specific devices
makes sense so here I suggest adding a userspace knob. This way there's at
least a chance to use runtime PM for sd cardreaders that send MEDIA_CHANGED.

I'd appreciate any feedback.

Martin Kepplinger (3):
  scsi: add expecting_media_change flag to error path
  scsi: sd: add ignore_resume_medium_changed disk setting
  scsi: sd: Documentation: describe ignore_resume_medium_changed

 Documentation/scsi/sd-parameters.rst | 14 ++++++++
 drivers/scsi/scsi_error.c            | 36 +++++++++++++++++---
 drivers/scsi/sd.c                    | 50 +++++++++++++++++++++++++++-
 drivers/scsi/sd.h                    |  1 +
 include/scsi/scsi_device.h           |  1 +
 5 files changed, 96 insertions(+), 6 deletions(-)

-- 
2.20.1

