Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E944C43381
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E6EC23B08
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbhAOELy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 23:11:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46348 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbhAOELx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 23:11:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F44e1R144581;
        Fri, 15 Jan 2021 04:10:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=KyC5CO8aKz2BcHfj2PYgW37/akU8hTdGZqPzsSNEQ88=;
 b=n//snox0GjMEcQpi+zDZovnKTx7jwuC33Yb7hRnXXBghoI0cb+BKLm1ZWdaaxUr+7dnv
 KvSZgfgTulb1IyGyZXlpmMQjclwkcivuZY3U8mK7+n0eJUyzXWQZzYOMhDsUTJ1jN/qT
 bnv3NtriYwYLyB9qrDAlWJaSABE739rGdz8EPxjGCBuBrdMToS2OJpH3yqIMJCfz7Pr2
 UM1bjakqwNSpsV9fqhw3NLcWxsPKPWKRX+K+7Nwli2qjqso591oNZAHHpLNl6nA0K1se
 68I1uh7WovGk83tq3s20omk20yNne2SuZkrjVL0LontFrTdwyqLFyr/cbhAdVJhF6FS+ gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 360kvkb6rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:10:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F46fG4095047;
        Fri, 15 Jan 2021 04:08:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 360kfagp82-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mYxWPldOvrtSncUIidwBXRVLDlcYf8rptG/6lXESvsk/GBFHmJ6PQCTSNPpQp1fg5Ok5iSHBvH8RWnN/hK/0QsLAZsJzzBKUYUY4z9bzr6Ndynl8eQGmTUsvBtAVrw9wdUa7X6seR7I6m6LCXQAyZg1H5JmnG+UubIEAkUg/X5vqRl1H7JexvhBV7KD4TCLlen33KceOP4sBcOkEBOdgq36G80FzY7SuUYcNhRAZzSkoqZmzJv/uGMz7EZbm1KLVuTqLOUVCw8rZi/aUUvdZ3/sUgkcZZnm8E8hfksrCzuZyHXSfcoELafYI9iz5tEdbz13x4QSP5iJujA+RNsqHQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KyC5CO8aKz2BcHfj2PYgW37/akU8hTdGZqPzsSNEQ88=;
 b=nwcCZxkdKvzvD4DcTFyfdAublTojUYlv/kcQtM2+WSf98owNPTpjIGvjCHde7pgnN09/sjJKolDoKl4GpvOg1L8lzhr9nDb2I3rF48xQAlL86hKYSbxqJ+7QzMaRWvCN8tL2ns1C1h6Mn5vEA8F27GUkn/ugznDuLFufsmUgAmOsxxKj3r3TTMpE8UcfBSOSpeDEcoEANiRKCX1rD1VUp7DDtblQOQelZYXeRzH+BHfPvx6pNR4ANbeUklTOMXE22928CJht0g/Nrj4K1SCIua0WmPOzKwevWAO1ZjjSa8gUT7fIihJoI0pleBFJjMm6zjBgEP9XE+lz3nv7Oe/wcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KyC5CO8aKz2BcHfj2PYgW37/akU8hTdGZqPzsSNEQ88=;
 b=m3c6eGnYYBY8nVZSxDDXIiWVyWxCg5QCeSda/day/SIeTykhVp9CUrh8l8vdMjYiisiP1HcKaTT7V6iVJH+KriwXAB85l7EIy72PJ3JHrG/UlsZlITsC2gKKnPYRlMbcz3wxr/gbFUCpShEozFSfbo4ZuEPTv3zt82NuBZ1FH7o=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 15 Jan
 2021 04:08:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 04:08:48 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, John Garry <john.garry@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Remove intel-linux-scu@intel.com for INTEL C600 SAS DRIVER
Date:   Thu, 14 Jan 2021 23:08:26 -0500
Message-Id: <161068333185.18181.7686743037769378663.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1610449890-198089-1-git-send-email-john.garry@huawei.com>
References: <1610449890-198089-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN4PR0501CA0139.namprd05.prod.outlook.com
 (2603:10b6:803:2c::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN4PR0501CA0139.namprd05.prod.outlook.com (2603:10b6:803:2c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Fri, 15 Jan 2021 04:08:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 062a934b-3334-4592-d6c9-08d8b90b4265
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4568B2984EE3BDC088A406098EA70@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aJryR5zz5G86Z9YV4y27vVOn5olGY4FwcIycLmR9AxydFFvriWBzwIUYFnsJwwn2HSRH+0a4J9hOi/Y1VAxA7cBAa/cqQ5CCjxtA+i0onP5FiQwBWWj+gaBAi383bS/MTecgPRUN7BmBh81OeNgETMY8g/RqoM5x9R4vjirPtwtBtMSxv8UEAf+TB9knl7yAFf1k1VN4DxBYr99gmTM/uORMeIl0uRzNwM5LrBdTkjffy05m2AbUpX2k9KbWlVgHv2Xri562FPSVCJd+xIcmTWSDrLTpA6hsqp41cs6sYY9ZUDUVlXLEW+2AahcVlQoeP9cBYvy4VALzGiS4jhHuB220SWkze9H1mTOKiRQ22hIAgRnXMp0K3sIer0jKRjvjP+bkwOLyBfz4GQrz6aqX2E1S61MCRml/YY2ig1B4bdY8njBMNzDHereda+gyfe2GikrS7i2Gdg5wVXr1ul8o4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39850400004)(54906003)(36756003)(6666004)(316002)(4326008)(6486002)(8936002)(2906002)(86362001)(7696005)(52116002)(8676002)(103116003)(966005)(26005)(66946007)(4744005)(66556008)(478600001)(66476007)(186003)(5660300002)(16526019)(6916009)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?STZISU94eWpPYUlXcTRoMU1oMnlFYVBMMkpBVUgrN1pMbVVzS1o3aWZpczZG?=
 =?utf-8?B?Z1pMYllhYWpIcjI0N1BCeUlyU2tsUmRpU01jWmYvZWpTUHlLejd0ZWJxdVpE?=
 =?utf-8?B?UkdDZEJ0WUpYVlRiTUpxd2o3aFQ0eE1rbUpFaVpXcmNieXZnSGxvVWQrcXlr?=
 =?utf-8?B?MTVHclFsSnE3dS9DRUNsWHJSQ0UrdTF5YTFlNE05ZHk5Z3hKY0MreEJ6MFdP?=
 =?utf-8?B?ai8yZmdUVFlKeWtEeHJMekxJTmM3cTlhVlJUcVVrbGMxVnpHWW42SmQvaklP?=
 =?utf-8?B?UU14dm4vTWdxTmUxMkszTUNiV213a21YSm1RWVhWbVM3UlJIdlVHcExUdzJx?=
 =?utf-8?B?Qnk0Q2RFc1gzOEtMZmNycXc4bVRwVm5OUytCU1JtUGtuL3hHN0R5bUdsZzVG?=
 =?utf-8?B?WE1IazlrS29MNDlHNmJKd1JwTU5MdlZ6cDRVaDhGVEt5UU43bzY4K1dxTllU?=
 =?utf-8?B?Sm1nSlYvR0NuQnV2RWtlWkt6a3RqajhUSmxMUFJrMHNkU3BmeUZTZTFDTThq?=
 =?utf-8?B?WFFvS202NzdtdnJXNXRFWnVaUzMrOUdSZnZaSTBhQmo4eWl5aFRndFVTbVli?=
 =?utf-8?B?Sm05TnJESGlnYnFnb3ZEclpoenRZVTVsbzRxL0FydGVaT1N6NjdoSC95Wk1q?=
 =?utf-8?B?VldONEJ2Ly84T2I1Ukp0bnluTW9PTWlDZk51elZjRjBVRENsZVZ2M3pQRHpq?=
 =?utf-8?B?c1NvRkhNRS9NdExzOVM5aEQ5blA0aEJFZGdYd0d4VmRnNXRoUWZ2QjFXUEtx?=
 =?utf-8?B?dmxFU3BwbWhyY3F2QmczdnRqYVc3YWR2cUREMURkaWQrRkpHcTlGdkZmUFU1?=
 =?utf-8?B?Ulc1UGdlckNodmo0V0ViVHJOOWZxdDZyRllweTdBeUZtZTh0akdiOVlsVk1U?=
 =?utf-8?B?QUp2Y3RDem9rK0xKbDVGL0Z1UjVvK1FqV3M5bGN4NGJZOFhYdTJ2alB1YThv?=
 =?utf-8?B?RXRQUUFvMTlZRFc0MXFQR2xaSWhWSCtxa1NFSC9FdjV3eTZTVlZ1TWZONEZV?=
 =?utf-8?B?VUw0NHFhcEswV3Z5M2F5K3NxVXByZlJzNHBlMFp6czBuZGlocVVBWDhuclNx?=
 =?utf-8?B?ZnppWkdZbjdTWEg2TFFsQ25sWXB2QS82WWlVd0djeS9hWmZIbUpTLzljSkVL?=
 =?utf-8?B?aW1VMzdRRGphSE1la0VCcmxLWlVOZ2tiS3ArV1BWZEFZOUhRK0ptWG04SG9l?=
 =?utf-8?B?QVk1V05aVm93MzV1ajFrL1I4dXJ5a1pZRTJGcWEwNTlxTXJHMnMrQkdtZDhx?=
 =?utf-8?B?dzh6QXE3R3F1N085WTdUL1ZNRWhrci9BWUVTYkNqbmhydkRqbEx1dVhrdW4w?=
 =?utf-8?Q?BqOiB9zNfQ3zg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 062a934b-3334-4592-d6c9-08d8b90b4265
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 04:08:48.5123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1IRC+oH2bSl2liiogHx9bw8iRHhgRMyltGskz+NKSJnMn90NQxc/kNzEscsXsOK9cIXx/3NkNpdTvVmQTqOt39EnjrHpYYt+JgYYWRHOfYs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 12 Jan 2021 19:11:30 +0800, John Garry wrote:

> The mail address intel-linux-scu@intel.com bounces for Ahmed and I, so
> just remove it.

Applied to 5.12/scsi-queue, thanks!

[1/1] MAINTAINERS: Remove intel-linux-scu@intel.com for INTEL C600 SAS DRIVER
      https://git.kernel.org/mkp/scsi/c/e8e5df5edd34

-- 
Martin K. Petersen	Oracle Linux Engineering
