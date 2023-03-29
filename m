Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C404C6FD18
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Mar 2023 08:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjC2ICe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Mar 2023 04:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjC2ICd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2023 04:02:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29262114
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2023 01:02:31 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32T7jQKm026515;
        Wed, 29 Mar 2023 08:02:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=dFS7La2yylS7Q3qJXwUaPx5WRdO5hmG6jViIMquXCc0=;
 b=RmCluTRzVRi0nmJY78TcwcZreXR9XNqSAo12ZOZaoOnGjOX6MJ5A/AmzrsCTtsN1PXHm
 nH1RGA71rKEzJNUnq2+4Dq15POClsPfuLp0uZp1pUIT6Xmj5ZBjtyOgRfR/YZgLBb8XU
 iCac9Wak9e2YVnL7GKwA5e+sN+xnFniMLliRW1JEtnfvSZf3d4fr2B+r/j80ejnGu4hl
 wqBwpADc5D0aoTy9IR82uy9b92zSwv1hdnEfMcFTEn1C66F7L1O+KyIClHur7q2Lj7/v
 RS3of7DIn58O8NA3iRIVvsJ00tVP9VCgxPBe1CmHpt7Z3xMZFNVGnzIAOFHiKqHa8wk/ cg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmh78r21c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Mar 2023 08:02:07 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32T7DhKN026784;
        Wed, 29 Mar 2023 08:02:05 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqde0krk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Mar 2023 08:02:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ngDcaYrSHDHoKnhtvXTFchZWlX/LGeEnt4zfzEVojaRIKsv6Jhw2FzeRdL2QvURC2vWHaL5qvvy9/nOpMj5+KtYeUL1LKED4S6YqdQ0tpjvm9H7Qi9oxn3QKXdlRUKO5X/zxlQhEBPqBNxPcAMRJx1qR8K+nvaLRsENYvmtopBleRbaZnSVf6evv+1C2PG18zTlMR5pnDZ+hDfN9sMGF6W1qH/tf3K7CKhsCK1KldgCwTJtfRhXv8JwwqNn0m7okDWTrVXkyNvLwu3czXoMHc8mat1cQZYgKuiA+Gs3SqqtNQ/k2f1jLUpP3LI4PU0HaGEWNh6w9YpPQPAZgNFMN0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dFS7La2yylS7Q3qJXwUaPx5WRdO5hmG6jViIMquXCc0=;
 b=SagZ03F06BVNDXtW9nAt94dXXnZCiYHaXCEGk8lzRvO298jF/mIgXLxpd10AYugT0FvAsR4R8LWaCwbUq86pvatjj+KugKeYL//IT+Q+Ph187n5r0X6oHIzbvzD8pTCW74ng71qkMkL/rACsm4Yhh5p+7i6q6/BU4lAu8GSX4BRIoAix2ShCj/YcQ7x+JBnkSEuRt/cEFzs6dC+0Tsgx0pOsODqWS76k5zwAUtgtSRO6lfWCrw1TIZ5neUek8+dkpjQX5C8cVyX7gIR4kcYvCNKqLyvrpxslVBi52ozJoskP7MQuTEXkNsccgkGMt6q/7vqg+aKTUk6EAu9gEKIOew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFS7La2yylS7Q3qJXwUaPx5WRdO5hmG6jViIMquXCc0=;
 b=jOtCIT0zpoXAeqh0MlQnAYT8niNBhVRZV+RroqQP5beaAxkiC7xIInzUo0r+y3ZSjHM/5k385uCqWPCG5R+06Euga5SKNjm07HBgzrddNjnnhoF4hLQjXcaqtHaYyHMD6WI0XXIjt6Kld62pNzUOMMUQmv98i6lwHRawEg0PQ+A=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB5679.namprd10.prod.outlook.com (2603:10b6:303:18d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Wed, 29 Mar
 2023 08:02:01 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267%5]) with mapi id 15.20.6222.033; Wed, 29 Mar 2023
 08:02:01 +0000
Message-ID: <e1267a18-b751-6af7-7329-30511447f4d7@oracle.com>
Date:   Wed, 29 Mar 2023 09:01:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] scsi: libsas: abort all inflight requests when device is
 gone
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com,
        Xingui Yang <yangxingui@huawei.com>
References: <20230328111524.1657878-1-yanaijie@huawei.com>
 <982d5c0d-1548-0739-d7d6-96a7834709ef@oracle.com>
 <eb2f325c-c45b-756c-77a5-3c62fe577aca@huawei.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <eb2f325c-c45b-756c-77a5-3c62fe577aca@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0102.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB5679:EE_
X-MS-Office365-Filtering-Correlation-Id: f75267c4-5d7e-4481-6827-08db302be07a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bZAfFpVOiPF01//mn3HXS667aPOmawZuJ7zJyc3Ylj2GnN/3GGj6GYYq1jEHoko2z/74OqZ4+AKv1O0bvn54ivod+0Z8iAYmQR3l4d24Fx4fP8eGDwXY6eqNGxiTQZsPOMQEuUWy2ONKIhQ0dyYC4HLbS2AzxPwnJ33RuHDcvDgJkaZdFfQJe5r5V2mr/VcGnaFZpFWLfDDU/jIFEoiNhFShsBQ7+RBWATmisvMVGFQHAOIVFOEHS82n82NvkwnUhyFKt6yp55z61yXMtGDo+jsmWDSxo6QT/rPDF9YH/LzmTkEePOhYVmux5pt4pQ0VnT1w2cdBCK+KjClH9Oy7xRPZAYgHpyQ6QWr/5ZRTcKZ6qKYhmpCDAjArcI+QjnLma+I3EAS8AZSJgzUs2UNyNwjpoB6AXnc0panoa7qEZDHquzyEMNlXaUcfm8W0p/fuZAS4lUq2qMoKputxRjbq5MtzXras1k0hXTEWGfL0EVTn3qaoMeO49V3ftbaQRFnDl/YQTIyGzLLEhgbVkqonPMvHOehEeEXEeiV3qnXQwRr//bXvEluT09OxWqgHC2Op25gmoEfKZelng2gkaafX3lSPZrwDn/5nhLZGrBpKAjTyeXRzA6V7WIzYWq6P8Zh+zO+zVDM1HuPlPndaeGRY0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(366004)(346002)(136003)(39860400002)(451199021)(5660300002)(6486002)(66556008)(66946007)(66476007)(8676002)(4326008)(53546011)(8936002)(316002)(36916002)(966005)(26005)(6512007)(2616005)(6506007)(41300700001)(186003)(478600001)(83380400001)(66899021)(38100700002)(2906002)(31696002)(36756003)(86362001)(31686004)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXVYSElFOWhVWTNEY2pLTnFkUVdKa3BtSHFUQlowNmhlWGFVaXN5NFErZG01?=
 =?utf-8?B?K25kcWZQOWtyUEpOOXlHK2dnd2l3U2h4M2FTYkRhdHlPQm5XN2ZudnVhZHJG?=
 =?utf-8?B?U01xMXMvNkJnZ0RXQSs3dG9MV3RtbDFNaldPZ0dUVWFuRmR0OG9hSE84Tk90?=
 =?utf-8?B?bE1TT1pSaTVvY0FrQzNILzcyQlJvcXJmR2toTEUvRERLclM0TEpUMzEyQTRG?=
 =?utf-8?B?ZUlvNEpkNkp3bGIrbWc1b0RUbkZBRUM4WUN3RTNwU0tiWjRzNnFGOG10RDlP?=
 =?utf-8?B?T1pYbDlnc0tvSDRFZWJrWTc4dVRUTDFFVkhMdGQ0ZE9qMjB5c2hXMFdjWmJG?=
 =?utf-8?B?anlMdHhVOW9EUm83K2p2QmorL09WaWhjR0xXNTZIWmpEcitMTEMwdnIyZGFU?=
 =?utf-8?B?NDVFVzZtN3BYWWs0cTYrMExFUHNFL3o3QlZkVDNiTU91ZGdWTjVTZmxMbFBO?=
 =?utf-8?B?MkFBYVBBR00vcDNkc0RaT3liZUNGYitGUE4yUHdWUUcwUUxsOE42SGZyeU8r?=
 =?utf-8?B?T1ZORmZkdjVVd0VUaHNFVXNaeWYvYjFqbTg3aXJnYndhQjdXbTA1L3VZcWFi?=
 =?utf-8?B?TEdOZm9PUHpKby91Sy9uVmhjUlZSZzM0SnpGd1A4Yi9vLzY5TmpHNHVyY1o0?=
 =?utf-8?B?SzRYbWd4ZDB1R0VqUkJCTnZZRUEvRDZiU00vUWRXWFNmTzR0NlFIVGtOK0gv?=
 =?utf-8?B?Q2dXdVMwZTF6eC92cTkya01jaGQ5R21TVkZ4RkwzZnRRSmxQYlBaTUJLSjB3?=
 =?utf-8?B?U2pZRjhMQXBpZ3hnNjJaaEt1RXNvUUovTHYwQU9sWVNpdmhQSGNrMjBYNW5s?=
 =?utf-8?B?WWpwb3owbmduWWV0WS9OWFZJYWw2V0t6bVd2b3ZhUzFIRzlDNEJocjl1N0tp?=
 =?utf-8?B?NStyaVAxdTJudnhNb2V1KzdFOG84bTJReTVMZllFaHdDZU40Z1FjY3FpbWU4?=
 =?utf-8?B?dHNMZk9pWWZLNFU4WkZ2SWZpTnVlNGkvZTBtNEs3ZlY5OGxuc0xFV256Q2xF?=
 =?utf-8?B?ek5YZ0xRTG0vVHNHanEwVTRRQTFOTlNxUHkrQ3FjOU9tMjVsN2hGNjZRT283?=
 =?utf-8?B?VWxEUDV5QVRJSC9IRnl5T04yYldMb3orR0hOMkRBZ2JZUlN5azRpNEV0TWMy?=
 =?utf-8?B?NGw1WDg4Skc0a2JHT0k3TjR3OGYzeW1rMlRXaC9hMHZkbFRNbDdDUittejNH?=
 =?utf-8?B?Z2MrdktSdVRpcXFUQi9GQlF3cS8vNC9EYWgxVG44dlpaNkZ6RU55VG1Nc2ND?=
 =?utf-8?B?dk4yU0s2enRYQjQzMUU3WE5waTh3WWNiQWxIMzZDSENzK2V6R1pFcExPTzBL?=
 =?utf-8?B?R2NudTdLYTJLd2xGU2tzSHREWmo1aWxhM1NhK3lpMEM5bGlsUGFGeWdNUnVm?=
 =?utf-8?B?NmlrQlVCMk91V3J6c3VJNXR0TFlHOHpNQklyRi9GTUdtR2NjYzk3RTlveURm?=
 =?utf-8?B?cWlNU1YxRjFsY3NGdG5mUzlYazJieHRMd2hZWFB5RGNCc0ZWZzNCVTh0WjJh?=
 =?utf-8?B?enQ2cVJ6SWtHUkhuVXVudFdWNnZ0aGg0dVA5V25ROElPWmRJVkY5aDFHcEFX?=
 =?utf-8?B?aTBmakgwcGlSTm90NlcyWHZ0elJ3SzlkQ3dJNnpYZEFxWWRrUXZKczFxRWxp?=
 =?utf-8?B?RTdqZWR3ZjhoazBHTElVazZrSExRLzFzZWs2a1VxaFRKclQzb1YrOVh6U3hF?=
 =?utf-8?B?bS9FZ0c5NzRXcFBSRFhhUGJZQkFmWkJkbDlva3JTNUg5MTYyNGkzY1dwZ2pr?=
 =?utf-8?B?dVNVWDZTU3hNZVZ0WnJGMDV3NC94K0J2WVVxc1kwQkNpZTRXOWFKNFV3RFN3?=
 =?utf-8?B?dVl3TXRzM1NBdkxNUlZnZndZY2VTV1d3SjFnMGFPN1UyRUVFcE44b2x5ajVp?=
 =?utf-8?B?WTA1KzVQUGRJZ0NNTTN5eUdORVVkU1NtalIwMVN0cmJ4U2dhTEE3aXdsNHdw?=
 =?utf-8?B?cmFPd0doTU1QMTM0Z0hGQUcwaWNBa1lIZURETWd2YjFITUN1Yk5TQU1RWjZ3?=
 =?utf-8?B?QVZwQWV0M3FJZ2JqYnhCeitncHB2bXVuWVV4ckhBdnJtV3I4TmwvdlY5dC9r?=
 =?utf-8?B?SGVyOTBNUGs1dThLalZrd1M4S3N4MnhIRzRENnJ0eEJrcU5yYytlOUI4UjBX?=
 =?utf-8?B?dDFkNDhaZHZNNHhyaG9QckdGQzgySFROOXlqLzEvYXpWNTJKZ2hkZmRxNHBj?=
 =?utf-8?B?OVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bno3OWhiZjAvU0tramtVNmZxN0hQbG1RaFZHZUFFb3NjK1p4MHpOL2VoRmpK?=
 =?utf-8?B?Sm9hWC9QWVI3VkpHaWdsbUE1Qkp4OHNoT2tXdjk5eE5iTUYyVnAwTElnRURH?=
 =?utf-8?B?OXpCdDRZaXlXc0FuNDFsazg0b2ZRSU0vK0tvckZBOWNLSjFQVVA4TjQzcnRp?=
 =?utf-8?B?UzNqNHJYdTE3NXZ4MkxTRldicHA0OVk4alZ5QjN2RWEzcjk5YVA5VHJaaFRB?=
 =?utf-8?B?KzdzdWQzRkdQZG9jWnVmRnlVU0NOVEdyelowUHZVdXNPRStmSFlXYnJvemN3?=
 =?utf-8?B?NXJia0FxUHFXRzlZakpHR3ZIZzZ3NStwZTNSRlhab1FrQnFYNWxJcmVRRE9N?=
 =?utf-8?B?UzI4TXhjQ1FSUUo3Z01DSHFVN2doaUprQzRodEV5dC8veWcyUHZqa0Z5SmZT?=
 =?utf-8?B?c1BrUUIxNEVFbGpmNjRoZStkM1JPd0xjTnZvY1JvY0tySC9tZHhad3ZqMXVP?=
 =?utf-8?B?cHNueXFmclh1am84Z0sxaTc0MXcyeWZSUmFkUDhWSkZBMGc3UWtaM3hjOGly?=
 =?utf-8?B?WnY3OGQ5c01pQTlMRkZtS3UvTk1Kd3c5dWJySjJFUEtQZEExRjV3dzFkbzdV?=
 =?utf-8?B?WW1ua1MzV3NhVks5TFdLOUV4eDEzY0RYRTNMV1JiT29uclIyNnNDNnJma2Vk?=
 =?utf-8?B?cit0QTJuSEVPeW9MQlN2UjhZOWFBdDhJMUFCMjR0cWtKVnh6Q3g2cFd2T2pP?=
 =?utf-8?B?RndBMi9GNUNkbFpzbFRuekpacjhoa0RCT2swVjVTcEpsaFdLelFiK1lqVW9a?=
 =?utf-8?B?QkU4c1pja1FBMk5FSDZDaWROWmdoQXJDUDhST3ZIaUthdWdqMHVzZDV2dXp3?=
 =?utf-8?B?ekVJa2dOYTE4TW85NW5MOVRmOWJ6L1ZsZWRwZm5KWGRNTWNyOWRPT2RpOG5I?=
 =?utf-8?B?UnBlVUlOcGI5dUdZTnhHaHFWeDA2Qk1SOW9pVmRyY2dGQ3RNb1BtSEpKTFBO?=
 =?utf-8?B?bEZvRk82YWo3VUJMZWNFb3hlVVZQc0F6ait3eHFtY3ZoZllDaTVGVll0UGZh?=
 =?utf-8?B?Z3lMZEJZbVFuNzJDQkxvZEtGcHVvTzdNWmVPQUVqMGJNZVRES2pJbWFzaGFx?=
 =?utf-8?B?MWJaNWRJbThwY0MzVTN3NkF3UkpqSlZ5S0xQRW10NGU2QnVTOExPRFBhb2Zt?=
 =?utf-8?B?ajZEN0NwdnE5bzc2YzJsYm9rVlRLYkd6WmVnZWRMbW5UY3hwWU8xd2sxUFFL?=
 =?utf-8?B?SUFVWU5pbnQvSlh0WEc4Y0ZDYmdWQ3BaQXViSWEyVW1VY1FJbG1nbWI4VFp2?=
 =?utf-8?B?VWZJdlNHdjZ5aEJZYkxXSzVoODh3OTdGWkNSMkZZL3I3RFlLSDJOSTB0NlQ0?=
 =?utf-8?Q?pv8FMZ3tFXXHw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f75267c4-5d7e-4481-6827-08db302be07a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 08:02:01.3591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U7OyuaEX+tKyydHpuww+mFyPWwPGiwiO67XLZmWIN8mird2RnlaQoNJIOmlBbAJu0AurUx5virrI8J1ipIld9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5679
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_02,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 mlxlogscore=679 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303290065
X-Proofpoint-ORIG-GUID: 2TyH0h0sF4IcTt3PcfEjA-JM_Ud49MZs
X-Proofpoint-GUID: 2TyH0h0sF4IcTt3PcfEjA-JM_Ud49MZs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/03/2023 15:25, Jason Yan wrote:
>>>
>>> +static bool sas_abort_cmd(struct request *req, void *data)

Maybe sas_abort_cmd_iter() would be a better name, but see comment on 
naming, below.

>>> +{
>>> +    struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
>>> +    struct domain_device *dev = data;
>>> +
>>> +    if (dev == cmd_to_domain_dev(cmd))
>>> +        blk_abort_request(req);
>>
>> I suppose that this is ok, but we're not dealing with libsas 
>> "internal" commands or libata internal commands, though. What about them?
> 
> Hi John,
> 
> Most of the time user space applications are not sensitive to libsas(or 
> libata) "internal" commands. The applications only need the kernel 
> response quickly on their "read" or "write" syscalls. This patch aborts 
> all the application's IO and they will return immediately. We have 
> tested this patch for more than 300 times. The "internal" commands may 
> affects the EH process but in out test it does not affect the 
> application's IO return.
> 
>>
>> I suppose my series here would help:
>>
>> https://urldefense.com/v3/__https://lore.kernel.org/linux-scsi/1666693096-180008-1-git-send-email-john.garry@huawei.com/__;!!ACWV5N9M2RV99hQ!KG7BcS-ahRI8lUq_H-dXiVqMuVRP3VUDz2q5XnAkQkUCPGuKRAOXQlo7UmuHnS3P5ibgF89UER7UUNO2hfmp$ 
> 
> This is great. After your series we can manage "internal" commands more 
> effectively, I think. And we can easily control all the commands 
> including the "internal" commands.
> 
>>
>>
>> Along with Part II
>>
>>> +    return true;
>>> +}
>>> +
>>> +static void sas_abort_domain_cmds(struct domain_device *dev)

Let's make it clear that it is for a specific domain device and only 
affects scsi_cmds, i.e. not libsas internal or libata internal, so maybe 
sas_abort_device_scsi_cmds() or sas_abort_device_rqs() or something like 
that.

Please also add some sort of comment to say that we just want EH to kick 
in quickly.

>>> +{
>>> +    struct sas_ha_struct *sas_ha = dev->port->ha;
>>> +    struct Scsi_Host *shost = sas_ha->core.shost;
>>> +    blk_mq_tagset_busy_iter(&shost->tag_set, sas_abort_cmd, dev);
>>
>> blk_mq_queue_tag_busy_iter() would be nicer to use here, but it's not 
>> exported - I am not advocating exporting it either. And we don't have 
>> direct access to the scsi device pointer (from which we can look up 
>> the request queue pointer), either.
>>
>>> +}
>>> +
>>>   void sas_unregister_dev(struct asd_sas_port *port, struct 
>>> domain_device *dev)
>>>   {
>>> +    if (test_bit(SAS_DEV_GONE, &dev->state))
>>> +        sas_abort_domain_cmds(dev);
>>
>> This code is common to expanders. Should we really be calling this for 
>> an expander, even if it is harmless (as it does nothing currently)?
> 
> Yes, It does nothing now for expanders. I can filter out the expander 
> devices in advance to avoid the wasting tag itering.

ok, maybe you can put the check (for an expander) in sas_abort_domain_cmds()

> 
>>
>> And we also seem to be calling this for rphy "which never saw 
>> sas_rphy_add" (see code comment, not shown below), which is 
>> questionable. Should we really do that?
> 
> This device has not been initialized completely if "never saw 
> sas_rphy_add", and there will be no IO from the block layer. I think 
> there is no real bug but we need to avoid to iter the tag set too.

Thanks,
John

