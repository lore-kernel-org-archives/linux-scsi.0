Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E82BC43334
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 15:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240272AbiGNPdh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 11:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240267AbiGNPdf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 11:33:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A67829A
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 08:33:33 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26EDcssB026608;
        Thu, 14 Jul 2022 15:32:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=7jtumBeLQep67sR4zPwa3otsm1CV6gLgl6D1IH9RcfE=;
 b=gneFn8eyYD6cVvwCusyfPnUITliQzzIqsaNbrCsrWwpDSFs5GY5INRIe6WtySUxtUpMd
 0GZHonJxFLvB1ZxSZzjE+nBD9vxmpr2t698mwgZynYSzBFb9msBz2RittAhHUULg9tPM
 MYY8+ozz+whK4UxwyUPLuWQeCIDgYhlz5a4HiwRj4ZrgzFrF8SrN4JVS9ryaYAn01jnv
 5rnf4bgR9mLFPGbTZUmArpOwFjjg6/TSWFRq2d4lS71Jpeo0rWOjd75wHx4YUMu8t/Ku
 ETmt9piaVaHl+1/5Uzhh2ktepaWdd3sBrBuLFqc//GpF8x6SZ4PX1ngTyeBUkNndLG4L 7A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71r1d2ym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 15:32:57 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26EFUaRZ024245;
        Thu, 14 Jul 2022 15:32:56 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h7046dnkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 15:32:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gLPOb8+nLC3fyQoO0FdCyOyA2+rAQ3w9oDsNmvUOOFpNsXVRpArZAA9gxkImpdjYi32RKiFU+8nIbWAn+kKBR6NNauRbY+Sd1abuhlUmVARC5JzqXCFep6hDFKtgW4c/+wt23CCLje8eb8cVwzyPXEYWzJEQMEYVgL9L7jfNkrzcBg/eArek3CnrYnfjvybDw+Fc/swI6V+2fXmKByKr++nGR2Sx1NvU36JgLxRktRNScHT/5TyT8U6rLcN905TEWHn0pB/Lu34LbZoi2wvWlm9YMFx9rJuJciuAxRi/a9YaT9kj1lnkkbb32oHPQljLLBepw159z6ky6JMuRKz2vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7jtumBeLQep67sR4zPwa3otsm1CV6gLgl6D1IH9RcfE=;
 b=fD92k8ZXuMG0besKdcryKuc/coRxwQUg8CbKA/gxtQ9EyAAujsKDxcpSTMINJxPzyUvu8VwdtVuC+ghntnU6rHViYuC1/nM2NKWV6b+Wzd+DDVQ6LjHxbF9aY7HO1Wk5SLsmZmj+rfRk2fB6ghtGDGYnbP7UQTu5uGFbFXkl1TBwwlwIGy+LG7VKlxPilmBa8RWdsGHfYs0QKFAJLfrMRM7kloWxgsGdvBOJnjv2A+1citp9gc13I8x+d+P9HHbQbyL2GHOm02CahQmLIXJwx16oAAElNlcNlBZxOjpEU/fT1xhzuT9GFZrngsPQB+OnZ1x+ZbyUtZQj4veljWc9AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7jtumBeLQep67sR4zPwa3otsm1CV6gLgl6D1IH9RcfE=;
 b=ws/Zv3MPFS3KWGjMJc1THAo1l7pXOVZPps6WGvC8W9IsGW//bDCDbcPePJKwc4ry3ZpM05+35JRwtcUiWTZhxo5oP9kCaI+oBPAbhYy3C7R41jt5Xfdb9qP3mVmfSv5ocaQhvOLtDigRrVOiRtlUbhmIWbIAGrMJKapOBFJDbZ4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY4PR1001MB2343.namprd10.prod.outlook.com (2603:10b6:910:41::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Thu, 14 Jul
 2022 15:32:53 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5417.027; Thu, 14 Jul 2022
 15:32:53 +0000
Message-ID: <97718f6c-9635-8980-ec04-739241a3984d@oracle.com>
Date:   Thu, 14 Jul 2022 10:32:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH v3 1/2] scsi: core: Make sure that hosts outlive targets
 and devices
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
References: <20220707182122.3797-1-bvanassche@acm.org>
 <20220707182122.3797-2-bvanassche@acm.org>
 <8fa5f4a0-fcdf-365d-8c42-9ab4041f2a8e@oracle.com>
 <88942839-e618-010b-07a7-76e0a302b1c3@acm.org>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <88942839-e618-010b-07a7-76e0a302b1c3@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:5:335::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a795635-1de4-4231-87d4-08da65ae1e65
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2343:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TLsyZBdUedXAtYRwoN+6QK9rxfWWZWfWV7+03mH3Me4LWI2eQcDMTsZlkYLTPU1+kYli2Q4yO/b3zL+k7bDxB+1fYQaKHAC+BYZnpMWS/XPPlLzpEJPRrnwYV2sVWBdbUUK92VsDUZT5o3XXAtb5RD31sjHaGrzYhkFNFRtL0KsM96ebJMmV+Xoo/nd/6188S2YTL/1ppl+LrGtitaYKmJvSOpIHVPz1T5obCzwbGjHmjlq0/fks1yyYnkGYy7NLNSW0ej8BJXHxws0oF4T9IBfKotVqaA4ro+eurZq61HZsqaeDphWnMAE2pIl75IEc7DAV2odJPk3Otu367ByNFqHVGjMBAMRz8GDLPW+ieL6WElgvBcC8rzko85d+omLpNXCZR+3d4DRdCOeOCt6/oV3yKBgMD2043byOpiXrXHamzAae1C9Z+VfmYQnboKu8qwiuCjzyYPTB1qjTzYwXbbcetvWlScpAZYzplyAlyTtCpIbWe8jbZdKqN9/Dr0Fpg2YaZnPwvbD+Bk7XoYoE93yMyIYYlAOXRXNzWQrKGwR8epjIjl1itBDkPZGTD07Yq+pD0lk3QQvJBmDdFEXgyUngEmQPJZxMKrZRcxxmXNxZNfmnU0DjJlAYTDz388At+0ZRGQ/hbiLxkm6n6sFMoIOo9UeY+vmslqooa7iUhxrH/VtMnJgSwbEry3x41UGlqxRXKGMsdgyPFICkBFs15IRFMPBJFeY4oIWEnYFILm4LrYaU7IRoBECXB93g3CfkufeV55x7WFhvk2TVBQlwWfTNm9AH7XKT/hKM3z6pR8bZnzer7cem+HQ+9o87XC19hmIRvOlhVjkNJahVVBF6RmDGY3362zihE+fJzIdxwIw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(396003)(376002)(136003)(366004)(2906002)(83380400001)(5660300002)(36756003)(54906003)(6512007)(316002)(6636002)(110136005)(8936002)(31696002)(31686004)(86362001)(4326008)(53546011)(6506007)(8676002)(41300700001)(26005)(2616005)(6486002)(478600001)(38100700002)(66946007)(66556008)(66476007)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZW0vam5pTUtlb1plZTEvS1hsSDE0RDY3NWdlb05vaHVaYno0ZWdwdTJFNzVl?=
 =?utf-8?B?UFhUL2E0R0U4Ymwvd0p6YWpwNmNPa1BOa1V3SmwwaDlsekNrbkJjdTd0enBV?=
 =?utf-8?B?QUZLZFltZ2poWWQvTGEwNHM0a3padDRSYjdJL2RFay9QUUF2RCtGT1ozanRY?=
 =?utf-8?B?MUpGbTdhdmVJOWd3ajl3VVBDZnpaRGlLQVYrWXVIZ3FCNXZqOGRTYlF3MGh5?=
 =?utf-8?B?TmdIWExGbzJPZ2JwbDIxSHdtaDhTOUwwTmdKOXFNVlNZVHdvZDM0b2ttZzhT?=
 =?utf-8?B?cU5xN0xoL245eGRJbWdvUGl4d2F4Tk5GeW4rVkdHRXpqVm1ZdWFHcXdwdk5q?=
 =?utf-8?B?Y2JmdnJpZlZyQVVKbC9iZDVid3VEa2FiQ0ovZEpGU1JOSHA0dzVKM1FSckdE?=
 =?utf-8?B?TUlxMkE3NnFvQU4vQlV3Qngvaklqek10MGZXM2g4WTFtKzgzcFg1NHN4YXRh?=
 =?utf-8?B?Tk9iYnF2T1lwczZ6cXBvQVgvZ3o3L1VreHluVmk0VEhjOFMwWmdBSTlwaTRm?=
 =?utf-8?B?S1AxWkx6T3pjWDBNTS9VZUloQjRTY09YVEpESkZOM0EzQTNtN25zdW5WWC83?=
 =?utf-8?B?SU85WVYrU2xSUEhxdEN5aDZoVEVFWHRtZ0d6K05tWGlqY2ZLRzNscE56UUJv?=
 =?utf-8?B?UnlicHhhOU5rcmRFY2ZhMUtTODVxSjZZMVQxYkVGM2poRE9KaTJGcElTRHdV?=
 =?utf-8?B?d3h4bWt5TGhsOEh3NVI5SmVQM29lQXJaVXQrK1JGTTFsUW9DSTVoVnR1NEZ3?=
 =?utf-8?B?bTVxMkcxbkF4YTE5R0tTakMrZzFwOWFQRDNxMlo1YU1nRlBZbFJCcUpKZTE4?=
 =?utf-8?B?U01BWUJ5UTJmVWR5NHVzZFNBTng3c3JDaDJhUGxqODB1ZDlkQjQ2VWxuNFBF?=
 =?utf-8?B?bFJxNCtydjBINEVBUmtvM0RjeDU5Z0FRTVM1aGIwODExUmhHOVhvUktjT0ZQ?=
 =?utf-8?B?bzEvWEl5MzFHV052OU0yN1JqN3Yzd2l0K2Rac1l0SmlHSUx0eUh5U09tMkhh?=
 =?utf-8?B?T05ERGdZOHZJU0lKMjBCYlFpbzNBV3g5MDhnZ01MUXBiQ21PS1pvNjFTaVJp?=
 =?utf-8?B?emhRU0hnMytOcmlCN2YvdU9DS1VPMzVQVkg2UFM0UXl0blBKeEQwdzZHRjZ5?=
 =?utf-8?B?d3RzMHJIRXlMelV4YTlVSkt1UmY4Tmg1MkoyMnl5dE9OalJiVmxsU0tKallV?=
 =?utf-8?B?VjY1T2Q3b2hWdjBLRE9reHh5ajVSUHVsMklaNnF2dVVETzNKVWlYaThlYXlm?=
 =?utf-8?B?enIyeGxsOERWZ0VLTFc4MHRvdmRHS3Y3Qm9EdlVYb0Z5eHpnRkxKQm1HdDNh?=
 =?utf-8?B?QzgrcW9IOGoxMTQwZmhCTlViK0JwZCtHdVZ1cmpVRFVYdmp4NkhNejE5QkU1?=
 =?utf-8?B?VStyT21OYWU3TFZMUm1aZkRwRkM0SDNpVXpDT2ZWQnRkaHliN2hsUmZmWnZE?=
 =?utf-8?B?UkUxT1VrUlRYUjFXYXc5Q21DK2hOZzRsUVkxeDQ5c29iTFlBMk85VWNaVytN?=
 =?utf-8?B?eTRFNWlCL3c2eGYwSnZqZjBqb3h2N1FqbEFpUGhHd0pvMC8zNmN1VXltSCtU?=
 =?utf-8?B?ZWh2STNtT0syemg1M1BzSklwRVhXaEQxbDNMU2hLaWVMS0VzMXdGWXhzTHV3?=
 =?utf-8?B?SjVwWFdGa2JOMlpBemhJaFE4dVgwUmd2eFNlM0ZuYXpGdHB4ODd5Q1g2YjVI?=
 =?utf-8?B?NjJ5YWNBWFhFa1ExMHY5ajc5eHNJRS82N3Y5Lzc2UDFwZ3hCZFBLOWxmYkZD?=
 =?utf-8?B?cENnYjQvS2NLWk92WTJiS1ErY1I1S295VnEzbU1RRXNqV1FHVkdFZTJOWWtl?=
 =?utf-8?B?T1BsNjR6K2szemVDRkpoYzRndXpsT0RwcXlwakhZRmxTUXluU0FFVC9BTDNm?=
 =?utf-8?B?R29rNGFYLzlZZEZObTdLbHVMNXNPZDYvcDVFMUFFMkR3dlJhQjU0OUZoSHZX?=
 =?utf-8?B?L1R1SERiYU16Y0RZU3RaZ09iNm5jeHVBQ09VVEp0VHNDMitQOXhCNjAzMEhx?=
 =?utf-8?B?TjUvMWNaZFI2V3Z2NmFpb3ZrT21qY1FIeVNlbnZ2UllOWWNYV3R3dHRzMTVX?=
 =?utf-8?B?d3hRUGRaakdoNzcwVndmMzZLVi80R0Rlc1Q1UXlCRHhudmdKUGUyUmxQU1Vl?=
 =?utf-8?B?Zm9WeHl3SDRXRFRRWVRNaUQ5R3k5NTBVT0NmbDRDN0ZOenduNjUwQ0RVSURD?=
 =?utf-8?B?VXc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a795635-1de4-4231-87d4-08da65ae1e65
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 15:32:53.6750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BO68X42w2whbcsbo/ooZJx36G4+dsxYwZCYbQjfrgo3OKJmeIIzTYZ1sVMDDhnLUPj8D5YFNIZE00EB8xw9YaxoXJmHPmeA01Nmv6Y2CAio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2343
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-14_12:2022-07-14,2022-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207140066
X-Proofpoint-ORIG-GUID: M8nxH9j67NqjDq-G97oFQSuFByVTy8kE
X-Proofpoint-GUID: M8nxH9j67NqjDq-G97oFQSuFByVTy8kE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/12/22 5:29 PM, Bart Van Assche wrote:
> On 7/9/22 08:57, Mike Christie wrote:
>> If so, could we move what are doing in this patch down a level? Put the wait in
>> scsi_remove_target and wake in scsi_target_dev_release. Instead of a target_count
>> you have a scsi_target sdev_count.
>>
>> scsi_forget_host would then need to loop over the targets and do
>> scsi_target_remove on them instead of doing it at the scsi_device level.
> 
> Hi Mike,
> 
> Thanks for having taken a look.
> 
> Could the approach outlined above have user-visible side effects?
> 

What kind of scenario are you thinking about?

I think we would have similar behavior today for the target behavior:

1. With the current code, if there is no sysfs deletion going on and
scsi_remove_target's call to __scsi_remove_device is the one that blocks
on blk_cleanup_queue then the target removal would wait.


2. With the current code we have:

	1. syfs deletion runs scsi_remove_target -> scsi_remove_device and
that takes the scan_mutex.
	2. scsi_remove_target passed the SDEV_DEL check and is calling
scsi_remove_device which is waiting on the scan_mutex.

So here scsi_remove_target waits for the deletion similar to what I described
above.

My suggestion just handles the case where

1. syfs deletion runs scsi_remove_target -> scsi_remove_device and
that takes the scan_mutex.

It then sets the state to SDEV_DEL.

2. scsi_remove_target runs and see the device is in the SDEV_DEL state.
It skips the device and then we return from scsi_remove_target without
having waited on that device's removal.




> A different approach has been selected for v4 of this patch series. Further feedback
> is welcome.
> 
> Thanks,
> 
> Bart.

