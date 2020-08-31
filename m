Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F280DC433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 11:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD6222098B
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 11:41:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="bZLz65AF";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="LwmXMh2Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgHaLlm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 07:41:42 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43652 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbgHaLll (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Aug 2020 07:41:41 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VBfW8k031542;
        Mon, 31 Aug 2020 04:41:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=6THUmfS9xdAztoPkGwC3FaclSzAdOgo9MAPU11JJB18=;
 b=bZLz65AFED43KDg+HVDYAhdIB10wdhhVzYd0euYFvG18RUCZZBPbuszOQjnR6lQYO9Cs
 WjV1LmMDECchFCelMq5+Ozn28tmPehofGy9E6hTCFzMIly2nURUlzo580wNnpeuEWrfY
 GYllISyT3JpBmAlEy+luunRphWYlYRIv3fMjBgwjAFtwBTz5Xp1UKDuCBdsDzHn9o4rN
 /lB1WHkSGJfNP2U2iN5ELIoNCFjmCCiK+1vcPtvWCc+g33TJkIbplIdBVxO5a86SUrQ4
 kpP4w2wVXYlpJEF4RZHgeVBKoGUv0rmLDQ6CyMWZM4kozM/A3ssoixajKXzSU0YFTfSu 0g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 337phprwa7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 04:41:31 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 Aug
 2020 04:41:30 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 Aug
 2020 04:41:29 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.59) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 31 Aug 2020 04:41:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ks6aknUu2/jI3i+ABSrlNKfJzeYfYdkWfHtZA+d26h3wMJhEioXjKLOHyGuyBqmY3dA9YGR3snXIhGd9Azc8yfxJETBi9gdd42vwpy3pPBSPWdEJOgJ7YkinFYuO7LUCw4iSfhorIACWBQ+cj/qNP20o4QYOiqbnEhazuf+VfFMe6FK57MNk3IbzIF+OUAmcnbK8Xxw2mKwdhBGhbzasNhZh+dadmsLBAShN3WVqV//M3AwHsO9W186jONxw+1IRAdcixhBbf6w9OYINZOXe5v1IFYyEeveE9Khyl0GB9+n5mka3jO0Wtvbk30GeZko8kMAKESeluAQhOq8KeRCxww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6THUmfS9xdAztoPkGwC3FaclSzAdOgo9MAPU11JJB18=;
 b=cOAW4AroT6E2onIx4JgbZJKeEoFWS37WLmVQEAUddTBp3FyItEt0jINwPNeYaQyxmmLT9y+6EwoLEvD3+U5KahdgMbUGqa86HcIWTUIvtDlpi19Gij/bHP+KWRMscNkUpJrEhX3NbwJsks02F8ARvrvcToZcyXm4JiPYl0Aq018sLDVAG431z4bntk4mdgTEeMsEcnaxAL7AVQj/H1hjebPB82fJq3gveyECQEhOZKxgdRurBtIlS5lHtWuU067EeEjIRTJJ27xcVpeOsuGZFPaBI7mm1IAPXV1PZsPyV880NrPIFPo7DKscDoTLNHgbNxHoHxMXBnYhKH6tLjaaLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6THUmfS9xdAztoPkGwC3FaclSzAdOgo9MAPU11JJB18=;
 b=LwmXMh2ZjQTtDisbqECPT0lOlPl7uvZX4J8ryfqcJXOd56wRJYwIPEPzZj0L4fCYrqRAj4CzoZXAo9KnguS0Y3uhG0W0NQ3a1bC6MQfeEBg2VgpoJBAP73q5c5K0//L+dlcPboEA+lDCaYowv4SxChsl5isuueAgjBY7jFpxYwM=
Received: from DM6PR18MB3052.namprd18.prod.outlook.com (2603:10b6:5:167::19)
 by DM6PR18MB3212.namprd18.prod.outlook.com (2603:10b6:5:14a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Mon, 31 Aug
 2020 11:41:27 +0000
Received: from DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::905a:ebb4:369c:ae1b]) by DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::905a:ebb4:369c:ae1b%7]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 11:41:26 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Xianting Tian <tian.xianting@h3c.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] scsi: qla2xxx: Fix the return value
Thread-Topic: [EXT] [PATCH] scsi: qla2xxx: Fix the return value
Thread-Index: AQHWfdsk2b/ryS/vZ06xqJFnAbz5JKlSGq5w
Date:   Mon, 31 Aug 2020 11:41:26 +0000
Message-ID: <DM6PR18MB3052E1B8F65AA24F80530E37AF510@DM6PR18MB3052.namprd18.prod.outlook.com>
References: <20200829075746.19166-1-tian.xianting@h3c.com>
In-Reply-To: <20200829075746.19166-1-tian.xianting@h3c.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: h3c.com; dkim=none (message not signed)
 header.d=none;h3c.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [59.90.36.175]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 662adcee-58ad-4d78-176d-08d84da2cb30
x-ms-traffictypediagnostic: DM6PR18MB3212:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB32129ACEA03197C58DC577ADAF510@DM6PR18MB3212.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wkFMy9X34FlxareAnEekE1nzaJRpBFYE9jT96RAo66t3kb8m/n4WbqWE7L2FZpOtgjV4QjSB1XSR2n/gNfZgb7zJ6l4JJEw9cEswGbiOeni17kAJK4fbOnUvnXwID9PNkgxBEbnzsGJ8hUU0DUF/uLxyzxJFbLBcva6fDWuHT07BNorgZKqyC24/PYXxHne1ja2gNp44uiNlvBTqfnZanfZbd0XqlbXXgVI9zSk+IYjdxvG8KX/QeFcDLU37iSpwmEJcsgbOyMsL7XR2wuZNsA7e/+4gy6WdGZrb/bYzOtbYwL3YmYNo1CieRbxNbz+C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3052.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39850400004)(136003)(376002)(396003)(33656002)(26005)(53546011)(6506007)(8936002)(52536014)(76116006)(54906003)(71200400001)(110136005)(7696005)(5660300002)(2906002)(9686003)(83380400001)(55016002)(478600001)(66476007)(64756008)(66556008)(66946007)(6636002)(186003)(316002)(8676002)(4326008)(86362001)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: T5D+lu0eIB7B0dOpVsbhLQKRJMi7yCYRkaRM2kg2RZiZB/KNyw8VbeXdb+xarvPvmmg1xxELP/j10BXgoGFlGw5CGwNG7vYRa4851P2j6lpL39eOI/xeR8nY84FAA6E4x7QlEDhvGhlq95On9oPSfmpcBhD2ZphcEMxr4OwZ8mVM/QZUzjtELbXQxuT433OilM0eAkxi+YGpFfldDy9FSlBWxVamFY4/3FgFn+rCt5G2BkPQpCx+OuhRnYlJbq1lSQ0kZcOzDi4RF5fDKhyYzdKo0X2LgnH2RyTOtjPqDu5zpsDjtzkmJZFX47WEgEaYn9b4f09oKp+CaT5D6YCtcO3G2Eq39MfefivUh374qSMyGkTycR3IJ4Psg0MfOc7Ekwdjd6G6k/RuG/kOLRE1bxdZOui16o0e3bGvmA039STomhxs4btU2RHsbznRRjPbgKML2CM2WtKY7sarlpY/eiV3Ntup2s/kBJ64cTDLVSD1+RA5Ho9p6ZAcb8pJErlDEmpVOP2bykL8pijqhez4nawmO0wbVSlVvsAXRjA6NqmL8JF8Xgz7JhWULCaIEWeQSvM5YYdpgqM4BeOd0ZZpzRec/AMeidi0qj1h0hizmqB8dL1n2uEsBbxGKbE0LqR0y0tn5Fup0a1oWI8YIeovPA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3052.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 662adcee-58ad-4d78-176d-08d84da2cb30
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2020 11:41:26.1302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PyJQ4sTCw5OjJmEmwrxINh6wYSgCbCyPYCqVcvFwD8KC0mIXIGMdko5PGG137mibfD7vWnqpRo+N3BcjC0cuhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3212
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_04:2020-08-31,2020-08-31 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Xianting Tian,

Thanks for the patch.

> -----Original Message-----
> From: Xianting Tian <tian.xianting@h3c.com>
> Sent: Saturday, August 29, 2020 1:28 PM
> To: Nilesh Javali <njavali@marvell.com>; GR-QLogic-Storage-Upstream <GR-
> QLogic-Storage-Upstream@marvell.com>; jejb@linux.ibm.com;
> martin.petersen@oracle.com
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Xianting Ti=
an
> <tian.xianting@h3c.com>
> Subject: [EXT] [PATCH] scsi: qla2xxx: Fix the return value
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> A negative error code should be returned.
>=20
> Signed-off-by: Xianting Tian <tian.xianting@h3c.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_target.c
> b/drivers/scsi/qla2xxx/qla_target.c
> index fbb80a043..612e001cc 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -3781,7 +3781,7 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
>  		    "multiple abort. %p transport_state %x, t_state %x, "
>  		    "se_cmd_flags %x\n", cmd, cmd->se_cmd.transport_state,
>  		    cmd->se_cmd.t_state, cmd->se_cmd.se_cmd_flags);
> -		return EIO;
> +		return -EIO;
>  	}
>  	cmd->aborted =3D 1;
>  	cmd->trc_flags |=3D TRC_ABORT;
> --
> 2.17.1

Acked-by: Nilesh Javali <njavali@marvell.com>
