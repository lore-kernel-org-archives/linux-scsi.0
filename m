Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B13A4C04FF3
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 20:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 669696135A
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 20:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbhEUUdK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 16:33:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48406 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhEUUdJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2021 16:33:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LKTIEU141669;
        Fri, 21 May 2021 20:31:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=2Q28d2DtnUAnTHn/ZrK3HNC2O/EQz/KNJ1lTANonAk8=;
 b=sHf/umC73rzJuxLwzDnJlVMb86y4z/WoG+BbRPbvBNUrR5+ZhFEHBHxg7E+99s5cY5tR
 OXWf44xwdwtdaLKJBSQCbTITOudIwXqrwiofH70Ln85r3hi4pPIY5xiJ0G717HXbaqv8
 02u/cPKpUApYWJSylG7+yxkw8FiQNAuZU1Q8laV8vR417EsE/fQSkSYx/rgjM+KO4XJb
 w6ZlfQTVUecCqxau6sMZE/gmRhjtjFamg0bFS3g9xcUoURMobzMVP+1z+5YN2875yxJQ
 cOFL5FWhgF3d8oSH3L5t5+VOmtTxrHIWefZKErqb+oIBgIYrqP83p5a0sThHjjovNzbS 5A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 38j6xnrmks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 20:31:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LKQZ5t016388;
        Fri, 21 May 2021 20:31:39 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3030.oracle.com with ESMTP id 38megnw0uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 20:31:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BrXFnVKd/di+DItZPbvlAX25k9Vg2oX5ijSZahelYr13/mRvlas7yomliJZxOV9AbAlHCBvNXc8+BZ42C9FPLz04Q/Z5hXyCmH4W4qxrW2f++Hs+x1f+RlW6+4sa6v1yv/SkPcg+Ms0Bbq+VxieXwHKCR7FVwy1eqxOEy0e6Dbm2/jsSc2qejxJAeB2IlJYrL3fPv2MgZQpvxOd+XOVJKEsJ0cTJpDqsdHuUVteAfH69dhs4CrIgiWTv7bd1jPPIjaK0vfjMWOZtFWpyQxDBnBeKYa8q+oDYu9MOM9pyOZLH+tqsaFldsuVt6TBc8YnnMwDpwimRpFUuOLDa2t1fog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Q28d2DtnUAnTHn/ZrK3HNC2O/EQz/KNJ1lTANonAk8=;
 b=AIEf9GYsp1SlR/6Fesf2kwdPhHAtTq4INf/bc2vviLtLRD55pbYvs0gjywBc468BHDVlE7VVehsCFsiSSBcT1BVX6wU8WaFLo+5Ymx3EOEa7vx2k5coDZk0rLesKWIwPMp4aY6yYURL5+b1nIunc1dGF4Cn5M61ddqaHdLfAqprRu3OeYuXXup2avEdVAwvgGN8Oh+lTikQ54LT6n/qravTcSIKaRkmyOpaql7m3WgESsgQlU8oXvWX9yH6qFaAAaLWIPfSoOhw3DzlEcaq2uxRwmf8Ahg1HylB91M6VcOw3mr6d5SC2V1lavzPdVwLJ6/0VmYaL6nzJfev+8TaXVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Q28d2DtnUAnTHn/ZrK3HNC2O/EQz/KNJ1lTANonAk8=;
 b=GyA57VGRJD2nKIj3wNF0aDmW9fsjWsPVwlAZZCRnoZJaNE74hx/UC8ihgvwh8pxRz/mAmdE3ONi5AIg8wIsRQUSn5lXP6Qyiatx/E6Ob6Iag1cJfbp9aTNYDSoUPN8+x+qVw716cWnvZAh60dRKO5hlnEmBLCJwXnwWhBB8L7tg=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4662.namprd10.prod.outlook.com (2603:10b6:510:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Fri, 21 May
 2021 20:31:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 20:31:37 +0000
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <skashyap@marvell.com>
Subject: Re: [PATCH -next] scsi: qedf: use vzalloc() instead of
 vmalloc()/memset(0)
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eedz4yn4.fsf@ca-mkp.ca.oracle.com>
References: <20210518132018.1312995-1-yangyingliang@huawei.com>
Date:   Fri, 21 May 2021 16:31:33 -0400
In-Reply-To: <20210518132018.1312995-1-yangyingliang@huawei.com> (Yang
        Yingliang's message of "Tue, 18 May 2021 21:20:18 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:806:20::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR03CA0019.namprd03.prod.outlook.com (2603:10b6:806:20::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 20:31:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e282470e-d62a-4104-ed4f-08d91c976e9f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4662:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4662D7650A1F212C9F2410388E299@PH0PR10MB4662.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CBph4DRUvaiDT4+1jE6c1X979wRDQD+sBfTx1QObeJM04EonQKID7QZedJFr9+VlNbP4m2uMc5I7d2H472xVS0oiZPCnuwecT++3Qb+I4fIoJAf7XWSYCLrFrN5Z+BIN7rkLlFQGF7saaxVpJ8if3OSCXRoLycQPcEpbwC3LVgm2lMKmx5i/I7o3WQMpB3FEldVlPPYQG++hrO/hIaPNCIYfWh/r52kIrdaRXNnsg3/3RXQQ/XIjewUbjbXGKS090nRSdSiZJeEzVpWv/shuDY3tyREQWEnbSUxJZtQYdPgv+nNnay9G9BaXiC8wZNfxfCvyS79E3CQuqoLKcXXpDR84nnAcFLltxAISlCivb1O/BDdaB8StyiuTGlcVdkOP4M8XrWnk0P58q7oIosSJnEoSHYQ4MLB9Hgh92nRyLWYA69uMo+65ib85hkeToVqRmXg2RXguG3RIR4NIp09bX7nk1g7TgNGJWOUbkW1LAK5uHNgUTCYjaA9kwhzftk7UzGTtutCVFATxRDzHO9gYiwE2Di2V7h2g6OqV/l27Z1aRRoxkWB2nNsNAS+h7XRKsrPWMWD4PcS+3Db9fbeffa0Jzc2jrADLKNLer0HaNbkaFfxxa+T3iVCx//RUEsTN8CCCVlMWyI6ucO8X5pG8LIGNjPaRKJqy4wruF53dCrKI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(136003)(346002)(376002)(66556008)(66476007)(7696005)(38350700002)(36916002)(26005)(66946007)(55016002)(86362001)(2906002)(8936002)(5660300002)(38100700002)(956004)(52116002)(4326008)(6916009)(6666004)(316002)(8676002)(478600001)(558084003)(186003)(54906003)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YDSFQaPKCtbA8/cRKM0pebdTFkB1qvAJF9tt8oBoTwN8i1UdUX7KyvpbYDRP?=
 =?us-ascii?Q?RCC6iH+IbA/g48jxCAHZfsBcZR3TjuTWdjQ77DwnoT3Qei/CAEF/dFl1RIx4?=
 =?us-ascii?Q?F8922Dtek/V4jvu8pRWcqxhlD+7Jffnl+jdeGlhKZYKz63+2MDFVCCQDz3yM?=
 =?us-ascii?Q?SlABe9FUOmiK2u5oLX/aNjKH1rj3GM0qccEZqs6+IiEusjGbCt40hVY7qXpP?=
 =?us-ascii?Q?DL7KJfkEk9smsgXd9KyEINEGdlTjb+JhNueYHwHFFWNpGrPTVbQL/6fFPhmT?=
 =?us-ascii?Q?Ye944fthJ5rLr1kUefHRs3Rk+Wds/Ojv2B7h44Ou5XBBQSCxedHdrMg0l67V?=
 =?us-ascii?Q?+4bclQqL7v4GDLqEBC4mqXJhEHDmycCUn8t0HM2e11mkBUgwnqlm/IZ8kVLT?=
 =?us-ascii?Q?ZTQ5uRHEiGYSh3JnTt2qNmw0q26+knImxNaZ2TJgnbStvT362X0O0c658FCe?=
 =?us-ascii?Q?i9x32Otx0ZLl7gmJLVW0Meo7Gu6kc9mh1FtKWI2QJu9m7PRq+TbqCaIywgOz?=
 =?us-ascii?Q?M0ZCSgUG75g2kVJdMbr1Aic/fQUEpFKewzvj5BYfI5/snI5PtG+0CvQEnowq?=
 =?us-ascii?Q?nR7PSNAk2kst/g/2oItavCXwOVOH+OjOfNmRh2UA8g0H+YsdXMxcvGc3ygKB?=
 =?us-ascii?Q?BPPhEeC7/Cqhzo+pJPwbUaSPlaD7e/4f5xfDM/08DNngtJSgRm2zV4FQazKI?=
 =?us-ascii?Q?cg8C9+ZIy2Fo214V2pjuhvNQHt5q2nzgRcxYa6E9eGU6RxHOf/jVOrE2cxij?=
 =?us-ascii?Q?hLo+aXA2lN7dVi7RhwZcN+DZnaoEul6ykqrdJVgN24mypspTQGPcM4e+bB7H?=
 =?us-ascii?Q?X4TUBGba6IM0yfe8KcCnJtKwCbCTQBnMNlDgREqAP8MWAVLx1IF4D2P+E5pr?=
 =?us-ascii?Q?uIKf4SVJsQzgqyHKgCORwPNqps2Whv/PSD7bb6efi/9xohBWMVP/3QTGhN4x?=
 =?us-ascii?Q?iDSmEA3fzxnmAhqTA3pM7BefkgPy5iO+s4VIzt5z1/uk2CF3O3nqKKot5jjf?=
 =?us-ascii?Q?E6Vd5KFSsjZDaONweHC6KT7IUpiZ4dehOKdSGF5lsGxGKlF7egPOLGVPCw+h?=
 =?us-ascii?Q?vOXqaK503AdIknzDzYUmN5M0JioDkRe9tZZxuVgr+9ig+j/GJ0zRtCIxkpY4?=
 =?us-ascii?Q?juOJNPQ2K72da0EzGMPOueiJDUN3krYATQseWQee7aZKyUnC3TYKmmp4jdEc?=
 =?us-ascii?Q?fKVbAwn8mkpx3cq0ihqlKZklVKbPMrysTR1fpMkqIyDtMwP+8mrFRRysNGAm?=
 =?us-ascii?Q?TrN9kX8DNmM8TUjYsyLXkRShFARGqO7dLkJkKhfSMid4yGSq4IhQJp1+1/gv?=
 =?us-ascii?Q?X30B1c/ImEc4SJzk1enrpj4S?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e282470e-d62a-4104-ed4f-08d91c976e9f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 20:31:37.2484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KnckaRvKicibrNSCNU+ICSdxoZwcQRPAx7/gigSw8MMR8ejn3ulxiJx8HTRzCGHCFM6cD/UdX26/3DYcRA9bW8tjvbIxU+B2/XuiHr4v20A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4662
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210111
X-Proofpoint-GUID: lt88TusrOc2ikDgBOVNJ08Xi7Z-5xvTx
X-Proofpoint-ORIG-GUID: lt88TusrOc2ikDgBOVNJ08Xi7Z-5xvTx
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Yang,

> Use vzalloc() instead of vmalloc() and memset(0) to simpify the code.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
