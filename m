Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54803CD68E3
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Oct 2023 01:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379334AbjJJBiI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Oct 2023 21:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379327AbjJJBiG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2023 21:38:06 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA2D8F
        for <linux-scsi@vger.kernel.org>; Mon,  9 Oct 2023 18:38:05 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 399Nwq4j010932;
        Tue, 10 Oct 2023 01:37:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=3myY99OA97zyug/g0zeUjly9XsVqFggyfXOO+gjuVr0=;
 b=2woEOXHRWi3KW+OoAqGm723eFCVK1qvfpCXleedlpLtastybn/w26whSyc9r3GqJobbj
 77YW8+wtcIwI4RZgcfX0L0+eqwR6MBdboTyALeJa2tu3SyvvQXTbQxn6OqB5D/9QSfu7
 0sz/0SZMzR0rGmnvuJRjF+pFWp25MONmEBw7oy1ZTsB1b7pg0ljvRweMWTPpeYMXerM0
 nQPaQKkNT4ZMqWHI8fUlt2sT/z0UBKIdT4jmJKJcgctzH7l+ftdKzskRJWTF3pQn86wh
 9hHTzoN4OPVsPV/snwzfOOM8X9ajxiipcELCOBQOh5JiypA0lmZ+rZ9yN2xugM3lu9mu Dg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tjxxu3xub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 01:37:52 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39A06MrY004786;
        Tue, 10 Oct 2023 01:37:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tjws5shqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 01:37:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hxm56rxWiokgymf9AXS2Rs3VTh1ClFQTuBXhs1rAdQssPOzj1Ve0P7v6HBx1fSz8lSGSrW4FOGkZ3LDMGKeKaY92pR8oGoTYbAJkxeqBmSZVCPwuSNimsdglbPT3DS8wUQ+zPGrADOEZtGoz1sQI22abXMVJfo/+4XiXbaj1H0hKygdeJP3Ku2VI8bzVGV8yrRh4Tlg1QW0O6pHRwpqAVwYs5lnLX7wBccBh56SNGKc//xRxaKV98+ByJ5tgHZQub16cFIE86LKcXWHwYlyO46oLeEclX2xGFF5yojqvTStiE367lnYEF7LYkrB51H/I2rFEXP1tAeI5Pi6oqz85CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3myY99OA97zyug/g0zeUjly9XsVqFggyfXOO+gjuVr0=;
 b=ZJ01HxRIBKF50qeLXg1JniLuaUcoXE+8gbefW1jUT5JSfMZHFK05+W/4h66EPaAYclI3EOz+BFPwqiGy+a3PFzQeyft0Qn8ZPT4KhXxVj7QbUmIri2nqIx6R1BihIcjmDwWxPTdpXKV0i2WrMDXco849YZTivYJ31kl2NdFHy2+GaLZm38DA2pnbCTVcSkamXoSPKihNKkkYqC2hovkyiG1pCCyuKl5b9f32NcR6v4b9bWqoOvGyRXK9loSbZaJHugJuvTAdSmwpy2i3cuA/drr3vflURdOs93pGXJkdi/+D4sRdoCp3XoQFaLcuOHp6xLMB9zLgpqfjQ6k/6SPrvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3myY99OA97zyug/g0zeUjly9XsVqFggyfXOO+gjuVr0=;
 b=B+5nq4q4zF2R7bwJqins1ewmVYGKXRrh76LJRPzQxuHq6Uasbr8JmzZe57kwMHZ6sTbRTLv2BYuNFrhJWTK9NAwDXH0sVX4MeqxZuDxt7iqaa3a0mY/975I061r4mg9EPgk/4f6Uout250iC+cAywp8bMIJpOic//gxHMyCPYTo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB6195.namprd10.prod.outlook.com (2603:10b6:208:3a5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Tue, 10 Oct
 2023 01:37:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383%4]) with mapi id 15.20.6863.032; Tue, 10 Oct 2023
 01:37:49 +0000
To:     <peter.wang@mediatek.com>
Cc:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
        <naomi.chu@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: remove dev cmd clock scaling busy
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wmvvntpg.fsf@ca-mkp.ca.oracle.com>
References: <20231004062454.29165-1-peter.wang@mediatek.com>
Date:   Mon, 09 Oct 2023 21:37:47 -0400
In-Reply-To: <20231004062454.29165-1-peter.wang@mediatek.com> (peter wang's
        message of "Wed, 4 Oct 2023 14:24:54 +0800")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0012.namprd10.prod.outlook.com
 (2603:10b6:a03:255::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB6195:EE_
X-MS-Office365-Filtering-Correlation-Id: 20297b32-3c22-41f2-7d83-08dbc9318317
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lOCEmhbwif8EYy7AA+I3D8V+GceG82ohqxmstrB54ZGPOebusziUW5VlOkxUvGbco7qa6fTz2HooSy9c/b1xtU7rUcZ4B4SFIayoZJNLqI0R+gXmlUMbqu5jOcW4CCqlQEv1Vi5z2UOH7ScdnfqPysG5FqCBdtQCpZbKtIaM25jDvlSKfDIqtnNtKaT8TzebYxdnnjKOnWP5udtQT25lUSAWMESQmRey3a46GoRf029DahfSUgdDq4N+hfobL+MeCrw3R5ZauSVtQNMdxYBR7zCn5zaY1yOZssSZQuBUfDUeO8RnWwiHwH54OgTfBFw54x4hcTtI+cwinDMXJxHouvwrvLQkUMWvgdSofvOhksSunanMrcdr5np8zUtgmayYeuVlo9GQffuwLzkiEPUKf3f/6m3qQ7RU8npgvh8XQooFInU8UtkopYJcaSr4WS1Sa2qBQI9oUIgmYe4gGm1HwTyfljadGSpy/TEjJAs07yy6apXK1D9juTxkzJqrg7UIBVnzX/y0DRG7IjwMd0w8Kz4ppV5M7z0JLqqMK/gmyWn3M/5v9YF56cQVvbIZAF3M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(396003)(39860400002)(366004)(136003)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(2906002)(66946007)(6506007)(83380400001)(26005)(7416002)(316002)(6916009)(54906003)(66476007)(66556008)(4326008)(8936002)(5660300002)(41300700001)(6486002)(6512007)(478600001)(4744005)(8676002)(36916002)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6Xb89TOr9i3xbUyNUY2g5ophzMobIJxduHO1zZuTh6vDW35cmwavmfJUy8dx?=
 =?us-ascii?Q?Epc3+wdXXCE8A9NTWynv/E9hpddO0jdo316eqOcuyZ2zQhe9NaHyJLkQzKq/?=
 =?us-ascii?Q?XKV7LtsrPFZNjrHv0gcP7mvkxM5wyu461P3E5vt+ZOCtQVlZRoBw3x2cEghm?=
 =?us-ascii?Q?CfWWL0ICAaLqHAmYToSodN6nNlrBZdE5RE7n7nnWDLttkEYppANhr+KtP0W2?=
 =?us-ascii?Q?LXjuT3dAKY+3RJoa+cVYH47kqje3rFsWY443oLfmiXNt7c0t2c4ceiTccoaE?=
 =?us-ascii?Q?FJsFOmg1GB+uhIoe6CBNitPB1IOHQhPBVKmdX60AU8SkE6F7FYIoCpQps5F8?=
 =?us-ascii?Q?Ff5pU8inn6jm0MxQlVsJ1VVvC9UOsOOtptlyWmpWOdSueCCKrRA8DugnX31O?=
 =?us-ascii?Q?mJ1l25AEvADhAXDXK2CbNBqQPBj6oQrrtLYtND/wV9XDuhMdnJLezZaKGwb4?=
 =?us-ascii?Q?ydv4erJG+IosqcfuFskGQrgOTqcVZ6WynoEWAdCjx2sVblbhTwgM+FyHab3u?=
 =?us-ascii?Q?v6x6SRyDyALrU3bK47lt6MpxESjwrlUCagoMcgJ251hk0sBvWaxp/dqd9T2p?=
 =?us-ascii?Q?GpHmxK8/Kh/IGWtUC3wOWsgKK9cdEeZ+sjkzV3WtRDIpHGPCp+/gjKwwVjx/?=
 =?us-ascii?Q?4ybaczWt16h931bzQxJoT4YlG5Z+n4DSFEAywbr1kXsFyjcr4e4x9BEj5jXo?=
 =?us-ascii?Q?S45bx1iCRy9ymaXbxV40wjv1gR85Qv3db/FONhnJC2o4Znc6yYJvdeDjOVI8?=
 =?us-ascii?Q?hboMVnTA4l0NEJIjQyrfn6slqCK3wyhNZYTaylpU9KDJExpxd8FpGClYnZ/A?=
 =?us-ascii?Q?ntbJHX2jpKJA83gCjwwoyG0R0N8sswD4Izjkwfk/Ukgbg+G+tzHA1UEnh/Fd?=
 =?us-ascii?Q?ied81+FHrlq/0H1EReiNVlpOlmQ5NL06ilnDZwBc8PCZ7ojOG+WB2fMJcswy?=
 =?us-ascii?Q?fJ5Qb2ZVaP0mY/LZwhdvM2IQbanHEc+jWX324KB6WM0x3XVmxD3CXkq7yTYc?=
 =?us-ascii?Q?O5WNYp9sQbUaQvHf8fpjt6Pb+cKtcIye2A0KhiJwOaHMVm5iwBsizUsN4926?=
 =?us-ascii?Q?GtaRcjZO1FGi8M1Wvs7Qe92/Ed3oBv1a9HkO2+JiJGDiiuNndMqGE7Q9GCth?=
 =?us-ascii?Q?iUovWBG+Hh19Yw4aeCku8/PZU9/78HOidgVNDGYY8pJ6EwtapdK5ZNt6dnNt?=
 =?us-ascii?Q?2w8GQRQog8UuJboBBLo0CsJ2P7whbeoQ67OjFVXnW0XrsxymaqtKbe5kqsh/?=
 =?us-ascii?Q?bk6ncn3dLgVzKLtdx1+UqsVby2haX5dGvcZnZ8SHmNv504hiYQTpjOnXzcn4?=
 =?us-ascii?Q?zO1m3OhPdgGoEBO31zf/RZDIsFQdWGDGQXIZPwIDZ0x9r8Vjx7QZzLx8oGZE?=
 =?us-ascii?Q?BlmjfogOxvclSjdqBwFzTyuQdqDL77++qhWB9B0xyqqBEtUB4jcfjIjjaJLj?=
 =?us-ascii?Q?SYsOpzFQ5wpH2kSbUYGAzej+q949pWBByvVrC4jcK3bOlH9cG725fUmLVefQ?=
 =?us-ascii?Q?rextFhbMxSpzAi0IjMxF4Q5ek8nGPILBytC0hU198YMkcdpUEQWVlFNabhi5?=
 =?us-ascii?Q?ynOcibJZCpOOaFbR9gFZhAoEOgwvUxVumlk2SVaaSJjVr46JVgf0wjNNhkia?=
 =?us-ascii?Q?0g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?MuBYfroOeKKVlYDhtP/ayvh1oqvWJ5GppfnwX9OA/MF6Iu5/cvS36YGEMgpW?=
 =?us-ascii?Q?H2xy+B1c4Yx6secYn5G7hS1ivI09WH29lW1OCltIQ9oDH7dXLhDR3qp8J8wN?=
 =?us-ascii?Q?XQthozOrzrB0jDCMFungZSMlb80GoTTXOl+OSg7kepmKIuW49JoESzBqwvsE?=
 =?us-ascii?Q?Ddu8qpnG9Ioytd7kBoqoXQT3+PPSybDiKYOIRJggT8foavA4CGVHijEVBXYI?=
 =?us-ascii?Q?lkN8sop4EjVnIbdE/CEbsHEBDojlKC9Lqa5a/yHgiIML+Thkxfdl8ReAdxz4?=
 =?us-ascii?Q?E0SCHBnL5NMn+cBW0TFzDIPJZyZkb3DAmlbM8rzKQHG516dwL2q+zpq97VOF?=
 =?us-ascii?Q?kpJDfEHKbuBTyvv33ls3OGlWTZHxvVZelztV/ZhzaCwZlSW+No4xcVFvLqf3?=
 =?us-ascii?Q?x0miOKAnLr7V3un+wvLOYKJuIWB4cqlFn3HPIkHouc1tZLYrWP2/hjeCpOoF?=
 =?us-ascii?Q?YSIAuHmaFXz42QcvTfK9iavQOnllkFR3btadtJ5NZgMqDyIzmBBnGbhLzGOE?=
 =?us-ascii?Q?WIZkGyy5XC+V1+XvSqQ4J0JzSb48gO7UdsaEHWJh+KKFUQ2AaRXGY+iWoW6u?=
 =?us-ascii?Q?PRzTaKEcM3wDeUYDWQzyLwagekX0ww71Dj11DJPTjQFqK4yutvlxKFdiUhvm?=
 =?us-ascii?Q?POjINijQ2V+5VASDeCn4Dtti8D1kbEnPPk/z5Dv/Fi3s7tLu8xBapK1DP26V?=
 =?us-ascii?Q?Gjv1nSLa+jfpNR8dPYk/Xt014a/swb06wP2iKGf7buuUlUe7yynXbvgi9ilZ?=
 =?us-ascii?Q?Sc3n2PJWO36SwBWpa98yJfIxeK/iW75Wy5MPJ5bqy+bZ9Zt0qxF5OZnTb5VU?=
 =?us-ascii?Q?dDjdD8EVqAogIWSKybwGBOvVJo4UxsIQvlTfAEH6JxrZI5lj5b8a7ObOkkAe?=
 =?us-ascii?Q?6kahVrFa69injlZQFi0jFA5ybc6qTCu0XJSP9//vIFF5jiVh/LNelWZ1gjU0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20297b32-3c22-41f2-7d83-08dbc9318317
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 01:37:49.4277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bW03VNTNb2CgEZebV/sDLK+/88EeoLMyAoJf1Oxpq0LddX6y8F2m9b7cVOIGZpSb7gvPvgbxwp0pEwC0zW0eibeeZdWKCd+uBBcB1kG4P2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6195
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_01,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=815 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310100009
X-Proofpoint-GUID: rmxRhxn4jW-bNwTfyWnBMW2rpPS2yfrJ
X-Proofpoint-ORIG-GUID: rmxRhxn4jW-bNwTfyWnBMW2rpPS2yfrJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Peter,

> If dev command timeout, clk_scaling.active_reqs is not decrease and
> cause clock scaling framework abnormal. But it is complicated to
> handle different dev command timeout case in legacy mode or mcq mode.
> Besides, dev cmd is rare used and busy time is short. So remove clock
> scaling busy window for dev cmd is properly. Same as uic or tm cmd
> which doesn't update busy window too.

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
