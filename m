Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F0BC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 14:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67F80611CE
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 14:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhJUOtu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 10:49:50 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:21142 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230072AbhJUOtu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 10:49:50 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LEYZMf011244;
        Thu, 21 Oct 2021 14:47:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=QTdfHCP8ZFPaFRVel5weo2JLzibi5sBY9g3NBytxgWw=;
 b=Er4cIR845Y/uxSc7v73HHCfiYxcQpSXh+2s1xysc/O9go4tLyAeXipruPPIAqXjQHpxu
 9lNJ72I1Uq7mTI24EXsLseSuSVXKgD8YPYTsfv1NsVetoe/TTZve7adJJWf6VU+gvzdA
 7Y8I8XQAQpuR1TrjFYEIcddHuSOUMMGMK26NzdSSIUhjvB3otlxjJ5nUNroCrWUeRwuk
 P/Quj/RUP9BseNX2nnBbJ4cSLXaw8zicytBfdzr6uWayPkNMtqhjDHeMqx587QuiBi+H
 5R/AZ+JoiphvUaTIIU64Z+84K+hm+Q5qjsUa2OydVCuTDrGS9RgG5EZ96eKwtLxNum4h GA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkw4xrx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:47:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LEau2L099725;
        Thu, 21 Oct 2021 14:47:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by aserp3030.oracle.com with ESMTP id 3bqmsj9fux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:47:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJPVfSNurb7GngdobtLSvLcePFCNPigE1yOQ55yeyEOxzeGrd32tAXJMNH6r4Oh3eH++yqCJS6dCg4a2uCaMYwVYf8IiyBxTmr7asn2BMAroAmfWhWmSFFEIcMo1WCjtewIFyHduriBVAq1ntD2oeAsPezXBhIl/Qh5G5i1RavyfqcpOJFMWLk9yFH/HIrYE8xgs2go8C4+9KiY7Dz57xJoGjk+agFMqMTc9t8u4TlcHIUobpBfeQ6JUmwvTLgVURq1Qx83ovYnWWdMU+CeUB0i2t8lmeFfVR1h9hUxNxdpKMb01rpo9k7N9Exot8ADsBzAXbspDDqIBqx6jI8Hihg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QTdfHCP8ZFPaFRVel5weo2JLzibi5sBY9g3NBytxgWw=;
 b=cDpX45y1vPZFsAH4Qzi1gzAlAbfx9BrYIN/N3Ab+dXPhY34CtCj5UM7GNO6qDnFIBnAgPbTF1KPe7mnNcZsUzyBxkcwt6CIET33gp8zrL5CEW5LvWSGMmtS0Tv1HFp7AC3+QuelW1o2+elntXn9+2E4qC2i/dskMq1od9cE3stFTpQZImCHq5sHEW0z07upHlD8HuRVbm2Qc6j2L4EskPxSHHg1QjplW8HuGzwdqubvtQfsUrGq9mBiO7PjLrYiD/ZtFoFYwq0s7zpnOtgdBDqbVtRY5N7TQNpyGmJw3PIEdNHvpQrSiRCrM0eHU0hSz9VmICaEVnYkIeb31hdREkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QTdfHCP8ZFPaFRVel5weo2JLzibi5sBY9g3NBytxgWw=;
 b=Rfn1V22CarkMjb/w4edyJLNA6kTuu5pP6yYUVjQbnnHDNqT3YkeLE+lcqGoC6SS//xTids2k04Ut2uqLOcbr4pd/7HUkodYWhRVY5kY7CRpOAmbiW1DcC85PzvReMdYHiKHiapKY5q3OiZ+UXHkTofkVvvA3ke0gh0lUotS1eHg=
Received: from BL0PR10MB2932.namprd10.prod.outlook.com (2603:10b6:208:30::16)
 by MN2PR10MB4351.namprd10.prod.outlook.com (2603:10b6:208:1d7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Thu, 21 Oct
 2021 14:47:06 +0000
Received: from BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188]) by BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188%3]) with mapi id 15.20.4608.019; Thu, 21 Oct 2021
 14:47:06 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2 13/13] qla2xxx: Update version to 10.02.07.200-k
Thread-Topic: [PATCH v2 13/13] qla2xxx: Update version to 10.02.07.200-k
Thread-Index: AQHXxk3WzJcjn9MSukiTulc2gL5rjqvdiG0A
Date:   Thu, 21 Oct 2021 14:47:06 +0000
Message-ID: <1566FAC0-0764-45C7-AB48-0F5EC81A9C35@oracle.com>
References: <20211021073208.27582-1-njavali@marvell.com>
 <20211021073208.27582-14-njavali@marvell.com>
In-Reply-To: <20211021073208.27582-14-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e3642aa-a65c-495b-3635-08d994a1a741
x-ms-traffictypediagnostic: MN2PR10MB4351:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR10MB4351EF09A2F0C4FC5541DDD2E6BF9@MN2PR10MB4351.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:202;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q1JzzMKMfYwEMXpG95I7DTlz0vWjrJuiiB5LPgzdrKuNLsyMNvPKikH4DKx9oE88tVxh5FT22v9drlPGFyy80IidsZljWPGErXnon3Ldy25S7mMf5x0M0JLDjGtf/+17YnJY5TBbcS3Kh9GMeMw35lWsVDRnjfkZxjpN1sd8NO1Zsw4//Re90BPz9gdffS1zpbWOR2v+08+2qdSadg3+GcqfTmyVr+zp+Nz4sSKTFkPDPRSPr19IOky9j2Cqgq9u5SBKmDVwwIPNI2rlhge9i75ekvlam4VtnASDONG18YgNz85SI2Wq3nHrYA6CeGxszwkTeRz/hPZaEdsAjA6zwa64nNvTWthCc1is5Sl+SMWMIiiGXP6mu9BK16FFITlRTXmm/KK6jslBy1x6L2OXxDksCIvuBxSEoTF4z5nv8Nhd7D/TXtV2ji0rkQaq1jl9Wcb45ruTWLDY3NjhGosRLK9LVaHUY/d+sV2nqdXrCby4XE6FPs6aHehGinOASFs1peF2TJcAeGzAbNWQFAeJPiN/Hv6yUqwpU2/VLrSz4lFsyJvqWN1itfAWpXK60CHOFVrofB3lUnOkdpnCqz7jEdLYDtuJwpC1NHVBalFvRRV0ApZnLyfAi3SiHC3nWomoZgvdEj49GCnr0bEXGJRTBMjQ6i2wQPEkgy55doFsfZxZZ35RIBTJlnOypPoTHxqN8KkdHd8/C7zf/vvZjoWklKnX+Kk/przTUrN6dG+jU3+CJTdQTxaAnrZuhM+7tXHv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR10MB2932.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38070700005)(186003)(8676002)(53546011)(122000001)(33656002)(4744005)(6916009)(76116006)(26005)(6506007)(36756003)(38100700002)(86362001)(54906003)(66476007)(66446008)(66946007)(64756008)(4326008)(91956017)(5660300002)(508600001)(6512007)(44832011)(83380400001)(2906002)(6486002)(316002)(8936002)(2616005)(66556008)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AoDpatePURaZJ4mRAuQbzjs/SUCA8EQieVVzOCE3z2Bu8/s+6saM9fw4nk3E?=
 =?us-ascii?Q?4pRbOdRJpet3oAtuZUQyYx78uspwnAgRWaitbvkWh/LyR53fhrKTihRP9OFd?=
 =?us-ascii?Q?1N4SBTr5bMosfyctCJmb8Z/GD2VlOE1gkNRuKogE7W1VsJGmvaOLIMWpwO8Z?=
 =?us-ascii?Q?WyTSZRlYDBjmKw4wftdQeLqJwT2CGhVGNBOEYbbllV0hmFMOAyXjNZ48vkYZ?=
 =?us-ascii?Q?3TposCmSpw/ea5D44weEls+JgwHUNyCQLbqbBcuf9W6CNCAky8nKKr4NPHEl?=
 =?us-ascii?Q?wIOGwF36pfTY4fXLPkcxsvNHnn8aA5BRoxjhQA0xMTG4gQWJaqe+UxaZw3a/?=
 =?us-ascii?Q?Elk3qvZkkItP9b530Gzh10Z2wpP23woAyXvFOOy2prkSScDH7yCMtkg6JGyt?=
 =?us-ascii?Q?BwmJAFGaSWa39I9lveMxOzXBb2IzJqQWCJczKtLN/lyzDLNnRBJixv0DxfZb?=
 =?us-ascii?Q?7jgVjaqlhDFBJ9g+Cj2OnqOwct/ZpjrkNoH6XajlzZUHe4jzNaNyUHX9aoiT?=
 =?us-ascii?Q?VvvdKM5AhhW3v3gilgkiB7ui8T8QyT5U/EUBjOAbrJsIpuCdUh2XL3lOBLeL?=
 =?us-ascii?Q?7VVcMpFRCmRdFMt02tVEBfu4uyCyTTJbmoCYRafZtotBCrJNZnEKgpZOpP6P?=
 =?us-ascii?Q?JSWpmJ7PW7f5wTonpZAInW2CBS4Ahs8PPtCpQyiIwtWbBwmyi6VKVTIyaiS1?=
 =?us-ascii?Q?0v5dznbDcHEmdsSrdIEnGFttKN9aJd+RCNBy4Ip8ue1UMvMDvcvmRSe6nOr2?=
 =?us-ascii?Q?SY/+7lx/5vHssD5dFGttxr61+wHFXZF45bM5re3BZdoU7TwyFOZnj/2IDb2m?=
 =?us-ascii?Q?o+xKEknmA0t2d+73VOe2WAl/zOk0+q+cV3zykKxl8Be7DGBdOiF+/59iG19Y?=
 =?us-ascii?Q?1+pSA4E/7ktylv6RypYIPlSKN8RdwVOrpoweJXFsE6awKirnjwfTvanUiKkd?=
 =?us-ascii?Q?oCBuj84NBiYNGtyMdCb68o6fH196NKIwAwYa5JQCohcZdz3VsaYgXMs6RGbS?=
 =?us-ascii?Q?YNC8l7ryEfSSee/Q9IYJJ1sQdZlOtjniTakRycXaktuL797Y3n3aMDd3B2JJ?=
 =?us-ascii?Q?yN6rmqwtdhD9vEKfahpTCZ63dInyMH/qb2Znm6PsGAPwB5WStYi2ggUe11fw?=
 =?us-ascii?Q?PpXVrXoGpy6lM4KztscXLuTUUlmo0aDZ0n2DnLw1N8GFmD0oudB4FwvkTzvC?=
 =?us-ascii?Q?NGmYmA7wRndziAxi6i+cNlysXw4SSjiCwtjsR/JE7e9wp1g0Akw4AGjf3w7e?=
 =?us-ascii?Q?G5qNZSh9S3RXHxEyyOASpmN7XvTsJKAeuNa9yGjSqZE6+4Q7nFCIdWnJ2q8v?=
 =?us-ascii?Q?HREDHE9XW2P+Yiw5NV2W6eRS/evzrIZi+k7Cy3VIYr07cg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <59FB117A84772640A2E1B7C149BCF1B2@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR10MB2932.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e3642aa-a65c-495b-3635-08d994a1a741
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 14:47:06.4791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: himanshu.madhani@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4351
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210078
X-Proofpoint-GUID: BgogaIdCD8FIx9Qoc7WA6iCiX2TCz9yr
X-Proofpoint-ORIG-GUID: BgogaIdCD8FIx9Qoc7WA6iCiX2TCz9yr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 21, 2021, at 2:32 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_version.h | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/ql=
a_version.h
> index 4b117165bf8b..27e440f8a702 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -6,9 +6,9 @@
> /*
>  * Driver version
>  */
> -#define QLA2XXX_VERSION      "10.02.07.100-k"
> +#define QLA2XXX_VERSION      "10.02.07.200-k"
>=20
> #define QLA_DRIVER_MAJOR_VER	10
> #define QLA_DRIVER_MINOR_VER	2
> #define QLA_DRIVER_PATCH_VER	7
> -#define QLA_DRIVER_BETA_VER	100
> +#define QLA_DRIVER_BETA_VER	200
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

