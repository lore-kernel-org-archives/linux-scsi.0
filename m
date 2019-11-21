Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D82C432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 22:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31C3D206EC
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 22:52:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="NczxgQL1";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="KTIhcGcl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfKUWwN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 17:52:13 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38128 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725936AbfKUWwN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Nov 2019 17:52:13 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xALMoCei027314;
        Thu, 21 Nov 2019 14:52:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=+yFOEVuqSkbxubLiXaygKhmj0sDOCgn8LRik2dntSr4=;
 b=NczxgQL1TbjoA2c/SFJEy8hm8XpvSS5xBwDezGZPfCwu0GIT8J3T3jc+No/OQB/Am+9x
 KGJvXUUbUCJWY0NPvCsTUes8u/Ggu4PZ0Fa+XZjoeIwHTgieb6gM1Vv68gy1NnQK9Pvi
 ex9x6d1/6HEZXTGKAFroVI3OrcR2imqrJKNbKNLlqnT7qPp3a8sK19uWGk/O1QPJcCxg
 LmkdaDi15LBF/CHekyyUQVWxz/aY5FhyiTNYkHPbbBAVj6iKUDnmfmGUnUKEbCscoIBW
 8s4yWHZZYRCI/1w05NZDrAPlPl7JCf7pU3Q75NDaZvYCemikC8nho+oGuyFWweNoMzzu OQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wd0911fvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 21 Nov 2019 14:52:11 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 21 Nov
 2019 14:52:09 -0800
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (104.47.49.57) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 21 Nov 2019 14:52:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iAnuWMiNsPhQ9TSUV+5PA0LzRJE1E/12wW6Lw67I/6bjbjycrj7UnXl+0J2fTJRky3jy+m7FJU0yQbHsGQNZIEXb4sg3Uncvz/dKfLwTtVpEg8eqxrleoP8+kjjmiFpZSFgLD2U/yuwL1BhTLF2ORNxJySlOjE9C6VNckSbFVkcRBnLS0R2wDf0SFl7K7sbkOY+xqmD7RkC5BlROflnLwC7v6b60vIQPmzlGC0qegTvC+BLfrbEhhkkNXxe/o72AGO1H6tKCw9HVzIxS4EbR1lu+pKB3TZPmKCEnrXrZCGKYcKH0R821Zovth7hSTKoylQZ6bPwhJqkoDyvMSnU4pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+yFOEVuqSkbxubLiXaygKhmj0sDOCgn8LRik2dntSr4=;
 b=DeI2vtcr2HaWvTm1ugFBTpvYdMtQUa4YieL2kRG1TpnzcQGyq2dQIdpLF2evdzHm5Sd5hILNXP0UAJM49PmVXKVbaTE3xQ1oNFj56g7gYiW4ygf2BSe32rdzzFF08033uGPW454f38unsxdob0Exx4CytKJxvFtFSlrutBezTLNudDqkdWvjCfC1vhZJSbRRZUm57SX6Q37/m8kaZxiLX7S2kfFmnUNk48HRANrEFYs2nrAVl+dsJPOUeGWoBhNPFPIkDAG7irdPlCeN7w+tGho3ppo3p2Z3R263YXbDD8BunXtmHluXu/+Ka3DVoKIshz4lsc7G28CE17VYlKHq/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+yFOEVuqSkbxubLiXaygKhmj0sDOCgn8LRik2dntSr4=;
 b=KTIhcGclhZocbQtDq1bW2wnV+fGJaCCsHYsvT61i6DFrOhWGSLy6wZk8pbu8SU8ngPyLA6fe5pz1xyQj04K5FNiMAduuheiHnLOkqpuLVuh3vCVrTcbBav2sdjvsQYYsaRCZS8kJ4PFb1bwLUMH17g1F730thq8mkHyv75q67Xc=
Received: from BYAPR18MB2759.namprd18.prod.outlook.com (20.179.58.88) by
 BYAPR18MB2855.namprd18.prod.outlook.com (20.179.58.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Thu, 21 Nov 2019 22:52:08 +0000
Received: from BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::5907:fd6e:ff93:426b]) by BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::5907:fd6e:ff93:426b%7]) with mapi id 15.20.2451.031; Thu, 21 Nov 2019
 22:52:08 +0000
From:   Quinn Tran <qutran@marvell.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux@yadro.com" <linux@yadro.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: RE: [EXT] [PATCH v2 14/15] scsi: qla2xxx: Add debug dump of LOGO
 payload and ELS IOCB
Thread-Topic: [EXT] [PATCH v2 14/15] scsi: qla2xxx: Add debug dump of LOGO
 payload and ELS IOCB
Thread-Index: AQHVn/HG+JWyoHReOkatLFnzgIK3YaeWPK6Q
Date:   Thu, 21 Nov 2019 22:52:08 +0000
Message-ID: <BYAPR18MB275952D745988ACBAFC8067FD54E0@BYAPR18MB2759.namprd18.prod.outlook.com>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
 <20191120222723.27779-15-r.bolshakov@yadro.com>
In-Reply-To: <20191120222723.27779-15-r.bolshakov@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.186.1.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f809eee9-6c31-4f7e-ace9-08d76ed57016
x-ms-traffictypediagnostic: BYAPR18MB2855:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB285516BB7167A063AC0F940DD54E0@BYAPR18MB2855.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:166;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(396003)(136003)(39850400004)(199004)(189003)(13464003)(6246003)(2906002)(186003)(26005)(6116002)(3846002)(2201001)(66476007)(229853002)(86362001)(102836004)(4326008)(107886003)(66446008)(66946007)(76116006)(66556008)(64756008)(14454004)(33656002)(446003)(25786009)(11346002)(76176011)(6506007)(53546011)(478600001)(316002)(7696005)(71200400001)(71190400001)(110136005)(52536014)(81156014)(81166006)(8936002)(54906003)(8676002)(9686003)(2501003)(7736002)(99286004)(6436002)(305945005)(74316002)(256004)(5660300002)(55016002)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2855;H:BYAPR18MB2759.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4CmrvvfNeGzKOv0YxrY1MoTbfbgeevg5+2GHgdTEtsGc6U+GEG5AZrO+bs9zIAWPYgq0fomIdL+HVOqG9kMQRMOCyCp1L/85jMuOhQxALpMAUF1B2UrpyiN93d7qXadyK8tDH84PeQtlA2a+ZdN5C2ncOuHnwTj7F+9ZJBl4fjgbdEl086Uz3NBJy6fKZNk7H3Tlx7cB14xmbkgTQD7NNS6zv0yihtypth3ah9tW+mXHXUZqJEzZ7YmH34+HzheG9QYqOY1SVP204Lz7AbCNhLz3JjTX961P8eh5YPXtux0T5bqax7SMWtoj5Fo4x36ynC6Y1AsCWcIudLuxQrBXSz0wD9xBH6KirZyRdc4bW/E8IR2DZWM1Xn2ypVIRRRJB7kaf2pgQ1Xa7GatdjcU98+HlPGt70GRAQY9WMUaCjUHT4RVMirqDqvYudrYRzhwE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f809eee9-6c31-4f7e-ace9-08d76ed57016
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 22:52:08.2329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qaZw0UkDz47fB+F1hSvxMw4OpH7IIYwbQpvvR5EuZydAEpb9hqYwbgQCxo230y6m3PvJPCizGzn60bcDoDnhvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2855
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_06:2019-11-21,2019-11-21 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good.

Acked-by: Quinn Tran <qutran@marvell.com>



Regards,
Quinn Tran

-----Original Message-----
From: Roman Bolshakov <r.bolshakov@yadro.com>=20
Sent: Wednesday, November 20, 2019 2:27 PM
To: linux-scsi@vger.kernel.org; target-devel@vger.kernel.org
Cc: linux@yadro.com; Roman Bolshakov <r.bolshakov@yadro.com>; Quinn Tran <q=
utran@marvell.com>; Himanshu Madhani <hmadhani@marvell.com>
Subject: [EXT] [PATCH v2 14/15] scsi: qla2xxx: Add debug dump of LOGO paylo=
ad and ELS IOCB

External Email

----------------------------------------------------------------------
The change adds a way to debug LOGO ELS, likewise PLOGI.

Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_ioc=
b.c index 12b37b711ae8..cd2e0f89e9b5 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2627,6 +2627,10 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_=
opcode,
=20
 	memcpy(elsio->u.els_logo.els_logo_pyld, &logo_pyld,
 	    sizeof(struct els_logo_payload));
+	ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0x3075, "LOGO buffer:");
+	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x010a,
+		       elsio->u.els_logo.els_logo_pyld,
+		       sizeof(*elsio->u.els_logo.els_logo_pyld));
=20
 	rval =3D qla2x00_start_sp(sp);
 	if (rval !=3D QLA_SUCCESS) {
@@ -2704,6 +2708,11 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24=
xx *els_iocb)
 		els_iocb->rx_byte_count =3D 0;
 		els_iocb->rx_address =3D 0;
 		els_iocb->rx_len =3D 0;
+		ql_dbg(ql_dbg_io + ql_dbg_buffer, vha, 0x3076,
+		       "LOGO ELS IOCB:");
+		ql_dump_buffer(ql_log_info, vha, 0x010b,
+			       els_iocb,
+			       sizeof(*els_iocb));
 	}
=20
 	sp->vha->qla_stats.control_requests++;
--
2.24.0

