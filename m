Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D05FC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 00:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiACAxc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jan 2022 19:53:32 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:55038 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229753AbiACAxb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jan 2022 19:53:31 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20298QCh012098;
        Mon, 3 Jan 2022 00:53:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6ttx14WdBTlrjNJv1z1YoVErJXOBoWupaxxS8NmXAUs=;
 b=CMcqqnLoLC19KZaMJuzVjC8mSK9+3l9uEXiweJUJxuRPRbgSQkPzfj62Lej09GycRXUU
 V46lpHILmqGXbvYgFAoYSOook9ZTbjCjeXCnL36ZyiP8XYrRp81DuO6iiJvIW/B0kusw
 wVt/Kc0bvHeUOpcQZciwXDR+5HY2/cqR4kLy2urigZ0GHEeuZHjYgxpxtAp5xRZZh93a
 JJbugkf4xMj9hUl8ZSmqzEU6zwioJ6QYNhF1k/lae4oQ0arsjsdhUN0/6JiRv/TX78cx
 ISOI7JzVqJVP+aMT3YD/hFMAgKehUWUIhBduittbzc9Qh5YpHVoJoPJvQuIEGI3EdwKn 2w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dadr89qnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:53:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2030q4b3002744;
        Mon, 3 Jan 2022 00:53:29 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by aserp3030.oracle.com with ESMTP id 3dad0bfv2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:53:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdGIBYU7vj4Lch/e+u8f6rMBcWY9AxV3K9zRgPQepyQjY7atCYtb7sll4PVbB5p8GArA12KpJ66VdiXoHOVKbFmIidgrdEQS+GnPT95naWMrDt2OepQYa0bX74qJfEPVsSjlelUyBvE4Wy4T1hWW/n17b1lCiZWmG/53m8xut+IhD5lePc/Vp0wI24ouJrsYw3ScqrNuihRtOCkldHU6+wL7w9b5jrGH1G6heWvJnVygxAeTUiW7n2Qsey7z2KYsHdWvWwoD4RO1dwXLV9RjggpOLcqVC2G4QA9k/BGLGQw1K2TyGc/OAMbpUNW1bOLrJdNa009dML2nrVn+UpTqgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ttx14WdBTlrjNJv1z1YoVErJXOBoWupaxxS8NmXAUs=;
 b=PJbI7GyHvMGBQLrfr66/iQtle5np8ZXYJwNTJFMqB1clP8+Q/ZqgXyvsgXZrYjRgE5AL5DTfNhJepwpGxPns+ADX6OqrScHrI+p15b0B51QyywXfnAFwKwY5fcWqpv3XGmZH6Gu7f39aFhM3Hl8Wbq7EpiZxUD90MO24qExsqb0w+wevVR31AmkGUDXh1ppN/hOxAy/wWp2UNjrLN1K/RVtN0kO2cJl5JaEvQDbM5XUd//6L00KSsr8bIgyKY/RyUa92CHWThpZdDs5EmP1bMnmmT2DTPTbHn0My4CAxUPfqc7JfoJ6aySYaaHuYjXQQ7CfKaENMInmGEt+PTGWeIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ttx14WdBTlrjNJv1z1YoVErJXOBoWupaxxS8NmXAUs=;
 b=Ivcgqn0YiGjjNgMpthyuvy4yHd+uPgCA8vy2uXp50ozmnb9bOXZ9Zazz6HwRJgPGS6BOIjM2MTsJcYB27cXN035+LBnXaKSaKHhNkTA8Z8irSoDA6Qdf6BiHSedBZwxEDkoFHUuNIq0/l3U9tsZP0lJagOnToUnqWww6Mog+3u4=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA1PR10MB5710.namprd10.prod.outlook.com (2603:10b6:806:23f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Mon, 3 Jan
 2022 00:53:27 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 00:53:27 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 16/16] qla2xxx: Update version to 10.02.07.300-k
Thread-Topic: [PATCH 16/16] qla2xxx: Update version to 10.02.07.300-k
Thread-Index: AQHX+JUNdnBwHAOI00uvks3nByA8cqxQh3iA
Date:   Mon, 3 Jan 2022 00:53:27 +0000
Message-ID: <0A364D09-A500-4636-826F-9B14804301DD@oracle.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-17-njavali@marvell.com>
In-Reply-To: <20211224070712.17905-17-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1a5884f0-d356-4658-4974-08d9ce53741f
x-ms-traffictypediagnostic: SA1PR10MB5710:EE_
x-microsoft-antispam-prvs: <SA1PR10MB57100682C66C947C97F2A104E6499@SA1PR10MB5710.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:454;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j5lo4SgxkvcPdv6oCE/+Em7+U9/bC2GPFIoYskWXAUsKDDSUqx951Im9mlXu4eFJJOWyh1d/61QDCLpBf3N2c5ei6fazxn04KNKpVXERByhvBE+7cZLrVmts+Dj8EMi3addpV8Lgp8hYmbrVEnssM57hRlDBZYBpkDlSKYvc4Og49afQyALAZ4BirnkwIvhalnf8UPklw84DnAoDXsBeGa224jRtLp5W4XHrK1oWlKV2z9DVliRCqcLGFli9MA2msFHw7AVK34DXwTXvwzGlPrWurafsGN06DH3Hd/jZc+M8B8LCwqU68XeQcmB2xktziElhp3V11IYHXrsd6UNw8uJQNRH20zi2RxBcFoHaVvBs8LU++Sin5tczVvo9fU1RUhwCzHvW+nz54DbnGrIsR2UNDmrgAe2GC4fySBTuP6HNWzt4C7xgOBOdbFKJNZjlT2r0tyknFsvJgtg7WLWgYcxH8ldKKHRJ8vkpj0YCAKRWnW0dr4LJ2oSEu83WqoYM8lV81o30XanT0EO347tcRf0PnAcWbRRNORVZ/u73ZWMNXo3etHaOcx5U/i4NOwCFyqMPGkB7/AkzyJU/crJGpUa3OQB9vQfA00yCmxrDXS/+yi86zYIMBJDvlMRyplnAs7D48vl+JtHu96Ryzv0BEaXpTgq0f5YgCmdqddcGE0rbtooBjGhgYQwufQFIF+HfkKU2GvRvNyBSTlMTPHSJDuUsCVE7N3WlNTyEt0kg8WM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(44832011)(76116006)(6486002)(91956017)(66556008)(5660300002)(38100700002)(54906003)(508600001)(2906002)(8936002)(4744005)(4326008)(186003)(66476007)(86362001)(2616005)(26005)(8676002)(64756008)(122000001)(71200400001)(33656002)(66946007)(66446008)(6916009)(6506007)(316002)(83380400001)(38070700005)(6512007)(53546011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6WNPaH3jFF2W1b/RqcYQkbh1DlUj11poa8PMSEz2uhTSzpaE+poQUsg1qAYx?=
 =?us-ascii?Q?HX4MQj28w3MscmF2o2ILtlyLckJR7GIwHbrdy2BBadZlt5zswwtAILHPzrAg?=
 =?us-ascii?Q?PPE4BVJRhsjZmQlfmjkiDADXAyDjEXbOzXtVYhKKWEjItJzUC6JdtpqYB2bt?=
 =?us-ascii?Q?8YLIC6xfUVy+eP6POU0JnhGvIEPqMk1RnrOmLdyoXGBlPX2iGuBjFGQdavB+?=
 =?us-ascii?Q?772BlpUsA2WYAqghFG2xJbbHebKYB3L5R6dUzFb/lEGb5qcY3fv7wl8XD6d6?=
 =?us-ascii?Q?Ofuk3GkTTr00bCwP/dtWQYUYDWTAcygXh/wgOxv7Di64jrliwJzshWsZJX4a?=
 =?us-ascii?Q?iDF0YgJPXwdX+mZdsDrkba8UodxlOJwWeO3EmELI2tng3UVSyH0MEE7+NzUE?=
 =?us-ascii?Q?Shqb2rThKC0qal9UjTP6QFKuoVLv+GyYaGD6Rp4IKzp5kjiAXEcXPTAC+jYd?=
 =?us-ascii?Q?X/jTQrrJNAZmjx+JPgXLWapkf2lD3Lr7OaYV+jj1xzanbQErup0hZKD1kKsW?=
 =?us-ascii?Q?tG/eHiO8qFGCJpgcXnfnIHHMN6zdQkgcapeUtMf1WkH32sprGzZFyi0hNiRP?=
 =?us-ascii?Q?63Z78yjGbBpg9UXVbV04ifFCXagfGiNKn6+H5nGltO8AxNl6+Mvd3jqS2Wil?=
 =?us-ascii?Q?X+GwwoaphP61l9mW/NkR8EAq2bf474NxCvlCMsvIRkP84OAu5AV4Cvlf2Cdf?=
 =?us-ascii?Q?ofBWBk4WQvVy+3MzvBoLafFll4ah0HAT3MScRBjlvbb1yJ+e+5kpUJOvNIgI?=
 =?us-ascii?Q?VeTLqAjWfnHH0MDYwsWcoZAgQaR4LOly1QfOnL/A45jm5HREGp0Eiy9H931H?=
 =?us-ascii?Q?U977gxqkKnpqbsfq7QGJfekYS8kzwSge1Zo4t2nYSXVrjGxFBKP0YQ/sk2pI?=
 =?us-ascii?Q?04lrCL6lBKBZnAzjskNwjks2r6v7GJ4C64kI3Bn7ZWve/c5PSJDQUK/2eLzl?=
 =?us-ascii?Q?DbZQtAKEItTCjYYYUrMnLDWAS+jeH448hW/xwgR301k8+oe0Kii2F4SZpseC?=
 =?us-ascii?Q?oLwxUU/y+2hEXavJUOarJWnXOSB2q5C0zGPWTZpJI5XYLcQe7/Ftyh4Eebbh?=
 =?us-ascii?Q?ywtykoE6WxNFAN9mSIGqBeLh3BmZPCVm43kkGvT5nEECH3Wpa2/PYkfv3VVN?=
 =?us-ascii?Q?ksCM49NsqdcdKGjIF9nx2wC63gBfhueyPp1RKzEETx0zHf8eLhT2GIh4htSD?=
 =?us-ascii?Q?nv/Kp7UGVLGMGy/E6gjBtAoKn4Tacq+WJX6pNWjU79HvYd4D8R3ERWQdJESD?=
 =?us-ascii?Q?BcgCuKD17+G++jyuNHU35XYEavubtZwJn3CzR2CfWYnpl7o4G36PtOz1IqMS?=
 =?us-ascii?Q?ZWlLbLVJcQBEvlxMQyccBiegqSB5Wf6eokbXSiED4oRhHH7dr7eCK+7+vuBY?=
 =?us-ascii?Q?n5vsCY4R1rFdKJQ4DcjnwlzFTmltfCQI/sZg3MYLDA//NAGJhnRDSra3W4q6?=
 =?us-ascii?Q?58OnegjgJBPepCcBYq4m/zwb6y+wgIjefaqMi3m5LsMTCtyFxHTgSbfcHuuA?=
 =?us-ascii?Q?HGzuc9CjG2ghNrR3oRnFGaLAHGNlk+Et2DykgQtjLRJVKGjhr9pH/tDc/2oW?=
 =?us-ascii?Q?wS/hAqHnAgQ7KdyEkK+qxDwfjB+YIGLUmn4F/Oz0w4eGKP82A4beV8r6Igcz?=
 =?us-ascii?Q?Oo0I98ayGNsDvzw0DmSpV2DpqCapBPryqmMtw8LlNx/W9UUEkgku06wcFN+l?=
 =?us-ascii?Q?CV11yaV0cHSdQhIZvq/gjY0pBMU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9197AF0ADEDAAA4693A0CE66CD40ABB9@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a5884f0-d356-4658-4974-08d9ce53741f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 00:53:27.5138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 31/DBiTORYV2SUK9y3e5fdlhac/nkcsNkyil7C23YeGlXtQ6Je8dyakKmx1/iz3xG0RxH2BGjNn7hs2ZPtH0W32jI688RL+FOJtfN8oPFwI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5710
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10215 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201030005
X-Proofpoint-ORIG-GUID: ya2vTa5MKzi8PtTtXPtICsl_Hd1Nr4Fx
X-Proofpoint-GUID: ya2vTa5MKzi8PtTtXPtICsl_Hd1Nr4Fx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 23, 2021, at 11:07 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_version.h | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/ql=
a_version.h
> index 27e440f8a702..913d454f4949 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -6,9 +6,9 @@
> /*
>  * Driver version
>  */
> -#define QLA2XXX_VERSION      "10.02.07.200-k"
> +#define QLA2XXX_VERSION      "10.02.07.300-k"
>=20
> #define QLA_DRIVER_MAJOR_VER	10
> #define QLA_DRIVER_MINOR_VER	2
> #define QLA_DRIVER_PATCH_VER	7
> -#define QLA_DRIVER_BETA_VER	200
> +#define QLA_DRIVER_BETA_VER	300
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

