Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A00A7C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Oct 2022 17:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJTRVQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Oct 2022 13:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJTRVP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2022 13:21:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3890D1B233B
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2022 10:21:14 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KGwt8T015155;
        Thu, 20 Oct 2022 17:20:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=LKWP+Vd1xtskPeJJdQ+yH4yIllhPpbGkvvQz5D4Jass=;
 b=g7c7S/gFkj9YYPS/4nf3+baynA0kD5z7gM9w6XKGQZorZQWnbMROC+oYJshFclXik873
 3X8+lj0j+1Hvn76BDTVFWHyeWLUUJTymGPXVjzL790TsVJc0u6UnIYMDG/vPqA1e7E8L
 rYth+nv6HpdA8xD3jx/xKzhMR8G2ijOvNmhI3a0jObpkVjZ0IcnB/jp/vwmNStBQInc8
 RjIJ3iLzHRi3qE+Wcfex3/4bltK6v9+mf1VuZTkmFyOBRnj5/eleEED+NLhfTtgujnqE
 jULQbQd4yVyi2YH25qcjMTb4RROedU0EX7fWi6SLVti72yRCdqAQNehBLut5/tpkS8qG kg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mu06787-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 17:20:46 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29KFQV6l007240;
        Thu, 20 Oct 2022 17:20:46 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hrd17fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 17:20:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DoTreXE5VrZB7jFSyFmwsW53xCozzPx8y5lyYow7OGUTZFRQtuaJ8o9fCSwk4IfjdGcZWrkxnXRllDhLzVeQ5uuP6WSdU5x2tl2iCT1nxyezKxY7JZbfw3uNyfjCWkhE2K6fBdV0q07S+poqlslu4U91QMfpYh4T4K3Eal9KHAItSwLwACooWcdUvswsqaFeIIiR1q/t7Ny9aG7ZrXRrgHmqh36t/56wM1Q2Z8vMHsHbu6SmZmUDoIyfCv8Qrl9c0lsXSidqqvAL6IZKNwJ95CvtgJnsYg2yI2apV3M4fXcE3Q0qtkzNhSJgo6LzWg+6lP07xPJQrtl7W2/wVKoaKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LKWP+Vd1xtskPeJJdQ+yH4yIllhPpbGkvvQz5D4Jass=;
 b=eYR5fOrQV2OayKIxCSyRg/kzmfcB2YGeADXqub31zJFWAzu5bbnVrkXGWDkAxVFZGkyCN52zWooLoc47sY9WhzolYK4R4tlJUxVLSCCJmKYVPQAMOCvpAy3vQ83Q4AuV5jYBAT6PzqG7896ZS4TL65CW07KmzxNGLn0XaL9E2htJpGVvKuIHbJQbR4zLWcFpWPZm9JWgcB9FUKUaMjnLPcDMZHidKGOZUNtLlvsakPdto7rf+6Zf7bmhmIFTfUTy7m9db85ijpnL1hLXqAJsh7B2OJk7bgNm+OzbqUf9EDdTKUJw7isnwy4HRXrhGLCwcx4ghLKq3Q/MaH/sojYJXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKWP+Vd1xtskPeJJdQ+yH4yIllhPpbGkvvQz5D4Jass=;
 b=oSXoaKgVC0zMrgecf/vxSg22aw7BE+IFlyk88N9nIqEYNZlUZTjkz6BbhaznI6wifcE5U3VnVTXY5+WQmrHiUjPwU1wcL3t1lAvVsTkk3fSmHtaHswJ6NTBfQRRCkXkrW6CKdbRtQUjBvO0NNbtB7tD3DRYzj3YxhlRaMNYaCYg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6750.namprd10.prod.outlook.com (2603:10b6:8:133::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Thu, 20 Oct 2022 17:20:44 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.035; Thu, 20 Oct 2022
 17:20:44 +0000
Message-ID: <e8bbf2af-33d2-2f52-e3b9-6d4ed91421be@oracle.com>
Date:   Thu, 20 Oct 2022 12:20:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v4 03/10] scsi: core: Support failing requests while
 recovering
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20221018202958.1902564-1-bvanassche@acm.org>
 <20221018202958.1902564-4-bvanassche@acm.org>
 <b4cb1875-19f4-c7b0-a1d3-4f41418e44fe@oracle.com>
 <cd2d08ee-5ebe-6c23-8896-5e684dfb03a4@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <cd2d08ee-5ebe-6c23-8896-5e684dfb03a4@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:610:52::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6750:EE_
X-MS-Office365-Filtering-Correlation-Id: 217d74bb-9660-48e8-2389-08dab2bf6bb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b/DHxtMuVlIoAi/LfJdy+Hqm0evroiCO4bUyuv6gu0+dghfCHQiH4fI1gZSAdG/xkHVHQ0yqg+5x52qmaVkDx2/0dMIaUx65cqq6UbUul0IxlFI39kWS2iS79DOXkSVoOCMKLcw/zlCSSPB/O6FS1EoTSVAKm6KfZzzt8z5sWXC/LhGGPuYLBUd3TEbMpRR0k5IV8qne/0CTg4j/kmuyQBS7kbAYcyTRj+zp+qSs/gKYeqkIQ6p/VSSoEfQvGPvIAqv5Q/d19LyVYmUuIXRaiyFaV1Tbk1hvSDyhFcmZknid+GDSfSuQj46bFQOVZPyeqjIm0R/dgPz4p3Vtisxatpdbcwh98EwxJJZjT4xu79X9/XtFswKDDbdz2I0oT8dBjpsvgFh9qJMK/0oQGYRxuvREazGXPTKzQPY+7k9QZf/xLrL7Ed0LUSLxZOQTZ0jb/b/Y1ftCFySm+OLxxsESuzK5XVkaf5HvMQeyfZrsAQ0zPXFLXiSbePizILtXWvt5mOxQxw+bxYIZrhPS+6DPtcxdudDk7KWjWyxDeO2mcUjzuGEIjwzF6YODrK2KJ92wEEgxLw0L9EsrwBaLxCCjWbm6f+nlKT9FOFyK9e0MH3AEPF7jkypKk+MqxoDuHRG6OICkat01cb5pOMqQR/QLZVGksB9rNRElUJVxFtFYTwiG33+kVR6kddIot/Sst2fTeoRCNFqoQA6UsXFFkd8yEeyNXYQGP2mmV4GX3t9V/08dtJ6pvqqnMGasrjTTC6pYHPjjJ3jgwAHBHIlmgZoh4oV0/oVNc5N2OGxBL2K4rx0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(136003)(396003)(376002)(451199015)(31696002)(36756003)(31686004)(38100700002)(86362001)(2906002)(2616005)(186003)(5660300002)(53546011)(6512007)(6506007)(26005)(478600001)(83380400001)(110136005)(316002)(54906003)(66946007)(6486002)(6636002)(41300700001)(8676002)(4326008)(66556008)(8936002)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NjhtbFdvZUlGYmNHVXF6d1AyQmlwMVpiallDS3k1d1BBU0o5bm83TmpCbjcz?=
 =?utf-8?B?Tlk0bGMvQ1hnamtaS1FCdTBXMXdicVNORlkzVDFJeGY2K2tlWDJHdVoyNUtq?=
 =?utf-8?B?cUJsYnR1MjFPbk51RXNqQnQ0SFM5cXBKU0t5YXFTOVNzOS9rOCt4OVNVSVZR?=
 =?utf-8?B?QmN2Z3BFWmNwbG9QMCtTMkVIdmVrVzArSkI0TW1UbWdMd3JzeUJWc3ZJc092?=
 =?utf-8?B?UE1ydXNnckxxV2ZUK1plOFB6YlZDbEwxVXQrWUhLSHNoa0VaTnRPZ3lpblo3?=
 =?utf-8?B?RjBKaDRFY3pwVUF4VWdac0dpRitHV1FacjZDS0N3d3R4UjVWTjAraExTcUhh?=
 =?utf-8?B?TzBGNVAwaW5sQ1BsNzhra3hGWmhwVUxqRitrZ0RCdnNnZ0U0WGJVdlVnd0VU?=
 =?utf-8?B?Mm9ONUZqNG9tTlpqMUNMUE1SeVBZZ2g2WDAybGxKeDd5V2VOVUVvNU1MbjQv?=
 =?utf-8?B?VHpwTkxSZXZva2FmdTNTNXo5NW42bWxaQlptaEMrRFZ3cUxYQ2RKTnpmeTJ1?=
 =?utf-8?B?RmE5d2NDNHlJVjhROURMaXZRTll5aWNuWEE4bTNsV3M4OVV6cHEzTXByeEVD?=
 =?utf-8?B?ZjZCc1JzOTlzV2NpenpBaXRRSEt6SS9WSVpYUmlTcWJ3amhZR2xYaGhVQ3hD?=
 =?utf-8?B?UmlZcjA3aXpXbzJGN0hXOU1JNjA5M1hmUDJTaSs4L0l5OWtxWGdTdWFaL0NQ?=
 =?utf-8?B?RjlZNEluQmFmaEFtUFFwalI3eWlCUkZZMzJCYTJEV2xlUG92SVA2RUhEbmJi?=
 =?utf-8?B?VTlQTUJwRXY5dTFURjcxYWdKOGdJVzcvY2JmY1NYT1ptN2ZKVnRsRlZHVnpT?=
 =?utf-8?B?dFlQbVhFUVE3a2ZIbWFFZEw5d09GYmsrSFB2UnkzOFZWalFpaFUvN2ZvV2w5?=
 =?utf-8?B?YTlpbmQ1eTlrQTJmM0gvTGU0Q0txSDRvZVplVFo3RTNsWTVZNlVnZkJrKytB?=
 =?utf-8?B?Q09iZzhVUjNQTW9RNUZsNytVanREN1hMOUpJTWpmbm1LZU01T0x3OFUvdW8r?=
 =?utf-8?B?RGdvMTJYWUEzSk4wVHFSQnBWY2JDRUlWK2hyek9PTCtBOUU1RlMvQW5ObzIz?=
 =?utf-8?B?SDRqU2JIRDl6RWoxSEZYekpqWTgvUnRsQzVDTy9MSTE4U2FKaEphYnZDRUFh?=
 =?utf-8?B?NVp5V3dFUEt2ZkhSQTdMbXRscjJrR0k4enExSm05aVJHK2w3cXJHdFduREVS?=
 =?utf-8?B?ZVdueXR4WmhVS0NIZTM2QW45NnZSSVFLdjkzcEhRZGNaMDBGNXpPRGhxY3Y0?=
 =?utf-8?B?eGlWTlpzc1ExTDZ4SXhOT0NiU2ljOVZpSDVZODBTTTZ0NmNuZXZ5VC8xdkxn?=
 =?utf-8?B?c2lFakFyb3U4QVljY0RPUGFqTEUxeVFOQ3Vpc1NYam0yM2tlYkxMRHozYmVT?=
 =?utf-8?B?a1VLTnB5RXRGU0JtWXMvVDJyYXEwTVlSb1lLSUpWc1N6cWFNWXNoZWpsbnVm?=
 =?utf-8?B?Mnc2L3lXRENLYmkvQ1JYVThyQS9TbVYyWk1FNTgxdk9HYW01dThUQ3gyK1hn?=
 =?utf-8?B?ZHBPcUhPV1pObTZGNWxxWGVTMDVRQXM0dmtKdjkwYnBXUEY4M1U2S0gyM1dD?=
 =?utf-8?B?TEJoZGozN3N2S0Jnd2h1cTFKc1pJU1VjYzMvV1BURC9rOHlxWm5xNWhCQ3Vm?=
 =?utf-8?B?RjQ4M3VvWGF2Q0VHU3pXMHVKV3doUG9RRklvM3JwbXZTSDhjZHQ4czdCSWFz?=
 =?utf-8?B?WUl1emRVd2U1c3JuTmNvZDFvSlYxOWhJQkdENVVudjVEa2dVbzVtcGFJMlZW?=
 =?utf-8?B?WE1adnlMa2pOdWxOK3BPNEFoTU1hL09QakJXY0FXWmZvbERoOEVkT0QwdUZ1?=
 =?utf-8?B?dG83WHdENU04ZFVvbkRWRkJFcitEdCt3WmZEcERZa2dXeG9adDViU3NjNGZs?=
 =?utf-8?B?dnl0cnVCQkJKUzI4WCtONEhSamVUV0p0cDByMWNiRmRsWC96emc5clZYU2lh?=
 =?utf-8?B?dEp3L25qVDdYRFBCcWdLemd4V25tRFVUajlqUzIzVXZqdG1ZRmlaWkpqYjdy?=
 =?utf-8?B?KzBIMHdraGNkb3hma0pOekJXTk80ZmlNamVWYjhXT0JyaG9VUWhrdWd5YmtU?=
 =?utf-8?B?akx1cHBxU0pYVkx1SjF2YTZ2WWxseTNjZURleE9jTG9XM2xQTDlMYlgxd0VV?=
 =?utf-8?B?MFRhVmplTThlaG1LbFpjaGlyN0JrZVJpVlQxUm01cHFicThNM2tBRkI5ek9u?=
 =?utf-8?B?NHc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 217d74bb-9660-48e8-2389-08dab2bf6bb6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 17:20:44.3817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jbk2QNFiLMq0akhBS6/TKeL0HBfoX3KuK3dPygnExr8PFepZILk5H7Of60I7BBuIFBGlED2GfUCF5GxBsMI4Lqtao+UxDo5pSOoBAaxHgFc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6750
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_09,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210200103
X-Proofpoint-ORIG-GUID: MECfvzkLnsLxi2cDte9kWjmEk5vbCz68
X-Proofpoint-GUID: MECfvzkLnsLxi2cDte9kWjmEk5vbCz68
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/22 4:11 PM, Bart Van Assche wrote:
> On 10/19/22 12:52, Mike Christie wrote:
>> Will we always hit this check? For example, if we have hit the
>> device's queue depth limit so
>>
>> scsi_mq_get_budget -> scsi_dev_queue_ready
>>
>> is returning -1, will we not even call scsi_queue_rq? So because
>> we are in recovery and no commands are completing, we will be
>> stuck waiting for a token to be put back on the sdev->budget_map.
>>
>> Do you need a similar check in scsi_dev_queue_ready or should
>> the check go in there only or can we hit a race for the latter?
> 
> Hi Mike,
> 
> A later patch in this series uses the SCMD_FAIL_IF_RECOVERING flag in the suspend path of the UFS driver. The UFS suspend code waits for the SCSI error handler to finish before the UFS device is suspended. Does this answer your question?

The reply for patch 9 about no other commands should be running
at this time answers my question, so we should be ok.

Reviewed-by: Mike Christie <michael.christie@oracle.com>

