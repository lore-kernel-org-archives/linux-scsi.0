Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79CECC47095
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 01:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54FB960FE4
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 01:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhFHBvH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 21:51:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40776 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbhFHBvH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 21:51:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1581jRJt135185;
        Tue, 8 Jun 2021 01:49:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=f2X2xm6izihk5fpoKU0veMqm0GDlMdnfaXErXFlNOYs=;
 b=G3bX4xLH7rbVJwGjx53E3irqLgXeke3vC230ozcVvzSvbL8kjdw+6e/ywXxx2NyunsAF
 6vaijoLB2Ro2BVbh7/6rU3APGgkExHgeGPpvaOoHSoryyXImp9p/qzOKxoxJpd/dEmCE
 fEJWVmsGLw7/IxgFeVGJvgHC0T8wuS7Fp/5Wa1Pz53EK27qWEcxAZX49ZjhsKEYwLEQd
 S925CBGhQeuiuMudksLxHZTbpss43TBVGFaT6Jomp6QVWHNGYrnPeAT0549y4AIz3E8V
 p+VtxPlftZMLI4DZsndEcComIETj+R6WKVXib0GhQ/9mbdGmbBAeGuXv5ll0Mwp+TKyD fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3914quk0j4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 01:49:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1581kTFB196444;
        Tue, 8 Jun 2021 01:49:01 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2040.outbound.protection.outlook.com [104.47.73.40])
        by aserp3020.oracle.com with ESMTP id 391ujwdevd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 01:49:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UNE3z2hiKJXuboX6D70hT6eeEmp1Xbc2xtTfBKsNqXgYsko2Bp24ai5+j68sR+QKTCbPeKjMrB5LDh32BuTTYhtF43eUcHg5t50UQUKG+8r0UNEehz6rJq2XS+6z63D5eXbHdvZYB7Ofh6hbIWp0YqTE1+Ej74X4ispsvIoh4dujohp51mH/ZeRhbdxyva0i9HKLMQkA21Hh+V+i4eMb0Ip+0ECeiclvi3lvw6G/xKqCMXJHxlbl0/0D5KCgBMKVQEJHo9JPpjI6Lda83cOzYFA86wDCkkko6vH+F3mGOYrsAaSk3AMyDak9jtc3m9wYT2ehPo2qBmX/zfGlUMVMpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2X2xm6izihk5fpoKU0veMqm0GDlMdnfaXErXFlNOYs=;
 b=Lm12TYpXdO/J3N91291FnXoh0sJdBkBTXG23f5qBHWJHc0C43BRsLiE6F3zm70vAen+wM9ap3YdDhvsaZrfc0Rms+2MGlIB/YhJPIO4UNqpbHB7RVT6dO6CDmyJp0SDoz+sxZK3ny9X+mVWWvVrBNddHW4kpSSIwBBRk0KWkywzGAl459ZSCovXgUBKqVQD0MCaBsCU9xZ/a7oLo9/buYBKsNOJVJAnT2CMAUnsZ5gGf3oZWSg26YRbbz++wLcR8XMRNGnfCDTJ6kvf6Sid9JjzGrlZVuEYc3KnK8BE7fICDno3I3hexymREqxjdPj2vBsEQAlp3ybZFRVYf1IfhgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2X2xm6izihk5fpoKU0veMqm0GDlMdnfaXErXFlNOYs=;
 b=zQs0w+F6FmHgxgsi5FnMpcNjH7VXPS7zV7Cah0NDUkO2CrEMi5vHtAawtMfXHECwG0ZeFpPXwOYeTjy9V2otWkqGf9nEJ5eeqs3SZ4AqAJG1jjgLjoQOdMHlEJNN3Ra9LF8ky8yvRk0mgTzwwejcZeNNpJmHFogZ5N5jlJKjC5M=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5419.namprd10.prod.outlook.com (2603:10b6:510:d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 01:48:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 01:48:58 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        Martin Wilck <mwilck@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Pittman <jpittman@redhat.com>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_dh_alua: signedness bug in alua_rtpg()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r9dktxb.fsf@ca-mkp.ca.oracle.com>
References: <YLjMEAFNxOas1mIp@mwanda>
Date:   Mon, 07 Jun 2021 21:48:55 -0400
In-Reply-To: <YLjMEAFNxOas1mIp@mwanda> (Dan Carpenter's message of "Thu, 3 Jun
        2021 15:33:20 +0300")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR10CA0017.namprd10.prod.outlook.com
 (2603:10b6:806:a7::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR10CA0017.namprd10.prod.outlook.com (2603:10b6:806:a7::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Tue, 8 Jun 2021 01:48:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 946dc1b4-4f56-4d68-5992-08d92a1f9519
X-MS-TrafficTypeDiagnostic: PH0PR10MB5419:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5419C5B2B0C9E1351467FF178E379@PH0PR10MB5419.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/zpBfyCNYKBPHJFXprtQmZrbUNSVN+yy25y9mCbxPUbOZ70rGdscAqwrEV+FUzzMFJYlGsj1NGgOveXCcKkrF1tLx5dRVOOkDX9WqJ9UUIaIlgEqin++ufQ7GfIysd6JXabEhrjK48ytvJrmliaBR8qtflZGRh9bdtK/osz4qAYKoUBXvO/mnDsiayhdyKd/FboEfaKD5/t+9noQw1tz8i0ARIzgK2jTaX6GlpGQYGaPqJIrhAtBqLc6HFfzc5fByHMp+pof4DLMpoLWliCPvMf6V26W6QMHwHqvwWW1I+WyF1xZsXIfv6/1jDjXvShKIJPRMSdv0ygcytlcv361yuq5ixrMu3qpaWlo4sAkRbZBV/0up1QNajHuaR6F4bLIAVD2vIMlJF8mYwwKnX55qLoDuEKJuUWDqzhrulaBVeL2MJtGXgFxVwaKUGqo6eWfvDWQDkRpsQRk0FjRPw8HishUHvNDUJnzK5eR196xBs1iHCRZrTRJuahroZeMjBv5rLbhsGB2PPUAT1A4eUmm4PSpzZzYe8n0/Lo8D6XOA3HAzM7IlHKH30tbt8XDbOwLBY8hdiStMrHDj8+mZHdeoV72jcWSZZ6KoWe8lcdQBD1jHs6KY1ETpRVvlGCYZnNT5XiUgHWpYeeo98+DTi/oW0opu4Ldh/5afY0bQO+YdE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(366004)(396003)(346002)(6862004)(558084003)(478600001)(55016002)(4326008)(66946007)(5660300002)(66476007)(26005)(66556008)(6636002)(38100700002)(2906002)(8936002)(316002)(36916002)(8676002)(52116002)(86362001)(38350700002)(54906003)(7696005)(956004)(16526019)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+UDI24qgO5UKHQiA3+EcasO7mXo1U+IhBioMQWOy6WFOgrvBUNJCvnuDfhks?=
 =?us-ascii?Q?Uv8xcDuDdJsKc23/3OeXE/Gw3EpJlqENbKD5XCwZZBCUiqOdwe+R1qBW7jY8?=
 =?us-ascii?Q?w2ghsPcmclB51D3t1hYPjnIBXotg+zkeocRd1TDwbwPI3ddCqusuaByhdURr?=
 =?us-ascii?Q?M8OQRQ//+dSg17ggfR/xENHEeob1nNuieje2wg4Gs87voRxJY/sjhMZPcrSM?=
 =?us-ascii?Q?pkfpCVQi+2+xq5lDdYqbs4iBmFQfH3k7/UQbIWbBpuU2A6DoB5w85WDiAQvV?=
 =?us-ascii?Q?u5M7ecrbr4P39kqaCOfk1hnqRz6Cmxn/X12os6/yo1C1a4AhmHBDYayBGiH0?=
 =?us-ascii?Q?DQl3XcP7BX9lD13ncAqBxu5F/xblhyRELhRyINa4e5vsSDbCWUa2SqwbkMpi?=
 =?us-ascii?Q?Ctd4jMxPN+e4bjkR1nd6b9i5h8brKu6KHwAynTuWUFWajEVHg7ECNd6bEGej?=
 =?us-ascii?Q?W+iLmLszVYSG7VD7/yDThr9KMPY7PDrmRUnf9Zbd001aZAG/l+le8l9LFkIN?=
 =?us-ascii?Q?4ZlzIbLVPolTw8MiVvcs/4bpJLGE97zu4Rf3Mb9D3qeHnAaAjGPhoXfVPxIr?=
 =?us-ascii?Q?g6e86C+CRqeiVVNO5oW7SYXI327Q6qOm2afThShvfTOur2G3ah9TWkwANq98?=
 =?us-ascii?Q?vljbpygIxpAMwJibpn8A/FCBRA3MyLyTUCPibd0yS+49E/G75uPiXUsZIqOb?=
 =?us-ascii?Q?eqKMu7gn6n86zXH2zkgVSPRKuy33Z8hhD0wzuKBVlax3L7QUAq9uys3eJSxx?=
 =?us-ascii?Q?owPmaPZmkAUtynJaHAJD/VI0aOlBWpiJA+msCg8a8vPinkcwgilOiEHOIPm0?=
 =?us-ascii?Q?HULP/t34LHj7KGNqIjCXJ7qlsNxomrI3YCp/9Uec4gZXYIWBGmP6Q8EfsngR?=
 =?us-ascii?Q?Z9Cvk3iBQqHQEAKxhPYV1YhLT1t47NWouopiSRtKlh1FX1Ob3V1rgdDgAvM+?=
 =?us-ascii?Q?/SCTKuspY16H5GaczOSD1mWGxV6fiBO3QkrgUYyy5ru68Y++Ll2zOhvdsVck?=
 =?us-ascii?Q?/miQQ0zz+LyVfwXki4Pp/QW4EgfanTApDxcm5rw1aWJJ67Zzh8gjkInEnanN?=
 =?us-ascii?Q?Un8HclbBU2syHNwZXLwpIrjFT/o3Mu/lYV82WdP+z2mWlPrti6NDqaYFdaaS?=
 =?us-ascii?Q?Xdl/NoteYMZOA1V8LKTkJuIK9oK41IONaAM+DwY2A52AxOEGaLUWEbr4/wSD?=
 =?us-ascii?Q?TPdjAlDijz8ffoMl82dDNAMLDHKVWTCzpTGU/QVeATZf/i9SqIMRWGOrbLfT?=
 =?us-ascii?Q?PRkuL9dlTnXLjAO/V38afoihwU6xcnbPiK0JN1rofChvyL6EUZboZskMVpMD?=
 =?us-ascii?Q?E/fskyC+1dQCFxN1+ySS1Cya?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 946dc1b4-4f56-4d68-5992-08d92a1f9519
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 01:48:58.5107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /lBS/lMALmmYPcOwVoOLuvA9M5PKKZPuQhVdNYciQtqUpyBoOJNjfl4fokKd+3axddcy631oVkyrQi9w7i3fp0tg+BhXnIZxiCoLQmqn6JA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5419
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=923 spamscore=0
 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080009
X-Proofpoint-ORIG-GUID: 6WgJIVS7KZEI7dlss3grc-UkNw7rB1Se
X-Proofpoint-GUID: 6WgJIVS7KZEI7dlss3grc-UkNw7rB1Se
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1011 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080009
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> The "retval" variable needs to be signed for the error handling to work.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
