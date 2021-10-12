Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0972C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 968A0610A2
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbhJLUhu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 16:37:50 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:26294 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234541AbhJLUht (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 16:37:49 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CK20LJ013029;
        Tue, 12 Oct 2021 20:35:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+irSh992xae4/1azrTdslLPopQrow3JaIP6yK0/2BSc=;
 b=NY3+Bm0ODTrzlqnKpPR2cTsCHaZyPqDu1SR0m+QpjXGp9p8OedL0rHbGEp4SKMmA5FXh
 bxmQWdhrV03QDXheDjsd8ipYwwvoiyVFWO+oGBgmq1beg8mPfJL2WN7E9GNdRkxKjhxZ
 9l5WX0MQd2Zkj8roiCjYeuTLuXbofaPgmV+gGkmHPh2bhXuLkxDovv+laezxSW0zeB2t
 yhw04mDxPx2gwHon/Cf5itA4TwDTw2+6eWCiLKhsN8bJYnOg4iQymC+PSbIaQfrBd3cm
 LRR3NUtPY4RNjRbHarpOADzdmm9FAhIyx3NsXjnB9QFzy13n9exen/lquSVTDt2LoXiZ hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmpwnb7p7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CKZ98h018006;
        Tue, 12 Oct 2021 20:35:36 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by userp3020.oracle.com with ESMTP id 3bkyvau7n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INDLynr6ZazzOc4YPcgmmbiLi6HGzGp9VALaLvKw1a6fUMmtgT9czHHm/lbNtl4yFw2hk1hW9/f4gvoxFbEJLCMpdPltpmTqrlOQmR38rci/dGyatyBWRg24JJ/Fg46DBAa+C3FEKBOB028WpN63CxXlsRuSgMpOKTohNDFJiuUxlQOjCB9j3KfJT4MqDi68YZ+2KRPWsLQIDOcPaufPsij/cc0MYSYc34XtZ/vBS/5WOyuwcbCGhOWJ2EE7EPnRkQnXzaGIFa9XUoK+c5n5m10CswhpW564a/BslRVRvVNxZItBMWokVV5IHpGdH2T9YE4wx6WM6UF40R5BsobcCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+irSh992xae4/1azrTdslLPopQrow3JaIP6yK0/2BSc=;
 b=LVBSdCrGGKcfv9YtwQUKYsGdvFB/pFXUCC0lIs8Z1s6ZgQkajgSZs/1xYNEJbDkpad9qXC49CHYEuPfflUBUCc4MNq5nYHtmtpYdayzjX0ouI78rnn3PX6mdM3CBAd81pXzyq8yDlBKMKGLoc4dySUBdgtk3bqMCv4lAXH1Dg7aL8I87yQNTARNYnho43XpDkx8UQ5ej0MyKHGnHadUgGFc8iEgcNmZfzeJUYtvsv5nrhMVdtQnKxQDq6bf+QYf1JQ+48h6qD7ap4qXIIVpKk6nNaEZTSL0Hm9EVFRKAVo7evF7iazJ6JFzxafIdFjkHKCyBC884WIw8LpsdLEv+7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+irSh992xae4/1azrTdslLPopQrow3JaIP6yK0/2BSc=;
 b=ze6yy9WRwMP8X1LSMJPoXQF0O3m+QS5t4+QPZ1yV9DdJhz5Gz1tV9co5zXPOpZHYfedUTPdvRnOWv4q1F3TIUSPlS39wMZzvqD1AUcyGSXmY3rbo1jdxfCngpYyVW0OHMe/4GdCsrTLOMQMqW/34IvSQJnnpdV1DsXATvfsgMLY=
Authentication-Results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5697.namprd10.prod.outlook.com (2603:10b6:510:125::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Tue, 12 Oct
 2021 20:35:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 20:35:33 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-scsi@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2 v2] kill clearing UA in UFS driver
Date:   Tue, 12 Oct 2021 16:35:14 -0400
Message-Id: <163407081302.28503.8474491363350181421.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211001182015.1347587-1-jaegeuk@kernel.org>
References: <20211001182015.1347587-1-jaegeuk@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0022.namprd08.prod.outlook.com
 (2603:10b6:803:29::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0801CA0022.namprd08.prod.outlook.com (2603:10b6:803:29::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Tue, 12 Oct 2021 20:35:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28b1b6f2-6a67-4420-316e-08d98dbfd6a1
X-MS-TrafficTypeDiagnostic: PH7PR10MB5697:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH7PR10MB5697A10739D4DBABFD315CCD8EB69@PH7PR10MB5697.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:626;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bZHGlXGVPVZhuVXXq9g1decq7T5T43JGU01TNfXmU2v/Xr+BPf4ryD3psyI4qcw0oVEEg6octy9R9UG4Tl/ZnrRq/i9saCpZ4Ylbaen8MrHLwo52ZP5AebRwE5SkOZa0jc2B6xo5xIUpTgjgrt0QFWjfTi863GCBhnw4YKd8ZFwWLBsMppKtqOIPP1OzhRnnlR6CkZSE8ff01NapNdbQPZqncDC9rqelelV35oOhmUICMvjEM2g2ivKHXEN1lDQUmj74ZBIWHxbNMvXcrXH4qwODqu79NJAYdWv8bjibCztGKkUJJ2p4htwmfUuvMZAuwTkC41JgYh6Dn0TftXmFvDWFQjc2d2bMV0OciDaeUsx+Uv1YtA9uQrfX2oz6B2zXpF2swCqQQigCQ0/edg4nv+cVLabZONa/x5Tjs8QMaB5q7/b/oNoEb3ct+aabTTgHeWNmqsA/ZMGcUXlToB5HOQi9IeKrB5dwJAxhMu5rj8cndg2YhPm252r2ELYR2pJCMb3o0DC2qtzDSt2wJQd+JZk9Q3kLOUupKYi8QsYoc0DqTDmV8yM1uFleL59ZwV3eUXSVQA+wLZYxCDQhiujF/oIl4eOyhHSaj49cltQCCh5V4c6isYheARac7UXyGejLrkG84vxJ76Yrs4gTZx/HPmrK6LK2n8qD6DW4r8P18e+QZibrX49uYDX9/+IfHZJqxd4Vq+aSuHxA1X48QekRiqjAM9k7WM5/omdP4hymPulwB9IivjSioekRxU4wrLWRF2u0ihlgZXjuBDyVzAX+knH/chkhQa6LlqvrTL3ayZu0vfoVk0dMAUh1WbD37Drbi5AHou2gltsOj6W3LF9nNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(966005)(921005)(6486002)(4744005)(956004)(7416002)(7696005)(66476007)(52116002)(2906002)(66946007)(508600001)(186003)(316002)(26005)(2616005)(86362001)(110136005)(6666004)(38350700002)(8676002)(66556008)(8936002)(107886003)(5660300002)(38100700002)(103116003)(4326008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UnlpU0tNUmRPQjBheFRtV0tsMkE0NkV1bWI3Nk1JZ1Jjc1RMNjcvTW5JQ1dH?=
 =?utf-8?B?S1hkandTbFpQeGZHWC9EL2xvajVGMFF0ZHZTYUZBbHRINGZIc2hOSkl2VVAv?=
 =?utf-8?B?dVM3TzNYc0tpcXBXRjUvTE9wZUx0azBQZkcyUm5nMmlLbjJHeWtSN3BUS0xs?=
 =?utf-8?B?YldPWDEyeVlISGczT1I5RlFwNDRITmRCUlNGcHpPckRlQ0MxaTBsQjRmM00z?=
 =?utf-8?B?eDBXY2szclBSRS8xNnZwcFhUUTR1dXZiTVR5QTFvcDFYMHRXMHhHZnFucVhq?=
 =?utf-8?B?K3VQRzBxZkY3ckl1UUIvWjk5bnRJZ0RUOHNoc1RXcGZtMzJIVVprSE5mWHY0?=
 =?utf-8?B?anI2QWNwVEg1bVNCTlV1VzVzQlZWTExXOHNqYzdEREx5ZTZHbXlTb1BoVTFx?=
 =?utf-8?B?a3Y1bTkyM2tkRlpFc1dHVzZzWktnWVgxRFVBMjJLMUlpMHlTc3hFb0lOMnE4?=
 =?utf-8?B?b0s0N2ZRaWkrNGVqZCtJTmVlSmVBb3hlUEI1b3FnSlBrZmVFa3BNYVd3UElw?=
 =?utf-8?B?dno0OVlKcjBwS3Y4LzFTKzc0V0VGQnFqWjJiZ3JLWkdIeXVEWWNYZ0ZEYW1n?=
 =?utf-8?B?YVppTFF2a0JGYmowbTBIaXU5RDBiQmE5TUFKTWFyWldNQVJLK29nQ0ZobERE?=
 =?utf-8?B?S2pqaW5ZM0ErUWZNd1crV2JjZytIRm9wRU15eXpuc2FSSGlwYnRTYk5mdzRO?=
 =?utf-8?B?TGJLYzNXT09JQ05MYzZteTcxSlZrUGRrSmR3amsrRVdyNjBtaEVKRE5TYWpS?=
 =?utf-8?B?clpBN0JYWHZFVm5aTkxVaWdZMmMwaGcyWnBqb0J1V2dvYzJ3bG5qeitLRFFQ?=
 =?utf-8?B?YmhHUmRVZEcxTU9aZ3pSaEtaVzZxQW9RaXIyTkI4OGtlY2hxcmhZTjdZUk5Z?=
 =?utf-8?B?Z3FGckxST21admNhWHZUcUo2b1ZwNWlac3FFODhPQmVnZXdubS9qbHRQOHdx?=
 =?utf-8?B?Um9zU2ZPQ0F3R3MxN2hIZTEreXJqNENXRjlBVFRxaTBCTUc1V1JKU3pPd2Nh?=
 =?utf-8?B?TGpIV0h6MnN2MzJRYmlGYkdSb2tRdm9uWlFIUldET2hUdkJTdXVwOWVOSFFQ?=
 =?utf-8?B?TlRtS1lEU0lHbjFlZFRaMnhzT0twSVg3bWVrU0JmODRsM28xZTluWTFVNGNv?=
 =?utf-8?B?UERMU0g1a0FDZHdJMDZUeitMb3YxUkQ4NEQ5K2JVNmt4YTJScU0xdjJVSm1C?=
 =?utf-8?B?SnhyUzNnZ2pUNWhHM09zVDYxSkowRFhDYW1uWlkvNUtjYnJ6WThiRC9Dc0w3?=
 =?utf-8?B?b2oyYnoxQ0wzRTc3VGFRQXdtMXRaUlQ4aXNkL2pXeTZub1diMVNzQjBxdjRJ?=
 =?utf-8?B?S1RxRFBMdFVkQWxaSFpVOFZTTXJRb2p3SEFmS3BxQm15NWxHK3hNVmQ2Z0Yz?=
 =?utf-8?B?Mk0vZ1RTS3RrcUtGZVQyOXJCWVN1eE94aE5zcEJKVlh0KzJIWEhSYWw5SldE?=
 =?utf-8?B?dy81bGNQVGFwbVFqSzlkdWF1TmxBZzJ5cWZ5eGpCU0NKcjdrMzlwakhqK3hu?=
 =?utf-8?B?SEVMMDlPTFFxZEtxTWYrTTdZSjFpWk5BOVlJVkFaNzQ1dEU4ZXZxb2ZqMHpU?=
 =?utf-8?B?OXQ2TCsxWEFoeXgwSVhaU2FlMUdqR0dQdSttN1h6TDJJNCtyWURaZGdyd0l3?=
 =?utf-8?B?WjlVMFFHMW9wdlpSUXFIVmhKUDhCNjlUU0xyQngwOUEvVVVwajVJa3VGa1JW?=
 =?utf-8?B?b3Qvb2NNeSsvNVpZVmpQTisxQ2ZIZzNpcjlJa2xBcUhOcWJFd0d2MGhqODYz?=
 =?utf-8?Q?RMssatTZsBHalpyq2HryZ2u0P3Spg4XRrey7HxY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28b1b6f2-6a67-4420-316e-08d98dbfd6a1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 20:35:33.0546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ou2Y14OCLvwFptIG04DkyQQPWuvarbb0rwrZ9EP+YHUxytFIszLNSZpF2khaCO+3iFQ8wlJ1SrZgOmp3fmercqHrKGTT/TYaVuutEtzbGN0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5697
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120109
X-Proofpoint-GUID: u7Yn5ML5VbOc3mv7XdRRw6PhMmUd0bXV
X-Proofpoint-ORIG-GUID: u7Yn5ML5VbOc3mv7XdRRw6PhMmUd0bXV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 1 Oct 2021 11:20:13 -0700, Jaegeuk Kim wrote:

> There are some issues reported and fixed when clearing UA on reset/PM flows.
> Let's avoid any potential bugs entirely by letting user clear UA.
> 
> Bart Van Assche (1):
>   scsi: ufs: Stop clearing unit attentions
> 
> Jaegeuk Kim (1):
>   scsi: ufs: retry START_STOP on UNIT_ATTENTION
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/2] scsi: ufs: retry START_STOP on UNIT_ATTENTION
      https://git.kernel.org/mkp/scsi/c/af21c3fd5b3e
[2/2] scsi: ufs: Stop clearing unit attentions
      https://git.kernel.org/mkp/scsi/c/edc0596cc04b

-- 
Martin K. Petersen	Oracle Linux Engineering
