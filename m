Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD447C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7A7A61156
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbhIVEqr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:46:47 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:5192 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231673AbhIVEqi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:46:38 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M4i7CT013132;
        Wed, 22 Sep 2021 04:45:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=x5U26J2FAhQ1uKFbJwb6G0E84z0eTX6qvjH8OUa71as=;
 b=SrWgFiSKyH7BetjHlHBWwPdzQmxMANIyA7EcQZRncGPvIEiJgNyXGJJ4Y32HWIH01Dxa
 fYNvw9J6fi6O+0zCtuLsCh/2n/hEaTpN29DDUWDDAygubvZiON/PJr4swdRbM8lFFQK/
 80gU99++OKVc9GqD35PyFddFpwSe1Du3N/X66cArdp9CFf64H7oEhN3iYdq72CAC3ptk
 mHK2llcaV5Air3vH4PoQIM7oeT//JwYxmMXhFetkzgnO9v3rWJ+at0RFYxyjhkjOHF5W
 //1Y1HqT5JHgEszAabl8VnG9705jWdC+JDqFmvMJa2caBfrps8jujjinrW+AZ5to+lHe VQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4qhc6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4ZZLn145589;
        Wed, 22 Sep 2021 04:45:06 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3030.oracle.com with ESMTP id 3b7q5mc79u-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=apXmUh/bUixJSpJX9APMFFEzHhIN/5UEgn5lYr0vgImKzwys8IJz0E0wwuJ1FNoMVARh5SNr9+Ojk+soBMGMbVtJtvTtfLT5/H6p8Rbx9oYaEM3uJqnbVUItxKnPXwGsLZM+I7z3esynGDHbvPYwrp3TQj5ekEMdzpukR96WIvxN4NBpRum6vt++OkfUDOgpUGaHhOJXv7fUm1AD0hHOsAvRom7jdHDQJHFYB0bjnoIIt+E5OotB+UPlH6pp6aVWcTI/tUCcso4k6pUbX/qEWu+YHdID+Izr1LPsmBkYX9GZjnFHaBG/hRVYrDl3l4C5Nocp5QfyVBWENNUMLxH58w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=x5U26J2FAhQ1uKFbJwb6G0E84z0eTX6qvjH8OUa71as=;
 b=GgQEU9oEMqw6EB38KG8dLW8bDuEz8Iw4h33yGgkZbxFGMFJqVWpYewcXSL1aGbi1Pk9uYog+KEbR1oNqSk1ACOVk2+MrYxHQeUw5AxnW3qECEG2U5t1wsO3eTZU3MbK3R/ue8DFIDt9JR5ONcUhq+duPunosxYpkBCNixMRJ5nAKIbOeI65MRqg9ka4ypgLz7B71ih9JfnyheeVzi5B3vVG2sHf7PPZOHJ9bjMBOeaOAp5UGgSjZ1QlDJ6PoQHRcRgyIRp7r5HocKQ94wDpacWbiUGJnCUbKmbBtudi/XDsxjmH7NnHlqRJPh/inzzA2P97IdStuf4nwzCOOnS4Ibg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x5U26J2FAhQ1uKFbJwb6G0E84z0eTX6qvjH8OUa71as=;
 b=CO85dy/ZxhbSVfkJDzoS/y9ka8nvsO9qHqrRSWeIQ9dKOJRe2+BRUmPc8d4j8x0gc1h9EK9CujPTKxQhR4EsjjzkUyIqqWfCpeEntB7X1n3eGjoYbn0LrjimvjKTPjC6HucZ+AOkCS4lnmwTLvW5nK7HAptJpZF90TpEgHUhoZU=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4518.namprd10.prod.outlook.com (2603:10b6:510:38::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 04:45:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:45:05 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     wenxiong@linux.ibm.com, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, wenxiong@us.ibm.com,
        brking@linux.ibm.com
Subject: Re: [PATCH RESEND V4 0/1] Saw "Failed to get diagnostic page 0x1"
Date:   Wed, 22 Sep 2021 00:44:52 -0400
Message-Id: <163228551953.26896.3753388261918564937.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1631849061-10210-1-git-send-email-wenxiong@linux.ibm.com>
References: <1631849061-10210-1-git-send-email-wenxiong@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0050.namprd13.prod.outlook.com
 (2603:10b6:806:22::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR13CA0050.namprd13.prod.outlook.com (2603:10b6:806:22::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.7 via Frontend Transport; Wed, 22 Sep 2021 04:45:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f87472c5-2b5c-45e5-5bbe-08d97d83bf3d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB451893F660B1A574B7971C1A8EA29@PH0PR10MB4518.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H9zV+Hl7QCWgOe3n+Z3CnvPxdsfewh6fYLQgb4zpxny9LUdsKkHKJChzmCA5f8gX2XR2ko36df4BwMM43PqcLubsJoprDOEDakvDXGC65aRWu/1OqrHiTQTnaY1aVrmDh5uk+wVJbJhXriPv6nRIYAv81TGJ4f46Fm1ZNoGTRVdn4P8MMd8EMj97fMBNGKjTd7zcnMDRuQ3kGvFlUTR/mVCZ8T5PaXJwuS8cP+TDwEugdhXvPqDmwXnXVuL6yTRtNTPpDTaXNVB3Ihb2ch8YeV6kqSmLl4EJDpNcaQgd822WPBvD8kqNPGx2YYp938icmsrIVd0gA9MZ+igGNMG4uiufUozroIki7aWsTPpz3hQWccBogvMmnmniwVtH1Q1ayV6OFVY86Ncxnw66no9+zTjlOS9vEGpcisbVCImZJ8jEnDYDVjcrqZ3xf8zBdhPDpO54io7vZ/bBlYBcU8DL0KFzblhuoS5HrZyr3X54tqGggOQ70qtxxlJsH+qhAwVDuXPw0x3SUYE7FOOVm0cTfrrwGMe5y5t6/DkGr/CLeqC43FOF87aKfaU2Xa4P3kEGcH76pwTCiy+cpDQtm2eWdsuah84wBCM5UnUiCCgNLiIAYSQ4dtRCHzF1ipbD0yjfpsLFko770xDccTznPYb+d2rPNUURZoP+lo4FvOq6ZXSIJgU0MjsW9SHdgBlJ2fANq8heGq7eYfO2chewRnqx3TxNj62PQcNigTvlKu/vssFHei4MLmtv0WKBT1STJ4GjI3dGnV6IS3PBoW6ML6F21xFbkmS+mnkOYJnmwrhpC30=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(186003)(2906002)(86362001)(66476007)(38100700002)(316002)(103116003)(4326008)(7696005)(8676002)(52116002)(5660300002)(66556008)(4744005)(6486002)(2616005)(966005)(8936002)(508600001)(6666004)(956004)(38350700002)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUt2SFBtRFdRMWhpWS8vRno3Z2Q1QWY1VkJTVWFUbDErQXVxZk5pZ1RFNWNS?=
 =?utf-8?B?M1ZrcnBvSExKeUVGOXlNY1FySU5YSVNDNkN5dzdPMGk2MTJ4WWxXUnBJQVNp?=
 =?utf-8?B?RjZUQTZZL05Ra2lvZ3B5Y3pmbnhIZU1nMm1RNmVRZ1ZpdlRRM09pUzd0ajFE?=
 =?utf-8?B?eDd2TCtLSGliWUFabngrczRsLzVQbjBZY25maHh5SUFrUVppVVpra3ZvUDJr?=
 =?utf-8?B?UEI0MGx4R045NHBNcHV0ZkZQUWRRYTdBMFlRaWFjSmVUNGNkR3lTQVJxV2lv?=
 =?utf-8?B?d1lTYTBSbFJQVStITmVwdzYxK0R4VWtnZVdCYm9kOHdTOVJzZnptNFBPTWQ3?=
 =?utf-8?B?T2NRdTRiRTFHSmlGUnZMaG9OSHRqNndYVmE3bVhYZVNqalpIZUhtemI3WWl0?=
 =?utf-8?B?cXhnZmNvQWV3cTFTNHJ4Ty9DYk11Nnk0UmhzMzlMaitna0RlY3k2NjFkK1p2?=
 =?utf-8?B?TzM3dThjcnJYakNqZjIwTy9PVDl2SkZKcTYvUGsySzJWQk13ZWtOWkUyc05v?=
 =?utf-8?B?Q29WcnRwSGhGWm9icFV1OUU5TmtWZk5UTFZNbXJsdmhWQmp1UC93N2Q1RWpF?=
 =?utf-8?B?NFZzcUc0djhDVVh6OU9rZGlZVjRzaW9WbUxrbjhKN1RhdHdpYU82QXVydVp2?=
 =?utf-8?B?VVp4M1ZGcXVFOWQwZGJKdXVwTGE4TENtek15LzZJa0NoZlprQ2pBeVA3N1pl?=
 =?utf-8?B?ZTFsMlA3QXFZZ2ZNWFN0S3BjSVdPYTQvOWU3akZCN2VHVGFSVjlweVR3V1gw?=
 =?utf-8?B?clM4TTQxelk4WFZIQlY4S2dRdmtmQ1gwSjdRSVAycmtvaUNLTzRGMUVWSGRu?=
 =?utf-8?B?TlR0Nk4xNEpDVDhEV2VOWHZ1SXFCckJuZ3VOdkZhdHVDWFFxMHdnS1pUVWdk?=
 =?utf-8?B?TlBrZjg5YURmOVNUdGNkWENrM25XczZhM1NjUk40cysvTitBMUYxRWZVUW9L?=
 =?utf-8?B?YTRmL3NvalhYOUJHS0ZQK056NVZxWGNPZlpmZnpZUlp0djBXcFcyd25XdFBJ?=
 =?utf-8?B?UkVweTlqdHRxSU9ldW9DYldDaVFFTWtzdmpHR21CS1JiZUZwRFIyVzRsbzRn?=
 =?utf-8?B?YWhselo3Wi9VQUxMWVJnS2hJbVZkR2tIRUxkRGtRWVpZU0dVaTRyTklQcXB5?=
 =?utf-8?B?d3o1THMzMXNnWWRSVEJ0RmxzcWVlNDF5eENRNWR3UFYrd25wTStWNStRWTg2?=
 =?utf-8?B?dkVJeHpicXlaNWJMT0RURDdSbWYvVDVoajRIV3IxSjVsRHpRdzBwNHZlaTFn?=
 =?utf-8?B?V1Q3d2tWcmZib1VGaElHL3VUazhLYlZ2SkxpcTI1dzBGQlorS2dsb0tkWno2?=
 =?utf-8?B?MGxWOWc3OXNReVpZTnRLZ0JsMjUwdUVUcThQOC9MQ2JLYmNYVXVOc0pyZkNU?=
 =?utf-8?B?MjVNZ1NRbjFkYlZlM0ZadTk3SFh5NU12cEUzME1zWkNVOEVGYUI5N0UrWWFG?=
 =?utf-8?B?S3Y1Ukd0QXR2aldMMUNqS1l6RTRpejNzM1lKSkxnb2pkSEp0QzBTQm5KRVBE?=
 =?utf-8?B?Ync0c2ZwOFpoV05ZL1IzSTRBM2hjV0RWUjRRNDVuc3dtODJVNXNidnovQTR4?=
 =?utf-8?B?UGhEQ0RkUEJ0TnBQMzZVMUJhbXIxYjhxVVJaS1YxdVhrc0FtczZyRjkzZ1BK?=
 =?utf-8?B?aWhWQWRSWUt4ZFJtM3J3R2F4bjVmWFkvTWwvVzNDV1dRY2dGMG90QUptc1Yv?=
 =?utf-8?B?b29TRjc5SFcxUDBuS2czei96VU5weUx2a215ZWdrSmU1RFA4RTUwamZXSHhT?=
 =?utf-8?Q?POOo9FPoSGfkvgRuDfcTPEhz/ZLJSdT/1WPniND?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f87472c5-2b5c-45e5-5bbe-08d97d83bf3d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:45:05.3686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ii0eQygh7IX9Hq802IT3FZ9TAZVOzaA9BKTeaOzkkYZdET3o8v/76axPzYuqBElb81aOjk5OjGRksSf8W9QgXAr7xXrP0gcaWTDKqnC7Ya8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4518
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220029
X-Proofpoint-ORIG-GUID: 5IjH4rmq1NOTARV_nhNOVm6yC6j0ubUp
X-Proofpoint-GUID: 5IjH4rmq1NOTARV_nhNOVm6yC6j0ubUp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 16 Sep 2021 22:24:20 -0500, wenxiong@linux.ibm.com wrote:

> From: Wen Xiong <wenxiong@linux.ibm.com>
> 
> v4:
> Add checking return value before calling scsi_sense_valid()
> v3:
> checked to retry on NOT_READY and UNIT_ATTENTION
> v2:
> checked to retry on UNIT_ATTENTION in ses_recv_diag();
> v1:
> called scsi_test_unit_ready() to eat UA in ses_recv_diag()
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi/ses: Saw "Failed to get diagnostic page 0x1"
      https://git.kernel.org/mkp/scsi/c/fbdac19e6428

-- 
Martin K. Petersen	Oracle Linux Engineering
