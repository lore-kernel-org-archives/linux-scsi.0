Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B029C432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 23:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAE312075A
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 23:53:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="T1aNzAsc";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="bZAKTlaK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfKTXxt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 18:53:49 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48780 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725878AbfKTXxt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 18:53:49 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAKNpBU0002206;
        Wed, 20 Nov 2019 15:53:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=25QeVzrIe1QnbrXSNhzVBPeLb6QN0dGNl7ZVZf+3eiU=;
 b=T1aNzAscewHJkBfx0F2tce4YRPa0r7J+73go2Cu3nA7bvjLQCgiy3uJe4aBaR7q2LYvY
 kd8VdYaa3rltj+jWVsUIvvutYCRbpNEMVWJI79ko8FQjz6jupTTvphFkSbHm7GLXw0ZG
 RVnJi6SlCsWzyTMG8mZcNResNPUlEVHqIqpJ53BLkUsNvF8ckqiTmvMo4Pnew8k4igTM
 HmYcYmG+2FfJa0B9FCw64ID5pXjpyNWgPB5GBIzlXjSj4cGdjaAclydYFVFxLaguisgm
 pKJUXXN20Kk/AOXoEVkxj3SS7NNxyzTflFARsQ1jpHY4EcixSLwI/wz0i1nGMMKyJXLI tQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wc842ags9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 Nov 2019 15:53:46 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 20 Nov
 2019 15:53:45 -0800
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (104.47.33.56) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 20 Nov 2019 15:53:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJ0hcC9Zn4vYOF5hzhl/83TcqwDqB/aiS3Oxzre8NV80xFQwoid+NKLvqoFV4GDI1QrAGEijbQqy2kSf9qlDde4eatzDKFf3alCMXgWIKf1HdATHnIwaEtQAkszsmqnG7dnV9x5yC0DZ4dfqDuRNTCth0oZOI6sTuLPZkYI83+HrHGSlNIRlFSZ7NMPTL8TSFGN9nTZ7o4l8b8ImvbseBmqQuuFGnJtO85jsbftXQjBsyuRFDKYg8ei5gZ5maZzpy3S39Vq8sSW7TCnUeeA7CD9yOyhjybq+xYdusJyX2mb4HIrYWvGDg2wU9eNXRljrXzQ7/SYv6yMv0WqAKro0AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=25QeVzrIe1QnbrXSNhzVBPeLb6QN0dGNl7ZVZf+3eiU=;
 b=IeJwQnQDpHLFCnNAjinXTcqXrq+UTDVbrRhS7ZNBvqNiQ8TdgR3UTeSQiQ386umYLG5aHow97SldjUlJrqRaG5GFboivV4rgBS5Lt839zkPejwOEnkzh5U+c/bxXP9sNY+f89k495UfvCi6gHZgwGIoX6DifcW0OxewHKPmnFyDIfinH+lYCrYgymYiPbUmpyefS4sKSqDQ94gfsYVZbMUEy2mYtoGwnLToOqq0QhW3TJSY5N1B8+rmPnvqIz3OX9DtG9/PH/P7q1kRzPvbQ7d6bSw+S8c/hhcHh51vndAOhI2vcESUw9w3dNHc+SEqWKg/7zrDeMbvfXFgYx5oILw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=25QeVzrIe1QnbrXSNhzVBPeLb6QN0dGNl7ZVZf+3eiU=;
 b=bZAKTlaKXPN4IIL78bQrw7pRWYqVsSwxT14SxTKd43Css1efTk2vgrj7g5a7OwXs7KYLQlANIMRmdFiEyQ3Cy+2oUVj/1bmOebLOnmm03JP5qHrekx9OIxDzFJmr/4cfoZJz93kM4n+O7zsvmyH7nRtg/BsvvT0OZI0zsENCe8c=
Received: from BYAPR18MB2759.namprd18.prod.outlook.com (20.179.58.88) by
 BYAPR18MB2789.namprd18.prod.outlook.com (20.179.56.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Wed, 20 Nov 2019 23:53:43 +0000
Received: from BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::5907:fd6e:ff93:426b]) by BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::5907:fd6e:ff93:426b%7]) with mapi id 15.20.2451.031; Wed, 20 Nov 2019
 23:53:43 +0000
From:   Quinn Tran <qutran@marvell.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux@yadro.com" <linux@yadro.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Krishna Kant <krishna.kant@purestorage.com>,
        "Alexei Potashnik" <alexei@purestorage.com>
Subject: RE: [EXT] [PATCH v2 09/15] scsi: qla2xxx: Send Notify ACK after N2N
 PLOGI
Thread-Topic: [EXT] [PATCH v2 09/15] scsi: qla2xxx: Send Notify ACK after N2N
 PLOGI
Thread-Index: AQHVn/HBkecpz0evC0GoU0Y5ICWl1qeUuHSA
Date:   Wed, 20 Nov 2019 23:53:43 +0000
Message-ID: <BYAPR18MB27591E2D46D9CB81C30B4004D54F0@BYAPR18MB2759.namprd18.prod.outlook.com>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
 <20191120222723.27779-10-r.bolshakov@yadro.com>
In-Reply-To: <20191120222723.27779-10-r.bolshakov@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.186.1.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e292d6b3-af4e-4a99-8816-08d76e14e04a
x-ms-traffictypediagnostic: BYAPR18MB2789:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2789CAEA17B970489A187244D54F0@BYAPR18MB2789.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39850400004)(396003)(346002)(376002)(366004)(189003)(199004)(13464003)(8676002)(8936002)(26005)(7736002)(2501003)(305945005)(11346002)(446003)(486006)(53546011)(76176011)(110136005)(14454004)(476003)(7696005)(316002)(54906003)(33656002)(25786009)(478600001)(74316002)(102836004)(6506007)(81166006)(55016002)(256004)(14444005)(9686003)(6436002)(66066001)(229853002)(6246003)(86362001)(4326008)(2201001)(71200400001)(71190400001)(186003)(2906002)(66446008)(6116002)(3846002)(66556008)(66476007)(52536014)(5660300002)(76116006)(64756008)(66946007)(99286004)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2789;H:BYAPR18MB2759.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6ag24cNhfEeLAnQ4aCzUwGW+okmUFjQAYQGAKzvFKyb3RcKGSXp4qsMHBi5KVxJg2UK++yJzjLKvmToh7od9LhMm5/7PsOoYFEd/eHAikaN7oZRtU3ARctvr/gvOEQoiEqFL2plPpxlZbMfNgiD8nsSOYbb2hu2CPB0fnJbDU1iJaJsqjoLf0LGzPJO7BNMUOC2Q8tIlm77U3c8M6iHFKYjVUdM1cyPnFr/kA3TJzxUKAUnbz2HhNN+c2QGZZPSCRUmeyRUK17eTYKPel3O3sI7m9vCbNkH7H5ymnHUZOlE4qDXZlhamAvfKYsBy45uQgR8Gq+HBTevVCA3rpR0WTIRGQLU0saTy+Nf+G6BeZ+fDF2aoIM+vNEieKbueLpBtl/MrRgFIV0bpL1ylPRNFzltODUCoRTsRiucXHFvR+eu0JUotIiwJ84gt/1TEy/25
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e292d6b3-af4e-4a99-8816-08d76e14e04a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 23:53:43.6437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 26lLsoWWyJVT8+bWNv7o4esfz5o21h1cnIXdzV6e4r1bHgMjEjE1nT0cqtZJ2bpkzU1FTwii8WC0pLS+X54hrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2789
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-20_08:2019-11-20,2019-11-20 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Acked-by: Quinn Tran <qutran@marvell.com>



-----Original Message-----
From: Roman Bolshakov <r.bolshakov@yadro.com>=20
Sent: Wednesday, November 20, 2019 2:27 PM
To: linux-scsi@vger.kernel.org; target-devel@vger.kernel.org
Cc: linux@yadro.com; Roman Bolshakov <r.bolshakov@yadro.com>; Quinn Tran <q=
utran@marvell.com>; Himanshu Madhani <hmadhani@marvell.com>; Krishna Kant <=
krishna.kant@purestorage.com>; Alexei Potashnik <alexei@purestorage.com>
Subject: [EXT] [PATCH v2 09/15] scsi: qla2xxx: Send Notify ACK after N2N PL=
OGI

External Email

----------------------------------------------------------------------
qlt_handle_login schedules session for deletion even if a login is in progr=
ess. That causes login bouncing, i.e. a few logins are made before it settl=
es down.

Complete the first login by sending Notify Acknowledge IOCB via qlt_plogi_a=
ck_unref if the session is pending login completion.

Fixes: 9cd883f07a54 ("scsi: qla2xxx: Fix session cleanup for N2N")
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Krishna Kant <krishna.kant@purestorage.com>
Cc: Alexei Potashnik <alexei@purestorage.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_t=
arget.c
index ab62fcba8ab3..853fa187d827 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4802,6 +4802,7 @@ static int qlt_handle_login(struct scsi_qla_host *vha=
,
=20
 	switch (sess->disc_state) {
 	case DSC_DELETED:
+	case DSC_LOGIN_PEND:
 		qlt_plogi_ack_unref(vha, pla);
 		break;
=20
--
2.24.0

