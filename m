Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEA0C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 02:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7A3E6115A
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 02:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237163AbhJFCkM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 22:40:12 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:45462 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230301AbhJFCkL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 22:40:11 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1961gkE7024877;
        Wed, 6 Oct 2021 02:37:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=EXEibEB4DrEfmJdvBQRLhki7gxaX0l5EhJKVlGIhKKg=;
 b=HJuZlagr/Wc5FK8UKXMkomWIPfG6ib3GKOtTgabDfaMGR985Oz1L96BVIAXnE6Dh2Ls7
 ICDbjnXUc0yhUTzSnI0iHUJS1zAgAdAnaEAyQWEe5v2vVcGG9Kvuyyvprl3aYAPm8WI4
 SLw9QqPzh3lWdR33i2Wvdhoir2Tts7K4kUsCCTa18egLYkWqsJ0lCvGd5DYn3sXuEaFI
 srBWdvSympLO8PnATf+diY3X2zr/2jnwnDowaQ+L5fqkFa79ju/MI1sTnFKsVqpNYlrv
 lOv+qHX6/rp2r/WZNJDVTRP/4RjDZ8rO37V9Kuw+u5aae92+qMMCrrQiAq31LF4jjM7r Mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bh10g8nqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Oct 2021 02:37:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1962a2GH049790;
        Wed, 6 Oct 2021 02:37:54 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by aserp3030.oracle.com with ESMTP id 3bev7u6acc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Oct 2021 02:37:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l05uGO+ltptuj1JLh6axjAGhn20DLCPB5OXS+eymFMioQyn3PQSUhHiqt7x5QK+JTw442jDP6zuHs5uJobHupHRqnkEku0vk3O19/gpo8skk2/Y9BLWF4SX7LfapF5wliIzzUlM5k9dYOhrKNf6/MQ3rixmhsgIE33Re6b7GQb3GQxryJg9eU0C+2AApU1z83Bl9FvcS/pVAff1V3iDf783VgxtOk7xqE+IdO9OV3IPtuT7sPLfHGGbcBEKsb+m096FRrnW2t+wAmKc/WKCipSDt2kjh1/adQbvs5+DQSJBCK/psFah8TG3OYQVV0RfwujCEHaO59YeGeYOhAei2gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EXEibEB4DrEfmJdvBQRLhki7gxaX0l5EhJKVlGIhKKg=;
 b=e1mPCa4yVx/8bXuQdj4Asm1RmxRtcDsNb1cFHrD1+iP5tbOPcG0lWoL6Ahz2+/DiVOEV1Bpb37V7vLodFtv/WzJnSA87HVp0W0ksYuLxj0bQQ/A9ZSRNYNVTPsivcZd6RILtatre+Axtg1oZlHcFKp9Q25/lV480mHOFHHweU85bOdu9vlH0QoYJZDA5Tl+CkLAnNboK7pFx8tBJeVmJVJsaDdY6ZykktWVuNNp5VxW34uAgt0RiW+FX7b/SWz2qyjnsyCg/7l3KFr2LAJpJmm/BCgtdRricUqX8FmjUj4hrzzcd4E+o8COm7ZXaPauUY0suTyDnWRKgGbm7ZWSIyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EXEibEB4DrEfmJdvBQRLhki7gxaX0l5EhJKVlGIhKKg=;
 b=Gh/My529RyW+UVn7+Zjor18nFXCU+bqZl3MKLkXL2IiNlfB7JocVDtf/iZIy4/EOnsOJSh28bXuyrBQ37nldcQq4LsySmIYPr+tvYym29osH8sft+/waSG8Fr/TuM35Z2Dq9RsmbQIpTTn3lfTQDrFVOaYoUOAAj6Nwo98ynWF8=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4695.namprd10.prod.outlook.com (2603:10b6:510:3f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 6 Oct
 2021 02:37:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%7]) with mapi id 15.20.4566.023; Wed, 6 Oct 2021
 02:37:51 +0000
To:     <Don.Brace@microchip.com>
Cc:     <pmenzel@molgen.mpg.de>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <Mike.McGowen@microchip.com>,
        <Murthy.Bhat@microchip.com>, <Balsundar.P@microchip.com>,
        <joseph.szczypek@hpe.com>, <jeff@canonical.com>,
        <POSWALD@suse.com>, <john.p.donnelly@oracle.com>,
        <mwilck@suse.com>, <linux-kernel@vger.kernel.org>,
        <hch@infradead.org>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [smartpqi updates PATCH V2 09/11] smartpqi: fix duplicate
 device nodes for tape changers
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y2763mr9.fsf@ca-mkp.ca.oracle.com>
References: <20210928235442.201875-1-don.brace@microchip.com>
        <20210928235442.201875-10-don.brace@microchip.com>
        <1351a25f-5310-cae3-ae47-01c842e0a185@molgen.mpg.de>
        <SN6PR11MB2848E6A6F6824C55641FB6FEE1AF9@SN6PR11MB2848.namprd11.prod.outlook.com>
Date:   Tue, 05 Oct 2021 22:37:48 -0400
In-Reply-To: <SN6PR11MB2848E6A6F6824C55641FB6FEE1AF9@SN6PR11MB2848.namprd11.prod.outlook.com>
        (Don Brace's message of "Tue, 5 Oct 2021 20:23:22 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0009.namprd06.prod.outlook.com
 (2603:10b6:803:2f::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.19) by SN4PR0601CA0009.namprd06.prod.outlook.com (2603:10b6:803:2f::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 6 Oct 2021 02:37:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ed50d86-9217-4793-9775-08d988724b1e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4695:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB469536263C9443CD14C6A7BE8EB09@PH0PR10MB4695.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K/4nli6kAgLEpnAwIqDqrzjJMh1dkj2uJjkZ/PVhEw3EzZSJcmzfc9tQZvmjtwHYCC/uhtOq87sdqc5O4rB6ZHiYChVgGq6B0h7UOwwmHQ8az4x0AwftthPFdRbU+vWMDd1pgYd/CYqIvP/tUS/8AUUzmkGKQqt5ViO7d+5hFA12Y7u5GznSP7m9SlbH8HNfbUABWabQH5XGx3dPLyJPyh1jB4kGmKghbpN2/SQldpaVmHcOZS39BdSqObB/uzOv/RQ/NdPGp4V1SO4diu/ok1rLu4C33KngrdRS70IQzp2NvXdeF5DaD/O24G7mtPD8qna+3n2Foe8uGI3oGKQY8YyVNFZQmqosXghQwKkbxoVP2smOfDJp7dDGFCVPISZPcAWfGZI4NEJOUfdUkElgboqpfGC0Ltjn0dSW/aQ0LYFiAqq/vOPYjZomnZvyalKprVqPPBXRwWDlTy+e2z67BqgWi4rpjTNlSoo6wYyGOA7kHJn104Ygmr3fc1yh+rTkUt7PgHklolCsj2Z2tv2X7EWjwkygZkKUFYGn6lO9eNELKilmhmZ48qAW59q5gHNt8ufVxM5o19K9x7/82Lm/2bGNYLkYtHDjbXqI3R5FuM0fa4P3XJiAzx+3bOjItyPjY/f005su5u48P1JUMJpfhD6Roz5nay8cUuIbB+LXBqrk1ufKvRLKvrxEeCxItjcJmjIjLJfu29+KqiVzmAAxqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(55016002)(508600001)(2906002)(316002)(6666004)(186003)(26005)(66556008)(66476007)(8676002)(66946007)(38350700002)(38100700002)(36916002)(4326008)(8936002)(52116002)(6916009)(86362001)(54906003)(7696005)(558084003)(5660300002)(7416002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W6er/190UCW15HJsaMhY4ePhcfvHfgeZnm12/YHICA5dhvPuMNkzCp1z/y2n?=
 =?us-ascii?Q?AUXAUPjRu4ziPEco/QQRbU2TCiRU+wHZ+D0rxORLoX3YbQ/ohJmH8/n+Fqgn?=
 =?us-ascii?Q?+tWk2fQ6v+17KOFUKy6T3/XOAkSguTQ+nHej4GDuruOt9DObrZeL3MjJeoSt?=
 =?us-ascii?Q?K6IakaiavH2igQB5nk8ZL1muen6kUlT+t9F4MV60hsi4vvEmYvwBoiFSODoH?=
 =?us-ascii?Q?cf5kVlpM+A4/h2khyZ8bDjIzi9m6rG6t2yBp+lpvBy29TzGQaVnt46ukBHQ2?=
 =?us-ascii?Q?t0hSFrJuA9vTzvXpQBsdEqPlLiamHk8HgWDZmhL8IBTlsc2EU6klb+dKG0G1?=
 =?us-ascii?Q?gHqh/HqMORDXYokKtn4tWwHgMC4aDW5/1MdObRoCCrSvj0+489S2siiVXlF3?=
 =?us-ascii?Q?Pu73cx7zH/KlBrkTTKu5r8x2Iv/clS7BsHe06A+jL+JXXPf/ALBp8gYPjnpg?=
 =?us-ascii?Q?urkyx1XCZxwZtabDGcRrtgGqOF4AZA6Q2hDU/6TkDblmBvzgycNYKZQffLjE?=
 =?us-ascii?Q?SFLNICjL5Rqq6lftf7ounVrzQ+oeAryEbMlh2gY9eXl4vuK42TBhZMlk7z1b?=
 =?us-ascii?Q?u11YB3pkoamjwks+vYF+aG8fFNGAvHmxUlN6dUE95yMjklS4/keK1A7aPFbF?=
 =?us-ascii?Q?lNziEBOH3S7+n5dhdKUYbhbALg/aJXfKHktaiByg32s5P92R7DNsOksppHL4?=
 =?us-ascii?Q?7lKoSWFrDOTUoHyOWbzwC4q98paldOSPBc/X5uIc8eObAUe1j4lukfM4CaUY?=
 =?us-ascii?Q?AdMogKBGh62UYPpwvBagnK5lT/5txMbF8tTbUlxaxE14NQO1DMcid3+nxUyW?=
 =?us-ascii?Q?COMEmfvwJBBN3RBcWLx/FAShn6eQNcHUfyRP9Q8C83rElDOAMQZEv9GUxA0v?=
 =?us-ascii?Q?iO5yqs69GlYfptRWqQg5DseA3fvdECdcqxTirgOssYZLHMB03/VwvkZR51AF?=
 =?us-ascii?Q?XPF0uKhsQW2h68yS6C8FAQrWPs4SEzVnP/mkU9ybeUr7uS/LKiwfWWw2rN73?=
 =?us-ascii?Q?mlqTDCYs5E+SF5HwrvYacDBGpq7g7TuFJusd4wrGvJowc+zTcvvZ9xryivVD?=
 =?us-ascii?Q?AI3b0pCGVuTpwxQGHrKk+hxu1JvJy1hw3ttFNdILJX+7v/aJvgSdJaIJZ5u3?=
 =?us-ascii?Q?z/P32om9OZUtueT/EiJ2IFIXVB5m0ndHbtnsm2Ava8WxbUtQtbz2Sgx5BmeO?=
 =?us-ascii?Q?a/KMt3uEGuW8bb34iV0j4jjlhFabUFLHlCaX5SRqZ4Mn5w81L+rXnrpWp9iH?=
 =?us-ascii?Q?pb5BjckACBmer9SUIQEVt/NVMtBYWgvBi4brPIEpF46FOJ00XH2HPwvE9CFZ?=
 =?us-ascii?Q?+rj10Wu05FE0tt73wVU5zhLm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ed50d86-9217-4793-9775-08d988724b1e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2021 02:37:51.8616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P/NTKbaV1o7rovjc1IalRfXE2EtLUXvAVlGBipd1AjYLdvARsxFHCtBvS375CpRlz9MmLm6Gd+3MoNCbMAkssFyY920h1fwA6ylO8sCvZIc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4695
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10128 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110060014
X-Proofpoint-GUID: BLBJH4Gu79xOMom8ESirx_U508VRHoh8
X-Proofpoint-ORIG-GUID: BLBJH4Gu79xOMom8ESirx_U508VRHoh8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Don,

> DON: Done in V3, thanks for your review.

Just a heads up that I already staged this for zeroday testing
yesterday. If you post a v3 I'll drop what I have. But I would prefer an
incremental patch.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
