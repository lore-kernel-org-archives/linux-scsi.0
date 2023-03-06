Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 329ADC6FA99
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 14:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjCFOfx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 09:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbjCFOfr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 09:35:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CFA2A14B
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 06:35:23 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326CxD9F017773;
        Mon, 6 Mar 2023 14:20:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=wwnhenHDv0dyitbX8C7UkwdbeBS/DESxmLDyCehGXEE=;
 b=g78uTNksB79CudNZb9b8RIY3czkr1BzudtR4ajjmgboWWd+xFUWrk4PaqEJmI0H0KtFk
 XLuv0+VOnBpVRkd6vNvSZrjhh5s9oFlhgrQDUHUpT4T1fld6VNnBxp0k/RH0uRbPBOM9
 6qS5j0BQOPybHXwWbfZdEA09NtT2F93xH6PtClrNA5v4M528IcY3HSuJLG6rS26nX0DG
 8HgTEESk9EVJk7NUZJiX/bLyNagm+4opwmgsomrNXlnt5Hdizr2tHXFW0A6+bYBkfpD/
 ok3UnUPw9W/J9v8s5lcJ1GXrhsB/t38Blo/r8XI25zffbl5L6iKM7OjY15SkH9Wsn5Wh qA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p41562y8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Mar 2023 14:20:29 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 326CGmo3025150;
        Mon, 6 Mar 2023 14:20:29 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4tthhmdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Mar 2023 14:20:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCybugY9Rn+RMMM4GYVATLHSChEyFKA25ZZUm/k+3aJdLEWzHhJJ0UC5Y8O8rI6nbMdLzA1OmM4NaDXhmq6sEvF08zhCHMWqtSKnZsws7cTWw7TJNEv6tC9fSe6HozFZwpdQUXJ0u/MeU4tivlR3ea5CqvEmba9GXv03PJDzFL7NeOjaMqDRhN2947G4zmoM2neyOOIIJ3a9SY+AfjujNJLkInkocY3636YGKM5TuJlF4OY0Kyr857kSgX7aSQUmwMnUb+62qCZqUay7qnVHTQUnnEvlLgSWCSGsigMYuQK4qROFWmkeIC1Z1kut12bJ4Rr6jLMq/K39RwpejRr7Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wwnhenHDv0dyitbX8C7UkwdbeBS/DESxmLDyCehGXEE=;
 b=cMYA8dKH/DJO1X6LDlJw1T/3dTf/TMlN+esg6ewMI9HnJ40sVrCp9Fsm6n+TnPA7qpqkqwzKbDIhGowZVg0euRr9K2mOJnukRSlpe2gAjom8sRU6ejYQhfawUhsQV42fRfikBNSbxebHIcy+9HTJdozL1IGjiqX7j8wKNJCdREq0h+GnGfuXE8JTx5qiD5XxP52jB8EnFtVBHYlRzCQMwhQ4FbfWPxd5LcpnBSvjpBDGoAqzv0naF7eG3PzL12kXN5b0bSYB1lLco7uAY/PSYic/lfxo5KnXeP4c5EuhkuE4SM1Y+kVXIw3phZCDiGyOW0ziA6aKPnNt3mxKIJTlHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wwnhenHDv0dyitbX8C7UkwdbeBS/DESxmLDyCehGXEE=;
 b=rPW7WYN+JJpuMkIoLuikSrWsJAYV20N6B85mZhYYvwpPUmCUvZJ03VXsU8J5cOiE2fAN/OoHNTtIEANLH/syqw/RpiouEEosURF2pKh4KwRTWmazWsEkvsVIRKFjRhiUrizYs96S0z9V5vxjtfZJeCV6JjUunyqesKsVI5MI5aQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB7116.namprd10.prod.outlook.com (2603:10b6:208:3f1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Mon, 6 Mar
 2023 14:20:27 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb%4]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 14:20:27 +0000
Message-ID: <ae17dcf3-540a-3b79-51f7-71da9b154579@oracle.com>
Date:   Mon, 6 Mar 2023 14:20:21 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 03/81] scsi: core: Declare SCSI host template pointer
 members const
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-4-bvanassche@acm.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230304003103.2572793-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0423.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB7116:EE_
X-MS-Office365-Filtering-Correlation-Id: c06817b3-4755-4551-da65-08db1e4dee9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R0BO5Igb2CysmmcXlrpaC8gzft5WR8TYVsuHQQi9U7BobxZAAXWsPVRxg3P+WHmWgg13SfU5NdMXHqL8C1wjtUwK1Uj6yvBTV/ngKWxSbKP7QcD2uqdGe1wIU90qeWTo90UiK7sVFjVp9pP9FKh7tCo/UPWccMP98qb/j/J+wOvVEeTN/djkD3jST1JV0S9TlUdIrLWl4dz/xH3FuWtO3z2D6FWcw2GNPtQY02w1hHwZnYHN1XBRXq7/WQgFdz3ugBU0lNluzGztu3ZC/S+xj4PKPINGF7yG/MAYlN/MGdw7uCRuvynkOrIjHe1s2gb5bXXC4IEiknwUDUzqWSdRwgQQxkhHLdJsKzLi7bhNMiCaZtbMufigrGm4zxnN4Wp2DHBqcrxZ3Hk8gvL3QCrB6h3Po3nafdAYBOLVJOqz+vclFOjbGdrrKt7lU9myzLJyyEPPKSWYZBBaiuq+U5OV7pDnzFlDp/cmDdePG1Rfa8hFgIUYWPmfRS2cj62BvMkMz4cwjkNtvPoz6R3IyU2/AQCSGSWJayur0DL98T216lqT6XPE4ZpW3uQ2DPcdr2yw8aeKu94gn0anoJoeIWp4ip2QvEuU31iUlm/TX6jV53PYOnJyJQu/M2wvyFbZJSzKn4TaIN6aaREVCSr6LeQqonSucmGli2mIO/zwSFiJNIt6J5I6Hsm4h0wegg4dqijLJL6BcxuPcXyBaMYrRqfEXNGq+NiaPPR57ts0rIrEdAM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(136003)(39860400002)(366004)(396003)(451199018)(6666004)(36756003)(478600001)(36916002)(26005)(6486002)(2616005)(6506007)(31696002)(186003)(6512007)(53546011)(8936002)(4326008)(66476007)(66946007)(41300700001)(8676002)(66556008)(5660300002)(86362001)(4744005)(2906002)(38100700002)(110136005)(6636002)(54906003)(316002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UkE5cTBsRVd4Q3BoVnlST0dUVk56cm5LeXV1VWEyUW8zNmhYQlhraDhUYXlm?=
 =?utf-8?B?V1gvbWNPQytVYmJQaDI1aTc5d1NHRTNRYncvNEFJZllNZG81VXNWQmZPOHFQ?=
 =?utf-8?B?L2I0Y3R2RzRBc0ZtdUJvVEs2ZU1nclFtdkFrSlRESWlqS0pPamdOS1R5TC9U?=
 =?utf-8?B?TERuWjVOSzJvbzV4ZjJOL1N1N3JlYzRKN2h1WEgwdnFFMzI3WDlIbzUxMXJO?=
 =?utf-8?B?Zzd0UlRJL3UvOXdSSjhRR2VnTE5wdzgrYkJOTjBUSzZOUzBpMU1EWnVRNm9L?=
 =?utf-8?B?RWVVMVZRWjlUNGl2Z0l5NGpBTW9zZmd0cG9aZDYwSS9kZ1VqNWZHZk1WZnRw?=
 =?utf-8?B?dGFGVGFJclA2Z3BlQlZWQURSWDNvV0Y5U29ZUHozV1B5Vjg1N25wV1J0YjUx?=
 =?utf-8?B?UHlFeVQ3a2tWaitCRHZoM1Vqd3BxQ0YrZ3hBZ2NhSThKOVpjTlBGclRrelpU?=
 =?utf-8?B?Y1l0aGZ5NlBMZlhiV1NVTGNCQU9lUUJNekZqMTBIdmtwOXR6Nk9sd01LYWNn?=
 =?utf-8?B?TFlDQlNlMWdPSmpWa2FPY3FUTzRSeFhHcEQwdm9tSjQvUGoyM3VXT0hZUnB4?=
 =?utf-8?B?ZEFOaHhYdFh4MnpkelB6NHcvQjY2QS90NW1kUnZwVGV5cC9rRGJqZ2NpbkxE?=
 =?utf-8?B?aVAzb3dlb1FHUjlhUi80Q3lvVXRXMzhySVhvK1VTTmpSK0NVaU5mV0JmQlVS?=
 =?utf-8?B?bDlvZUgrWTRMU21OVjdRYzF5cjErVERKajVuTDE5QzhJa2N4eW9EdnFVZEFG?=
 =?utf-8?B?MUEvSnRkK2ZuTjV2QkplWEVvUXJWWHl2cGRFR0J6RFoyNlZhbnd3dk80dW5T?=
 =?utf-8?B?NFdic1M1ZXRTWkRaMnlsMDNWVzFZdEUyRWhLOEluZjIweXdxbkY2S05MSlh2?=
 =?utf-8?B?MVpRWnhSc2ZKaS8zZXJlYURzUDJBRVNwT056TXlWYWNUSllrS1NCR3hDb2lx?=
 =?utf-8?B?bnh4blhuWmxpRk5PM1ovNllNb0RjaU03TFR3d3MzV2pQQ1JZQUdlS25ZODM3?=
 =?utf-8?B?ODFLTXJBN05YeUdZSTdzRTJVUlAzUzJwcmxuZmk0a0RPUHpJdjJPc0wvUFhn?=
 =?utf-8?B?ODJ3MWRjNHk5YVVtdHhzTzh4ZXdIQ0k1QUVGQ2k0VTVYakgxZ3h3UFhWaHBZ?=
 =?utf-8?B?QmVJL2ZNN2RXMHdkWjhPRy81Y1BOcnRLV2VxM1VLWFhBK1dhc0pGUnBzNFpY?=
 =?utf-8?B?d00yT1F0ODZWVVRWNDU2aXF4YXh1K0ZadkIwS0lkTjNLUXM3UVhpeEZIUmRI?=
 =?utf-8?B?S0NSMGJJSm43aGQ0RWRXS1hHcnVzWGFRUWw2QTBMa0hoQkZ2Z2NCcFVDaThp?=
 =?utf-8?B?dng5THVNNWFmckhGQmdWMXJMTHdyMVMzOCtUdHlTRlp6ZlBBR3JiUHo3Tjk5?=
 =?utf-8?B?N01TVVRBTUtUTzVqSFpicW9FZlVSWDJwQWJZZldGZWZzTWxMeGFMOVZnODFp?=
 =?utf-8?B?Q0lwVWZTSmpLMDJBaTlCeURwQVozcVNIZ2hhSUFOMU8xZnk3ek5ieW13TFdT?=
 =?utf-8?B?M2pSdnBabGJwdHNmbUlmdWUrYSt5Vk9zSnhkSm5HcTUwZTVHVTh0L1lUeDIy?=
 =?utf-8?B?T2FuTUJCT3VlNHFQMi9udGsvVitaQUlmd1VITFc3bEtrcG1iMXIybmFEUGZs?=
 =?utf-8?B?TU5Ja0JoekdzSGNpaFk0VFlLK051Skd6M0JMb2tLZU9jZXY4eE15SEFUV2F6?=
 =?utf-8?B?ZHJaQ255TGVJOTQ1Q0JGNHlhWVVqajQydXR5TUtHU25wWTNZUjFZb05sbkZk?=
 =?utf-8?B?WXg3UFNoVExVS3FUQlFQU3hSb0dvd052eW1Hd0g5TUtyOVplTlhYbnh2OHE4?=
 =?utf-8?B?WW5mSTVNQTk2bHNlV0x4OFBuMnQ5WWVsajEzQlJzSVdEaTZCeXoxKzU1eHJv?=
 =?utf-8?B?VXJ0U1EyQU0yOXYxd3VsVnJWZWtjeXI1ZHJUNFQ1cHlVUEd0eDIyMXpDWWlE?=
 =?utf-8?B?bjlqRWVSb015aGZNL1lqUGxKdzQ2Q3l5RUlFS2hpbDFHN3BXNDVHK0ZZaUU0?=
 =?utf-8?B?dnJVNzcyRERMZ2JVQUtLMjBxcnNwbkxvLytPTVdUK1dHNjdRU1VZbjQyUmVZ?=
 =?utf-8?B?azl6Z090cVpVYkw2VGF4Zk9VTHJaMWhJaVhxZzBWTXNCZVRwaUx0S2FzSDcw?=
 =?utf-8?B?OXpaMHhsbnc0Q0xpVFZET1phbWUyZVU0Z1kySDhtVzB4Lzh3V1pZWGVEL1pL?=
 =?utf-8?B?QkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NqOzVwj+VtR5zvWaQG0N5kKHdu9V11xgaoDl2+J/BsSLb6s+9qhy0vl2MshY4MGXnvl8dA2t3qGR2HiW8lWxlUO4QbwbHFQf/nfJljfMaFSpUFF/Y3qIcoV9e7feAuAI1G6kbMh0sq1f9/xpuWw4y2t+HV3swAGg8YROF+vZ0USBigsgp2XLDOdtkkp9aIsXC3Df/gEAYxIrQ8xRdyFxRluV9xPOPJw1h798TJUoSm6+jZxIMzPKpM+CuQT39SyU8I5ha6QOH7MfaPZHVeEbVbx1LZX2Qa9L5Si7vvvrNZ4PhRLlHfDwJYFJnSILY0n+MlqMZaOt47uzCMe6h1M9ShJP8xlBs5F7JHmNS9yvG+/Aw+E0VJ89nqoXTFy/rNAAaXdiKuvAj6zE13pWq9oBF3G0VCjappUBfG0210tym3raD6reOxyU79g8ZHK5WF78LvqiWdcITj9igidWmcIZUiqZ3zux97YAc/WrqKbAZ9lneedJAijhMU5pTvS1EEo+5xBIfDGkiHhelTiAUvGJcCGg17VMJn40wG3xPzGzk3QIPSky9Gw+WkVy9iebtzquxRGIM9HZjwAk609azYBkP9+7MgE5Bq0vqNGfsGWhHwjkXl3jyjutof9+B7MuaDlRlVdTnYAeM363Bzkvs8PGBsRw9U5nFg3ibWCov4OgVj3iYIMgJl+CuWqNaQ4iHzxg6EHNC2B92+K6GAx5uTaU/fmB7NJ0wmUu02ZtKOUkklB06feHOmKlYasZ9OKSZGv8cP/MardRz7UQHgRENirRxSCC/HnYfqsYkp0D3i0/HAvVZ0sBPLRYg6VA31sg6bOtlf4idH4XcGu+WjMTNQeso6Rs6bvtYmUSmQjIB76wQQnyWXGANOsBLhh+iJDnWHbd
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c06817b3-4755-4551-da65-08db1e4dee9c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 14:20:27.0297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NKmIRwTEF0/LxZgzvqw7ecmC7KKHkXcbrcPIhxTxn7CLzpzsFFlzs/clQPSE14VUsOCP+YLQseGSxTLMqRcnBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7116
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_08,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303060126
X-Proofpoint-GUID: 1fh6Ia0ur3Vi_B0Ic9jq2baJ0KZhHMBZ
X-Proofpoint-ORIG-GUID: 1fh6Ia0ur3Vi_B0Ic9jq2baJ0KZhHMBZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/03/2023 00:29, Bart Van Assche wrote:
> Declare the SCSI host template pointer members const and also the
> remaining SCSI host template pointers in the SCSI core.
> 
> Cc: Christoph Hellwig<hch@lst.de>
> Cc: Ming Lei<ming.lei@redhat.com>
> Cc: Hannes Reinecke<hare@suse.de>
> Cc: John Garry<john.garry@huawei.com>
> Cc: Mike Christie<michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
