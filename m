Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB37C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 15:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D62DB20793
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 15:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406420AbgLKO6T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Dec 2020 09:58:19 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:64044 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406401AbgLKO6O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Dec 2020 09:58:14 -0500
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20201211145730epoutp02e3b9f9743a9351e8ecd598e6d14fe2e5~PsWelEOv21689316893epoutp02k
        for <linux-scsi@vger.kernel.org>; Fri, 11 Dec 2020 14:57:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20201211145730epoutp02e3b9f9743a9351e8ecd598e6d14fe2e5~PsWelEOv21689316893epoutp02k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1607698650;
        bh=R5FcDS/TS17GZcZwvPhvmqWTKtggijaSfKGhePCYnr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rkFvPXtPj7TrGoz33ISud3AqLVKNron7cU2pR82daTE3Mo8zGQ4R+yqtQKdcHJdSM
         AMpjUtv04PB8b1ygvztSfaXPayWupWyF6CGlkMu1g0XYaf9TkEdvKGo3RQgy0i8jIW
         4N8oUzufesiikJzp2IePGXWVaO/3iHFZkAYVEQeo=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20201211145729epcas5p32c66a0996a1c53b24668c1be9d615611~PsWdpWNVp2218722187epcas5p35;
        Fri, 11 Dec 2020 14:57:29 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0E.00.50652.9D883DF5; Fri, 11 Dec 2020 23:57:29 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20201211135205epcas5p1f1696075e1354f0f4c7af04b950d514c~PrdW6fQb60154201542epcas5p1m;
        Fri, 11 Dec 2020 13:52:05 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201211135205epsmtrp2fe2f38d12e5212d5f5464f91ae3d27ce~PrdW5WhCB0569205692epsmtrp2S;
        Fri, 11 Dec 2020 13:52:05 +0000 (GMT)
X-AuditID: b6c32a4a-6b3ff7000000c5dc-24-5fd388d96153
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D5.71.08745.58973DF5; Fri, 11 Dec 2020 22:52:05 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20201211135202epsmtip26706456da2bdcb8021663f93a8476308~PrdTz_pmh2927029270epsmtip2H;
        Fri, 11 Dec 2020 13:52:02 +0000 (GMT)
From:   SelvaKumar S <selvakuma.s1@samsung.com>
To:     linux-nvme@lists.infradead.org
Cc:     kbusch@kernel.org, axboe@kernel.dk, damien.lemoal@wdc.com,
        Johannes.Thumshirn@wdc.com, hch@lst.de, sagi@grimberg.me,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        bvanassche@acm.org, mpatocka@redhat.com, hare@suse.de,
        dm-devel@redhat.com, snitzer@redhat.com, selvajove@gmail.com,
        nj.shetty@samsung.com, joshi.k@samsung.com,
        javier.gonz@samsung.com, SelvaKumar S <selvakuma.s1@samsung.com>
Subject: [RFC PATCH v3 2/2] nvme: add simple copy support
Date:   Fri, 11 Dec 2020 19:21:39 +0530
Message-Id: <20201211135139.49232-3-selvakuma.s1@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211135139.49232-1-selvakuma.s1@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0wTZxjH996dd9eykgORvaJzS5PpcLPIhtvLVFyyut00S7YRFkKywbme
        hQmla+lQt2hxY0LZUJg/YpFhCMFRfzBKB11piSlzhbpftCCipYFAySbR8mM4tCvO9lj0v8/7
        PJ8n3zxPXhqPLyOT6AJVCa9RcYVSUkx09CSv2zBc4c3deOymFJ0bOUKiE9N3cVR++A6GHLfr
        liF7Yy2GWs5dxtC4b45CYYMfQ5fv3yJRrfMqQI7rzyGv7TSJGpoDFKoaspLorGsRQzUVgxjq
        CDXgaOBYI44uTgUJNBocotDUQh+JvmybB68mst6BneyPxhGK/d3fRrDeX3Ws2VRJsu1NB9mu
        YT3JzgSuE2ywe5Bkqy0mwLZf+ZSdM69hD1+qwt6W5Ii3KPjCgk94TUpGnjjfXbmIqQ9t3mua
        byX0wC0zAJqGTBoc/y3HAER0PNMFYMD9sgGIH/AsgKNlnaTwmANw2GAgI1ZkwOlvXmrYACz/
        ZuahZZjspiIWyWyAV5vMRIQTGCkMtx4iIhLODOPQc282Ki1n0qFvsR6PMME8Ayd/MkVZwmyF
        s+FbQIh7Cp7y/BP1RUwGrLb4lpw42HdqIhqAP3A+/6EOjwRApkEEOxf6CGFYDmv1dbjAy+FN
        l4USOAnO3XYs7VMKJytPYALrAawOlgq8Dfbbw1jkSDiTDFttKUL5SXjcfRETcmPh16GJpVEJ
        tH47gQk3XQvdnS8J5dVwusdGCmUWmnoLhFvVADj4rx0/Cp42PrKN8ZFtjA+DzwDcBFbyam2R
        ktduUr+g4ktlWq5Iq1MpZR8WF5lB9Jeu32EFY6PTMifAaOAEkMalCZLQQW9uvETB7dvPa4pz
        NbpCXusEq2hC+oREuvDLB/GMkivh9/C8mtf838VoUZIe2+S50NC9RX1j+zrvAYVoJs19PDSz
        2i2t/1g/mHbh2TWnA/tZlrixKvh44ldvDr2/dYe8y+/Clu1tst4L71LJUSoI5cWUvqYjuQRv
        ieWkD1WfrTc2iRXZno78liMpoqy3qN7dhrt/1FzZXtlqk42hk4kqsrw/tJn++e8Vne8p+6mx
        DCL9szvv6pMbXR5caS+OIb+fv1RxLfuv4lDewPl02XdDxt1fOP58TNdvHW/L0r1jtTp8r6S/
        qK4508K8zuka07btS86QfzRlt1SF3jgwYnbZs+/74q4p4pozM4E1c8WkX5O6MqZ3Z1mKbuP5
        57upnizPnp6OnAAXuyt2bbtcSmjzudT1uEbL/Qec0lPFFAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsWy7bCSvG5r5eV4g8UnhC1W3+1ns5j24Sez
        RWv7NyaLve9ms1rsWTSJyWLl6qNMFo/vfGa3+Nt1j8ni6P+3bBaTDl1jtNh7S9vi8q45bBbz
        lz1lt+i+voPNYvnxf0wWEzuuMlls+z2f2eLKlEXMFutev2exePD+OrvF6x8n2SzaNn5ldBDz
        uHzF22PnrLvsHufvbWTxuHy21GPTqk42j81L6j1232xg8/j49BaLx/t9V9k8+rasYvTYfLra
        4/MmOY/2A91MAbxRXDYpqTmZZalF+nYJXBmnOv8xFTRZV6z6up6lgfGUXhcjJ4eEgInEoXvL
        2LoYuTiEBHYwSvyZ1cYOkZCRWHu3kw3CFpZY+e85O0TRR0aJuefPMYIk2AR0Ja4t2cQCYosI
        KEn8Xd/EAlLELPCZWWL+rjawhLCApcSdf3OZQWwWAVWJZ0dWgdm8ArYSn/6+ZYTYIC8x89J3
        sM2cAnYSfVvugNUIAdXcP9nPClEvKHFy5hOgmRxAC9Ql1s8TAgkzA7U2b53NPIFRcBaSqlkI
        VbOQVC1gZF7FKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREc4VpaOxj3rPqgd4iRiYPx
        EKMEB7OSCK8sy6V4Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7GCwmkJ5akZqemFqQWwWSZ
        ODilGpiWNjy2vW/y8cV5nRVPNrSZ560yKDywskhy0uv/BYdXv0vUTr/6/K/CsUUu79lzE9v2
        76nSXf3e6XjQXm8hqSMzpGofOoqG8yT0sj7/fP7W/RtTb16rduk/9sY8pmKzYC+znGKtHP+k
        I3tjbKdZyb8Qvpyd86twxbO/OryTjXqzTNK2ur/YHx59OiLjg3+53T6LI/+uq+zOn+nrJDLJ
        0b/Pndsp4vH0fcfLpu38dzPlzvb5DSqOW/57tKUXl9bon4/s5BBJvz9t/tHVna/1rt9Z+rvm
        2KaPoTHaur3yP+urXBe/3ayyZP+7QIevHV+2trsttjeNuucs/lju4Z9/Qi4mb17vmnDbiedK
        iyRL37I2JZbijERDLeai4kQAJ1oB6F8DAAA=
X-CMS-MailID: 20201211135205epcas5p1f1696075e1354f0f4c7af04b950d514c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20201211135205epcas5p1f1696075e1354f0f4c7af04b950d514c
References: <20201211135139.49232-1-selvakuma.s1@samsung.com>
        <CGME20201211135205epcas5p1f1696075e1354f0f4c7af04b950d514c@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add support for  TP 4065a ("Simple Copy Command"), v2020.05.04
("Ratified")

The implementation uses the payload passed from the block layer
to form simple copy command. Set the device copy limits to queue
limits.

Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Javier González <javier.gonz@samsung.com>
---
 drivers/nvme/host/core.c | 89 ++++++++++++++++++++++++++++++++++++++++
 include/linux/nvme.h     | 43 +++++++++++++++++--
 2 files changed, 129 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 9b6ebeb29cca..d235156ff565 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -647,6 +647,65 @@ static inline void nvme_setup_flush(struct nvme_ns *ns,
 	cmnd->common.nsid = cpu_to_le32(ns->head->ns_id);
 }
 
+static inline blk_status_t nvme_setup_copy(struct nvme_ns *ns,
+	       struct request *req, struct nvme_command *cmnd)
+{
+	struct nvme_ctrl *ctrl = ns->ctrl;
+	struct nvme_copy_range *range = NULL;
+	struct blk_copy_payload *payload;
+	unsigned short nr_range = 0;
+	u16 control = 0, ssrl;
+	u32 dsmgmt = 0;
+	u64 slba;
+	int i;
+
+	payload = bio_data(req->bio);
+	nr_range = payload->copy_range;
+
+	if (req->cmd_flags & REQ_FUA)
+		control |= NVME_RW_FUA;
+
+	if (req->cmd_flags & REQ_FAILFAST_DEV)
+		control |= NVME_RW_LR;
+
+	cmnd->copy.opcode = nvme_cmd_copy;
+	cmnd->copy.nsid = cpu_to_le32(ns->head->ns_id);
+	cmnd->copy.sdlba = cpu_to_le64(blk_rq_pos(req) >> (ns->lba_shift - 9));
+
+	range = kmalloc_array(nr_range, sizeof(*range),
+			GFP_ATOMIC | __GFP_NOWARN);
+	if (!range)
+		return BLK_STS_RESOURCE;
+
+	for (i = 0; i < nr_range; i++) {
+		slba = payload->range[i].src;
+		slba = slba >> (ns->lba_shift - 9);
+
+		ssrl = payload->range[i].len;
+		ssrl = ssrl >> (ns->lba_shift - 9);
+
+		range[i].slba = cpu_to_le64(slba);
+		range[i].nlb = cpu_to_le16(ssrl - 1);
+	}
+
+	cmnd->copy.nr_range = nr_range - 1;
+
+	req->special_vec.bv_page = virt_to_page(range);
+	req->special_vec.bv_offset = offset_in_page(range);
+	req->special_vec.bv_len = sizeof(*range) * nr_range;
+	req->rq_flags |= RQF_SPECIAL_PAYLOAD;
+
+	if (ctrl->nr_streams)
+		nvme_assign_write_stream(ctrl, req, &control, &dsmgmt);
+
+	//TBD end-to-end
+
+	cmnd->rw.control = cpu_to_le16(control);
+	cmnd->rw.dsmgmt = cpu_to_le32(dsmgmt);
+
+	return BLK_STS_OK;
+}
+
 static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 		struct nvme_command *cmnd)
 {
@@ -829,6 +888,9 @@ blk_status_t nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
 	case REQ_OP_DISCARD:
 		ret = nvme_setup_discard(ns, req, cmd);
 		break;
+	case REQ_OP_COPY:
+		ret = nvme_setup_copy(ns, req, cmd);
+		break;
 	case REQ_OP_READ:
 		ret = nvme_setup_rw(ns, req, cmd, nvme_cmd_read);
 		break;
@@ -1850,6 +1912,31 @@ static void nvme_config_discard(struct gendisk *disk, struct nvme_ns *ns)
 		blk_queue_max_write_zeroes_sectors(queue, UINT_MAX);
 }
 
+static void nvme_config_copy(struct gendisk *disk, struct nvme_ns *ns,
+				       struct nvme_id_ns *id)
+{
+	struct nvme_ctrl *ctrl = ns->ctrl;
+	struct request_queue *queue = disk->queue;
+
+	if (!(ctrl->oncs & NVME_CTRL_ONCS_COPY)) {
+		queue->limits.copy_offload = 0;
+		queue->limits.max_copy_sectors = 0;
+		queue->limits.max_copy_range_sectors = 0;
+		queue->limits.max_copy_nr_ranges = 0;
+		blk_queue_flag_clear(QUEUE_FLAG_COPY, queue);
+		return;
+	}
+
+	/* setting copy limits */
+	blk_queue_flag_test_and_set(QUEUE_FLAG_COPY, queue);
+	queue->limits.copy_offload = 0;
+	queue->limits.max_copy_sectors = le64_to_cpu(id->mcl) *
+		(1 << (ns->lba_shift - 9));
+	queue->limits.max_copy_range_sectors = le32_to_cpu(id->mssrl) *
+		(1 << (ns->lba_shift - 9));
+	queue->limits.max_copy_nr_ranges = id->msrc + 1;
+}
+
 static void nvme_config_write_zeroes(struct gendisk *disk, struct nvme_ns *ns)
 {
 	u64 max_blocks;
@@ -2045,6 +2132,7 @@ static void nvme_update_disk_info(struct gendisk *disk,
 	set_capacity_and_notify(disk, capacity);
 
 	nvme_config_discard(disk, ns);
+	nvme_config_copy(disk, ns, id);
 	nvme_config_write_zeroes(disk, ns);
 
 	if (id->nsattr & NVME_NS_ATTR_RO)
@@ -4616,6 +4704,7 @@ static inline void _nvme_check_size(void)
 	BUILD_BUG_ON(sizeof(struct nvme_download_firmware) != 64);
 	BUILD_BUG_ON(sizeof(struct nvme_format_cmd) != 64);
 	BUILD_BUG_ON(sizeof(struct nvme_dsm_cmd) != 64);
+	BUILD_BUG_ON(sizeof(struct nvme_copy_command) != 64);
 	BUILD_BUG_ON(sizeof(struct nvme_write_zeroes_cmd) != 64);
 	BUILD_BUG_ON(sizeof(struct nvme_abort_cmd) != 64);
 	BUILD_BUG_ON(sizeof(struct nvme_get_log_page_command) != 64);
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index d92535997687..11ed72a2164d 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -289,7 +289,7 @@ struct nvme_id_ctrl {
 	__u8			nvscc;
 	__u8			nwpc;
 	__le16			acwu;
-	__u8			rsvd534[2];
+	__le16			ocfs;
 	__le32			sgls;
 	__le32			mnan;
 	__u8			rsvd544[224];
@@ -314,6 +314,7 @@ enum {
 	NVME_CTRL_ONCS_WRITE_ZEROES		= 1 << 3,
 	NVME_CTRL_ONCS_RESERVATIONS		= 1 << 5,
 	NVME_CTRL_ONCS_TIMESTAMP		= 1 << 6,
+	NVME_CTRL_ONCS_COPY			= 1 << 8,
 	NVME_CTRL_VWC_PRESENT			= 1 << 0,
 	NVME_CTRL_OACS_SEC_SUPP                 = 1 << 0,
 	NVME_CTRL_OACS_DIRECTIVES		= 1 << 5,
@@ -362,7 +363,10 @@ struct nvme_id_ns {
 	__le16			npdg;
 	__le16			npda;
 	__le16			nows;
-	__u8			rsvd74[18];
+	__le16			mssrl;
+	__le32			mcl;
+	__u8			msrc;
+	__u8			rsvd91[11];
 	__le32			anagrpid;
 	__u8			rsvd96[3];
 	__u8			nsattr;
@@ -673,6 +677,7 @@ enum nvme_opcode {
 	nvme_cmd_resv_report	= 0x0e,
 	nvme_cmd_resv_acquire	= 0x11,
 	nvme_cmd_resv_release	= 0x15,
+	nvme_cmd_copy		= 0x19,
 	nvme_cmd_zone_mgmt_send	= 0x79,
 	nvme_cmd_zone_mgmt_recv	= 0x7a,
 	nvme_cmd_zone_append	= 0x7d,
@@ -691,7 +696,8 @@ enum nvme_opcode {
 		nvme_opcode_name(nvme_cmd_resv_register),	\
 		nvme_opcode_name(nvme_cmd_resv_report),		\
 		nvme_opcode_name(nvme_cmd_resv_acquire),	\
-		nvme_opcode_name(nvme_cmd_resv_release))
+		nvme_opcode_name(nvme_cmd_resv_release),	\
+		nvme_opcode_name(nvme_cmd_copy))
 
 
 /*
@@ -863,6 +869,36 @@ struct nvme_dsm_range {
 	__le64			slba;
 };
 
+struct nvme_copy_command {
+	__u8                    opcode;
+	__u8                    flags;
+	__u16                   command_id;
+	__le32                  nsid;
+	__u64                   rsvd2;
+	__le64                  metadata;
+	union nvme_data_ptr     dptr;
+	__le64                  sdlba;
+	__u8			nr_range;
+	__u8			rsvd12;
+	__le16                  control;
+	__le16                  rsvd13;
+	__le16			dspec;
+	__le32                  ilbrt;
+	__le16                  lbat;
+	__le16                  lbatm;
+};
+
+struct nvme_copy_range {
+	__le64			rsvd0;
+	__le64			slba;
+	__le16			nlb;
+	__le16			rsvd18;
+	__le32			rsvd20;
+	__le32			eilbrt;
+	__le16			elbat;
+	__le16			elbatm;
+};
+
 struct nvme_write_zeroes_cmd {
 	__u8			opcode;
 	__u8			flags;
@@ -1400,6 +1436,7 @@ struct nvme_command {
 		struct nvme_download_firmware dlfw;
 		struct nvme_format_cmd format;
 		struct nvme_dsm_cmd dsm;
+		struct nvme_copy_command copy;
 		struct nvme_write_zeroes_cmd write_zeroes;
 		struct nvme_zone_mgmt_send_cmd zms;
 		struct nvme_zone_mgmt_recv_cmd zmr;
-- 
2.25.1

