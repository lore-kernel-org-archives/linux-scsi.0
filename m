Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD2AC04A95
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Sep 2022 17:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbiIYRig (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Sep 2022 13:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbiIYRia (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Sep 2022 13:38:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0A42F028
        for <linux-scsi@vger.kernel.org>; Sun, 25 Sep 2022 10:38:27 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28PD5Ff9003610;
        Sun, 25 Sep 2022 17:38:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=jb2OfGYkW2chUeq3roRZRD6NH/sGgYJI/av9xbhlIM4=;
 b=vqxoIVyoCOhTCv5PNUH8DOe0+6hzlR8OTmXxmp1JLp0BGw7AQ0uN7Ew66Sks+H1+0N1y
 LSIY+1zYXvDSPVA3ClvZ7q4u4jsUzBS4fSC8oq/aavDXfjxuuJi3GfAKU7EydnfWmB3w
 PsZziAZFeoU5YxwrBLZz4iz+lQ1m3G3T6rJKfeU9+GJuLDTFsUNKWIpWdh2TqFxJ/J4H
 ePE+4SdbYnXTBKkuIySBk27FovpinnDOfjQ9Ce5o3xxC80HEvKtwNCr279jN4RktIRPu
 Xfi/i9GwgFkQjPGF5ryQQNFg2fdxY24cTc5W7nPIsn8oAlSE7zkzNXrQYQfwPCW15JrZ qQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst0khxrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Sep 2022 17:38:25 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28PCHHsI001526;
        Sun, 25 Sep 2022 17:38:24 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpuxuuu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Sep 2022 17:38:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0xzfK7VInisb6p7eOwtLOiLqCZKFysa8YRPE5k8tYbidLpq4v4tA/0h7YjrSnjQ5s88cbRGz10lEgXXjMPcE2uUP8zptL1vxk1LRUwqWY6ZdS7WqPZrF/5DZcj3JiMFHlYhQn9GM8SPkFVBej5e9YHg31M3FAfprkm3He2Oy5d7JL/BurE1TboKQCITB53nv2wruAUHXQDgsCw5it6Dj+Mw82Kqy+T4R5LmuWcSwMzZgGj8gd4PNqFD0bVMrE+63hzldPEKqOrnX4wyPBE26wMTnyNDhxDXCas/7n0e/1JludPEGjkPrngg3YkIxsES9V+nhanjlaavlPa3PuUC1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jb2OfGYkW2chUeq3roRZRD6NH/sGgYJI/av9xbhlIM4=;
 b=d/69SrI0TYl3tIIcfGPRbbvZ1RIXvtoIr1qyYswpuGdoUE1VI/ikD2svL4LmJ2GSFBaRRfOKY/eph039DbAmb6NmgpwdcAH46cswo1R0c2o228iTpNDtCp3evhLoio0jTNcs5n2csYt2MC2yfEvg5TsIFUpYH4RRaRo/BHCyOJPO3wbMd2761RLcxeoG90SBmUruXpcgB19AhnqXWRWWzDB6wteEwmVqnOOHs50oVsd+qpbUEDzR59u+CyGPr/L0brjUnmIIH2LnDPFCFYQYTG6uyiGmKyO6d6iPCH/4O1yhe40Aw9z/LwaSQyedi+dlZQjV3aACxY/fErqTqOwG4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jb2OfGYkW2chUeq3roRZRD6NH/sGgYJI/av9xbhlIM4=;
 b=yyY2HEJL7z006HBSUeAGmFK24zk0NLN6xeq97Ajcv8AW9SFobauMqTocC6AJ8RxrLjd/PctvW9pqYtD895zA1M8xBCn5nnlzAeSMwn4xJTlxAReebDnMr2aQrNBKvKI4PxlykHRy6DcjlOEOlnIQKFkwvJJHckNzZWHjTuJo7Bw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH2PR10MB4295.namprd10.prod.outlook.com (2603:10b6:610:a6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Sun, 25 Sep
 2022 17:38:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351%5]) with mapi id 15.20.5654.020; Sun, 25 Sep 2022
 17:38:22 +0000
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        matoro_mailinglist_kernel@matoro.tk
Subject: Re: [PATCH 0/2] Unbreak mpt3sas on big-endian machines
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmfjpd9u.fsf@ca-mkp.ca.oracle.com>
References: <20220916130111.168195-1-damien.lemoal@opensource.wdc.com>
Date:   Sun, 25 Sep 2022 13:38:19 -0400
In-Reply-To: <20220916130111.168195-1-damien.lemoal@opensource.wdc.com>
        (Damien Le Moal's message of "Fri, 16 Sep 2022 22:01:09 +0900")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:5:40::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH2PR10MB4295:EE_
X-MS-Office365-Filtering-Correlation-Id: f97201b5-d7c4-488e-bb5b-08da9f1cbe20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RobDgTPHSv8FJdrYH7VU6OKET47MhcIv24PnWT9Iq670l+Mk8G6jwPo9fuKZflLifXoThXrAANbH4ALlQ2fIhS4c3/1+62tYDd/J9SkS28YpL3RE5bE3Ss4qA1EOToMRvfRNBRVftIbb+oY5n+Q8ph4QKl+jgBSNbBPGDGwmmnuQkioH/pMkgyJJqT4GmCJ5V0EZ5OVykzSUSqw4g57N8SY4XFOIZRxArNIgV0SXCilA81PtErxOTh8t72ybfnIA+VrWVQUC56WXNrA15/yNMDfFJ974PUAmIiNPj1yt+EbWKCmXNMj4XpeNM+QvDrVPOHhDetzuXoIHGCCldimOEftUjrThMeDlma39Yn588SzwRWZ+dTIr72isauFQO4CJ91Lmqlp7t//glG15uNWkfcGO2ZmsHxMAnJCJQZ2RazmxhIVWW48CGyDC+2FAs5FyXrOm+0LhV0kmX8OUHldF2+CPhV1/QwDxLxepAmUi3XwzTUFXgnTbdJP6edRsN8aSqYQUq5PRo4C2tdPCjzUTcJIFcK0Wm4r2W+Qcch9xjqdV9qNiueGlxqEWd0pJ7PmK8pzPwe9ZdL4lbNftsRvTdZxBzUpSJ8FcJ4rnOv3aPyQmyUP8wUnRYr/26jDjeoXs9m0rMJNAEpsQBfKDTC/TYSM5x4RQOVjIOj52fEl87JUae3xHybMO2MpZYAnpIQiA0BgsDdAbw3m/gtMX2Rx+tZYSHpEAHvGn8gZes0eNWuccm7S1em6cm2nPPn4juikEacQt+L74NDjlC6NKDHVZa/lvcSoMTBJke1o7klUeIrs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(39860400002)(366004)(136003)(451199015)(86362001)(41300700001)(8936002)(4744005)(6916009)(8676002)(66476007)(316002)(66556008)(66946007)(4326008)(83380400001)(38100700002)(6666004)(36916002)(6506007)(478600001)(6486002)(26005)(186003)(6512007)(5660300002)(2906002)(42413004)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D0NmAiGo7kWdhTYQxtdlsGPN7umXQRUBBKk6+9NckMLO+zc4WT1OwqmxGJT8?=
 =?us-ascii?Q?SWU6G7STyW3IN5kIYZATK4H2qbUjnCBE0iyTynsieGUdEgkkmSR3nNzXQvKS?=
 =?us-ascii?Q?1tLXtuscaqgHhhxJcHwIAX9SlG+9nWz4+qiczdQhAbSfG1MRt59nWvThHI6Y?=
 =?us-ascii?Q?KolBJB/T9t11l4qld9N373vTmd7DaL8IHkVFVnf6pMQbI/3ormgF9rz1h7+v?=
 =?us-ascii?Q?uNTt98AdtcMh0f7Tl/Buy0C3bYNJ1sbvALexg9Yc4D/TgxNGddKcq7N/JoJD?=
 =?us-ascii?Q?Gn2CWP1KVX37AMWqfR/q/KNqAz+LSS2mEGlPH97tmQkh6m/mUkFNS9zOXUNh?=
 =?us-ascii?Q?PMPKeOA6aCnAviYIETjp1KRweIpEK3LUISQtu1+F7/8xq6/F1R/JOVyDfZaa?=
 =?us-ascii?Q?vRviv2CajzeqF6vaNFqi8kdWvXb08Xqrg/IuH+HIslib5nRQ4E+EUvxkZhZW?=
 =?us-ascii?Q?sNZuyDO00dyvy7d4fRd04g6DUsLfy0ErqNEcnpBqBBQ/K/bQxp78naNadzZK?=
 =?us-ascii?Q?xbTUf4/f0iKKs+b1P0bDR/llMJPvCd0lWl8AcHNxT2TdoA4gY1pTuSM890mK?=
 =?us-ascii?Q?J0hmSZyuGvo9daCeC8zWKLVm9Tc+NQuD8I2FOcCIOb4cvyMpeT74wb5NaU6p?=
 =?us-ascii?Q?4sjxKT/PtxxxettjEJvDXldf5OLXeGtk8ldsFxNNJlke0Gz/UpxzVhik5eAv?=
 =?us-ascii?Q?mxVWXtSTQW69ViO7tE8wdTgE7xjhxGVuqLhKYT339Ah52wgtkNq0dd/xlWRB?=
 =?us-ascii?Q?vrnN09CBk4LCHVv2kvR2xOLI1NV575frBNkwrZdfufDwfyoawbyrbNoqeiXN?=
 =?us-ascii?Q?lmJ87TCDo/XDydLPLMxY/vcF2YgDttWCcWSW6bNkjpYe5I3c0iJfMKhjjmt4?=
 =?us-ascii?Q?RSzr2UEcfrjdn79MtcRfN5wbe3BLEXXzhDIKimtgmzXSdtpkxqrU3o8lQ4uo?=
 =?us-ascii?Q?2ZntRPzYxPq9FXJqzFPjf+hH5RUpHCAANgIhjn9jEuonAtg/Bm+HGcpfr4qX?=
 =?us-ascii?Q?5tXiZYYaO6hxKa+zm28I56xyIl8BYqI3Hw4/S5oNNEM3D7GXi4BfxqMwzEPb?=
 =?us-ascii?Q?L3lhgWXzIPhAmy+HkdRtRpS3k1dpqOdx8YoLGEPtrjj60LiQEFKl4HJA6c7E?=
 =?us-ascii?Q?MZ/k/Tijb3/6ASeqPpKCBQhThVdDayrkNkog1FPKUfOauJzt0H6I9L5O85Ay?=
 =?us-ascii?Q?skuqWWXMy4Kl9MRpD7jrgVvpkOELCABJ2Vpv4Q97TC6ODzs+co4V6zC6101p?=
 =?us-ascii?Q?XXK45uLgIkdSEqQUD/7KypBtZCEAAiPIP9IJ5NwkbeObSlmCk706VeiDOlZU?=
 =?us-ascii?Q?FXkY3O7ZeJSUrDn82eGKBA5jns0C1q4IewKylgw6qULAcHynx9zhTxydXARH?=
 =?us-ascii?Q?OVGsucBiN8YDNDkgrOa/8W6K++k1mAUizw0ldjaAVJlCFgaAiLN4cao8nytd?=
 =?us-ascii?Q?9Z/LDonVOW4OVz4bfRHz+YSVvOsDrjcd3I3LKgoXmn7V6MMdhI+87BydFBgD?=
 =?us-ascii?Q?6hm0QgNqllZcaGmdAVUjZRcnfk/rKLx7kRSsIDN1WS8W79YRrmMJF9Sa7fCy?=
 =?us-ascii?Q?klZYrZllGpM4uatYG4NDfu3pa7rC4N+HPVES2yHZp2FHxf+/nZHcnxYy3f0C?=
 =?us-ascii?Q?Fg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f97201b5-d7c4-488e-bb5b-08da9f1cbe20
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2022 17:38:22.5469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p3qV1fiM+NPdJ5Omx9b+yXdYHBtFnSGIyPuCifbA5/oAchs0pv90TZ/l7HZ/Iv2GuVwIAlDKUZjCQhMIyWyp+qMiXvRi4PuLozIDEGqAA/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4295
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-25_01,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 mlxlogscore=675 adultscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209250128
X-Proofpoint-GUID: F-enqpFkDlCzRZHP8GXyQ3QWM9uMsuVx
X-Proofpoint-ORIG-GUID: F-enqpFkDlCzRZHP8GXyQ3QWM9uMsuVx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> Patches b4efbec4c2a ("scsi: mpt3sas: Fix writel() use") and
> 7ab4d2441b9 ("scsi: mpt3sas: Fix ioc->base_readl() use"), while aiming
> at only fixign sparse warnings without any functional change, broke
> the mpt3sas driver on big endian machines. This series reverts both
> patches, until someone more knowledgeable of the Broadcom HBA
> controller interface can properly fix register endianness control to
> avoid the compilation warnings.

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
