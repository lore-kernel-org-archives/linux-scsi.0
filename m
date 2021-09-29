Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C784CC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 18:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1DE461501
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 18:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345353AbhI2Srq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 14:47:46 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:24850 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235814AbhI2Sro (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 14:47:44 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18TI2QSO008708;
        Wed, 29 Sep 2021 18:46:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=GqiajprccMMyemw+DF2xrbrPFwKuc3lzAtXhZ8fHMI4=;
 b=JyOoTjGV9CNY+W/V5YNuAyx7URN6X64OUrsab822YR6c2mJzBwVGrTDgYXrP17LcmLoi
 oADRXgk7g36VKnD8IQxsV3J6oAeyQPmQH9L7LYLz12E2at4poB9UY7wUJzd1OcD2SA/a
 VQe6Ni+/yZZR4V82thYQkTJyupvzNLhYuXFNDytLcOItjNrDTcggy13BsbhJS+CfhHS5
 yzf/4O5y+44OzTSzPXrvq2OTw2pe/NbT5JcIVgwkbXj46ZQZLJnNRztEDKvesV9SKJnh
 k/EglIN6AIhJox89ScjaUE71dnOfcntfP+NLCCaMZlrguO8OEsmLDalxeD7zVr51y+MR Rg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bchepr41y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 18:46:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18TIj3Zc145050;
        Wed, 29 Sep 2021 18:45:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3030.oracle.com with ESMTP id 3bc4k9rces-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 18:45:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OnZ29XEP/XMEpQjvruLqjDsNHh+a2p4QNcvbuaD3BW/6AvOScwgi8L+8IAOT52q+m/xC2P25BywobY1+T1nE/WL3VyvgLhjKzujHX1KfmZCBvAz9nx0iW2m0VsM6Tk8q67OIXMMtJcBlUaTo0oGBw1FjOPmUR5wAXkmlmRFzC/HaXX/G/dxlJyIa9VdJOs7lbAAjLkcueHGhhPhbcUqnNyJqr2k6KIwBsGUWxO0jSQGrb+IB8AP0B4b87BKV7Z3n8w0IRju9dIJFlycczOFMGLK0kk7TdBIMSbq7K7lFg6kJBW2BdGQemGJEk+EPGR0/7NioTRgP1fb404zy9EcD6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=GqiajprccMMyemw+DF2xrbrPFwKuc3lzAtXhZ8fHMI4=;
 b=e//ONip7TtZFdsjacUJs0UXVZXFCtjlS3hkR2oCaky3fR/DBSEhBie1+LCJLEUPaHoBkTa57t8xIW9Ejm3+g9HRUrKe2WXoKZefNyNr5umePBQ2qD0SEnsOdqfQw2tzxGB8m4ZKOT9uxL2XUoSUmyVR0hYwh8M2Wjv48nQmWwCkUbqxw03nwDw2glhzLxSaU4TEGLktpllrYYQwDP/6jIhOHMOm7Kw/cxeyvV3KFkOpKB+OHE0932xIbONfdtvVIMBT14oMjQLgm7R9Cu7AI53sWsKbZEWzjFQX/bAhnptLKCifUw1oVC3JXEPH/WUUm+sqIxyWVRT3S5QvqCUNJWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GqiajprccMMyemw+DF2xrbrPFwKuc3lzAtXhZ8fHMI4=;
 b=nFEEHKcwsIMS4svCbzzL6/IG7mfqAb/btDrgpWtMZllUff9Tcn26giqJftWAP/nqrScxNHvALTI967Q1JkgpJCH9g737RWXIaapd31chdFEjwdVQDGUoB6hxoXHo+Yn4VSVcY8ftFDP7zOUhmJzLa9YYq0W2zgZE+f7CGvcTlBc=
Received: from BYAPR10MB2934.namprd10.prod.outlook.com (2603:10b6:a03:85::22)
 by SJ0PR10MB4560.namprd10.prod.outlook.com (2603:10b6:a03:2d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Wed, 29 Sep
 2021 18:45:54 +0000
Received: from BYAPR10MB2934.namprd10.prod.outlook.com
 ([fe80::a835:7e9d:bf65:47d7]) by BYAPR10MB2934.namprd10.prod.outlook.com
 ([fe80::a835:7e9d:bf65:47d7%5]) with mapi id 15.20.4544.021; Wed, 29 Sep 2021
 18:45:54 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: simplify scsi_get_vpd_page()
Thread-Topic: [PATCH 1/2] scsi: simplify scsi_get_vpd_page()
Thread-Index: AQHXtRLifA6tIJJuyE+53AqTMtjvWau7Wk+A
Date:   Wed, 29 Sep 2021 18:45:54 +0000
Message-ID: <01A5F4A9-F237-4448-A6A1-BECF2073F89A@oracle.com>
References: <20210929091744.706003-1-damien.lemoal@wdc.com>
 <20210929091744.706003-2-damien.lemoal@wdc.com>
In-Reply-To: <20210929091744.706003-2-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db9d3fef-a43b-4f7d-3229-08d983795e0b
x-ms-traffictypediagnostic: SJ0PR10MB4560:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR10MB4560A04DED095A0C7F840FBDE6A99@SJ0PR10MB4560.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0lwC2hR7N37nHBAPQ1TCdzRU7Af6cMYhQrubqC29AgcTuLc7b3xGZawljYk9E8jGe0fkFybSw1vP9NAyuRW2CpBgyjyDG5jMOx/Xt7LxQris+BMxIYRwDiv/OCF4ACBgodwmd9v2hlNENcV2mHhhGk1n70FZpXO5uEoVdkuarboUjumgYLVlWY4JavLeamh2+dBOGP8Uy/TyV91hpUVv/D7BxWC7YtT4ThE8wgzFVW+lMbqJma15qPJvLtzCNI/17yIFQs+dVcUd4k9IdPLf/IjK4IQ3pQhBKMuWu7xVk7j+PB0UqRpfswvdFBvcyey58Z74X6N9Hat5RA/1vYdjudYtKZlbhSGMGkcdRwqa9+X0OlgwgoFuesk72Z6IEmk0P8zdsa+SKp70SPHjjAo9yC7XOO/nOPKUPSlSlkNnSmhPGrbP9wdhUzw7a8WcC1q0DAY4IdCa0LlclNE9U/+LSybM61spLM5ADugRaShpMBaLiiiSzyUkGt+jSCF9UMgr234OB1LPcAvDNX0fapOBXOIUCvu5pY6wDn7TfYS/SSGymutx7bKwiUQsUEA88BLquq2hGki6fFIAsg/qtqy8KQS3J1IRp3B8gxCLXT7KMkYcJIs1avWZxjt9AFO6CAELg15OcKc7nnbUi8UPjDJqkE0QAGp+GYqAziiZAHF2vCfuYpxVHhCQL3s178Cn5ptDCLGYBgLRLBUh+/P8YOToEkwA+dxrbVE6o6OddfsJ4Qp4zOG6YmnhzCcx7ODH7LDR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2934.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(83380400001)(86362001)(107886003)(4326008)(2906002)(66946007)(6506007)(6486002)(53546011)(64756008)(91956017)(26005)(38070700005)(316002)(54906003)(76116006)(66476007)(6916009)(71200400001)(36756003)(66556008)(66446008)(5660300002)(38100700002)(8676002)(122000001)(2616005)(186003)(44832011)(33656002)(8936002)(508600001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/2A17qDseMJ2BTep5+ETuBf4CHz//5Z5SU7zkhFgef6KkZ0g2VwF5W8wx+5F?=
 =?us-ascii?Q?jw9VZ/nSC18SnVgxKrfe7BUlXo1Tjry61uTxxh7ye98YnYEdChugDZ86Zj7E?=
 =?us-ascii?Q?PDoeegkx+2Ghf5p6EZm8C2OHa0Dj8GV8KSttScnpZ7Ht8aJnvfyp1ZA+trEk?=
 =?us-ascii?Q?VzHXHJe8Ms9HeeKpMo4mI5Mu/bFFRUrX4GjGqEU6rCyV/0f+KO8KAa40P9fO?=
 =?us-ascii?Q?EC9Az+BOVqHFpyVHseTHeQG73BnEt9nyd/IwBCvVwlJbXyeWQxCfS29HIkK8?=
 =?us-ascii?Q?pzHFkoeeMCkwN/LDaClWVKJQoHZdVExOaBEfiTjYKlP0UTbuH7kpyfmZnoEm?=
 =?us-ascii?Q?jF+0f0YGy9C2Dh5t+CRL4K0bFoxQ478FZJilkQP3Zq5G65U5xrHYNgtYiSqv?=
 =?us-ascii?Q?lrbqKYaUUK0UsFP2vfktMzfm0etLaDM8QIkDF80lz4oCk4sBcRiWyILaP2i0?=
 =?us-ascii?Q?sU/wBAdqfAvCYIx0DRzORKkFboNC3qDCekRCp6jUefeaWqAamVEaE6Cyeb7y?=
 =?us-ascii?Q?QrHmkg2BMV5wRFislCbi9eI19M9AQbFcCSH3463dteTMzhS77fnfZ1iqUelN?=
 =?us-ascii?Q?AQdOtgP6o91dh69DDjVygTgCG+fJCqAnWu8O5JBtOBBB+RXJWI2dfQGOCP2R?=
 =?us-ascii?Q?+KdIDOigrQzSMuOrUFbO7RGa45fab0sHMvOWjm+ghir6NpyfFzd1qHXkZXcb?=
 =?us-ascii?Q?4lzIhPN836QF34U8Q1CGRjdjajK1q6IjHqTOjn6ATDdGztEaRwVQOk1zEAO9?=
 =?us-ascii?Q?oc081mC3A0fs8MoH7YVEiJ8QPRF/ZrWxYdKZHbYlxlyw1iYvFW2yVJBEruEB?=
 =?us-ascii?Q?ZHWinoGsqNtd9+9mBA3nhYgH1Iw+C1JPBCe4kDgPviWMARM9rs7q082Djr+t?=
 =?us-ascii?Q?vDqcjSRT3YSTik6/6A7StHxNyr4o6PKpHuvd0Rp3327cz/o9NnSCK/VJOF1+?=
 =?us-ascii?Q?AuzpHLlhqJyjs9LhE2WKoRwqQofX3X5Mae5hy0iVedea8NxAog2cFzShk2/Q?=
 =?us-ascii?Q?CT4XLyhlLItw5UPDH7rHlPmLBCebOpxNak0CGm59ka90pud69u4v7ztzQ0Xu?=
 =?us-ascii?Q?DSLGxkq3PoqLFDT3gGf+v6saPCuQnuUviIzwg22SctpD5jV/Ev+XY9AQ65jL?=
 =?us-ascii?Q?jljDSLtCJ6rvxY1Z4XaBAa8Y9vtNRfC1mPXQw4wGsi3pJIJhYgylWGkwb+3K?=
 =?us-ascii?Q?Kbs6pTge+AEDVg9k84+sLZouyO7H+ck7asm/BleG7rYTAc+ui3oQvGzMrPiE?=
 =?us-ascii?Q?PYybQg8b0jpNmmRqKw4Xvmi2zcYCS8ls1BZ756adzlD0vHZOFoqASfkKjfmT?=
 =?us-ascii?Q?26NOoxjqpg9ZPz3QKUjNSo3L71K33eInSRSYmBFCL/QH6A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7AB2FEA87417BB4583EFD3B4A1973971@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2934.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db9d3fef-a43b-4f7d-3229-08d983795e0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 18:45:54.0390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 92wFQeDTPN7vWyk0lzjKoMwdJUIL22l01F6sc5FhyF70uHc38Hmuc8JIGrucuKClBbrUitODpbnDdDuwKROiOIkqNfkzPG1n6/8dQUTqezk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4560
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10122 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109290108
X-Proofpoint-ORIG-GUID: dBRkO2TE-VlkPdCyhERwh5vp7Wy0xb_3
X-Proofpoint-GUID: dBRkO2TE-VlkPdCyhERwh5vp7Wy0xb_3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 29, 2021, at 4:17 AM, Damien Le Moal <Damien.LeMoal@wdc.com> wrote=
:
>=20
> Remove unnecessary gotos in scsi_get_vpd_page() to improve the code
> readability and use memchr() instead of an open coded search loop.
> Also update the outdated kernel doc comment for this function.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
> drivers/scsi/scsi.c | 31 ++++++++++++++-----------------
> 1 file changed, 14 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index b241f9e3885c..6be68b3427a0 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -339,47 +339,44 @@ static int scsi_vpd_inquiry(struct scsi_device *sde=
v, unsigned char *buffer,
>  *
>  * SCSI devices may optionally supply Vital Product Data.  Each 'page'
>  * of VPD is defined in the appropriate SCSI document (eg SPC, SBC).
> - * If the device supports this VPD page, this routine returns a pointer
> - * to a buffer containing the data from that page.  The caller is
> - * responsible for calling kfree() on this pointer when it is no longer
> - * needed.  If we cannot retrieve the VPD page this routine returns %NUL=
L.
> + * If the device supports this VPD page, this routine fills @buf
> + * with the data from that page and return 0. If the VPD page is not
> + * supported or its content cannot be retrieved, -EINVAL is returned.
>  */
> int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *b=
uf,
> 		      int buf_len)
> {
> -	int i, result;
> +	int result, len;
>=20
> 	if (sdev->skip_vpd_pages)
> -		goto fail;
> +		return -EINVAL;
>=20
> 	/* Ask for all the pages supported by this device */
> 	result =3D scsi_vpd_inquiry(sdev, buf, 0, buf_len);
> 	if (result < 4)
> -		goto fail;
> +		return -EINVAL;
>=20
> 	/* If the user actually wanted this page, we can skip the rest */
> 	if (page =3D=3D 0)
> 		return 0;
>=20
> -	for (i =3D 4; i < min(result, buf_len); i++)
> -		if (buf[i] =3D=3D page)
> -			goto found;
> +	len =3D min(result, buf_len);
> +	if (len > 4 && memchr(&buf[4], page, len - 4))
> +		goto found;
>=20
> -	if (i < result && i >=3D buf_len)
> -		/* ran off the end of the buffer, give us benefit of doubt */
> +	/* If we ran off the end of the buffer, give us benefit of doubt */
> +	if (result > buf_len)
> 		goto found;
> +
> 	/* The device claims it doesn't support the requested page */
> -	goto fail;
> +	return -EINVAL;
>=20
>  found:
> 	result =3D scsi_vpd_inquiry(sdev, buf, page, buf_len);
> 	if (result < 0)
> -		goto fail;
> +		return -EINVAL;
>=20
> 	return 0;
> -
> - fail:
> -	return -EINVAL;
> }
> EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
>=20
> --=20
> 2.31.1
>=20

Looks fine.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

