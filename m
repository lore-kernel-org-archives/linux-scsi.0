Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1003C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 10:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbiKPKoe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Nov 2022 05:44:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236947AbiKPKoQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2022 05:44:16 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3808C3206A
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2022 02:32:15 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id ED586336EA;
        Wed, 16 Nov 2022 10:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1668594733; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NBaNkBYURTW/4a3dGoiUdV3W+HkyEj2e8+74XOvQCrM=;
        b=mm62x8p1XewJx6IrbpnA6Dc6Gncma8Jv4EEsc+nH0Qa+ZI8o72QLumMFPOpqUCaGnVkf0K
        zYJ4nyn/6CerbTZNNfLMIcJTxQmiq/51hnbUE62chFQhFilO15BUnJRpXIdQManxhahWLn
        eecEfbUcQ2Y+MxLxk/4oQIP7A8q0KT8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B1DEC13480;
        Wed, 16 Nov 2022 10:32:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ppVcKC28dGMJUgAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 16 Nov 2022 10:32:13 +0000
Message-ID: <0efc9faa6dd519d1d402a08dbedd5cd7ed0de4f5.camel@suse.com>
Subject: Re: [PATCH] scsi: alua: Fix alua_rtpg_queue()
From:   Martin Wilck <mwilck@suse.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Sachin Sant <sachinp@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>
Date:   Wed, 16 Nov 2022 11:32:12 +0100
In-Reply-To: <20221115224903.2325529-1-bvanassche@acm.org>
References: <20221115224903.2325529-1-bvanassche@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.0 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Bart,

On Tue, 2022-11-15 at 14:49 -0800, Bart Van Assche wrote:
> Modify alua_rtpg_queue() such that it only requests the caller to
> drop
> the sdev reference if necessary. This patch fixes a recently
> introduced
> regression.
>=20
> Cc: Sachin Sant <sachinp@linux.ibm.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Martin Wilck <mwilck@suse.com>
> Reported-by: Sachin Sant <sachinp@linux.ibm.com>
> Fixes: 0b25e17e9018 ("scsi: alua: Move a scsi_device_put() call out
> of alua_check_vpd()")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Is this complexity really necessary, just for calling
scsi_device_put()?=A00b25e17e9018 is supposed to avoid sleeping under=A0
&h->pg_lock. Have you considered simply not calling alua_rtpg_queue()
with this lock held? alua_rtpg_queue() accesses no data that is
protected by=A0&h->pg_lock (which is just h->pg, AFAIU).

Would it perhaps be sufficient to just make sure we keep a kref for the
pg struct in alua_check_vpd(), like the patch below (on mkp/queue,
meant as an alternative to 0b25e17e9018)?

Regards
Martin

From 04df5933239921e7e7ac00e9ec0558124b050a51 Mon Sep 17 00:00:00 2001
From: Martin Wilck <mwilck@suse.com>
Date: Wed, 16 Nov 2022 11:24:58 +0100
Subject: [PATCH] scsi: alua: alua_check_vpd: drop pg_lock before calling
 alua_rtpg_queue

Since commit f93ed747e2c7 ("scsi: core: Release SCSI devices synchronously"=
),
scsi_device_put() might sleep. Avoid calling it from alua_rtpg_queue()
with the pg_lock held. The lock only pretects h->pg, anyway. To avoid
the pg being freed under us, because of a race with another thread,
take a temporary reference. In alua_rtpg_queue(), verify that the pg
still belongs to the sdev being passed before actually queueing the RTPG.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 30 +++++++++++++++-------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/devi=
ce_handler/scsi_dh_alua.c
index 610a51538f03..905b49493e01 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -372,12 +372,13 @@ static int alua_check_vpd(struct scsi_device *sdev, s=
truct alua_dh_data *h,
 	if (pg_updated)
 		list_add_rcu(&h->node, &pg->dh_list);
 	spin_unlock_irqrestore(&pg->lock, flags);
-
-	alua_rtpg_queue(rcu_dereference_protected(h->pg,
-						  lockdep_is_held(&h->pg_lock)),
-			sdev, NULL, true);
 	spin_unlock(&h->pg_lock);
=20
+	if (kref_get_unless_zero(&pg->kref)) {
+		alua_rtpg_queue(pg, sdev, NULL, true);
+		kref_put(&pg->kref, release_port_group);
+	}
+
 	if (old_pg)
 		kref_put(&old_pg->kref, release_port_group);
=20
@@ -986,11 +987,22 @@ static bool alua_rtpg_queue(struct alua_port_group *p=
g,
 		force =3D true;
 	}
 	if (pg->rtpg_sdev =3D=3D NULL) {
-		pg->interval =3D 0;
-		pg->flags |=3D ALUA_PG_RUN_RTPG;
-		kref_get(&pg->kref);
-		pg->rtpg_sdev =3D sdev;
-		start_queue =3D 1;
+		struct alua_dh_data *h =3D sdev->handler_data;
+		struct alua_port_group *sdev_pg =3D NULL;
+
+		if (h) {
+			rcu_read_lock();
+			sdev_pg =3D rcu_dereference(h->pg);
+			rcu_read_unlock();
+		}
+
+		if (pg =3D=3D sdev_pg) {
+			pg->flags |=3D ALUA_PG_RUN_RTPG;
+			pg->interval =3D 0;
+			kref_get(&pg->kref);
+			pg->rtpg_sdev =3D sdev;
+			start_queue =3D 1;
+		}
 	} else if (!(pg->flags & ALUA_PG_RUN_RTPG) && force) {
 		pg->flags |=3D ALUA_PG_RUN_RTPG;
 		/* Do not queue if the worker is already running */
--=20
2.38.0


