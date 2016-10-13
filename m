From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 0/2] Locking issue in libiscsi and be2iscsi
Date: Thu, 13 Oct 2016 12:08:47 +0530
Message-ID: <1476340729-8569-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:35309 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752183AbcJMGrC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2016 02:47:02 -0400
Received: by mail-qk0-f172.google.com with SMTP id z190so69859277qkc.2
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 23:46:44 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

These patches are being resent with required changes as per comments
for [PATCH 02/28] be2iscsi: Replace _bh with _irqsave/irqrestore

In IO handling path, there is no spin_lock taken with IRQs disabled
when calling into libiscsi, so no issues were found with use of
spin_lock_bh/spin_unlock_bh except for one in iscsi_eh_cmd_timeout.

This needs to be applied on top 11.2.0.0 of be2iscsi committed in
4.9/scsi-queue.

Jitendra Bhivare (2):
  libiscsi: Fix locking in __iscsi_conn_send_pdu
  be2iscsi: Replace _bh with _irqsave/irqrestore

 drivers/scsi/be2iscsi/be_main.c | 37 +++++++++++++++++++++++--------------
 drivers/scsi/libiscsi.c         |  4 ++--
 2 files changed, 25 insertions(+), 16 deletions(-)

-- 
2.7.4
