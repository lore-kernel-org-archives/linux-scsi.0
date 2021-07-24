Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48256C4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 02:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17A3A60EBA
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 02:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbhGXBeh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jul 2021 21:34:37 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:17836 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233618AbhGXBeh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jul 2021 21:34:37 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16O2BMfc022482;
        Sat, 24 Jul 2021 02:15:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=CfxS5rSufVCqa5kLbVeWZq5oO8h5WgvnKZDD8eZyPJQ=;
 b=phcaZO4vBYRVf2f+e9etFJw7lZBJTeVK4f4NA9khiFRbXcmeFkRLpsQFLzAnuR6qwZdg
 0On7gXJbC1c4RuZ+7Hhzg+6yLEmAOdfdxH1XwISes4N3S6BFR3AGZd9IqudJHqo7x0On
 feQT5i/suNrFaK64/+1zVdk2VVU3NTeHPh/bI7gtT9gCg14hAADbTetvqpk9Zf7d7GT3
 JBh09iC5bb8mhHr5T3Wkzfv8GIlimqlLlVVwUzcp6kQj3xlPStYrx+JS4lSTo94x6yYI
 1jt+TR9lIFsqZy5dfGmyAB3ZIoXLtACzK22Tt08I6V0rGzudNU8SYetRUylLK1q41HSl hw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=CfxS5rSufVCqa5kLbVeWZq5oO8h5WgvnKZDD8eZyPJQ=;
 b=E1/AAejhPQg2JZ5+qyv13ScQcoVjllAtaoglUlZ+zWPoIS0mGd21AUQJF8ViUjhm9cwQ
 3SxnBKiv0ck3qwCekHIMLmYHaFelLeok3zSYe/GenMOYaVXt3h85qUEOvHIVWhcH/YuX
 mNCQ3+WYu8Znd0jZZ81YzohYyKIB74hKn8l+PweFf5YTtclzzvvWKM6Qthjq4Rs8jRSf
 1IeNvzvoHk59UrDkzMQgSFxuz8mzvWz81t5crL+7wT8mKH62qkItcl09w4CuGYlGVm0I
 BETvv4TF2hkQ2C9xAuMY5b3c07t4DhzHFz5SroEpMKnLmXa34drsXBGPQjt/FsdqjDkE sg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a09f1g0h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Jul 2021 02:15:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16O25RCP188061;
        Sat, 24 Jul 2021 02:15:07 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3030.oracle.com with ESMTP id 3a08wb21ed-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Jul 2021 02:15:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g96DSLvJM5xv6gNtqg4AH1CBf9DcJUIPHoMkRam3uRaxUUFv8ioYIM1QHX3slSNhGyh9yfXUhCP7qs7Lh3bTx3N6D1pDM2HPgO4GHecAqWcSRAh82VPVSb1/B3FGWhDtq25rSvlw43HwezzPG+yaQ2rB09JJklMX1sko7bmRg32E5i4vixzKl6+VWp3FxUX1RJpV2ZbVYljsBDqeLgr4DESWVxWyUOElRhG0QEaiqnEJx7qx2EzjdZZ1JzL3LNWi/fzc43ogl0RdotcSBEoNyrhNTLFzZaxWzkS3FdXfjwch3H/v6CZiC1/ARUP+/fe9wfKTwC5hm+VGjS6sz0RhEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CfxS5rSufVCqa5kLbVeWZq5oO8h5WgvnKZDD8eZyPJQ=;
 b=cAiQ3sLS7y7E+NXwk7WXiNPsW3rfi3ckgWTg7TPO8hemO+CPtFnkIagjj7MVOdi4EwEfptUxRLuwWK5AXkqaPH6/0tEIAwGp51dgLhXZaBxGIPi8nyFV4YV0IXYdTIKSidiFy5UNqnikJ7PSiMtAE008e/LzhMeOSnYcISMF5ILSYOO1eftIU5B2UmdgaHjxHHFRcitBtaB44/kkElB48yQcR3QW9yI1hadkU7s50MRkVw32cFoeK4abciyfPi3ZpPVnJYNysDCMNBakJZdGdxlI50SJtCq2zjoww3SQAykAPtpBt6Lqqm9DBON+II2YvAuaTzqCITYrYqSuTI3fnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CfxS5rSufVCqa5kLbVeWZq5oO8h5WgvnKZDD8eZyPJQ=;
 b=YBkXeWrwZSr5QPfCzREPc5WcVMd27ZW0GXbvjdT7zI8bZVanGM4gejTxK1qTxOgAUXc4rYdGWQZUGs72r6rofgWSP26j4AwfetYNWZYMr1UlHNXXGsEIb1WKp31ylDMtEldYN/RGJLxGs1TEbc16GKIKPC7BnaQv2YA8fIxtGi0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4647.namprd10.prod.outlook.com (2603:10b6:510:43::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Sat, 24 Jul
 2021 02:15:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4352.029; Sat, 24 Jul 2021
 02:15:05 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/20] lpfc: Update lpfc to revision 12.8.0.11
Date:   Fri, 23 Jul 2021 22:13:52 -0400
Message-Id: <162692235523.25137.8345126369260622186.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0023.namprd05.prod.outlook.com
 (2603:10b6:803:40::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0023.namprd05.prod.outlook.com (2603:10b6:803:40::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Sat, 24 Jul 2021 02:15:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d55d431e-7754-499e-29c5-08d94e48d9fc
X-MS-TrafficTypeDiagnostic: PH0PR10MB4647:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB464726390D4BE5E7F5A494CB8EE69@PH0PR10MB4647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r9z6KmERDBQpD0NiXxEosLrwACfvjzgh6gdLAVGBYwP5R9LN+NgpCsuaXDzWLtu/h2MhSt+pVuaOz2KIItxFyDrUk3UkyXrc8AYyX0MEieQFaxhMmhhHmJMykh1ZDHa9reeqsri2/EkHhAYG4ZUboKV+vuVXMfSgJPYsmHrEQg6NIefgl7ZjnMr56s2VojnsSJ3Ksu85PhQa3vqCTVYk1Y1TqZLhp+oTPUwmHPWUEukAF0N/WjIwtgbVQEqdeePWOoS9ylTJ7j0DbAldUT9jDoNInhjA4ufDKHzB96zsifu1HIld5g0U+JDY/0Q51rj31kUE+upf3PGX6PcSFgNZJXbjSrcWNRwpBSAT4eukHI4ykhKmNM7pQ8nLC41gDGHyLCsjR+72bX9XcAU/9C3q48nHHLW0TAJ57F0Pixbk8yRjvOr1VC+RhcgVD1aLEKytJefr/KlfB8PlcdBRIP6/DDQOrBVV+tAV44Wx0TnAU0g3X8lit+jdYXAfAzG9vflaPHBWZj4UR9+voBAhKjsOfy4i73d9+m6xfkB5mTY0t0VO7/s6GNPutHrMA1R6VXoos6NizEn9mNKXuGdlNcpV9s2oP6gEcFHNW2Ef2mqEMgCQygLNQmSdo1zcOclKNX7VpoIX2pHOCeq6hpyjZ/wboslMEcZbh7GwwQ8JdhY+9bZ2aOgAqsjWxgaZRZJfWfu0Rnxrz0F9TfjOxN/upm179X1Rpc2jh/xIJb5ZnLmlv8Ioyu3grMCG9ee2rTz78inn455gLFQkenB0sI1FdJe8fBqigGfutqEQ3MpW+41YBQCnZ1uz0Pi+EHrCG2y4yQ/1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(136003)(376002)(366004)(2906002)(6916009)(52116002)(7696005)(83380400001)(5660300002)(107886003)(4326008)(316002)(6486002)(38100700002)(478600001)(6666004)(38350700002)(15650500001)(86362001)(956004)(66946007)(966005)(66556008)(8676002)(186003)(103116003)(2616005)(66476007)(8936002)(36756003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3BUY0tqOFpHYUhDbjdKdTJHMitzK3AyZFBFbU1wQVNxSUNGVkowRXJpYW9V?=
 =?utf-8?B?QjNIbmpXMmkwbDlub2J5a1Z4ODloVGFWMjlLVHBwM3JIT0VTSEtkTytScTl0?=
 =?utf-8?B?RFNGZVBZTHV1c1J0dDJoV0lEbXBYMWcwK05HRGV2Zi83N0h0cDJXWEwzcEF4?=
 =?utf-8?B?Nk9hbk5QTURRZkZJUU5NeWdnWDU5QmF5YW1YZmFIakRhLzBoRjc1cDBCbGlY?=
 =?utf-8?B?ODZWT3BhbURWQmRkb0lxTXpnNCtQWFFFb0g0Y1hHL0FPeU9vT2t6aUlTMFNQ?=
 =?utf-8?B?RkJLa1hjQkhUbjF3a1N1d3paeEdWVkpWZjRMOU15UXJueHFycTdTTzk4Qks4?=
 =?utf-8?B?a2I2Y25YcHN0cFltNGVrM0NmNUd1aHZjbG9Fb1l1TmlPaHJwOEd4WFYwRWNo?=
 =?utf-8?B?dmFVTnhBME1XckVxeDlqTWlmaGNVYi9mRnUzVVlybmRBZTJBTWtXajZ0QXlV?=
 =?utf-8?B?aHhaeWx2d3ZaQUFBbVRZZWR3UDJ3LzlVaWlqK045TWpQMWNTR21acnI4Mmhx?=
 =?utf-8?B?UXpnV0QrNldHTnNBTUVHdXFXUnlHWExNdXRRT2tWNEIzNmNCZHoydVFaVmlh?=
 =?utf-8?B?QWZ0dkJTM3hhMkZBR3pPODkxczh2cjBhRVBYckFQV0grKzlXNldHZVNwNDF6?=
 =?utf-8?B?SWNOSWNma3pINkZSY3kxM3lzZDBXQitBTHEzaVVxdFE3YjFjUGlHd1NObG5s?=
 =?utf-8?B?WUtFSTFoT0RzNllpeEwvSUI1eTJVSEZsZk1qSERBUHlVdkhZTE9hN0NzWVhX?=
 =?utf-8?B?WHZxMmRVMG1QdVZ2ZVZXeCs3eTRRTlQzbmE2bUVmS0V4NG1Jb3dtamNydnd2?=
 =?utf-8?B?bkV4RXdQMEliWVNycTZtQTZjbHpTY2pNMURrbHp1d2ZpOHpXVzhxTkhmS005?=
 =?utf-8?B?dWViRDQxdXMyRHF0S2Z1ZzRMRDdDNndGUGRHQkZESExOZURTcjZ3Y2orUTVI?=
 =?utf-8?B?TCt2ZWU1MUNVdE9jeWp0TC9kUnRadHROaS91YU5ZR0VKclM5UFh5Z2NrSGE5?=
 =?utf-8?B?TTMzQVE5NmlPeElnUTZnZTNON3U3bHlRa3Y3T2FnNm9OTWFnYzhxYnV0TVVS?=
 =?utf-8?B?VXFMNnJyd28rQ1c1Nm5GdTZEdEhiZTNiV3FEQTJhQ2h4OW9wbnMvUk0reFdY?=
 =?utf-8?B?bjBLWTdWdjQzS3o3SzN2dDRwbFhpM1IxYnBQV1F0Zy9WeFFFa01VbGlGMUpH?=
 =?utf-8?B?MzJUTkRyNGQ1b1JCcy9Qc3RvSy8zWTdoR0MveTBvV2MrbzhaRFRVRVNIQUFC?=
 =?utf-8?B?MXFQR09TZFl2R1lLZ0ZBczF5NWdLMWQyb2RPUVd2L2d4SlJjRndOVUVxY3U4?=
 =?utf-8?B?WWo2MEt2dFVSSGxIeW9VZVJ6OUF2bE42eGpWQ04rdzFtNkhJMWxyZU5kT3Fu?=
 =?utf-8?B?UXRTdkJ0aFlRc3hBNk10YXdjS1AvUXN6WWdhZnk3aUFtRFcvekRkZGRpdzN6?=
 =?utf-8?B?bUdpK2FUbCt3aUJXbEVhM0Y0bGs5b1lnZWVpTi84c2NPajNzeGR1OU53aG1h?=
 =?utf-8?B?cXhYZnNUV1JubnY4dkFhbURzbVBvL1lqMWI4Z3pwVTZkRDllckRaTzFIWmdm?=
 =?utf-8?B?Z2lTK2VlTmE3T0pGSy9iNTR1ajZ1eTJlVjVpTDdiekhmYWloRkU3OG9rbW1O?=
 =?utf-8?B?MWF2RG9jNjY1THVxNjBxT093ait3T0I5bkNCUUJRcnArajBCall6eDJBWUNG?=
 =?utf-8?B?ZUJBeFBqd3F4blY1c2pqVTNlNU5SR2tweHRDcVIyU2tXdmJKSHU2elhyeUdK?=
 =?utf-8?Q?no8xcH9NJmsL4yU4Ji/FeBYcR55GTTkvIOzntde?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d55d431e-7754-499e-29c5-08d94e48d9fc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2021 02:15:05.2813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JxKclPUhVeNk1iK9DZnQqj5jjIO5+MILQCc4mv94Lu9M6NMtthwZb1QA4PdN4agBcRfFW1Fid21pTbcqpukugxoWILlq4BviWx272SF4R9g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4647
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10054 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107240013
X-Proofpoint-GUID: PIdN4Rv9N5RB15QdFJoIJWc81aPOfgdA
X-Proofpoint-ORIG-GUID: PIdN4Rv9N5RB15QdFJoIJWc81aPOfgdA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 7 Jul 2021 11:43:31 -0700, James Smart wrote:

> Update lpfc to revision 12.8.0.11
> 
> This patch set contains fixes and improvements for the lpfc driver
> 
> The patches were cut against Martin's 5.14/scsi-queue tree
> 
> James Smart (20):
>   lpfc: Fix NVME support reporting in log message
>   lpfc: Remove use of kmalloc in trace event logging
>   lpfc: Improve firmware download logging
>   lpfc: Fix function description comments for vmid routines
>   lpfc: Discovery state machine fixes for LOGO handling
>   lpfc: Fix target reset handler from falsely returning FAILURE
>   lpfc: Keep ndlp reference until after freeing the iocb after els
>     handling
>   lpfc: Fix null ptr dereference with NPIV ports for RDF handling
>   lpfc: Fix memory leaks in error paths while issuing ELS RDF/SCR
>     request
>   lpfc: Remove REG_LOGIN check requirement to issue an ELS RDF
>   lpfc: Fix KASAN slab-out-of-bounds in lpfc_unreg_rpi routine
>   lpfc: Clear outstanding active mailbox during PCI function reset
>   lpfc: Use PBDE feature enabled bit to determine PBDE support
>   lpfc: Enable adisc discovery after RSCN by default
>   lpfc: Delay unregistering from transport until GIDFT or ADISC
>     completes
>   lpfc: Call discovery state machine when handling PLOGI/ADISC
>     completions
>   lpfc: Skip reg_vpi when link is down for SLI3 in ADISC cmpl path
>   lpfc: Skip issuing ADISC when node is in NPR state
>   lpfc: Update lpfc version to 12.8.0.11
>   lpfc: Copyright updates for 12.8.0.11 patches
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[01/20] lpfc: Fix NVME support reporting in log message
        https://git.kernel.org/mkp/scsi/c/ae463b60235e
[02/20] lpfc: Remove use of kmalloc in trace event logging
        https://git.kernel.org/mkp/scsi/c/e8613084053d
[03/20] lpfc: Improve firmware download logging
        https://git.kernel.org/mkp/scsi/c/16a93e83c87e
[04/20] lpfc: Fix function description comments for vmid routines
        https://git.kernel.org/mkp/scsi/c/50baa1595d30
[05/20] lpfc: Discovery state machine fixes for LOGO handling
        https://git.kernel.org/mkp/scsi/c/e77803bdbf0a
[06/20] lpfc: Fix target reset handler from falsely returning FAILURE
        https://git.kernel.org/mkp/scsi/c/21990d3d1861
[07/20] lpfc: Keep ndlp reference until after freeing the iocb after els handling
        https://git.kernel.org/mkp/scsi/c/4e670c8afd47
[08/20] lpfc: Fix null ptr dereference with NPIV ports for RDF handling
        https://git.kernel.org/mkp/scsi/c/2d338eb55b14
[09/20] lpfc: Fix memory leaks in error paths while issuing ELS RDF/SCR request
        https://git.kernel.org/mkp/scsi/c/cd6047e92c6a
[10/20] lpfc: Remove REG_LOGIN check requirement to issue an ELS RDF
        https://git.kernel.org/mkp/scsi/c/e78c006f4c88
[11/20] lpfc: Fix KASAN slab-out-of-bounds in lpfc_unreg_rpi routine
        https://git.kernel.org/mkp/scsi/c/affbe2442941
[12/20] lpfc: Clear outstanding active mailbox during PCI function reset
        https://git.kernel.org/mkp/scsi/c/a9978e397840
[13/20] lpfc: Use PBDE feature enabled bit to determine PBDE support
        https://git.kernel.org/mkp/scsi/c/137ddf038472
[14/20] lpfc: Enable adisc discovery after RSCN by default
        https://git.kernel.org/mkp/scsi/c/816bd88dffc5
[15/20] lpfc: Delay unregistering from transport until GIDFT or ADISC completes
        https://git.kernel.org/mkp/scsi/c/0614568361b0
[16/20] lpfc: Call discovery state machine when handling PLOGI/ADISC completions
        https://git.kernel.org/mkp/scsi/c/c65436b21c3a
[17/20] lpfc: Skip reg_vpi when link is down for SLI3 in ADISC cmpl path
        https://git.kernel.org/mkp/scsi/c/02607fbaf00d
[18/20] lpfc: Skip issuing ADISC when node is in NPR state
        https://git.kernel.org/mkp/scsi/c/ab8038608825
[19/20] lpfc: Update lpfc version to 12.8.0.11
        https://git.kernel.org/mkp/scsi/c/545a68e711ee
[20/20] lpfc: Copyright updates for 12.8.0.11 patches
        https://git.kernel.org/mkp/scsi/c/f2af8ffc63a1

-- 
Martin K. Petersen	Oracle Linux Engineering
