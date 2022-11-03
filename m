Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5100C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Nov 2022 02:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiKCCNx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Nov 2022 22:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiKCCNv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2022 22:13:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDF813D2E;
        Wed,  2 Nov 2022 19:13:50 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2MlvHd029528;
        Thu, 3 Nov 2022 02:13:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=LvnWahXmPmGg8uWS3BT3/z9VN0HmAZhMizeRwOzy1n4=;
 b=R+Lf6cuLsuwadzovEHATwpWcm2JEH3CFbdkdNG27mMmKR/5vuGcAneRsm9W/GFbmdJFa
 zvnzF9TeWn7Hzim5aMA4EY9SzhGjmVNqp4FV+fRDp++tQRUhgPKj66u5s4kyRKwv9dwI
 MQALGoyyPknmdkFgCE6LfZnbd+xKLscAvDuem+T+ql3nm/Zfe3byOgQm+7518AiP1boq
 E1cGrAVa6qUorV+6RDqWfc2M6KW1O5sWoEGvoPtSDFDKwGX/orurv4cbLtQ0CpNqPavT
 72TF/nQOR6StlxN9S8OJf6tOO7zgeYCktp/IBQbaFsGvtljcR8FFWn+I/lv9TwOjobL8 dQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgussuf28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Nov 2022 02:13:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A31JhQc027210;
        Thu, 3 Nov 2022 02:13:34 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtm65s8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Nov 2022 02:13:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0v4oNPqPQdZYrLNErioRj/NUXXuTyEzi1l6+g7h0I7XcZIz70QSAMaehxBKB4lgP8xCNlGVHW/MF21Jq9HJz03BBs4J76LNHvgpQCk1OBP0d9ipZxVa9bJhu1GOZ/9MfNnxIWWQiW0EZ0u05hU2u7cplBdf4Nc/L7tTj5zeILYEoy514tHbaaNkR5JFBROOfjchQd20ynvmj83fJB6eQPZ7eu/hTQRgb8nBytbHlOnx7F6tEKxjmqgVxl/sDw7opYtQ952b3htj324H6smMQA1VIt2QXkXFR1UWRGXv9EAK7iX3EPTV140xNykOE0HQRjpuEMFITgbTtBuZdkByUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LvnWahXmPmGg8uWS3BT3/z9VN0HmAZhMizeRwOzy1n4=;
 b=gTX/gGgaOU/8gwLu47Huw4AO38tJbJ+h3e/Y+QNTp9kZ4czaggIuChcjFdhiEMLIjzBdwmbfu8yJQmLIgGnI3dJAGhMSVwK8vm1n8nmFJl9NREBVarGZ9LyhWJr5Et3Bx4eEAz1O99zU9t6dBPvDsindkLqVWQADag8h2jzHTaIZ3HAz2Sz9t6I/0pkGM3IK8g5NG2j3ra4kZ41xPwDONopYRGx5Ov+pGRIPOA37Cnwvj7oUEM9lT1+eKb/ODI0UBOcaMqJwRy8QtF1+bZfK2VEsF0m8KonzVNy5tUYSBMFkPV/y04HEDpX3r8sP5P4604A74lFwh34+DzD70iUa2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LvnWahXmPmGg8uWS3BT3/z9VN0HmAZhMizeRwOzy1n4=;
 b=uaMgiDmno8P9u/oTdf3IsTuoX+oK+EDvgWM6dMaRp24mLK4J67F03JwUwCNeVqIZGcOBgT54T6GT3gLSEFf3QxZyBPwokUYie+TecPVXEU24uuX+tDgo1JZqV2UJh+P7aeluPGRuz5D4ruhvMM41cx/6kq27lcv1Cgc+0w6rCu4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ2PR10MB7013.namprd10.prod.outlook.com (2603:10b6:a03:4c0::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.15; Thu, 3 Nov 2022 02:13:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5769.021; Thu, 3 Nov 2022
 02:13:32 +0000
Message-ID: <7b8cdc82-0aca-2f41-2eed-299dacf95771@oracle.com>
Date:   Wed, 2 Nov 2022 21:13:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v3 03/19] scsi: Move sd_pr_type to header to share
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-4-michael.christie@oracle.com>
 <0123db70-6217-135a-4101-0609512e723b@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <0123db70-6217-135a-4101-0609512e723b@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0P221CA0041.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ2PR10MB7013:EE_
X-MS-Office365-Filtering-Correlation-Id: 2641cca6-7dd2-4563-0b21-08dabd410143
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f/5a1oNXTsl9Oks3XiHDcwkNoLBA1bfUbaF56STiBxHw8lUB0o2FIPKaEDW/lh2X7P1rgVh595g9doR9XW4iR+bRSFJMbDLPbVc/ot7PSkGPeN3OhHE4YLoWyiLS1V0Dn4Vt1IX8rfAWxUB/jQDPLMRAaOoveZBQGDXHtnYe4aYkwDUZKYQ622kX4bRUMsrg255kfovFMq8gPiGI+QGXRgH0QF1bk1Oy+eX1W2GLTw5Hczpm5qiCVeoJzxvrLtLIuXA4LVIM/6XBQa5sCuTTSlA3w1B78XDJAYlwoIoQrSyUGQXCh5mFPA1XpFKJ5ZZHHylKXpE8TKGLz4pNdKPaxeI05Q2HMaDgTCUjWMr/4gnTJ2HkZm0/LdbddHQO2R8hWm6vtHMaIDbEwP5+z+VP41kc13trAjHFcJbaOldJYeLWtoMT09af5SvvJcgex+27U6zKAKvoOtwYcRvAOO+7l8AjwXU0I3OvlJ29yojoG7M2L+aC0caDdotVCyQSsbAsOLXTbOrXAnYD8WSJJ+OEoSJZnNSLAMBeCFoI1uXt0wWRiJdD1GpeikTvwRkyWkv1tkI2sppr7YUNY7vs3oz5rDI4/GG8IvO8YhcqaELSz6hKL5+164hbZedmlo7h2fsOLbILJ4nBUeycImFHa8LgZtzELZ/19897b/jLqWleDxdS5Z2ojJvOZdxZy2IwYvrUEzm2Yr1E0h661Pocc742Oh7lyHvmZCR0SoDCCMBroe8t8LzYyv+r9ucau6CwIFvwTXyj9mpAw473qeqtfXeFpJrJ20QyTBV93qQVo9y4Hzr7fmvmTLr64hX7zMx6reui
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199015)(36756003)(31686004)(38100700002)(5660300002)(2906002)(86362001)(83380400001)(6512007)(7416002)(31696002)(921005)(2616005)(26005)(66946007)(186003)(6506007)(6486002)(53546011)(478600001)(66556008)(66476007)(316002)(41300700001)(8676002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFdNUTlnNlRJUmpPMklCckl2Q3hNVGtWZ1BFcDRCOWUvNTFVWnV2SmFWSFNG?=
 =?utf-8?B?SUtoQnBWZ2VSU0I2N08rdCtyR24rR1RPR3hzY2FMeWUyQndrL3dvNlpKb0N0?=
 =?utf-8?B?WVIrVU5zYWUwdlYwR3k4b010enNEczNqM2w1ck05STdzRE5leVphQmdxZXB6?=
 =?utf-8?B?Y2ZnRnZpSXlaNWJyMzVuRUM5QzlnUi9jU2s4d2hPNm1iUk9RVi9CQzFBQ1BH?=
 =?utf-8?B?UGZvU1g4dzJsWmpmUFJJdEhmVGRNVW9UMm1pYUtQdVlCZEdoSzdObXFXL0Z1?=
 =?utf-8?B?dHVGSjJ4RDZrNGVmaFBoNFU5UlErWnVsQzQ3NWpHb2ZCclhZMlpuNzFRR041?=
 =?utf-8?B?cGJ0RWduSkQ5WDVkR01TTmdqOHIrdU1OaXVuWHR2aGk1OHB3TVluRlh4VEMz?=
 =?utf-8?B?NDB6a1FSS0RFenEvV2p1MWEyR1hMZno1anM5RU40bmhlQTd4cDBxYlhpUC96?=
 =?utf-8?B?T2pSTmVTZ2V3KzV6UXU3K2NYMUlPbTBNQ0lYNWRRdjB1cnFKSWc5MS9YYXNi?=
 =?utf-8?B?cTlkZ1dLOU8zcFROS25MN2tLN3R6b1pCN0UvNkxWVGFOdXFuTTNXaXJVNU5N?=
 =?utf-8?B?UWs2cVV5cDBEbHlqQzRXZDlGdllxQzcya2JnbWhjR2tzaU1EUjUySyttaVFO?=
 =?utf-8?B?Yk5iSmxIZVZ3aDR5RFdTaHMxVytjWXR4T0I0QUdnWVJ6cDZkS1FpTnZoeWcy?=
 =?utf-8?B?ZFBBR1VybTlzcUppY04yQllpVzVZREREakEzcVZ0K2RpOEdhNVovQXJNQVdG?=
 =?utf-8?B?Z2IvUlhoZU9EZG00V2xXSVdEaUNOdk1FdGhRVitPU0t2bWJqandYSytFN2RZ?=
 =?utf-8?B?ZVB1OG1SZUlmTFducXBBMUVWa3QwTlY1Uy9UcWVJdUpNTGcrYXh2SFRha2Zk?=
 =?utf-8?B?M1pLTTlmd2lQOTB5Szg5TDB4UFF3bElSVzhhZGVnMWZycHAxd0FaYXJjcDNY?=
 =?utf-8?B?eTV4bGJ6cHZ6OEczWVUvQlNwaWhQZnpYY25wNEphZTNMVStacUVJWUlCNmZI?=
 =?utf-8?B?ZGYzdEMraXNtOTJ6NG9JWXJLVkpsUDc3WE8vM0xPencxOGFFTE9Sd0IrQU1u?=
 =?utf-8?B?K0dYTFVEb2tMQjRVQTlaU1MyNERmMGd3QUF4OWxzUW1FZUhIZ2R6YlVDR1dS?=
 =?utf-8?B?bjEvRFRncWlYRWhWWjJFMXZ6N1R5Szd4bVFtcnY0SXprNHFPaVNVSGpOTHpP?=
 =?utf-8?B?b1g2RkZhbUtGQXhqcko5RWpjNGNXL0FlMTFXdm5JanFnREYyK0d3N2s0bkZQ?=
 =?utf-8?B?dXhjTmN4UklzKzRZQWI0Q3VScWdPYjBybXVLTkpaMnNHS2l6TDV1ZUtsM3pS?=
 =?utf-8?B?QzJpNCtmTDAwYmJFTlBRdUZ6dllvUHByKzJ4aXNkMUxGMnd2NDNQRnVOcGFx?=
 =?utf-8?B?d0NKRm55SDhBaHRFT3RVQnNLeDg0bVJsNnIya2FLbTR5MWxmNDhqekdwYlhm?=
 =?utf-8?B?eGxpbTZ6dU9xN05VcGUrczBtTDJRS2FSKzR1L0tORnJCTnRZdXlwbUxValA5?=
 =?utf-8?B?MXIraGtUZzREeGc4aEEyTkxBc1JKRzdyRU4wNHg0bW1lNWlBZ2RwblE4NzNp?=
 =?utf-8?B?VWpwcDF3aUZNWVFnc0JMTzJsN2dqYkE2RTJJaElub3ViRHVtdEduTEtJbXUr?=
 =?utf-8?B?WHNnUzBWU3pMS0daNmVtVGw2aHIrT25KT0RSZVY1YXdxZDlpZnFIUldDUnIw?=
 =?utf-8?B?NEtXclNKanA5eWxKN25qelBVWVBHVnBMSnl6Z2N1cDYxTkhweTBtWWdFdFYz?=
 =?utf-8?B?Mzh4bFJSaWg0ZW00dFc1M2d4ZFg1UnVzQzVQM28zRnhRWHNITEpydUgveXph?=
 =?utf-8?B?cEZ6TFJnUENFS1pLVHhiaEJxeWFPQXR4WVlwUWw0VmIyWUhabm04bzBsR21I?=
 =?utf-8?B?OUlUZG9qZjBrZlJTZFB2SDNQRlJCS1J2OTdmSXI3MlZyMkN5UkNiWW1CWjFm?=
 =?utf-8?B?S0ZnbndCclhGb1haaWRJOURhTXJ0STVrcHpybDFvYjRwQVNWNFA1TGpsUWht?=
 =?utf-8?B?czgvdk02WUtHeEtGS1lkZ1NkdXNlZDRFRnhQQXN2RXZmV2JWaXpsWEdsdGFo?=
 =?utf-8?B?WU82aWZBWFB4WFgxVk5sK1dBWENvRnRXQ2pzejVxVVc5cHpxZXR1L0tDa3Z5?=
 =?utf-8?B?SE9yRUh4OU9MazFqbld3MnRSQWxxSmgycUhqa2tocjBnTnI0aDRES2RKU201?=
 =?utf-8?B?K3c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2641cca6-7dd2-4563-0b21-08dabd410143
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 02:13:31.9447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZlkwOfWnNUSwa22bOpfXITFfdv9eQCmLiR9solKc3ArpkAuKy5TAv3l6ljrJMlva9FBsTE6GjyB1+aF093/6jyGrmEnLfCsG7kCdTQkpmm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7013
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_15,2022-11-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 mlxlogscore=961 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211030014
X-Proofpoint-ORIG-GUID: dtKzmkg7tRhmQ2o6sy0YFq2nili9uuSi
X-Proofpoint-GUID: dtKzmkg7tRhmQ2o6sy0YFq2nili9uuSi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/2/22 5:47 PM, Bart Van Assche wrote:
> On 10/26/22 16:19, Mike Christie wrote:
>> +static inline enum scsi_pr_type block_pr_type_to_scsi(enum pr_type type)
>> +{
>> +    switch (type) {
>> +    case PR_WRITE_EXCLUSIVE:
>> +        return SCSI_PR_WRITE_EXCLUSIVE;
>> +    case PR_EXCLUSIVE_ACCESS:
>> +        return SCSI_PR_EXCLUSIVE_ACCESS;
>> +    case PR_WRITE_EXCLUSIVE_REG_ONLY:
>> +        return SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY;
>> +    case PR_EXCLUSIVE_ACCESS_REG_ONLY:
>> +        return SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY;
>> +    case PR_WRITE_EXCLUSIVE_ALL_REGS:
>> +        return SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS;
>> +    case PR_EXCLUSIVE_ACCESS_ALL_REGS:
>> +        return SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS;
>> +    default:
>> +        return 0;
>> +    }
>> +};
> 
> Please leave out "default: return 0;" from the switch statement and add "return 0;" after the switch statement. That will make the compiler emit a warning if a value is added in enum pr_type but not in the above function.
Hey Bart,

Did you want that compiler warning functionality in the future code
or are you asking me to do the above only if we go the switch based
route?

Chaitanya requested me to make this array based in nvme/scsi. For this
approach, I can add a WARN or printk warning if the pr_type passed in
does not match a value in the array. I don't think I can do a compiler
warning though.

I didn't care, but I think the compiler warning route might be better
though.
