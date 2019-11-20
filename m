Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82DB7C432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 23:06:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E2BF2088F
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 23:06:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="VIbJQgeL";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="tIMSnXHH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbfKTXGU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 18:06:20 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17880 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725842AbfKTXGU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 18:06:20 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAKN05oK024264;
        Wed, 20 Nov 2019 15:06:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=+HkOghZ0vte+caUZWxKwUYdUipQExAN4vuQcIYGqp2c=;
 b=VIbJQgeL5RC1qw31qfWLMlDkdOPz/HvAC5ZJiu6cUeVuYnJFSEGVo8vZ7r1sF+y8dK4b
 hiKg588R/vITY2flT86FnjM/DQgL7hev2gcqxm/BTDhLDTSXF7zeeIhqmK60rxF4TYO5
 1WdE/DLlnOZNe5ltFp9lQRHEsI/emYsgb0DskHBwrmf8d1H0//IIiyzr2SM7QTM87QKq
 nnWNIE0M0P6LOlq5rOkzJt2GGeHi73iL4Kb0chwSCd9hgc7lmrjyzMHHqyXSLnnaVRq5
 9mQn1Z1u4fwH6WlscvMT6w3PGAYLwjoC+SkZeYYHrqRgReF0tJ+9Zg0+VOmdQQR+O5kO 1Q== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wd090uvr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 Nov 2019 15:06:18 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 20 Nov
 2019 15:06:17 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (104.47.32.56) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 20 Nov 2019 15:06:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5himkJwzoLfw+GcZmHaaWSK0PxAT1zZ3v34Br00RxhuDmpBeJtw8kQxeJBOXJwxQCB4QpKRWGlXiDZrjqjPtcJO9Xekjq2YlCbuXbw1Qud2gsLUP0wAyzDytt+81ux+jDd+HVl3fWBsuGDykJPU+p116ArlDXEZfZDMg42ZJktHgOvR+sqtJpk174dOdWOewH8HmQPmefXgiVnQw4v83vaxkYz7HbWx4lBq0fk0EFje3xPG6tqjdyWiWYbKvBO0aA28hEYoUUMgQVg/ETNzLLVxwSBSXr0HrCXfrrifo+m6B2BTpoA0Pe4GM+ky1gg85zdv1B3J35sRJa/Lp/ULbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+HkOghZ0vte+caUZWxKwUYdUipQExAN4vuQcIYGqp2c=;
 b=h3e6QVXxUsPSyGIivtary4YhuLvzkjg6ADtrp4yE1kAkrG2d9aiUzvN4HX3SK40PU8ybQ0ZmLVUxMtNYyy8Falk3dBii9AduNQKEXssFpz68kT91R6X2iDwLVQ3VbHb+6/1za6zSHyeJOwxpszGrvW1+Cu/6JQ0W7sInlIfJ7EVuK1xr5dDgIvYdEClw0ihkGfPKoplO5vmlrERf1lFmx2xEAM5GRaBkd/Z4KOGbDuXEZTNBCyLdUywQ+pQU2BgPvIyEiX9RtNCSWDZAK/ZH6nJmw7zUbDuitfo5+o/QdRNnU9KqpycYsBRIxJ34F83vBb5PGGM0TCrNeiI07X58IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+HkOghZ0vte+caUZWxKwUYdUipQExAN4vuQcIYGqp2c=;
 b=tIMSnXHHNqDFJgWiAJ2/Z7nKPZIRVZpueC7h7qET90NzBuiyI6qU/bsMizXPYlYfHntWDHNNEhCi55iGEV7tzhZQGWXgxKmzvpZkXeuJCs+mbJIoYF+DA2/5vvgzWAsSWrL7qTiQMY7HXpKFUriD515QfPlq2eFMoculllrK3yA=
Received: from BYAPR18MB2759.namprd18.prod.outlook.com (20.179.58.88) by
 BYAPR18MB2901.namprd18.prod.outlook.com (20.179.59.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Wed, 20 Nov 2019 23:06:15 +0000
Received: from BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::5907:fd6e:ff93:426b]) by BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::5907:fd6e:ff93:426b%7]) with mapi id 15.20.2451.031; Wed, 20 Nov 2019
 23:06:15 +0000
From:   Quinn Tran <qutran@marvell.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux@yadro.com" <linux@yadro.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: RE: [EXT] [PATCH v2 08/15] scsi: qla2xxx: Configure local loop for
 N2N target
Thread-Topic: [EXT] [PATCH v2 08/15] scsi: qla2xxx: Configure local loop for
 N2N target
Thread-Index: AQHVn/G+aq6zOc1fUkaqNHqfOxUOu6eUrXOA
Date:   Wed, 20 Nov 2019 23:06:14 +0000
Message-ID: <BYAPR18MB2759EA9C77A9CD0807F43AC0D54F0@BYAPR18MB2759.namprd18.prod.outlook.com>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
 <20191120222723.27779-9-r.bolshakov@yadro.com>
In-Reply-To: <20191120222723.27779-9-r.bolshakov@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.186.1.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e4e57f7-a9df-4c26-a67b-08d76e0e3e68
x-ms-traffictypediagnostic: BYAPR18MB2901:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB29011E514A615AD9E3D81923D54F0@BYAPR18MB2901.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(39850400004)(136003)(346002)(199004)(189003)(446003)(52536014)(256004)(476003)(14444005)(9686003)(4326008)(486006)(7696005)(2906002)(26005)(8936002)(186003)(76176011)(11346002)(6436002)(5660300002)(107886003)(55016002)(6246003)(6506007)(81156014)(99286004)(102836004)(305945005)(229853002)(66066001)(316002)(86362001)(81166006)(6116002)(14454004)(71200400001)(76116006)(2201001)(33656002)(74316002)(66476007)(66556008)(2501003)(66446008)(64756008)(66946007)(7736002)(25786009)(54906003)(71190400001)(110136005)(478600001)(3846002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2901;H:BYAPR18MB2759.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SqadPqDhFMO8+MC/rF/vNnJl5rMGJvASVZWTfpoDRpY54429TZpf8hnJPvE+PFoaIzAyzoeXYaJyz8Dt/nSMtLutYpFTIPed9HKvSHedWS+GUpxeHu6NptHbxf2fs8+eQdymGtArWk9REbu1Iaoi0k7cyZLrdMtqNr4IJqdxict3iUycDy8FpeEBYrXPo3ZFd2OBOXjIOyukQJtafTyy7oXEtGNTOltkr2gn+L88nKUupKomot42uzzkspbe2QcevQon/kzlgyNXT6eioTar3OENxmnbT/vUWSpjAYAaAiFCATlprxMVoOQGXHH8fhmH+ctezcecEYbbFID2TegF44Gk7vIsJEtHpkqor8LK5KVi5rBGIK1OdMnH5kxPrhsXcwExhzt2knEiJsmLxOux9mAf7pDN3nRCnr143XlOc49OEsI6KiD4pjUl9VIzhv8z
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e4e57f7-a9df-4c26-a67b-08d76e0e3e68
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 23:06:15.0078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8M9PLF30ZSYa6Sv98XoU9Ym7UufzxaBJ36jZMGWiOMqJi04v4HTONieaVJlpm0GARN5vUmd6RhlEQZyydTSODg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2901
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-20_08:2019-11-20,2019-11-20 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

qla2x00_configure_local_loop initializes PLOGI payload for PLOGI ELS using =
Get Parameters mailbox command.

In the case when the driver is running in target mode, the topology is N2N =
and the target port has higher WWPN, LOCAL_LOOP_UPDATE bit is cleared too e=
arly and PLOGI payload is not initialized by the Get Parameters command. Th=
at causes a failure of ELS IOCB carrying the PLOGI with 0x15 aka Data Under=
run error.

LOCAL_LOOP_UPDATE has to be set to initialize PLOGI payload.

Fixes: 48acad099074 ("scsi: qla2xxx: Fix N2N link re-connect")
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_ini=
t.c index 12391815be06..096f41fe17d2 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4932,14 +4932,8 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 		set_bit(RSCN_UPDATE, &flags);
 		clear_bit(LOCAL_LOOP_UPDATE, &flags);
=20
-	} else if (ha->current_topology =3D=3D ISP_CFG_N) {
-		clear_bit(RSCN_UPDATE, &flags);
-		if (qla_tgt_mode_enabled(vha)) {
-			/* allow the other side to start the login */
-			clear_bit(LOCAL_LOOP_UPDATE, &flags);
-			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
-		}
-	} else if (ha->current_topology =3D=3D ISP_CFG_NL) {
+	} else if (ha->current_topology =3D=3D ISP_CFG_NL ||
+		   ha->current_topology =3D=3D ISP_CFG_N) {
 		clear_bit(RSCN_UPDATE, &flags);
 		set_bit(LOCAL_LOOP_UPDATE, &flags);
 	} else if (!vha->flags.online ||
--
2.24.0

QT: ACK.

