Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B51DC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 20:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiKJUCP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 15:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiKJUCO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 15:02:14 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D18A1B4
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 12:02:13 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAJtlSr025852;
        Thu, 10 Nov 2022 20:02:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=XFg81IqTrBMkBpDpIGT4RZJtwY5WB0M3xiQ0NVOiBUE=;
 b=NtGE7Iyjsv58Jm2ild1sE8KcnsPHAQ/cSUBmhMNSxDLW1qiiWqdbIZTJqiKc++8Syujs
 xs0IGCbOEdXbXUfgv0IzBdEIuryl0up9utlt6aFGkGF7+v8xBJcXWj8U21kDbCUN3wuV
 53Af3fFBzf4gQKzKoE/LCeznvX9fFkeFxEZSUPs0AUEORsMhjkUvRA9nv12oN2zzTaWK
 zhsolQMZJuAjHC3lN4jPeF3SVdWLbM8EgF8/XsW7c4ZdmCZMFo4+uPdNUU90pOLSUHgK
 svMeIJzzEG+wm7cYPm1wRwotlZ4gpG/oN/0Wjh0rOBhMEeVvCIoS97+ZOtgz+5rqyHGI bw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks7fur57c-33
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 20:01:57 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAJI7P5004208;
        Thu, 10 Nov 2022 19:26:33 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctpvajh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 19:26:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DP8/OBLkvxJY0emoKelE2nqcDpajourINbaB0HnQVEWj6s1nR0hqDdAf3aBV7s7vyF2tKCvMxGjIgGM/vf0xc/uew0+9cVfuxmyQpZzJQSu/doBnPBv6ZxhY05zkst1VIWaH2mtUiiyddHi/rL8lr6jY9PQS93+UTo465+9/obfDt7RVfuDZLuwC6CvneQsxCoDzFKpWw8ru/tlVoZUFjzDlK7LuU524vyKjlG7isBrND6Xa890wcqYPftnM0zGFEcWWQhBsXHQNm9ECBHJkx6CEEK1Xs3cv2l0dr4XALnXJzYLhiQOXdXC2rTsQr0WsNVz545ToImSKiv3CRi7XRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XFg81IqTrBMkBpDpIGT4RZJtwY5WB0M3xiQ0NVOiBUE=;
 b=OQ1qgxAMzhw+vnFu8PDH1gWbXhT36WxHqH7OfVWFPm1e+kKnBMFGVeygn5XgeCtjqWhabzRWK+yFXj2YxaZHI4SjJf3AfZAM6jyqVlq/H1CpD8+T6wMa3yT09RXbTmHwEN0VITP8hXsJAcRCx1NO5rJ7JAGlAEKo6rdUCDklobWl/5+1WDlWnm7c9s6EXExytVjpt2Y/55NyQivSpS/GKP2cbWHW/M+VrGWl4u77YNJLpztPxbsAmzRc1J85mCGaVAh3vRts0uKKeAXfdk/OiC3Gr/B6LudKvoJy679hgYOlI8+EZZBaRS3kzG1Qo57F69LkhhSi0gAR7TXrEE9oxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFg81IqTrBMkBpDpIGT4RZJtwY5WB0M3xiQ0NVOiBUE=;
 b=pE02yBwJ46Pydf1WXVKCH/iREKrmxVLYE6N+RBDEvTSTjjtMWmDawz38LEt66rS6rcUWZlfr7x/rxUB7cCJhewEyt+N/vDD3+3KiRiwhuSF+V2S47bUm0aqA9oE51yqueZQ83aBYcYpwHmiIWM9/Is61HBskmihKoJIupq6fBvQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5902.namprd10.prod.outlook.com (2603:10b6:8:86::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.13; Thu, 10 Nov 2022 19:26:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 19:26:31 +0000
Message-ID: <a215068e-a5f6-34ce-2b23-8f964b09db4c@oracle.com>
Date:   Thu, 10 Nov 2022 13:26:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v6 03/35] scsi: Add struct for args to execution functions
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
To:     John Garry <john.g.garry@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221104231927.9613-1-michael.christie@oracle.com>
 <20221104231927.9613-4-michael.christie@oracle.com>
 <1bd9df90-fda6-270e-e437-e1039a0a8b76@oracle.com>
 <02dd9d58-a5dc-2733-5b34-481f276fe231@oracle.com>
In-Reply-To: <02dd9d58-a5dc-2733-5b34-481f276fe231@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR17CA0021.namprd17.prod.outlook.com
 (2603:10b6:610:53::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5902:EE_
X-MS-Office365-Filtering-Correlation-Id: 74447c8f-9fbf-4e2a-a923-08dac35177ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qY2HAF9msJ+/AHR/lkHYrNbekql9eoElWNzPNKmyAIzRWuV844AfisAR6LSQQWqwZSWCzejf7xnR5HVQxswFPf5fZVp06n653vyiBeAN5BgTpXM4vde751GcfUbhcPiTjbEa7wzkEHR4QrPiyopdQ8l/Z6iciu6Kmylwe1F2CFPbK24cVPAlYRjHB+rDzETPMOUF6ZymjQR+XeDTS9xspuenQhQ7SBxlgcmdPTmDkO3Vx8pxYbwL7sSKLHHk8LoPT0qFOjhDT8K4iktSXpI2MspvbH3lEmpAyXUhOGFiYS5KCazVyOLzomcKnm44JMupve/vulSrdxsq8loSSKCURAT/E0fRPb5mpscQOKLThrIyQhM416hYTZdvWSgs7RmxbBdgazsGwYUKl1GKDfcpHWGQ2eQDJmK9SLMy3L1IbVEq3c0GJuT59UScOPzEyhTtpubHezzA74w+z+GolbUzV1TCivbUBmytQaIyMQSALP5WVJEGA3qqnlilaliCmKI08wOe5OtzR4wWZM16YPfLblow5cJhwRcpHts+cZRUDa/h1TYNfJS9QSZyb7TOhXvagPe1+pfVbfJIx0U2z/eEARpvqU3Vbya7z/LAPohba3e6KsASnW6rOVzSfg88Qv2DDfu7LSLpk3ood1hqh4Vlr/TlU7NhtScYetUrLzHam44AzPW6dgsJLi0eBYmgbp2l6qMGyRi3tk39MYOJNC6kIkW+jmpRVhfnimD3Bbk4zAjtZ9YSojbn0kFBM3PJPNFEc65APi9q706yYJSMGlzKEHhpc+82TyZCFSiqkIwO2a4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(366004)(376002)(39860400002)(451199015)(31696002)(86362001)(38100700002)(316002)(2906002)(6486002)(5660300002)(8936002)(66556008)(66946007)(66476007)(41300700001)(8676002)(186003)(2616005)(83380400001)(478600001)(6512007)(53546011)(26005)(6666004)(6506007)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MEJsc1JTR1h2emltTEcvajZGNjhBak5pR1E1bEJMc3VsTlhUNlNUS0Zramds?=
 =?utf-8?B?bmNJRDBxdzBNS3BPaXBjZGVzNytneXVCeG40OG1zeEZWaHRSMXZKU3N5cmFW?=
 =?utf-8?B?TGF0S0FqdEJvK1JVb3dzZXVZMDRrMlRGdEdQbDUxdW9SOFVYVkgrdldXTEJY?=
 =?utf-8?B?WWtKUHFwSk96Z1VJWjZzNTlyQ0dGMUhyVk9ZVERDU216Z2diUGVkMGdsaFBE?=
 =?utf-8?B?MU9LZmdmRmNYNlozK0l2MUp3NFFyUm02enNGNWxidUU0Y1dBanZ6N2l3MXRp?=
 =?utf-8?B?UmR2bGlYWTFHVnQ5NjBlTk5VMDhYU0NacW95cERyZGlKU0lQZlR5SVhuYzhR?=
 =?utf-8?B?b2xpdVBFUndJaUp6THVqbVczN01ZRVhWb25qYXEvTFhuMEdqWkdvcHVkTGtB?=
 =?utf-8?B?SnRNZGpDSVFnSUdOWnlDZzd0SzhMTTFzem1xK0VCa1hMTDF0RFo5bTcxMlpU?=
 =?utf-8?B?Tm85UEpVbVltV2gzTERQKzhmNHJPZTdHbmlxMSt5S1B0OWZhU0tZeGIvTTBP?=
 =?utf-8?B?QzgxdGZTb29JZ1Y0RUFjUTJpWkl0K0dUbkpTRkVMREUrRnUzcSswUmxlRkhJ?=
 =?utf-8?B?aEtEQkZpZnNKd1AzaXhwNWhSQmdodVNQU0gzNVh4ZU41VHBRWGZmOVVTcUdJ?=
 =?utf-8?B?bmVWUERjeVhzZVNkV3RjQXVLMFJDbUlVZmpJNEtKcG1EVXFuSTU2Y0dYZnJs?=
 =?utf-8?B?amlJazVBdTlrdEFlbG1iTHM2K2hTMzN0cG04MDRYQjBWaG9GbU91bGhaUDZ0?=
 =?utf-8?B?a3dzQWplSFZLOXRQamZTV0VBTEFVQ2x2SXl2a2hoNjJBKzRjZkwzaVZram4r?=
 =?utf-8?B?WnhodS91SFZQMitxSTVGOVJIeTdqNC9pbStiWWVWMERldVJGcXRLYkc5elVl?=
 =?utf-8?B?RWJnQzQxb0liQnZnVzFqcmhwT2hSbVl2RlJqUXFibUdwSzNzVlZmUU9DMStv?=
 =?utf-8?B?WGVEMmFsZ1k4RzNCZHJqakpZUlIyYmJqamlnZ0hlanAwT1pDRmhaZVlremlr?=
 =?utf-8?B?aTJZK3B5VVNVNi9heWZSMS94WDI5TDZnbXZpZ0JxM1lHUXIvNkhUSEZ2UlFU?=
 =?utf-8?B?UStPcm56VTErOGpBZjBpSk5rR0pqS1c0dm11UVNuaCtIdjhNMXcxOTR5QXBv?=
 =?utf-8?B?RGZVTjlDM05qZWhUaGliRlU0VTZScWVOMWZYWGxFb3hlSGZxaEVJcVIvQTNp?=
 =?utf-8?B?VkpkODIwOFEyN3hwZm9GWmNoRUZvamlPVjVKMnV2YVpNMllyc0R6eUNRMVRu?=
 =?utf-8?B?S3VIako0SnMyR0R5Nkg3RFJabG1VNXl3SGZUUThHUkVjNGZHTWJrYVJuZWJT?=
 =?utf-8?B?N2dEYzB3VHoyM2hZT3V0MnhuSUhTK3hacVNYZ0JzMVVlb2ZhWFpQREMyeUM4?=
 =?utf-8?B?ODUwN0tpL29IVHJTZmhTMWJPTjYzYUJ6SllzUVBycWFLOEZCdmFQaFZ5bG5D?=
 =?utf-8?B?UjFIWDc1OWRnY0h1U1J0c21vVkZKV2MxSGRqME52R2xpT1k4NTJEbTJvemY2?=
 =?utf-8?B?akh4YkRrNjhzeWJSUVZ4MXNsdTFPVVhsTWZBWEhMMHRRcmVYS0ZaM3ZEb1VS?=
 =?utf-8?B?eTEyU0NicmFrS1JnbmdzOHNKK0pxNldhN3lUWnFuRDRIV0Jlb2Rjcm1hVTU2?=
 =?utf-8?B?dy82dUpVb25TRHNlcUpWdWtmZ3FFc1RBT0NzYlovdWU0cHIybGJEams1UTBX?=
 =?utf-8?B?dDRaODRWckU1NG13UDFyNWpnV3crZnNGUVBmMXdHUWprVXk1TjdDMHhZK2Vp?=
 =?utf-8?B?M3ZnWTRLTzhtaGJKK2VVRmVZZnYySjBSMzdJM1JEKzV2ZTZiMit5VitjWW82?=
 =?utf-8?B?YkZSaUJrdTVnT2JSeURadjljVEZQQmN2ZTVMODhLVjl5a2NpWjFjcEJDZ2hL?=
 =?utf-8?B?Zm1SSXBJK0RlbWt6N2FyZ0NXWms5TkVqQ1l0TG1jTHFvSml4ekhxRzRDWE1l?=
 =?utf-8?B?TkgxVXg2L3ZVbmI5U1FsczB0VkxZdHMybjArcGxJWnhmZVYwTjFMYnhQN3hk?=
 =?utf-8?B?dCthVHJKWGNicHJYZG9pWU91RjZUMzZCZ0tEVjI0K1psSFd0ZGU5ekFCRWI3?=
 =?utf-8?B?K2l0UUcxWGxDQ1lhMW1Ddy9Ma1FIaDdtT2hBNTVhQllyVUl3cHBWaXJjV1Fx?=
 =?utf-8?B?NEV3b0tHTzRlbE41dkRSdU9DVXhuODhyL2tPVGY0Yzg5dGt6U200dGhjTWJy?=
 =?utf-8?B?TVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74447c8f-9fbf-4e2a-a923-08dac35177ca
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 19:26:30.9633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /NXohk9nYupqD22w0ZOmTmphxcbi9TmLIcIUg9jK9oqMkPKS6iafNTdIs8bmG3VsDQQD5vEPD3EPq5ICzmffWSZhXwl+Ok9XmLUdUFanW3I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5902
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_12,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100135
X-Proofpoint-ORIG-GUID: IMJgpX6GJzUmZRU-z3UIeT87-WXtiL3C
X-Proofpoint-GUID: IMJgpX6GJzUmZRU-z3UIeT87-WXtiL3C
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/10/22 12:40 PM, Mike Christie wrote:
> On 11/10/22 5:15 AM, John Garry wrote:
>> On 04/11/2022 23:18, Mike Christie wrote:
>>> -         req_flags_t rq_flags, int *resid)
>>> +int __scsi_exec_req(const struct scsi_exec_args *args)
>>
>> nit: I would expect a req to be passed based on the name, like blk_execute_rq()
>>
> 
> We have scsi_exeucute_req now which works like scsi_exec_req. I carried it over
> because it seemed nice that it reflects we are executing a request vs something
> like a TMF. I don't care either way if people have a preference.
> 
> 
>>>   {
>>>       struct request *req;
>>>       struct scsi_cmnd *scmd;
>>>       int ret;
>>>   -    req = scsi_alloc_request(sdev->request_queue,
>>> -            data_direction == DMA_TO_DEVICE ?
>>> -            REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
>>> -            rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
>>> +    req = scsi_alloc_request(args->sdev->request_queue,
>>> +                 args->data_dir == DMA_TO_DEVICE ?
>>> +                 REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
>>
>> Did you ever consider just putting the scsi_alloc_request() opf arg in struct scsi_exec_args (rather than data_dir), i.e. have the caller evaluate? We already do it in other callers to scsi_alloc_request().
> 
> I did, but this part of the patches just convert us to the args struct
> use. I tried to not change the types to keep the patchset down.
> 
> I'll change the types in another patchset,

Oh wait, I could probably handle your comments in this set if we
wanted to.

scsi_execute could already take the block layer flags, so we already
are doing that type of thing so when I was thinking the scsi_execute
interface should be less block layer'y I was wrong. So, I could convert
the users to use the REQ_OP_DRV instead of DMA values when I do the args
conversion since we normally do just pass it in the directly (vs libata
where we do some extra work).

One thing that is weird to me is that scsi_execute_req is the more scsi'ish
interface. I would have thought since it took the req flag since it has the
req naming in it.

I don't care either way.
