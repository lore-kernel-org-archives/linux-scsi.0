Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFCF7C10F1B
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Dec 2022 16:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235690AbiLMQX0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 11:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235701AbiLMQXD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 11:23:03 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7927EC6E
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 08:23:02 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDGE0qi001446;
        Tue, 13 Dec 2022 16:22:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=VxGnoe7SENzJxYecVBkFksotxwyXsB6Izu1HH5bnNEY=;
 b=pF2oUh05k2SmyYldfC6tRaUVmSwJtxzpAxfep+STozTD93L0Sm9oZSw5UD0K60eVKhv+
 qcB1cXaX57gY8oXpjuhi7rZLqrG8CP/7RVqcY6o5agoXT1+sIDVapKxKwGF48TsEtjh8
 UKHSqsY86ifT1h1aVxOmRzjOi/JCH2eOCLdTugFxyMmkXgaPhWyAzP49DBcf27MszWWc
 HYOJQGb2yEv7OtK3PdALTF7sKlHuaarzecLeebLjxDvxfqyO33qUaalifTT9Fx738UsZ
 nd2RUe9yCsbdAj98RU2P1c68jXY671PUJyKm28NxXmvujfodZTEKr6MBHWlOU1BhIEZJ Fg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mchqswsp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 16:22:43 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDFCUi6040036;
        Tue, 13 Dec 2022 16:22:42 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgjcjk9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 16:22:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIOKtTfew/o3D94XwOBanVXdmA2URShSaS0QL86GtJT6W40MLMKbaOGp+hCl5uKFg8ogi9KMdxy2Ldd+pWHFrm508Wjzlt2H4jOMBUeoGgBYez8welZJGcXXOS8d4JA/5zdHwCThLsWiGr0tfRbxqBzfk9NDbUSSPoL17p1YTSHGwmS105SOgObOfyu+5HFdPLU6lZNCXwD13kU3FF3FOakvWV+nTIa561cMTpMdrRsISLMEhiVttR/e/6FVxehBkfQDuMBCJiea+2+Elg6w5JytSlS2HzgH7gEu3VM8tAkhp5T4CDm1o0w6KV+IU/3RFtpNKjQaDB30fg9A71YAew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VxGnoe7SENzJxYecVBkFksotxwyXsB6Izu1HH5bnNEY=;
 b=kAwBCJ6upwS4+MWtb1LCZ0FAOpRUYGE3Xss/zLbIHF9kWbsYbzMRNmOZP41ApBncTAZQgZUI5gnxqGjQCLxZzw72qvbtF3ib+cV21TKzf0MOGvWFsOta19Z2PyyUJF2PYxKBiUVnjpvOIGIIbzIkfEsSYGy3Ha4oiYXkZo/YSQvV2DXdqsHLqxt2dYzGBF7zMY7PIYMd/8V1CNjrPs7dy8mrqir38D1ohA7jUQEty7wambYkY0XZfUGn6vebDKG2YCsg73OH4Q6SFM2/gjuxt1GI2CE71tpAaTKhhX2e5jhba5yAmvcsuflHokHEQpuarRj5rcKQVqHk3+ZNn2x9+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VxGnoe7SENzJxYecVBkFksotxwyXsB6Izu1HH5bnNEY=;
 b=E5Vkm5HLdv9OKmj7V7OXYTR+tS9QTIvwzeA3odPiDPUWhNg36EGMu7VCj8kMwSAmsfjb0Kib/xVp2UcR6LLMOkp2ZFQzQ4gpz9rBbe3oz0Vs1tqJKmpcbn4vzk2RNKPTzuvgxNyZeTkJLlkHPfDIc8d51We/O5Pi7DYAIRs9t6w=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB5335.namprd10.prod.outlook.com (2603:10b6:408:127::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 16:22:40 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 16:22:40 +0000
Message-ID: <76747055-4b60-a5d0-2b40-8140efcb29ae@oracle.com>
Date:   Tue, 13 Dec 2022 16:22:35 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 4/5] scsi: libsas: factor out sas_ata_add_dev()
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com
References: <20221213150942.988371-1-yanaijie@huawei.com>
 <20221213150942.988371-5-yanaijie@huawei.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221213150942.988371-5-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0440.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB5335:EE_
X-MS-Office365-Filtering-Correlation-Id: a9b24726-95c2-47f2-e44c-08dadd26413b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d7QtmlHn+2D4SN4294m5uoml+VpSqXoZdhY2YBechfFKiZIanHlln/ijB1uiSDuqMiiwDMN6JqUuRhqNZ8vOlGCruHlijmB3C7igDG8i5A29FJADRlcztmtLIT+yHVBxtmcAjHArlASqu+sUT6OqV8XhJIGwRFkheRrcKBc8P4Y55gCICOQV0v4awlXnX+yGX4V4Vdi2xGVFSdclOsXhL8YUVKu9G14fM8eCyDu3/vRL4ZNociEd4zMLhkdCdQ0MNddUXRacj7AVEM0a5UW6pUOvyPkLU9qgdnpi13FlytlvKNwy5uXwNhwWvF8I/qf+FlVokUDgEl1rQ2aeB/3kRqrKnFS0zw3PFWJblX2t+dGlqdMs14HST5P/PgXQSvYQsJPdTJ2z6zepAkaAwyKqkfNCIB1Lhm88j6Lh91DVnqnsSqmmsL1066EgpSChWxzqXulfQyvzaK76uCJV4xtpoh+o8OsLSVVP29+VBX9rfHv9xynfmK1MPL2Sh9YLUdNSHbKQyHrXi9IiU7cIA01NxiNFvflWsn0O8/wK8vjR0ZW0Wfr3eBxcCMnx/EdrTOTPq+ExN59LKy7cPKZagebNr/HA6VH78/sptUSWi8QMIGVWaP32DuTPwsfzkuobpekusg68Gw2w62jvWMPhWstV7/gVUsQO5uHGY5A6S2OWg941Wsl1Ja7XpRLJlg1zhYz4nrigpfUVLBF8G5HBxwZFFsNBJ7m4XmtK+qgHhJbnE2M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(346002)(136003)(39860400002)(451199015)(2616005)(2906002)(38100700002)(26005)(6666004)(36916002)(316002)(6486002)(6512007)(8936002)(83380400001)(36756003)(478600001)(31696002)(186003)(41300700001)(6506007)(5660300002)(31686004)(8676002)(4326008)(66556008)(86362001)(66476007)(53546011)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0RKMGIydE5YUUZuc2oweDFIcVlKSVI3L05LVzVuWmFsUGR5WUZ4a2dRZUcw?=
 =?utf-8?B?V1VBaVRkRzR3Mlkzb3ZWUENjdWJ6STl6VUhjKzV4VktBSit1RzZvZzRJTmEx?=
 =?utf-8?B?ajQrYW8xb3lkRDVDdlFxV2MyMzM5SC9ZNld1WmgyNzJScml3amRXYUlnZitN?=
 =?utf-8?B?aWhBRjVWbmxGOVNmTndOUXRGZFNTYXJiUkFDK1JWYmdxc0Z4VzV3MjNlb1Nj?=
 =?utf-8?B?Y2t1cUFuN0NycGtacENMTGdYL2hHRjg1ck5WZzVERHVoaUs0NllEZFYyZ1Ax?=
 =?utf-8?B?WEcxdG5JVnBGdGY2RzNoWmtpYWJYN1Rvc3B5TVVDOUcwVHIxcjhHKzJVbE1n?=
 =?utf-8?B?UVk4SFZUbVVnOHEvZnBGSFhYRE5FNzk0eHJqUDR5QUJ2NXFvTC9HU3VmQTV2?=
 =?utf-8?B?OUJuQlZyQnd0ZFovZkozM0dLZk5ObnVNT0w1RFNkOXhwNWpKSmJkRHZCN1JX?=
 =?utf-8?B?bHhXbEpVUytUQnlSZFYxZnZDUlNpbWtuTzFleUxIU0F4K0dUd2trTHl1dFc4?=
 =?utf-8?B?d3BabHkrbXNYWWhXcEhaamJOMGJpdUlVVVo3WnVleURoOXl2Tm92RjA2NkpB?=
 =?utf-8?B?VHY0aUovZ1BGZFE1cS9QY1ZDRjZZczI5QXVNNFNkVGNvenQzRVhBUGdJdmtr?=
 =?utf-8?B?aWhIeDdkcXJNamFXSG9MZVZsOVZOTFpsL2hNNW9hcGlJM080LzBVQ0pLZzBn?=
 =?utf-8?B?L3dTNTE4bTJmeHFmajA5R082OThiTzV1ZFJTMUFWN3crdmcwSytKU0JKR3Bn?=
 =?utf-8?B?SXl5ZldZN2lnL3ZVeEpvbHJHenk5ZlYvc1VwQkRqaS9vS28waHBuSlNzeTF1?=
 =?utf-8?B?SWdLZW94dFcrcGQ1QmYwQlpDWi9TVlMrVXdIbzJGcmtyZmNrUlNKVUtNYndG?=
 =?utf-8?B?M05FM2Y5R0hTNDc1cy9RazdXWU9NUFVyVUttK0o0V1NCTFFZZGtLdGtUbENT?=
 =?utf-8?B?c2FEQi8zbUtPN3kwUTlUYTJGeFdySzBTbEpkZjR2eTJuSDZlWkYvM2c1N09B?=
 =?utf-8?B?Z2RYeGptcWlFaGVPSWtxOFFsdE1PQ1p4cEZGdnBpdE5XWW50R0Z1bWNBdmFu?=
 =?utf-8?B?bHMrVlZCVnc4UTZ2eVNtYXNwOXF4OW1jdXlPczRKWXoxeUpkNWxvR0F0V2pR?=
 =?utf-8?B?a1B4NjE4dWpEbTZ1amJ5dHE1RVNra3E1WlhhSHNBWlhKY3kwc3k5WlVNckVB?=
 =?utf-8?B?aWVrNkR1QVZOVGdoMjVFcWZoQ0dFaFdadXR5OVZnQ2dYcHRIZzJjNFlPSlJC?=
 =?utf-8?B?ZlF1aHRaZGF1b05TdDNtRFRFRFQ4eHJJeVlYYUFpejdPaUErN0NLSlJKMEF6?=
 =?utf-8?B?dDZZcE5ua0pqeTRGN1QyMUxla0lvV0o0Ym1KaGNMOUlXK2IzNlhNZnhCQk5R?=
 =?utf-8?B?L1pHeVl0UjhkUDJSN1V4S0Jzc2FDYWJZT0szY1ZEeGtMWVBUZFdjY2QxUGtY?=
 =?utf-8?B?NzBTbzRBTlRGK0dLcXJ4R21hQVAxeU1oTVdFTVFtUXVXUEIzaU0rOWcxVzB4?=
 =?utf-8?B?YW85Y3J2eTByUmhPYis4UDdRb2NUbEcxblRyMFVWeE1hS1BqZEJTQ2lSaERX?=
 =?utf-8?B?RjNlQit1RG9qNnZIaFBrZ21XTG9mcVIrNFZQQndpZElIOG5MQWF0UUVaUzFl?=
 =?utf-8?B?ODkrcldmWm4rUWhuZGpoZUsxb21jL21lSFc0L2h2U0NIbjhRbzZWVno5RFMy?=
 =?utf-8?B?dnBkaURoVWFZZCtpVnowVFFzSGFSSmxJVVI0Z0twV2NNaFlZMzkyeDhLODdo?=
 =?utf-8?B?OVJVWGI3TUJhdlRybGM4ZzNtZS8xR0xnODZqR1duQ1YxdTFwMnlwbkloLzhM?=
 =?utf-8?B?R2FES1dSTTZidWR2bkJqRnBUUDFlUjJSdVNBbVFLRys4MERpRjl3TithWmFv?=
 =?utf-8?B?Yjd0aXhVWGZvNDAxYVVDaTZXaURmN0djbCtYZU1IV0NId2x3bnNyZitpclRC?=
 =?utf-8?B?ZDM4Rkc3dmxTVzdZZUxwa21EeTJYNU5EaVRHRFZ2b0JrQnBUc0pyQzZaajVy?=
 =?utf-8?B?dGZOSGREQmx4LzBrVjI2YlU3SlFGd2Jjelg1NWpWNnJHMlBOQzBtdnBOazlF?=
 =?utf-8?B?dTIrOFdTZ1hrY1VzbHdEY29kUEVpdXdsOGtxVG9lN0NYc0FUWFlLbHBlUDlV?=
 =?utf-8?B?dDdBQU9IYTMzYXY1U05Vd1dWYVFDaU0xLzVHVVF1STk3UFJnN3A0Um83a3Rw?=
 =?utf-8?B?bEE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9b24726-95c2-47f2-e44c-08dadd26413b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 16:22:40.1161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BrFz/DoNLKj2T2JBmKMeqpzzKOkq39FJkBFqA9HIPZOqAi/kgg9MduyPEiBu0OC5cNdSeyxGanohHHLI1/exnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5335
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212130144
X-Proofpoint-ORIG-GUID: WFnF24u9WVHKF98pI-kkwf01gnSh-Hvv
X-Proofpoint-GUID: WFnF24u9WVHKF98pI-kkwf01gnSh-Hvv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/12/2022 15:09, Jason Yan wrote:
> Factor out sas_ata_add_dev() and put it in sas_ata.c since it is a sata
> related interface. Also follow the standard coding style to define an
> inline empty function when CONFIG_SCSI_SAS_ATA is not enabled.
> 
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Apart from comment, below:

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/libsas/sas_ata.c      | 62 ++++++++++++++++++++++++++++++
>   drivers/scsi/libsas/sas_expander.c | 54 +-------------------------
>   include/scsi/sas_ata.h             |  9 +++++
>   3 files changed, 73 insertions(+), 52 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c

>   
>   
> @@ -109,6 +111,13 @@ static inline int sas_discover_sata(struct domain_device *dev)
>   	pr_notice("ATA device seen but CONFIG_SCSI_SAS_ATA=N so cannot attach\n");
>   	return -ENXIO;
>   }
> +static inline int sas_ata_add_dev(struct domain_device *parent, struct ex_phy *phy,
> +				  struct domain_device *child, int phy_id)
> +{
> +	pr_notice("ATA device seen but CONFIG_SCSI_SAS_ATA=N so cannot add device, target proto 0x%x at %016llx:0x%x\n",
> +		  phy->attached_tproto, SAS_ADDR(parent->sas_addr), phy_id);

Do you really think that we need to add all this info, like 
parent->sas_addr?

Indeed, I think that we could make all these prints for 
CONFIG_SCSI_SAS_ATA=N into a single global pr_notice_once(). That's just 
my thoughts.

> +	return -ENODEV;
> +}
>   #endif
>   
>   #endif /* _SAS_ATA_H_ */

