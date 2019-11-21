Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B25DDC432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 22:51:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 610E2206DA
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 22:51:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="PHLgzlse";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="c12VNdr4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfKUWvC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 17:51:02 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44120 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726351AbfKUWvC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Nov 2019 17:51:02 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xALMoOYO008606;
        Thu, 21 Nov 2019 14:51:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=QOTs5Len0w8YPy2wjeqGqioOcpQmLtaSxcj4kBhDKN0=;
 b=PHLgzlse1mDMAbjGVgztSac26WLXvdHkpdvbq1PvhrBElN6SKclJvkaSMqWc4r7si+ID
 eVP/R/Fl8PuMqlz26UId2eMN0X8q3FlHavoRGeOh0tsRNkD3tItr98eQUV9PJx7LK0NL
 rFln5dS0FRsG8Ok6bkG8MeifQNfron3G5lIr4edE8J1sbpEniV0TggzLuiym8IMGWnjL
 4+T8C9+bWxi4TDc82VbELEwK/jf7HFstIZs0wIe44hxEuwjMQJxM2qUIvYhHawGW9lhZ
 G54G5VdQHuIa5I8zPgN8l3q0otYMG5GPNW4roCNu1l9PUCdNaQQfHiqK2nfdNpCri/3B Xg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wc842g5m3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 21 Nov 2019 14:51:01 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 21 Nov
 2019 14:50:59 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (104.47.48.58) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 21 Nov 2019 14:50:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LTD2/8+XgN1msbiE/tkEfhh5BGZ7jpNfB6uUvdTRz991muPuVAQFEaKHe9CauvNvgy9S0vfzk7UzksX1IxO60WE9Ln66uaKckcVQnzZkp/NDVywb50X++Fg21JBiqRB8F3BPTPhjdGUZ07o766m8wG7nzCRWqLmCk1xp+PERC3vgACEAwEO7+zXV8N32QpLVG91m8lLOq16v0Mk1PPWl8xMGCQChZZhYt88QCZJe4vC9OtNvqLOZ/ByQ0y1oTF4Xn1iiUyTTUWmZ2rHWNxQCkG7d1pVRna5dtXmXYRPu2ArxFqi6ZqY3oJXcEGFqMTYDlarZCiPV/Iz0n3jnnboYPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QOTs5Len0w8YPy2wjeqGqioOcpQmLtaSxcj4kBhDKN0=;
 b=CFuHRDx4PV48p6Su31L5pYV3mbmhh56BPlQGWgHCFXuc14D58NFXjZENnI4U8iswxrhFYuAr6e/J38qiFowcGPPwddZJrziU+ScbOJEOVOMDBix0ehs33fIalwlQ1/gzkA5wKbQmQHhGMg5ormbv0ghSJK0D7p9JAdhm5fWF1H6Vz8m83QchO1yN0cAbsJo3HFnV76NjulwNF87xDWO5HWoFBN+EDSJ+SYgWD5aYPxXT2+J05urzCeAd0+XJGuiPoEBeMpGxGvcms2RwOaHa14PnIJN9ArwDdWYJOjzOIv7UIeviraJc4z5Pw7PQpM++JntUWDrlbLVwN8YoCQ57Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QOTs5Len0w8YPy2wjeqGqioOcpQmLtaSxcj4kBhDKN0=;
 b=c12VNdr4xIBjzQaDAppBAE7DGPdinCC0HLDtYeUJcBwOnTHgaR0dXtzNFDJNTP9/DdkIChgZQ6s6xFP6WIbzWB2yAeCZh3DQwtYk2y6wt0/zdQXnQ/hnBIHFULAn/dynAmgZs6Ttk3VEgvo3Ivl83lzYS6JXWGqADjvyaF2R5rM=
Received: from BYAPR18MB2759.namprd18.prod.outlook.com (20.179.58.88) by
 BYAPR18MB2855.namprd18.prod.outlook.com (20.179.58.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Thu, 21 Nov 2019 22:50:58 +0000
Received: from BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::5907:fd6e:ff93:426b]) by BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::5907:fd6e:ff93:426b%7]) with mapi id 15.20.2451.031; Thu, 21 Nov 2019
 22:50:58 +0000
From:   Quinn Tran <qutran@marvell.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux@yadro.com" <linux@yadro.com>
Subject: RE: [EXT] [PATCH v2 13/15] scsi: qla2xxx: Add async mode for
 qla24xx_els_dcmd_iocb
Thread-Topic: [EXT] [PATCH v2 13/15] scsi: qla2xxx: Add async mode for
 qla24xx_els_dcmd_iocb
Thread-Index: AQHVn/HNnHFaS7vbK06G1KxyqGbBA6eWPDug
Date:   Thu, 21 Nov 2019 22:50:58 +0000
Message-ID: <BYAPR18MB2759E4C4CDDA0D5447D7A5BDD54E0@BYAPR18MB2759.namprd18.prod.outlook.com>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
 <20191120222723.27779-14-r.bolshakov@yadro.com>
In-Reply-To: <20191120222723.27779-14-r.bolshakov@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.186.1.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2da7d900-07cc-4b6b-4599-08d76ed5465c
x-ms-traffictypediagnostic: BYAPR18MB2855:
x-microsoft-antispam-prvs: <BYAPR18MB2855B0FC33B1B696D2198775D54E0@BYAPR18MB2855.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(396003)(136003)(39850400004)(199004)(189003)(13464003)(6246003)(2906002)(186003)(26005)(6116002)(3846002)(2201001)(66476007)(229853002)(86362001)(102836004)(4326008)(66446008)(66946007)(76116006)(66556008)(64756008)(14454004)(33656002)(446003)(25786009)(11346002)(76176011)(6506007)(53546011)(478600001)(316002)(7696005)(71200400001)(71190400001)(110136005)(52536014)(81156014)(81166006)(8936002)(8676002)(9686003)(2501003)(7736002)(99286004)(6436002)(305945005)(74316002)(256004)(14444005)(5660300002)(55016002)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2855;H:BYAPR18MB2759.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 87Ncs/v0gP5YYulO+Yvgf+Gfov3myPBwwZOaaxkagKrow0QFyejYoubxtKu/bUUbFL9e8NB4hPP5Gt2f0iY4XHEsjzFaevSXeOKWtvWzY0wG6fBEFUiMq8Sfurr3nZtVjeBVXfZK5t6ysh4TTsAGcSkVkVaztZrPE7WCKLRH4DUyZyR7Nf2LQcgGeaafntThez7eLNIiRdX/7MQT7BsKnEFu5GAafjvKpsK1P5aBCWbWeLs2HyN4RGci3R+KgqmYoKBlOG0gdH54fgcssm3bU5vA9N8Xtw4sIkUziRzM8Hd5Hfotvl0wxCi3sc4pqPB3T8IVwi7PuzIVS/4jOzo1xQVVUEmcjTQf5+KH8uBx1ac6PnHFIWpLYi740dvzI1ZKxMA6a51jXvCwLubBB2HX/I5s1m6ipkJvzNgDiDr3mKQw0ijsIeFzjCn/XKCaNyEv
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2da7d900-07cc-4b6b-4599-08d76ed5465c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 22:50:58.2197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UE5W4TkXwHcgnyUZMEmbgwgaXvb/AZ1aX9kn8yCUKU91Q3P2bIANMtsclaIS9yBc1RgjyzntZIYisIyKWfwl6w==
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
utran@marvell.com>
Subject: [EXT] [PATCH v2 13/15] scsi: qla2xxx: Add async mode for qla24xx_e=
ls_dcmd_iocb

External Email

----------------------------------------------------------------------
qla24xx_els_dcmd_iocb() performs LOGO and might be invoked in contexts wher=
e it is prohibited to sleep. The new wait parameter provides a way to use t=
he function in such context, similarly to qla24xx_els_dcmd2_iocb().

Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_attr.c   |  2 +-
 drivers/scsi/qla2xxx/qla_gbl.h    |  2 +-
 drivers/scsi/qla2xxx/qla_iocb.c   | 11 +++++++++--
 drivers/scsi/qla2xxx/qla_target.c |  2 +-
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_att=
r.c index 481c05dbea06..35c703ec59ad 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -828,7 +828,7 @@ qla2x00_issue_logo(struct file *filp, struct kobject *k=
obj,
=20
 	ql_log(ql_log_info, vha, 0x70e4, "%s: %d\n", __func__, type);
=20
-	qla24xx_els_dcmd_iocb(vha, ELS_DCMD_LOGO, did);
+	qla24xx_els_dcmd_iocb(vha, ELS_DCMD_LOGO, did, true);
 	return count;
 }
=20
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.=
h index 5b163ad85c34..df0f3421e3bb 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -43,7 +43,7 @@ extern void qla2x00_clear_loop_id(fc_port_t *fcport);  ex=
tern int qla2x00_fabric_login(scsi_qla_host_t *, fc_port_t *, uint16_t *); =
 extern int qla2x00_local_device_login(scsi_qla_host_t *, fc_port_t *);
=20
-extern int qla24xx_els_dcmd_iocb(scsi_qla_host_t *, int, port_id_t);
+extern int qla24xx_els_dcmd_iocb(scsi_qla_host_t *, int, port_id_t,=20
+bool);
 extern int qla24xx_els_dcmd2_iocb(scsi_qla_host_t *, int, fc_port_t *, boo=
l);  extern void qla2x00_els_dcmd2_free(scsi_qla_host_t *vha,
 				   struct els_plogi *els_plogi);
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_ioc=
b.c index 53ccbd6b71ed..12b37b711ae8 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2562,7 +2562,7 @@ static void qla2x00_els_dcmd_sp_done(srb_t *sp, int r=
es)
=20
 int
 qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
-    port_id_t remote_did)
+    port_id_t remote_did, bool wait)
 {
 	srb_t *sp;
 	fc_port_t *fcport =3D NULL;
@@ -2601,6 +2601,8 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_o=
pcode,
 	elsio->timeout =3D qla2x00_els_dcmd_iocb_timeout;
 	qla2x00_init_timer(sp, ELS_DCMD_TIMEOUT);
 	init_completion(&sp->u.iocb_cmd.u.els_logo.comp);
+	if (wait)
+		sp->flags =3D SRB_WAKEUP_ON_COMP;
 	sp->done =3D qla2x00_els_dcmd_sp_done;
 	sp->free =3D qla2x00_els_dcmd_sp_free;
=20
@@ -2637,9 +2639,14 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_=
opcode,
 	    sp->name, sp->handle, fcport->loop_id, fcport->d_id.b.domain,
 	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
=20
-	wait_for_completion(&elsio->u.els_logo.comp);
+	if (wait) {
+		wait_for_completion(&elsio->u.els_logo.comp);
+	} else {
+		goto done;
+	}
=20
 	sp->free(sp);
+done:
 	return rval;
 }
=20
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_t=
arget.c
index 68c14143e50e..0f2bc4cd562f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -932,7 +932,7 @@ qlt_send_first_logo(struct scsi_qla_host *vha, qlt_port=
_logo_t *logo)
=20
 	mutex_unlock(&vha->vha_tgt.tgt_mutex);
=20
-	res =3D qla24xx_els_dcmd_iocb(vha, ELS_DCMD_LOGO, logo->id);
+	res =3D qla24xx_els_dcmd_iocb(vha, ELS_DCMD_LOGO, logo->id, true);
=20
 	mutex_lock(&vha->vha_tgt.tgt_mutex);
 	list_del(&logo->list);
--
2.24.0

