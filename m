Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E616CC433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Oct 2022 16:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiJAQT6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 1 Oct 2022 12:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJAQT4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Oct 2022 12:19:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F0A2339F;
        Sat,  1 Oct 2022 09:19:54 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 291CLSfV007841;
        Sat, 1 Oct 2022 16:19:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=HxjAHgQV4jRBqITxfCVqcrd191fnOB0ALzNNkDaOP4w=;
 b=tjtbmN3XWWTieMZiAURL5nMPsXQh+Ya2DApaa7Uy4BM6LYj0Iok6dlls0ggPWNOxk4GI
 BPDvTcfYPAxjlFv0B6t7ZQzWFicV9hQX9/RYyF1GI6RFdKW77pMp8HDmylXcFl5GMTYF
 PQ/aoCOf1k57vZ+Z109rrOiAtsmv0a3RzuDnQfUtrzMGUZn9QSaokcrbHAEsjeR/MD7H
 vCGrbI52KJCNtPIHk6GDe4NeOLsHmuHS4ITPRAUdvqpbdQrOaBfTfIcIRY7cCmJtdS1h
 IVYYwfNI+OReP5g74ieqIjQT+LPYHogOU+KoJimrQF8fPP/le340nA9XsCpT7aC8dJ0l QQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxe3tgpnh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Oct 2022 16:19:53 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2919138n003433;
        Sat, 1 Oct 2022 16:19:52 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc07y8a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Oct 2022 16:19:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WnMYLMO7W1OCFiaJ+CHow1LKupkzB2sQ1VxiwtvpxiXfLWRLw8FzPLHDyTSd6Vqh4NltrnAn+b8wnmvIBxpQvGcAXX1/KT6cKQHY8P0TSChj1doShL79Kr50SwSrRMl+w4Hsa1Zi3SuhzVJkqK+cWS1eP0Dxf4AyyTqMOa5kufIyvW9s+fJMji6UyLZASOhjEgwYVVPXyjuHyGM8zGY5PvA1F1RwyTp21p1cuLJte0FZeWaqsIWd03N23uwztNRrvCwE5Y0goxis3BOJPTyC4V4mvcy8weAxNl+mr6gOH2MloPNJ2Znu5MgozpaH+85TmevnCF8AQk9n5E/Lv2AWPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HxjAHgQV4jRBqITxfCVqcrd191fnOB0ALzNNkDaOP4w=;
 b=CzS6Zji3Vft6rGIPVd3FaXIcvtlsC2C26au+8DoRIe/zUmNZQl27CCB+Cs8UiUcfq7O/ngGvZ1tk+SmeDN3KPKmZ1XNqUuYiohq9x4UaKdibwIuxzsATX/df2PYjShK0kSR7Iv/QSSYieD53PwomZN5MT0Z1CL2gNE8XphYSUmGaCy+wXMqgazWXpwSuTx0XLWd7FQ/KSCzqq6Hd4Etwnx32bI9fBf42nrCJQiKC/IyzNz8KsVC86sb3yevmyy8Atd3i4njx60CTqwKh1WEPxYdhYmc9pWVmliUgS9QxEyoKYQiQbcxAwNJ4swu9sYthF5RngzUDSxECuwN3+PHSoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HxjAHgQV4jRBqITxfCVqcrd191fnOB0ALzNNkDaOP4w=;
 b=awKoVk7Ss1vT8zbQMRiARd/NqbRad/s4PECvDzMFN0AmV/m6MHReVRecE1EUuOhlKmOL9VXoLQIs00OltTJ/m3O/pTocMvwfLtoKZ7qiFCUdT0oVqdQl27OcFZyn9/iXgmRNt5+lCmOMcc6+35dtrEMRCYpg91YH45j1KF+rQW4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW4PR10MB6509.namprd10.prod.outlook.com (2603:10b6:303:21b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Sat, 1 Oct
 2022 16:19:49 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.024; Sat, 1 Oct 2022
 16:19:48 +0000
Message-ID: <f4d08857-204e-f0ff-600f-8e8c87b6a02d@oracle.com>
Date:   Sat, 1 Oct 2022 11:19:45 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH 7/7] target: core: check RTPI uniquity for enabled TPG
Content-Language: en-US
From:   michael.christie@oracle.com
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com
References: <20220906154519.27487-1-d.bogdanov@yadro.com>
 <20220906154519.27487-8-d.bogdanov@yadro.com>
 <5f730538-6738-86b9-fefe-da09ad9e0a47@oracle.com>
In-Reply-To: <5f730538-6738-86b9-fefe-da09ad9e0a47@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR07CA0009.namprd07.prod.outlook.com
 (2603:10b6:610:20::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MW4PR10MB6509:EE_
X-MS-Office365-Filtering-Correlation-Id: bab7abcf-fcb0-4062-3ea8-08daa3c8c2d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JIgvI/uiu0ZCMLzJmFiPHtexaCjlCCXu78GuTY38GvAB9G/KUya0nmkgzbOmabMWsqnxH3xoxBmGYMcZ762IEIkFINs9X34VlWuKKorWgEcHD8hERpRDAd3bDZYCskwjv7I6H04HBj64aVeHhbMmt3L0ofo+jEgZ9EdgyaykRohC0xadwrubV+6KWUN7y013sLdqpAZAQCOgICka8qOI5C12rjYUXwbgy5Yv3IgqyfKxkB+6tGr4HZzlvmGb/TBA5540t5OfwCK0aAIcukWv4LSlCDQnof42/zSXoeHL+jxZ2LkCLgKbKZZ4oREf3McFSTUz9JDItbbj1CFZfAZqKCMkkO4qUcUU32v7sCGtNTJPRjJJhUACcLtHgxjRGX/WuckKH41Y1sY8wjCTQK8z234UjEcfAjLbFzk55PDhuL9lc22AyvmUdSuYRWIskmCuucnVeBEQtq6c3zbWV13pmGaEHJiMcz9eM6HwZa6/FFilbeUYRr3L0HUshnXLV5AQJScTEG8Z1fk5U/NTd+qZGTWiTDX57CRj0dhIlq61w4oyJpV4DmJhY946c5f6e9eFE73Q2IDVsgr+6hijU8mzVs7Y2cwQTZMIPC0mT0qzMfqGq+KdTrJ/ySiE+SWvlwitD3yhS3MJAaTDxJwj3dzGbHDQmP4J1oJVUO7cMIKcf1OjJQuDUSLxePI31HpG+qGUmu5+KnWl/UNwiqhN2bUPcSZjCPqRAJ11hTpPoemBj+6NLl/1nuuPWDrxIU6UC7YTEZ3fUeJcvMPiPYDipjgzrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(376002)(39860400002)(136003)(366004)(451199015)(66476007)(9686003)(6512007)(38100700002)(36756003)(8936002)(26005)(478600001)(6486002)(5660300002)(66946007)(6506007)(6666004)(41300700001)(83380400001)(53546011)(2616005)(316002)(31696002)(110136005)(4326008)(186003)(8676002)(31686004)(66556008)(86362001)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWpjUmhha0NEZU9WR29oTmVENEhmckZvRXFyd3AvcFV1NTFaaGwzT0FzaFdP?=
 =?utf-8?B?WUVUL1RDN0ZRR2d5TUZaMWtTQWlCU2ZLTURWa2Z3SUFlQWc1TWEzVXI2clVn?=
 =?utf-8?B?QXFhdmwxR2VRUlovV2dCcWxWNEo2NlQwRkpZSmZSQWFrQzRmVGJqTFhqbnNX?=
 =?utf-8?B?Y0ZIYzNZNUdVaEF1V1ZITUJkbDlEakJVelBma3JMUlNnaTByc1F6RGlVWXhT?=
 =?utf-8?B?TnE1NzdabzRsNHpsNi83Z3hISkRvenBSYnd6aXgxR0RLUkk0VXhGdG85Skt2?=
 =?utf-8?B?NWhyaXpqeTNrWHc5UW1qS3plK0ZnVlprbkZtdG5tKzNXN0QyalpNYURjeDZq?=
 =?utf-8?B?czNIUzJTNVZYMW5veHp5aG5mb1dCWUU5T1hsN2laenYrZGN0OUdBZVV0UDVp?=
 =?utf-8?B?TDdSZEcveHlnQU5mOXRDc1NlYlZ6b0QzUVliMVRGODFYdGpGWlU4aEZHV2xj?=
 =?utf-8?B?Uml5TTBuUm03TGpZN21GNGYxVG5GSFVSblY3VWpEUmxWQjd0WGpIdzE1MTl1?=
 =?utf-8?B?eXdSVy8ybCtSWDRmMzhpQVpqeTA0dkwrN3g3NDY0Z2xtNHpKYWxyclBDend3?=
 =?utf-8?B?OWQyL0ZwZE90cFJ4cE9aY0NZMGYraC8vUHNHWUlPS2g5d1VXeVBueDU4YmJS?=
 =?utf-8?B?WU92bkRXM05BMTNFMGM1bi96S3hDZHF4dFBVbjhUOEx4bTRveUxVdXNpdDJY?=
 =?utf-8?B?TjhqelNjelh6VEV0b2pGZVI3OUVkRkM1dzdxWFRtem9QN3M3RmlXYktLTG1E?=
 =?utf-8?B?UmNweGFKOUFkVjlpTFp6S2lmZFJCZGlmL3pHdWJITWs5ZUVrRDl5L3lTeFYz?=
 =?utf-8?B?UUt4LzlYeFU3V2hWdmxmMUo5ZzhDOVZQRjZsZGc1RVYxSHZhQzI5aUM4QVVD?=
 =?utf-8?B?Unl6MEI2QzRzeWdWNGlvY092Z1ZvcTh4a1UvanBlTC9iVWpPaTZwWTU3SlZM?=
 =?utf-8?B?WHVweEhwbkN4TFY5VHhJM0JmVE92eUsyMGdnY3RqS1dLdG9PNG1HdFVYSXg5?=
 =?utf-8?B?Z2RQU3liOCtzL0FKWTdTTXRVSVZ5eFEvcE5NRWNyV0tKd2N1Zk80TDZDWENL?=
 =?utf-8?B?L0R2MTRWZ294cHdpQTc1b1J6UkpxZUtzL2kyZGlSTHlDVUI4ZzhjbEN6Vkls?=
 =?utf-8?B?U2FCb2htdFRRU0FjV0JQVVd2UE4wS2JackJNbDRzNjNtdlBQSzVMb1draEhH?=
 =?utf-8?B?UHQ1MzB5TzgzV2xudUN4ZXRQQlhBK2J6SlEyOUgzOW5QYXIrd2VRMzZmTnZs?=
 =?utf-8?B?U1FTZFZuZjd2U3dWeVhOcGVyYm9pVXljd3REYWVuZktMb1VWeTNYK2JiV2RB?=
 =?utf-8?B?eGxSYVNnZHhNM29JbW1HN0IwWW5pVGVGNXNPYnhqTHIxWEFZbjkwSzNteHRF?=
 =?utf-8?B?TU9UQmJNOEViSkVrTmV3eGtBUEF4ODZuYXlJZGJNdEd3ZG1kK3dWeWFKYUpM?=
 =?utf-8?B?VDBUbXEyMnlmdDY5NkFuWXlQTGhOSHBhQTVKTjh0MFF2Zlloc2hWOThRYmZi?=
 =?utf-8?B?YXh4MHBjQ242M2lRM1Z0WC9NaGlGRlJzeHRyeGZ2b0FtcmJQTERJQzg1azhu?=
 =?utf-8?B?NTlTVU5mMFJkNmtSbTVETzRhNy9XY3JqOEJOMFhUZWVNYWNGZmg1WVU0a0RZ?=
 =?utf-8?B?UVpEYkZFNEZtcEtzN0txZlBLbFFkcG5zamxid0w2c1JhQ2tPRVZ5UHhLbXVZ?=
 =?utf-8?B?OUZhY2xyQnl4dXZDZTRTZVNIV05IdklFeVJleFZxcGt6clhDVkM2Y3o2NXdu?=
 =?utf-8?B?WFpDbFlWRlc3djMzNTZvNUp6T3pLS0loNUYyUlgrT1duWWlUSnZ1S21CRjV2?=
 =?utf-8?B?VCtkdGJaZWo4WEg0c1pQTldQSG5meFdSUjFiaTBLeGMzaHdmVDZYTmxMWk1x?=
 =?utf-8?B?Q0lzcWFxejJtUEo0MUZmbFUzaEVTbjF0TlBNeDRxUHE5di9XVnNqa0pGMkN0?=
 =?utf-8?B?ZVQwSks3SFFTUE5ZVk13UTlUUXFSUTJzVVk4TzN2M3F6Z09ZZHFNUkhHcmVr?=
 =?utf-8?B?U25CT0FQbE90dFFZTlBVSXJ0OTF0c0JEaE52djNieGVJZ0lSTVI4NEFqSXAv?=
 =?utf-8?B?ZWZBMjFxcnhkRU94Tk8rbFcrQzJOUkg0VXhoTGkrQU1FUThJTlNJUnd2SkdB?=
 =?utf-8?B?WnlKZnhvelZ1QXlXSndVNGY0SmdjVTZyZU1UVDJuZXVUSTE4clNRVmhpbWtZ?=
 =?utf-8?B?QlE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bab7abcf-fcb0-4062-3ea8-08daa3c8c2d1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 16:19:48.6594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hroAyUGmlVHludbj49qJSbpyMioxDwCODDRt8u40v7GmfbRu1715J8kGffxgAXRW6dtdd4l0RpnUhHYCZQl1f7gIZSbmz3GVtumHMYighkg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6509
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-01_10,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210010105
X-Proofpoint-ORIG-GUID: aci0gmC2vKzG0f_moZISaceIjXveoJ0q
X-Proofpoint-GUID: aci0gmC2vKzG0f_moZISaceIjXveoJ0q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/22 7:02 PM, Mike Christie wrote:
> On 9/6/22 10:45 AM, Dmitry Bogdanov wrote:
>> Garantee uniquity of RTPI only for enabled target port groups.
>> Allow any RPTI for disabled tpg until it is enabled.
>>
>> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
>> ---
>>  drivers/target/target_core_fabric_configfs.c | 29 +++++++++++++-
>>  drivers/target/target_core_internal.h        |  2 +
>>  drivers/target/target_core_tpg.c             | 40 +++++++++++++-------
>>  3 files changed, 56 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
>> index a34b5db4eec5..fc1b8f54fb54 100644
>> --- a/drivers/target/target_core_fabric_configfs.c
>> +++ b/drivers/target/target_core_fabric_configfs.c
>> @@ -857,6 +857,7 @@ static ssize_t target_fabric_tpg_base_enable_store(struct config_item *item,
>>  						   size_t count)
>>  {
>>  	struct se_portal_group *se_tpg = to_tpg(item);
>> +	struct se_portal_group *tpg;
>>  	int ret;
>>  	bool op;
>>  
>> @@ -867,11 +868,37 @@ static ssize_t target_fabric_tpg_base_enable_store(struct config_item *item,
>>  	if (se_tpg->enabled == op)
>>  		return count;
>>  
>> +	spin_lock(&g_tpg_lock);
>> +
>> +	if (op) {
>> +		tpg = core_get_tpg_by_rtpi(se_tpg->tpg_rtpi);
>> +		if (tpg) {
>> +			spin_unlock(&g_tpg_lock);
>> +
>> +			pr_err("TARGET_CORE[%s]->TPG[%u] - RTPI %#x conflicts with TARGET_CORE[%s]->TPG[%u]\n",
>> +			       se_tpg->se_tpg_tfo->fabric_name,
>> +			       se_tpg->se_tpg_tfo->tpg_get_tag(tpg),
>> +			       se_tpg->tpg_rtpi,
>> +			       tpg->se_tpg_tfo->fabric_name,
>> +			       tpg->se_tpg_tfo->tpg_get_tag(tpg));
>> +			return -EINVAL;
>> +		}
>> +	}
>> +
>> +	se_tpg->enabled |= 0x10; /* transient state */
> 
> Just use a mutex and hold it the entire time if 
I was looking at the configfs code and am now not sure what the transient state
is for. It looks like when doing a read or write configfs holds the buffer->mutex,
so I don't think userspace would ever see the transient state.

Can you just drop it?
