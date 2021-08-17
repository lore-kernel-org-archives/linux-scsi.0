Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED2D2C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 02:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D186F60F46
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 02:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbhHQC4D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 22:56:03 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:1324 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236124AbhHQC4C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 22:56:02 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17H2sPXG027481;
        Tue, 17 Aug 2021 02:55:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Tk9ND9+yjK3YYwIsp+xLv/Qb5Qmvh5tkOkrPeUcg+Q0=;
 b=PFW9IyZ+93SqSh8JUGF8ZGDYhccHBreqmXYMzeDooRHxgFUXmu4fgGwv3/FNVhrG/EV3
 MPM3r0uHYCnxAc5lkhWcJnvrrcVTLCD70pHAg2kIXRkys4UNT8tQFFiImoj4rznKrLk5
 JGg+NnKh3Luys6O+p7M7Iz/BKakTECnBe0gG0eIswW5ysgUFLUgfPkp/v8Tj7OWAHo56
 2Jxv1UDEe6wCxpZQYcrSa/n+5iSBVr+fgQBcWOZ8dtcBVfap9ar6Xa8gtsRx5GfkKQxg
 IwyyAxp+y/EET23QjR2UEL5aRhiTabeCWE1+r9t89fiqAQs3A1sJpE1xIDoFFSBRT1l3 jw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Tk9ND9+yjK3YYwIsp+xLv/Qb5Qmvh5tkOkrPeUcg+Q0=;
 b=ir9NnnoS4LhvqD5OJXCC58pVNCx9lTmG2vSyB8d67oa0Z1Njf15R438xfoJZXVsQSFIG
 bxHLo63OvWVpSBamyjijE4UoGQALi1mZxfWvUJhsDMzFDAt5IuZv701WzNTWHWvPF41z
 UVZe17tJOR3k5EdWLuOyMLfLWoy28qmBCZFUblu2ckAB9dYSIdNHMPT65Kku4mdWZ71P
 oyuCBq8u5UfqaNRgrNPI6Mqb69jyaHq5Tktu87Lv6B4nQhj4WfMoDAGON5/QeF5K6cx9
 fi84U5WG+h9jd0WH8aDJxJfAnTfs5vpERwm4pqV5hUINFXm24SdZGe7bhThKx9oztHNY pA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afgmbamc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 02:55:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17H2suaX193959;
        Tue, 17 Aug 2021 02:55:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3020.oracle.com with ESMTP id 3aeqkt9m0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 02:55:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5ZycFTu94eiWhfFkJytNQVe4BSG56YgsnWp7n/TCuGIN7xcnJuwMZXn3rCto8Q2NgTaXAtAKcnUvuaOcSGDgtPkSj4uvjnZBHjjZBnu6IVaUtiqiJZks+2Bq7luqy1RuOuoVv5bNrc3u2yzCqLAzNJPglqfGA0KcpXz42Qisr+V3ir/a49pFJJZHKy7xDHjI03V4xhIa/aXfRHI0esUntuGuorOeY2VwqeffOl+zqX4FoZNSU4ykYQn7ieDuh/hPciMF2OiqyYQZG5cXOv+UYmAEO2n+purvIHiv3m13/DlN0qXmOymQ047RuDF7JPdsxG5xEGO5M9TKwAlV6hdAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tk9ND9+yjK3YYwIsp+xLv/Qb5Qmvh5tkOkrPeUcg+Q0=;
 b=d2Mh4Td3cpY/VyCRx1x6ZbB4AbAUZq/BLI4qaAJq+vYewX+3VagG/jSIK4t/48q4lDVCe61amuvNMvdtPtmyNZdGPAeyDfonXU2a0ZDYHQ2b4mGk4NsXP5a/gWDQsAA9X9mK79RE/zzMNbzyO9iZ4OfFDlq15MHLDsO3n+yNKgBPufttqUyTfykohd9F//x3fWneUAL+ve7mWasFAU5AqUYDyQ/4KHRdEuQDtN6jmAnBxHNnxWhtakeisspUUhTEfekscWm9qUlPlcRZNgmm6TJlxafPj0ity9RGuJsXXOAileZn9AdHsilOfo6wYSyyxwmXpOXxw/6EA3ZELQ75Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tk9ND9+yjK3YYwIsp+xLv/Qb5Qmvh5tkOkrPeUcg+Q0=;
 b=bKdD5uBZ9YL4s3o6K2TrxyHN2TP38IhUgFovABKSsn8Nhaefc3ykfNzkzcP5+0R5192H6duBZU6d2b+D0IGumJQczam8xWI9PXXIx+D5LRLrBYAX+Qua1vAXA2mViJ+snKFen5Qs1x0Hp7CFhlMVBCQWbZtTibeqCLMzEbKCsSY=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Tue, 17 Aug
 2021 02:55:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Tue, 17 Aug 2021
 02:55:22 +0000
To:     Tuo Li <islituo@gmail.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com, TOTE Robot <oslab@tsinghua.edu.cn>
Subject: Re: [PATCH v2] scsi: target: pscsi: Fix possible null-pointer
 dereference in pscsi_complete_cmd()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v944ok4z.fsf@ca-mkp.ca.oracle.com>
References: <20210810040414.248167-1-islituo@gmail.com>
Date:   Mon, 16 Aug 2021 22:55:18 -0400
In-Reply-To: <20210810040414.248167-1-islituo@gmail.com> (Tuo Li's message of
        "Mon, 9 Aug 2021 21:04:13 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0108.namprd05.prod.outlook.com
 (2603:10b6:803:42::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0501CA0108.namprd05.prod.outlook.com (2603:10b6:803:42::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.8 via Frontend Transport; Tue, 17 Aug 2021 02:55:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a57776e-17ce-4a0a-c22a-08d9612a7496
X-MS-TrafficTypeDiagnostic: PH0PR10MB4615:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB461581E8CE50F05A03BDED338EFE9@PH0PR10MB4615.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4FAroQs6BI3ZJSBooSpDQHplp8UexSCfnHYX6HpKiJ/n/SYfcdQOoVUY+8lwIvk1FHf7cf33yMNbFxPkS5+dOw8/qUTjwGK3RpY0mn6xKmP9/UavYOBBzV+vkf8hVJMABvR1TeR4vA3PeU/3Ny9O/bS00EQAacesAxeMI3wcW05IUpRThLMUawW77a9wp3kSJKgJK67QwlHarfu5jbCALh2hO1TDvAB5MIVsI77O/cYCJBnrx/X+bot0jmW5jSmLGyJBdRJq/fk04FOo0ycenNr2vpEPclIMScrDJFQsNMd1EJQ3dMlB+sTqXZpKfoNYRBtD1Uo6G2nL5WHLnG4mXoAA0EurlIAywQvwzHV3GEhoGg0gh/etEuESkKWH4IYTrLmj4+fTq31z15eMOfgqivHGVc5hOeLhicEkMt+on2bmqX9e/pF3tFEs45z75KE8oYd0Cjmdftt3/ksMTaJ6TABlkJDd2mn5tn1fDnPC8PRb0CGGGngtcPCpVhkReMgzENB0dBhsIllcg6J7dVh90jjmO3iCvGpd7aeAJaqzX5+s22jOQAk1Yzh7XRfkfmXT2Eo3d3CwpHmgQlt8+wLzXbAJfS+9zuiV4UHcXDh66RpK/DRNBxvgvGT0B/Qt+L5p5Fj7YfB0KnE8TIKPVpstHEBbNMhSeBJNtLhQFBsdmApUGfoOCvDIFUWRT40KJZAJRUn5iOEiTWYu2Fh/E6mN6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(39860400002)(396003)(366004)(956004)(8676002)(316002)(2906002)(8936002)(6916009)(36916002)(52116002)(7696005)(478600001)(38350700002)(38100700002)(4326008)(5660300002)(6666004)(66556008)(66476007)(66946007)(86362001)(186003)(558084003)(55016002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mF4kFyxla8tEDW22qg1gcIGN39mV1CgOMfT17NFcPaUjBtSv4SuMbCP4+CmF?=
 =?us-ascii?Q?GMNVz4ccEjfefQCW9pVPoaFUg2YtM6xv/8h2JxXvAPnOrFqNWhxvUeeuR7Uw?=
 =?us-ascii?Q?AnTvHVkZ4Qz+xxMK0DaQsWJJrxJOE9EE8/AWAxk/iQeYa2E0lEsMzg1WzLP8?=
 =?us-ascii?Q?Tzu8jSWW8vhmECsTYULUk29OcnBeLbio7D5BqRB3RbxwzpyxpjbYJTpr79DD?=
 =?us-ascii?Q?yYq7wHRmHYMatM32XWANrMWRFkShAl7M/IBmnYbaKe5rysGW1f67ANdIe/j2?=
 =?us-ascii?Q?qnwhxTFgugipAsV7GPPREI4IF4qwR0m5YyP0gFqhwSHUN65pELsy2x8JdeOX?=
 =?us-ascii?Q?9UwWj0HhlSanmJUD4rCf6gMPafnIZ/Sz8mwZuHQM18FBLQqO4tOkTbMQDgpz?=
 =?us-ascii?Q?ukrpGKS5MgGW1VVu+KrM4/k2CLIO1QUo0BshEKqmvRAwILAa1y1d8lsf8zr+?=
 =?us-ascii?Q?8nqR7JwBl77+llv0/9pHLd75bDTVuSPKPcHJ0953WIItoKuO56AnB7PH1nrP?=
 =?us-ascii?Q?UMpThQU+ffCYs14vxN0tLZ4UP5AbdWJfPaC9mitq+V2DGIeHuQhxsoJPnltp?=
 =?us-ascii?Q?nGDxwh/qkOboQXCgNodXmGeArVKlmJDdkHXDWLb8rFJN9zIVn/ffWm69+7k5?=
 =?us-ascii?Q?Sj+qckBpWmaktE+vqUNf1SY8gqGdlyLdE5L91zwGUlNZOclfLRoS7AJulSWn?=
 =?us-ascii?Q?RFc5WXqM1IZ2Hzzin+wADLDXz4RFHjnohtiEr2EQ4TAdTrxfHCIBYEG2mW30?=
 =?us-ascii?Q?SBjyYcwNjRCeIpkSMaENejd4sSDit0zMjhN5J7Xj8aQT7dbxhDv9MsqUTNvI?=
 =?us-ascii?Q?D1mwvlMj4GnbK6UWw3ylCPH4shNWUlrtuhJlMCESflckAdg5jn5u426N/HbX?=
 =?us-ascii?Q?EyIG11K8pINcBJIuUXCRFE6nzKE52eDV0K+DDxhA9XVwrd7xzQYfPFLvDXrj?=
 =?us-ascii?Q?VKXL9jWdHMFsS0uhQ2uRH6pTkPT6nUOfGFO5/QfYc6NpCCj9gi5x1ib9yMPz?=
 =?us-ascii?Q?zmztl0Et14G5z/sR5xxXTS36wAOn2U3WDdklsAkHGemP/yXf8vbVRWApC04q?=
 =?us-ascii?Q?1+NWJRqW5oMI61GzXz5ZL4rq64yXzbC+y9SpRm4rQMlqwg/P2c1PQb7Q5uKi?=
 =?us-ascii?Q?9iaNMQ8NXqO2R6RIyoWNrAShP+D8fwyxU03CDEPKqf9OUKK41V08WeYSI1mt?=
 =?us-ascii?Q?tn7qaiZr4p+FmKrhQEVOPzOVqp3QhOnlzj6BpSHgwpDxIVnyKa3qHzBuHgEH?=
 =?us-ascii?Q?vB4Qt+5nlSttOWsXTBFF7nxWRGmKFeKBEw3pn/KjTLKnKJENQro6m1ylFSUq?=
 =?us-ascii?Q?MS1fl1xTjdUSqODUyIPhxe54?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a57776e-17ce-4a0a-c22a-08d9612a7496
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 02:55:22.3338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gUrhaa6XUbYLOplN+zj2vJaN/p4DOxaRQ2Z6fFDmzQNrn8h+Jmv5sBqhOzw+9M3cgc4rsf6jYc5mJGFAMI/no416ipikuTGJY7IYlx0iD+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4615
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170017
X-Proofpoint-ORIG-GUID: 4doTiVfFIEmiO8UfE_mbiL-HX5O4kUJF
X-Proofpoint-GUID: 4doTiVfFIEmiO8UfE_mbiL-HX5O4kUJF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tuo,

> The return value of transport_kmap_data_sg() is assigned to the variable
> buf:

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
