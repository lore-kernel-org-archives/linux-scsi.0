Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BE3C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 03:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiKID5t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 22:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiKID5s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 22:57:48 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8C817A82
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 19:57:47 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A93msIr017627;
        Wed, 9 Nov 2022 03:57:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=EZ5r6SVXcdjHJW8pE04YaopXf0yJGcUnIZ6YcggxWHw=;
 b=ztRO0r+PpYBPsgGnP/ErYUjLLzZBSvT7o8G5XsXrUGiRhg7r2dlwr0YwgeImsD+TNzRg
 ZyWx4PtfnOxBzmkRgKysZgiF1HToTutIVNZLoCFObx4NmNRVo0r/bLIFLBQQvrr/S8V+
 zIUxd7+2fUyJMQVxgTQ/PD3VUSAgwpdrmtgCrZXXiDSNXovmHQ9TE6MMmz+jDuPEmi9z
 G+eJw6yXX4ub+weI+Wjdd1RBxjPhvDRyQTlDhq1Fv8fvNLUFzZxj3aELqTkjI+x0KBzH
 B1mdAZDMWtK8GGZs/aqQb+EuhoByWiw9kAptv/o36SwHLDhmCPSBVVxZZje3DnS0QuxP fA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kr4mer0cn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 03:57:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A92jd6C036314;
        Wed, 9 Nov 2022 03:49:57 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcyppatf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 03:49:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A8N8vKT/9MsMZKdqy9P6R7rSohnEObLz0DcO4RvEZ7hv68PU5sDUUGyWShrrNWybLBFM+8wCt0WRmPAPAmh54nPzD5Bk3pe3t0dfwHWTjCy+rZ1zEqwz3sg/xBs+9SGEBtbG7dB2JEx90vmfkBSL84VhWrYh25hUufT54WYNxic2lpzcp//CE/DU36WunUSbS8NZ3wFrvVtgyrL5egIp+IikE97QTJQJic2TayT139Go+73ZL2LaU8V1wEWdZ6zhYNiuYshfS9EYh79nbnWjki4DYsR0LDsrBKwoN77OHQlhEDQe5KC8ILQEuw01AH6BT1+qDhCHsbHHqPjBy21YsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EZ5r6SVXcdjHJW8pE04YaopXf0yJGcUnIZ6YcggxWHw=;
 b=aoLrdoI+TFeV+dDeueGMO8bEZE+5xJSkU5UOO7bOsJ6ml5qbEFJ92xue5+Cb2CVkDtTexYJKt7Kw2M33Mqfivn0N1tbqsZhBO948Q22RyceRTR7QmDXVU+jbMMLjlT98NppjTAXfqhycqXRKTiXLH24f6XBOCaVOScDBg2G0L0k9YsoneEBZAOGaHVe/eLygk9E6cJyZSGPdTfSbn47UiMqPfic//Es+2lHSp6wYsdqeMpJt94AL/Dt923jMpeKv3b911qvbk0xBx/XiNON9kgBrkrsaLWiKkESk2ECtBvD2+Urm1bhDHll6LlgENzo3U3OS9yYfO3UKYsuhZdwDrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZ5r6SVXcdjHJW8pE04YaopXf0yJGcUnIZ6YcggxWHw=;
 b=IjMnT9tznfQXvdeLRas13gm9sfKlAi1ik5Jhf0eCCWXeZ/+gJjsQYcdiZg1NPvr7Jb8Md7B9d2Ml1W1dDesn5gOMdupE9JodpHH77iHvgNQWdhrlcprjTMm2QryCWuw/Wop33VR33UjW2Fk9fgAoSh29CNa5/rTKQ9j0FlA2Ycg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB5853.namprd10.prod.outlook.com (2603:10b6:510:126::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.27; Wed, 9 Nov 2022 03:49:56 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 03:49:55 +0000
Message-ID: <967b7881-2c01-6019-b08c-b6ad9a977d7e@oracle.com>
Date:   Tue, 8 Nov 2022 21:49:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v6 02/35] scsi: Allow passthrough to override what errors
 to retry
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221104231927.9613-1-michael.christie@oracle.com>
 <20221104231927.9613-3-michael.christie@oracle.com>
 <132f8a3a-1cee-e660-4fb7-3a09ab22c10b@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <132f8a3a-1cee-e660-4fb7-3a09ab22c10b@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:610:52::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB5853:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d11698b-69ea-4589-7475-08dac2057737
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6EhM8iudf0teBx8nOYCR+LUDwy4zE0oe+5oRXwPVugzCPMMEju/LBU3lQ8C9TQaYiuiQeshr7LNYo0Q/7oxoMJV11TGDPs9ESkw0Y1um2bDlm6woJkaCBe5f4DgNzEY6VpArvgtOU8mXAFUJ8cEyTxRVhSB54/v1etAPoAnkFz7dTdUQW12rGAD2edMHqaw3547PQbopuseI8pMzOdRee0qXFAfmcuEOy+k4xsPQ4wZ+Ap9NoYz6M/L784D+ouVmQ3bsmVhP12GXkdfjmMlRqMavJ1IYOU1siPbGuJMxWYdQn9fUGjG+gcLFGZZYozwyAfF1Ajd7ubtEHgaVyZ/gAa++tvmZTUkE3ldoK43VIX3tTpFNq+GbobQiAoRvd0sIwWaKXLVHB8WeHt5WYp0up4gOnekJHeh7YcMQ3B7nQNLAE7YVG1xXpnNIUk+mB0NJTpi4uzmmb9Epdzo75Ea3Od3IRnEHk3GFzvkPPNWruts2Mm9FUQTU5d4cUd3NLmzCGppVMQDmNuLq8z6pz6pJBp+XaFep1StoYa9G2jSzO+q8KICUmo6maR2LJ8FoIYjKyauhyjr8f4bpWGtXG9lyUaUI1dFx7ZzP3QeJwx07/dhNtvTLhz8RpS9Q/vJC6p3yi5hu39+p1scJq4v4h48L3VY2tOEL7aJrfwxrpw9+K4zivcLsX5hkGS+3fq9YcC7y7aMWulXp+ov1BNdYxKem9VlZMO1w+V7PuBbucCOkqeVwB8VwJk3jJJyC8ebQe2LmoQeuLjFpGgF0mInBMMu/5MrBTMJQxgpWD0qVjDeImtQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(39860400002)(136003)(346002)(366004)(451199015)(316002)(5660300002)(41300700001)(8676002)(36756003)(6512007)(186003)(4744005)(6506007)(53546011)(2616005)(66556008)(66476007)(8936002)(38100700002)(26005)(66946007)(2906002)(86362001)(31696002)(478600001)(6486002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjJnWjlIN0Z3SzYxRHhmQzhNdmYvejhTUDFYbUR4K3BOUGVoN0M1eUlSbzVp?=
 =?utf-8?B?czZYNjhaV1VETDF2eloxaUNYRkZOVHhKNWY2cVZJVXRQaXdQTFBnR0p6MnJR?=
 =?utf-8?B?aWEydGNsQWY1SFh6VXJnR2RCZW9ySStjRERCbVpZejdMNEV3ejlLeVdGWmNZ?=
 =?utf-8?B?SUlOTzgvbGtwamZEMFFEYWtOaUNDWDQ5R3BMSGRvSGRrKzIxakkvcHMzSDRZ?=
 =?utf-8?B?UXozNmE0MFFMc0dJWGpZdkFVOWtPZVdjdXBleEhkdlZNeEo4T2xDSi9HVldG?=
 =?utf-8?B?bTFXZjNSTlppME85a2duS09KbXdHK041NlEvMm8wUm1HRnBuc2ViR1NvMlUw?=
 =?utf-8?B?aC9xRFM2LzU1dkFuUzJnQmFJK2p4UzZtWVZORm4wL3Ewc1hKTEl6WWFOMXU1?=
 =?utf-8?B?YVk3R2lpTGtwanN5Z2cxMlBva2FuWW5CSkJpb2NPT1lsSVJxU2RJWjl0cytS?=
 =?utf-8?B?dFp6ei91U1RGODFvNVB4MGFZaUJ1TFF0MW5VSTlIS0JrTUxJSEtjd0FMd08v?=
 =?utf-8?B?eGlZc3RvNGxLdWh4RDNCVFVadStNZ2F3azBsa1hwK05Kem9nbVBIUXVDNjNx?=
 =?utf-8?B?OUUvL1BQRjFHZUlPMXVlZkwvMm5leUlDR2RwY2c3dEJWUjlGUUk3UGtPU0dv?=
 =?utf-8?B?Ti8wTnA0d09DUGVIYmtVR0NtTHFlREd0ckZ4Q05mQjBkYXQ2RFd0R3NBU3Rs?=
 =?utf-8?B?Q1dHMlFCNVVBVi9tQ05NVjFsTXZ2Tk5SR2tBSlcwdkdBc0pHNFFvV1pKc0Rs?=
 =?utf-8?B?ZGQ0MXlIUE9hNkt4R1VTUitkd0pZUEdxYXZybEtma3BTcW5laUw3QUY5R1ZT?=
 =?utf-8?B?Mmo2TGxnek4wbUR6ZkxpZGxpK3VuQUwyYk1MdXJ1TVNYT3RBY1ZDVmlVM0tx?=
 =?utf-8?B?ZTE0dWgzU05vTldpQkdiRURiQWFaWGEyWnROWHkyVElTZ2VTa29EMU9MZFZj?=
 =?utf-8?B?Q1B2MXdXb2t2VVdLVWRoWGc1Kyt1RGJVYVo3MFpOcCtBa0tCekkzOG9tTVRZ?=
 =?utf-8?B?OWVlSTNyRlFsRHUxVFltd2xlenIxQS80S1ZLZTAxVGUxUm5HaGlnYS9yYlIz?=
 =?utf-8?B?L3B4K1BWSmJzUXo0b01QVE5jUG54TlVSSDUwMmRSc2I4QzFLVmtvcDVySTBO?=
 =?utf-8?B?RWIyWEw4NmI0ZW5aMngwSnFVY01LYW00SXRMbFJqaVJSZXdxdUpMcjN6NXRF?=
 =?utf-8?B?K1E4aEJxZlMwQ1k2QitRNjcxbHljZk1LdHNwL1kvL0ViZVRxWDVTbTRBQVVY?=
 =?utf-8?B?TitVTW05cW9hVWkxVHFZNzYwMkF2SG43UDBDQ3l4WE80VDM2QzJvYkl5Y1d1?=
 =?utf-8?B?SElpdEFBbUxEZVlPTlpZdWF5eVdZMjJuYkk2SUVKbTIrZUdGU3MvTGlwME5O?=
 =?utf-8?B?RXJFRk8vOEFITlRrNWZGNG0yZEl1TFlJQmsrMEFmdmUyNld4TXlJMENIbWdp?=
 =?utf-8?B?dDdiZ0pOSHFHR1FBdUFCWTY4L05yTEZKR2lrbEl2QzdpVzc5Nkdld1NnazJL?=
 =?utf-8?B?NVZFbDZqaVNIRjVkb0lEbDBrSkp0V2NLNTNrZy9RSng2QitURkJiT1A4Mk03?=
 =?utf-8?B?Nkc5cnpaQUZ0YzFkN05FbGRYWDgySTBDVVRvQUFwVVAvY1NnYitzYUlReHZs?=
 =?utf-8?B?NG9Bb1psUHV2V2x3NnZka0dEVXcvVDZQbnBaYStJTHlLWXVHSFlFdXo5NlE3?=
 =?utf-8?B?WEtxWHVHc3FpazNrMjZXN2YreXlTQ1FRbUp2OW9aWFZRR0xOT3ZWTitRUzFP?=
 =?utf-8?B?OWF5NjF1ZlVHN29RK0RCNmQzNXZFNHVwWW5JUXJJaTNTUndVckNZUGQ3MDgx?=
 =?utf-8?B?SUJ3RXpmWTYyK3ExVDdZZE42VEx2N2lYaVpvSjdqcVdSSXI0bXM1NktqT3pY?=
 =?utf-8?B?QXNNMVNKUWoyeFhob1A3Lzg2bFprTnRIMjA3VWd5MnJaUmpIRXdXQm9YK1FM?=
 =?utf-8?B?UG0raCtwVm5Lei83amRpSXlXYmxuaXlYbllUWlV4dDVqN2Z2bHk0dXo3Y1F2?=
 =?utf-8?B?TzNHc2ZxZnVha2prNlJaK2tlVG9pTkpLRHBIcmw2Z3dVQ1RjSGlBZGhoUUNS?=
 =?utf-8?B?RmpLNUdOMno3K29WREIveXdycnduZW41cVF2VXhLUjZvT281VXFpUzB1eHpw?=
 =?utf-8?B?aW9vRmNxV3ZZeHdibjZkU3dMelNFK3A1NVV4WXo0Qm04SWxTTEtJa1poek9V?=
 =?utf-8?B?ZUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d11698b-69ea-4589-7475-08dac2057737
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 03:49:55.8813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vB/CM6M35XLZnHeNuLuxJhyWNAdznYNNfCGH6uc6MxZKdPoyJ4bbDl8zDWO88QO2S6UFj6Yp3sgUcJCjnzneKJX7A8+sYGdMaMxjztW5e5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5853
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-08_06,2022-11-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211090026
X-Proofpoint-ORIG-GUID: wM05nW_HOdTR7jhmobd-G6EqbPYB1EMB
X-Proofpoint-GUID: wM05nW_HOdTR7jhmobd-G6EqbPYB1EMB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/8/22 5:57 PM, Bart Van Assche wrote:
> On 11/4/22 16:18, Mike Christie wrote:
>> +/**
>> + * scsi_check_passthrough - Determine if passthrough scsi_cmnd needs a retry.
>> + * @scmd: scsi_cmnd to check.
>> + *
>> + * Return value:
>> + *    SCSI_RETURN_NOT_HANDLED - if the caller should process the command
> 
> Should "process the command" perhaps be changed into "examine the command status" since SCSI devices process SCSI commands while scsi_check_passthrough() callers examine the command status? Otherwise this patch looks good to me. Hence:
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

I like your suggestion and will change it.

