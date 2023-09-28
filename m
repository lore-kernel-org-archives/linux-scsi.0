Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5919DE810D5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Sep 2023 02:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjI1Cbl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 22:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjI1Cbj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 22:31:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DFE126;
        Wed, 27 Sep 2023 19:31:37 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38RL7TLa005173;
        Thu, 28 Sep 2023 02:31:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=RKrYlT3H+2ZLBqJSkC+ga7l0xrXpKGY+hnnUPwV1LUA=;
 b=GBloTcty/mLWnd4xRm0iJYRDoSSPNZ5AWNG7xUbe3eQkSNRCy4b4ELnYFjfQAf7vdf0T
 mtpk/XZkyrPbvMO9lvrD4K//3th8pD7ZyyvslzauZdnurzzirAFWRBp5jCpLWGq9Qq9X
 mjaLBl9SkGP5DkzkMboHWjqSR4hXOzIweD8ZYg+Q9Y18zDKr4WJu0z3BmUy5gq6zCnx7
 l240pFivLMF/nOedhnjr0xOX6Ulda0HLO2N9yJtOnI2WlfRq5d5y9lV69VOohTwSk9lJ
 9CGvDMPPjJk3Cj0Iona03as20OAh4HVeyhy1BS+Yax0lBHEYZKb9qi0SsqzdZjGe5+sg 7g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9pm2b4um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 02:31:37 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38S210kp021222;
        Thu, 28 Sep 2023 02:31:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pf98ang-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 02:31:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hejSBrLhstfpe9G3X0dBwMJsIm4BSRlVaLFsnoCT4lNoINVfIy6Z8EuKHS+c4pB4m192BcP1wWrEdGZgCb3sbfmG49eM7YWZA4wxbIscjoqpFZ/Fh096kpqeK+TrpOZAJR5D0BNXh3dZi3H2EYe/JhxSFjJ9vnMc1cqHvvFXfXcqDH2lpsUYC4IjzwKVUk4GokiLz5F48f/h8IqeK9aRU3jLJpwKVz2C5ex1thJ/UNKTWQSo2i6OUX6vifpsbjNSvMQ11hdgWLeML3JvGbtBWB+Q4AGPyQPUa5o6ayeR0E9wWNYWV3abcemgqW/fUT4hvCdgJX5x6wHM1tFtqudpwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RKrYlT3H+2ZLBqJSkC+ga7l0xrXpKGY+hnnUPwV1LUA=;
 b=SEmE4ibw4aGaesdCz4nIUh3VvL9Kj2EwdsUP6Q0IkNJb+61yUegOIyPkmnhQg8V2YXnvJDY0iCN1VT45T3jQubZKtkV9IYtMf1eWyQXM+mPIcWV7vK08Ad/wwnr0bt81Te7+jDCJket19nEedmS7gfCtAtkLTR/RnQtXuVOz3q4yH38u6XINYIA/e2EEMyhMODbb9s6QRanm1Thf7FecouQswWjdJ7qOGE6wyT0WSmu9XfFS22eHyurHVl82hyah9AbLrOwqzUWYDsQrBRIH8P4jnAyDY26PF2XLhg63kyF+aIx0s4Xhz6gPvnNuB23aSyjCirxKOotw1IqwXuAwyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKrYlT3H+2ZLBqJSkC+ga7l0xrXpKGY+hnnUPwV1LUA=;
 b=h7fyco9GePvT2NFRTwM1VQFkkMeuLxy0P8uYKrG90ZEPhX1tQNvsxt28wj0Ha7bHFCnx7MdGLrnMr8Lb10dviPYxzci1AOZbDcyDTro/jLVtTvmmMlxAzjzvpB+TDALz4J8enFdndVGD4YGXL9M60lI7RAh1DOiBkBT2bf6oNBQ=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB6548.namprd10.prod.outlook.com (2603:10b6:806:2ab::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.25; Thu, 28 Sep
 2023 02:31:34 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%6]) with mapi id 15.20.6813.017; Thu, 28 Sep 2023
 02:31:34 +0000
Message-ID: <1b1f7a5c-0988-45f9-b103-dfed2c0405b1@oracle.com>
Date:   Wed, 27 Sep 2023 21:31:32 -0500
User-Agent: Mozilla Thunderbird
Subject: [PATCH v2 0/8] scsi: target: Allow userspace to config cmd submission
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20230928020907.5730-1-michael.christie@oracle.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230928020907.5730-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0308.namprd03.prod.outlook.com
 (2603:10b6:8:2b::31) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB6548:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cd28899-c5ec-4a86-e120-08dbbfcb083b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gc3FlBQ6jZIVy/acHybGwEhq6//uv5UFiTXmnkojrQtd7vL4TzAIK0E3/CpDQZgSyB0Wn/6zhGPNofAAhQB4wLEm7n29+eZJsYwdViFbsNKG5mNxokfu3q0I0Ju4G8Pe5QoH/DSFCH09xBJ7EgPYliTyueeC4VauMgk+CHMZ83cATb5tXwdY1nvPPJheopcxxZEqHf3A8x9xdOQvOMbGXBevLxBLJs9Xsy6oEJopKisDgEg7WFKZag9mAxH/CAQUDzw2PL9z7RlFuLHzsiCWsSfwDw3gZHwG15W5wHxfsw7n1vPRfxa8GF+TknctykL5JVLokwOSOoLNJUbsCJtX+9WlcV7H6XpMD7iikm42H7D/Fc5OuOChMgdpdKdASn3nedEAXw54etFO5LclUhe6RyzZldjbkV075RjSM+55UkrfOrsquhJBWwgEFks4kG02GdRo0LY79HSjfW9ECPBOnhUtHmv8HiTQ1OUHFsZFwnmjegqQORVvSdYCSNgdszSyMwSi5uxp1yoJEerK1zqkOyI4gCsnvD7UI7pbWWjUswClEBfjfn9Fd102b1HlOIX8c7XmjH+qTj8W8gAmD7so6qJ+pPjn0HN1AxYbvdfMC7ZLuyTGVGPy6sg0NGpjwlhJVgdyG2rvTDodwn/Bj26oyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(366004)(39860400002)(346002)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(6512007)(6506007)(83380400001)(86362001)(31696002)(38100700002)(36756003)(2616005)(26005)(2906002)(41300700001)(31686004)(8676002)(8936002)(450100002)(316002)(66476007)(66556008)(66946007)(478600001)(6486002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0hVNitaVnltazEvdGo3MEg1V1BkNEFSMzdYR0ljbk8wcVIwR3l3S0wxamYw?=
 =?utf-8?B?NmR5WE1kazRLMzJZQTl2STRsSitjdUN1b2RmcVpXMG1mTlJ0YnVyOUpxTkVH?=
 =?utf-8?B?VWx2OGs1QVdBYzZEQmVDU2FtTzQ0V3V4TnFWRmRLcUN5d2tBNFNEd0EvNUt4?=
 =?utf-8?B?UlNKbWp5TkJ6M0VKbmJOQU5xSmxKVVZUNTV5SnJFdXBVY0FqdzNMTVQzSnQx?=
 =?utf-8?B?TmJxRXNMMTE0OVpRK240WFdoaFlUZWxHbnRZTnJBVS9pSlErVlB2YS93Z3pZ?=
 =?utf-8?B?d1cwZjZyOWhNVHdnNlg2eDVTbGFCSXdSd0UyQW5iVjYxQ1dKNTRPb0RGcTVi?=
 =?utf-8?B?Y2MvM3g3eFYramNjTVp2VE0wWFYrVGl3Z2ZWdWJ4aW1ZRnBhanEydmhxT3dI?=
 =?utf-8?B?K096YVRBNGYzTnpIbnFWaVZLdms3aDVDQ29OOHE4TTBVY3hsK1hvd2JpbGpm?=
 =?utf-8?B?Snd1TnVFOXh2citpNFFhSzh5WU9Wc1ZZOEhsSXBPNjRyYzcvTEM2b010dlhV?=
 =?utf-8?B?QU1kTEVjb2tUNWh3VUpXUnhZTThhandLTlpob0ZraTh6RUU5N1dCSE82ZHhu?=
 =?utf-8?B?STc0eVlEeFlkV3lJYmlPQndQbHM1S1lPZGdFNHlucTluY1RqTTR0OEZRdmVV?=
 =?utf-8?B?SjdETVFZYWZsQ2xPWlNHc0lQOEoxdkVYNnJEc1NyWS9OVGM3dVg0N3hjKzJP?=
 =?utf-8?B?ZTVFL3lMeWFhQ3JweG8xZUMrTzM2OFY2dUpmbjFsSEcvU09obnhyNE1OUmdL?=
 =?utf-8?B?bndadTFPQXRNS0krYXNhT0liOW1qVkp1TS8vOGRiai9TZC9veEpFam1XOXoy?=
 =?utf-8?B?b2hxRExlQ253TFhGSmdXZEhqOXQvaUllMFpwUnZzZUMvRDlKTkYxMmQyaFRX?=
 =?utf-8?B?aWJZZjVxQm01OGVCNWk3T3dhNDF2aDBMeWo1OGtzYTRIdEJnNG5ycUduTFFY?=
 =?utf-8?B?K2dKd3crYXk0TkJRR2JyUldrM1RRMGlNWjg4VXFib3lDTTRFSStJcmhTNUl4?=
 =?utf-8?B?V2IwSHdaaVBCSmorRitiYy9PRWNsU09rSDVuNWh1b25tK3RwR3kvMzZxMDFI?=
 =?utf-8?B?M0VaWTJZSVNXOFlLNWcvbUpFWEZkY1lVR1JDbmtaMmZld3M4bEtpTUxVQStm?=
 =?utf-8?B?NWkzSEErVFRqK0p5L1hXdVlKT0YxYVRPWlkvWS9acXNCWE1CZDZRL1NjZ0Mw?=
 =?utf-8?B?TWxYVHdXeUlqc3grVWVuTUp5RWhUOG1mSEIwTEZkQi8wV1hNc0RVb2dQRmFl?=
 =?utf-8?B?UUcvbHlzSjF0dEhtQ0NoT3dOMW5rYmJLSEhQTVJISU1oOVB6THhLTUxjbW8x?=
 =?utf-8?B?UVpJcTFrUFNFWmliTkZYQkNxQlNiSUJUZUJCWVZtQTA2VEJia2U0aDVqdkRU?=
 =?utf-8?B?S2h2ZmZjU05oaG15dHVuS0doWFFZNjlDTHI0dFRZc2d3Z0szUFk1bVcvdk1l?=
 =?utf-8?B?T1FSZTBDK0J1UnFBcVN2SkVsbHNjY2dvMjZyVzZWOEJBczBWRmdjV3RudHda?=
 =?utf-8?B?SksrUUVpN2VNVGpEV2ExdFAwQWZ4K3YxZk1nbUJDVHcxcWF3cXU3WDJJMkxO?=
 =?utf-8?B?K2VvSWNGK04ycXhQd2I1WVZwSUc0UGZuNGdrNmsrdDZXcTkxY1JhOG5RdW1x?=
 =?utf-8?B?S1FyTEFZSjZ6ZVNpUFZ0c21tVUVDSkFmVG9CTEhsVUNMVUx0ejFkZkpwTU1X?=
 =?utf-8?B?eGVqa0h5Rml1N3VjdjlhUWxsMzR5Z1RySnZKcGFUVjhpNGcwd1d6M0NFUUhi?=
 =?utf-8?B?LzNTRUZTNjZvaGgvVnMrOUt6QldJblFWcnJHOVR4TTFNamRxcXFweU5GcFcy?=
 =?utf-8?B?S1Y3WHRuc0pueHN5eG5FUzlwcjBwZUl4bStST0lGbHZhOVR5bTNaVUZZNXEy?=
 =?utf-8?B?ZkF0dkNYSzNUQy92T0ZhTStyUnF3dlBHbEh6RW5UQzcvWkRLc2FVQ25hMTQx?=
 =?utf-8?B?dEY1dHdBTE5PcGxTK0ErOXBSM2hxU0x5T0FXSDlPKy9hYWk2ekNEMENvVnFZ?=
 =?utf-8?B?Q2dCenpXeXpKaCtxSy9XeDFORFg0MHlSNVBJUGhPbnJaOW1CRkpWUnd0Wm5j?=
 =?utf-8?B?M0ZNaEk3WHhhMkdnUUg2Rll0ODN6Y2IvOVdySFdDSGhsVWZ0YTFMclNZc3RE?=
 =?utf-8?B?d0hGMGRtMkowM1U5TXJxOFZmQjRudUx5am02bUdZVnN4WEJvUWpzSHlTVi9n?=
 =?utf-8?B?Nnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jFT3d64kmoQtT3r9yoszZn2O/fvBc5hdLik3Ta46o94bJpqO1qvwK6FtK+We3kj+bqd3vzD1WGQerbVW6oyBHKSFkiLulym3tTQM9qsH0ghQ5Xc8bZqLhx6FhbAz6+NQrpMSZwFysaTB8Qg/Q68rOPoMvqlem6oV5qwyqKPuCXwZo93Uu6jXDZi7aD1mj2mD+K/p9ZIRuLmAI2iyTUqt4JGSPe4x3sG/bHhyx+2rh2g0+7rVDL4/Kci9DEDDxsCcXooiVkUIxCx/BhCcApPZDQQ9uVANT1ktK3ZqL0WH4Nq5OjvtodgAhmlgBmdr9GDDQ599+3hx7kpOcs6lD/eJxyk+F0e7phE+3W9VEiMA9XwMhi2BwEFxCz1tphiUrOtDpHfo4xDI1fHj9E+PHvByPWGI3JJREWlH8fTPVKGITD7fk+RsIgRhYNOAhSuC2C4IhCaZCaMshp99XInx6x9UCBKxHA0MEyyv3SkwdltSKQbLhx1stmYTQ1U40L33A4iIk8bf1pyN0dl6DsCdr1yerEgcEso49v3qlGJ3u3/O08yzX9SWddOaktoMb7eXmVDoqiZQ5qbv+b/xwRKxX/3KgRxWDumoMFCq6fUEAPk0MhDquoJRFnN/HckYzdGl4qxi1v+V6PUrxTAYJlotRWPMKU0K49Vx3Adj/NBZFEhwK3GK6q56ez8QgPWQ2oSutkzUKXYAuA2PPHzxuZNxGoytGYrueMZzOhwWE6mEEzCkNlK3KpuQKdQBZEV8eZJLYdhb1x9pbyjnQmwTF0Aygf2DTQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cd28899-c5ec-4a86-e120-08dbbfcb083b
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2023 02:31:34.1631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 16v4ocCrlLI4pWRB52GvLb0t8Yn3gMot80+c25iXv1KN1rSjUUBpqFBu2ZpjJcNQHhYOEWgfAhrY8xjJZZHVfDnBbf0afmSHyPmtS9irTtI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6548
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-27_17,2023-09-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309280021
X-Proofpoint-ORIG-GUID: qFnQ-KZpWytUbhY4H2LhTTAKqEIN1scZ
X-Proofpoint-GUID: qFnQ-KZpWytUbhY4H2LhTTAKqEIN1scZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Linus's tree but apply over Martin's
branches. They allow userspace to configure how fabric drivers submit cmds
to backend drivers.

Right now loop and vhost use a worker thread, and the other drivers submit
from the contexts they receive/process the cmd from. For multiple LUN
cases where the target can queue more cmds than the backend can handle
then deferring to a worker thread is safest because the backend driver can
block when doing things like waiting for a free request/tag. Deferring also
helps when the target has to handle transport level requests from the
recv context.

For cases where the backend devices can queue everything the target sends,
then there is no need to defer to a workqueue and you can see a perf boost of
up to 26% for small IO workloads. For a nvme device and vhost-scsi I can
see with 4K IOs:

fio jobs        1       2       4       8       10
--------------------------------------------------
workqueue
submit           94K     190K    394K    770K    890K

direct
submit          128K    252K    488K    950K    -



v2:
- Use sysfs_emit.
- Add iSCSI target support so now all targets are supported.
