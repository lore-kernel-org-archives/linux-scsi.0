Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD4AC77B73
	for <linux-scsi@archiver.kernel.org>; Mon,  1 May 2023 15:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbjEAPJO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 May 2023 11:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbjEAPJJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 May 2023 11:09:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D2710F8
        for <linux-scsi@vger.kernel.org>; Mon,  1 May 2023 08:09:03 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 341EItne012491;
        Mon, 1 May 2023 15:09:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=GleZl3HyM4p8gQxmSixJXxKnTVBkgjItiNt1Vf3gcOA=;
 b=VaFCUsJNcHr6xKqyatH7YGTjhLh4+T+6wzT10Gxa4f1tA32sdMebvtsVJ70edwyTDOPs
 irVIu+kARGlnUgzaSW3MN3CLmEdBopHrjsCFxb86lq+bDerik/LUvxSaPsbfSEeKXA9x
 gBsIsZDCVNk5FyVnGJzZnhoP5XKC4lE4CKKCmH4x042pkNVRoWyvQcKjQqvN50s+fd5i
 drn3gToMokyMvpYE6dLh4HnHx1b8+jMKgKORWB7JHTJXden09OGWrbp2g0ptR5+n0lsX
 CkVs0QpKt0g5nvdLrRZSCkON8MNOMMp6wooWh50IPF7o6hWtv7YI0mDPy2UuSy2PCQNj hA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q8tuu2hp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 May 2023 15:09:01 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 341EXQUl003258;
        Mon, 1 May 2023 15:09:00 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3q8sp4sv2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 May 2023 15:09:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBaNOLvCe8Ohuk3WFZzdeNi4DQ63P9XhQru7HwjtZ1H3Fjx0LP8Y1w1/VxZWmIMvn1Wa6gpHnGjwzYkvmJamMPjgarFjAwESN3mXg5MjSKe+fIIfw5FYz/vPQ5XnJYUF01qRmqtDZRNVOWcoHExnt6BgpDiYdSvoWWM3tboUUH6nr0w/EEwHoToMzyxDGf3b2wdMFx6saBp+1JYoNtL0d0UlYHE4GRvc8r2eutc4F1Ov6UCDKzm7jjQ75oPoPigXC4HfbsvI1Hto9zZv7/a3/GHgxGzwVjzxQ+kSIcvXAR9MgRXwx7DhYvWosXqqfmKdIG/qFA0yYsVpOc6wBHF1aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GleZl3HyM4p8gQxmSixJXxKnTVBkgjItiNt1Vf3gcOA=;
 b=bc2tNLuhztu2CkMK7ZmDHQGveZonvauQye1wBWxyHcKJPgIsLeTMAkUBiu4JGQ819VXOFuLGlvFz0rfUR3sQnoyl3afXd4jQE10rEIbQ/ZqQydnAZeUJa2Ds1Uge/c5TkggXfaxVunjORe/T9TrCxJStfFRsbIIu1oPEHZhkJTQ0MEGhyhT3SS1GeHc8dPU1S9s8GSF99CnfL/K6e+uIdtJPuXadzjOfOa935oR92eqtHdqoGaoGHdHaCYGJxLNbMIom85TyyqsJ8TsTCOvN0s+lsab4V6lT0j7RCH8SJTkBt7TyCRl5LU69MkqKq9Dytwvsfn2dV5c5Ic5Fr29Qsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GleZl3HyM4p8gQxmSixJXxKnTVBkgjItiNt1Vf3gcOA=;
 b=FB8Wae8LVgxRa5oogtfBmFWcVgyxOyJ7QP1XmOexW1pkc+9rA1U78B3x3hp8U+8ND3+kHQNBCEKBqJAN0oHLoU79WKEttAU8IHbysYZQONZz1eMvzK1tY241RB0itEJT8uT08XMohlZHfzwV3utgP3RqM945IB3hmvVTNpuZNe0=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CO6PR10MB5633.namprd10.prod.outlook.com (2603:10b6:303:148::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.29; Mon, 1 May
 2023 15:08:57 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::195a:41b1:6434:af74]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::195a:41b1:6434:af74%7]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 15:08:57 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH v2 4/7] qla2xxx: Fix hang in task management
Thread-Topic: [PATCH v2 4/7] qla2xxx: Fix hang in task management
Thread-Index: AQHZeaayBWF1WDuYrUir+JXrICp9IK9FilqA
Date:   Mon, 1 May 2023 15:08:57 +0000
Message-ID: <DF83CDA6-2AE1-48A7-B3A4-C0015D438EF8@oracle.com>
References: <20230428075339.32551-1-njavali@marvell.com>
 <20230428075339.32551-5-njavali@marvell.com>
In-Reply-To: <20230428075339.32551-5-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|CO6PR10MB5633:EE_
x-ms-office365-filtering-correlation-id: eb44774d-e2cd-4b7c-87cb-08db4a55fcdb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cf5qx7m8w7rr6DYq5qRZv8AKQvqcu+oYoVkvxvRrVYo5CPQTIHJ4h6XxHzJcZZi4502JrnE7BcfEqKdLS62w9KXmYuEz5V4NyUY5XIynglBrI6V/ySWfAo/gU75ZDZTT2syXHK+8N8S5+Te1ROq1zyzVc65daX4+JYpz0BhDP3fTa7WhLUDeJpoKoxrTMnJ4rtnj4i06HPKObYkEl9A8X9Z+uBUsuLnSg4a2XZXap4seBmycRHT1xX/R6sRwt+iFXKSMp/11VldZleML2/mWVAKQHwQig49/SNFLulbe3qr7WJevQ58SqpB7ILKh5D0LIzgz0RKXqrNj7CK8a8Tj0kXx9gc2WAk6IYMXO5P0W/cyAqMPbMnXpZcNOfU8Jh+EaIU9NOziGxFVZEJnTmSKntHMHJDdmqq0CSYsNW9I953Q11ndbxdLQ002MgvvExwwtlIMzaBwoYFskLiv2QhJZ9RYWiDxyXp06EpG/U14Ef162XnHnAt1DEsvkTYEpJVyB3Gx0R+jmxVa9lEvWr8c6N5xurAbYMf1VDScHC0b+LAhqlxLrt7ZkZ9TNtrOreIuk9tWg1l5l72dGdQ5rZ7cUcoAMGq4QG0hJqFi7a9f0fS34NtF4ZwaGhZImyFkbwtPj2sBDzUph3oxnwxmcPCEZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(376002)(346002)(366004)(396003)(451199021)(38070700005)(8936002)(8676002)(26005)(53546011)(2616005)(38100700002)(6506007)(6512007)(33656002)(44832011)(478600001)(186003)(5660300002)(36756003)(316002)(2906002)(71200400001)(54906003)(6486002)(86362001)(83380400001)(66476007)(66556008)(64756008)(66446008)(76116006)(6916009)(4326008)(66946007)(41300700001)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2illnuRW1mL6AMPQVaT2QEO15NB09L4vvtqVx0a3nFj3SWNFW/xtERglaSIG?=
 =?us-ascii?Q?4hJYpVpvVpsN76pYJln0lX+sZC1+bdoXvNqzH4K+9E6DPirG9Z0Kbp4wVQya?=
 =?us-ascii?Q?zgV4ZLlstgjMYAtTiDKXvRtX2Cf4vNyz3YpGAfx0/N8UrFAy1X+EdJksJcTb?=
 =?us-ascii?Q?KwfyM5JiN7pLUEM6Qf6P4Wc1hKNLifIK4fU3qtdqygW4NXEgRtIIkZq6BC8B?=
 =?us-ascii?Q?lP8HLX8Svy1qaaj+mPeSDYkb9YHyebxurfJmq3qKdwa8aQjbm7fpd1gFFGDQ?=
 =?us-ascii?Q?Vh4xUACtPjEjohhS/y/HM7kTBsiTNpY8RFdeH5W74tg1r7Y36rhjJDSg+dld?=
 =?us-ascii?Q?w0ehuKI0oZBrJHnchGeBL5UZC/gk+BPHsDBYSVUIx135jS6b4+f/3/QfBaXj?=
 =?us-ascii?Q?2fUJ288p22O02pZp7OLqyoj3ATawfOCh0ToFXiM/HEW5dZEH3tr9EtUXUPBb?=
 =?us-ascii?Q?nAdf7HxcGlXNMdvXZJCtqzNpbqLAvtsJaYdq8BeXS9hxaBM0UJiyEh+88rmW?=
 =?us-ascii?Q?4dSBsXtzpkedFaPJl95g1FibtcM+Hs/UF23iqbJnSVAQy0/6ALmIX7qIYY8I?=
 =?us-ascii?Q?Ryo1pb/nQ2Ltu4fCr/HrVy/p8xbsJbOT+kehtv6lQ1ZhPLI0YLC+47zCVZB+?=
 =?us-ascii?Q?aLydyvUF+a0Ui6KxVCVmAoVknyGVCocD52eVcsS74HtxLgzbfA8hOeka2MiB?=
 =?us-ascii?Q?83wu7qHAhu8PT3KrJ/bUPKx+l3NId9V3xcThDdVqf/h4QLsQwHUs0zE+LBNL?=
 =?us-ascii?Q?Zcdb8Q/9v7S8ZggE2dtbU3PLKHRSONwy32Ftx57DRgckk/WJtmUqjSwJ8Bjn?=
 =?us-ascii?Q?Z5lkRW24+5Gl23cMYO2u9jOEVvGGRRAsUbKx+tXBQ4n4pTpX9AFu5Y4VEH+7?=
 =?us-ascii?Q?vt4zbMzqsH7Ab+3YRFfAn2WBbLnSnPkZXa/nuA6Mnhogx64cK2DYcntn3JnP?=
 =?us-ascii?Q?6Byju/GHnPsa7cEIU1ZiW5/qCfXOg3Y/dGrQxHKdy450JoLa+kQsLfKeRAWM?=
 =?us-ascii?Q?7QKh2XJZdSXhnOu8+u5fxJqeEYjs/ZFM8eX26oW0s5toK7w27+Ue+IKb64dW?=
 =?us-ascii?Q?WQ+bJCyBV15oAPf6KygyWkuQmcjSv5sdM2OUsa6D5fsLrNRBY5r+2B1nu2Xk?=
 =?us-ascii?Q?8aF5NpwxIVBjwcSbWLE6Q1P4PfOEyCLOJwmcLW7IP25XOrvY2UaHEn7ecNtu?=
 =?us-ascii?Q?e6YHNFkwV+PIFIykx2t39RzlTVXUZpJJ8uUZbtpEj6jEJHEuKtYO4hCEz2l8?=
 =?us-ascii?Q?vXhISnT5sAW8eF3kVILMh/CXxJYOCiiaXDhdN5oH9fdGacXZyKOkv2RWnVRp?=
 =?us-ascii?Q?5bIer0jzs/mD8cjWl/N4daG/RsBLQkvse0AuC6zuSRqqfb2mtPGQwQ77xS7g?=
 =?us-ascii?Q?x8K37LbZWamJaKOR5VT2SQkSzw/tBZ73aW1xmfb01O0axm18aLh9TY/YMoEx?=
 =?us-ascii?Q?lIk4kZY8T5YL2Few/59gVP/bIUE5g4w8yjtZJUiQjlpzPvFbpVgLVQ9ghRA2?=
 =?us-ascii?Q?VWUovdQOnD9tsRrGb8D4cazbH5Z56zu+bX/spq4XNL2CjcKhlmKtLKk6Tywd?=
 =?us-ascii?Q?nveOVT3cKbeQTzvIQh+XKO+xJDS0qLvoW5sL0WK0hepIdZPsX8zRE0Plo9J+?=
 =?us-ascii?Q?tw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <592AD6BA1C9D6A4187288452BE2CEE2E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ptbcugwxpG7rPyv1b4vgEUlpcRC0kEs/ZpncUh8gaOWVUoR5EAL0M8rpbDTqSA61NzJG2JFnpp2AUvUNOJ+mTxEMGxElk0rd3SQtNVGNczhE4t2K0mGePq7j/8TsdLbzyOEiMJmXW+WvkanQkPsjnVU7pQoxuJ6pVrhCuhZgVsXOOeq1EK0EiR3fAOlsGoji5li+Zyny4M0AOARD8v8F5HIRvfIGNAzIwb7aaJwLS+O4HQc1jUQaRPk/NTroa2xSA+yYJeoS976zufHTt4sw1ZtMqePUtKpmeP6OnpLh5r5+JtvY5FSX8yAkXne2oMiunyXYwMrfBXSaW2DeAQeVtVgPY+bKTRqasZyt1uxaXtjOr0MhvJg01eYm5/n7nAiFb+NFst1uFCAjHqg/1B1LGgm/7Z2wXamhPshlCnid2yzIZBxbJiou40jsYvt5IJGm6zsEpbstnIl8KAujReZOi4JvSDGICQEfQu79XD53JJOiUJrDYu6qDZUd54T9n/LgzlIc4hTOSNmgYlHreTDCM4Jh8CmrAIhT++AR+aljcpb1Qs+LYRye9QTHC4y6N3jqqBUhXhPHjHG0klWeJFnj5imMdx7s11nwegQvjLWT9FzkcEAFtMTMHiCWS3ELgN0g4G9bWjJTdx0AuU8d37SMNa4KcWwPkbmbD/sPlEoAH1lgb7bOxwSXc0zltuSyXbmPDjY/aPb8WYaSEHOk4yFOVxfy6wiEqBPUKjDE8A+Hgx8ascsyE5YybLprUNgQSdoaS0lbMbH0j9nFfOm0AfRvr37UtrFn6OSbTDBOCoAI8RY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb44774d-e2cd-4b7c-87cb-08db4a55fcdb
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2023 15:08:57.7970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TZldsqGK86sP8xTf3BwOZ2v8AznC1NHkjHxwP8FAx6gvbq5qjWeefmivfNsGukBS8k2MjplRFu7EVYNUI6ay2MyCDUsZcuO0wUv29pGkqGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5633
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-01_08,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305010122
X-Proofpoint-GUID: E0AX26QS81oUglQb_09P1xyK-204byHK
X-Proofpoint-ORIG-GUID: E0AX26QS81oUglQb_09P1xyK-204byHK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 28, 2023, at 12:53 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Task management command hangs where a side
> band chip reset failed to nudge the TMF
> from it's current send path.
>=20
> Add additional error check to block TMF
> from entering during chip reset and along
> the TMF path to cause it to bail out, skip
> over abort of marker.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h  |  4 +++
> drivers/scsi/qla2xxx/qla_init.c | 60 +++++++++++++++++++++++++++++++--
> 2 files changed, 61 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 0971150953a9..3e0be0136cad 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -5516,4 +5516,8 @@ struct ql_vnd_tgt_stats_resp {
> _fp->disc_state, _fp->scan_state, _fp->loop_id, _fp->deleted, \
> _fp->flags
>=20
> +#define TMF_NOT_READY(_fcport) \
> + (!_fcport || IS_SESSION_DELETED(_fcport) || atomic_read(&_fcport->state=
) !=3D FCS_ONLINE || \
> + !_fcport->vha->hw->flags.fw_started)
> +
> #endif
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 17649cf9c39d..b61597d6882c 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -1996,6 +1996,11 @@ qla2x00_tmf_iocb_timeout(void *data)
> int rc, h;
> unsigned long flags;
>=20
> + if (sp->type =3D=3D SRB_MARKER) {
> + complete(&tmf->u.tmf.comp);
> + return;
> + }
> +
> rc =3D qla24xx_async_abort_cmd(sp, false);
> if (rc) {
> spin_lock_irqsave(sp->qpair->qp_lock_ptr, flags);
> @@ -2023,6 +2028,7 @@ static void qla_marker_sp_done(srb_t *sp, int res)
>    sp->handle, sp->fcport->d_id.b24, sp->u.iocb_cmd.u.tmf.flags,
>    sp->u.iocb_cmd.u.tmf.lun, sp->qpair->id);
>=20
> + sp->u.iocb_cmd.u.tmf.data =3D res;
> complete(&tmf->u.tmf.comp);
> }
>=20
> @@ -2039,6 +2045,11 @@ static void qla_marker_sp_done(srb_t *sp, int res)
> } while (cnt); \
> }
>=20
> +/**
> + * qla26xx_marker: send marker IOCB and wait for the completion of it.
> + * @arg: pointer to argument list.
> + *    It is assume caller will provide an fcport pointer and modifier
> + */
> static int
> qla26xx_marker(struct tmf_arg *arg)
> {
> @@ -2048,6 +2059,14 @@ qla26xx_marker(struct tmf_arg *arg)
> int rval =3D QLA_FUNCTION_FAILED;
> fc_port_t *fcport =3D arg->fcport;
>=20
> + if (TMF_NOT_READY(arg->fcport)) {
> + ql_dbg(ql_dbg_taskm, vha, 0x8039,
> +    "FC port not ready for marker loop-id=3D%x portid=3D%06x modifier=3D=
%x lun=3D%lld qp=3D%d.\n",
> +    fcport->loop_id, fcport->d_id.b24,
> +    arg->modifier, arg->lun, arg->qpair->id);
> + return QLA_SUSPENDED;
> + }
> +
> /* ref: INIT */
> sp =3D qla2xxx_get_qpair_sp(vha, arg->qpair, fcport, GFP_KERNEL);
> if (!sp)
> @@ -2074,11 +2093,19 @@ qla26xx_marker(struct tmf_arg *arg)
>=20
> if (rval !=3D QLA_SUCCESS) {
> ql_log(ql_log_warn, vha, 0x8031,
> -    "Marker IOCB failed (%x).\n", rval);
> +    "Marker IOCB send failure (%x).\n", rval);
> goto done_free_sp;
> }
>=20
> wait_for_completion(&tm_iocb->u.tmf.comp);
> + rval =3D tm_iocb->u.tmf.data;
> +
> + if (rval !=3D QLA_SUCCESS) {
> + ql_log(ql_log_warn, vha, 0x8019,
> +    "Marker failed hdl=3D%x loop-id=3D%x portid=3D%06x modifier=3D%x lun=
=3D%lld qp=3D%d rval %d.\n",
> +    sp->handle, fcport->loop_id, fcport->d_id.b24,
> +    arg->modifier, arg->lun, sp->qpair->id, rval);
> + }
>=20
> done_free_sp:
> /* ref: INIT */
> @@ -2091,6 +2118,8 @@ static void qla2x00_tmf_sp_done(srb_t *sp, int res)
> {
> struct srb_iocb *tmf =3D &sp->u.iocb_cmd;
>=20
> + if (res)
> + tmf->u.tmf.data =3D res;
> complete(&tmf->u.tmf.comp);
> }
>=20
> @@ -2104,6 +2133,14 @@ __qla2x00_async_tm_cmd(struct tmf_arg *arg)
>=20
> fc_port_t *fcport =3D arg->fcport;
>=20
> + if (TMF_NOT_READY(arg->fcport)) {
> + ql_dbg(ql_dbg_taskm, vha, 0x8032,
> +    "FC port not ready for TM command loop-id=3D%x portid=3D%06x modifie=
r=3D%x lun=3D%lld qp=3D%d.\n",
> +    fcport->loop_id, fcport->d_id.b24,
> +    arg->modifier, arg->lun, arg->qpair->id);
> + return QLA_SUSPENDED;
> + }
> +
> /* ref: INIT */
> sp =3D qla2xxx_get_qpair_sp(vha, arg->qpair, fcport, GFP_KERNEL);
> if (!sp)
> @@ -2178,7 +2215,9 @@ int qla_get_tmf(fc_port_t *fcport)
> msleep(1);
>=20
> spin_lock_irqsave(&ha->tgt.sess_lock, flags);
> - if (fcport->deleted) {
> + if (TMF_NOT_READY(fcport)) {
> + ql_log(ql_log_warn, vha, 0x802c,
> +    "Unable to acquire TM resource due to disruption.\n");
> rc =3D EIO;
> break;
> }
> @@ -2204,7 +2243,10 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t f=
lags, uint64_t lun,
> struct scsi_qla_host *vha =3D fcport->vha;
> struct qla_qpair *qpair;
> struct tmf_arg a;
> - int i, rval;
> + int i, rval =3D QLA_SUCCESS;
> +
> + if (TMF_NOT_READY(fcport))
> + return QLA_SUSPENDED;
>=20
> a.vha =3D fcport->vha;
> a.fcport =3D fcport;
> @@ -2223,6 +2265,14 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t f=
lags, uint64_t lun,
> qpair =3D vha->hw->queue_pair_map[i];
> if (!qpair)
> continue;
> +
> + if (TMF_NOT_READY(fcport)) {
> + ql_log(ql_log_warn, vha, 0x8026,
> +    "Unable to send TM due to disruption.\n");
> + rval =3D QLA_SUSPENDED;
> + break;
> + }
> +
> a.qpair =3D qpair;
> a.flags =3D flags|TCF_NOTMCMD_TO_TARGET;
> rval =3D __qla2x00_async_tm_cmd(&a);
> @@ -2231,10 +2281,14 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t =
flags, uint64_t lun,
> }
> }
>=20
> + if (rval)
> + goto bailout;
> +
> a.qpair =3D vha->hw->base_qpair;
> a.flags =3D flags;
> rval =3D __qla2x00_async_tm_cmd(&a);
>=20
> +bailout:
> if (a.modifier =3D=3D MK_SYNC_ID_LUN)
> qla_put_tmf(fcport);
>=20
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

