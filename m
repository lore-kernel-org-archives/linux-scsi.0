Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D71FC432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 20:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F17972071C
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 20:25:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Ow+RtYZL";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="GucSPt1+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfKRUZh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 15:25:37 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33770 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726638AbfKRUZh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Nov 2019 15:25:37 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAIKFdvS021801;
        Mon, 18 Nov 2019 12:25:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=lq6U2k7CZnYJb09vrbkwgDGQjEFxRdOYKjwkGDL4OvA=;
 b=Ow+RtYZLeovxn0Z9bkF4L9W6KPoLzBdiAcjViQ/+ZtJMJiG580J9h5IoYZ5d62+IBkxr
 lAJxmrRyZZ/VwKMyRZW3ZfFes25iqpuce+7zCf2H1hXnQmd1x5KoBAiWdotIhYD0rtjy
 YdW7xsiZLFoUpA53xMTo4edejYeKrBLLqsbJJcNv2ns8EUm7mJSMStyIZlA5EAZkadYN
 wNNxYWdc2WYxxGv5UL5nZyFrkFITmjIn0KCfcvIL9wBShcgjGzPsbNOr8Ll4vjootw2Y
 vLP0bbp3uSvZUlgWB/yS8iRf1qDyomsTbm7HA3nPBtRRJvOxLLerM0z+3IcPQfWHewdB og== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wafbv8dfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 18 Nov 2019 12:25:32 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 18 Nov
 2019 12:25:30 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.54) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 18 Nov 2019 12:25:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R/WifbjFId1IB2ltOrjXJ3AV45fMDH74qOt9svE6Qqtu4e8KSL2zyEuOnY32OV/iSPXjCrGaE5C/6j6j1soM5GCX6Wt7cOpTEshdDfFxJklPs2jM3dr9f8pJXWXd9+oiew3WsAJe2VZ+ztFDPgfdITf9LrPR9yqtGDNyYFrsllAh2HSBmbzSV5zxGl6JKpRDGN6isOeBcogx1MZuFSDbxo/D2Anx8bDDxujBLjD1HA3EUt/uw2wW6Y7s6hBGsBuIY4CUvo8xgIY9LLAWlimT9ocWbPET9+8OqWsvfxYGGUjyHkfm+VXuvPtrZLRyTcfEc0zkOMhHbySIXSTpDyyC0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lq6U2k7CZnYJb09vrbkwgDGQjEFxRdOYKjwkGDL4OvA=;
 b=R7ikX6D5jwa6UMa0rlwiUeNHuC0y5uQqVHdRYhFktTeonzcmoSTPUD9Q3FKXpYIH0MC4jr6DJxFSlHB+/X3y+Tto8wkTc71GjL+NiwypEW2y/8hwRb0QKo4q0uFFjkOMizdyzJw+E1W02s1c4Pimt5arxMwdXEvrRcX+j4mqlcI/o54NDu5iml69+9cPTz0sFMPrB6Du8JxyJWaXB7jrpOf5ptCvEtImkIoKAw0tVWi58+JoXxwKU415nldrcV486DoU10jrfBWtFCL9E9XySKa2se1t66yD7kMQ8AQs0PKb9But+Z8/poDzR2QZigQAQ9APo+SYNsu9larWlzBGOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lq6U2k7CZnYJb09vrbkwgDGQjEFxRdOYKjwkGDL4OvA=;
 b=GucSPt1+ugIvLjb6u0RWwiUUcuRg0eixzoeRMRz5T3oeGyMGHArVZbeP5NXEwDxidMaxh/4GxgmXW8bCtf57YwOY4lZQDuCTxqHBKR5mD5aoCQwQjvonVUUo5CA9DOFQygEad8XV5bbM5gdEuAdA2YGS0v+TFihzPeOeIoij2k4=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB3070.namprd18.prod.outlook.com (20.178.255.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.29; Mon, 18 Nov 2019 20:25:29 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089%7]) with mapi id 15.20.2451.029; Mon, 18 Nov 2019
 20:25:29 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     "<James.Bottomley@hansenpartnership.com>" 
        <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 6/8] qla2xxx: Fix memory leak when sending I/O fails
Thread-Topic: [PATCH 6/8] qla2xxx: Fix memory leak when sending I/O fails
Thread-Index: AQHVk+rDuxklThfjSEqidsZypXigyaeRdMwA
Date:   Mon, 18 Nov 2019 20:25:29 +0000
Message-ID: <4BDE2B95-835F-43BE-A32C-2629D7E03E0A@marvell.com>
References: <20191105150657.8092-1-hmadhani@marvell.com>
 <20191105150657.8092-7-hmadhani@marvell.com>
In-Reply-To: <20191105150657.8092-7-hmadhani@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2600:1700:211:eb30:a8a4:12d6:33e1:c0ef]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1439828-d166-4a1c-85e6-08d76c657445
x-ms-traffictypediagnostic: MN2PR18MB3070:
x-microsoft-antispam-prvs: <MN2PR18MB3070AB9DEE1136D69B3B00CED64D0@MN2PR18MB3070.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(346002)(136003)(39850400004)(189003)(199004)(486006)(446003)(11346002)(66946007)(14454004)(66476007)(66556008)(66446008)(36756003)(33656002)(81166006)(8676002)(6246003)(478600001)(64756008)(5660300002)(99286004)(25786009)(81156014)(76116006)(91956017)(186003)(6506007)(53546011)(305945005)(102836004)(86362001)(7736002)(46003)(2616005)(476003)(6116002)(316002)(50226002)(4326008)(8936002)(229853002)(71190400001)(71200400001)(6512007)(6436002)(256004)(6486002)(76176011)(2906002)(491001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3070;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +x5U9tIB/9GXfxVIuSsNerZY7Kdg5q62Xq5m7u9Q+FGRgRqBBPFdwAyjML2N5bg8mdsBPYULZWdeCpNa1GeuMUsGHD1YYvW9vYLn+d6s/Ki5GTKvxBE8J8s2bbVqtmoM+6yeedjqXxhyhTYHBI33SFIKd+tVE7rEAd82/CfJSGlgg2YZdi2W4aWeh15eh2mBzkflO0KdlmTEJaZQTRuLvKLKKNLwemezXitAxTMN009jwV0kTIF+f0P3gv3UTl1f6ZirOGn/r3ElN/lmn6HQEx1q7WVfwIv5Tmot78TnNffrLAYgkGz73PGajLH078BFetUJN/ZNXtLrin4CTum3pvLuICfTu4KMkRGg0TG+d5ltcqQePtpZe2JKYl69G+ErEabWdrY7eD6nlSI/NqdCIEC0mk0A3e59A22TRUPfU/BnNBSPC9nBf8nE4LbUmS5P
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DCDE23B1EC39044A84281202B8D8538B@namprd18.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a1439828-d166-4a1c-85e6-08d76c657445
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 20:25:29.3275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: STQKBkV1D4rw4rB4x6vjh59l2hJDfwMICmSrP1H0fmZhOdONUJCJAiKVp4wQHo5oobdboEAwWsaECl5zdDuPLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3070
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-18_06:2019-11-15,2019-11-18 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,=20

> On Nov 5, 2019, at 9:06 AM, Himanshu Madhani <hmadhani@marvell.com> wrote=
:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> On heavy loads, a memory leak of the srb_t structure is observed.
> This would make the qla2xxx_srbs cache gobble up memory.
>=20
> Fixes: 219d27d7147e0 ("scsi: qla2xxx: Fix race conditions in the code for=
 aborting SCSI commands")
> Cc: stable@vger.kernel.org # 5.2
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 4 ++++
> 1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index b59d579834ea..b513008042fb 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -909,6 +909,8 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct s=
csi_cmnd *cmd)
>=20
> qc24_host_busy_free_sp:
> 	sp->free(sp);
> +	CMD_SP(cmd) =3D NULL;
> +	qla2x00_rel_sp(sp);
>=20
> qc24_target_busy:
> 	return SCSI_MLQUEUE_TARGET_BUSY;
> @@ -992,6 +994,8 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct =
scsi_cmnd *cmd,
>=20
> qc24_host_busy_free_sp:
> 	sp->free(sp);
> +	CMD_SP(cmd) =3D NULL;
> +	qla2xxx_rel_qpair_sp(sp->qpair, sp);
>=20
> qc24_target_busy:
> 	return SCSI_MLQUEUE_TARGET_BUSY;
> --=20
> 2.12.0
>=20

We found this patch to have introduced regression of double free. Please re=
vert this patch in 5.5/scsi-queue and not needed with the patch 5 included =
in the series.=20

Thanks,
Himanshu=
