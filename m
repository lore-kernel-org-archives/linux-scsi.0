Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62050EB64D8
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 00:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbjFOAjV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 20:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjFOAjU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 20:39:20 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4239B10A
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 17:39:19 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35EJko8j011566;
        Thu, 15 Jun 2023 00:39:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=6YXumwuq2DhMoYBcL372QO2wSxRtMopv35B4SFVwNjE=;
 b=NFVm1CqT9d+lAiA24ed1lYN/TYq/LMSCzD0ONXj8r0apRv72CmochWJYZT4jWmLsrwZZ
 UnzitbWTYVuzqZQqo5dZWh5aNUJsfMGMRuKDdXZo/nYtvrTckAcFqmmN/Zel0I/fMAEw
 Ik2w5VxUhRExekERpk/YOIiRGvLxT4vRR54t209ChHTAEMv1goVOAjM3bYBvNtBvSs6B
 flhwj0uM/EohzMFem1oApMooiAvc5Z1lDa0qvqbhsnb8CrJ9deJREIKwJqtxe0qK9bWe
 pDRNs+/05Q+Gis7axnPdlVpLc/8ICDjWaam1HiSADlCurWhfEsE6o5DjmW5bX51o3MfC /g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4hqurv3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 00:39:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35EMqYbV014033;
        Thu, 15 Jun 2023 00:39:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm60swx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 00:39:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kB2X5Px5tm+keTonPEANlYokf8q0DX59M/K9BejweJsFlF+Mivt2AbSd4HkOfG1rBawBgIDCzdzBDyLxEqupjxmfVAfE96fI/ChTs/dD6wMlC7Qz+gaqOtTvILhz7O+jeRWo9SmgW/kcdv/A7zp3GrfJ0Gd28TQTUZcvlVY2bk+4rb1nGl7ZuxbAtqXVRdMNoTpfq9nlV7+A2iH4SZU1cLwK+KKJINlj3bpfJSd6N0KYrfYthotWmSIkCTEmzyfl3ZQBoRVX3NaNZ2A2BhtqLoO8LnzEO1oNdjbvI5w/b6BrUT0e9wII4mTa7Pt7DcrUAU6T3bCHIVy5XBX3pfuIPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6YXumwuq2DhMoYBcL372QO2wSxRtMopv35B4SFVwNjE=;
 b=TJVEnj+9k3BLRfUYEnPUQCnZtU8Ty6l9e+pBwtXYRwIlZbMHjhlhYoPguaRbJCdEBhVcQ1C5joZpBb9/Do2bpT/bnCI5KaOd7wxEWY7GXekFmDuhP7igz/vVmJPPhegPYkU7Rp/BsuIB7WTQtPuZ1eIcMh//HPF27mV8Z8GWj2YjxiI+D4N87L9MIwYBJjnCQVYUwKUhfwiFEjShZ0xYdF3dXDe3rWcHvaOicYES51s6kPZyiU9x/QrpwlgZGIfVlCP2R664XMVqiH2dbHc+6zjGw5YsPJnuGoOU89nvZHmUeAnfWnZapkdQLIpAsr3Sv5ZtTivQrVSSMc/nrdwBxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6YXumwuq2DhMoYBcL372QO2wSxRtMopv35B4SFVwNjE=;
 b=UEt8bmG4RusDr6DyZUxHKfSeYJCWR6J8pwdvWGAOE1E+uDht+fVzjW6zzwVR5CgrvsM3vWDBP6awh+t1iEtWqpfceHMPblGfjXP68EYWxVWccWqbwwHRXM3CdTJ4nzQs9vb0RTylSNofD7d05CrgmscyQEocM/GleS2qtNhApoo=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MN0PR10MB5912.namprd10.prod.outlook.com (2603:10b6:208:3cc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Thu, 15 Jun
 2023 00:39:15 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::d634:f050:9501:46dd]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::d634:f050:9501:46dd%3]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 00:39:15 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH v2 7/8] qla2xxx: klocwork - correct the index of array
Thread-Topic: [PATCH v2 7/8] qla2xxx: klocwork - correct the index of array
Thread-Index: AQHZmTSxwJvdxVVxSEGaojrSLu70QK+LESgA
Date:   Thu, 15 Jun 2023 00:39:15 +0000
Message-ID: <502738AB-44FC-4291-879B-CEC887AAD482@oracle.com>
References: <20230607113843.37185-1-njavali@marvell.com>
 <20230607113843.37185-8-njavali@marvell.com>
In-Reply-To: <20230607113843.37185-8-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|MN0PR10MB5912:EE_
x-ms-office365-filtering-correlation-id: 4b01b7d0-42ea-4c2f-d8d6-08db6d38f219
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9p0Zxq9UQafM/ljv9EYUiWeXfbIqE+sconz1QvcOJBmzf5Lfyz/IG6KD/ZUZbvrseyuRvHUqTTz74klW5bMheRVanZa0Ao7Io8Z48M8gEIsUrQf50kTzsnNBmOHTrLd3Cf+17+6IrFeU7HuT+tQ8+IpaaEJI8bp8b3gNy6tfDEXxChYbjJVXLPPxbz8RAKOXW9wg5RoqHaYFI4cj5olWnXpmQgqQ5zAQSy+hmSRzWz28MhONt/16rMZH5um5DhwDCAN8r08b9f7m2dOz88AYWT9Ye+HEH24T17avXUI36gHtsBTZDYkjDxB+8jL2oBDgJKY1P+g0jfOLCXNmvvZImtCaXVaPJFWi3Bh9rMphqTWIApCQ2n5vN/7ewcLPd1QYrHVLs2t+UG4KF0dFT0qlspgpQE/7kn0bIz0TxTyosY3PlBrEM4p64F7RPIQl+Ge7e+jjksafp19gRAi2oyGWbFKHSb6BVqImg7E4jsqmS77lMNOKG/wDQyXSOjqmmLr85NvYQexNGzezljfwLE/ad6F1Bk9JKQVLplbsZ2Dk+/9ZEeXfaknP21bmWD5gI9rhLkwRPRu4IJ/vclO7xD9oeS/pfy17HXNwnkq3y+fF/sKMp7RFeaAi1izlBkZeV4w6fMatKIq65DbjyQm/WX3TJA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199021)(54906003)(6916009)(4326008)(66946007)(91956017)(66446008)(36756003)(66476007)(76116006)(64756008)(66556008)(186003)(478600001)(2616005)(2906002)(316002)(8676002)(38070700005)(41300700001)(86362001)(6486002)(6506007)(53546011)(33656002)(44832011)(8936002)(71200400001)(122000001)(5660300002)(26005)(83380400001)(38100700002)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tkqd8gtj96LLisIt/0xb68gLKRyQP8OW6ZNe75h78iv6ZKmFDvm/Hmjy7Dzh?=
 =?us-ascii?Q?zCkQjRuMgyISxYSs/Y4MJm9zJwJ0w0r+6HP/esWPwzCQUczx+r6YUUYx9Dk6?=
 =?us-ascii?Q?XSoedu7JdkHpevEDKb8ZrhOlNWyEAoEljrcgEGWGmhziKqJP6/xMw1Pi26GN?=
 =?us-ascii?Q?h4q1bIOYOwEhMroiZ1RYPW3NU0x/z2Xv7WX/1q+dGWRZxJBxV9qAvU7iV7nu?=
 =?us-ascii?Q?yT8Y/OJT9I73pamKAuRO8TIEUwg2HwxrZNznf+ncThZbzkGJGEInlLhjIgI4?=
 =?us-ascii?Q?xjvI4T8AB87xq6Cf308yEjKc1274S0koUpEY0nFq4bFaKCXjPqHgp17Pc+ql?=
 =?us-ascii?Q?XL/xE5PIQj1G7lbwdv1UnqjbuFjO1FxtqxLeK09JpzmxUTeUF1nz2E9HiiS9?=
 =?us-ascii?Q?GbRHpqRyaExzCQZH1zcyxJXZquMyynRHI3DzlLgwkcuP9L25MtA2m2YBXkFo?=
 =?us-ascii?Q?oxnzMG5IsIk/wOAZRFvt5DILIzbLhvQCVD11pulljtyhwuAwEJAd8MvXBAB2?=
 =?us-ascii?Q?ShCU2xfCpiESO4mSc9eJhDtwuCd/LszpV+XaUdJHN0ifUVHwkyrPHKnP6Rt5?=
 =?us-ascii?Q?xLR2B3ZP4dPLrG+rx5Nlh5ohJxuaUfTPIujMT0x/7mfARVIWCgza7BTKGxyL?=
 =?us-ascii?Q?looKdgjkuvrEcnARTZA/3VV3dvjB+Wg/Kwoe5pkZ5bG/nWZipW2E5QFlGPEh?=
 =?us-ascii?Q?cYoW5CjJguxoD5OruMYKdmkgwBhTd/g8lDnbXK+JQtniYkdURu2RClubHMmm?=
 =?us-ascii?Q?GpwWdpq2mFH0VZLr6JCs1FTACp3LygQvRrCF8AOGSYUPclSHdiuoIIN0FcjX?=
 =?us-ascii?Q?kAhoNguLs5lXZYCPROA/LKT9YT5+yDZGmgQMN8yfMP/wA3KswcxRCjPoExrm?=
 =?us-ascii?Q?RZ9xdndGZaNHiSOYUnumI35Jjziycws7kUTvrVOTmVy7xWlMZuyedXS2t2cM?=
 =?us-ascii?Q?KgD4Xlz3b1YoL3W338tURO6qbBSeI0Zr2K0TLmoxqshC+w/Qt7pFiSh1cWkK?=
 =?us-ascii?Q?iiXLbyTRPrwgR0Z/OaXNYDZ4WTKDhFjgtR6ecWqsz0/2uMCQbCUQiEvW2/gJ?=
 =?us-ascii?Q?iG3gUPo3iYh3DqvHQiaFKKmln4DagQQyPhjZ87rR/aQ7bEGok9YVGfYad/W9?=
 =?us-ascii?Q?yAct1f5gDiOgaqZ0ldMwY+VshyWj0Di3NqnBva8PjAGBC8SP3oiqzrIG8wX+?=
 =?us-ascii?Q?Rc5wvgTC1nYcNpFfMFxzSg0lcKhBlEePZy0qbRbBg33YroVxrnUcUYTH4UDZ?=
 =?us-ascii?Q?Iopwqij1n+EB5zHuK4yZQrIsl/jrfb1XaAb6UAFjVwycB2+BuPQv/tixD2bn?=
 =?us-ascii?Q?HNndL85lbxbPE89e1HmOcONq0b6gYbxZAc1drWcc06Jox0XtqoHONlikstqs?=
 =?us-ascii?Q?Otd3NL+Ht4A8jU44D+XgP+4OhUky8pkGX2s+xTOfZ8mJV7JUwweMXuZ19Iuy?=
 =?us-ascii?Q?A5tQi1oQCD/xpjw2GAw45Vj/tFAA6x8XZsos253iFOIupHa3IFQeqGLZWLMd?=
 =?us-ascii?Q?DX7CasMw0rAe7m1uZGy9wd9VhqSxSVEyjqXgZDGGkerO116aUzaEprw84kHa?=
 =?us-ascii?Q?kJZinmOUT70JmU94vooVJ38syoXHACSmsXWBn9zqVzZIugF6FHRYkbALnulH?=
 =?us-ascii?Q?Tg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5793F00B4331B343954E4E1C11C0BD60@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: bKFS/4PtnWFJ3eaLU3BHg71AHJ3ogt3S5JKjjv8ZJP1D3CXP1mZrsAICnhTcrqMz0m+NXjZSD3AkpXb3O4ic1vapw+KDNLHXTxFRwlaCTbwuv0SKgn9ADS5ugdAxxiuVwFzrErfwS6IpeMIPLYZgc8nchxtd734ObgVn1Nw1s8sL/pGSPeFssRVco3hMKSRIFsP3Pso1dosr0KDFK8UOix3pRglDWos2lZfn7bPcEzdqNWVMiXWIQvMxQVy+FzByh0T37ljD4RMXR7664zSkGcyWWsXZl4BABSz6BTMmScNIMg+SBHiZ4MT5QqygsZtdRHdKVTR4CzwKIx4KH0WEEZMxM0RtZi/mjj+UjrUb9gErOJrIncwvnFt/Ype/HFYsjyJ62X+mmk3SDOymODXofjpEncCiGr2jh6jere2eJQtLGhjX2zPupyxmr8DlooRWydBs0eBNM9UsO31QJTFpHWVA6KnMsTPd7DgeaofnuKNRmaUJBnOxEYO4WJy6gY24ni4M6iho0b8vKjFfLRkoaDxlrp+J/2iDQT2TA7ErPUT+XMQEz2tzA6SV12IzvTCNQ3sbhecs6s6VE2G8MPV3J1wUDRK2oyh1sLmfDLQsMx8PxJ1ywjTaH1NArUrIIHg00vVHuevuymssvTiT4EOyr3be6BRrn6ogek0kZ/dNTiiS2QyILEdu0+mm6pVHtLv4bb18iXaqYDhF7Ku4sXycw/f5k/dO/4P8vmQjZ4IGZegLSqGV6CfF4YwWZucrPoNTvpdg1VTwnjFBAqSCTERf3KYRSXeIyrLfu9tIpw7OMPs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b01b7d0-42ea-4c2f-d8d6-08db6d38f219
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 00:39:15.0203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l2gdMFO5NdmHi+cWbsMqhfd0RucfbALPTkpUV13O3FO1aAu0ChRXbc+lZtRWAPxFjbMHvlto4lAF27fMDKwGd4BIWhB1z6QCWohpWwDP2NU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5912
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_14,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306150002
X-Proofpoint-ORIG-GUID: xXQPWpKxW2nuAn7TYj8Yatyquw1iWF3l
X-Proofpoint-GUID: xXQPWpKxW2nuAn7TYj8Yatyquw1iWF3l
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jun 7, 2023, at 4:38 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Bikash Hazarika <bhazarika@marvell.com>
>=20
> Klocwork reported array 'port_dstate_str' of size
> 10 may use index value(s) 10..15.
>=20
> Add a fix to correct the index of array.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> v2:
> - Remove the outer parenthesis.
>=20
> drivers/scsi/qla2xxx/qla_inline.h | 5 ++++-
> 1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla=
_inline.h
> index cce6e425c121..946a39504a35 100644
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h
> @@ -109,11 +109,13 @@ qla2x00_set_fcport_disc_state(fc_port_t *fcport, in=
t state)
> {
> int old_val;
> uint8_t shiftbits, mask;
> + uint8_t port_dstate_str_sz;
>=20
> /* This will have to change when the max no. of states > 16 */
> shiftbits =3D 4;
> mask =3D (1 << shiftbits) - 1;
>=20
> + port_dstate_str_sz =3D sizeof(port_dstate_str) / sizeof(char *);
> fcport->disc_state =3D state;
> while (1) {
> old_val =3D atomic_read(&fcport->shadow_disc_state);
> @@ -121,7 +123,8 @@ qla2x00_set_fcport_disc_state(fc_port_t *fcport, int =
state)
>    old_val, (old_val << shiftbits) | state)) {
> ql_dbg(ql_dbg_disc, fcport->vha, 0x2134,
>    "FCPort %8phC disc_state transition: %s to %s - portid=3D%06x.\n",
> -    fcport->port_name, port_dstate_str[old_val & mask],
> +    fcport->port_name, (old_val & mask) < port_dstate_str_sz ?
> +    port_dstate_str[old_val & mask] : "Unknown",
>    port_dstate_str[state], fcport->d_id.b24);
> return;
> }
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

