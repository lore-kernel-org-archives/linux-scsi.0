Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E2E7C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 17:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAA5960E78
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 17:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhHPRMl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 13:12:41 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:61468 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229723AbhHPRMk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 13:12:40 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GH71gB029304;
        Mon, 16 Aug 2021 17:12:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=k1qYuTfUn9YLE/bLVQph8I3Oo77S1uJeTuFlOEJoicY=;
 b=QAoAphY5XxqCFodqvSrn5OPUtZZE7iC32sBxqlV4pZ7LloEBE0EAE4arG9x2QpxIR7ez
 i/CIjLEcWE3xk9OWt8YdCzqn/H56cL/8HDsZYSO3hho71becwlD8pFJh0n8HoJc0oVpW
 PAaGg1BwqAPLPBWyVhTmLCjVIyGKP8uEsJuF+mqMYWQOKfhYYnFL7e+4Ks0UtCrZkcBh
 zJ92wcDyL+kiiT9fHkSMM1THTtIdAYmZztThZZMvBGBgkXANNPMnA2lV3qKt8XWPRWqe
 K5zVBprv95Iu+kdbhwy4xFO++D3x4JABgt68iR7I1Hysc7HuTch6UdY7cxJus3RpHHT3 UQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=k1qYuTfUn9YLE/bLVQph8I3Oo77S1uJeTuFlOEJoicY=;
 b=UpoMXE+Z6u+RZG6wgiyHOZlXH2ZouY68xUoUeRiopUI5bKdEr/JWJUzqRqihTN6LgCqu
 2ZdK7IfTvT4hezsjbiCoJUhzrJPwxldPRafWIK2J9cqK9AxuTwYlIVShkYrbRbdUSfsG
 6+Yd3xXsvH7wNIzkHtfZTWfYI66Jefr5zdUzku4oWaVFgo8ArHKVhMofxeytZdzSqbmx
 3v0QJycJ2H2Q0n0RzyzIr/BywUqKalOLYzrVtCdZYqvrlG30p+13z0NdqGTitaM6u0n6
 DreLimg9HE1N5X/ug3nSi+Q967ucRTdZw1DhPUuy+UTT+6eb8PFCWugJuYBP7owfO7Wr 2Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3af8302cyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 17:12:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17GHAsIT082482;
        Mon, 16 Aug 2021 17:12:06 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by aserp3030.oracle.com with ESMTP id 3ae3ve4npe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 17:12:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KeYmhMNG96RJp1N3fBJ36dIUQs27B/y0jgjwXuMyMQ0PqN6S86C4PLfRbbcpFTYpVxBi/RSxPW9Iqnx9azsc8aLUUYQHRz2u7FaChEyR8PrHmBBtVWqGxRPTR/UpS41vy2VpdY94XmVLcIyTsv/eTt21J4b8G9eRROjTS4UILKbA6qjV6Tk8t6QrLvAVoK/HDOFZGVe+I0BQxVaqY9DbFQ/pfIXP0VvSGLDPzfFOcfFdILb4gryuMBdwKIOYJiEGobeHuDUhlps8DkgXyOqE/lND5gwzQzVLo8zhR+qsT2mEyRklW/OrvxsJeK7S3owRQbg7il2QeaU24wC+48LimA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1qYuTfUn9YLE/bLVQph8I3Oo77S1uJeTuFlOEJoicY=;
 b=EVUV8mUNH2G4zsVx7Kn1YHBMaQh2KFfyoG/X5Mo8Vf9dUcXsQ0xpxW3kGy2GWMYhGGZDe4/jy6+PNjIfjPVZOq2JgiJYXYT8KJyyfvgtrQjW/jN3FEocp5SA6llN5cmKJzqqmgJ3HIQLIpB8xYtpDipUQGTXcksFpryrrnztk8Qd4McvlMhlrMbGnEbPY8Of2laz3vHVBWyABVcRbs639NurGWxYUhVaximeojyAn4qirUh1p9jcSJzcpeQ1zXebboO4BI3Hvczm8VY2U2hrLOG6vygWAsXLSg1jh/aLkJrDxJvNK6cvxrziaEkYGTm+Zjpda5SF+EvKixvpF1UWlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1qYuTfUn9YLE/bLVQph8I3Oo77S1uJeTuFlOEJoicY=;
 b=Jni7LakAaJ/D2HKS7hGeCy+3h/muH3MJcTXYmjbsx/yje7k6cKm2d6w7GXZpkLi2h8bmNAz7pZGhoARPbk4n72iutLPWKXIPGHyYs+hbaHY02BEdf50DtAcsV2Pqo5YSEUhcCBbdqBjkpp6Cw1eVGSSzZpa5VlCqlKPm7v30+ag=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5562.namprd10.prod.outlook.com (2603:10b6:510:f1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Mon, 16 Aug
 2021 17:12:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 17:12:05 +0000
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v5 0/5] Initial support for multi-actuator HDDs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135r9qpr5.fsf@ca-mkp.ca.oracle.com>
References: <20210812075015.1090959-1-damien.lemoal@wdc.com>
        <a968069d-07df-396e-8ac6-04dfe3ee3040@kernel.dk>
        <yq1r1eyshs3.fsf@ca-mkp.ca.oracle.com>
        <743ace9d-2d10-f903-aa7f-cae3fbd1872f@kernel.dk>
        <DM6PR04MB708184CD5F221364BFCFDF47E7FA9@DM6PR04MB7081.namprd04.prod.outlook.com>
Date:   Mon, 16 Aug 2021 13:12:02 -0400
In-Reply-To: <DM6PR04MB708184CD5F221364BFCFDF47E7FA9@DM6PR04MB7081.namprd04.prod.outlook.com>
        (Damien Le Moal's message of "Fri, 13 Aug 2021 00:30:11 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0165.namprd03.prod.outlook.com
 (2603:10b6:a03:338::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0165.namprd03.prod.outlook.com (2603:10b6:a03:338::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Mon, 16 Aug 2021 17:12:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ddaa463a-dd98-437f-47c5-08d960d8f8b8
X-MS-TrafficTypeDiagnostic: PH0PR10MB5562:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5562107A4546A919490116878EFD9@PH0PR10MB5562.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q9wuYNM8+HK8SiWa7YurS8aurDlecIvxjxAkmOUIXxLIogXDWdnm0TiL/Ujjcn7pHyQESB1EKLxOczyhYL9RrRu1aG5Z4KFThGCZT279xIhJsE5nEGDtfv+n0jmAL5wVRitOs+FG7RMy/CHYLlVfsgxpCxZYq6mMCijSUq2uyZFMVxEkcu8JdqmAdY31zOiYHreNktEdTjYhLoXSd78qGu5gCagrzXDPbj+DjWFaJloLDCodMexEMQUzY0X6PT+G6OTKLrgoCqO1xE9yVSQKhms1QXN7NssA3FsW35yOUYU7QZwY6l6uDPF7/RJQeDq2cCvoaemRdkPfl5YA89HWgMXWKZwjuIfU64S+J4qsr/rQN6t1ObmCEnvyHCf2gpCDIYxWaGr+05PAwrr2kG6HZF+juvpZJwDzQLLumjSL09/JMFrqLgv15V/R/9mTtKlnVj4SFKfmc8Z9icqh4BCWZKj/307ry1n06S0an8QGQs6psz1nPGS0q4cwhdM2o4goum/ZzocIJ1BHRPg9k5QLJ24QkoCvysHi0MV7AKOQthKnNWclb9mIeHPZPKCxcerUlkEtptGsbAzK7WUJ9LLnCQHaemBdYMg/+i02BuHx99H0JDCkJIzww2dAn2YhblcI8RekxVOe2hemSP629aKXLDmdW9WV9DhQS8Yz61Y+MJjpyYIeB0rzLrDwn1n7Qo7R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(346002)(39860400002)(136003)(26005)(66556008)(66476007)(2906002)(558084003)(6916009)(186003)(4326008)(8676002)(66946007)(8936002)(54906003)(55016002)(478600001)(38100700002)(38350700002)(86362001)(52116002)(5660300002)(956004)(316002)(7696005)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8g5jovlrOipcSOJQnplNYTJIbBCE7rRyT5c0zzelMTwCly4luJpso9O8qXUF?=
 =?us-ascii?Q?KgKzTTy6EogE6sOi4Q0tsLA0rKkI/7QDrMtcY9/RcleR4km/gPmXZZOanOu1?=
 =?us-ascii?Q?6cBiIe3S+nV/eWJPlYale9mRXcldXHBICcFn8z0QtPHsc7ZcT7h9J5m1zZfA?=
 =?us-ascii?Q?qIx0ZZnOhbwYhDpqGXE1x7UAGro4osThHe4n+kX17xZDN1sFkH4tJ3ROIB6i?=
 =?us-ascii?Q?b5bjLGTnCf9VPFRTjs5vRJUT4rnn1AeUKwv/t4JB+SFWTVAtIgshYX0fgloz?=
 =?us-ascii?Q?A6l0OoU6knEYx6V4cLGEfWgokXqVfooGLsLXUeljCWyLnwaMV1eUnMAF290F?=
 =?us-ascii?Q?9vuaXRiDf8ZXlV7gYembaCZISb/991DH8/x/7CJRJ4Itj8x8aZGrN2qdraV4?=
 =?us-ascii?Q?tUR6ltSeQE+ZMGcEggQV6NGHGnbJzbT5RKLwEl2UjhNmmzjFAMdxZn+rOtAQ?=
 =?us-ascii?Q?+TpFPq8TARp/AGI+yly6xfbw+0Mnfh37bHstDAkF06ViSiBh7/F33lRnWKtJ?=
 =?us-ascii?Q?gz3yqPDbV2NlnpBNSMBKvUyUuChZu0avY+4JpvuFOwxl3oq4RaTVa/7YjiQ3?=
 =?us-ascii?Q?Oy+PGQu/YGaCwO+gOKTq7f/mPQV2hpGtyohId+DLF/wp2/5jk0BnH0LqhE7w?=
 =?us-ascii?Q?lWPzAwiaxmxTXUasVGwI/9rW7nVfvZJaAXr9PBY0LTtX6oTRrz7S9r2vdMx/?=
 =?us-ascii?Q?dr6Ky5MzLA+mhqq54q0Grtzzy70y5dkzF9cCNUXQTVkSeR0tQQR12BpZ4Eys?=
 =?us-ascii?Q?wxIWh3/Am7Rhe9zm1yydDnHaHZuKHoGrnH+pS6f7h2H71by4uQfJYLd/00xt?=
 =?us-ascii?Q?jGTU/r1M/E3XK6XRV6ZtLLafqwdV8sZizQudB/5+FcDxVxLKru5iwIpCjJhO?=
 =?us-ascii?Q?6kR6m+eseub0IkZHhrFO5k9ruqkb6j/PyPtjAJUOPQYT2fI8UgkLU02Tz6nu?=
 =?us-ascii?Q?JD+8z+G7os7didxoRlgEhqvRmWnRUCjs4bmfHw7pHbegbqB7TY98QgdiVgwu?=
 =?us-ascii?Q?JwWyAWIHyDjK2TLPqFIzmmdBtbPJ7mm1LP+YgYF6jixA4HnZyyALizR8/em0?=
 =?us-ascii?Q?aFxvNs7jzh/aYhvhe8YJqV2afjTgaMf6CpyYSiIa6r8e/ZElSN/GGWUKw5gu?=
 =?us-ascii?Q?8PQKg/+vLZW0L8IVnFxGNyw8r9Im8P3vSgLamxOCNVQK7JJ+bpi5M/xcdLKj?=
 =?us-ascii?Q?7TqPedjdN9ZlUdrsFqaq1y2FFl2y1mkJMuKq/GW1Ew6ew62iU45pMB4DIMG6?=
 =?us-ascii?Q?k4PsRQXmdJecyTFR57o/UGsPXVirLRTFpjJ+WuQyBPeu5yBJ0+c1g53kTaaK?=
 =?us-ascii?Q?JOyb8M6XfL6jDL6l40u226SS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddaa463a-dd98-437f-47c5-08d960d8f8b8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 17:12:05.2620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xGUGmCm6UCadSN+lnM8sxyz/0CG0W2+oQel/bIaxzKVIWg19Ljfmj6RpcuIH49I9mQX5YyVwQ391vIeg8+9BBBg3CSwrCfohq3NFKgv6it4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5562
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=886 spamscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108160109
X-Proofpoint-ORIG-GUID: MDdSUZi3569iKFsc92rNdfHTUtlTRKN2
X-Proofpoint-GUID: MDdSUZi3569iKFsc92rNdfHTUtlTRKN2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> Without patch 1, patch 2 will cause compilation errors
> (disk_alloc_cranges() and disk_register_cranges() will be
> undefined). So may be both patch 1 & 2 should got through the scsi
> tree ?

The sd patch would go into -rc2.

-- 
Martin K. Petersen	Oracle Linux Engineering
