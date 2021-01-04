Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8929CC43381
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 10:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47FD521E92
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 10:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbhADKtF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 05:49:05 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:34449 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbhADKtE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 05:49:04 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210104104819epoutp04c729f2873be0f2c90ca156cc533b4d85~XAbwoJSzR1077010770epoutp04K
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jan 2021 10:48:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210104104819epoutp04c729f2873be0f2c90ca156cc533b4d85~XAbwoJSzR1077010770epoutp04K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1609757299;
        bh=2WE958f2JtjnRde+BTSAKrky2G48h6Bb1krIKzPOCV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E70KRVvs/niD571gwhGKMMGO1X+rr9k0aKX1KZijVcmtidGkUobYM+bztl6YImzgE
         /hg5TWGxalC6RCwXIeWtip1hy8dIUPYAxbo3A19qqNzQGKXTIMLDAGbcxa26XonfXM
         YIKp3xiH51HR1voPtgffdP7EIcnHDdKbMIO1+LOA=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20210104104818epcas5p36ebacb89f69c0030baa74a6532cf07ba~XAbvnl8VD0252202522epcas5p33;
        Mon,  4 Jan 2021 10:48:18 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BA.F6.50652.272F2FF5; Mon,  4 Jan 2021 19:48:18 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20210104104254epcas5p212bb42457cfbaed5aeaeaa5b6625922b~XAXCEt7gK1410114101epcas5p2W;
        Mon,  4 Jan 2021 10:42:54 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210104104254epsmtrp2473ac76f532b611e18588853ef90caba~XAXCDYupL2765227652epsmtrp2f;
        Mon,  4 Jan 2021 10:42:54 +0000 (GMT)
X-AuditID: b6c32a4a-6b3ff7000000c5dc-9d-5ff2f2725cfe
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AD.49.13470.E21F2FF5; Mon,  4 Jan 2021 19:42:54 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210104104251epsmtip10b0f508b42d2bbc84eb3ebbb8c0f86cf~XAW-D1XyM1773217732epsmtip1c;
        Mon,  4 Jan 2021 10:42:51 +0000 (GMT)
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
Subject: [RFC PATCH v4 3/3] nvme: add simple copy support
Date:   Mon,  4 Jan 2021 16:11:59 +0530
Message-Id: <20210104104159.74236-4-selvakuma.s1@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104104159.74236-1-selvakuma.s1@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdlhTXbfo06d4g9ln+CxW3+1ns5j24Sez
        RWv7NyaLve9ms1rsWTSJyWLl6qNMFo/vfGa3+Nt1j8ni6P+3bBaTDl1jtNh7S9vi8q45bBbz
        lz1lt+i+voPNYvnxf0wWEzuuMlls+z2f2eLKlEXMFutev2exePD+OrvF6x8n2SzaNn5ldBDz
        uHzF22PnrLvsHufvbWTxuHy21GPTqk42j81L6j1232xg8/j49BaLx/t9V9k8+rasYvTYfLra
        4/MmOY/2A91MAbxRXDYpqTmZZalF+nYJXBkz3v9iKzhgU/H83wWmBsZn+l2MHBwSAiYS0/dU
        dTFycQgJ7GaUuLzkLBOE84lR4kbDHhYI5xujxKKWmaxdjJxgHTveTWcCsYUE9jJKrNyfDVH0
        mVFicd9PsCI2AV2Ja0s2sYDYIgJKEn/XN4FNYha4ySxx6dcndpCEsIClxOZ5R8EaWARUJbYf
        +gYW5xWwlVh35QwjxDZ5iZmXvoPFOQXsJCZdvMcKUSMocXLmE7AFzEA1zVtnM4MskBCYzynR
        +PAiO0Szi8Shp1egzhaWeHV8C1RcSuLzu71sEHa5xLPOaUwQdgOjRN/7cgjbXuLinr9MoEBi
        FtCUWL9LHyIsKzH11DomiL18Er2/n0C18krsmPeECRKmahKntptBhGUkPhzeBbXJQ+LFmhvs
        kMCayCjRtGg+0wRGhVlI3pmF5J1ZCJsXMDKvYpRMLSjOTU8tNi0wykst1ytOzC0uzUvXS87P
        3cQITqZaXjsYHz74oHeIkYmD8RCjBAezkghvxYUP8UK8KYmVValF+fFFpTmpxYcYpTlYlMR5
        dxg8iBcSSE8sSc1OTS1ILYLJMnFwSjUwGfT3HHBuWv7r8IO2h4vNjh1h7v5ftmhF8CIGPZ33
        MZp904K/T/th1Hjh5s0Z9r8vLbc4ZvJc/3X0d/4Hj9NXJs/m1xCbYNd0XyI/euKZB5tdFcru
        swvpChyZ3LHpqXiJnllE0J+ltzcej9vyt+XMWr+OnpOfA+9vs7TnlZos/ET1vnqLJoeDQerG
        Lm99/RdbIlpL3ldNvLP5j6noua6TgWp/M6VfXPs32f/v66ncs9wz+TPixep8jt3Vizmjkum6
        dd3flVG6Cgz6v5nD1L5Pv/NqxtWr3oUHJ5Zd6nmxkavQLfhdevOOisfJzMqzN/37zNuaWF4W
        3XGUq2OGmOV+B+MC77lVP7oXc9/aXXMzUImlOCPRUIu5qDgRACEvBDAVBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWy7bCSnK7ex0/xBqefilqsvtvPZjHtw09m
        i9b2b0wWe9/NZrXYs2gSk8XK1UeZLB7f+cxu8bfrHpPF0f9v2SwmHbrGaLH3lrbF5V1z2Czm
        L3vKbtF9fQebxfLj/5gsJnZcZbLY9ns+s8WVKYuYLda9fs9i8eD9dXaL1z9Oslm0bfzK6CDm
        cfmKt8fOWXfZPc7f28jicflsqcemVZ1sHpuX1HvsvtnA5vHx6S0Wj/f7rrJ59G1Zxeix+XS1
        x+dNch7tB7qZAnijuGxSUnMyy1KL9O0SuDJmvP/FVnDApuL5vwtMDYzP9LsYOTkkBEwkdryb
        ztTFyMUhJLCbUaL71nwWiISMxNq7nWwQtrDEyn/P2SGKPjJKnP52gQkkwSagK3FtySawBhEB
        JYm/65tYQIqYBT4zS8zf1QaWEBawlNg87ygriM0ioCqx/dA3dhCbV8BWYt2VM4wQG+QlZl76
        DhbnFLCTmHTxHlA9B9A2W4lFrcIQ5YISJ2c+YQEJMwuoS6yfJwQSZgbqbN46m3kCo+AsJFWz
        EKpmIalawMi8ilEytaA4Nz232LDAMC+1XK84Mbe4NC9dLzk/dxMjOL61NHcwbl/1Qe8QIxMH
        4yFGCQ5mJRHeigsf4oV4UxIrq1KL8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgST
        ZeLglGpgKmdrfc3br+78Kfu0HJ/d22uXFbebbxXjzZONNBda9+6Iv8hBk+6l++NaW1QK9839
        ut44I6rxf4edS8ISX+6s7W+nt+/oUdmwqko621T2oaPh0l9JHzuvO/Xu3yvk83hetXXOV4Pf
        Z61OBCTWTUuc0eSmcV9UlO9J/st1R5lerJb54jrzS0zi7oobc53SVKdaMdScaVuUzccWf+6e
        jVrgR2P+ht4bthF6zP6zPFjbZ1k5bC+885GlL0LyNP/OG7JLhP5t3GaiZvzok3HFlnWzzHoC
        vO9pHu8J55AU/6e9jDlw4j4Xh4mVFyauYYiVN3V4oNCx3VLrV1pEdYWwoJKbSOaL+g+Cni/1
        POe8maPEUpyRaKjFXFScCABXoDLRXgMAAA==
X-CMS-MailID: 20210104104254epcas5p212bb42457cfbaed5aeaeaa5b6625922b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20210104104254epcas5p212bb42457cfbaed5aeaeaa5b6625922b
References: <20210104104159.74236-1-selvakuma.s1@samsung.com>
        <CGME20210104104254epcas5p212bb42457cfbaed5aeaeaa5b6625922b@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add support for  TP 4065a ("Simple Copy Command"), v2020.05.04
("Ratified")

For device supporting native simple copy, this implementation accepts
the payload passed from the block layer and convert payload to form
simple copy command and submit to the device.

Set the device copy limits to queue limits. By default copy_offload
is disabled.

End-to-end protection is done by setting both PRINFOR and PRINFOW
to 0.

Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Javier González <javier.gonz@samsung.com>
---
 drivers/nvme/host/core.c | 87 ++++++++++++++++++++++++++++++++++++++++
 include/linux/nvme.h     | 43 ++++++++++++++++++--
 2 files changed, 127 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ce1b61519441..ea75af3e865a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -708,6 +708,63 @@ static inline void nvme_setup_flush(struct nvme_ns *ns,
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
+	cmnd->rw.control = cpu_to_le16(control);
+	cmnd->rw.dsmgmt = cpu_to_le32(dsmgmt);
+
+	return BLK_STS_OK;
+}
+
 static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 		struct nvme_command *cmnd)
 {
@@ -890,6 +947,9 @@ blk_status_t nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
 	case REQ_OP_DISCARD:
 		ret = nvme_setup_discard(ns, req, cmd);
 		break;
+	case REQ_OP_COPY:
+		ret = nvme_setup_copy(ns, req, cmd);
+		break;
 	case REQ_OP_READ:
 		ret = nvme_setup_rw(ns, req, cmd, nvme_cmd_read);
 		break;
@@ -1917,6 +1977,31 @@ static void nvme_config_discard(struct gendisk *disk, struct nvme_ns *ns)
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
@@ -2112,6 +2197,7 @@ static void nvme_update_disk_info(struct gendisk *disk,
 	set_capacity_and_notify(disk, capacity);
 
 	nvme_config_discard(disk, ns);
+	nvme_config_copy(disk, ns, id);
 	nvme_config_write_zeroes(disk, ns);
 
 	if ((id->nsattr & NVME_NS_ATTR_RO) ||
@@ -4689,6 +4775,7 @@ static inline void _nvme_check_size(void)
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

