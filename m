Return-Path: <SRS0=Uo2m=ZV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AE1BC432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Nov 2019 20:27:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1840C21774
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Nov 2019 20:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfK2U1c convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Nov 2019 15:27:32 -0500
Received: from m4a0040g.houston.softwaregrp.com ([15.124.2.86]:33198 "EHLO
        m4a0040g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726970AbfK2U1c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 Nov 2019 15:27:32 -0500
Received: FROM m4a0040g.houston.softwaregrp.com (15.120.17.146) BY m4a0040g.houston.softwaregrp.com WITH ESMTP;
 Fri, 29 Nov 2019 20:25:32 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M4W0334.microfocus.com (2002:f78:1192::f78:1192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Fri, 29 Nov 2019 20:26:35 +0000
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (15.124.8.10) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Fri, 29 Nov 2019 20:26:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAwQLNXttPbOp7B9rCLzDiTDkQSoFE4lOs7P873Kzlm0CHmr8mF4iou31Tq5upEbJV6i/X2QWmnhJQqa5kAs7iUSFL/2HXb/3X/gXjgUIRQ7G8tbZwK8JJO56BTpSZ/0XUU0XzIKZza/TxkepZpdy2s51flY/D5WKqXhSQW/PfURniKtgtPM9dYNT8CFlvJ9GjRQBE3HCgmenuh6TfvS3kg+MP4Bqy8CCGO9mamG8dYEGHFoMdPZemQod17FE+wiJI7RXA2hIu5PPXR6igMmbyzEeAigqifef+wEKS68+ILaSba9/V39b/SEoKWf1dwN+mOZmL77Fi48AccnRoGA5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZPn2ISs3Lntt7Ku90L0fT0Tdc8NdnjeplO4m/4YzOk=;
 b=MyRCzfy9vZkzfm0UiRz0LqGj7xaD3BKqgyeQ8529rzjXxTt76cVXZqln74bFRGVULhOoX39LQha44B2AVzHN/LywcWI+r/fIzUCYPRhBD3NC2kqSk6LsIpazm/Ss9r0EZDzfRLJMhgHQxxooKhWcqQpY17s9N4lSQvaAkrr7e30TcEvs1BIqkt+W9EvKquwsfFm2YtR8VW8NhgaOsp/rYgf5D2bHbSFTahZRIVTbLwzbHOoXFRNuleuBSas5SbJ7prWA5Ww6X2nOi03S7L/9+7zEp+cgH98GGkFiplAxrozCgkzO2eonW3jX69QphI03VlxWfeyvQvHpe+jJU17NOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DM5PR18MB1355.namprd18.prod.outlook.com (10.175.223.16) by
 DM5PR18MB1644.namprd18.prod.outlook.com (10.175.224.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Fri, 29 Nov 2019 20:26:34 +0000
Received: from DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::b08c:34c6:ffb6:641c]) by DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::b08c:34c6:ffb6:641c%12]) with mapi id 15.20.2495.014; Fri, 29 Nov
 2019 20:26:34 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>
CC:     Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Hannes Reinecke <hare@suse.de>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/2] scsi: qla2xxx: avoid sending mailbox commands if firmware
 is stopped
Thread-Topic: [PATCH 1/2] scsi: qla2xxx: avoid sending mailbox commands if
 firmware is stopped
Thread-Index: AQHVpvNKYCEBiNY4p0Wmj1jkBPK5ag==
Date:   Fri, 29 Nov 2019 20:26:34 +0000
Message-ID: <20191129202627.19624-1-martin.wilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4P190CA0022.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::32) To DM5PR18MB1355.namprd18.prod.outlook.com
 (2603:10b6:3:14a::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [2.206.153.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e395b220-01c3-4dce-6021-08d7750a6d2c
x-ms-traffictypediagnostic: DM5PR18MB1644:|DM5PR18MB1644:
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtFwd,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB16442D8DB09B5B5E605AA5E8FC460@DM5PR18MB1644.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:115;
x-forefront-prvs: 0236114672
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(366004)(136003)(396003)(39860400002)(376002)(189003)(199004)(6116002)(71190400001)(71200400001)(3846002)(4326008)(6512007)(6506007)(25786009)(64756008)(66446008)(305945005)(44832011)(7736002)(6436002)(6486002)(66556008)(66946007)(66476007)(386003)(8676002)(8936002)(14444005)(316002)(186003)(50226002)(99286004)(36756003)(5660300002)(86362001)(81166006)(81156014)(1076003)(52116002)(14454004)(102836004)(26005)(66066001)(110136005)(54906003)(2616005)(478600001)(256004)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR18MB1644;H:DM5PR18MB1355.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vB5k+qG5NT84qMgsxjXi3m64HHeFDRMnVbPJi1vJ9Be8MX5WYpi4vy4lzdvSU8BkIbzX3Fl2d36PcbStOyr3lwCFVzKPNq8xI06Y76yf6vdkck0M4MLEg7X9bOOFvw2vnosIkiRoqYhmd+kZjjdkg9WFIamEFSvIZ6QSkdJ+2icCFvEL8m+bYj75xW+lCEXnSFgnNOoxcOrwC1yvYO+dEcUd5GdbySU2pToz37GqaQyNCtybF/BpNton3PJx6oGr4yrQR2JTJx95cZuY1iW5QsjqrywkMtx+t2t4fVh9R1AKhj7jpWY1I4YNgMA5Duavwhv3MfqNL1tomDLd67a/+Kp/cRhb76Lx8yd+w7vcv5QJ38WM1reSjE9DJ2Pe+KvZevhTJk+fJwdyb8b4S69yrOpp0N4wgg6XQp8w1iAictalnGyxOAvl8NxQUup3uy4m
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e395b220-01c3-4dce-6021-08d7750a6d2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2019 20:26:34.2220
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DVmCQqoL8ckQv9IT9WZ5/UL/NmFioZSEAx6GeF619Fd2N0u7IiMTl51P1fb0Qirz1iTowPSggtB+DgbJ6+DUvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1644
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

After commit 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting
down chip"), it is possible that FC commands are scheduled after the
adapter firmware has been shut down. IO sent to the firmware in this
situation hangs indefinitely. Avoid this for the LOGO code path that is
typically taken when adapters are shut down.

Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 3 +++
 drivers/scsi/qla2xxx/qla_os.c  | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index bb6811b..e129df4 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2643,6 +2643,9 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x106d,
 	    "Entered %s.\n", __func__);
 
+	if (!ha->flags.fw_started)
+		return QLA_FUNCTION_FAILED;
+
 	lg = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
 	if (lg == NULL) {
 		ql_log(ql_log_warn, vha, 0x106e,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2450ba9..43d0aa0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4891,6 +4891,9 @@ qla2x00_post_work(struct scsi_qla_host *vha, struct qla_work_evt *e)
 	unsigned long flags;
 	bool q = false;
 
+	if (!vha->hw->flags.fw_started)
+		return QLA_FUNCTION_FAILED;
+
 	spin_lock_irqsave(&vha->work_lock, flags);
 	list_add_tail(&e->list, &vha->work_list);
 
-- 
2.24.0

