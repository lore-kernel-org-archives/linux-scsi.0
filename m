Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12103C4321E
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 03:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiLADR3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 22:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiLADR1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 22:17:27 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902A45DB97
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 19:17:26 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B10i8EB025678;
        Thu, 1 Dec 2022 03:17:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=FjEujc/vC7zxRbAb0zaKatl0Cbia9ib/8ZSLtN+SY3g=;
 b=JgOXKHa5oRvO7ktOZUasclkA2mfyaT37kQ9NrUDxiD+Sqx+mtxjqhQKc9wBEcgSZQbwU
 LTFB+mi0zuDgqf1yCADRg2O6zX6syxV+frjIYZ1Gt1uquUDZfzEyklamdSNiVmQIQKob
 A6iM/ayUrK+RhiwHSOgZCPTRp567dXFTqFx7WqIMIxDsUuQnUeRzfYepsMMh7+8FfYwV
 M5fzbrRvEZiWww9hwRPA7e35ZtqLBG8wABNwsiarrT2o5cgF4WMv/N+D5jWYd9HDhRvq
 rb+Oaa/x9DV0EFF6d2ryuDZD13YQ7lYC7yO215MXs6oMjED3B9NEGVXel2oIOe7ncrYe bw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m397fm6ws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:17:20 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B11FXsD019654;
        Thu, 1 Dec 2022 03:17:19 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m398a944v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:17:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rsb554Do6f976RVIwcdsU/GxVxLSYhaOuBvjT7Jeji0MMzaCrzv4KCYFlfXlfk2mYIkoLyqCY4lWmGlm8Ib0SE79mL1Vj0UQRchqan5eLPrHXh0FYSJsB38ZtepOokbJBhPg1uXsM7IQyUrlzAb3BHwdCHmDNgms50Qh2HBCmBdmDd2xeN07a+PwYMbpKtgT0Iit/cs48WLHWfFt1mir1OLLwNXrDOouxtiNsCrfwCdr56Yyl0C1EsS3rtqO+4R6JaWuXh05AEM8Nojt0avxDKhIa/Gvkw6lypLRyIVOPLXvHCjRkg3PQXZwVvWUpmknFRqwB4aucL7oEGIvcWca8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FjEujc/vC7zxRbAb0zaKatl0Cbia9ib/8ZSLtN+SY3g=;
 b=bEYFPwFHgaZab7cH5wXlsgXQIbseFcjv8g2hdfojhrqZwHOwJTMrcR0bcUoipjTiTVpQWjaYW1/9YMIylOv6KiFA1EoR8lEQYaUUHP4SgMMtAGvG6dHE5glERhfRyhl1QKeGUutpR9CUWnNK07SU1z9LjOkH0+RhVI36ZmwfkqWOr3iuvLTy4FpC4ENu41rxB+7bX/jLvgh3Pgz4zYikGMXaMaeWXaY6f7SUzMFP6si0EYCEroVq4S/ppi6fORML91pBdbogEkCTQJ9ddJf4N/UYfX2O4xFh+8hVQ6Ji3hwORGP6QEor945DbAXB6GarWLi9se5p3iM3tbFu1oOkyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FjEujc/vC7zxRbAb0zaKatl0Cbia9ib/8ZSLtN+SY3g=;
 b=jQONWv/gYIcb04oroeEkVmpIdSfrRWl+IyxaQZBZrpvSGdRefhXHrzxjZ0Rlv/C5TdLPsX64Fi0v7qar3I/iNL1gpoYYc3kbX1SGQ3q0N9CZ1hHe9m3yK5gHXM2zrNdlxLPED0GqeBns5wOiZwirmE12pjGwUtPvUW+V1yz+i2Y=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4347.namprd10.prod.outlook.com (2603:10b6:5:211::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 03:17:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%9]) with mapi id 15.20.5880.008; Thu, 1 Dec 2022
 03:17:17 +0000
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Damien Le Moal <Damien.LeMoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5] scsi: sd_zbc: trace zone append emulation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bkonke3y.fsf@ca-mkp.ca.oracle.com>
References: <d103bcf5f90139143469f2a0084c74bd9e03ad4a.1669804487.git.johannes.thumshirn@wdc.com>
Date:   Wed, 30 Nov 2022 22:17:13 -0500
In-Reply-To: <d103bcf5f90139143469f2a0084c74bd9e03ad4a.1669804487.git.johannes.thumshirn@wdc.com>
        (Johannes Thumshirn's message of "Wed, 30 Nov 2022 02:36:16 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0005.namprd11.prod.outlook.com
 (2603:10b6:806:6e::10) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM6PR10MB4347:EE_
X-MS-Office365-Filtering-Correlation-Id: 803c1d3e-ee7d-4039-2be5-08dad34a8c21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N1SVqD4OlCBuFjL2P+JtJ5rSKtO1X040A3WP8NLMfIXv1c+Kgpk2vYdpgr2VXw/0q0e3wy7bwVqy2JuuN7TNV5wLpV5A51xLOpqK/bNY3GPzDgUBkCLNaipBmSBPoQX4cXGv8OkX87g0lRTVLli6CvLZ4MGbNvL6Tcrw2DbVeRy+xQHrjd8mK/dhygT+eyPg7dNY6nn5cc38Pk5Zj1asIan4kNk+UePlC2PvhDGp89nLPgvbqvcGLLNV0coAdRhmb4SNE+fynGo0R2pil5n5/dUqYfaXaNofw1wKCnKtLrSXPFgT/1hYlZk3jc++XihMu/63qrMxLMHrYdc3rTNkyK+0Lvg22/O76QYX/t3jXl1Y1aGNWwP0TZ2a0kH/SwsCu6JdSA2VllJoTCG/9qhR+Q9PNJv0lQX1/ZUWyKdociD1p/MR/qO0EbGBrZ595OyZcfEoU7ZQy7JuDI93i+OI8O2GgJocdXUrFxhtttHgETfuOUcDOL+LPzN8C3H8i6jBRiiqKxORrI0QFEEsKpzxjAG4c/x01q/8ZivtrH1q9nKgJFvjNyRqzeRJc9jukayule9c0wrbInF1cZqgXDr8GOGKAUQz4BFZ5SxmAnMGyf32nBU9U6skBoAuJbzYMEjQziopaWHValTXuOdXp7YefQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199015)(6916009)(6512007)(316002)(54906003)(5660300002)(26005)(186003)(41300700001)(4326008)(66476007)(66556008)(8676002)(8936002)(38100700002)(86362001)(2906002)(83380400001)(66946007)(558084003)(36916002)(6486002)(6666004)(478600001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qmh0hGyXkK3Fs9nfVK/9iRgJ6v7NXKs3w4rxyGn226mYjuziUYE/dTYhIa63?=
 =?us-ascii?Q?AfmvIXHRN5nUbhzThAfMA1jvxzHppPmqO2RUdu5SI29SZPQTu2/12vkc3xsD?=
 =?us-ascii?Q?6LewXyuhed4cwnUsA+N8sTFAlcPGggTcYPbuJjr2NCZvLhzYLzmUvPi8SWWx?=
 =?us-ascii?Q?UlT8Y4dM16ziTue/g8yt9z7TVcR9tlzrOuWcSD9KObWjJeu1Xc8wp10VzueP?=
 =?us-ascii?Q?bh039OIsMpa9r8r88QpPiS3ygHDaLMWrgb/4usn+dR1Xz/MrbhyZpAeHUqOh?=
 =?us-ascii?Q?aLGZhij3b+ONFNLqGTyGq9qv0ppxDnh1YcdQns+bLTRXmY+7MIQOtod6AaFS?=
 =?us-ascii?Q?eFIS7Q0DOWBvL3IztEkwU6NAPYMQ6CmA148Ch+eDJJSHNvsI6XRsZNRMNhy8?=
 =?us-ascii?Q?/6yw6udjQH/DgFoePxZdmSGpQAMlKadTCjADD1+z3JamK1/vHvJur6bkoAe7?=
 =?us-ascii?Q?6ZmE38SfEY5fB2uHxEQ7rZYW41NlTxigpFL3OzT8BtczOPz+sDyam4GNPCm/?=
 =?us-ascii?Q?/Hl44UhN/ILjFwrLDYhYcXd8y2r3asaNQ4RghJKbYZfcmLotQ9l9l/cGei5c?=
 =?us-ascii?Q?hokPkYxM7aD2sGE5nvFyYVC769ugfZllfFBNaHZ67ckxBn0KXYciY8nULa6T?=
 =?us-ascii?Q?naWGiZFiQ7erlvueESsrtohlUEk3V5vdEI9JiF9vIm43mgD166QCK7oKxX6W?=
 =?us-ascii?Q?yTEiQmRlju/7M+E+GALrq8rRAcO45hwuCoFL1YjQLXh9BD7XamM+iWhvVdIy?=
 =?us-ascii?Q?YgzgPwwRqqH3Y7OvnV8q2Xt8nzb6gf0gyVT09y13O3aTXMnArzI7dNj8M+0c?=
 =?us-ascii?Q?BwRdO/eP2vTKHTVEFFZpKHZrx/Jd2xPR3BTN9+LVEKdGJc2WH17hhtiTFunN?=
 =?us-ascii?Q?M4JVgdk3plhdXP4UElKzshl2KYo6ylbTB+nGnVEjjI9erJ+fA6QPSDvrcvUf?=
 =?us-ascii?Q?l4ZjJ0E5yX7JJNU4llfGvXxyLZD8iPMZYLjYpK4nnep7uiFqrYC+2EGGUCb+?=
 =?us-ascii?Q?MxCj0cpeaqxGqJ5mSqfMTVaiXFnElPHCmE6VCu4LjZqEuDGxb3TKs7R9zhE/?=
 =?us-ascii?Q?CoJNKUIYGranglzAKyLQ1B9horCGmOt3eCclM33mCtnYNwyFRmcODOLVsTyo?=
 =?us-ascii?Q?9C7tMS6f1hI+dEU+0LDCtQzLlYUpgQIw8OaSC0BL4yxiQI2aeOp2PJ/NdqYF?=
 =?us-ascii?Q?xfAY3MQ3rDgpRAb9Rsd2wjfQMR1YosiMnpnQVsk+pZBijTaJtq0sZvjyV2Os?=
 =?us-ascii?Q?+vDuKiyQ2NFHOwGB/49NW7ykBpcqG9p74qjfHyLQV3pdODKPXk3JNM+S1p1n?=
 =?us-ascii?Q?Y+yfk2IGVhU0F4mcbS/zCI7sy717sph+37MJ57kwfZ8MGEX1gITEwy7/Jg28?=
 =?us-ascii?Q?Z3rQ4RWkPaZGBqC5Sq2hci7oy300NEwH/6q81N49cHfmK1ciczpU/s04dGwd?=
 =?us-ascii?Q?3ZNFkKHYvVuZVvZTflZxi5kqka3spgIMJzwcAfQMy8pE3pJSoXau8LzlIcFi?=
 =?us-ascii?Q?auwsYhDFutMD/5bfZOsU8dlRdaspXkB40wBEsJ1+zasl1e6jwLtrZNkIAlTq?=
 =?us-ascii?Q?z/XkGiPmx11Yy2qHC2Y/8GFk0bBQu18F1+ZCkVrXIXb68s4l2VOVM+GYZH/9?=
 =?us-ascii?Q?LA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: mkU5BwMg6g+cPeDxKMQbQxvJlGBJCjJyAPsZkahUGORILaQBIs9GAp6euYgl/X3PJLucRLM58P+t89mUSXOBOZ7Yd0BxKUeW4Mkr+2gUHxjM31yLaglQ+pTEN37qbnPT0yUav9FZ8lDYmbDuYYIJCsKSv6B0m3G9DIwirbWL8xaCPLSSEyw7Q32dloztYO+GMQsaWx5FCQV8YTcf2nhNOcTnEhg+7hTRH0ERY2EbzHAEtMTRLtszVEFXCwSLe70xVlu/gKTbr4noOcoKlFCkBT84CdDhmCNnB+mkKDr/wZaDx1qiX16UoeqQUNCESGE5fR8Tvpdz2qN05xTHgpQvPgfe+aSMICkQGSQgqivc3oJhRWNISTYZTgDgDPYwCzcv+6+FShIBWs7s/WYEcTOmulGmkDieEade8dr1K9SRu5JBg7dRyzx2MKeeiZ1Oy3FukUy/jV5gcrtho2hwL3rwcOC0oKCODyXcW13dXAFfqj1du9IbpbgCI2nzOZd6njGqiJ+E0XmQMXfMHDvLdnv1112SSYiTUfHEYlGOFHRuqA3N2Ehy2pmeu6uj31mXPjch5Zw0S8KqSGXGuGCJR9zzaG64x72Nw6CynNgFILRsrCoI08RDZ/uVkGsJFkHgkIV+vqCxTfxYop19FWRoQ0yFl1d3f6Xr9e4VMcae9r157WY2pFYlo2/xAFc12oQrkFrgB994MTrSygiGbi3Yn5bTPVoIFUFC8jlg1GUtaRSvFSkGkrmV+hi3IyoM0kg/SqTdDrlF2FesHUCpAZ7Tbml8s0i1l5aOS4nec6tn2ShiKBcjRVD3Q/w6nDjDY4RjI3GX/IDyUa5tW2+IR2+M+GtKbjMOwDc6M3tHoWK5hFr/0ohQubnTg8B4jBAxsuWc4tR1
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 803c1d3e-ee7d-4039-2be5-08dad34a8c21
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 03:17:17.2742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fBIjHvU11mg7aFjGxGmW7wjYywoR9pQOylt72riJNlOAr8O1UGWlq/+C5LbZGPGz/phbykMbFCLuYGA7evNLL38uTfKp9UdDqk/HPUpl0TM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4347
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_02,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=632
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212010018
X-Proofpoint-ORIG-GUID: -l4K3z3LGsv_iIcV8jYcSEU0Ql2EO2L2
X-Proofpoint-GUID: -l4K3z3LGsv_iIcV8jYcSEU0Ql2EO2L2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Johannes,

> Add tracepoints to the SCSI zone append emulation, in order to trace
> the zone start to write-pointer aligned LBA translation and the
> corresponding completion.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
