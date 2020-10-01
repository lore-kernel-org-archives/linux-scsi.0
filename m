Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 537F3C4727C
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 11:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBE2F2087D
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 11:03:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="jK4f/yLF";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="LRl5c+Sq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731788AbgJALD6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 07:03:58 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:13646 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731647AbgJALD6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 07:03:58 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 091B1P46008885;
        Thu, 1 Oct 2020 04:03:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=GqqDeVRccWfN3Hj2abEBusZHFjxjuIpkVxsn7icE4pc=;
 b=jK4f/yLFsLSWl8WDcQqRMCzMdq221Qj5Pjoi8/mAnXQ+53JkYXdRsUHIt3JyCwiBCu+r
 kIarMAQpVYNmTfKuFhllE7+zfYnC44KLFY7XOExIpD8g7j8As4HTsqaic/AYE8fOMhV5
 7iWLZcprT/zRaAlMAE7DS8FjiqnvpHw6PY3L3XIh7TvsNTNHNFpyFbGgH48d6p8jNYmw
 CS811/VjcjAC/L8nYOR+L+X2qmmMkJFqNYUfbwMvDYgA+H17En/zE5dNpQHxkgnZOJtz
 Z6NyZaE9ySQHZ/3yZRdLQlZ0T3TRbsgwrQOKp5oIMvftyh51yZLoKN/1sRet7rkvRdSL Yg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33teemm994-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 04:03:49 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 1 Oct
 2020 04:03:48 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 1 Oct
 2020 04:03:47 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.53) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 1 Oct 2020 04:03:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqPk05ddCtEMKb9xgA39FmdkNNtbn5FkmkUWEY18yS8r+Nkf6NkPv4GH+Zpa3DxXlRQgMTOzlHv1xEvJUidQzo6PQwpcQlrCCYswIWimNiL4JGMOBnc6DucYoiV0gHyo2E1hW5jW6Sx9087Q+4amNohBUA3sh36BkVDcC9KyBnNsZcLw6rq0SsxL8XdgYHrwPO6W+lsff+X7HDOby2GHbq4vAdDHp0nr5YW18cj+wNflcdaTfHQ9OpbVVb1DNVwgdJR8ovt4OLYp+/UG6oOpW5UBttQ0GXqlKq2VpzsY4SbtcxeMYJR3jHkoDQkv9YfNaZQnfwmq/cvhxLoNGGv+Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GqqDeVRccWfN3Hj2abEBusZHFjxjuIpkVxsn7icE4pc=;
 b=CO30IQDKF/15pNpuUfAvulvCFgyVfFZy9JJYokIgFores42HVUl1kfmqS1+GFgE1DDyeiL/IFbc42LSCjMt0LgGCKyAzLqdmlM7pCLJgA0Bx+JPT7YG0cWUEcIvygg4KEW3k+qSeD4tJJ3JX9acX0zOu78yNHX6x0CknANXwjNpJwAVKZWimzQDIpl0F+iwdt8bKyN8QHqriUkhaYBlHp7yL1rATSVZkXKk6Rp3CPXH6GUIkRPu84hT7+zVeqd47fDVsaBwPqjFOH1Bj6FzTBq/Cjk2JPT9h6+h/GUpKKGK1OHN/87KRIM2yGHLiDpOvsbKxtDXtTAkywSKuR4iA6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GqqDeVRccWfN3Hj2abEBusZHFjxjuIpkVxsn7icE4pc=;
 b=LRl5c+SqY4hC80lFZAl6g274Vxx0Jt+RAy5aXvrXD5wDUO8F5zPmMiCuX7JIG4Iu2PbLnRw/GTl904/9V/m+8IEOyC7TFmW9sZ99xxBiwFP8cMG2C/kndZyHdOCL6aMgOuE04hJG517N1p5TsOPZtiOorOcnxDx77eO+8RgLzBg=
Received: from DM6PR18MB3052.namprd18.prod.outlook.com (2603:10b6:5:167::19)
 by DM5PR18MB1017.namprd18.prod.outlook.com (2603:10b6:3:32::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24; Thu, 1 Oct
 2020 11:03:46 +0000
Received: from DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::e9ec:af5d:dfbe:2099]) by DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::e9ec:af5d:dfbe:2099%7]) with mapi id 15.20.3412.029; Thu, 1 Oct 2020
 11:03:46 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Ye Bin <yebin10@huawei.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: RE: [EXT] [PATCH 1/3] scsi: qla2xxx: Fix inconsistent of format with
 argument type in tcm_qla2xxx.c
Thread-Topic: [EXT] [PATCH 1/3] scsi: qla2xxx: Fix inconsistent of format with
 argument type in tcm_qla2xxx.c
Thread-Index: AQHWltDVxsVuhMD14027/RsQAmf3iamClPGg
Date:   Thu, 1 Oct 2020 11:03:46 +0000
Message-ID: <DM6PR18MB30524E8D5BB0DD27CCB09B6DAF300@DM6PR18MB3052.namprd18.prod.outlook.com>
References: <20200930022515.2862532-1-yebin10@huawei.com>
 <20200930022515.2862532-2-yebin10@huawei.com>
In-Reply-To: <20200930022515.2862532-2-yebin10@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [59.90.37.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12f0b7b0-ae41-4cda-1a5e-08d865f9ab0e
x-ms-traffictypediagnostic: DM5PR18MB1017:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB1017D0A40914C149AAF5B605AF300@DM5PR18MB1017.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:67;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CJIfnQf/Tm04suo+QGhAHRFpZZiArWl0Wpl/r6k85N9NmEoiVmpVgYEi8jMOkUar/eGYUqvzApO32YdIN5C0J1ARmMlUL/2RyWZkG/UkefvEUoPwjkWu9UjArrL1RUnBP7/fL9in0orrJUgcEl1/9LjQUJ3/0KDdZJOCt1sXWySAQoHhdwbvemlOMOraLjRgPrp1XlnLtyzKgBM+400pOcpbhNhGFzQxYz4jj8u4eoAf6u5iGtAn6h0zIB7nn4niRYGSLMlsGIrtkFz3xFu6NDs/6hDUApoCqmTdOHxJK0uDirXNUwW+dN4nJs2pwhG8N7ImfhW3gNa3T2FcUnHR5cqwzCkLiD4SjTWZOGrWs9eNQGJJ0217Tg2JJSnzstLJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3052.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(110136005)(316002)(71200400001)(66476007)(66556008)(64756008)(66446008)(52536014)(66946007)(55016002)(4326008)(83380400001)(9686003)(2906002)(33656002)(76116006)(26005)(7696005)(5660300002)(186003)(53546011)(8936002)(6506007)(8676002)(478600001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: BgNWKgjdWTCk2/nITnVGPqnZ/ACc0GA39ghqUtYwzY1Bd/Hqf+Ot17FcgzfuhT4K6nIF21sHtuS9lpwEWbva9Cj9kq742nbFvfaYuSf+UZ+61xDdhQtKXjK2Tw4V6Yj0qZ8LVzzzakUk5g0pkbyB0dnQvI6G+CWF8rD9YVTICavbdpAUEeJD1JksBE7rgh7TdOf6eU17Jl2ZAHVhL9xjmFN3dWexZMAa88d8UWpjZKUpTMHJRtKVMEjJLXfiJUWe6pcGAWUoX0wz4iGRTumReGGo6G60UpBHNmtmhIzXe4Yske/6mhksZWZInzcbH99pFt7pkdqlmMoTjetSHtOctJdYVXHEqlox0kegdQmVHc7+KzNoIAa0YHuFvyOWwggWn1ESflO+R4oEyEcSI9I0l76DSLPklwJHHK++742BOBFypkYPv+6eZ93V1+rBb58ErYYub7HqgXwWN9c86bVI8w8JWFH++QDyH0aSR2RzrkECZBPfhzqxGnYNLgfhkBcxhMY9A7P11BwYC+NaP6kIglCr/t7VWu2uIrGSbA8hMLIc9KYU+1+juQp63N3Vnz8ovJnlTNIIf4iRBNyD9WqLSR5Wgglg0O1G/y+Nj+RkosuWJSQ3x5KD4AbTFRoXY37+f0QNwVYjrAwxtfsp0DI4hQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3052.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12f0b7b0-ae41-4cda-1a5e-08d865f9ab0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2020 11:03:46.2846
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bd7V7jQCZtq5xPeRkbG/lXSTZyzzKbc9oELBUewtSr04STzFqM84qCqR3kBJPXaa4zyQAJUgeY+McMXRQzC9ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1017
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_03:2020-10-01,2020-10-01 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Ye Bin <yebin10@huawei.com>
> Sent: Wednesday, September 30, 2020 7:55 AM
> To: Nilesh Javali <njavali@marvell.com>; GR-QLogic-Storage-Upstream <GR-
> QLogic-Storage-Upstream@marvell.com>; linux-scsi@vger.kernel.org
> Cc: Ye Bin <yebin10@huawei.com>; Hulk Robot <hulkci@huawei.com>
> Subject: [EXT] [PATCH 1/3] scsi: qla2xxx: Fix inconsistent of format with
> argument type in tcm_qla2xxx.c
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Fix follow warnings:
> [drivers/scsi/qla2xxx/tcm_qla2xxx.c:884]: (warning) %u in format string (=
no.
> 1)
> 	requires 'unsigned int' but the argument type is 'signed int'.
> [drivers/scsi/qla2xxx/tcm_qla2xxx.c:885]: (warning) %u in format string (=
no.
> 1)
> 	requires 'unsigned int' but the argument type is 'signed int'.
> [drivers/scsi/qla2xxx/tcm_qla2xxx.c:886]: (warning) %u in format string (=
no.
> 1)
> 	requires 'unsigned int' but the argument type is 'signed int'.
> [drivers/scsi/qla2xxx/tcm_qla2xxx.c:887]: (warning) %u in format string (=
no.
> 1)
> 	requires 'unsigned int' but the argument type is 'signed int'.
> [drivers/scsi/qla2xxx/tcm_qla2xxx.c:888]: (warning) %u in format string (=
no.
> 1)
> 	requires 'unsigned int' but the argument type is 'signed int'.
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 44bfe162654a..61017acd3458 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -850,7 +850,7 @@ static ssize_t
> tcm_qla2xxx_tpg_attrib_##name##_show(			\
>  	struct tcm_qla2xxx_tpg *tpg =3D container_of(se_tpg,		\
>  			struct tcm_qla2xxx_tpg, se_tpg);		\
>  									\
> -	return sprintf(page, "%u\n", tpg->tpg_attrib.name);	\
> +	return sprintf(page, "%d\n", tpg->tpg_attrib.name);	\
>  }									\
>  									\
>  static ssize_t tcm_qla2xxx_tpg_attrib_##name##_store(
> 	\
> --
> 2.25.4

Ye Bin,
Thanks for the patches.

Reviewed-by: Nilesh Javali <njavali@marvell.com>
