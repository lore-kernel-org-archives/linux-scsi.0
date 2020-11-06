Return-Path: <SRS0=4aQo=EM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EFD0C55178
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Nov 2020 22:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6590206C1
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Nov 2020 22:26:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="scKvWdzI";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="scKvWdzI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgKFW0H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Nov 2020 17:26:07 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:48732 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728482AbgKFW0H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Nov 2020 17:26:07 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 8B02712803E5;
        Fri,  6 Nov 2020 14:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1604701566;
        bh=UOouGRZVfPPrkFoBKImXA/neRmAkbXmdMwxFyJVL7u4=;
        h=Message-ID:Subject:From:To:Date:From;
        b=scKvWdzIjPLsqAHIxEaCm602YQgcETDIATJ+mvW9BgANqr+3BWPHEVnwWkLflkXUz
         yqCOMAk2tDl1Gt2R016u4KxbQplzoUhOorEPFZL7+W0e1yt7x4h+3tJiell5Jc4E/2
         BQt8XBAF/9UTssqdw3JT9N+AW7SKsscpitxnymio=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Dy0DS38CLrMq; Fri,  6 Nov 2020 14:26:06 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 2EFAD1280386;
        Fri,  6 Nov 2020 14:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1604701566;
        bh=UOouGRZVfPPrkFoBKImXA/neRmAkbXmdMwxFyJVL7u4=;
        h=Message-ID:Subject:From:To:Date:From;
        b=scKvWdzIjPLsqAHIxEaCm602YQgcETDIATJ+mvW9BgANqr+3BWPHEVnwWkLflkXUz
         yqCOMAk2tDl1Gt2R016u4KxbQplzoUhOorEPFZL7+W0e1yt7x4h+3tJiell5Jc4E/2
         BQt8XBAF/9UTssqdw3JT9N+AW7SKsscpitxnymio=
Message-ID: <8a60c7bd72f908a637f0f9e60cce7ab3a047e343.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.10-rc2
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 06 Nov 2020 14:26:05 -0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Three driver fixes.  Two (alua and hpsa) are in hard to trigger
attach/detach situations but the mp3sas one involves a polled to
interrupt switch over that could trigger in any high IOPS situation.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Hannes Reinecke (1):
      scsi: scsi_dh_alua: Avoid crash during alua_bus_detach()

Keita Suzuki (1):
      scsi: hpsa: Fix memory leak in hpsa_init_one()

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix timeouts observed while reenabling IRQ

And the diffstat:

 drivers/scsi/device_handler/scsi_dh_alua.c | 9 +++++----
 drivers/scsi/hpsa.c                        | 4 +++-
 drivers/scsi/mpt3sas/mpt3sas_base.c        | 7 +++++++
 3 files changed, 15 insertions(+), 5 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index f32da0ca529e..308bda2e9c00 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -658,8 +658,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 					rcu_read_lock();
 					list_for_each_entry_rcu(h,
 						&tmp_pg->dh_list, node) {
-						/* h->sdev should always be valid */
-						BUG_ON(!h->sdev);
+						if (!h->sdev)
+							continue;
 						h->sdev->access_state = desc[0];
 					}
 					rcu_read_unlock();
@@ -705,7 +705,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			pg->expiry = 0;
 			rcu_read_lock();
 			list_for_each_entry_rcu(h, &pg->dh_list, node) {
-				BUG_ON(!h->sdev);
+				if (!h->sdev)
+					continue;
 				h->sdev->access_state =
 					(pg->state & SCSI_ACCESS_STATE_MASK);
 				if (pg->pref)
@@ -1147,7 +1148,6 @@ static void alua_bus_detach(struct scsi_device *sdev)
 	spin_lock(&h->pg_lock);
 	pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
 	rcu_assign_pointer(h->pg, NULL);
-	h->sdev = NULL;
 	spin_unlock(&h->pg_lock);
 	if (pg) {
 		spin_lock_irq(&pg->lock);
@@ -1156,6 +1156,7 @@ static void alua_bus_detach(struct scsi_device *sdev)
 		kref_put(&pg->kref, release_port_group);
 	}
 	sdev->handler_data = NULL;
+	synchronize_rcu();
 	kfree(h);
 }
 
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 83ce4f11a589..8df70c92911d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8855,7 +8855,7 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* hook into SCSI subsystem */
 	rc = hpsa_scsi_add_host(h);
 	if (rc)
-		goto clean7; /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
+		goto clean8; /* lastlogicals, perf, sg, cmd, irq, shost, pci, lu, aer/h */
 
 	/* Monitor the controller for firmware lockups */
 	h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;
@@ -8870,6 +8870,8 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				HPSA_EVENT_MONITOR_INTERVAL);
 	return 0;
 
+clean8: /* lastlogicals, perf, sg, cmd, irq, shost, pci, lu, aer/h */
+	kfree(h->lastlogicals);
 clean7: /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
 	hpsa_free_performant_mode(h);
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 93230cd1982f..e4cc92bc4d94 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1740,6 +1740,13 @@ _base_irqpoll(struct irq_poll *irqpoll, int budget)
 		reply_q->irq_poll_scheduled = false;
 		reply_q->irq_line_enable = true;
 		enable_irq(reply_q->os_irq);
+		/*
+		 * Go for one more round of processing the
+		 * reply descriptor post queue incase if HBA
+		 * Firmware has posted some reply descriptors
+		 * while reenabling the IRQ.
+		 */
+		_base_process_reply_queue(reply_q);
 	}
 
 	return num_entries;

