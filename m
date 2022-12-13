Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D4CAC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Dec 2022 16:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235955AbiLMQOE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 11:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236007AbiLMQN6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 11:13:58 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9601721268
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 08:13:54 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDDtfJf014068;
        Tue, 13 Dec 2022 16:13:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=TxF4/aiP/9yY5BZYG5VknWPphf3l9DZE9ztfIH6TnUU=;
 b=fHL2yTklE6j1MPn981zeBp7ccvVgPPM2NQoSnslKZhjDhdMyejabwi71E/hUfb8uNHEP
 90ZyJQjeZ0iIV4W40z948FF9S2lfWgF6XOZ/Z33GfL4XGfr8GTrW1iJr1gzACbZvxEAV
 ax/kcMryBv2Jmbe8ZilX558kmq0dQC1E2wCzIssYQsaGVD3yZaeQedYr36owmVc1j1+b
 /QhphXeMuC9c8gpfBbTwq/LExjPkc/2TrTps7ADWw+Op5bEJLMkiWvRhvSasuDIdN4WQ
 SXNnIs6NFiJBXRJ/rrS5MudIDJDDEP/t8I4fpxCuVbBKYM9fbG2MjLz//2cbzbrrxfcu wg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mch1a5u7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 16:13:33 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDFCU5O040026;
        Tue, 13 Dec 2022 16:13:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgjchxkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 16:13:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ze/ftUg1gCyVEjt4p1nhzX4yAMErqWLxHNisk6m53v5oGciBnT6GAVQihmIp3UQ4C8Qbmc1xA5n+3tvKEoh4rmGyWLyhzwyFKAbOnTv1R31cqKghieQlMLtE6RqDCC2tNhr8F5/82jjUDywe5iZhVjw3ZtRYR/EBY1XSXVdRz5C/7J7ym9LrIEr2vq2FU9ZCiYvwic+J4KM6u8jkiDNzDZmIGiC+vPTSNd68Afp82v+I2J9TNtyYAHggshqdK6l1Ua55qfTKOwvzHGe8mFc4G8RtkfeTl1MNeSnSRpG+G9RhvPEZjrfDu28uCaQiAg4UwvG8WR+DyNQoApvAwFCnXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TxF4/aiP/9yY5BZYG5VknWPphf3l9DZE9ztfIH6TnUU=;
 b=oH8jaOSS3pIZtvQxITs+9FFzlwMFJhZX6gRAoHe9rIFKQH2oszLkq5twMihEM2NdZjaw+6BpjiONW+yKA8IA0Ze4Cxq0eHFdopy6sBdSnArOameRATz4qMyR/dhIYjQaQJVnhIb4n6ilG4TsUiNUBwh/dM7+5atNjJNdr2bQsTRVs51wPI6lKYBtBRqXT8IjYSWrfplZ50FWf0DZX15ejV2b/MnUolhNcSI/QAFRHKSoFoDzs8MbSWTMMhnneFpurDdQoZDIdSjol4CS/xAWc8ECCZ/yji4YEFxRFpbc6Nb6905j3AAYWu/tPxaVLLfilHJM/Q/9Ij5rDcZGY3ahIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TxF4/aiP/9yY5BZYG5VknWPphf3l9DZE9ztfIH6TnUU=;
 b=oApo2IYrFD4YB7e1wl0KYdcNFTITqBnju8/noUT+vtuYQubm6Z8wrDq2PGhjPZVQ6HJdRYAURguCqq7AvgQIe3iRvGdcxZmxg5XVkVw1M7cYgCL88js+B8xbZ6/QijThtMPL1tXI9mTG6Q8COdgXQL6sscFa91WWtwf0obSmcIc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB6146.namprd10.prod.outlook.com (2603:10b6:208:3aa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 16:13:30 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 16:13:30 +0000
Message-ID: <72fd6542-88ed-720f-b05a-076c62399535@oracle.com>
Date:   Tue, 13 Dec 2022 16:13:26 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 3/5] scsi: libsas: remove useless dev_list delete in
 sas_ex_discover_end_dev()
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com
References: <20221213150942.988371-1-yanaijie@huawei.com>
 <20221213150942.988371-4-yanaijie@huawei.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221213150942.988371-4-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P123CA0005.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB6146:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b4d8fcb-5ed4-4b71-62f1-08dadd24f958
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OJggUCNVUin0vnisJp4HJ273h15GRgTDmb+KaQs5wZ7CqorL/F+iG9WMMYi7Sk7VEh14K3OxIgMmF/S3GPu7iCcsLjAbajEbKhVWyS0z6hLF3azAKeHkDZN68P+WMnUZSPjCBrXtwedHaSdn+4dZirfCEZ3UkxXbVSMYi+MGOmgfr0PY4biTiMQ8uUAt4qixzHmxe2B2pTT3XTfg9pFWhz2Wc99Sc7ITeJHaP6UYHqMTStSuM8NlpCXc/n29ZG7KSEbQqSiYjOvZCZCd874xM67kC2Apbqv9fVgnxOkjiWKm6eJi2MuUu1wKX6HuJAIF7LYrTy9mPp4sy1Lujk1JbGsr7mQRVtG/z5t/AcX88KaKxEj19dfXEOwe7MpjT427aD5l1UpDji2hWB4voLK9xXX53WIlUwHdIVBZ1WT5az82EfH4TBCQe3588tpQfTd62X0TEjbPYxl5LtvTnhFrrRsVvZUqYj/wd3x8LLUjpEUCXsIA4ja6LbTjF/R5oy2jfUNtnwIQGBRPRawjFEvuY6SuyOS66IBFcie81tecxlVl/5HFap2vOsjfWIR9hHFTnfiv+b8HGOnP1auPl6yHWZBcrp8yktX4rlzIntRSfxJmQB72MV6g7fOmf3KFhvNi6FH6b/l26Hvs8G/cMv+8POIkcBFVPrnarxm1vxPJlBHS9N8Qpq9KX4KU5JBZ9H0cafbhJrc5O3c7u39E7voSTf+SjMSjqIM3iFw6CC6PxAE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(396003)(39860400002)(366004)(346002)(451199015)(31696002)(86362001)(36756003)(6512007)(316002)(478600001)(53546011)(186003)(4744005)(8936002)(66556008)(66476007)(8676002)(66946007)(2906002)(41300700001)(5660300002)(6486002)(4326008)(83380400001)(38100700002)(36916002)(2616005)(26005)(6666004)(6506007)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUg1ckJnc0tqbW8vSFErZURzMWxXa2E3Wll2WExNRHV1ZFBrb0p2T29VeGVH?=
 =?utf-8?B?OHV3TzdGNCtwZmdIVlEvbzJHL1FyenF0a01JL1lHSHc2VkU5MUtmSDJGVEow?=
 =?utf-8?B?VE1JSEgxODZJNDNrVnJ6Tk1aWU9DMXhuZXB1aGU2TEFGT2dmWDBQODArS1BB?=
 =?utf-8?B?cjR5K2M1TmVIYmZnS0diRzVTczJMRXl1SnN0ZVZqT0dUQk1nYmc1QmRIWmVQ?=
 =?utf-8?B?UlRLekV3Ry8xUThSUHZ4TjRrbW5GQ1BtS21xM3JwbUxLUUdmZ01TVHk1OGd1?=
 =?utf-8?B?azM4T1hkN05FL2tjWFRDd1FNYllpQ2c0a0JZcC93MXZKU3RMVVVuUGx0ak4r?=
 =?utf-8?B?VDZHeDVQbHdKeFBybGVXU043Q0QxcExweDZnalVJckNCTlV4dVAydVB2SnFu?=
 =?utf-8?B?a3gyeGJyZWxWblhGQnZTUVRRcHBmZzNPTk9uc3FpRnlwMHJDNUhYUFhFMy9N?=
 =?utf-8?B?RStSdTE2czRWT3k2VFJUNzFheVYrdG5iYnhEYjRvZHJBNnJ0ZCtMRXJHNldQ?=
 =?utf-8?B?WHVwbi9DUEZWUWlQNU9ZUUxzQUpIdDN1dW94OXhFSHZpeWNxMU90Qm5EOTdZ?=
 =?utf-8?B?MllkMElDR3NCb3BrNERPdXNqdHQ4VjcwSTIxNHByVzQyRGxIMWlQdmRPdjZI?=
 =?utf-8?B?YjRMb2hyQW9yWS8xRVhXUUVpT2svRjQ0eGRYblp5Z0Y4Tk9nMk0wRURMNnd6?=
 =?utf-8?B?aUZhaDRHWFVvWnpHcElwR0h3ZUt5bXFlUGRycEJPT0dQTHJ5WDJJN1JWQmRX?=
 =?utf-8?B?TEl5QUVkcENFcjBaM0hVNUNldU56UHVqS0NnYlh0dGp4N0IxWHZEcmhkeXRU?=
 =?utf-8?B?aHkwOGFlNzV3R3ZpUC9TREQvOUc5VDM4TlBCeDhTeVhGQnllRFBOamo2WUVk?=
 =?utf-8?B?WlNNWmVMamFDd2tzSXFLdVpZUUxJd0pXT0Z4VmNibDZjTUhTS1IzSkdoLzVu?=
 =?utf-8?B?QkdNQUZ2RGk4L0FkMlJQZjY3aS9kVXFPTWh2YWtqSGdIZngwZ2YrVTRCallw?=
 =?utf-8?B?b1BSU2V1eU9aZC9rUlgxT0pjbGZobS81WEkyZGdNZkFyUXRSSTk5UzY5SXly?=
 =?utf-8?B?MDVtMUF2c3BTYXVuNGFaY1NUWVhnTm9YTEFYMCt6Vkp3QktXOSt0V1B6ZGts?=
 =?utf-8?B?eHRKTUZMaFR3MVpxN0g5QlVTY1kxTkhoQm1HK042L0NsdG1Xci9HRDZCWWJw?=
 =?utf-8?B?SkFIZUd2eGJTZzROem9Ba09qMXN2dVpsN0JYOUozWnNWbFYyaGFPYnF1Q0JY?=
 =?utf-8?B?bmhPdGpEMFdBZi9QaGtoSWo2d1hBeFF4NVkrc29sZnNzN2ZEZzVoMnZNQlEy?=
 =?utf-8?B?eGdDTE5RUTdEOXNaZWZrWWxOdk1md1l6QUR1aFA5YWZlL0RYaWdaVXA1cnQx?=
 =?utf-8?B?dnR4Rm1zaFNKekVSSVhJZkxDS0N1R2xHNzdGdWUvUmpuZzEzQllBRktwVTZh?=
 =?utf-8?B?d25hSTJNZkQ4TDdxaHNDRGorcGR2czVma1Zyc3N5TUJQNDdsdnN0bkRaZFNC?=
 =?utf-8?B?QzhBK0pidGFnKyt3TldkTGhWcHNyU0RDNzRzdFlzQU1XbnhYNlRhZDR2TFl1?=
 =?utf-8?B?UHAvS2N4eEJRMWlua1ZFaU96MG1OV0NoMDd1T1NxcFJpZlRqRmY4aWhkSm0w?=
 =?utf-8?B?NkFsejZZWFpyU2lqTTcrbGxGOXZwRFpQajVwSTlLQk95aS9JZDFaRnY1WWZ3?=
 =?utf-8?B?UFk4RGJNL2ExMTVPTWhpVVV2SnYrZlNGamxtQTJqZENCNlA0LzJob1NnVnJU?=
 =?utf-8?B?SXBZVEgvTzZjdXpIU1BwMWNEaGlWNWxjYzVReURhQU9QZWw2UWFCZEYvblJa?=
 =?utf-8?B?WnJpUURPZjZ3OWx2alZCZ0xTTnpudkpGVzV2QWtvZlFSTmtmYXJLYWZGY3pT?=
 =?utf-8?B?alE5M2NZNjNOblo1NmpjUTNUa0I1SkN0QzkwdGZsUlozTFRjcEdEOThEbmdX?=
 =?utf-8?B?a0p5TGNLODQ5OS9QNkwwM0hxdU5DU2phbGFSNDh6eEE4d1BiNUxTcDNpQmRw?=
 =?utf-8?B?T2hQSGVEZGw0eDF5cU5IRktIRHJ1ODdPYUlhQytxRzZIeXZRQU1YTmZDU1Jl?=
 =?utf-8?B?b0VBalJIcUJvV2s4NmU0RXZjY0xGYjVRZUNkcDVSVXRNNlprVFNkQnFhdklV?=
 =?utf-8?B?alFoeXdrd0thcThTSTRKdTJaQVRuUXFjWCtKNDhEaVdMQ1UwSmhzWE12YmE4?=
 =?utf-8?B?akE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b4d8fcb-5ed4-4b71-62f1-08dadd24f958
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 16:13:30.0101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4N6ZROZuAFK6u1t3Bf0C4LoVFp8txA0c06PspWOoT65vsHI4Aa06DKo+vPCt4I4RfiYtbmqnHEok1Utrt8eUGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6146
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212130144
X-Proofpoint-GUID: 855aI5Kn7-wNOcUfIUpj6VKnB1tdul1J
X-Proofpoint-ORIG-GUID: 855aI5Kn7-wNOcUfIUpj6VKnB1tdul1J
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/12/2022 15:09, Jason Yan wrote:
> The domain device 'child' is allocated in sas_ex_discover_end_dev() and
> never been added to dev_list. It used to be added to the dev_list in this
> function. But after the following two fixes it is added to the disco_list
> instead. So the list_del() and locking left is useless now.
> 
> Fixes: 87c8331fcf72 ("[SCSI] libsas: prevent domain rediscovery competing with ata error handling")
> Fixes: 92625f9bff38 ("[SCSI] libsas: restore scan order")
> Cc: John Garry<john.g.garry@oracle.com>
> Signed-off-by: Jason Yan<yanaijie@huawei.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>
