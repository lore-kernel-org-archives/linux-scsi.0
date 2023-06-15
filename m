Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A480CEB64D9
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 00:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234721AbjFOAjc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 20:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjFOAjb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 20:39:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CEE26A0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 17:39:30 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35EJwseL015409;
        Thu, 15 Jun 2023 00:39:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=bIz+yRBzW0qy8GVXrskFwcvsdemLUPpPZBGKKH0l05I=;
 b=EIlODXOztGaRzvTG8dx4Vn7Eob79F8S0h3l0nBBS6LPJKSxupiiAENim+2sCQnbQ3ZhZ
 axXMlspkPuttYfhHFATC3I7TFuNI2wC1khBOSy/TxDrn6XZjdwGnvzBYWQQEVNfKl1VZ
 Lktt6tiMhCI0d5FRg0gL1fHcKPnINea+N09/QnkcX+yPEmUhzCh759PBTReY4xcMGA4q
 krhpO1NauDnXSEhop1894YzelsvwjNLK8h9oUsFXgWyJK8EaNV07BtB5n5U5E9/I1+3g
 DH763E0ELbdq7/72jt0QTIjva1/KQzjL11EE1gTyN4cEVJOIl3hu/aux2JNAdfGFiCDz cg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4h2arsja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 00:39:28 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35ENwFZm017794;
        Thu, 15 Jun 2023 00:39:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm60hq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 00:39:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZdYcgF0O7tYTOYg69ieY4cYmyL+xrNxKRPTrrIGmIQthRx6j1mMyzZTIGVhUKIfOdaTpTmhYJvPdrJikutyLPYNa2asxJ9410qZgFPwJn39TOIq+Bze7++tZ3UkKNxDmLzkWP5azwSv72Z+HW2VbkFd1b8Bmd8By08ZGGn6UdMxka/tadRXK61m/S85vMrTBYDSrxjAKLzLsOj5ECROgocuYLcuAc9EsuuS+JWVzGpcN+KdpJIXpF6Ytd/IX9xup9qkjQisgtOpshUkYFZ/rNeFnjHKHtzj8VLEB2NOtf0PmPA/SMRDCUn18XyCXHcSWQy8Ja2i18ILhhbhtFNcRAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bIz+yRBzW0qy8GVXrskFwcvsdemLUPpPZBGKKH0l05I=;
 b=HPLL4TVqGS7Gzk43swS+J9cKugWrQqNHLO6+W+t5oMLqVjz2d2BYmowANPaVmgdb2NJyC0M4ucOn0EMBkySCQqbRDQos3/usTTfiYiXlOJPGwaMhjsOIxOSTo1zfmYWBhNH/lK9T8jO4QHXPO1/DHF/H7Oat1p83fYtL88ZocUchvkfDLfEQFhKZXRtauiaXcBuFR6PhO1IAnP/45nI2bpt/+4RGEpzMjhkj6BdwU8vuxWW6EgHbNXk4aTx6pkt8GSuWuokYVWWf32NMqR9oxNtamZWKanlPhAay9VA0mc96d4F0rwwB4othXICj5bO22R8VSUnZkdGCNRJwZboNjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bIz+yRBzW0qy8GVXrskFwcvsdemLUPpPZBGKKH0l05I=;
 b=z5pUzjMvnKKaDAZ2dlqItDhve7EmkOijwmmHK+xEqOmn+QA85YX1/Do5HPZE7l+V+ec13k4uUod4ACJW5a9fLa/sl/JSHjCaYP1alSMynarjM1XXf4thVtL8Dij7fVEsklGSxZXeMKSfqY4yZtsi8gOIimQWk/P4P7P5lBAS9gs=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MN0PR10MB5912.namprd10.prod.outlook.com (2603:10b6:208:3cc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Thu, 15 Jun
 2023 00:39:25 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::d634:f050:9501:46dd]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::d634:f050:9501:46dd%3]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 00:39:25 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH v2 8/8] qla2xxx: Update version to 10.02.08.400-k
Thread-Topic: [PATCH v2 8/8] qla2xxx: Update version to 10.02.08.400-k
Thread-Index: AQHZmTSzF9x4eoIDkkCPWozdicwxQ6+LETQA
Date:   Thu, 15 Jun 2023 00:39:25 +0000
Message-ID: <ED15238B-2DF9-4AA2-86D5-77D315467A4E@oracle.com>
References: <20230607113843.37185-1-njavali@marvell.com>
 <20230607113843.37185-9-njavali@marvell.com>
In-Reply-To: <20230607113843.37185-9-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|MN0PR10MB5912:EE_
x-ms-office365-filtering-correlation-id: 6fc04553-93f6-4314-d634-08db6d38f848
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GYRvh3PvN1STxNv5aEzJhybrtff8JnWlsnicxtl22H1Zb9vMcWEaDdYKp87C9GKzW9gA19oVSZfRaHLz0xQj1w7KLYK3aH4aYwtclYb2LN+G70fKT1/2uLHJnwa11uwzIgls6BGZeCX2E9CvAtdsRh4bxX56rcvLfmIsChCNLhX2PmRjehGO3wBHYxbz8y6X6eiDJwYJcDacyLDIdjLk8DeUi/jhiv6gRkmWLvf0PFHXIOpmL4+DY2QltoIQiN3AG3SJbFzRF/ocT9Ys+GN+fDfZ8tTy+Dp/kAtd+7a9ZAgf9t9G3dMy+3x4qpXbb4SmdK6rE03ZS2ig/6gnjQmYJY8QPenjtSCKVuf8jpg7aCKn0OlWboNyH/PuhbVpKvysawbAwvj7pmFsjPpmgbXVM7VLEalafaricA04h6sVPHZScg7IhQuZPktMd3a3c5chqxzJ0g7/fHJ2n7g1cm/zf+CcCJ1AAQczti47+Dc6JkMPSM2Q4J9mF6/mWKxDCav8Stw0SaF/9HqAlP5VQmOAQKuxO/Eimmji4eh/OPCfkKu8kn6FujhDyAcqcK2dWsMG5Pw4iAoIjaH6fWPZCFFfdkxd1OZOkNHFHYUSzZjvNBCAGALEhT15C58ams/gA3tjlRxGGJIMM85JmJZgB+rK6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199021)(54906003)(6916009)(4326008)(66946007)(91956017)(66446008)(36756003)(66476007)(76116006)(64756008)(66556008)(186003)(478600001)(2616005)(4744005)(2906002)(316002)(8676002)(38070700005)(41300700001)(86362001)(6486002)(6506007)(53546011)(33656002)(44832011)(8936002)(71200400001)(122000001)(5660300002)(26005)(83380400001)(38100700002)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?04hgG5ijo+rT2v6BwGvfTXy0lCJ7ssqEWXDowhCJH0Nrbgi9CoslOMfHuumD?=
 =?us-ascii?Q?OfhrCOYA0IsH7XAjr9HQyE8E22bv2a/5Pm4jm8axyDNeQHwA3/FdlQQj8XHJ?=
 =?us-ascii?Q?iNWD1m73EdjBT9VmVcL4zb2U949/KZjMLXg1amuPP/td0GlmRUnruHTYXIiM?=
 =?us-ascii?Q?tLsHol/YhlC9G4hgbkXtnC2444lpR0k2egXtmWT0XB/ap5k8BxrBGfhyu5GI?=
 =?us-ascii?Q?e8OkgmQWasjWZzD8BxsGqWYKMkaJEUwtiJ4P8o5qaEPMqM4c7V5ujZ2uTBDS?=
 =?us-ascii?Q?k+faoZKuDTUSnHUmrsREq49UEodlhdTqjPOU1LGXfSaDQ4N8vBqSODg45Sed?=
 =?us-ascii?Q?Ihyy/fo0Qi0rZEuoSAQ92RY7xiKF6qsDmKJB4LOrHVrgj2/LpDQaycZ1ut1/?=
 =?us-ascii?Q?vphLdKTqcAFpNwXy9VJZr81CcZ3trJD3WBU0uyMOSh1i+7id8RCT+Eab2uqI?=
 =?us-ascii?Q?qC5b4WUZxoHa5KhluNVpmp1wza9pe+e4iIQBDR2OoyBxTnv9nbmVUlQX29ob?=
 =?us-ascii?Q?ppFlg3AdflaPlyHYjICoXo+lZjNvUA5PVyPzLK+ynOdOqGCmUbV2A/7u7tSa?=
 =?us-ascii?Q?7FCzyl9q0Xo4zAG4MJOJHj34CgoK03cWmEmMi0hFheOi82TPBlDg/XFmEFzC?=
 =?us-ascii?Q?Egl3xMt9taIZoAQx2PzKFYFIiP3VT4Ba8b/fey9OvVuJUHNVyKy2fyB9hxEY?=
 =?us-ascii?Q?EZr/9iE9HZeXx8ymxkEFt4nBehNYUinSJjw2WJq9pT6qqWhN7eFMsceBOdEg?=
 =?us-ascii?Q?gD3g8vxwqtGIPnhQ018GIjPcPWZ+Oqj+ULx/t+imEnozLxdaBjsJx/EBnY80?=
 =?us-ascii?Q?X9bgxJQLXqMXbbw4G1XTtMXh5WJCMuCcQ+HzB9OqKI7A8Ss+GQ4cEDWevcIr?=
 =?us-ascii?Q?BMa5D9Dz5LWm7ar5XDwi4ut029q/zr5KjfpEmouOLxYkIrMMrOGL2Aq8YoO6?=
 =?us-ascii?Q?7lwbpQoJw2GrqvjN7AKtLVQ5RguQfzLAxFilxQ+prLhdvxvpCLRw3T3fiIrN?=
 =?us-ascii?Q?KW5u4G7wq3L0baWo+XlzIxXebC6a4rwVC/5Gcdhp5pvIhHIVDzygClTxkNaQ?=
 =?us-ascii?Q?LnKfmzARORhwF4kBAz/+Du1WaXPjL3PkPQyQrwhTIX56YcRiEJY+1zPi/t/l?=
 =?us-ascii?Q?G5zSJwRVU+hewduTHQs5jMQsjKiQO8OnKWBOxT0Umk0MO6k7eyT9vP38Q2r3?=
 =?us-ascii?Q?LxorrLxpkN20hzP4rOs85+DCg2/o79rnAuFwG29kHvn7TpWOJ9X6eEXucN25?=
 =?us-ascii?Q?VL0CIS5d+E5SfuBCc0bLNAbN3tW2m2JyRPGB0WFu3DvtRK1Nz/Kwwx2Kk0WL?=
 =?us-ascii?Q?vJwMFDgyu0rG/FOf+cGfYBjtTJT0v3H6Q5/ECH396o30ewG1gZznmY8pNcmZ?=
 =?us-ascii?Q?W5IieviE3cWOSsbDpILoH2PyBDqb81X12dg1cQc8mLdRPyp8CKe2unjxKOXG?=
 =?us-ascii?Q?eFIkQ2gQ6lRl5pI3Yh2Pf2OVkf55R1A5yij95diK3CarKHi2BvXq9jds+PDO?=
 =?us-ascii?Q?tZadGbQdrosyFDYREp9YaaU7l7VbDSuPYCSeNmXhQaU3jlbkyR5fQfcUuaej?=
 =?us-ascii?Q?C72kccevtvy3ZYhR6NrCjoOxenhhyml9cMNkpzUaWbDFA1dJ0oP+WK0R7xMW?=
 =?us-ascii?Q?vg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0BB5B9158111C442834EC9A48D39F95C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: BojUM7Izcn1tS4fmCIJIzKsWw4ecI4g/j5Tl7yg7JlId3q/2bNnnb5u2nvuwH9oRsIzx5k7B+LVaRv+7nPyjzuOA86/MfVJ/Vry8X806cGwGv2LH9mHcRhs7dCJo7QYkxVfpHI8MKug03zFyl1unHCor11/5TLTiElSe2SjZKXMh6OC244tz8FqzMnxQNaerTN5HoTQNAd8FHpL2LSM+YGqD8Wu/ZpVZud4LStV/IIUaKER1L41lDLKEBedsjVCDXo3ag6ccVFmKobIy0LKpJvG7a9Rj6KFDcedcXdCCRloR2bguO1Xo79BupVwXqtyvpryn2q/tLaKzUQyOcVpWBKLye1Q5SLpTREscV08xcc19HDfSjzIxvvj6wirfG9zSkKf126lnTF0Hn52a9/2rfXhAxrgklBIrTxg8NzM9MRNf6WBiwz4gmDrswhxTgOLmLzmJxQf7l/BAv+sssnC1gZcfjLFo/ustWjCbaLHeN1DV07UwU0esl9jAcRAGW8caHWzME/txe4a+u10i4hELQSFYuFHx3G5ak+s91tWtcDHfQoKcYxRth1c+ZI60fRbUU1Iftp2nHYky+iJd2QnSXT/dSlzl0s2HNeUrzqRklFngtqYurR2MY3yzkZCB70HpvdWHxqtsOmgS/lu15VT0ko2LFE/H0AdALiEgmHicJC5kBQem5oIrlUnQ+exOmHdk78M8zPGS3d4ZLVG3SMXVJtnt3vS86FrZ78iaTyXdLb7w4z4PLE0PBKg+KWcrS9hZVIKE/1XtXyxbCFn1kfpFzxyq0OlvBC8WJXZ1kKL9dz0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fc04553-93f6-4314-d634-08db6d38f848
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 00:39:25.3691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Qs0YJOlPHqVHgEY+l/oP+AWuRpga7NjFGy0VkCjhLO0OxkA8rY1V3U+Oj2FtjEql0SPH+6YBzZcvg9Q1kRe1YN95Iy6rmrzpxxN62RyANM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5912
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_14,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306150002
X-Proofpoint-ORIG-GUID: FkqKJML8YHRg25fCaefMM7wMv64OtIjw
X-Proofpoint-GUID: FkqKJML8YHRg25fCaefMM7wMv64OtIjw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jun 7, 2023, at 4:38 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_version.h | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/ql=
a_version.h
> index 4d6f06fb156b..e3771923b0d7 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -6,9 +6,9 @@
> /*
>  * Driver version
>  */
> -#define QLA2XXX_VERSION      "10.02.08.300-k"
> +#define QLA2XXX_VERSION      "10.02.08.400-k"
>=20
> #define QLA_DRIVER_MAJOR_VER 10
> #define QLA_DRIVER_MINOR_VER 2
> #define QLA_DRIVER_PATCH_VER 8
> -#define QLA_DRIVER_BETA_VER 300
> +#define QLA_DRIVER_BETA_VER 400
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

