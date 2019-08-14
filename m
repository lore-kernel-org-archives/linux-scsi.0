Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8368C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 13:46:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9155E2083B
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 13:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbfHNNqX convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 09:46:23 -0400
Received: from m9a0002g.houston.softwaregrp.com ([15.124.64.67]:35993 "EHLO
        m9a0002g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727965AbfHNNqX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Aug 2019 09:46:23 -0400
Received: FROM m9a0002g.houston.softwaregrp.com (15.121.0.190) BY m9a0002g.houston.softwaregrp.com WITH ESMTP;
 Wed, 14 Aug 2019 13:45:43 +0000
Received: from M9W0068.microfocus.com (2002:f79:bf::f79:bf) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 14 Aug 2019 13:28:31 +0000
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (15.124.72.10) by
 M9W0068.microfocus.com (15.121.0.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Wed, 14 Aug 2019 13:28:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cArAAK5HuzGHTb3wtlfpkd9J5Lmw0Fb8RbKabYOfGzGHUywPgyuep4o2r1EcLChOnNT2Bru6FkqJhing8svZXVj5VTx6DfdGS4NKv5ZgKRzyO5ZaFu98Xt71jlpVqeG9gVaaOyz0/SOQn45KJ7qyvmuhkb3pQP0lmpciQfTdtBEaCTt98Ol67dkaSI4GiQrMI4wrKjlHMFn/xhJSMVawTUAVMd4NpN9gJZY/33Xz2Ffa8Up8qSL+TfePu9tflZsWeSUzM10kth8XVWfW2coaFzFIQCUcN+TJ5FBOTm11S3aTAmB5VPmbzztoh7q7JgIOkU4O/brKY7yXR1OZ6OLv9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ttHmZMYpO+PyyywQ+dQjvxQEClnH42kfWpqzcmnWCEg=;
 b=X3L6hH0iwG99YvIR6YbP58z3VSwjaGnLGaya6JZ1Qr9TuuZGfZDllRGof8sJpSb1uQbi2K2h1jLcWLlpFs87CAwOdK0HDOiOy4aQCc1Scu64kKmKKiDkRa2M+uj6NamfGRdpf5TljM6mZ9cdQlJetlL1hB6M9fMdvVxDb90HyznxLmNFawBK9S9vr3GqoCgk/k9///phnbpAGqcFcq5s3ZkOnPFbqKIW/ZY+EXIZhq13xoBybBFK/bJXxx9bfxhRAiUYdE8naNlvGTysTREqpAeyAPqMYtMn7GFRvos7Y5i/RYJmTGJKYAC+upWz8O+jP0IVrqmeZAFDf+5hPtqL5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from CH2PR18MB3349.namprd18.prod.outlook.com (52.132.246.91) by
 CH2PR18MB3429.namprd18.prod.outlook.com (52.132.247.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Wed, 14 Aug 2019 13:28:29 +0000
Received: from CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::8818:7a86:93d7:561a]) by CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::8818:7a86:93d7:561a%6]) with mapi id 15.20.2157.022; Wed, 14 Aug 2019
 13:28:29 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>
CC:     Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Joe Carnuccio <joe.carnuccio@cavium.com>,
        Quinn Tran <qutran@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        Martin Wilck <Martin.Wilck@suse.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 2/2] scsi: qla2xxx: cleanup trace buffer initialization
Thread-Topic: [PATCH v2 2/2] scsi: qla2xxx: cleanup trace buffer
 initialization
Thread-Index: AQHVUqQpw3ZhPzS2+kedroh5/53/cA==
Date:   Wed, 14 Aug 2019 13:28:29 +0000
Message-ID: <20190814132642.5298-3-martin.wilck@suse.com>
References: <20190814132642.5298-1-martin.wilck@suse.com>
In-Reply-To: <20190814132642.5298-1-martin.wilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR06CA0016.eurprd06.prod.outlook.com
 (2603:10a6:206:2::29) To CH2PR18MB3349.namprd18.prod.outlook.com
 (2603:10b6:610:2c::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.22.0
x-originating-ip: [94.218.227.174]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59bc3bf7-4f09-4d11-c61e-08d720bb4b8b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR18MB3429;
x-ms-traffictypediagnostic: CH2PR18MB3429:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR18MB342983E30B8730108227AD0CFCAD0@CH2PR18MB3429.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:364;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(189003)(199004)(66556008)(66066001)(256004)(3846002)(81156014)(81166006)(54906003)(66446008)(8676002)(66476007)(4326008)(8936002)(6116002)(50226002)(64756008)(14444005)(478600001)(66946007)(99286004)(25786009)(53936002)(110136005)(316002)(36756003)(486006)(305945005)(476003)(76176011)(26005)(11346002)(5660300002)(44832011)(446003)(6486002)(7736002)(186003)(52116002)(6506007)(386003)(86362001)(102836004)(71200400001)(14454004)(2906002)(1076003)(71190400001)(6512007)(6436002)(2616005);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR18MB3429;H:CH2PR18MB3349.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qigjY6YZo1OXgVbrIZnNqR38pjTJfTEDB2GY51juGZZvDW+TXv6Q3TLI9Tn1kniRHQ9rN7pyMgHMF2zbaR2p4InviM6GLt6TVkWH2+nGamrcCL4ucFC79h/urQd6tboRpzQmIQc65EbRJuucFxZD2RUA4Ti1e+VqowRZ1x18lMR0UR6FFWVgCH25cyF/gwKB8Na+/ksCN0XsF9jsaLDBA75NMquSXMgyVrvg0MknznWrE8rNKT6OSRLhIZdxL7RGKwPlaIvA+EFwnj949GKYEHfXHPKN3ZgSXjFb0ztgzio/+1SBJxWIWcGtUuRf42+kGZaDMIRPCzKMH4XBqenJpi66UCU1YlRMH/YemWXWC10guBmO1+KXmdaYAw4FCZT1lFA8uZEj4MEbwmjUZliLTD53vzLAmKL58zOM3m1mvPw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 59bc3bf7-4f09-4d11-c61e-08d720bb4b8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 13:28:29.6278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZzP+pm+eora+NPmoYarY+DzNpDKPUGd+wCecYEddqX7dva/SCZAKIcQMYVtGe/O+EPcZNwfEaAi6aEwCPnaZJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3429
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

Avoid code duplication between qla2x00_alloc_offload_mem() and
qla2x00_alloc_fw_dump() by moving the FCE and EFT buffer allocation
and initialization to separate functions. Cleanly track failure
and success by making sure that the ha->eft, ha->fce and respective
eft_dma, fce_dma members are set if and only if the buffers are properly
allocated and initialized. Avoid pointless buffer reallocation.
Eliminate some goto statements. Make sure the fce_enabled flag
is cleared when the FCE buffer is freed.

Fixes: ad0a0b01f088 "scsi: qla2xxx: Fix Firmware dump size for Extended
 login and Exchange Offload"
Fixes: a28d9e4ef997 "scsi: qla2xxx: Add support for multiple fwdump
 templates/segments"
Cc: Joe Carnuccio <joe.carnuccio@cavium.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 220 +++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_os.c   |   1 +
 2 files changed, 102 insertions(+), 119 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6dd68be..4a89ec5 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3032,103 +3032,113 @@ qla24xx_chip_diag(scsi_qla_host_t *vha)
 }
 
 static void
-qla2x00_alloc_offload_mem(scsi_qla_host_t *vha)
+qla2x00_init_fce_trace(scsi_qla_host_t *vha)
 {
 	int rval;
 	dma_addr_t tc_dma;
 	void *tc;
 	struct qla_hw_data *ha = vha->hw;
 
+	if (!IS_FWI2_CAPABLE(ha))
+		return;
+
+	if (!IS_QLA25XX(ha) && !IS_QLA81XX(ha) && !IS_QLA83XX(ha) &&
+	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+		return;
+
+	if (ha->fce) {
+		ql_dbg(ql_dbg_init, vha, 0x00bd,
+		       "%s: FCE Mem is already allocated.\n",
+		       __func__);
+		return;
+	}
+
+	/* Allocate memory for Fibre Channel Event Buffer. */
+	tc = dma_alloc_coherent(&ha->pdev->dev, FCE_SIZE, &tc_dma,
+				GFP_KERNEL);
+	if (!tc) {
+		ql_log(ql_log_warn, vha, 0x00be,
+		       "Unable to allocate (%d KB) for FCE.\n",
+		       FCE_SIZE / 1024);
+		return;
+	}
+
+	rval = qla2x00_enable_fce_trace(vha, tc_dma, FCE_NUM_BUFFERS,
+					ha->fce_mb, &ha->fce_bufs);
+	if (rval) {
+		ql_log(ql_log_warn, vha, 0x00bf,
+		       "Unable to initialize FCE (%d).\n", rval);
+		dma_free_coherent(&ha->pdev->dev, FCE_SIZE, tc, tc_dma);
+		return;
+	}
+
+	ql_dbg(ql_dbg_init, vha, 0x00c0,
+	       "Allocated (%d KB) for FCE...\n", FCE_SIZE / 1024);
+
+	ha->flags.fce_enabled = 1;
+	ha->fce_dma = tc_dma;
+	ha->fce = tc;
+}
+
+static void
+qla2x00_init_eft_trace(scsi_qla_host_t *vha)
+{
+	int rval;
+	dma_addr_t tc_dma;
+	void *tc;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!IS_FWI2_CAPABLE(ha))
+		return;
+
 	if (ha->eft) {
 		ql_dbg(ql_dbg_init, vha, 0x00bd,
-		    "%s: Offload Mem is already allocated.\n",
+		    "%s: EFT Mem is already allocated.\n",
 		    __func__);
 		return;
 	}
 
-	if (IS_FWI2_CAPABLE(ha)) {
-		/* Allocate memory for Fibre Channel Event Buffer. */
-		if (!IS_QLA25XX(ha) && !IS_QLA81XX(ha) && !IS_QLA83XX(ha) &&
-		    !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
-			goto try_eft;
-
-		if (ha->fce)
-			dma_free_coherent(&ha->pdev->dev,
-			    FCE_SIZE, ha->fce, ha->fce_dma);
-
-		/* Allocate memory for Fibre Channel Event Buffer. */
-		tc = dma_alloc_coherent(&ha->pdev->dev, FCE_SIZE, &tc_dma,
-					GFP_KERNEL);
-		if (!tc) {
-			ql_log(ql_log_warn, vha, 0x00be,
-			    "Unable to allocate (%d KB) for FCE.\n",
-			    FCE_SIZE / 1024);
-			goto try_eft;
-		}
-
-		rval = qla2x00_enable_fce_trace(vha, tc_dma, FCE_NUM_BUFFERS,
-		    ha->fce_mb, &ha->fce_bufs);
-		if (rval) {
-			ql_log(ql_log_warn, vha, 0x00bf,
-			    "Unable to initialize FCE (%d).\n", rval);
-			dma_free_coherent(&ha->pdev->dev, FCE_SIZE, tc,
-			    tc_dma);
-			ha->flags.fce_enabled = 0;
-			goto try_eft;
-		}
-		ql_dbg(ql_dbg_init, vha, 0x00c0,
-		    "Allocate (%d KB) for FCE...\n", FCE_SIZE / 1024);
-
-		ha->flags.fce_enabled = 1;
-		ha->fce_dma = tc_dma;
-		ha->fce = tc;
-
-try_eft:
-		if (ha->eft)
-			dma_free_coherent(&ha->pdev->dev,
-			    EFT_SIZE, ha->eft, ha->eft_dma);
-
-		/* Allocate memory for Extended Trace Buffer. */
-		tc = dma_alloc_coherent(&ha->pdev->dev, EFT_SIZE, &tc_dma,
-					GFP_KERNEL);
-		if (!tc) {
-			ql_log(ql_log_warn, vha, 0x00c1,
-			    "Unable to allocate (%d KB) for EFT.\n",
-			    EFT_SIZE / 1024);
-			goto eft_err;
-		}
-
-		rval = qla2x00_enable_eft_trace(vha, tc_dma, EFT_NUM_BUFFERS);
-		if (rval) {
-			ql_log(ql_log_warn, vha, 0x00c2,
-			    "Unable to initialize EFT (%d).\n", rval);
-			dma_free_coherent(&ha->pdev->dev, EFT_SIZE, tc,
-			    tc_dma);
-			goto eft_err;
-		}
-		ql_dbg(ql_dbg_init, vha, 0x00c3,
-		    "Allocated (%d KB) EFT ...\n", EFT_SIZE / 1024);
-
-		ha->eft_dma = tc_dma;
-		ha->eft = tc;
+	/* Allocate memory for Extended Trace Buffer. */
+	tc = dma_alloc_coherent(&ha->pdev->dev, EFT_SIZE, &tc_dma,
+				GFP_KERNEL);
+	if (!tc) {
+		ql_log(ql_log_warn, vha, 0x00c1,
+		       "Unable to allocate (%d KB) for EFT.\n",
+		       EFT_SIZE / 1024);
+		return;
 	}
 
-eft_err:
-	return;
+	rval = qla2x00_enable_eft_trace(vha, tc_dma, EFT_NUM_BUFFERS);
+	if (rval) {
+		ql_log(ql_log_warn, vha, 0x00c2,
+		       "Unable to initialize EFT (%d).\n", rval);
+		dma_free_coherent(&ha->pdev->dev, EFT_SIZE, tc, tc_dma);
+		return;
+	}
+
+	ql_dbg(ql_dbg_init, vha, 0x00c3,
+	       "Allocated (%d KB) EFT ...\n", EFT_SIZE / 1024);
+
+	ha->eft_dma = tc_dma;
+	ha->eft = tc;
+}
+
+static void
+qla2x00_alloc_offload_mem(scsi_qla_host_t *vha)
+{
+	qla2x00_init_fce_trace(vha);
+	qla2x00_init_eft_trace(vha);
 }
 
 void
 qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 {
-	int rval;
 	uint32_t dump_size, fixed_size, mem_size, req_q_size, rsp_q_size,
 	    eft_size, fce_size, mq_size;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = ha->req_q_map[0];
 	struct rsp_que *rsp = ha->rsp_q_map[0];
 	struct qla2xxx_fw_dump *fw_dump;
-	dma_addr_t tc_dma;
-	void *tc;
 
 	dump_size = fixed_size = mem_size = eft_size = fce_size = mq_size = 0;
 	req_q_size = rsp_q_size = 0;
@@ -3166,39 +3176,13 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 		}
 		if (ha->tgt.atio_ring)
 			mq_size += ha->tgt.atio_q_length * sizeof(request_t);
-		/* Allocate memory for Fibre Channel Event Buffer. */
-		if (!IS_QLA25XX(ha) && !IS_QLA81XX(ha) && !IS_QLA83XX(ha) &&
-		    !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
-			goto try_eft;
 
-		fce_size = sizeof(struct qla2xxx_fce_chain) + FCE_SIZE;
-try_eft:
+		qla2x00_init_fce_trace(vha);
+		if (ha->fce)
+			fce_size = sizeof(struct qla2xxx_fce_chain) + FCE_SIZE;
+		qla2x00_init_eft_trace(vha);
 		if (ha->eft)
-			dma_free_coherent(&ha->pdev->dev,
-			    EFT_SIZE, ha->eft, ha->eft_dma);
-
-		/* Allocate memory for Extended Trace Buffer. */
-		tc = dma_alloc_coherent(&ha->pdev->dev, EFT_SIZE, &tc_dma,
-					 GFP_KERNEL);
-		if (!tc) {
-			ql_log(ql_log_warn, vha, 0x00c1,
-			    "Unable to allocate (%d KB) for EFT.\n",
-			    EFT_SIZE / 1024);
-			goto allocate;
-		}
-
-		rval = qla2x00_enable_eft_trace(vha, tc_dma, EFT_NUM_BUFFERS);
-		if (rval) {
-			ql_log(ql_log_warn, vha, 0x00c2,
-			    "Unable to initialize EFT (%d).\n", rval);
-			dma_free_coherent(&ha->pdev->dev, EFT_SIZE, tc,
-			    tc_dma);
-		}
-		ql_dbg(ql_dbg_init, vha, 0x00c3,
-		    "Allocated (%d KB) EFT ...\n", EFT_SIZE / 1024);
-		eft_size = EFT_SIZE;
-		ha->eft_dma = tc_dma;
-		ha->eft = tc;
+			eft_size = EFT_SIZE;
 	}
 
 	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
@@ -3220,24 +3204,22 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 			    j, fwdt->dump_size);
 			dump_size += fwdt->dump_size;
 		}
-		goto allocate;
+	} else {
+		req_q_size = req->length * sizeof(request_t);
+		rsp_q_size = rsp->length * sizeof(response_t);
+		dump_size = offsetof(struct qla2xxx_fw_dump, isp);
+		dump_size += fixed_size + mem_size + req_q_size + rsp_q_size
+			+ eft_size;
+		ha->chain_offset = dump_size;
+		dump_size += mq_size + fce_size;
+		if (ha->exchoffld_buf)
+			dump_size += sizeof(struct qla2xxx_offld_chain) +
+				ha->exchoffld_size;
+		if (ha->exlogin_buf)
+			dump_size += sizeof(struct qla2xxx_offld_chain) +
+				ha->exlogin_size;
 	}
 
-	req_q_size = req->length * sizeof(request_t);
-	rsp_q_size = rsp->length * sizeof(response_t);
-	dump_size = offsetof(struct qla2xxx_fw_dump, isp);
-	dump_size += fixed_size + mem_size + req_q_size + rsp_q_size + eft_size;
-	ha->chain_offset = dump_size;
-	dump_size += mq_size + fce_size;
-
-	if (ha->exchoffld_buf)
-		dump_size += sizeof(struct qla2xxx_offld_chain) +
-			ha->exchoffld_size;
-	if (ha->exlogin_buf)
-		dump_size += sizeof(struct qla2xxx_offld_chain) +
-			ha->exlogin_size;
-
-allocate:
 	if (!ha->fw_dump_len || dump_size > ha->fw_dump_alloc_len) {
 
 		ql_dbg(ql_dbg_init, vha, 0x00c5,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7d73b6a..51154c0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4577,6 +4577,7 @@ qla2x00_free_fw_dump(struct qla_hw_data *ha)
 
 	ha->fce = NULL;
 	ha->fce_dma = 0;
+	ha->flags.fce_enabled = 0;
 	ha->eft = NULL;
 	ha->eft_dma = 0;
 	ha->fw_dumped = 0;
-- 
2.22.0

