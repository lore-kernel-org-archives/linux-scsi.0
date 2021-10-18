Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 895B0C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 14:21:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 729EC60F25
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 14:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhJROXS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 10:23:18 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:7542 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231927AbhJROXR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Oct 2021 10:23:17 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19IDG5wV018689;
        Mon, 18 Oct 2021 14:21:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=hMCr6FxYMdwDhMAuHUuvVXJGql+DHi8wQZS3JntCBnk=;
 b=R3jcXDMkS1wvFs8QAgfTmdef+qVxPKKmZLXA2BnH8vdhXv8WPAo9+OqXOLpZFTgFmS0j
 fpRcXcrP07hZ1gxzfIDrnAmEskhqyQ2SPB/a3jA2DBp+kRTnqfAyAMoF2MDOzr0uAvD5
 Ka0Je2Uscl+npSpbbNasRybE7kk0UBHZfL49cPPQmLpYZ3KsAp5ItdG/j7Mc2YbAX5uR
 ZOVzxR1GmadHHK39y1H/qO7Z0hCNP04Vtygks3tY9JWsRRRDBdLwQ7ABnvorCgYxxM1X
 scPzcjSqluMXdl64qZScPubwxWR59CUAL0ocTbWf96odAfVpb2Y508p8QW3dlcBfcp4y ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3brjxn43ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 14:21:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19IEJV4N100816;
        Mon, 18 Oct 2021 14:20:49 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by userp3030.oracle.com with ESMTP id 3bqkuvgxbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 14:20:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktIGmaeFPP+V2eU7JWTFbZoqLZkDLbiIE5QdOmcQ/eTjzIoAxE8c5+pIBedD2I52MWfQdWE+mGI33LXJTsxgR+/Wa1/MbC+0TjZ6JbBR3Hon1cf7TBgj3YbqygNM8Vypg25yz+pM9yKZ+cGxNsn2GQGm29I0IovcrxfrmjOVTFOio1d9jswDLRi9CulNgK7FF/U4UE6nxbgvM0ZKBMZnybzfHRxywT4Gjg3kqxN+McM630KTQzc0gd8l6CWsFoi+ZJArAiMSNqkU2tMfyULifD7d4anCh/CYdTnvj1g1WESCSs3GTz63vwSbjSzTnja4rQsnve7ly/TMVR/wy69cfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hMCr6FxYMdwDhMAuHUuvVXJGql+DHi8wQZS3JntCBnk=;
 b=J+Y7ApE9ssxbmr7QdrWWX1iUCGV3FgE8HBIWqQDUCGn2s7HOHJyGgYS6Skr7G21pqqJADbtrIl5gwuhfALvF/uSqZVBLZCnCVm4YFGE6KmrA8vvuKn3sKvYMBYnFLzz714sQLLDxVFva5YuCVq0jdfFKXCVLSfm1Yp6SEyScL+axMR3CRl2/Qi5lzSOjo5aHplxh1gS3MO31UbnRDmGfnZX44oUKjO3qpCYB9PnRe5LZLy7IyjdVSO81JyqpGWHd3vCvsFUkMZpyHXq5DOJ0fpnTqtjEPbOnRn+bwFPeRYGSBxZgOQfCQXTn7mkKnGYGzUXXkHB1OonVlhZzcFn2tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMCr6FxYMdwDhMAuHUuvVXJGql+DHi8wQZS3JntCBnk=;
 b=MfBBeawlMetHp7hEZ0Xo/EHaRWgUiw1M9akk0qFUb0EAUQVR+Qp/EzSF3XxHbcfbRgMnbFNautPNk1C1K+nKB1nVSZUs7WAYVHUo1HAHvTBqSnoVroIIWu/GAxW0q9aEDAwpDKdpPzJKuP2i/OkGHVUJeS/nQ40X0tWmVEqg7WY=
Received: from BL0PR10MB2932.namprd10.prod.outlook.com (2603:10b6:208:30::16)
 by MN2PR10MB4013.namprd10.prod.outlook.com (2603:10b6:208:185::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Mon, 18 Oct
 2021 14:20:47 +0000
Received: from BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188]) by BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188%3]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 14:20:47 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Zheyu Ma <zheyuma97@gmail.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla2xxx: Return -ENOMEM if kzalloc() fails
Thread-Topic: [PATCH] scsi: qla2xxx: Return -ENOMEM if kzalloc() fails
Thread-Index: AQHXw8Nn3ujM+Rx9pkqyuGt9dVCDEKvYzygA
Date:   Mon, 18 Oct 2021 14:20:47 +0000
Message-ID: <D717C3AD-1753-4785-80EA-B20A17506750@oracle.com>
References: <1634522181-31166-1-git-send-email-zheyuma97@gmail.com>
In-Reply-To: <1634522181-31166-1-git-send-email-zheyuma97@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2fd6ee4-212b-44db-9ecf-08d992427abf
x-ms-traffictypediagnostic: MN2PR10MB4013:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR10MB4013A1F7AB91B8DF2D42BD85E6BC9@MN2PR10MB4013.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5uy6mIV6D1UMpNWRcvQe+T/SzEQLldg2BuP+6qflEz2EGfL0Oi0wsr76XsriuNisXFdsczLocrn5dXZib459uD99/e2vSuC1rCbIrCVmY3K49RXaac05VTYPfI7rijLR2c25HYlvfofZGLmvVx6cP4kPqakVGdc1eq0VVw6q24rw0U/FqEO+NS38ui4zk9uDfGyjka2ml/uKguzotMk4vBBYjy9CWX0Ksv29LYMI1ccRJUOphxPdK2RqI5GWM4BznjFjNFo7ayRmvfr9F/9SYRDaPVBphXj1e4CH+WzDs+wOhSan2AI0OMlhPkj9RLwz8mu+zojvK37GWTsw2XPeHJfPEdqmwmedXAdh2z1QhXzs252qxXjFbMod9DrtnSGbBn4319bPkeH5sgdS6d1Ecj1f1XY8nZs9ow508NiQiwGcz4+YhaCpShmnZX/4yeZoJkqNMJ1K0dUbKuh/6cyIKjEnHfJgZNd8Y2VD+Q/GIlTeD9cpAR8X4xgQs7wrX9T2BFtVH4t37XBo5NY96HktHTm1D1wrpmozE141KxYeJKR5B3PIi0WLYqUQJcBTV5Q+jkfDRWxb7E026b17fAoz9eAIo1zIyEHY8yosdrsAK2jdYsZ7UYUNt4nyLBTXzMP4KEr6KBuD0aw/EyQKwDx8JE9cOZrhy5xpW7Y43LXmb376Ha14gm//k1E6bvqOjih/R+a00RmNgmEykvpP+znTViqjaVyIvl7b+FoE6vgKUVA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR10MB2932.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(71200400001)(44832011)(38100700002)(122000001)(83380400001)(6506007)(36756003)(4326008)(186003)(53546011)(26005)(2906002)(6486002)(6512007)(8676002)(64756008)(66556008)(66446008)(2616005)(66946007)(5660300002)(508600001)(6916009)(8936002)(38070700005)(91956017)(4744005)(86362001)(66476007)(76116006)(54906003)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Rm04xfklupqNt3Dj5pasnG26bmdHyOvAayjQd+m3TrPcFeDzFrGYPnpUs+3D?=
 =?us-ascii?Q?1mQTaDu/zZJlTCGvno5FrHJbbQWaMcdU7Kfges6869jtGT/ejeldom9oCKoC?=
 =?us-ascii?Q?RGCTNCpW0llr1ScvEU6PDNsUWP92gjSmUmPu6diaFcvwmLaaw1QdT9L6/dEv?=
 =?us-ascii?Q?47U8hUNjMOdnd+WX/m2J2njeDJTcO46NiRvILhNvV+BJrZwlx+IJ07s3lz54?=
 =?us-ascii?Q?2FrZi7Z3V2y5ztfgAVYB5jY4dhGXuv9xJ7JcNRdwASMfcc03G99aAdQa+YY1?=
 =?us-ascii?Q?3tFA6ezmYsggmbw3GcyNcTtZRKXIy1gZNBF+u8eaYQp6Eb3pWJzPllIXL5rh?=
 =?us-ascii?Q?e9y1okLYozTyO4639j0wsDA54D5BgTfgk8pCvgvzVnS9uZqEJHLgFqJtyimR?=
 =?us-ascii?Q?9MlkHsGV50K/jA7f6I3sPlK89Gl+mozAO1BHA2rK7/bL8eBKn8k7VpsuMXBv?=
 =?us-ascii?Q?m+1XZUvkiVtM7bNG1+9E4gWmdt99+KMGvWMtYKEUPhfe9G8B4zhQbIkr7uny?=
 =?us-ascii?Q?2TwNKZ39xYe2Zo+Lzq8ysEMo67rKiolrtL/kogYkQxgUOnG6kJjNExD9HTNk?=
 =?us-ascii?Q?/WYmSTTVXKuV2qu9SnOSUT7p2AXl+IREXURgyCUQWZVifEqWod535u1Pir6+?=
 =?us-ascii?Q?XDfmlPBleVRhMh+4lco01goMhfNh+OOM6SqFi4p1xJXj7cRPvgCpGCGaSCSf?=
 =?us-ascii?Q?ttq4/pCtlRiDY9x4cVc9YdMp94g3JdL56Av/IOhs+m4nYU0T1g+ZdiRuxOem?=
 =?us-ascii?Q?nfDOdW6a8ISehrH8hUccY0n1ahXoTAxjGkQR+t7oa3EYG98jr/IifERfgrey?=
 =?us-ascii?Q?/m2v1t4Vw8I1Dgp2WQCv5MhbalKpPGS9KpmUvxAx3otlA3u/OgDR5ukwsaWB?=
 =?us-ascii?Q?bBDb1NClgYez5phAedtVDLZvyd0e9d9Vf8op0qvoepYc0/JjC3ZnNHP4Z5Mb?=
 =?us-ascii?Q?myp4St3RluX0ideDjcrhpNpN6Tsp4x4OTVw5otEozvT8iMLSj4RqZ+PcmB9Z?=
 =?us-ascii?Q?FsyslDYImXq9BC2C/PVTdMW7zS/9JRaEJA+DBk+q5vQXuYSHeFcXOYv7ikUe?=
 =?us-ascii?Q?QDPzAtWhb5ByjGhnLQ/pluRi9LcN1Yuakum6vJrvgq6cZ4/gBVANQ/CK+Uz5?=
 =?us-ascii?Q?eoGnLkukTRZfnxIBdtM6mHeNxgjlTIxlc8TAAWC4oudFQYkinvNueXaatTEB?=
 =?us-ascii?Q?NerrnS+AHJ+rMulz6cCchhL/3CNlgR5ZOWQEMS26wY7bEFuQcgaobEDjhMGs?=
 =?us-ascii?Q?Vkm0HfAWVz4oZFkh2+GbTo5dxAuAX0vC1ZAYpsVlFXH7Vv1mO9picGxI02Ns?=
 =?us-ascii?Q?4d0TDsMoPyNPbKpzISRBLBvq?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <67CBBB9D40F29A4EA0BE25AF20A68CE9@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR10MB2932.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2fd6ee4-212b-44db-9ecf-08d992427abf
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2021 14:20:47.3601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BB5jZDhOBQJlDuD0AJqCoU0eENURVbtMTfM9yQL5S8QZpIsEcKd2KJ24De0ArxYnbuv+hx7xSF6HzospbJZOg93q7jRx33QAkKMickCm4cQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4013
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10141 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110180089
X-Proofpoint-GUID: VJ7TefrFTWmfiqqAUnpcQpQTFwE4WK-k
X-Proofpoint-ORIG-GUID: VJ7TefrFTWmfiqqAUnpcQpQTFwE4WK-k
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 17, 2021, at 8:56 PM, Zheyu Ma <zheyuma97@gmail.com> wrote:
>=20
> During the process of driver probing, probe function should return < 0
> for failure, otherwise kernel will treat value > 0 as success.
>=20
> Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index d2e40aaba734..836fedcea241 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4157,7 +4157,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t =
req_len, uint16_t rsp_len,
> 					ql_dbg_pci(ql_dbg_init, ha->pdev,
> 					    0xe0ee, "%s: failed alloc dsd\n",
> 					    __func__);
> -					return 1;
> +					return -ENOMEM;
> 				}
> 				ha->dif_bundle_kallocs++;
>=20
> --=20
> 2.17.6
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

