Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3BDAC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 14:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC93361153
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 14:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348925AbhIHOXQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 10:23:16 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:8732 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229600AbhIHOXP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 10:23:15 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 188Dv73J012553;
        Wed, 8 Sep 2021 14:22:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=nB+7KVhDMhA2V9IdYn9aVdH0hyzvkX7u5IPhAxKDoXM=;
 b=LpJ5ZeyZ2KnyqgWhPCDBIF5FaJRk0LyZb7slkq02AMR5PkoZmLXpLA2WdAb0hE9Bx5wU
 8kT37x/SwWW7FClSJ699oXqR7gq3w16sFaDboUDIkXxr9pfxTwvFJvCXKtwe/uH43Wbi
 j5KfPTGvbd8IokH+4INtB0y0tRfTtU4Zj0Z3NB1c7xk3olJwPNXs+vJWSkGU8r5OPvhD
 oHjDWMhv+EDWWyrh9aFJuaDfprsX02Tntg3sbZW2H/IDCayWhX4UoBw+AuSKsDPJZbmn
 2KQNFvnMNaRdW3uIZo6qwCk3GD7uSWDfPlnjyJfA2T8GwahV4doAH4XzCMlVuloJFuJx Wg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=nB+7KVhDMhA2V9IdYn9aVdH0hyzvkX7u5IPhAxKDoXM=;
 b=FSUXcceTLTjUNMcpqILuGpb6arrifHg2wSvds5GEPYs6+Eom3r3P8S3mEqgH3IWQrVLw
 /iAnOWiFFHmhxboODZ9q2yVDXvmCqkQPO6YuWTaHbrweEZvxPEZ5JzYvpMef1jONRLHi
 z0jyjYp3uhDaqzOTU49jidMsZbSHxIowIMHTCHw+Z83MrjO2WyIrDMLhFX2NnyPgH6GZ
 03s34/Vf1hVNpHlnclwGM7M9FC7ETcdSVfD08P1rzuiMJvgzkBskodUCYHbJNHQHuzzx
 r4zU3RSoTgfkz8kdxzwMU+XbSCWrEtXTpOVKNI9R2fyYDp0+/K7mmYEdj0V/gwI0kM2N Ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3axcs1augt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 14:22:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 188EKDiF156863;
        Wed, 8 Sep 2021 14:22:04 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3030.oracle.com with ESMTP id 3axcpntj6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 14:22:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cb8CjBpA4hGaeAtYgiJep1xLK9dx8KpEKTmdxtjpxQhDFXk90V3E2lcWatXdmaAG3+A4/Z1dbL2tYsCiApG06nk6nH22Q9GzFB7pzA0Enlx6NzQ3EuBbU33ymjUApxoUI4sXBkjxroYyV4HrqgLjIo20XZaMy+QNhr18MsqpPxqv8+Qo3K2nvTwrx4tmRsJVFpHY8W2g3M08Iyxvh8vJUyps2HXnF0Kru/45gKGL3ASkXUbEdfC347BIhHtjKhml1TiH4+gvP1AFs0X6v8V7A4Z02CkIEvuWuM6weWwFPVkDDIvKRbVv8zENa4mXaQP7JlZ1OMipGrZCKOco3AU1lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=nB+7KVhDMhA2V9IdYn9aVdH0hyzvkX7u5IPhAxKDoXM=;
 b=h/xQG1Odng3qM660tSU24j12luZWUiRAfxhK+yXgTWAvKtKPNsMb/Xh0PMf4tQzDooTGZc0RI6XO1UvypcVSxsko+pwlXqV5kjSO7XpcU1ZjDThULRjemA7i6dB129xBLvg8bklNC9hDVwJjq9uqaYdQI2gGGbOrudh+AjaGfP6mV3fePzOfQfvMRVDhcPYa01juF52AERMkEQVpa28NbTOIimZZ+KI12QNM366yYSEn6QUskUZS99cvbutlwmN1+H1Fn1dWYESHwpQLymmB0myw19jqMVeB/Xw0ZE8GHVjC6UC4+I90q47GzIv2nYS5b0r1zOea3sqtpqRsaFIhDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nB+7KVhDMhA2V9IdYn9aVdH0hyzvkX7u5IPhAxKDoXM=;
 b=YlLWHogL3MO0y0+QTGBssZwqQN7CP5Z+Fcn+mQUleA71IKvMS9FsSXahMRYnVD5iXnFhBBKV/QFzDh3tZh0jyikvOn3gnzHw9o9rRd9t68lnQeUg2IVB7Ms7yWf4OrOn6adtamnmIWHLtr5G5UyRUhwpZvVSC1cee4iGMra3tVc=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.25; Wed, 8 Sep
 2021 14:22:03 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::38df:8fa2:1602:2dfe]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::38df:8fa2:1602:2dfe%3]) with mapi id 15.20.4500.015; Wed, 8 Sep 2021
 14:22:03 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Naohiro Aota <naohiro.aota@wdc.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd_zbc: ensure buffer size is aligned to
 SECTOR_SIZE
Thread-Topic: [PATCH] scsi: sd_zbc: ensure buffer size is aligned to
 SECTOR_SIZE
Thread-Index: AQHXoyiKLXsXf4y9h0aIi193sLb7JKuaM3cA
Date:   Wed, 8 Sep 2021 14:22:03 +0000
Message-ID: <9432B19F-358C-4D27-8CF2-FD105F549E47@oracle.com>
References: <20210906140642.2267569-1-naohiro.aota@wdc.com>
In-Reply-To: <20210906140642.2267569-1-naohiro.aota@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84878382-7ea9-4c5e-d857-08d972d4077b
x-ms-traffictypediagnostic: SA2PR10MB4732:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB47324B30762FF0DFA8743F98E6D49@SA2PR10MB4732.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /LtUYs8qZ0Ugd9hJ67QH/dTHULXUARw/48HEtkOreQTjUBxbPyS6KJ9KP7a/J1lz3YMxYFKdU3+PZG12fo6spvzSdxtYvEsS+RE+ErZKeX77dAKRe9GFH6xEmSuDdS+J9KBXYzapaNfuQZuC8SELvgwVEaUkv++ioUNHcZgofjOU3SRnsKAlgvH1jeCKUTwpJhJu/rzphm59ukub4CKrpdwWp2UwxQXPFdzKuYB+CfUgF0Q2eI4Hvu0M/0O5KgUmZhIttlY7mSFiIzAVpcW7VbStcHCFVA3K0yqfY0ocDX0Bls84wDbqi0AIs5JGkL3xrhbkFhutf5VQIR9q/8jvwA4BG+7Y73LEoSxpxLtdNNp5R+D4YRatXx3Caot9PGOOC/yiIU/CLRL5tWsUxwfV5b2Vz2A5Cyf7R6suKTvkKfg1L+T50aqEFrNsyNmO/mIK1kWeqzHeEYMhOIHqUPi60eHFVIcm/43pErbWjrhoAn0gn5VuHj3HruUsZ2V6TNdbAfbFKIIOo6+viMJWosJW3GZBxyS496I7tdnzTphfLcKT3eWUqOB5G8wU0JFjTzdg3MyOTUF/uwGeHkb1hojJsf+xq1aldqrY9VaAXx+mnCTDCHOv9e2j9WyNon+SerbVQLiQqAa3gb2r6YOgeilV6liWSlG0VyNwok/ejTSTTaDs3sOZpOWuAcOsl/1AcMhbWukxTD0zDWnFiRfnhT55N8ps3/sKeMLMlm7ZZyKd2ClJM24u2XuDtVWwqJKfm8fG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(346002)(366004)(376002)(478600001)(4326008)(83380400001)(54906003)(6916009)(316002)(6512007)(6506007)(2906002)(53546011)(6486002)(86362001)(66946007)(66476007)(8676002)(26005)(44832011)(8936002)(66556008)(64756008)(2616005)(71200400001)(66446008)(76116006)(33656002)(5660300002)(107886003)(186003)(122000001)(38070700005)(38100700002)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?x/ng0YXTECPCugFLoWgCx9uqQ/oyo/92Z4frfmrOfANUsiujfpSnIhkWwqvb?=
 =?us-ascii?Q?Q0kF7cJ3F7vA14A7XJzyNji8Y8vUStfnGKHjeDZ24nMPEDY3Bl7Wb35yNYth?=
 =?us-ascii?Q?stFUXA5tfcOKjWaxv4XpdwDVXCd8yMKH4mV+4Kvdjg1/cnbYLV4/x1J1Et//?=
 =?us-ascii?Q?Ul2I3yNHd0RJZAeTdzCB75VxHFZsx4eyA6vYgo10zUZ4CDC5B2e4GnJsAf5K?=
 =?us-ascii?Q?QihM5qPbFPRHxUuTP2ZHsJywcegYqMaltOt4AL3J2YHr/MgrXvULO6yjQlgI?=
 =?us-ascii?Q?WFptqbA/3ABGhdQwEpacsYEZDUTquNmLCRLR+AodqMqoF5mdax9QNVWRx79J?=
 =?us-ascii?Q?2uizoVnXhPLHKVXt0+oi3sT5qpo0lSqSkQUB+/S3bf9u4MfR38VFQ7CoC+e4?=
 =?us-ascii?Q?YWK4OhVqk0de/h7pt/t3l8X3y79Xa1Ve206txX5bhjw54CDfLxFLTufB5tv9?=
 =?us-ascii?Q?uJ2id9ogDkGCcunBwnQJzYaw8QuyTgBFZ1qXHyNGgNiWBJgKTbk7utBjeBoE?=
 =?us-ascii?Q?qG8+WwKOy7TXx9qabpRD7owPMK6eW+I95jIJQsQH7rctcoFMdZk11i/NcmJy?=
 =?us-ascii?Q?cfbzhSSFE7XC8vnu9o2bAYfyyozEePkNUaU4uGZo+nTQ8KFp1FTLV9QWynn0?=
 =?us-ascii?Q?MwoL1wPmVCBRD8RKfX21+tXSCw5ffXDqn+UhzHgnSFmeuSETpJ79CGwIUVL2?=
 =?us-ascii?Q?hxmDu8AbHvQsO6Hl8sqxO27gYfs19Ny89UP2fqFG62DQDs9sMZs1NsJRdkLT?=
 =?us-ascii?Q?vHsNCu0HJIr8Db2Lo+rgstwu/24SQ825Kvxh4+x7KhREkYUekxcdMYGSc/87?=
 =?us-ascii?Q?JFhEKqGHJF4BjAX7/VWiqs9sDMvHrYIMIZsfprYHNba7ffn9LA2EavfpezBm?=
 =?us-ascii?Q?8iWdI8FxuGV3KCIn22Ac8oXG6enjFX9YLzd/DZ3A5thLZ/3vDQyyrIADUZL6?=
 =?us-ascii?Q?D9qZ/FVcHIdolAzmJv6iTkaDa6+3Aexb919v1avZl9JvOUxI5YORZ1dx6zPe?=
 =?us-ascii?Q?2EGaPB8M4lO9V9M0HInL0xGJbjNleBqWtrxm3Gt403hHjIvyaZUbrnMMOUl0?=
 =?us-ascii?Q?yYkFnD8L8Ynzujw3i9a4RZz/XTx23AfCFhdKm+7vEb+tS2xCQm4S6bLMkYIp?=
 =?us-ascii?Q?5kR8198S3QgozkhNz8nEWqLdAuTLY4sCVKd5Uj+PNDspm6inKzWlHWzkfvoW?=
 =?us-ascii?Q?WocRXvzIfRDywnlyIEGilR7+8O1nuVaFRL+PXgry75li0pNnRbeKB2qVYxzs?=
 =?us-ascii?Q?jtWLQC8tLWTtRz2riElkr2gvE2aeWYQ+PIU7F0tB6TbD9znsEE4Sm+P6YVEn?=
 =?us-ascii?Q?TrRv5MFvCo62EemR15jt7B7/h3MxapwAPTF7UfZXcAp+1Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <213450D89032C74B9DB4CEAECAD578C1@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84878382-7ea9-4c5e-d857-08d972d4077b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 14:22:03.2006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IQiWYyvOxMqKQYwSTh8zcbrsB1COKe1jXO7iD4651+og57rSo6nq1Gp6qIJfzjiT3fCEFLPubQgCeXqvzrapF7naPwuKmhInFl1CgWVLja4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10100 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109080092
X-Proofpoint-ORIG-GUID: 8y1qvyFFYjsEozV1eDnUotpP7S86BzEY
X-Proofpoint-GUID: 8y1qvyFFYjsEozV1eDnUotpP7S86BzEY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 6, 2021, at 9:06 AM, Naohiro Aota <naohiro.aota@wdc.com> wrote:
>=20
> Reporting zones on a SCSI device sometimes fail with the following error.
>=20
> [76248.516390] ata16.00: invalid transfer count 131328
> [76248.523618] sd 15:0:0:0: [sda] REPORT ZONES start lba 536870912 failed
>=20
> The error (from drivers/ata/libata-scsi.c ata_scsi_zbc_in_xlat())
> indicates that buffer size is not aligned to SECTOR_SIZE.
>=20
> This happens when the __vmalloc() failed. Consider we are reporting 4096
> zones, then we will have "bufsize =3D roundup((4096 + 1) * 64,
> SECTOR_SIZE)" =3D (513 * 512) =3D 262656. Then, __vmalloc() failure halve=
n
> the bufsize to 131328, which is no longer aligned to SECTOR_SIZE.
>=20
> Use rounddown() to ensure the size is always aligned to SECTOR_SIZE and
> fix the comment as well.
>=20
> Fixes: 23a50861adda ("scsi: sd_zbc: Cleanup sd_zbc_alloc_report_buffer()"=
)
> Cc: stable@vger.kernel.org # 5.5+
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
> ---
> drivers/scsi/sd_zbc.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 186b5ff52c3a..ea8b3f6ee5cd 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -154,8 +154,8 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_d=
isk *sdkp,
>=20
> 	/*
> 	 * Report zone buffer size should be at most 64B times the number of
> -	 * zones requested plus the 64B reply header, but should be at least
> -	 * SECTOR_SIZE for ATA devices.
> +	 * zones requested plus the 64B reply header, but should be aligned
> +	 * to SECTOR_SIZE for ATA devices.
> 	 * Make sure that this size does not exceed the hardware capabilities.
> 	 * Furthermore, since the report zone command cannot be split, make
> 	 * sure that the allocated buffer can always be mapped by limiting the
> @@ -174,7 +174,7 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_d=
isk *sdkp,
> 			*buflen =3D bufsize;
> 			return buf;
> 		}
> -		bufsize >>=3D 1;
> +		bufsize =3D rounddown(bufsize >> 1, SECTOR_SIZE);
> 	}
>=20
> 	return NULL;
> --=20
> 2.33.0
>=20

Makes sense.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

