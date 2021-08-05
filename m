Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD529C4320A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABBB36113C
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238788AbhHEPej (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 11:34:39 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:39528 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233376AbhHEPei (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 11:34:38 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175FVaLf008239;
        Thu, 5 Aug 2021 15:34:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=82V61MFtmMi2fPTMkFJ3z6iVbaAAaa0M4lfnslh5N7E=;
 b=PRIzviG6x1mNOVA1sOFag6FSW/BSeiPjZpeJt5uGc3p+yGtWgNW5iPdwDjgd9VHDpc4i
 Itd6CvnfXOdoqbfFVvPP9NV0c6TfXk0AHKPPvsxS8J/1If2Ku/IG8dqB6vulIWMWWB2E
 bSTHXz7NWqEK0KTVroa3X9KbHXjEi1AilXT0YV/evMUOPw+7EiQyy/q1YHvY0KpjMA4U
 mqNkVUqEW0RYJrCk1zm8H67Sj80JJWRSoLGnVhUHxAIkfWYRhN5mrwUhDB5EgCMbO/g1
 0f0yuqD8DXhIknTi4RJBFRT7wkCwm93uUZ4DdWQNSiTgvUZbPmKNSRXGlwYOyJhBsd1l vA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=82V61MFtmMi2fPTMkFJ3z6iVbaAAaa0M4lfnslh5N7E=;
 b=kznwHrsa4HA8c4O1oKqsJa5ZD/Qz8roGsyGvGUYFtdDO8Xk7cCN6yaSdT+8CIuJMwvuR
 RBpke5E3yHTyHAL3BN2rJgN1oohPrfdv41mH4kBzp8fqr8oSVgz/TrEZm6Ohkw7B7nwL
 yWEHOgODiLqklEEqgUkZvS8IGDHHIu0SnqdHWn5GRzcsputIf1NLtoJ98b5/AWrRh88N
 pguz+boqtb5MQ5LySMNakUtUR+h1WmAzRtTXQiftCfXh/EWGr3q3tCljMHy07IFv59Bd
 F/iz7QTxlAgAAB56KLafruzIp0K1GL91ANJr93+gawfGPtixx7dYfJ/F6Wvr/NfIhK/W wQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7cxn4mje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:34:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 175FU6nL037731;
        Thu, 5 Aug 2021 15:34:22 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by aserp3020.oracle.com with ESMTP id 3a7r49xgh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:34:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mniaKJy7BIRXJk6XBXzTnat4c/m6tK+/Oq6em5n4Zi4kbDQ3NIHphk+QNZkaqUwR51wskTj5sC2FGkYBdtNQz3VArfAjUTb6zvnSQmGAtRTdmtegI7A2/D6aYOxfyMJHSv7QDVI/fTzce3Ofs7CpLHOn/5sHlKEKqFtqrzowwfyimdProJN8omOPjJZ3hxsAymLc0qs4KAh4Frmfp8rd8CioCJ9qMmCJmRsSwZSgBiPrGsZG2zh2eqQ7Pn5XBHhW8e/VEc7y6ZlPU7Ti2/lbzfX9/LiRTRAS4RbqmN8C+rEA+lhcH/cInPncdMtD9/bGzAtmtNUnqggLRggIX54TeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82V61MFtmMi2fPTMkFJ3z6iVbaAAaa0M4lfnslh5N7E=;
 b=XUlNPbnsFxJGuL5BX9jHS/nVrkc54fgSlF59waiGfC18ImI27/25AgK0hWokZE4+eyP8PnEYkapTSn3o3wqins9H+pC8kcnOPloHVKPkT1xc9XLuNJb6eFovAOiJ0WjG9aDG9vvGsI2D8rln0ItrwkIAzHfqYptGS/8QE5BX+Zg0KM1cJjw/F23imFB5m/JfCyAZyybOSboAVnuS5kTcZGbhO592usSxIeQs645o6e/ggIPhR2YDkkSQA1zVbhfRKRF12BlYXc6Iq7PfTTN7c3ebE0l6AlKxEReU1/OkvqvqN1QbUjH0CYn3dEn+hc9d7PAfsM6tVhJCsfUM3cINug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82V61MFtmMi2fPTMkFJ3z6iVbaAAaa0M4lfnslh5N7E=;
 b=gHlNbXiMjvcKMRFWeLDIGXiKzxsD3/x5L2kTvnBl1VwjvOBQGbzIItvXHPoTmSMoQdsxmfVdrHU4Ar+P51l7h9Nsw7AY2RxCt9V8vhnVkcqMnfjOBftpAOebAVCG6VvmQpjsJtMccqATldmHSStWgsKwc7L3JQRMxnrtHGYNPwY=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2703.namprd10.prod.outlook.com (2603:10b6:805:4f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Thu, 5 Aug
 2021 15:34:20 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43%5]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 15:34:20 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 07/14] qla2xxx: fix port type info
Thread-Topic: [PATCH 07/14] qla2xxx: fix port type info
Thread-Index: AQHXiePwEZsRxaaVU0OXe/jKKAiA8atlCu6A
Date:   Thu, 5 Aug 2021 15:34:20 +0000
Message-ID: <1A5A20FE-CFB1-4C89-9BDD-C77BAD854E3B@oracle.com>
References: <20210805102005.20183-1-njavali@marvell.com>
 <20210805102005.20183-8-njavali@marvell.com>
In-Reply-To: <20210805102005.20183-8-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e23fb6d9-7165-4829-1653-08d958267e66
x-ms-traffictypediagnostic: SN6PR10MB2703:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB2703AD5E1E0B04E48569D13EE6F29@SN6PR10MB2703.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:478;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PpJhXdPqNud3K/qydqjSUCN4HUzjaiaSEDQIOv8aPzboGtmAY5ip0nTDOqj9me19v1TE4KXHixHMzoq8BZmrOWTeGgmMWZjo6e2cg2iDckxycxnKiQ8MFyxYJGfIOkTjuq9lDkfnfZsnPZbi6jGTYkRzcg6plOXTCTzMjwzRq8G2Ga9XQFEhBmxzP6c1T28Ku5fvtCw6sKVsH713zi5Z0zd1vAysMPiNDSQUVJPC2onB5hZxX4kQy2OPhznKuHALhQHrwTQYD8XbsARZ0PtWo/dWPOeVINMY5rZiW+9N5JzunoWYzvXglU1zq0WZnU5vxE4mT8I3wQbH6izc+SKPsiJxMC5yknn0QXsWKxea1IuCdDcOXG2YB/sL+0LstVPWdCvxuQPqT4vJ5dhAEPWuEUzIwwZWcOopZ3vtG1pBLlZNkqhh/RKEPk3mBc3xzksOVRnjb5KJH8Y7g1OOdnOINLSf5o5WBk1e3tcBhTNjHknMulJKCvKqF37KTPpELQsdPGsmypgufSzJ1gC6KgvsbxLAu9ZO/3Yd7zxeCFv9BDEDxHv8M7RMpxvA2wGOCH1DItNWF6bxGvLwnFHmJQrOXFtJRV+knDptGhjaOX66lU+WJpOtvJVwp902pbU1CRGF+undwSmETtMtUOoXrOBnhDcc8l78Vdk926iLwOLF2o09x/cOSEaxDK+b5D/9ipKbbToG5qsvCZDpOeL3cSlh7GlaST9TahyLruupk8cTWI4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(39860400002)(366004)(396003)(186003)(44832011)(6506007)(53546011)(54906003)(71200400001)(5660300002)(6916009)(478600001)(316002)(86362001)(4326008)(26005)(6486002)(66946007)(83380400001)(36756003)(33656002)(38070700005)(6512007)(64756008)(66556008)(66476007)(66446008)(76116006)(2906002)(8936002)(2616005)(122000001)(8676002)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qwIyhgS0Q6phf7poD3FeaVQ24Ge8ZkZf78Xs7+SgmecRNvpIh1mc84HPKqwi?=
 =?us-ascii?Q?WNWfTEYk/DaA/CYy3WljwIRbXbWaP8DfntstuTEQJK/lLrG5vWJMi1Wcq0Ky?=
 =?us-ascii?Q?o0tua1f+7SGSb/mILa+RvZ2cRhf2YCeH7IW7vz7EkyvoOa2PpsJrsPUXo69X?=
 =?us-ascii?Q?XwHGhHsp3273Px+bsc5UDnCj+6PBQu0M9ihZ/RxW6wvnip58z4rKqOQt199m?=
 =?us-ascii?Q?S6iOYTHqes9CZ2Y4apXMpTa5kVYB6suiryiwZHxu7MNeey1U9jjGLbKzwLYA?=
 =?us-ascii?Q?8DElEkokHhNTQXydLgiW2dxvBrTKqN+Ueh+1L4r9korVmLgmqkFh04EMNDde?=
 =?us-ascii?Q?QUuPh2TcKpHSIsxHFvsNOGukTDoFnfcVGoYo1w3YPoqX7yy6he2pC0M/041h?=
 =?us-ascii?Q?nPLK6sW/SABk26ixYj6HNdDiD4Y11cRVRB4lxcd04jt0tryy2Cke3THhampT?=
 =?us-ascii?Q?MZhlLCRmYRQzzgGFCF1RKsXstcdy7kVRaYLg+e98NiztiRIWo6cWavpLuChj?=
 =?us-ascii?Q?sDOC6TO6DqgziyC46lYjvBC3kdykbfu1VJaIKMEUiLpdX1k1P/Q8/XkAq2et?=
 =?us-ascii?Q?h5gb7yzw4a0zJVomd0cmjZeqX9/gcTkgcxIzsKXU6H3R558k8GcUqTB32LiJ?=
 =?us-ascii?Q?soXkzgPbqpXjrQeqk4dkwEgx2/P6IIcEbw4klJbSEPU78SWxl3yfBcY55BfF?=
 =?us-ascii?Q?K2LVls+K0KpVg6K9WJl9WvzAE4EL1aReEXh1MKmexzJuzBkD0rOWsNTfAQe6?=
 =?us-ascii?Q?1MDNNF8u877F4nhW0OXkNum5KLjounDu+8Sb5v871/xz6QOI6c6V4OLLyfEK?=
 =?us-ascii?Q?iLhonzHNXH3XxtmqcCjPxPD0MAxobV+jm4AE0emrNPLZp3DFP93FoTl4mTkx?=
 =?us-ascii?Q?BJyLAPIhnxP+P6R6Pg/C2r6ViihECMVfqntNfvcuRYUtN5U7D1JCfiy+tZSv?=
 =?us-ascii?Q?pa8ULiJ2Gs8OZMBhTHfCJftNmPfCY0zz56064t5ChyTyGexksi959E/Yz/At?=
 =?us-ascii?Q?1YDKe9cP8Lq8udRj/CN+iYVoplhfV+6WmEydxBuadH7tHow0VB8BDbxqporJ?=
 =?us-ascii?Q?JVE4+puR+pM/xckP+tFPVZ38VoA5Q4oAk8RSfimGlM76h9wjxnhvTLDwzhq8?=
 =?us-ascii?Q?xUpAyzu4bIMU2i3qlZleeU9TRYJ3nh4nxunc5EguBsaQyNl+Cj8Q+9fDuxyq?=
 =?us-ascii?Q?TvtvvVcUZUgR1orm+WUnxS60BND6gFVab6dhzWM76bLHFOjc2h/DHl17cHzy?=
 =?us-ascii?Q?DbqptRwJMK2OsBAktNnu59ofrcItJrd3Jy2A74gmoQHj0Q3DSPWTakwThx09?=
 =?us-ascii?Q?Sk5FKyAuyg53psZAFT7rykaP?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4169E09A58C5B84DA7B34D5149656298@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e23fb6d9-7165-4829-1653-08d958267e66
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 15:34:20.1667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dXqvQAmdWeH+26ydtqb+dYO8u7baKixN7jIrQBLJL+J4FAA5q9DwJD3oCgFxwVty6JcFIcI6i8GNul+V4ySVJ1XhNLSYJRaeHA2geOeD7jU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2703
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108050094
X-Proofpoint-GUID: 5_G-Kjh5nYRJavW-AgkeJy-W9M6-YFdg
X-Proofpoint-ORIG-GUID: 5_G-Kjh5nYRJavW-AgkeJy-W9M6-YFdg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 5, 2021, at 5:19 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Over time, fcport->port_type became flag field. The flags within this fie=
ld
> were not defined properly. This caused external tools to read wrong info.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h | 8 +++-----
> 1 file changed, 3 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index c081bf1c7578..60702d066ed9 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -2428,11 +2428,9 @@ struct mbx_24xx_entry {
>  */
> typedef enum {
> 	FCT_UNKNOWN,
> -	FCT_RSCN,
> -	FCT_SWITCH,
> -	FCT_BROADCAST,
> -	FCT_INITIATOR,
> -	FCT_TARGET,
> +	FCT_BROADCAST =3D 0x01,
> +	FCT_INITIATOR =3D 0x02,
> +	FCT_TARGET    =3D 0x04,
> 	FCT_NVME_INITIATOR =3D 0x10,
> 	FCT_NVME_TARGET =3D 0x20,
> 	FCT_NVME_DISCOVERY =3D 0x40,
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

