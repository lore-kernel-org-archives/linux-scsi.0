Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4055C43381
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B838B65084
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234823AbhCPDPt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:15:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38926 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234785AbhCPDPV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 23:15:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G3AdAi074917;
        Tue, 16 Mar 2021 03:15:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ZTfO2bSNGfzSMb91KeS/ot/WwFKBiVBmckfnusnt5A8=;
 b=OLySCAMrYZyfOaLpuovzr51cArh3PQ6sNnh/mNuMfpxqyeSSrPrWJaP9UGlErX4cQ8j7
 OeJ8YqWvN9e+Tske+NyBPxUZ8BKq8sN4WOYyq8o24GHrvlUV4JVnjMLRGvkEIaS8Q6rx
 nkWpdeDuxDoPU4VhzzUjILKTQjRgteKjqOfSIo+Y3ECwTZ7pQhsao6wpZv0NB1iEXAyz
 8XvEfIGgC2p5QjsvRqvLC65+8ZQs4F/TJOzIe6e9MH5p4QpX0gpjOJpQ2fT1sYvn2EF3
 azuMXYi7cOjUUZ8txDs6bX6BsLjSRcZuRMOQYrHVB5F11d6cicCaIsl/31jA6NdDyQLd dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37a4ekk39p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:15:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G39dpr138133;
        Tue, 16 Mar 2021 03:15:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by aserp3020.oracle.com with ESMTP id 3797a0nb5h-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:15:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RP12xi/zzsAZxcB7eP/bsLh5o/MR2RN+RW2HfCuOPTjzNcMwWSODRde2VpQz4jrv3qZ/dT57ADz4D9hdGCYPOcPdqLNwNMqOE2qKBk4iqhEtRDoIc/zygotsZBt/t1g4/Ir95fu9j2eX4BqapLxjZ4JAQgt1qVdgCFmj6gcZsrECSkMjWFRnwZbFbny4mQmxEn5VRV6l3o0lOLZeg8WiJeMhNh0VRXsK8k1bvtb0WlygcBMMKMuf1BQqteO7t50FvZsNjYeWYmrAKTo5x8QcYuYzzeKytlUVLJW9iEhHwrM8eXFZlbLRBeMV5Ke3j8vk1jfK3PkAJXa7uNgpzI+JYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTfO2bSNGfzSMb91KeS/ot/WwFKBiVBmckfnusnt5A8=;
 b=D4K92Vdxx2vNLbzELl2qbtzkb4GWmIfULquOsullH47IiH7g5RXRJcF9HlICa6/kBvCPe1TturqHX5kMwaTfVIWS9G/iMLsM+lr0P4/MkLk5kLduF+oxq7YTFwV+wf5KHCxCY3yejgtD9os2LH109uLHS+ygFRbzy23YKY4fzB6UIKKmoqjQ9/ebWkLi75xBhmTVRDUH8p0QleW0Aeh0HWSNkqXRsf1AHquzT0jqBK0ShqM8td6iH0i4r2tJTTqnNcm1olg9593zC2RnKPAYg1bCkqpO8iGtFkEPE8f2V2C3VVsoR3yF+XzaUtI+w9OelWiwwCgsJDjPC0o+RhBNvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTfO2bSNGfzSMb91KeS/ot/WwFKBiVBmckfnusnt5A8=;
 b=qwhsXMjoypMdAFwfy117bctGMUBLYCdFE3D/pBD1UTpGh0bw6WizuAYhg2OEaIjGtrITK2ybuBISO+z1bk+qHNWVpbGwWglQ9kP/Sr/ZNOG6KEuEm+f9WDS90Z3H0VLENNDp99aOUyTxUXJRWtGyuM01CBuIiU8iOv0G5vUqQ+M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4709.namprd10.prod.outlook.com (2603:10b6:510:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 03:15:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 03:15:09 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, bvanassche@acm.org, hare@suse.de,
        michael.christie@oracle.com, houpu@bytedance.com,
        mlombard@redhat.com
Subject: Re: [PATCH 00/23] target: code cleanup
Date:   Mon, 15 Mar 2021 23:14:54 -0400
Message-Id: <161586054342.25014.2389873301381826454.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: CY4PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:903:18::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by CY4PR02CA0012.namprd02.prod.outlook.com (2603:10b6:903:18::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Tue, 16 Mar 2021 03:15:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f833401-2cbc-4b13-b5a6-08d8e829b439
X-MS-TrafficTypeDiagnostic: PH0PR10MB4709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47092911624790E87B4075818E6B9@PH0PR10MB4709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:61;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HCp5jIdZx4L7prtjJJmcIVsBo2yy9R/AIZvmbMDxhqC+yB42DUUE6mij25MJI+yRc4dK+dcFKEOgZx5Ag1aFbtQqxjR8jlO4KTs3O9Tg4OL5HAYiWYGtHpVHSx8psjTJHc8/TYHOxb0dHiMEFYDeg+8nJthFgZVJlnXvtXpojDROPU9BHTto6PDzlDEtZMAkuMOfnGHPprK1tPZczpkf8YliVstss1PGTpk8BABStXv2kXEg5uqyPRUHUR2/qUQG8SovMh+Go+Sfft/y2YN1wI0ShpH0/Q3zoxtPWgfQj8tx5btjblSNq6tUAOmlaMjzPm82XiVnFEC7jXPYYnRci3XrW5ZsC0+a1qo73bTUEUNevL7rOTw8TlGZaDmrSpV636VmpPnvzFZXjYoPeD/Qjmf9F00Orv44zagtWlrzKrC1R/FuragzyG1iFLkgD/V5LlJQlTMhAWijA7//EFLxPGfy8HKAtE+Nqdo8IuDBD0jCHLNBzxO1txmre4cn2GVASkDg8+mg8uFD8wJPq931n8KnnKPUQ3FDVbdOUUtXUO5feBR/+GugoiQ7w4Tw5B8CZR+RCWLc4wOV5k3co9wyGyvWYxRqmVkimmAuO3j4eGaQR9XgmkB0DRSzjNJM0JNHreYr4OEStAHDP2zaM1RqRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(2616005)(26005)(478600001)(956004)(4326008)(83380400001)(6486002)(186003)(66946007)(103116003)(316002)(5660300002)(966005)(6916009)(8936002)(86362001)(8676002)(16526019)(6666004)(2906002)(36756003)(7696005)(52116002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TWxYQWxqay8rQUFHd0xQY1JxL3hKdUVCRFNqVlRrNHJHRmpFQW5XQTY0cVBs?=
 =?utf-8?B?TE80QzY4K3o3dDBJU29sWG54OWZaZzZLSTQ5bE1oOVo3bVpvWWdEdUFNRUNm?=
 =?utf-8?B?UW1ncE9jeGFvWnhPRlR2WmJJOVg3QWpJYzYybjlSYUl4ODNDZmxZV1NsOXdT?=
 =?utf-8?B?WmVZY1RGQ2VQRHRRSTYyYVd6bzd2ZTlDaVJMUzNQZE04ZkFGcDUwNkpKQW5K?=
 =?utf-8?B?WG9HN1RST2QwaU5IT296cFRTellLdkY2VVFsc2o0VE4vbTZOemVZMjBOanZU?=
 =?utf-8?B?QzkxalVCUnVXZU9sRHFQM0Z4OEJsU29aOXJwZnVSQ1J3d2VHU2xINjdjdFIy?=
 =?utf-8?B?bkJQd1NMMTl3RDF2Ukw0NnhNSFdUUTNnMXN4cnAxQ1NuMTZTaUwvdzh4aFZk?=
 =?utf-8?B?dGsrZHRxcEJrTUlRM0hQZzczR0lFdjZyNjhEQzVhRGhKb1pJTWk5TldPUHJp?=
 =?utf-8?B?bGhLdFdRU21yQ3N1QVRkZlRSc0tQck1xRmQzUXlZUXl6c1E2TEhWZ2ZLdzlH?=
 =?utf-8?B?YzZSV00yb2FUbkl0YXRyRFFoWTRpVXR3ZWt0eXIwRG1xL3ZwTkRqS0VudCtp?=
 =?utf-8?B?NWxKb2xSdVR0QTFleEt3UkdGclNoc3UzOUVPWW1rbXNGekFEYWVTdmxhRnB5?=
 =?utf-8?B?VzVrU0Rlb3J1S0JFenJtYzI4ellxcUtJOGVwWGhsNUhYaDV2eGxGK1cyQTNI?=
 =?utf-8?B?WDJiS2RCQms2SFY4RGNOTHFYWkVyc0xPbWhCZThBTEFDQTFvU0tEbjEydStV?=
 =?utf-8?B?MFh2clVNTkR3VnJhand5QXhSYkd5MlVqTTFiQzVFZmFNZFVjeFhuMitOQnd2?=
 =?utf-8?B?L3RVY29LTXNxb0pNNFM3U2d3ZGpsV3dLOU83T3JNUDlUSE40clJiR281ekU4?=
 =?utf-8?B?K0duME5kazdJcVU0V3dUbWd4WW9vQzNFQUFiQTVucDI2MTkrZzR2NDVlK2lZ?=
 =?utf-8?B?WCtBT1o5RXJQSXhtSVZWWGcyL3dCdmlndFRMeHE0eWxYNURnVTlRWWo5TlFO?=
 =?utf-8?B?Tm5TS1JoVFRDT2ZsaVQzem5xL2VSc3M2V1MrSFhxM3RnS2ZxdnJCYWlBQWhB?=
 =?utf-8?B?OGw5eXpDclh2d3RqaTIyZDRaMHVDTFN0bjF5QnpxaUlqd2RVZmZnY1h5NDND?=
 =?utf-8?B?amZsRlpTaGlBQnh1TTE3QkQ3TkxzM0F0K21nVWRZMWhVVjd5N245dHcwaUZZ?=
 =?utf-8?B?MDdNaWhkZXp1OXkyNE12SFRQcUdyT25WazI2dG1zaWFiRVNsbk9zbFZ1MkZk?=
 =?utf-8?B?YTRIUkhLdW80c242djZVMVErOENZRnhITlRhV0xsdGIzQVJ3amk1alFIK0NS?=
 =?utf-8?B?MzhtbG5za3ZNQ3R6L1BqZEhqSmc4cWhya2RRNUx1NWlyS1NuRnlXRnl2THlj?=
 =?utf-8?B?clBtYmdzWUdDVEdzRW53bUVSYkcwcVlHOE5KY0NiNjNMeVlhNkdTQUdaeXRt?=
 =?utf-8?B?SVhRTHhiOHY5ZDNENkJQRnlFV3FOR1ZvYXdjZW9FMkgwdS9PeG9jdFZXSlhY?=
 =?utf-8?B?TUVNd1FOTnFDTzJEZVdBZHRBejZEUFVESk9VQjh0T2MrelZ0bkkvMnB4a3Vl?=
 =?utf-8?B?UWxKUGNyN2tWcVl5TzU0MVV4WkhLU3VIRzhqSDBQTlRVUVRFcXg5VWhvY1ZW?=
 =?utf-8?B?cEFXTjZiWFhxSTh6cXFiYkpKS0FKUC96YXRtemhoSkJwVGV5Q05reTl3Ynl6?=
 =?utf-8?B?bkNBM29qK3AxaFY5RGZmaCtPTE91YTBKVGtNVFJiSmdUcndGbXorSDArWHJh?=
 =?utf-8?Q?82Mf28DyiEegWohii+d7WqEfDCgwSolaEEDyAal?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f833401-2cbc-4b13-b5a6-08d8e829b439
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 03:15:08.9990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PzzXuAILtmK8y3balKanXj/RoBFnRTTSbFeCMRuQH4WLFpr/vm3FXY77k3yl2dLyGcvTgmHU5vrwnUsgtXLmUgpWzpOMm39u5LsC04ZL/0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 27 Feb 2021 21:56:22 -0800, Chaitanya Kulkarni wrote:

> This removes unused macros, various memset, extra variable in the
> target/iblock for bio get and fixes type mismatch for the same.
> 
> The unused macros warning are found at compile time and they are
> documented in each patch commit log. For memset removal, there are no
> warnings.
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[01/23] target/iblock: remove an extra argument
        https://git.kernel.org/mkp/scsi/c/bc9e0e366fce
[02/23] target/iblock: trim down line longer than 80 char
        https://git.kernel.org/mkp/scsi/c/a2c6c6a3b1ff
[03/23] target/iblock: fix the type of the logs_per_phys
        https://git.kernel.org/mkp/scsi/c/c151eddbef7e
[04/23] targe/pscsi: fix the warning in pscsi_complete_cmd
        https://git.kernel.org/mkp/scsi/c/fd48c056a32e
[05/23] target/sbc: get rid of the warning in cmp & write
        https://git.kernel.org/mkp/scsi/c/5cfb5b0258a0
[06/23] target/pscsi: remove unsed macro ISPRINT
        https://git.kernel.org/mkp/scsi/c/2c958a8c1f15
[07/23] target/stat: remove unsed macro ISPRINT
        https://git.kernel.org/mkp/scsi/c/c3a27351d6db
[08/23] target/stat: remove unsed macro NONE
        https://git.kernel.org/mkp/scsi/c/c3a27351d6db
[09/23] target/stat: remove unsed macro
        https://git.kernel.org/mkp/scsi/c/fdc1339a421d
[10/23] target/iscsi: remove unsed macro TEXT_LEN
        https://git.kernel.org/mkp/scsi/c/91ce84a3d789
[11/23] target/iscsi: remove unsed macro PRINT_BUF
        https://git.kernel.org/mkp/scsi/c/c4d81e7c53e7
[12/23] target/iscsi: remove the memset with declare-init
        https://git.kernel.org/mkp/scsi/c/c22659fbb98b
[13/23] target/configfs: remove the memset with declare-init
        https://git.kernel.org/mkp/scsi/c/2d4e2daf4fed
[14/23] target/configfs: remove the memset with declare-init
        https://git.kernel.org/mkp/scsi/c/2d4e2daf4fed
[15/23] target/configfs: remove the memset with declare-init
        https://git.kernel.org/mkp/scsi/c/2d4e2daf4fed
[16/23] target/configfs: remove the memset with declare-init
        https://git.kernel.org/mkp/scsi/c/2d4e2daf4fed
[17/23] target/configfs: remove the memset with declare-init
        https://git.kernel.org/mkp/scsi/c/2d4e2daf4fed
[18/23] target/configfs: remove the memset with declare-init
        https://git.kernel.org/mkp/scsi/c/2d4e2daf4fed
[19/23] target/configfs: remove the memset with declare-init
        https://git.kernel.org/mkp/scsi/c/2d4e2daf4fed
[20/23] target/pr: remove the memset with declare-init
        https://git.kernel.org/mkp/scsi/c/4db6dfe62c5f
[21/23] target/pr: remove the memset with declare-init
        https://git.kernel.org/mkp/scsi/c/4db6dfe62c5f
[22/23] target/pr: remove the memset with declare-init
        https://git.kernel.org/mkp/scsi/c/4db6dfe62c5f
[23/23] target/core: don't duplicate memset 0xff
        https://git.kernel.org/mkp/scsi/c/4524a0b15902

-- 
Martin K. Petersen	Oracle Linux Engineering
