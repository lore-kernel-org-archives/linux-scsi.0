Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15DEC432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 22:52:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C62B2088F
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 22:52:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="LP6PA7HI";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="Wf8rhbN2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfKTWwX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 17:52:23 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:63392 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725820AbfKTWwW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 17:52:22 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAKMq5wV005874;
        Wed, 20 Nov 2019 14:52:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=263vAFP9khVXczDAf0nOcZfT9OenP4p1TRYN0uXGzTU=;
 b=LP6PA7HI2X+djyuh5KD0BJKR1Xf6f7kqMvRMBZ8EFncg3mFgVrCJX0J/ydDvPqdQg5sK
 xibWTsLVwk9BNWnFjSykp4m0N1rYu3A9jaccqXRspO+616s++JEIrtqMOp7ZlghFVm00
 FaNmYv4MMzpcDHkBrT57rKmLord+jXFWU9t3Vkg0n7MA6MyHKVs1L79p4R2O7sn5pFvt
 X0ZJluDt9goIzaLYOyBiJ81OqphYi3h5nrlbCjrf0xQ9AlPXT02+sXLpxfAbabzm6bjF
 DFdSvoWQM96gHhBhZHy6UyMFOgQilV24r5MtXpdayQEDLlS60qjIbX4UCmEDBZDhTl+c 5w== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wc842a989-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 Nov 2019 14:52:20 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 20 Nov
 2019 14:52:19 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.53) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 20 Nov 2019 14:52:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8b5bKiMONsU9jpMpY/Dxm4xCiwE8SyCzr99/4B11PTSCGUUEZ9QJ3zOWYj6aNbmOMRAS88AWQjFuTgJrlfdUxph9kXUJhDLMVrUrPJUKnHuWiwyS+Tgme/k3EIIQBITcoXrj6Bcala2ZdmbZxHOwOsVJF8MUg/0Oo8RZhIHXhRWNz7kDRfT8jL+6lAgqwC6KJKlfFCM4WL0YitPSvWfA90h9Rhr5MCm4irXhtnhZh/1TRdRYFlAp9YGexgELJxrYCb/yKwKsofABxV30U3Y91XaJPJDVasDtWSvnKkgX8R3cMM0UnrgmTm5Do8akADm0fLS4lwCRGHMXycnb7TEcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=263vAFP9khVXczDAf0nOcZfT9OenP4p1TRYN0uXGzTU=;
 b=FZSO/DrkMlsh+M4Bm2HRi1JIjukuM4FSGxBzriY/QXG1b9+dH2Ksf5mxLPT7ctkLtjPcSB2USiPf42+SpJISIzc5IN+KMW8ElcSaLiHC5/D0kcXZxzwMXdAfkEm1kBH+VdqqJJ5qIExYhbBtumg1UzM+qbMOKDSthoz26Pqrazf5xcMoFg1mZx8E8houQOts3mlqcnj5YkhekJdrxvii89LEGgdiSMU37Xul57yoK/G0JMNosUy9OYwr/jeCvayl0pFv+bbs1Qu9nEslFNlUDygHEcx8LJAuYfsZTQ39GC8T1BhJl/tfnJyQo/FeYTo+sOnZL3HInMiF60sqrHZ6aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=263vAFP9khVXczDAf0nOcZfT9OenP4p1TRYN0uXGzTU=;
 b=Wf8rhbN2a0qPjFLtlE/XxArhl+WcOLNLg+WqC+GVlv2IsNazZTDjefCbsK/GSHndZFc2+HTxpmOX6dA8QgPtFMosml4l4ceZB4oRLidqnT/ApP4wCcp39S18vlmOb4oLlXvvs4YOE4MSJIXYU0nb5QYCXgcsKqxtXtNoHdpKUvE=
Received: from BYAPR18MB2759.namprd18.prod.outlook.com (20.179.58.88) by
 BYAPR18MB2358.namprd18.prod.outlook.com (20.179.91.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.30; Wed, 20 Nov 2019 22:52:18 +0000
Received: from BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::5907:fd6e:ff93:426b]) by BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::5907:fd6e:ff93:426b%7]) with mapi id 15.20.2451.031; Wed, 20 Nov 2019
 22:52:17 +0000
From:   Quinn Tran <qutran@marvell.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux@yadro.com" <linux@yadro.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: RE: [EXT] [PATCH v2 05/15] scsi: qla2xxx: Allow PLOGI in target mode
Thread-Topic: [EXT] [PATCH v2 05/15] scsi: qla2xxx: Allow PLOGI in target mode
Thread-Index: AQHVn/HLF/c1nNAZDkSAUzug3UCEB6eUqN2Q
Date:   Wed, 20 Nov 2019 22:52:17 +0000
Message-ID: <BYAPR18MB2759F79A6F217771C44CDF0BD54F0@BYAPR18MB2759.namprd18.prod.outlook.com>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
 <20191120222723.27779-6-r.bolshakov@yadro.com>
In-Reply-To: <20191120222723.27779-6-r.bolshakov@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.186.1.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc8beb42-f228-45d9-3029-08d76e0c4b61
x-ms-traffictypediagnostic: BYAPR18MB2358:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2358B90BB8D0E375EA8209E4D54F0@BYAPR18MB2358.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(346002)(366004)(39850400004)(136003)(189003)(199004)(25786009)(186003)(486006)(446003)(11346002)(55016002)(2201001)(5660300002)(110136005)(54906003)(71200400001)(71190400001)(316002)(6506007)(66946007)(76116006)(74316002)(66556008)(66446008)(64756008)(66476007)(66066001)(256004)(99286004)(2906002)(7736002)(305945005)(76176011)(7696005)(229853002)(478600001)(81166006)(8936002)(8676002)(476003)(14454004)(81156014)(4326008)(52536014)(26005)(86362001)(9686003)(6436002)(107886003)(102836004)(6246003)(2501003)(3846002)(6116002)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2358;H:BYAPR18MB2759.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rDCoSEpnBlI9nq0rr7LJ9BV2qoQLHEVBVeILtJa5yzm/sGdydZNlTJpD5Ya4ZaaG1isQIVOsOSMuGKTOsEQxf11t3hiE95wgizgyoKGGNYknENVZtIVM+yyw/OKP3aKrpzRo5jT20+XQaXldHCvpGDmF7nmHkme6/swAXjGk2ZDphpl8kxjk9lvKGpQDtdsy9/lNyTjbXPiBaRr0JoSOJ8MR/U/9FszZ0PIUIBGw9bk8ebSE0WxCk7eMWSh6p74MvnOQKqREzYN8qhiBhEMJCILgiLG+j3q6VgtpDQiDMkpCNB2GBHUCTZD0QwdZgW5FO2sdWJqicE9FLtvfqmE33O0v2HaS3xOLVewUziTC2SMzvJ8MXXKDSIopxtyOoSZKPSHACJITwQZuRSlC64Yh5piVygrZJrTwDyjcK9WRsG+hAeRqcYWQ+/2hrfftJohK
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fc8beb42-f228-45d9-3029-08d76e0c4b61
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 22:52:17.8348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CnAIjVaXpYnA19f5B+SiFo8n25JI64FBhwycVFyEtOj+nekzJa4pbKjuPHLy2QjYlkNn0LEXIX+bbWNdKILHMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2358
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-20_07:2019-11-20,2019-11-20 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

According to FC-LS-3 (Fibre Channel Link Services) 6.3.2.4 "N_Port Login - =
No Fabric present", if both parties in the point-to-point connection know N=
_Port_Names of each other, Nx_Port with the highest N_Port_name shall trans=
mit PLOGI. The specification sets no restrictions on the port role that sho=
uld send PLOGI.

However, FCP-4 (Fibre Channel Protocol for SCSI, Fourth Version) 6.2 "Overv=
iew of Process Login and Process Logout", instructs that in point-to-point =
topology, initiator shall send explicit PRLI ELS.

The change fixes stuck P2P login, when target WWPN is higher than initiator=
 WWPN.

Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_ini=
t.c index fcb309be50d9..12391815be06 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1527,10 +1527,6 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host=
 *vha, fc_port_t *fcport)
 		}
 	}
=20
-	/* for pure Target Mode. Login will not be initiated */
-	if (vha->host->active_mode =3D=3D MODE_TARGET)
-		return 0;
-
QT:  Nack.  Leave this hunk.  Instead do this

if (vha->host->active_mode =3D=3D MODE_TARGET) && !N2N_TOPO(vha->hw)

--


 	if (fcport->flags & FCF_ASYNC_SENT) {
 		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 		return 0;
@@ -1720,6 +1716,10 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *v=
ha,  void qla_handle_els_plogi_done(scsi_qla_host_t *vha,
 				      struct event_arg *ea)
 {
+	/* for pure Target Mode, PRLI will not be initiated */
+	if (vha->host->active_mode =3D=3D MODE_TARGET)
+		return;
+
QT:  Ack.

 	ql_dbg(ql_dbg_disc, vha, 0x2118,
 	    "%s %d %8phC post PRLI\n",
 	    __func__, __LINE__, ea->fcport->port_name);
--
2.24.0

