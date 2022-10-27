Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61105ECAAA1
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Oct 2022 17:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237032AbiJ0RH3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Oct 2022 13:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237031AbiJ0RH0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2022 13:07:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC3D199F5E;
        Thu, 27 Oct 2022 10:07:25 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29RGDvqi014958;
        Thu, 27 Oct 2022 17:07:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=U1+yrQLzCcfM51BBXz+7WAuR8mhiDs2aoI/3DN2jJ/0=;
 b=VxNW/UmLy7c12CZe8fX6GHsZY4Mnj4pnjltD2avDN7Cip/5UCztOp0Ed7uN375Eav9km
 wRpUt15FWXbSDRwBP2krTsLzrcHRfz3k05w4MuWGUZapjfObrRh2E/eL2atgJh9AwBZH
 2cBD1MTRVV1M8HTb+VFnwuNre5/U8XG+vdD44X9QgvT0WLvwnD7nvonAayUmUK6/Itm/
 4Is6tlUexwi2C0mpspKVFedIAN36W0Aw4WxGslZJinaZGyPA4vi1xKJ+2+itGMTX6XkA
 tCIGd00LCfrtjQvrX0YouRktRd6xKe7siFUR8LKvFMLRkR1a9PV/lBVZf/4feIBJLkVA cQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfax7tktk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 17:07:03 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29RGEwie012294;
        Thu, 27 Oct 2022 17:07:02 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagr6ngt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 17:07:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjFENzzpOt78vcul+zyqomj4AqB8jjuDZIRfcJEQsCb6/AJYKzk33OKvIbMG4fUw6rKpcl+jLZi/Px7Ild0K2AiHLqb0iNsDs7Kd5WbcnIDYJrnqKu6WUwx15QTUlCkxDBT04Ki4sZpZ+mcei9uNxouvxqrq8/oZPB/nMrNDSZOFSQ6uhjHD8Na/lAkfoQpaXCo8BJeJPe/PahnQ2/fAYpiipsn3KmRfwckB+jRctDRuab+Y2aSbfjhbKccj5IKobXcjguAowde27CWZzrrv1qol+23ctjwVUHykoX9BSD7FmhPQvZA2idEcitxSF5D+qxdwQDNnfnoWzfNqhyqD7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U1+yrQLzCcfM51BBXz+7WAuR8mhiDs2aoI/3DN2jJ/0=;
 b=eNTMM3ArmxI9EuTu0iHo4ZWRlN8aQtzgj8/YCL4RxlBDmRWqdKv4qZNGCQ9PYzbdNo2npyvOkrvzaZHBdYZdJaF5HCaRRf69bKFLJ+qct9DbVaMr4Z6qUAC1fKXsbvVT1GyouXiwxXeRMvwkT6tNnmAy/qsICj/Luj5bji3P8rwuxjmziQrezVhYhe8huLOhG7rF/6hBDzAKm0zBLv9ibZ/shClfGSAArm+f5Mug1q/ImpJD7hzwAQVAutZhpr1I30TFYKnjDxJvkYQ7vc/5hPlpTAtITcGmangxRreZljIJ/ycMuX28XhF9hxHV3Tv99uyX/GW/yfKblf2TyHi2Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U1+yrQLzCcfM51BBXz+7WAuR8mhiDs2aoI/3DN2jJ/0=;
 b=0KByCJj2aa2sNClLa0eFu2kZBFGc/Us6sZvV1WtIuUF1gdcKRRunO8VICmutMnN0Yag5v4QA+HUOXQTJUUPf7NdbC3YgiAcaRLUsnb093yp70S899bZP6Cje7sVbid9Cc2bft4fZSaHrN86GVjBlPQD/WeMaruygnlJO11oSnf0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB4253.namprd10.prod.outlook.com (2603:10b6:208:1d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Thu, 27 Oct
 2022 17:07:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 17:07:00 +0000
Message-ID: <a74266ce-3839-5d2f-abc4-cb30045d811c@oracle.com>
Date:   Thu, 27 Oct 2022 12:06:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
From:   Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH v3 10/19] nvme: Move NVMe and Block PR types to an array
To:     Keith Busch <kbusch@kernel.org>
Cc:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        target-devel@vger.kernel.org
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-11-michael.christie@oracle.com>
 <Y1qhXQYOpEUk2uqF@kbusch-mbp.dhcp.thefacebook.com>
Content-Language: en-US
In-Reply-To: <Y1qhXQYOpEUk2uqF@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P223CA0028.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MN2PR10MB4253:EE_
X-MS-Office365-Filtering-Correlation-Id: b8ee6fef-a1ac-4e64-2f56-08dab83da99f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TFg7RGoS5dnbX8EoSZwuweerl4w1jTtCYkDJ6Z7NK/iQYFZMYXohhId5UFa7ezBj1WPU0CbQbVZK7hwMM/lpr9eT0cCufWBlYvkHiFMLK2D4gKC6pXaPuft0Shc4c2rIACSwA4NVmOJc/p69X8tvWbxmwVmgrEzIgH7BB+4FxIu/vgojypWOMqhjsVCtheINGo+VXYTV0VvCvBKcKihtHMjBv3mNVBLlOed1gjsWVTZ8Vi00VShVJlJF2wkBV93DpM/1PgcQ/9sHND1Ua/3inDMm4ef4ZBv/Sb8xFvqziC08trQs/k9zGfET3qPJvY10GmhQwGYP4GTw3xoY0DS3aLPyJDEEqWlgeJdThw11ZS4s7FR+QVP4Rl1S2KIzu1FKtAG01THeJJhxpS/V+RjaPG1aVUachVoyS+G4htVwsF/IQ4d9eqoIiu+f1uShk9WF/hosZr8xpG/9O0+Uf1uW+AHfjffsOJw7TFaRBBd607EeIpL2wiB3M8RDXPORieLAoJ8km4ABFyVgo5+YM3T/MVqSFr+MHkBFg3rV8Bs0b9HI6lQ2gMFpxTmztVseEh8qBtc4E2Ak8RW9Lg9HJ+GLfI/7HFZMlMZ5tnivHgQ6Maw6Xj7bG9QNwiIH4kh7bFo7zXvj9PvRaXEZhdddej0hw/JeBbjnx2OoFfMHMv/HaduxpxESSW3S6WsnLQCkPM7EQjkNIpahZD5pup9MAmT54CFsGFmP24wkqshJFvhBVj/WrmF/dTtuMpU3UjvF8KS/Qc4WMU/wJaXVIn22JLOrU89o1Pw5SK1/CdaiqZ/OczQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(396003)(376002)(136003)(39860400002)(451199015)(31696002)(86362001)(36756003)(31686004)(38100700002)(6506007)(2906002)(2616005)(6916009)(53546011)(6512007)(186003)(26005)(478600001)(83380400001)(66556008)(8936002)(316002)(4326008)(66476007)(5660300002)(8676002)(7416002)(41300700001)(66946007)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3dGL1ZGK3B1bEh6TWhrbk5Mb3Z3cTRnRjlmU0t1V2hON0lsak5waGVsWTFH?=
 =?utf-8?B?ZU1UVE5lZzlna0NscjdtUmJxam54dStzMFdTWngyL20zQVo1N1k5VHhJZkgy?=
 =?utf-8?B?b0RMRDBlSHZmMTl6RlpMVHZrTklSSGJEeXRubkRVeDAyOHVqSlZDZ1hCRDVZ?=
 =?utf-8?B?OHRDR2ZQNXN0cGlWZ1ZOMEZlQlk4aHRkUm9ZTWZyQjJTQlVDTElzb1JpZ0dv?=
 =?utf-8?B?RDBPT0szOWV4YjJCWWd6bmJ1cDFXVFc1U2xWWnFSRDhtZkliYVMxdWJoN2tI?=
 =?utf-8?B?Qm1Cc0lSZ2IyWTBQbXcrVk1KMmpDM1FKcFJiL2hCYjVVV1lkL3NnRS85Wk03?=
 =?utf-8?B?NmEzd2lrQ0lscXRtRVhRTzh2T0ZCb1ZJTHhQSTRlSkpEdHZuRkg4RkhLeThz?=
 =?utf-8?B?U2JUeTZaUVpKQkZvanpNRnVOTVE2dkJkU21XM2NLakdkRU5scTlJTTMyblA1?=
 =?utf-8?B?bTU0VCtlN1oyRmM5c0h4NXZZWGVWa2dsM2VPMldSaFdYRkZMUHF3STlaUm5P?=
 =?utf-8?B?SldYVmZtenFiZFhQS25zenc1SzQ2N0VvcU5XMTgweVZjc0ZrZE0wS09tL2ky?=
 =?utf-8?B?L24rTkVOb3FDNS9qZ1VPSEhDK1lhdVZGM0dlR2dXSHYrVjJPZmFFTERZQkdh?=
 =?utf-8?B?UlNWV09lNFZ3Q1RQYk80U3ZaZUxONzZhemt1RkI0OEZVcFZ1YmpGL1Nsdjhn?=
 =?utf-8?B?MnduaDJGckxoTVNpWm8xdTA5VkNObVJMcVhHSkF2OUwyVVJNRFk2OVowWGp2?=
 =?utf-8?B?Y2dNdVlGZzFVaFRHeUtSSGR3Q3liZnFTQ0NSZWRma0k0VlZVZFFZZ1hOS1Zv?=
 =?utf-8?B?RUtoUDhIbi9yOXVCUUNTOU1wcnlpU3hzckYxMG0zZ05UOEFtcmRzTnFWb2dn?=
 =?utf-8?B?T1cvemZsd25wdUJqWXQ2aFd4ZGYrTjE3UWlJMTVZYXpUa0RiVUVJbmVVQVhR?=
 =?utf-8?B?SmwyKyszTVNSWFFnZlVhSGJXSnRSRTJqWm9lRkVYcjdTR2NSNGVvWnpoQW9t?=
 =?utf-8?B?MEh6MngzRHEvbGlybENhV3hsWmlhakZ2TXhxZ0cvbzBoc1k4QXhHM2dBTHNl?=
 =?utf-8?B?Y1VDd1FxZkNaYmZ5OGE3amJRcllHS3EydDFicWJ1djlrNWRldklzQm1aQ3hJ?=
 =?utf-8?B?ZUcrTmx0cWJzYlVzQ2VQQXdacGJnOVhZOFVRajFLaTVMQ01SazJVVVVLUG9V?=
 =?utf-8?B?YnhiZEpNN0JKK0FpUXNrczhtamZpZzZ1ZGd4V1dXV2crNzA1UlBsSFhuN2Z0?=
 =?utf-8?B?OE5GbzI0YmRyRHR3SngxNmFNZFZmN2M5UUlTT2I2ZUVkTkVrVk1PSmVCMHM5?=
 =?utf-8?B?cm4xVlZiNjVlL000Q2ZzanNiSXZrelFqK09FeW0xMjQxcEdhNmNHL3BKSTlZ?=
 =?utf-8?B?djRFVWtJMGVCUjR5VStsdXNYcThMSCtaaXZsN00rcituRmRkSTJJUDNZT1p3?=
 =?utf-8?B?M1VzV2RScFprM3ZFaVpNL2JOdWY1WXNxQ3Z6Y3ZkMm93TFpvSXN4cTExNFhU?=
 =?utf-8?B?MkFZZEgxa2dyQWpwcE1mTVpqYzNSMW9HUkJTYUpvcFUxenBsb1lDYU42VlpB?=
 =?utf-8?B?YzBtaW1HRVRPdk40SC9oREo4a2g1R3pMZFZzRmhCZndZb2NCMkRZMy9HUTda?=
 =?utf-8?B?cHJiRncyTmZWalNFOWQzcWNXOEgrR2pWdWtkVisrNG9sNTNvNkZsQzJHUnY1?=
 =?utf-8?B?dGc4bnVDSy9sUVhzTkc2TSsvSnZnQUl4T0pUYytwb0FSMVcvRjVpdlRMQUtP?=
 =?utf-8?B?T3FMeCtwK2VEWTV5T0VNcFVQZExQRTk5Q0EvSE1iYjhld1pEL3JLN2RHUW9w?=
 =?utf-8?B?N2N3S3VidXE3dE1LanRYTWx3WnEzN1FmSlFMVjR3WERWdW1jR0NBMjF2bGR0?=
 =?utf-8?B?TUZJU1UvajJwRHhqZTltZlkwWE5hbFo1NDg1STFZRWdnZVptblJLYWlkNW1j?=
 =?utf-8?B?NFdlZmx4RDJYVFhBbURFelBiLzBFVUFwVkRGZkEzdzFJTWxMQmxwYU9YOFhL?=
 =?utf-8?B?OE9tUHcvMGNSSE9iZ3RjTFZQUzVTWEcvY0U3czhSTnBBdTQ3ak1BaHkrbmo2?=
 =?utf-8?B?TUpYblFXZ1JHdGpMdHZnYSsxd0pWeDVwTmFQckZNZXBFS2RRNThELy9PcEE0?=
 =?utf-8?B?cnN2QS91U2pUcXFBSTJPZUtST3BrVEo1SUlZczhhSm9Hc0NSQlRDQmMxYUY5?=
 =?utf-8?B?SHc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8ee6fef-a1ac-4e64-2f56-08dab83da99f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 17:07:00.6362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y3nblroOM37cvJZ/dttA1utyIrmIet+N3WrEXdLoFg9B7lmve3CKCRdbqSGsCQesq9oZBX13YhLOax+Zdgvg/R9TCvdVEE1/hrsmeyzHSBM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4253
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210270095
X-Proofpoint-GUID: w2zmSZo30J2kBCIz4qjrznCMegGFye1p
X-Proofpoint-ORIG-GUID: w2zmSZo30J2kBCIz4qjrznCMegGFye1p
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/22 10:18 AM, Keith Busch wrote:
> On Wed, Oct 26, 2022 at 06:19:36PM -0500, Mike Christie wrote:
>> For Reservation Report support we need to also convert from the NVMe spec
>> PR type back to the block PR definition. This moves us to an array, so in
>> the next patch we can add another helper to do the conversion without
>> having to manage 2 switches.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>  drivers/nvme/host/pr.c | 42 +++++++++++++++++++++++-------------------
>>  include/linux/nvme.h   |  9 +++++++++
>>  2 files changed, 32 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
>> index df7eb2440c67..5c4611d15d9c 100644
>> --- a/drivers/nvme/host/pr.c
>> +++ b/drivers/nvme/host/pr.c
>> @@ -6,24 +6,28 @@
>>  
>>  #include "nvme.h"
>>  
>> -static char nvme_pr_type(enum pr_type type)
>> +static const struct {
>> +	enum nvme_pr_type	nvme_type;
>> +	enum pr_type		blk_type;
>> +} nvme_pr_types[] = {
>> +	{ NVME_PR_WRITE_EXCLUSIVE, PR_WRITE_EXCLUSIVE },
>> +	{ NVME_PR_EXCLUSIVE_ACCESS, PR_EXCLUSIVE_ACCESS },
>> +	{ NVME_PR_WRITE_EXCLUSIVE_REG_ONLY, PR_WRITE_EXCLUSIVE_REG_ONLY },
>> +	{ NVME_PR_EXCLUSIVE_ACCESS_REG_ONLY, PR_EXCLUSIVE_ACCESS_REG_ONLY },
>> +	{ NVME_PR_WRITE_EXCLUSIVE_ALL_REGS, PR_WRITE_EXCLUSIVE_ALL_REGS },
>> +	{ NVME_PR_EXCLUSIVE_ACCESS_ALL_REGS, PR_EXCLUSIVE_ACCESS_ALL_REGS },
>> +};
> 
> Wouldn't it be easier to use the block type as the array index to avoid
> the whole looped lookup?
> 
>   enum nvme_pr_type types[] = {
> 	.PR_WRITE_EXCLUSIVE = NVME_PR_WRITE_EXCLUSIVE,
> 	.PR_EXCLUSIVE_ACCESS  = NVME_PR_EXCLUSIVE_ACCESS,
>         ...
>   };

It would be. However,

1. I wasn't sure how future proof we wanted it and I might have
misinterpreted Chaitanya's original review comment. The part of
the comment about handling "every new nvme_type" made me think that
we were worried there would be new types in the future. So I thought
we wanted it to be really generic and be able to handle cases where
the values could be funky like -1 in the future.

2. I also need to go from NVME_PR type to PR type, so we need a
second array. So we can either have 2 arrays or 1 array and 2
loops (the next patch in this set added the second loop).
If we don't care about #1 then I can I see 2 arrays is nicer.
