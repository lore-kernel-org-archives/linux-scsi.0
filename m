Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94409C00144
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 23:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbiHAX6e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 19:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiHAX6d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 19:58:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BB924BCD
        for <linux-scsi@vger.kernel.org>; Mon,  1 Aug 2022 16:58:32 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271No9nY001959;
        Mon, 1 Aug 2022 23:58:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=HtmpFSFd0twkCWlpgxO7RQKLbRVKMfnnBcz4XAFTRwg=;
 b=DCkiXisPU/sXiZEX/McWbBnzZVaU8AMOk4Cjw3DZXnBdmXVRIe/MVNm1uD67o1EaLFSk
 ckzqn+MjEcXKeCR8W+MMl8IhKxoQi9gsLRV+LH+RblffFgOQI8wzLeFRbwJNMD1/jy11
 3NJPUyrtkKhcoOe4ixfpTpB492v3YWnCOluX7hICahZ7C8E2O+3yXOtoCvzE7vy7Qt5j
 S89jnjpzwZdmz1yCycmIEF6rtEtob4bX9x+0NoEpTcU+rkHD/j5wKdhCO+9up9L3bj4d
 Kdc01dXpjLHZdroQK4ZNp0VxdkkoXuozwGGLsOy2lBnarGD5SmKBtlCI9Ch9N/oFUN3j 1w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmvh9n4c3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 23:58:19 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 271NWnv3014182;
        Mon, 1 Aug 2022 23:58:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu31t4ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 23:58:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LadhD9gUJFH1NaRC7P5UhZPI2UvOTqgmGdyePpT3WVU6UaCo0blkYU23QIWe92q3hKXtMrYXS9drds1E0yt2xDbWUo2vi4I/iW8o7hCEwsD9QNxiEhTYvG61kP7olyF7ZSIRCj/kSReiikyk7xlw+K8ObPK6i1vZC8q91epYYu9dhri4o4GdaoGt2hrNl4mlJRRw68Ab/nA37FwXd/mRXyC749Yv7ROGWl/mXVYTZ15CySUFLgxPyupUNpDMFhMvifKomyRMiiPfz30Pp1AJsVDCNPf/UynSbiG4TDCHKlSKiKXmVgJQE1iTLzUPrpawemnEA6iDMox2c1ZQ6hurgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HtmpFSFd0twkCWlpgxO7RQKLbRVKMfnnBcz4XAFTRwg=;
 b=cj6CMdIz3hsbZUI/Dmz021JoJj3F8/qEiOz34GLbzyjto9FQvVl3rnpLzT59UtSPBwVFS0pI6H51AJZ9BMtC8wa+TLfMxSSVFNuNPSM0gOAUf1S61/qL0YZKbYUqR1VhDU/7JDrgKCWjm1290ncTzgcXeXTrNaEAVmbcD/FwkhGcEBbcOgJvoSMRJK01Elvgh2ozHi/2026VWVh7APEziUY/ZcyL8CH2qJfz6Dj5Yu5fzFUEVu/PUhtHjVxUSx18fXU/UBVkSLcf9xyB4WlcDEOxFdpCUIng5L2y5cum8s/XY076RBh+e7+HoQShgSQXe28G3XhZerj99EJ2Qy2Cbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtmpFSFd0twkCWlpgxO7RQKLbRVKMfnnBcz4XAFTRwg=;
 b=GlNvNRul+eulhmq45GqhyHV15nA8MIN2KxTNq6xDVo1o1qqT+cCCHjk4DL5IAEVxKoWaZM1AWiA6vnBlM9HvtAWu2f5v/bD7Z9YZQyJwzGoEnVwCu0mII6tHApwd4S3xf7qXz+DRB7C3ETnXsCVsRIrQytSOqxWBq3UceMt0LWE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5815.namprd10.prod.outlook.com (2603:10b6:510:126::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Mon, 1 Aug
 2022 23:58:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%5]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 23:58:00 +0000
To:     Tony Battersby <tonyb@cybernetics.com>
Cc:     Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Disable ATIO interrupt coalesce for quad
 port ISP27XX
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k07r34c2.fsf@ca-mkp.ca.oracle.com>
References: <97dcf365-89ff-014d-a3e5-1404c6af511c@cybernetics.com>
Date:   Mon, 01 Aug 2022 19:57:57 -0400
In-Reply-To: <97dcf365-89ff-014d-a3e5-1404c6af511c@cybernetics.com> (Tony
        Battersby's message of "Wed, 20 Jul 2022 09:43:52 -0400")
Content-Type: text/plain
X-ClientProxiedBy: DM5PR08CA0035.namprd08.prod.outlook.com
 (2603:10b6:4:60::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76e9b47f-4c45-4b73-1191-08da7419a9f1
X-MS-TrafficTypeDiagnostic: PH7PR10MB5815:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gsU6nzItl4L0HLIExP7/dZ6J23L8rcXaqo0qOHVVgUA9gEIqkTPmOE79uI9EtShC9W0qRVF1beMSojqzqX9KRVlf4bjUsMtYFhbgw1GEu670RB9+bjuw31ZxpdZDNeQEqF3/JCbY++JTB8He5Qm8vdXXu61AhEEVGbAZRxHSmXMY71NZFNAd2nziZ+FUCin8haLMmjjAl7oMD+IhEI1Yb+AKgQi08deYdarMhYuzln28OY31wfzsMb3aWt5Inb+LaIuwkiNj8prv2geGNp+54XdXF1kBFFeD5WeJCKnpeGzrckorUGWrBbjMZhpzHyx0xyLfMJmaZ3S0RGdhwM70+0HyPQ1v4daAor4GCugVQPchEi5TgzF8z+Ui7t/hwLa5/vb2hYcXTRbS7hQt9qQpndF78GigCs6OU2bzx3KMDaQGdUFiy0Yi7aXNrmxKCSpkte8mszz979pp5Pm3mYKfc3N3aIBwPkZ2ymXiVY5W59UGrmY64wdH7zKWVitkDfFU65UJOo1eYowZkgTa3p/Ay8mAk7lKcTPIFL7sWDoAnze31lyc6sP0Cyea3RXOye5/30s88Yr7LjidoVg1ju0lavRm/7ylFX8wq6nTvqIRHDm1YM+X+vX0f1FmHhLxThHwjwGhGhHblCX+Msdz5TMxZAPA/Tbruf6HlLd8S1tZ/zTvxRxRSMtiVuwSec5WEiMPUPZ26Vk4Liy04/2UhQnTLucOpVSe3xD8Ft+51dFK1iX0BSTW6tJRjuTY+DnLnDpae0aW2IagcgHiL8l7+dLIX6fnadIM+Aw89ea2MUKzizDfwObZZ2NzywgFSHmOHQtc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(346002)(376002)(136003)(39860400002)(36916002)(38350700002)(38100700002)(4744005)(6512007)(6506007)(5660300002)(52116002)(8936002)(66556008)(66476007)(66946007)(316002)(41300700001)(6666004)(54906003)(4326008)(8676002)(2906002)(6916009)(186003)(6486002)(26005)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bgy5klpQy8AmnUgdAD5IS5zYJ57L6DGbXRHnZnC/8M6jhWF1nog0kj03Piab?=
 =?us-ascii?Q?mD26ssoPOwSfsVS47jWp/0hryLn1M3zPi3q+0XfUT/VyGD/3+5SDr5MuBMlV?=
 =?us-ascii?Q?y2p4pWvhAe7EHiBqg+kNkhEO4nkMTUOz1FyKajjHVDPtjDghFUyEpaVA0FB1?=
 =?us-ascii?Q?5bjeOtvlLviqBe+Ut6YlQQ6hHUqxgJwZ/cZLOEEPBWGQRLADI7o4D4yg6VK9?=
 =?us-ascii?Q?Jq+nAxCI0SRvfVxPZCgRmScfFXbZGmh95n9FgJ5m1HZgLA8BRfxFtUHSWAya?=
 =?us-ascii?Q?BHj9w+Wb/Ma0Y+NADm+p8go1JNbg4+W80ghk472FEF1KWk3doHLdzYoE/ZsL?=
 =?us-ascii?Q?vjRdNJCq9D5lxLBIs6acBn9znmwwfjz7R9kuLY1e1bK987EcmmNjsGE6EOHb?=
 =?us-ascii?Q?Lgve9y4Y8TFt9oube8AcGOM9RmGRqGpA4rphlIx6Ee5rIcXXwLl2B2qTjYUE?=
 =?us-ascii?Q?Lc4hhKqNkudu5EtMOub9ZWQnyWTWcRkni3tOfB0V0G4RiH3Y/YeSFmDvAhGO?=
 =?us-ascii?Q?INDUEs0kLRLVQRa7n0Co3qD5ZUH1XuGEhHNskx5rAD+chACkyr2FZmEidCko?=
 =?us-ascii?Q?CXi3d2vGQoHS1qZoIsUaV7C8O8EVONHQ/s/yfNnz52Xdlb8TuRDAbj99SgY5?=
 =?us-ascii?Q?ZuygJlqSNgQeNvP1ZU5jOtJ+29wfdzvHZPyT+djCjPNuSzFUohC/1YL70GzF?=
 =?us-ascii?Q?nwUlZdKLAcrR++Umw+s0wAZ2/cs/aG9nf1sJggRQGWnN34xfpXYR+8Os0JUI?=
 =?us-ascii?Q?hfPmbgnSZdnY7ZqTt8U7okmLJajXthhFCurwsSsXLY6E2fEnJ3WJtfw0xKxT?=
 =?us-ascii?Q?eWliV2ZqQjHec3d1R4DgQD8bmUbSA/1s4uySwN8UeLV/YBRTBdyuLEwfPsUh?=
 =?us-ascii?Q?jMgJnsM+yGtLhFX8WwsqGZEQRB7qRzlndvtdQ27/hWSreEBofh7ARHj78DT+?=
 =?us-ascii?Q?K2sU2kkiZLHX6nJvU6KDpvCFYtd2GjtzNqeox0y1Fx8+CyqdQ5zNApOZ0uMP?=
 =?us-ascii?Q?WRp/CkcLHadx8UxsGf9DIln6oogfD9JFUe89L+BMhdj5BzQAA6uxkD82QDvB?=
 =?us-ascii?Q?u/elXJzjhSgDcx8eTdFYuLmg1mTIoikhmy6H3VaqzKOxkJc8JWo5oEg6X6b5?=
 =?us-ascii?Q?XbgQFZdcD8pkVKuwsGUoqO8td1VYqth0/4mqPyqi5Mi33nImT82IgNpHlRpn?=
 =?us-ascii?Q?R8oSjIxGKdvXKCTzjq3YtOq8HJJgg85jC9tbMrz5GIZT3qARP6TfCtQhv0n4?=
 =?us-ascii?Q?vydwHqRpoUA2xns/4qJSzFiHVKUH7mHvTo1TWTYQ7Gh6ztOd0aU0YV57FWm6?=
 =?us-ascii?Q?DXzbjr7tWDkwkAsURty3iY5d1B4RmGRtgf9aevS1l7iZjVvw++XhdHVSossY?=
 =?us-ascii?Q?kSCobTPbNzVT9I+ldTWKhEPWHu5ZlH3pOxDnlvUJC+VBdUq5zla1U5WT0hw3?=
 =?us-ascii?Q?gehJZEeO3sHLJgWizeyx+svGazMXgX13qfH7BnXSaPlqy//PybqfalIiMlJU?=
 =?us-ascii?Q?5FD72MwJeWa1Zsz5IjQeU64JYsEzjtzDYKK1d8x3ZuqhD5I4T6tY6zFkgiNd?=
 =?us-ascii?Q?hrjkFVlCpa3HBNSqznoT7xdrH8HzTpoNJZ6/tRYttwSBZEj+xCdp1xzOR2fx?=
 =?us-ascii?Q?Dw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76e9b47f-4c45-4b73-1191-08da7419a9f1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 23:58:00.2061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KFubHqoCXlBHU05IRxxXnsrpAogyZeXjsolEffkoFeCzRak2PTBDtmZJf6+Iz14BliyvWfFpLu2cKlAN5EACMtNvCUyuQiH/S/kjvgYIaPY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5815
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_12,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=911 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208010120
X-Proofpoint-ORIG-GUID: mWMdJMA3O3CaKSpCr-1750rOyScXo7B0
X-Proofpoint-GUID: mWMdJMA3O3CaKSpCr-1750rOyScXo7B0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Quinn/Nilesh: Please review, thanks!

> I am using a quad-port 16 Gbps QLE2694L (ISP2071) with SCST 3.6 +
> qla2x00t-32gbit and kernel 5.15.  The following old commit that went
> into upstream kernel v4.16 is causing a problem for me:
>
> commit d2b292c3f6fdef5819a276acd64915bae6384a7f
> Author: Quinn Tran <quinn.tran@cavium.com>
> Date:   Thu Dec 28 12:33:17 2017 -0800
>
>     scsi: qla2xxx: Enable ATIO interrupt handshake for ISP27XX
>     
>     Enable ATIO Q interrupt handshake for ISP27XX. This patch
>     coalesce ATIO's interrupts for Quad port ISP27XX adapter.
>     Interrupt coalesce allows performance to scale for this
>     specific case.
>
> This commit was present in qla2xxx when qla2x00t-32gbit was first
> imported into SCST.

-- 
Martin K. Petersen	Oracle Linux Engineering
