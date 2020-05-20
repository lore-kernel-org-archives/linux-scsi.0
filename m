Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69277C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 06:33:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17F7D207FB
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 06:33:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="LpzhVLC/";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="Y1aLXcDP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgETGdx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 02:33:53 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34992 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726309AbgETGdx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 May 2020 02:33:53 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04K6UeTF023904;
        Tue, 19 May 2020 23:33:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=eoF3X/HZwRpNfahxGVIct1VUg1HQGuoIuFpBRDkDcJ8=;
 b=LpzhVLC/3uITuhEjpMAylp7N0pfJYdgcbe6Z6B3M3NVBbE5ldARooETYxo32PU/CTgo7
 1mBBp/7tov3o96YsFa5ubg/pCRF1eM6+dEN4JpOCrODCnFmYAKNvQwv/MMfcGxQai+RJ
 fy/RANoWOc1/rzJV3mo3T9ro+dPXZkTzXo6EwusfKP9kcWQhhdJc9ytIPeDXvF2OTDa3
 Ob4n/Ftgp68omuTD36ymoQ83+aZwRUgOGG62gjuFejcH1f7e2Nc9xEwrqLHzwvE0iAAN
 8P9oIMVzexq9C9vN4IQ8p/qZf5Yavknt2yut4IgXTBflLw3tgzBr2iejBySqKEvH37aO Bw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 312fpp74xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 19 May 2020 23:33:49 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 19 May
 2020 23:33:48 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 19 May 2020 23:33:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RbqqpViSE0NG6b3/J2QT3nJ7Bqcd84uhwwwU+3dID5jfWkxQ1spQt/VUZTywLjwsoIIQTnYX2wBH/QA4pGFMTMMh/Q46giClCRVUpRsoQScLWRY8nXGqOgKF2z1EHynpXDx96/g5JAXjMRg5crhBlCfa+38i8zEidI3qalkaB9a6etnYeIIHQy9F5zo7HHpuWF4CGLxDh+75v9jWsbmmBmFWUtFv/2YWJDs17wJ7xYjBwhZJCEp65frnacGIyuWOLnt/M/YgvtaToe6rhKKPVpSndlRAxdoHabmOoi63sI9ttbE+NhukkKf6K8RLePyY8KA09suFBhc4QdLwPVl8GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eoF3X/HZwRpNfahxGVIct1VUg1HQGuoIuFpBRDkDcJ8=;
 b=Jzl1LuJ5q7Rl962vfc0bs4+5PYwOj9F6ONxYDMUrpazIWq6yGvoZQcDFTz2pUBWtsr0yJfMWGFmnphjkneOU9SMUkAbZ/asUy6+we4P45hYOMak5tVzQsGbnopGqFn7G2kCCdbHL/lBVspiF/o43DcQy3zLzyIJB/3eEUsry6FR3lXNcBS+F3nm2I//cTaruhMdvxaeso1C27VwesMMNEgEPN46zA9lrd7DWepPB0qs87QYDti6dJQRPEZU6gsiXZl34d1tTci/LQLTBxGMA8gvH5Y9Y1a84S2swWRN9qcOmwlWIbsuaLvVxHGijV524FI+eqOD7MXt/ppN86bvnUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eoF3X/HZwRpNfahxGVIct1VUg1HQGuoIuFpBRDkDcJ8=;
 b=Y1aLXcDPw0ftsTfa7Cj7cm2ilUNgA3gHU74J7LL6oS6tiU5y+BwDEIIZMpO6bhmW1f7YC/I6DtRsPtX9JQpoc8HrVMsjNgm+4vZAoSZrKz/VG1PXKIzAalRj+AF5dLtQyt8eXqc5+aLCLRMuJaHG17n2MjaMrKJ5oBDFMYFgq/I=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM6PR18MB3523.namprd18.prod.outlook.com (2603:10b6:5:2ab::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Wed, 20 May
 2020 06:33:45 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::4534:f910:753b:b037]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::4534:f910:753b:b037%3]) with mapi id 15.20.3000.034; Wed, 20 May 2020
 06:33:45 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     "rosattig@linux.vnet.ibm.com" <rosattig@linux.vnet.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Arun Easi <aeasi@marvell.com>,
        Girish Basrur <gbasrur@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: RE: Regarding - Patch - Fix crash on qla2x00_mailbox_command
Thread-Topic: Regarding - Patch - Fix crash on qla2x00_mailbox_command
Thread-Index: AdYs34wgPovt6PIETKCcIWSIOZymMABkQLIg
Date:   Wed, 20 May 2020 06:33:45 +0000
Message-ID: <DM6PR18MB3034B8373D1AF280C18593CCD2B60@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <DM6PR18MB30346814DE1F5807188A844CD2B80@DM6PR18MB3034.namprd18.prod.outlook.com>
In-Reply-To: <DM6PR18MB30346814DE1F5807188A844CD2B80@DM6PR18MB3034.namprd18.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.vnet.ibm.com; dkim=none (message not signed)
 header.d=none;linux.vnet.ibm.com; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [103.195.202.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e36f7ed2-491e-42c0-7dd3-08d7fc87bf66
x-ms-traffictypediagnostic: DM6PR18MB3523:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB35239415A5052E10ADA8CDB4D2B60@DM6PR18MB3523.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04097B7F7F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DzUGb34vP9LiJyTWVVS2n2SXFoZcF7UJLqJgKtNt6v72MoqyNtj4sOO3DhHbRDOlYDqSOV4r1tkn1RPdmh+OJ2ft8MzsrXefuff+1539cIAAKr5f37hSgmpCx9ZXvU9FEGv0M36WcmQ4PoUspaBNgKWNvI16T0Png/QUYgYS3RAkPh9/oSlWexppbLq8sr0kkBTPVSfoLcVNLAUUOrLgLFfb34Z+QoxlDHQ94Mze82cpCxQilsThKbydqE5LJy5SVD/sKPT6F/ywt7gJ4OT9FxGxg6Ggu/eN23WNSKy43zkFuAEkg8kZZMgLyWFcrPiHUobJrzJ/o0EREfXEmHMNCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(39850400004)(396003)(366004)(346002)(86362001)(71200400001)(33656002)(2906002)(478600001)(26005)(52536014)(76116006)(8936002)(66946007)(6506007)(8676002)(186003)(53546011)(5660300002)(66446008)(4326008)(7696005)(66476007)(6916009)(66556008)(9686003)(54906003)(55016002)(316002)(107886003)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: mdu6f7vOkE0I/vl2sEFsRDqSf2wH6TguQiiNQnI41kKBRfpwBLpA8pQhwwm+m05LMsMvYou8KHYqT+WL2/5Dh+HkjoMS7EY/Sv7+FlGJCqLtnVPObdfL205FrVe1fXqiCJ8cbtho+IO0xCmrmkXT6Ajgn1o/Z/muZr7mdO5mdyAR71mJAoLFQQ0SUi4DzOSuhoLCq7iMjBDzP4+z7Q028YnMoQax4KdFP8Ea7GSdzWPYqTPfwJ7IwDSSUD2GRqahxIhITO0RI0bd37NIy4CWHHM1zp0qzzmUg3la6TqpeOvZ65pGjHZtV3lY33dDh5ZBNQW5OZrnMTXf3IZ2QQw57NEq6O4mTy6P4J8GznufbEOQYZdnQqFcs85WgpznRrsRQ+Frvk22yt+FZU7zdKmHUXeGrok/DZOuamO3wlBMYKe2c8ySzG7ZGxfrHhhW0PwrHw3WpyNiPt4vvMHbn6UmqiDBdM1iJtmX8KdWqltS/ijCogJK3FQ5L5ITAfZ/DGzW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e36f7ed2-491e-42c0-7dd3-08d7fc87bf66
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2020 06:33:45.6415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XKYuOQBZm48dK9YF3KyJxhYb3q9h+xQBEMae5k1yhdS1O2Akt5p8PYQRjNeOM7n7lD0M2bDBe7uJGVgaGfpxTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3523
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-20_03:2020-05-19,2020-05-20 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Rodrigo,
Any updates on this?

Thanks,
~Saurav

> -----Original Message-----
> From: Saurav Kashyap
> Sent: Monday, May 18, 2020 12:20 PM
> To: rosattig@linux.vnet.ibm.com
> Cc: linux-scsi@vger.kernel.org; Arun Easi <aeasi@marvell.com>; Girish Bas=
rur
> <gbasrur@marvell.com>; Nilesh Javali <njavali@marvell.com>
> Subject: Regarding - Patch - Fix crash on qla2x00_mailbox_command
>=20
> Hi  Rodrigo,
> We are seen regression introduced by below patch for QLA 82XX HBAs. On
> unload, the disable interrupt, mailbox command (MBX 0x10) fails because o=
f
> this patch and leaves the FW/HW in unstable state. The next load fails wi=
th
> initialization FW timing out.
> The only way out of this is to reboot the server. I  and  test team have =
tried to
> reproduce an original problem that is fixed by below patch but we don't h=
ave
> any luck.
>=20
> We would like to revert the below patch but would like to address origina=
l
> problem as well. Can you share more details about the NULL pointer
> dereference? Which data structure was NULL and what was the test case?
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> git show 3cb182b3fa8b7a61f05c671525494697cba39c6a
> commit 3cb182b3fa8b7a61f05c671525494697cba39c6a
> Author: Rodrigo R. Galvao <rosattig@linux.vnet.ibm.com>
> Date:   Mon May 28 14:58:44 2018 -0300
>=20
>     scsi: qla2xxx: Fix crash on qla2x00_mailbox_command
>=20
>     This patch fixes a crash on qla2x00_mailbox_command caused when the
> driver
>     is on UNLOADING state and tries to call qla2x00_poll, which triggers =
a
>     NULL pointer dereference.
>=20
>     Signed-off-by: Rodrigo R. Galvao <rosattig@linux.vnet.ibm.com>
>     Signed-off-by: Mauro S. M. Rodrigues <maurosr@linux.vnet.ibm.com>
>     Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>
>     Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index d8a36c1..7e875f5 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -292,6 +292,14 @@ static int is_rom_cmd(uint16_t cmd)
>                         if (time_after(jiffies, wait_time))
>                                 break;
>=20
> +                       /*
> +                        * Check if it's UNLOADING, cause we cannot poll =
in
> +                        * this case, or else a NULL pointer dereference
> +                        * is triggered.
> +                        */
> +                       if (unlikely(test_bit(UNLOADING, &base_vha->dpc_f=
lags)))
> +                               return QLA_FUNCTION_TIMEOUT;
> +
>                         /* Check for pending interrupts. */
>                         qla2x00_poll(ha->rsp_q_map[0]);
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Thanks,
> ~Saurav
