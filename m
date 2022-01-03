Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8596CC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 00:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbiACAmT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jan 2022 19:42:19 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:15898 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230182AbiACAmS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jan 2022 19:42:18 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2029BWes017339;
        Mon, 3 Jan 2022 00:42:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=yzNR0+GyLxUfyupW8v0M6x6OsUCVVR3j2PVz/gKj1YU=;
 b=m9pyB6axJz7Msgw/5C352JIyDXdmGwsMxsRVWSm+APrECJioqcDdjFCz1ACDEm+YV6uu
 wQqoFJYpo2em1anQQh34SjbK1ah9rdgGoshIW4Di3v0IUtZKbZHNWXg48BwrrF5TykyU
 eHz6SLaoAtJw4Er8K4AeClYo9xwjq+YGfy8KhKvqLvrTu5QRjb1WKjpajbKqpJKDkWGn
 VjaGv9JyzBSYn9J7LrISTciAFNM/YMuSQbHLk+uO3uQMUhb/uuBppjAmH9nxtK08eJhM
 UVsXS6lkLlnKGZ4IyCkLGqsW6Sy4Jck3GhsH2gUrJ1UhJgbfYLa6dKpvPTK2XEwOUzG1 zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dafgu9p62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:42:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2030fveF176487;
        Mon, 3 Jan 2022 00:42:16 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by aserp3030.oracle.com with ESMTP id 3dad0bfrbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:42:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B1kDA4lCEcjBs+AxHpSTnwKtafgXcUZ+QCbuPX3rjHVtxbfNqeAOywAuszfaJPjEyctjXj4iGL6/Qy7rtZCt2/4dJb/KOeEyHaoGuPuLm8hk62IcBWhhk/e692PmZSajZIhM8we5yHD9yGG141yMPXdMW8QlRkTIypxMr9H38+621a8hb7nZZBwavrwnaK2TIO1L0eTkPQZqH7qdm/yTHxavuUYWJdz6eCIjzardQwBzRvvhMPtPGU15n4slWAGR7MaZaUx3OB1TWuMhOJzuE9FL4NPh1g79o86Nu8jdWmcuo+RMGGHfHpr4QtBmB+nDxvxW4Pz3otyMVeWZMHGf4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yzNR0+GyLxUfyupW8v0M6x6OsUCVVR3j2PVz/gKj1YU=;
 b=GYds/G4Vr/Z/KXw9VQ/NVKJaNX7jmyKC8WOuPjMUF6yOG7AGddK2m3LMCHGj+Krrc1SqG2y8Yz6WIv/Gms8Vr9aNlKqQFh+Ortr2/Vo6X0RON9uIz0ypHRn26ZXvGaMqot8ZZRWIh+Qnx2cg6bTrIdzqZ2FETtx34hYZCXT7A9SdlhFfuql4U/QDkTmUZiFgn/qSCSW87d5I59EcOaZZP75NXIXB3ez4lxcE/M56mQwunnlZG/cB7NkbA/BmtTN8hyBzVsIUJOBMf+eSOoSC5Inhjr4S8bQpqq3vkcTYZxUxIrJglcfVFbZp/6hwym2+2QqiJvLCTgJ/WUkHR3Ek5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yzNR0+GyLxUfyupW8v0M6x6OsUCVVR3j2PVz/gKj1YU=;
 b=Tsy3R5oXXKP/5LoelAIlwpnPuM8i7s+WzyPAr5xKtIvtboqsXtUvA/BJIipzaMZhhTmRRmLqEgAIv/JAv74s1Gbd3dP+WfONbaC9KuVpp8azZ7siKxkjg7He5QMsxK8AfvfZvDGP+7LmxMAi8Wihwe/UesJ9m9UDaoAo76nspmI=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4537.namprd10.prod.outlook.com (2603:10b6:806:116::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Mon, 3 Jan
 2022 00:42:14 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 00:42:14 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 07/16] qla2xxx: add retry for exec fw
Thread-Topic: [PATCH 07/16] qla2xxx: add retry for exec fw
Thread-Index: AQHX+JUD9v0sV8e4N0i4L4STV+MVC6xQhFWA
Date:   Mon, 3 Jan 2022 00:42:14 +0000
Message-ID: <A2EAA16B-73CA-4557-B54A-6667CE0144E0@oracle.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-8-njavali@marvell.com>
In-Reply-To: <20211224070712.17905-8-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 46cca100-8bb5-416f-7ee7-08d9ce51e2e8
x-ms-traffictypediagnostic: SA2PR10MB4537:EE_
x-microsoft-antispam-prvs: <SA2PR10MB45372581C1B5D44E3A8D3493E6499@SA2PR10MB4537.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GXkrb2O9i5FFIWX/AlBAy9zIQnY5hkIkytNNJxr9ORfpoKJRmsmsNd0XPrXEyaM5QYOXJQTyYy3hW3lAR/ZjLkuybH9se7bUZO6XNnJaarTT7jfNIMPSv/Rvq2M2h0ihUJru7qQizaugxYtShqMCVJx6XaFt5VyJ9Ci+2b7hp8gGJReWWUG8sXvM9wNLaT0OcpgZT0aIiTfAjguKMwPfTLyy2Z90uAb7XX0rNBfi34zILQBEgxE/pu8xmjB9nHmSiB6jxRaga27trBS/fRF/fW1SbkCn/rlwUOYxJpj8GfBjO+9wiKuagNP+9HqpE/sMK5eA6pKzXThR+ttnv0mz/ymU+ZQUTl/1cGL4omr4M1Pjjsqcwd5m2N9EBTSHmSzHduVNdn5hCEorihyRhmxSrcNUyaYwIUfkCwUOxMIpjhItSelTvl+jrmQW35XuIDa8pGxqCBol6SYODc4VZ0vrnAFyAgdOOAfAViY8uoHCa1ZLNTebhq3EGXrgQcu573V662Dr4GpFpiCfPoJ40ad5RW4NbuZYAbktRadHVAIwZ39JV/JM5ftj2mBwk+oSIzaeMAJ/RDOHoGwMPO77G1v7M/PfTDdjPt8QX58RXqvcng8ocpcBtUXo14/zp6lD+A4bIoNPiNBjoIWmU+9VBStk4KuE3CIv4aRm67xmz6uiCgOLpLNO8WB2G1Z4qIyfMSaNWKTnEZ8r+XeFEmsK9nPEfzJiRz0esFicYZ3Qr+oR+3k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(91956017)(8936002)(6916009)(66946007)(2906002)(76116006)(6486002)(86362001)(36756003)(83380400001)(26005)(508600001)(316002)(33656002)(4326008)(71200400001)(38100700002)(186003)(122000001)(54906003)(8676002)(44832011)(6506007)(2616005)(6512007)(53546011)(5660300002)(64756008)(66446008)(66556008)(66476007)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+m9qUuF2nOyvKVQ/eaDMJOifma0RxQFyFJDWiYhRIB63qptZXGQqTv5+yrjo?=
 =?us-ascii?Q?ct0uuI4YbY/gac+pUf4aZiAF4Z5hy0BCMnCfH4EtdJFe94mvyUBWZIzTB0tX?=
 =?us-ascii?Q?ayANXXtjNYUfTnLOpOKI888QP8oL2AiaQdr78YuwQeYAm4dQ3fV0fBhjS2TR?=
 =?us-ascii?Q?qDWNr4PT5Oa8Mx6IlIH4ug9xc7DP4py5t1ke33FymDBI8KfdX+vOjpSAf/Bl?=
 =?us-ascii?Q?qDRXI2eH2pEvg3tuGf67TIvIAWQf6kMPNHeQXjKkc7Alb91slW+K6ScBx/jL?=
 =?us-ascii?Q?pQB29FbRhpr6dledOE2+/LHa5yIUm7r/1sGz+ejzS00BZ67jH4BVDfFtu5dS?=
 =?us-ascii?Q?WTSE2g+2akJSYBIUsnJhtX0OFmETd3mM8oExfXOlohozXZ6k88eOXbPQekdU?=
 =?us-ascii?Q?gfKwebyxc6xwhj8C7R0av6+QXAb+gZWEmNzw0sKNxGhmypFa3pqe15L77fr3?=
 =?us-ascii?Q?abv750QPk18qhe7QHoRs9tYxlDU2MhOao4vaNSDjTzC9sYu4d9jlWSDIOssG?=
 =?us-ascii?Q?Nkf5aFbXsBJL+nYVuQQOCcrlQXyrqb7ffm4u9YcENxU8x0QdXqJIY835KY6g?=
 =?us-ascii?Q?Mg85ZGepO1eotOY4nYXK7vaId6Zcnhm/aOfA388ENeYpHD5EUWRueG6ra1Tn?=
 =?us-ascii?Q?dd2vu5Yr/Uuew3M2deLjFL9eCFpNf1OMKjSL3YrGRzy0/4qyO/Gxv1cHqGMi?=
 =?us-ascii?Q?RCklQ0ryMdGhiNzCRspao1atIPyKholLbK5E3Ur+fh6tP7rgUxlXT1VvXvWa?=
 =?us-ascii?Q?NDaudujoAe9tTT5Sokdd2hDbVVhVMKqgEWfTaYv0pgjRqO3OC90cChnw/Hxh?=
 =?us-ascii?Q?Syd44FNcwmXsTaz0wBwBUhUwFUnmJZYtorr5V7oi7DYWsXh3SrtbAChbkGN6?=
 =?us-ascii?Q?5umX7tzz0zgkWqaQny8invX8HPKFyPeEZD0VLtkhTP5Vmt8kJkpiir6fOBiC?=
 =?us-ascii?Q?bqE/ci1VJrljZctO0JpLUiiFpCK2Ej/hg/xiDNh9z1MZ10BBx7gOWxGd8rvz?=
 =?us-ascii?Q?Wn9bQVxi7VAhNHb7cpu1fzqCqEQ6umvcMYNxt0pHM5MsghGRXyrQuZh6D9bI?=
 =?us-ascii?Q?2c/9IyWU69EvMbZvr+MNY0piwNnOeibcwFu97ubw4tOREywG+uzVi5bO708y?=
 =?us-ascii?Q?fWH1RLokkcLhniNXpZDkaZe41K2oULAcdp3U5pcbWPiRu9YUQSbYL7+CuiYs?=
 =?us-ascii?Q?6P5fI0Tr/qxRZ32QHKVn1vO2XquiGCEcTP83eDBvzQFw4yTh8WIJhLXY0iKG?=
 =?us-ascii?Q?wxJuavvC4w7HRRN0HzVd8o9pn3fyHGjbulrqIc2md7+bMQTDc49D+cxGfBqv?=
 =?us-ascii?Q?xt6mZ+V5c84k2VFIGjSoTS8vOzVUoMtiu0WbTwat6l9TVYSnbOiW15cERtps?=
 =?us-ascii?Q?QXG09ieV9gJadYWiBRFL7ls555AgzDgQaP2dd2Kl5WWoF5kmcBVvja/fVxKP?=
 =?us-ascii?Q?LeAWv1qVoehMAP7YYkN1FEm8JVD74+Cm+LKM/mHdM6qJvUkGGnvgaNwPvcDn?=
 =?us-ascii?Q?iHi82qHO/G3ZbORsdqBINEIVTnjxwkt1htsy/n0YjyepNeDvD+wEig/lTGRL?=
 =?us-ascii?Q?YtpnZqLIqY2kBfLnests8+FFBHWfacC/4pWuA1tBih+YTJxA4gAVp5RtkwHG?=
 =?us-ascii?Q?VEOTB6UY3Cfhxx3HQURLo3F88CE+ANbXAi8VlBUWSq3ImUmn7QAuhvqLWcAm?=
 =?us-ascii?Q?25Fi1PRvIWXBResyWA+vu6iIq5k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F6591300AFF0814E81CEC9F64A4ED4C1@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46cca100-8bb5-416f-7ee7-08d9ce51e2e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 00:42:14.3415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ax9Ve6xWbRhFptn+aAIWjVL2w1a9Tpv2YO7mdylOs/GrJTGaFfyg8EPdas4t5C6MfVb0hZASEFSsZ98ZmIQtSskdCpp//Niu17bsvtJGgpg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10215 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201030004
X-Proofpoint-ORIG-GUID: VwrtwaqbU_GgmbFhojmJxkWiO9GJCxjG
X-Proofpoint-GUID: VwrtwaqbU_GgmbFhojmJxkWiO9GJCxjG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 23, 2021, at 11:07 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Per FW request, Exec FW can fail due to temp error resulting in driver no=
t
> attaching to the adapter. Add retry of this command up to 4 retries.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_mbx.c | 8 +++++++-
> 1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 38e0f02c75e1..c4bd8a16d78c 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -689,7 +689,7 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t ris=
c_addr)
> 	mbx_cmd_t *mcp =3D &mc;
> 	u8 semaphore =3D 0;
> #define EXE_FW_FORCE_SEMAPHORE BIT_7
> -	u8 retry =3D 3;
> +	u8 retry =3D 5;
>=20
> 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1025,
> 	    "Entered %s.\n", __func__);
> @@ -764,6 +764,12 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t ri=
sc_addr)
> 			goto again;
> 		}
>=20
> +		if (retry) {
> +			retry--;
> +			ql_dbg(ql_dbg_async, vha, 0x509d,
> +			    "Exe FW retry: mb[0]=3D%x retry[%d]\n", mcp->mb[0], retry);
> +			goto again;
> +		}
> 		ql_dbg(ql_dbg_mbx, vha, 0x1026,
> 		    "Failed=3D%x mb[0]=3D%x.\n", rval, mcp->mb[0]);
> 		vha->hw_err_cnt++;
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

