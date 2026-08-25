Received: from mail-vs1-f99.google.com (mail-vs1-f99.google.com [209.85.217.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5508D48A8B8
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 15:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672697; cv=none; b=li8oINHXepu++rL6dut5icdTwTpSyC50u+N3wshHgqn9KgxSimxOTlbWjrxHZnzQXPIzIhlErt2tJKzQBOknpkMs6Li6FKUoochcy0oOzIS5OccEd0HxSM1aynJWEZTSTkgM59TI5AjkpEIvtIi/EqZUs3H2yO0tW7SjyU6jOSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672697; c=relaxed/simple;
	bh=M2ZY7hh2ZK24VogBMRBrVQ/j9y11CeCKlJJS5p9xFOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ovp/P1r3mpnEYKccOv/0yfkGc8w75YpRrMTfBhiar9eLWj9yPtTqcHLUItzwHnygStj8hz+YLWxzDf1naiOMtqhAfdho5w9FeUKcqDeCjVroqI/7eB0pXo1GFomMbZic0Hr2J2PD17xIlpJ6UugksA+ba9TW25iNyQAgta4t6QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=PiX/6DtQ; arc=none smtp.client-ip=209.85.217.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="PiX/6DtQ"
Received: by mail-vs1-f99.google.com with SMTP id ada2fe7eead31-77be71b5e8bso1205147137.2
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:44:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787672695; x=1788277495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FXziSY15FJrJQUwEzZgTQ87eLt0U5fihuwM19JgwOfQ=;
        b=DJDiEbAHPWWiWFXi/1KEQlq1W/FLZSeItqQgBeBCFFpERPh5DWsUPf0z6b3t44aMiX
         IkNoCK49d3gV5GTzZwquIeXEox1dbPOHR6ZYTb/XeREBR+5sBZZRfAHPBsmwbZRj9I8y
         xg9PXKa1iZAHjfTi9WsjYnJbfGoYubSTi1CHz+cYyA2c+RA0/JiCrcNLm9TJMTvXuMtK
         9nL8lMd7g/6KpLbw5Pz7zSsKGDWn50QAzJyCD+Wh5cx2dZf54x2qxYEAIAX8lqhIJG2j
         dQO4OZybp9x4BScuGvTOKi0zIEfa/riwyjt5dPaQkLDie0j++kFHMnGCBpy+hjKBlkBq
         NeNQ==
X-Gm-Message-State: AFuF++nMKl6NBAkTxCscPOZbiCUTyTapp1gvlq95w4iQxVPhuoYPK1MC
	eXsbHet0lOIr0TmGAf45gb6iJueFE6qonexhr4vRm4OQc87COKJe1bnau3BXRfac/xQ4e+pwZSG
	fVuW7o6n3b/Z6aJ6lcwp5MCKpuP9PrGGCP3kRVenbJ/88tL6TAIkIpdJogrzaXhcBNTAlSJJ+rs
	BU1Dt1wpytGtAIzMOt574QCyNb0GHDMRrZN1Ax8MVWeZo402QKPpNouFIu4szD/2QCPCajkD8AP
	mn7zfneo07oDQA0CcOfE0bS
X-Gm-Gg: AR+sD13P8+KO4F86zzC6E+W/syyLvRriM6YoyTzeve1QjPQ+AkmQXwCjCk3Jp7Lm+4E
	QTwSnOUr94lDpbqH04ludyTI/T5FHBAHQgFL+oGKz3CNn+lGV0JUdP5ZhErQ3agEvF9FbAcpVq8
	1/CysR6wj2jGCwkpclyeMVl83Qn1tb/ZqouZyUK/Xc/O5oZTJKy+d/MNMqGp3k1H1H7elKwdA8Z
	k4g51qx2hDONuU6dTrezP6NWAtT7iIikxrsrFNIjKYS6rSabrAvRPzhC9SZXLds16c7H/qxR3ku
	juDMBLW5PsUCyM4AYnGfC/KaB0rSwsoNYnQrfCX46/GY3niHdnUsc9k/J1QinVWGecqsSHlq25S
	c/OiGmk/C9mKyukqxo5p9o4ctkCFzZIRNIkyOGelydFIy+PP8dpuqRzSAgLU3HUKkWxRDtoLgWO
	7W5bz6ipkO/TA2jooxSe+GWnKKI1WxhuaC1SQnxqI/TME5zQ==
X-Received: by 2002:a05:6102:504c:b0:778:30ee:f44b with SMTP id ada2fe7eead31-77bd3c8a73dmr8346215137.13.1787672694960;
        Tue, 25 Aug 2026 08:44:54 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-121.dlp.protect.broadcom.com. [144.49.247.121])
        by smtp-relay.gmail.com with ESMTPS id a1e0cc1a2514c-97c833e4350sm761097241.5.2026.08.25.08.44.54
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 08:44:54 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c85798977dcso8460843a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787672694; x=1788277494; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FXziSY15FJrJQUwEzZgTQ87eLt0U5fihuwM19JgwOfQ=;
        b=PiX/6DtQwD4OXLsHQ1CNOaxRSIdy+hZWtNNyJJVvnb9m1fWlJGJ5JCTuqMeRKFVJbq
         uIsLzd9FEvw5R5Q13Grpcg5lACrjY14KwfpVmy8sDgrX2XrS/Dai5r35RQNNBgSuj3Ty
         xPcgkV34tE4ezP2Y0C+abYYpPW9BB/UhDMsdY=
X-Received: by 2002:a05:6a21:7d02:b0:3cd:a1e2:f238 with SMTP id adf61e73a8af0-3cda1e303bbmr4340101637.16.1787672693856;
        Tue, 25 Aug 2026 08:44:53 -0700 (PDT)
X-Received: by 2002:a05:6a21:7d02:b0:3cd:a1e2:f238 with SMTP id adf61e73a8af0-3cda1e303bbmr4339995637.16.1787672693339;
        Tue, 25 Aug 2026 08:44:53 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f9209fafsm63445311eec.23.2026.08.25.08.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:44:52 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	sumit.saxena@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH v2 10/17] mpi3mr: Fix out-of-bounds read in SAS topology change events
Date: Wed, 26 Aug 2026 02:34:04 +0530
Message-ID: <20260825210411.301535-11-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The number of entries in a SAS topology change event is used to walk
the entry array without being compared against the amount of event data
that was received, so the walk can run past the end of the buffer.

Work out how many entries the payload can hold and skip the event if it
claims more.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
v2:
 - Cached num_entries in a local variable before bounds check and used it
   for the loop condition to prevent re-fetching from DMA memory (TOCTOU).
 drivers/scsi/mpi3mr/mpi3mr_os.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 9aeec6146acb..6a80b784200b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2827,12 +2827,28 @@ static void mpi3mr_sastopochg_evt_th(struct mpi3mr_ioc *mrioc,
 	struct mpi3_event_data_sas_topology_change_list *topo_evt =
 	    (struct mpi3_event_data_sas_topology_change_list *)event_reply->event_data;
 	int i;
-	u16 handle;
-	u8 reason_code;
+	u16 handle, avail_len;
+	u8 reason_code, max_entries, num_entries;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data = NULL;
 
-	for (i = 0; i < topo_evt->num_entries; i++) {
+	avail_len = event_reply->event_data_length * 4;
+	if (avail_len < offsetof(struct mpi3_event_data_sas_topology_change_list, phy_entry)) {
+		ioc_err(mrioc, "SAS topology event: event data too small (%u bytes)\n",
+			avail_len);
+		return;
+	}
+	max_entries = (avail_len -
+		      offsetof(struct mpi3_event_data_sas_topology_change_list, phy_entry)) /
+		      sizeof(struct mpi3_event_sas_topo_phy_entry);
+	num_entries = topo_evt->num_entries;
+	if (num_entries > max_entries) {
+		ioc_err(mrioc, "SAS topology event: num_entries(%d) exceeds max(%d)\n",
+			num_entries, max_entries);
+		return;
+	}
+
+	for (i = 0; i < num_entries; i++) {
 		handle = le16_to_cpu(topo_evt->phy_entry[i].attached_dev_handle);
 		if (!handle)
 			continue;
-- 
2.52.0

