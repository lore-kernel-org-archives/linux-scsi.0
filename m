Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1569CC4743F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 03:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB66361278
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 03:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhFHDHd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 23:07:33 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40936 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhFHDHb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 23:07:31 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15835bxa085565;
        Tue, 8 Jun 2021 03:05:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=kvjGVER5KcQ9qsQ/C8jlpA/7gfXwCPzp+BoNucJBTn8=;
 b=ejxktjxSjTnoE0dmEI9Kk9L1zBAyaMzf9ppG+Yz1CiMqsJzi6T5JuRXokA9QrYEK9DXO
 /XiAaItJKWkTiLl7GRjSkt78Ht3S/CyT5js3Jn315OOi1QzvelW/vVHAGnPcCU014zQ2
 hGNFMMF1tSzeOHP0sSW3k6gexVtSsosI8Wb7ylgydFtgiLTjOX2w3mpd1HtMOJ88EFrT
 3MrDG/6C18ctk6oCQWrDuxU0GPfE0dIqoqJCmC/spZNLf5XIFPSsTm8kLVze266jWfB7
 fpWKZPzn1v0RCsCv4SnriNroCG7ANxV54J8Km6vDhO717nsn4iX4hYUPj4cZtz256JlC Dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38yxsccn8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 03:05:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15834UCe151447;
        Tue, 8 Jun 2021 03:05:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3020.oracle.com with ESMTP id 391ujwgtw8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 03:05:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGZBjVrssA+Yzw+WxCJcF+qgAeypUsJ415ZeEqKkfREK8X40u0YtKaGXo6I37LtrGpGQtZTleOZvftaNng5t0eJk3L+c09LED71O4KHvtPrZ3wsSj9+mHU9WPrAiaQjUW33y6ndKeFiWSeWZxLtalDQAG2XafaCdPeAQZCLTxMgY7QlDZzrOu1PjwyAIfRVyEjr9b1eP+GtDOSouFbtPOLslDMz+QY/IX3vMIOkLv+fHA7yo8/+XdZsvUrDdSB2uQb4SNVah8tNbrMqv9ySQWNk6R6/jw6kdN3fyz7USqHymugYCA7PetK34HjpqT52lJasuAZgMjjDOUDs8Bes/rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kvjGVER5KcQ9qsQ/C8jlpA/7gfXwCPzp+BoNucJBTn8=;
 b=jniy3Xx/dHIJmwcZG+PZbXtzozldhxYtXNeVGhoNfCvdDDABw/6Nf2tK0zgHQpauymLsEG0uc5FXnblUa29A+E7G2JGZLJyad7EVJ9tG78sTnzKXiRsXvahm1aJHbJ+yKxx9UHmmUcnK1KYQQKzJuvzsAvVhkn3NqfUjsU++HlJJGadjs6CmUqC9UuwX99RTq6ChbhVvKFj8+NQUhVT3K/lov+e3cktu6BzvViXmm9yDMfePyDKr/0NPmq88GdFZG+yTHkvlxBm+2LUOL32Q1ScdroJeQa6Md1/qsTIn83NDL3x9iDyMYTKeDec+LV5/YN1ymA/Ei+sHuVqlTHuCqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kvjGVER5KcQ9qsQ/C8jlpA/7gfXwCPzp+BoNucJBTn8=;
 b=DzvlxIU2vwEvGT6X4Y0d5iKuNWkV36b0+4EYS/4R813KFfC0ODhhJJK/4yumFb3JxrWBpWw7gRhQNMJXHJtbE5URniEQxDUJBtAkPgt0RyBNDVygfYC3uv1qth4FzpAOD2tG8nX8KzuQ8YR98ZotJQRH7s3xBQ46CoPDpvBWfP8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4470.namprd10.prod.outlook.com (2603:10b6:510:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 03:05:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:05:34 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        peter.rivera@broadcom.com, jejb@linux.ibm.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, steve.hagan@broadcom.com
Subject: Re: [PATCH v6 00/24] Introducing mpi3mr driver
Date:   Mon,  7 Jun 2021 23:05:23 -0400
Message-Id: <162312149257.23851.9704833389076969688.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520152545.2710479-1-kashyap.desai@broadcom.com>
References: <20210520152545.2710479-1-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR01CA0023.prod.exchangelabs.com (2603:10b6:805:b6::36)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR01CA0023.prod.exchangelabs.com (2603:10b6:805:b6::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Tue, 8 Jun 2021 03:05:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba5777ef-6126-4c99-dd6a-08d92a2a48ae
X-MS-TrafficTypeDiagnostic: PH0PR10MB4470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4470CFCFC4B92DB6D228BEBE8E379@PH0PR10MB4470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NGj+t7aJbY6kR3EigUd7AOtUvJI1LOdR8Af4agX07ZnXAu5mSM+UDHT+wjmOS9DF1xAf29kSlo7f5i4TfuqtatsCCGgJfDgopMVpXB5ezLsdn6H/PEEuL4RcSydJZf2gK2zr0pVpitsErLT80L/wa0PGmthlGE24muMh2jSijsIhmAtzAJz3wCxR1oVXoODceiDHHwjhSCXHGbt9sMzzq+dXQjY/Ov0c++PpYE5cXUD2YvfZ0+BQaK1PR3BG6vfMyIZlMfdyjFzQf8l5ofxeb+05liaq0gYXiD+P1LlFxR7r+talNe5APK4ahKPJN5dqVbK18kkZXiZfNSJI8sdLfpyezP1tc8dBfRLFCTjzLg71oSyZ5X66HitPm6TIvSMmP9Flsd4cxajZPvyA0S4Xm4aRSMKXJKU+N479uDWH9iKzM9NoJnQb3AjGnmHbWpZQr2SFDWPcqEPEajGGMNCN2atcZtHeZVobccU8u7RWgJDmLUnWzVUtx/khCk15daLW1asBevGJzRjTbX4Z8ysK711RccpAsitUps47AHjTAvOBnZFhfHcNZ92lLLuI0CtG1uCCWFMlOk7tC/++bEwmuMlHGVWEyVizYrEADCwQVqKTf5zJ2VNioJ6foRS4n8PegHc6A0aBfGzPV0YHXzHcEyGCigRNBxBp9whGHFmfmH97Zclm/Fq3a3LHLHTbGfxsTTib3B/b6pSQ0RxkovG12jQeJel2VKE4uOHNZHcZAKUK52Afb0ozhS4Yf+8OJ2gFHr5hlCvs423MAO2MEDBi0LeEG33++iZ+OAIAtiOk4N3qK3g4aWX0aC/OXH9x+6pZcLo+Wv6MhzqcLNogqE4EXgn/xLGsCTFFUJnhT3BKf1E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(136003)(396003)(376002)(103116003)(83380400001)(966005)(478600001)(52116002)(7696005)(8936002)(38350700002)(36756003)(6916009)(8676002)(316002)(2906002)(26005)(6486002)(5660300002)(956004)(2616005)(66556008)(66476007)(6666004)(4326008)(66946007)(16526019)(186003)(38100700002)(86362001)(42413003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cEQ5UjZYZGxZUE1KM25xaHM4dzQrSStXYlVBSnMwYXVhcVhrRnVKcUJDRkl4?=
 =?utf-8?B?a1VaSVY0cktZVmJWbE9vWGJURWt1V2FsQmZncVJYZWFack1BcitWS0o5bVJY?=
 =?utf-8?B?UEhKeTRMUHFDUzBkT1NaZWI2bU9haExPaStHN2tMTi8zYjRFRkxpRTJ6Vk1z?=
 =?utf-8?B?TVpJM0RPUXJVNmEvQmJiU1dkU0hKNHNRYXZYY2tqNFRiSzZ2T1NnWTQza0VT?=
 =?utf-8?B?MkdWT2VMSHRFMmE4akxPZ1lFZVN5STJUUWtXd0JxT1BYOWcwWVE2TkVKdE9z?=
 =?utf-8?B?VWNuT1l0ZEtmVURiMHRub2ZTaWhDcjd0T0tQUU9IYTRlMHVMeUs2dHE4WHpB?=
 =?utf-8?B?T3pTdE1qcEJVYkdHa3lqQzFMT2RzRTBxS05PL1RmRUh2a3I1MGJDdVpLWndL?=
 =?utf-8?B?cHRkVU5lWGdTQ2pRdE4vYm5TWE51VFd6WU0xVkVLVkRUM2F1bmc2a3lSVVJi?=
 =?utf-8?B?TUsrSDJxZVR6bzBjUlEwTC9wMXVaNE5GVUFBcEQrNnlrM3N3Q2FsdzR6THk3?=
 =?utf-8?B?NEtSUlV4eHhvd3lKU3laQ05QV3FIdS9wa0g0L1lzaXllVWRMZjBEU25EWXd3?=
 =?utf-8?B?MnBWM25uQ3hQYTVnK0YzV1FxZEpZQTdWQkkwUEVyMFZjSXR3TDh4ZldJNEVU?=
 =?utf-8?B?MmU4MWZCZnNjVHRXNnEzRXdxZDdUNFZEZ3NITkdYVkNIbTA2dWhpdkM4Ym12?=
 =?utf-8?B?bFhSNjJLbkhnWXJ2ZUZ1MnJZcUVZZDBDK2dTYkFsVlNFUUxPSVRoSGJ4TnVs?=
 =?utf-8?B?K2JZWUxrbGxNME5ZcXUwU05rWTlqblBtVWtEK2dKNDNXaDFSTXRGbjNKdUZw?=
 =?utf-8?B?ZU1ZQ0VYazhsWGxiRERPdkxXUklFNGkrdG44U1dGZ2VodlN4T0FNUXo3RTN3?=
 =?utf-8?B?a3N3MmpKd0p2TWdDUSs3RUxZd0NOQklXTGU4d2RLL0lXemZDUGVueVBjazdW?=
 =?utf-8?B?QnZVYmpseTRrbHh6NFJCbFlkYmxjMzNPaXZEVTQ0Q282ZnJlVitUQ29PNnAx?=
 =?utf-8?B?ZG9DRG1OQ0p6OHNSWUZHVDcvVThESmpnRWlmaEdNRjBubFFhY2ZSQXgrbXZ5?=
 =?utf-8?B?SHhzUGo1RmU3ZVc0bS9WMDRZOUx0SEh4dlVGdll6U3E2amhPMEpwcXVQTUdj?=
 =?utf-8?B?WDhGeU9HK2ZXbHJiZGtyTW9FZE9wQStvTmR2dXFEcEpVVEh5andwa0dhSlJL?=
 =?utf-8?B?bHl5ZUgxKzFaamJ1M1k3RE94YnlsOU8yZWpwUjdYYXRVV05aL2JLcWhCNFFw?=
 =?utf-8?B?ejZjQlJ2VTZWaU51WUJ2emxUYWRUbW14cjNrQ0dFTXZjM2ZZNkNON3BNUjZC?=
 =?utf-8?B?Q0dwWWtjbzZydHlYWHFXZGFnQU0yYi9Ic011aDNVdWpIMVBWbFZYVEx4Z2FX?=
 =?utf-8?B?UE9ZUXZOcUtNVlBySFkwKzIvYmh0UGtsVjJnU2w0VjM2cTBvTHBkM2tjS2RU?=
 =?utf-8?B?TFNxSlBKTTBFTTViNHlkek1NUHlrWjJGSjNKenZMc2lteDdxaWVsaGhmcnVZ?=
 =?utf-8?B?aGE4RnRzOEdJL2RBTWl2SjloYXhZWjlmV0d2U1JPT3FNVWdGYmZaRHBmcFE1?=
 =?utf-8?B?VDlQT3pFUVFzT0JjcmYrTHYrM0NVSzIwS3JUanNGM2cvZkd0eGlTd0FxMmJw?=
 =?utf-8?B?QVEvUEszUXBMcW1hNWZYc3FLYlpNWkh3aDdYOExub211WEhoUGNncTdCWmlW?=
 =?utf-8?B?UCtmaDBKQUF5S3B2UUJCSFNNZnZMUmlCY1ZlMWFWc3pJSEpCWVMxY082ZlhP?=
 =?utf-8?Q?pEj+aO6q6F4nRQdDLwmIULekSAskO7I3Ecm8CCL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba5777ef-6126-4c99-dd6a-08d92a2a48ae
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 03:05:34.7561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IwD9f1iiKwoE6ZgSbhqebkjWrv4tg3nyKeEPwD6v+H7vrsQqzqgJCv0/uf8q8kcovkC3BLpeBwyVXfD1NaG7veT7YtTwE4947WfN4CJC9N0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4470
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080019
X-Proofpoint-ORIG-GUID: AycfXWbU36xPW2Vc8uWuzfPxjQf1Dz1X
X-Proofpoint-GUID: AycfXWbU36xPW2Vc8uWuzfPxjQf1Dz1X
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 20 May 2021 20:55:21 +0530, Kashyap Desai wrote:

> v5->v6:
> - Removed special case handling of REPORT_LUN (Patch #5) - comment
>   provided by Hannes.
> - Added Reviewed-by tag from Hannes,Tomas and Himanshu to appropriate patches.
>   Addressed below feedback from Christoph H
> - Removed meta-header mpi30_api.h
> - Drop the leading underscore from the various type names.
> - Removed history and extra information from Copyright headers.
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[01/24] mpi3mr: add mpi30 Rev-R headers and Kconfig
        https://git.kernel.org/mkp/scsi/c/c4f7ac64616e
[02/24] mpi3mr: base driver code
        https://git.kernel.org/mkp/scsi/c/824a156633df
[03/24] mpi3mr: create operational request and reply queue pair
        https://git.kernel.org/mkp/scsi/c/c9566231cfaf
[04/24] mpi3mr: add support of queue command processing
        https://git.kernel.org/mkp/scsi/c/023ab2a9b4ed
[05/24] mpi3mr: add support of internal watchdog thread
        https://git.kernel.org/mkp/scsi/c/672ae26c8216
[06/24] mpi3mr: add support of event handling part-1
        https://git.kernel.org/mkp/scsi/c/13ef29ea4aa0
[07/24] mpi3mr: add support of event handling pcie devices part-2
        https://git.kernel.org/mkp/scsi/c/8e653455547a
[08/24] mpi3mr: add support of event handling part-3
        https://git.kernel.org/mkp/scsi/c/e36710dc06e3
[09/24] mpi3mr: add support for recovering controller
        https://git.kernel.org/mkp/scsi/c/fb9b04574f14
[10/24] mpi3mr: add support of timestamp sync with firmware
        https://git.kernel.org/mkp/scsi/c/54dfcffb4191
[11/24] mpi3mr: print ioc info for debugging
        https://git.kernel.org/mkp/scsi/c/ff9561e910fc
[12/24] mpi3mr: add bios_param shost template hook
        https://git.kernel.org/mkp/scsi/c/8f9c6173ca46
[13/24] mpi3mr: implement scsi error handler hooks
        https://git.kernel.org/mkp/scsi/c/e844adb1fbdc
[14/24] mpi3mr: add change queue depth support
        https://git.kernel.org/mkp/scsi/c/0ea177343f1f
[15/24] mpi3mr: allow certain commands during pci-remove hook
        https://git.kernel.org/mkp/scsi/c/82141ddba90a
[16/24] mpi3mr: hardware workaround for UNMAP commands to nvme drives
        https://git.kernel.org/mkp/scsi/c/392bbeb85b2a
[17/24] mpi3mr: add support of threaded isr
        https://git.kernel.org/mkp/scsi/c/463429f8dd5c
[18/24] mpi3mr: add complete support of soft reset
        https://git.kernel.org/mkp/scsi/c/f061178e0762
[19/24] mpi3mr: print pending host ios for debug
        https://git.kernel.org/mkp/scsi/c/71e80106d059
[20/24] mpi3mr: wait for pending IO completions upon detection of VD IO timeout
        https://git.kernel.org/mkp/scsi/c/44dc724f5eec
[21/24] mpi3mr: add support of PM suspend and resume
        https://git.kernel.org/mkp/scsi/c/2f9c4d520aa6
[22/24] mpi3mr: add support of DSN secure fw check
        https://git.kernel.org/mkp/scsi/c/28cbe2f420d3
[23/24] mpi3mr: add eedp dif dix support
        https://git.kernel.org/mkp/scsi/c/74e1f30a2868
[24/24] mpi3mr: add event handling debug prints
        https://git.kernel.org/mkp/scsi/c/9fc4abfe5a5f

-- 
Martin K. Petersen	Oracle Linux Engineering
