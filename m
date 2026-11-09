Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794255101;
	b=ngVDslMyk9713bhYOUG3mbAVAGzZqZh5zY5iJjuakKEQ1LKmLQD1ElzUJX/Co75vj0mf
	 qUiLyeb6sKN1Ayjy9kQN3O+VeHocVF6Q1ti2/Ivd+b6lWOPAbaee9IPTbjRqVJy+kJK0I
	 ZmGTo8RwZFDEjaeU9E23ZacAgiy95Gf0J9ASiVvzsELjkSD7oW9YiKT86q8mHPVwVnfs9
	 So+Dwfn5NFNf79ALpakFbhKo26+4msH8W4+S3T9oO7Lz8FEUAeWtRGAYW3y2z4JvhCFpi
	 CBNwh8VC/M5m1QtInYlDdDxkwoB4+GkxZPr0Eaeoxm74r2iLTr+esAfP+rrlprK0RmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794255101;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=FGfAVWgpi2aN94+rs+NNa1Po8AGQSVyIerXI/e4BStI=;
	b=VqcP3trD0u9r4dRQOtt7dhMBKs/+YxH2aKNnE9a514/vZHWt5EjQNRsxEx1JO+ykjepU
	 sDOFlc8QLhAlyvOiRQmR7YmsHjmDd3Ndj3BpQMpdy0yrwBqzXz/xKpA5zoXV7zsFDAyUn
	 yR8nbuxN8MyqcJXBl4bQNM85hoH45LhyU5t+Qluhikd8buehZA/xRu3Zl65Zy3+ZkK4LB
	 FG9GDpejKoaCQQpxFvBzzyF1IpIbkRR5X1HUuJGU87/TI6AmwPVCX8Rzelb9IKAHUBiII
	 kqZnrQZu71DBKMdt4uLS+ZPZRsWDwy9UFCx3X7JHk1pJUWRoxLkzQFsgD1Gx5o52Ycg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=I1vNRjIe;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FA2606A337
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 20:11:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47FA2606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=I1vNRjIe
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794255100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FGfAVWgpi2aN94+rs+NNa1Po8AGQSVyIerXI/e4BStI=;
	b=I1vNRjIeB1UdVgRGhQfYM4jjirJAgQharfSHpRQvB/ciP3iGfp5DIDjVUyFOBTbyy88y/7
	4G/hLqYYxeaIgjSy36MeWBA/DbrdR6Xe6U7Vszz1l+gCUUvglGhc7N7+CWuFJVRYIZ2GCT
	j8SeVH5Loo4+THIJ0vYuGZiL7YtUE0w=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-636-UFTivgPGO7erJxWaWnQWWQ-1; Mon,
 09 Nov 2026 15:11:34 -0500
X-MC-Unique: UFTivgPGO7erJxWaWnQWWQ-1
X-Mimecast-MFC-AGG-ID: UFTivgPGO7erJxWaWnQWWQ_1794255092
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5886E180060F;
	Mon,  9 Nov 2026 20:11:32 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A8E5C18004D2;
	Mon,  9 Nov 2026 20:11:30 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: "Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Martin Wilck <mwilck@suse.com>,
	Hannes Reinecke <hare@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] scsi: scsi_dh_alua: set handler_data before alua_initialize()
Date: Mon,  9 Nov 2026 15:11:20 -0500
Message-ID: <20261109201120.1067815-1-loberman@redhat.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Since commit 50759b881e1d ("scsi: device_handler: alua: Call
scsi_device_put() from non-atomic context"), alua_rtpg_queue() only
queues an RTPG when sdev->handler_data points at an alua_dh_data whose
port group matches:

	struct alua_dh_data *h = sdev->handler_data;
	...
	if (h && rcu_dereference(h->pg) == pg) {

However alua_bus_attach() only assigns sdev->handler_data after
alua_initialize() returns, and alua_initialize() -> alua_check_vpd()
is where the initial RTPG is queued. At that point handler_data is
still NULL, so the initial RTPG is silently dropped: no RTPG is sent,
nothing is logged, and sdev->access_state keeps its zeroed default of
active/optimized for every path.

With dm-multipath this goes unnoticed, as pg_init calls
scsi_dh_activate() once the map is loaded, which queues an RTPG after
handler_data is set, and multipathd's alua prioritizer issues its own
RTPG from userspace. Anything relying on sdev->access_state without a
subsequent activate (sysfs access_state/preferred_path, native SCSI
multipath path selection) sees every path as active/optimized until a
Unit Attention or rescan triggers an RTPG.

Seen on an HP P2000 G3 FC array (implicit ALUA, two port groups, four
paths per LUN) with dm-multipath not in use: sg_rtpg reports port group
0 active/non-optimized and port group 1 active/optimized, but
/sys/class/scsi_device/H:C:T:L/device/access_state reads
active/optimized on all four paths after boot, and no
"alua: port group XX state ..." message is logged. Writing "activate"
to dh_state sends the RTPG and corrects access_state.

Kernels without commit 50759b881e1d queue the attach-time RTPG
unconditionally and are not affected.

Fix by assigning sdev->handler_data before calling alua_initialize(),
and clearing it again on failure. sdev->handler is only set once
scsi_dh_handler_attach() sees ->attach() succeed, so no handler
callback can observe the partially initialised alua_dh_data. On the
failure paths of alua_initialize(), h has not been added to a port
group and no RTPG has been queued, so freeing it is unchanged.

Fixes: 50759b881e1d ("scsi: device_handler: alua: Call scsi_device_put() from non-atomic context")
Cc: stable@vger.kernel.org
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---

Notes:
    Tested on an HP P2000 G3 FC array (30 LUNs, 4 paths each): with this
    patch the "alua: port group 00 state N ..." messages are logged during
    boot and access_state shows two active/optimized and two
    active/non-optimized paths per LUN without any manual activate.
    Without it, all paths read active/optimized until an RTPG is triggered.
    
    I found this while testing John Garry's native SCSI multipath series
    (v9) on an HP P2000 G3 FC array (30 LUNs, 4 paths each, dm-multipath
    not in use). Native multipath uses sdev->access_state for path
    selection, and every path showed active/optimized, although sg_rtpg
    and dm-multipath (alua prio 50/10) both report port group 0 as
    active/non-optimized. No "alua: port group XX state ..." message was
    logged at boot. Writing "activate" to dh_state corrected access_state,
    which pointed at the attach-time RTPG never being queued.
    
    With this patch, the port group state messages are logged during boot
    and access_state shows two active/optimized and two
    active/non-optimized paths per LUN without any manual activate.
    
    This fix is independent of the native multipath series. It affects any
    user of access_state/preferred_path, and ALUA prep_fn fast-fail, on
    kernels with 50759b881e1d where nothing calls scsi_dh_activate()
    after attach.
    
    v9 series: https://lore.kernel.org/linux-scsi/20261108204733.557995-1-
    john.garry@linux.dev/

 drivers/scsi/device_handler/scsi_dh_alua.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 87ac0a6d63e5..84ff3aed2c46 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1233,13 +1233,20 @@ static int alua_bus_attach(struct scsi_device *sdev)
 	INIT_LIST_HEAD(&h->node);
 
 	mutex_init(&h->init_mutex);
+	/*
+	 * alua_rtpg_queue() only queues an RTPG when sdev->handler_data
+	 * points at this alua_dh_data, so set it before alua_initialize()
+	 * otherwise the initial RTPG issued from alua_check_vpd() is
+	 * silently dropped and sdev->access_state is never populated.
+	 */
+	sdev->handler_data = h;
 	err = alua_initialize(sdev, h);
 	if (err != SCSI_DH_OK && err != SCSI_DH_DEV_OFFLINED)
 		goto failed;
 
-	sdev->handler_data = h;
 	return SCSI_DH_OK;
 failed:
+	sdev->handler_data = NULL;
 	kfree(h);
 	return err;
 }
-- 
2.56.0

