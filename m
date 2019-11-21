Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E78C432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 00:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AE6120878
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 00:03:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="k0djxuUj";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="RXtsZDIZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfKUADF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 19:03:05 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50148 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725878AbfKUADF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 19:03:05 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAKNuPgt014509;
        Wed, 20 Nov 2019 16:03:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=8cgcpfG0dFQwNKqFtP46a24EhqoN1rxitqSanQnXtG4=;
 b=k0djxuUjsSt+XIQtWXEnHgfPQVxU1xRLPuWaI1I+n9fcP6r2z9gCLooqBWLWkkLf9cH0
 tExwg9knBL/1LKqBD78kAGOBEV285oFlSCNZbwxBdkp4SPTQuXymCJk58Z2dPKgZZzbd
 F5kVH04Fc39JgV6xr2XXsM19KDHD27Eh+AZ10715A2/eHrZwy7lt/7zWJLP4Q65SunKU
 syLIk7WtWmWn6hNwlepAWT8FNG0ogHFhu1MGXgwOugunc1kQhK61laeSTYWQOS2N63hS
 BW9TRXnqTKSsCITivh6zBnrIyoB0WWqlCamV9BCtGc0RFw1uCeL9mSCHlsMcaKkJIpNP ZA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wc842ahwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 Nov 2019 16:03:04 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 20 Nov
 2019 16:03:03 -0800
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (104.47.49.52) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 20 Nov 2019 16:03:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BAgj+Qd2Dzhz8UxouZWr/jxpdTA4KIyKmqlPfSq33tEU+mcx/WNAO0hnzIVmjS9p1uqgwYawIVXAs+Brx2039IkwmUhqAEygnwuxwuK69CMraNPiX+q0fknUm4ViGwVbbW2EpP7GBBXCiq+9uTiU43TtkEyrrtSzCY+eSzQZoBgirj2D6POKyVDtzlM86zn09eYvn1UDk7vKWtcgfn0B0/uqOXuYIUM0wrJVCgNpj0jlJOEOggH53R60Nu1CempWSnJYfAsTjIVNyTm1OWtd8XWHi/rx9AZwlgjv3VbB3HZscB2zWISNswDlMJ/DCjc/0DXkbLgrq3hCWCeiWzi+qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8cgcpfG0dFQwNKqFtP46a24EhqoN1rxitqSanQnXtG4=;
 b=Asquq5DumSR03WqFBl0HrypyMooN03raN0vnzVX5HXyD+yGxQbcM8HJKvbEEs1ao737RkOqjqZ+DYLPdfXUhgFs5j9mUgBh/GlOhkzDpAyHHEonbHmpFXm3knVOKJId0VIDYe6/5NOPm0DzM7rqNxUBkMSlKKz+ILGKJIVuHV+GjRdqnQ0geQkvtZHlGGOrGmN6ct0cshS+ef+qaHFjITXTM+BAQ4R1uOHZoWQvbGac1Y7mjD9jMcSt/fog34rLLHNo1NDCV3ZY+Wx5TJxg4J5jqV6jeZ6j8JxGbFe/FDAaUeQ4Gq3WuGYJxqIrB0orqCdUU4HfKTLtB3yrG9r0Htw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8cgcpfG0dFQwNKqFtP46a24EhqoN1rxitqSanQnXtG4=;
 b=RXtsZDIZ2jorYjr9Z+GFPOP/gpqF1Ef9STcAdkbgssP1Ve4uA2MsvBNgiZseTUH/oIG/cU8tsIo/WMpUOdBwgz3mB+/C3/a81NtAC5CvqId9rnZSgCPg2fnWoxWjq/OPIxM6yEvBXtds3ewmrRGsui/kK2D4/mLIiyPpHXVxjWw=
Received: from BYAPR18MB2759.namprd18.prod.outlook.com (20.179.58.88) by
 BYAPR18MB2454.namprd18.prod.outlook.com (20.179.94.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Thu, 21 Nov 2019 00:03:01 +0000
Received: from BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::5907:fd6e:ff93:426b]) by BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::5907:fd6e:ff93:426b%7]) with mapi id 15.20.2451.031; Thu, 21 Nov 2019
 00:03:01 +0000
From:   Quinn Tran <qutran@marvell.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux@yadro.com" <linux@yadro.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: RE: [EXT] [PATCH v2 10/15] scsi: qla2xxx: Don't defer relogin
 unconditonally
Thread-Topic: [EXT] [PATCH v2 10/15] scsi: qla2xxx: Don't defer relogin
 unconditonally
Thread-Index: AQHVn/HCmWeiFkLWikKy4v0ZYoCbhqeUvekg
Date:   Thu, 21 Nov 2019 00:03:01 +0000
Message-ID: <BYAPR18MB27594A332DE1F7E0AC70B227D54E0@BYAPR18MB2759.namprd18.prod.outlook.com>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
 <20191120222723.27779-11-r.bolshakov@yadro.com>
In-Reply-To: <20191120222723.27779-11-r.bolshakov@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.186.1.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c3e5d2f-311a-4cd1-3b50-08d76e162cd6
x-ms-traffictypediagnostic: BYAPR18MB2454:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB24545E6F6954385DC99D92EDD54E0@BYAPR18MB2454.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(396003)(39850400004)(376002)(366004)(136003)(346002)(189003)(199004)(478600001)(33656002)(2906002)(476003)(486006)(66066001)(71190400001)(71200400001)(6116002)(3846002)(11346002)(446003)(8676002)(25786009)(66476007)(66556008)(64756008)(66446008)(66946007)(110136005)(76116006)(81166006)(8936002)(14454004)(81156014)(54906003)(2201001)(74316002)(7736002)(2501003)(4326008)(229853002)(7696005)(76176011)(86362001)(305945005)(6436002)(55016002)(9686003)(99286004)(5660300002)(6246003)(107886003)(14444005)(256004)(6506007)(186003)(52536014)(316002)(26005)(102836004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2454;H:BYAPR18MB2759.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kYL5gB/OGv1mgSAPQOx6Tdl57XeG35RW5PVH3wBzTEwyICzAU+pIfn0nYWJVzJWppxNM7aP4aa+FdcWI4KXieP45Pekevr2gpfg4t28PI4N+HBViERd5YBaDDI0UIjjvx/M3M8G1zlVIDPUNSGshw0bHUPDWYgsJXXMVJDPR72tAZLD3xn/aJIKY9ndupebgIOEt/VgnG3KX8M5Z16eG951rRySqKOm1P4XajjiIjdpsDeG5roLS89shP9OEbYegme4vcOD1KGONWcidSa2ud7O8ZAoCFEq8mga7DYITYuimqkmc5yym2oG7uza7kAWmCipdkZ3/dfjBOuVVOfXrdw46xSknCH6K5MvLtUsF1OghttUrY3ImyGyJHjIPHsL9oxM94+dLtvuRw6W3Nu9Z7RWIOqCq5PRiPPee6UFiBCZT4snL/VXLpxmArXmFuuHH
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c3e5d2f-311a-4cd1-3b50-08d76e162cd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 00:03:01.5748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OjI/lX7aoIpLgjZDqY4KofqUaz7IYKuZMzlnUxkDU6RT+iT+VcOfMWLSffSCH4i8U061wBiMkInuEyRDKMtG4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2454
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-20_08:2019-11-20,2019-11-20 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good.

Acked-by: Quinn Tran <qutran@marvell.com>


----------------------------------------------------------------------
qla2x00_configure_local_loop sets RELOGIN_NEEDED bit and calls qla24xx_fcpo=
rt_handle_login to perform the login. This bit triggers a wake up of DPC la=
ter after a successful login.

The deferred call is not needed if login succeeds, and it's set in qla24xx_=
fcport_handle_login in case of errors, hence it should be safe to drop.

Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_ini=
t.c index 096f41fe17d2..e984746e7428 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5050,7 +5050,6 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 				memcpy(&ha->plogi_els_payld.data,
 				    (void *)ha->init_cb,
 				    sizeof(ha->plogi_els_payld.data));
-				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 			} else {
 				ql_dbg(ql_dbg_init, vha, 0x00d1,
 				    "PLOGI ELS param read fail.\n");
--
2.24.0

