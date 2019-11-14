Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5221FC432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 04:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30A3B206EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 04:42:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ocSs8KGS";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="LhptA+iA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfKNEmq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 23:42:46 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:19530 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726521AbfKNEmq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Nov 2019 23:42:46 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAE4em35021160;
        Wed, 13 Nov 2019 20:42:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=Ge7k4OSblBjU2JhwE4iFeI1STTIDyks3Tjf9AV2lZAU=;
 b=ocSs8KGSpWCFtqfu6DcR45ppV5ppZSsPUkTu9GZOVtcri14JRVindnfyBP3jXq3syE6Z
 kCjYvLAaUj97/5A4f+532wtb+rSQVA3t2Fk424LXt/3iTEsGUCdJ/BqkJA4cCtJgx51U
 xgIZrr3kaYToot6K/2tt55zuodf3rquqC+NBypf1WIG9vV7wUObbM3NkW93/JkwCRghX
 wgLU5gwqdYHofG6lLzsiNw04kQ7vccP5yMR3SUVqVkPwvkS4RXhjRCqjlyeMwfpBlgPp
 c/Imo9K1pVDVSQENx3IY1g8zrbKwzbzMWk30LgZ/KycbSnonzrf5dzGMG8ktSHg1NDQZ NA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w8wwg0gdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 13 Nov 2019 20:42:35 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 13 Nov
 2019 20:42:34 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (104.47.48.53) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 13 Nov 2019 20:42:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kg1HIzvMIP8LAitJfGIB5EIP19tHmB+qMi7Roh/vUeoN+pIlK7JWzq5bmnc2xj0iA9jaKyJEPrDwV1us9aUMKmFCfYm/Z3ECLRTMxsGYpBCvbemmDHvLigOhySzdjvHdkymHDmStdlAzx7BooiRqM3MshhaBmFy4ea99r7ezBT1H/yibJSob+FfvboXMNSE8gCgB3WteIsm74t4lOE9RN3RQNbzl/EYtnToCO1hV+ky92CSUdDHTMNfr+wnU6f/droHIRrFcNeq+MgSAbki06+lzCvoocKm6sNyu8OVCb/d5H2x2XZKh7W43f/+jrHDLLYRXgir99uJyPZcHOR1pdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ge7k4OSblBjU2JhwE4iFeI1STTIDyks3Tjf9AV2lZAU=;
 b=a1Ru35/2RaTkvnYxG/zMjulAJ4z2QR6aEoNMID27vrEW1viYOObWZa/h1y2fp6UcYa+8BMPrN9Z84CtDIPlIypGutlExTSAs76S4j0OautQmJqFWT8TRj3Sequ3CKBlY7a8A6liLXSi9OzBljrwsfTQc1s2YlntnQtFhp9h9IqdL3FB7z05P4Mef6BI8sJ2WLzYoUqUObUiOagKtRjAmgU9X7GX2aJQBRApjcA2bgGqPH8PyJGaxjwXXHeVKPd8ySpBsypGiVQYvZ2EmIFHDgmgdwoFzWTr1X7Rk/JFZRGGVcMl0vh72+yrBTBIbmJNg0vVGBXd4taOx9Ccvw676wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ge7k4OSblBjU2JhwE4iFeI1STTIDyks3Tjf9AV2lZAU=;
 b=LhptA+iAA+hxIdNx6fSjClu33IXZLsQqe2vOzYPM1Mo7pbiikj25rmGd3qtpFAv7O1lYB/7NBimQS6NFibPXvj5qrmt1vLcVJSEtERnUnUJuWjQDxUEBo2M+0R22FXhB/BBFwMHAVAWinzCmLaMA5dg2kTV7cut3k3qcHdMAvEE=
Received: from MN2PR18MB3022.namprd18.prod.outlook.com (20.179.81.79) by
 MN2PR18MB2384.namprd18.prod.outlook.com (20.179.80.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Thu, 14 Nov 2019 04:42:33 +0000
Received: from MN2PR18MB3022.namprd18.prod.outlook.com
 ([fe80::50f5:6e56:bb7a:c6a5]) by MN2PR18MB3022.namprd18.prod.outlook.com
 ([fe80::50f5:6e56:bb7a:c6a5%6]) with mapi id 15.20.2430.027; Thu, 14 Nov 2019
 04:42:33 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Pan Bian <bianpan2016@163.com>,
        "QLogic-Storage-Upstream@qlogic.com" 
        <QLogic-Storage-Upstream@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] SCSI: qla4xxx: fix double free bug
Thread-Topic: [PATCH] SCSI: qla4xxx: fix double free bug
Thread-Index: AQHVk704LzvZr/hpFk+MexrJVSr6K6eKJC9Q
Date:   Thu, 14 Nov 2019 04:42:33 +0000
Message-ID: <MN2PR18MB302207CEA407EB6C5E8C2A05D8710@MN2PR18MB3022.namprd18.prod.outlook.com>
References: <1572945927-27796-1-git-send-email-bianpan2016@163.com>
In-Reply-To: <1572945927-27796-1-git-send-email-bianpan2016@163.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e1001c0-d25f-491b-3318-08d768bd10b5
x-ms-traffictypediagnostic: MN2PR18MB2384:
x-microsoft-antispam-prvs: <MN2PR18MB2384842E806B970F09788E10D8710@MN2PR18MB2384.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(396003)(376002)(136003)(13464003)(199004)(189003)(81166006)(102836004)(76176011)(11346002)(6506007)(71190400001)(3846002)(476003)(33656002)(486006)(53546011)(99286004)(446003)(2906002)(7736002)(26005)(2501003)(66066001)(25786009)(74316002)(305945005)(86362001)(6436002)(6116002)(4326008)(66476007)(66556008)(64756008)(14454004)(316002)(478600001)(14444005)(8936002)(8676002)(186003)(71200400001)(66446008)(9686003)(54906003)(66946007)(229853002)(5660300002)(76116006)(52536014)(110136005)(256004)(81156014)(7696005)(55016002)(6246003)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2384;H:MN2PR18MB3022.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CJLTqcOtB1gUx9/GGpwUHbzOkjW215sy3WLbwhQHKccPdAAxz2XunmorrdZu/qdEEvWhhZM/0I9HyVplKpFpDZbjC9HnbMNP0lYCcdsjiXqK75p5StQfvtMqegTn6wnHUOQygHrIpVnl8+4r287pjK59LkpIHZPcckMHFdn6PpvY0CO23XG++sJytz0imboCmOK9JP1QD7z0EQBEDk7OdZxpISgj9xnlhI/4fjBIRItr5YNrtPA417IemeZ1vEZKEBwoOsZVK6pB4aVlER31fH8fzziTVaTVtl9JRDMIcFUpSn9kJzjQq9R3OP5GoiwbS1EezV1NukCKu0+ZPfWQlDeqYSA9VLwqazN7KDyltjQVVyH0g0wkHaMPBmH2KdskUjD/Y5HpnUghF+MGLZvT6sfIiradNmiIZYtRWdbz8QOMi6cs+17WnlEz5p1XSSNi
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e1001c0-d25f-491b-3318-08d768bd10b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 04:42:33.3683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L6MmX6uk3dbwCZYt2K2evuaZON3iXxQcz9onjhiR8vHEIsPpzZV7bDZJtRTsqBSn/BYRKzQFUYgwdMflYPRuSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2384
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-13_06:2019-11-13,2019-11-13 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org <linux-scsi-
> owner@vger.kernel.org> On Behalf Of Pan Bian
> Sent: Tuesday, November 5, 2019 2:55 PM
> To: QLogic-Storage-Upstream@qlogic.com; James E.J. Bottomley
> <jejb@linux.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Pan Bian
> <bianpan2016@163.com>
> Subject: [PATCH] SCSI: qla4xxx: fix double free bug
>=20
> The variable init_fw_cb is released twice, resulting in a double free bug=
. The
> call to the function dma_free_coherent() before goto is removed to get ri=
d
> of potential double free.
>=20
> Fixes: 2a49a78ed3c ("[SCSI] qla4xxx: added IPv6 support.")
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  drivers/scsi/qla4xxx/ql4_mbx.c | 3 ---
>  1 file changed, 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mb=
x.c
> index dac9a7013208..02636b4785c5 100644
> --- a/drivers/scsi/qla4xxx/ql4_mbx.c
> +++ b/drivers/scsi/qla4xxx/ql4_mbx.c
> @@ -640,9 +640,6 @@ int qla4xxx_initialize_fw_cb(struct scsi_qla_host *
> ha)
>=20
>  	if (qla4xxx_get_ifcb(ha, &mbox_cmd[0], &mbox_sts[0],
> init_fw_cb_dma) !=3D
>  	    QLA_SUCCESS) {
> -		dma_free_coherent(&ha->pdev->dev,
> -				  sizeof(struct addr_ctrl_blk),
> -				  init_fw_cb, init_fw_cb_dma);
>  		goto exit_init_fw_cb;
>  	}

Thanks

Acked-by: Manish Rangankar <mrangankar@marvell.com>
