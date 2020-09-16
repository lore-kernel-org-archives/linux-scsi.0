Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB657C43461
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 09:16:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68A1D2076C
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 09:16:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="L8YZSMGs";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="HZ9kzyUF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgIPJQA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Sep 2020 05:16:00 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52642 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726243AbgIPJP6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Sep 2020 05:15:58 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08G9AQEM011885;
        Wed, 16 Sep 2020 02:15:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=Lpbn1eQO2DQVq49XlPUf/g/RU9ABfvmTMD8/5DFM7ng=;
 b=L8YZSMGsTVPv4jfEc5WGfGxELcKmck44eYanJF4UDIQLx2DH389qF2AC925EiK3smSPS
 EpRNjDuXf0oRJpTtHEXK+uM4Kma01M8Oq+2JyuuAfwIwNmO7qrFkc0JVNFMo7vnHDIxq
 zxxslT1t1inPb/hAzhmercYHzpgj5h2AagXKib8n+Oks3jwMSapS9TUQ2miTc4os9q8J
 gVz882npIw1dSWE2oXQiYe5Q/xTPIT5mddT2Rr5f7glmDFxJGu4BaUR2Mh0Vqsb+Khvp
 n9256oiNLBH5Tb2QtlqkU2USZTTanDo5XOvwO36W8sq1l58HySVtR9UgBlj2cb+TOFTM rA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33k5njj2gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 16 Sep 2020 02:15:52 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 16 Sep
 2020 02:15:51 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 16 Sep
 2020 02:15:50 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 16 Sep 2020 02:15:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5lmZ5MgM43NgHgAE/ciWg9SLersyq7nYYF0jqxK+IRp31MAHP+GtgniB5wpL8wWcSV0M3vNRRLGgzerWv7zieKvV7UipmIyvssYGDaX48NkW83pbBb5N7Ra9NSLYXC0OAKSwtTQ1duk8pJv63rpZ4Lklhpr8IyjrUi2jz5X+ppUPbft1G/X2noVjURpxa4RT0Gj2cCZDiYe3+Vz/37w769p54ORdJl+d8DbaJ1GVDJosT+XIcC+Vly4CVcX15vV0nGab0uCXG67XaXLs/oqynVDrvQHmPEosM35N+k9M5kSXHB8FuwmqxReANVrqERqlJIMghH46sfBHSmhKuGBoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lpbn1eQO2DQVq49XlPUf/g/RU9ABfvmTMD8/5DFM7ng=;
 b=SbdYYv8hWzD2sMQG14dfr9pDJV95o1N399QZrk6ZDwMH90yW1AqA02hN3ZEUez8HJkN1Q1/32+XNeiagMYs0q/Q1KamxulWPsruV7Az9Twsjn4qsSxtRvnHRPLxMc7xS1wFIN/gjL5AIjHtIu4sFo4BUIcbbLrM+iqA2PCDJNw0txiO55YuRsTj1yKMGgG6WtVDdPdPmgowOGVqsBEU7DGHpxfsMinHhQ3jil2lAjuXIxGeZa6sSMs2g1an4Q2b5dxVIE4H8vX2Qf3BjEMc66y+VT3wXd5j1s2gBOU1LJ94xnhZk3QrMZzcAkA3I0L1iq+njzVXWE+/c5tGdy5OmRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lpbn1eQO2DQVq49XlPUf/g/RU9ABfvmTMD8/5DFM7ng=;
 b=HZ9kzyUFiq1HPEyRS3JXEz6GLHRdaWFISJaXHR8E5FtIZjjd+RbbapgDtWqo/S6rPUDhbn+MUytnV412O9URR2dHQwEUn1F0KH1QWkfXDyDWCOAVImEEZLXjj/76qdaJg32/K7+fVaHfy+SfIL1Z0hTPY6Dqog0wuog2wfNjgi0=
Received: from BYAPR18MB2998.namprd18.prod.outlook.com (2603:10b6:a03:136::14)
 by BY5PR18MB3251.namprd18.prod.outlook.com (2603:10b6:a03:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.17; Wed, 16 Sep
 2020 09:15:49 +0000
Received: from BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::5040:5594:5bf0:3163]) by BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::5040:5594:5bf0:3163%7]) with mapi id 15.20.3391.013; Wed, 16 Sep 2020
 09:15:48 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Qinglang Miao <miaoqinglang@huawei.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [EXT] [PATCH -next] scsi: bnx2i: remove unnecessary mutex_init()
Thread-Topic: [EXT] [PATCH -next] scsi: bnx2i: remove unnecessary mutex_init()
Thread-Index: AQHWi/GYjQ1+KEiWzUCtTI92rYnqIalq+0Gg
Date:   Wed, 16 Sep 2020 09:15:48 +0000
Message-ID: <BYAPR18MB2998601673B4F089021B2763D8210@BYAPR18MB2998.namprd18.prod.outlook.com>
References: <20200916062133.191000-1-miaoqinglang@huawei.com>
In-Reply-To: <20200916062133.191000-1-miaoqinglang@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [116.73.249.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8ef459f-103c-4c4c-79d4-08d85a2119d7
x-ms-traffictypediagnostic: BY5PR18MB3251:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB32519636927852EB66DF94BDD8210@BY5PR18MB3251.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:295;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F3q5GVtDexED4/BjYdIRXN+etlNs6gaxzsSZdfAQZyWSfaHwVVsiD5Im3tNIUWuD3HmNw/GZSjDBTeJz+qRL5fBKyaJS0PdiiN1+CR0EIP3EkCpYhuMS8p8MJpJQar/3SX+VkULG2ShuJFWzo8c34NPe8fe44mOGMDWUeKkET7VoHTDyUuvtxYhgYDZyttTcFVYe4i6TE9+YgO0EBdlo0zHxW0wSWAPtPzGhK+9QD0+xWYa9r8a7LUdlXJD/DDsWj28TcZjGXvLp9L1BJDT4NVBNyO5ScUkaD7Czd9f6OQreOCP1wpBaottjIBUgi2HP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2998.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39840400004)(396003)(346002)(136003)(376002)(2906002)(55016002)(316002)(110136005)(8936002)(52536014)(4326008)(54906003)(478600001)(8676002)(107886003)(71200400001)(5660300002)(33656002)(9686003)(66446008)(76116006)(66556008)(64756008)(66476007)(26005)(7696005)(86362001)(6506007)(186003)(66946007)(55236004)(83380400001)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 2ioxo8nN5N/Amp8SrSAMX1b4yIWumJmmJmTviWLTFRj7tHpylpbkuaMvgZtQaAwJnx59HfezZtUlTKikpttp8GbAZXe6skGyOEwb9zf/viybvpVfa2cilyTfVYtbCAb1PBYlWoiKsy3OI+ucxv4lX+qJ3NzX8mx45KKdwZsXPktiVCw+eP/7n5yz4awfqBSDtBiRbCPezZHU3+V9Xa3Yn0EAm5NTuRtSegZwlfMzArJEf0/Y/5o/DfhfWNIgPpLp3tO8p01sQMeFwf2pvQ8CVBuZcLp29AlBJhByyD0ehwpPDN4IL9ALzHIDpE1SZvfjLigQZ4wHEzLJD3lLupPH4Ln3vVWYzBmQteMaEo3tWg7KTTV8MsKvX53k6oZdPX4cSrDdS+V1X7JxdIpGaPbAVurHGDYYOiusSAdxyO8vfzeUTyV24XZ3b2vV43921vrVQYTX/72JVTSR3mDmSJiVnolSolLbOT/JBPHeGf7jYBEsBwus4mww0ulDRjmGWvPRYffqn+wJQWQ+76uuIZnGVpioT3NhWoDyFTkUJlgmEunDfi2F6umxBvwBtBKqjD5G3c5w35dcr5CgkkPL4rwmhtVDo3Y5XKbC2SvFEbJkElOoFUSeSL/oY3QNynzD5f95ds29r9y9k9rCux64DUo/5A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2998.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8ef459f-103c-4c4c-79d4-08d85a2119d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2020 09:15:48.5258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l7VqjCmylOu7PGAf7MNymrzY5frqIwvhmxG5eN9g7W4hIQ/zAERiyg0TqmHVPDU1s7nDo9XTNlWBT1X6YZfYww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3251
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-16_02:2020-09-15,2020-09-16 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Qinglang Miao <miaoqinglang@huawei.com>
> Sent: Wednesday, September 16, 2020 11:52 AM
> To: Nilesh Javali <njavali@marvell.com>; Manish Rangankar
> <mrangankar@marvell.com>; GR-QLogic-Storage-Upstream <GR-QLogic-
> Storage-Upstream@marvell.com>; James E.J. Bottomley
> <jejb@linux.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Qinglang Mi=
ao
> <miaoqinglang@huawei.com>
> Subject: [EXT] [PATCH -next] scsi: bnx2i: remove unnecessary mutex_init()
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> The mutex bnx2i_dev_lock is initialized statically. It is unnecessary to
> initialize by mutex_init().
>=20
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> ---
>  drivers/scsi/bnx2i/bnx2i_init.c | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_i=
nit.c
> index 6018cdd17..2b3f0c104 100644
> --- a/drivers/scsi/bnx2i/bnx2i_init.c
> +++ b/drivers/scsi/bnx2i/bnx2i_init.c
> @@ -474,8 +474,6 @@ static int __init bnx2i_mod_init(void)
>  	if (sq_size && !is_power_of_2(sq_size))
>  		sq_size =3D roundup_pow_of_two(sq_size);
>=20
> -	mutex_init(&bnx2i_dev_lock);
> -
>  	bnx2i_scsi_xport_template =3D
>  			iscsi_register_transport(&bnx2i_iscsi_transport);
>  	if (!bnx2i_scsi_xport_template) {
> --

Thanks,
Acked-by: Manish Rangankar <mrangankar@marvell.com>
