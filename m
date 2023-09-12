Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA8FCA0ECA
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 08:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbjILIJd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 04:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232328AbjILIJX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 04:09:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EFC524F
        for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2023 00:59:48 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38C7e0f5011015;
        Tue, 12 Sep 2023 07:59:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=eWblgpJMKVsXyfs+nCyCQSlSx022vwAfHa2XLNI4pwg=;
 b=Egvorajffp6h75d9fTBLWK1BiWQoHkVdx0HVjnj7l44+gt2FqYeLF+Wz9ejLoPiNZPyz
 cWTAV/AfB42fhuph1qX1ENUNBpb3euZ7li2SPPOJz6xAXT/BkP4tTEbvYg5kBXvXP9Ra
 1nZIiTe+UVAmpq/ioZb5aFx2bpmdWk69K4er4eFl4SRIO8a+MRIBsB5+YFJvSX+wpWlT
 hprsjGOpREWreCXvO6mlgneccnAEsq/b5pnhBwXTT4M356W0uiQE0sOWzp6F7n2z/YZB
 xJZvu6MwSFTawKtpyB1QVd9dSgL18OAaNw8mBikSJ2ZsioSoIQ46KwbQEU3a2s8Z6Vyt ww== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t1ju1ub9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Sep 2023 07:59:44 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38C6AWaq007757;
        Tue, 12 Sep 2023 07:59:43 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f55d6xs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Sep 2023 07:59:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PqYfpS6tjXLzet2n4EJjMGqIdwWgkOBlDfiC/JhUH5CIqE1LL59BiHYZ5bHe6uwoK6rTiCSY1KPb+zuSfdAXTCGIyNxQtGsjZGUM7v5Qau2PFtONDwlENi6/lLVLXAF3jxOgBG+xUps9Yw7WcyErh0nP05qfxCO+cwtIX0qyORwgi02bxKlHBfJQWHkOmQg9gp6QLmbugypnzhWaTaPHaR4VBr/QoXBbpyi8ixFFEIqn5kHkhqRz2QqydikkLZDL+htDsn+m1dCkM1qU9zO2uWSP6SXXNxpKeUpptQPU427bs3ACgN+PshobvYw5JVj4Vwjj4JVnGr3F7Cc9JzyW1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eWblgpJMKVsXyfs+nCyCQSlSx022vwAfHa2XLNI4pwg=;
 b=CKM2JG1f7PJdcBpxDr9zC4RWlOf2TAulUG8yhPIS9rnwKLxZFf7e4QDaL0YAwCb14EBjtWIToPoYnvlfv2YzhTlyi4XW8Llruc/KytreeHZdZHsJQyJZMpZYNKgJ558FRyOlNvJD72qH9jE1wfjWSOM1sfC7U3O2LqRQdUQlwQmrs0qXXfCaTg+HK9IbSK7NbZUq60ItSU6Iy9yWEKJSFbvokKL2th3tGmBQ10XK/n2aOsPZT8Ocga1/Y5nXbCelzeeRjx+npvvgyOreRtj+Ik5Odp4XREpeZN1f1W/0jHCiu5QrNwxho3NgKHKE85QjPY1ON5wbqiHHjeIavvwinw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eWblgpJMKVsXyfs+nCyCQSlSx022vwAfHa2XLNI4pwg=;
 b=Cq+NaDayd2AtufB0dCFH9A3EB2AhcxwZiUZSTwFBcmeV9dKpUs846hSaJG6fZj6Gp86898wWvJFjXrgkwG77rVjwuNcr8KtjcRf+WgnQ35gpzqfyppFHctuNTRttYKjd1BhXYuyJLG2zATQjANftfRxXZXThxkNPsLqPsAVktTE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6629.namprd10.prod.outlook.com (2603:10b6:303:22e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.31; Tue, 12 Sep
 2023 07:59:41 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6768.036; Tue, 12 Sep 2023
 07:59:41 +0000
Message-ID: <dd0d0354-9ea1-aecb-e6de-39e225ad0d50@oracle.com>
Date:   Tue, 12 Sep 2023 08:59:38 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 2/3] scsi: libsas: Declare sas_set_phy_speed() static
To:     Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20230912074715.424062-1-dlemoal@kernel.org>
 <20230912074715.424062-3-dlemoal@kernel.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230912074715.424062-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0543.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6629:EE_
X-MS-Office365-Filtering-Correlation-Id: ec3f061f-b13d-433d-4704-08dbb3663847
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HlfZtfSu5urNi4b9GWHyCeSzKemhDE6Uv78cgiglE5jAXp8p+UABKg3t+JVb8xm2trN1MHp1fkV/N90D/CE7GeAbSHZKQh5/szR51fKWQamWU2pZ2799ejDKKIBLNtMiBAA8lUn3S2emNKrLBeIdBTKm/hwKbIAWWjM82BLGm0pO7++YSe00agOV0DDMDjYtN9hHkFnToQPtxigxZtVaMxlW/qCBEiUZrA45d3048deHfg2Bk4FDxbx3gslEvXs6eHt1D5hXc63KrR9GGtvOoPAlTWU2cpdH+n80GboCaWE/yFFsRbz9ei0+THAusSjqJB8G2/NkqLuYhQxRVgSK+kHx6teaK6WdDP+dFe/h/cnUwjpHD825LH4pVoW6b9mZMp9WX0BL0SlHRAnWMtP2K8zi52Wt+3y5EEmZwP4/YtGKDgIA6zSciv4U0LCfaI+PddSih0LkDQIeFYCwaCVVVnccCZF7B7Zjz85gJT9FUpRJuZQR1QEQfmFvnaBw/b0T6D5lG9V1n4D9Li05Bf23qobr+aBwwS0ZuCfYAOnNRIT+TQnRF8Zc9ghDN8+eB29/Eab7ZC+bhdMQI0yO/3+72QeSNxasZYts+tSM/chfK/MzE18T8H6bR30Zpw3CjAvxz+T5V8KBfzKJqG6e67PteA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(396003)(346002)(376002)(366004)(1800799009)(186009)(451199024)(26005)(5660300002)(8936002)(8676002)(2616005)(2906002)(83380400001)(86362001)(31696002)(36756003)(38100700002)(66476007)(110136005)(6486002)(316002)(6636002)(66556008)(66946007)(6506007)(478600001)(53546011)(41300700001)(36916002)(6666004)(6512007)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWpVMHlpK2VZYVlRSms3VWtBRmhjV1gzNDE3RkcxR0lrOElvWUpKaENMSVNh?=
 =?utf-8?B?aWU4Mk51cDY5SnpxdzdmbXAxY1pDakhVa3N0YnZ2TjZsYnF0OTJCS0FTUWJC?=
 =?utf-8?B?KzRNdENZbk5ULytyUE44dXRSN2ZPMllCQkhzVmczVkM5S3gvZk9HMHFpeW1h?=
 =?utf-8?B?c3lKLy9VYWpYdDdqZGZTclRGN1lBS0ZxWHdtbVI2SnJoM3d1M2tnYXJMZVht?=
 =?utf-8?B?dEhML1d5SkVWcnFiTmdveUczMldqZ3hOM3FvNjk5K1Z6MDdPeU0rYXp6NVRN?=
 =?utf-8?B?ejZKVXUxOXNWbGQySlo5eUtDWmROTUNTaW1zL21jUUZDeCtmb0U0QXBwQThU?=
 =?utf-8?B?UjhoSjBRNCtRbFlncC9mQmRPUXVLMDhtbHlYWklLNnhkaGFla0J6K2E5eDh5?=
 =?utf-8?B?Qmc2aS9zR3FnUForOEJDVVVKdW0wMnhVOTd3MlpqV3FPVjQyWkdramVyam1M?=
 =?utf-8?B?NW5DN3RScWlzZEluVXpFb2F2WGIzdFIzM3FHZmNOdzlyNGh6azdjTk5ibTZS?=
 =?utf-8?B?M1JoVjNWTlo0UktxbFYwM2ZrNDBiQlhuaDc3emtqakZuOFRpVEVqdERyRVE4?=
 =?utf-8?B?ejFTKy8xL3hlZVBpd2FXQVFQL2dKRGR1UGJSK2RacFE2OG9mVVRXL2x4Smxt?=
 =?utf-8?B?S0xJOXp0VzQ0K3NyNkVhVlV0M09PSDVEdEVCckUydTQzRE0yTHBaYXZxd2g2?=
 =?utf-8?B?ckxaY3lFWjJ0ekRFNkVjTWNlT3FiVUZoUU02Um44STVsWkVzdWhvR0k2WHJ2?=
 =?utf-8?B?Q0hIRHJRL0pRUGUyZ3ltdGpmZjNnK2lxdUQwR2VXL0x3OHcrL1FVY05WMXNv?=
 =?utf-8?B?eW4wb1psc0ZKUThMK0NZNFNyUWxZeW9NNTJVbmZMT1o0YkZ6eFoxYzdOSUxk?=
 =?utf-8?B?TkhOUjBMMDFKRG9BQWpPUW5DeWUxWVdMNGk1VUJOZ3d4R1Rja2R4ZVIydXNL?=
 =?utf-8?B?NmRlZURWY0pBWWlnc2h6UGVjUU0xYU1WcDBIT1JDMmExcDd2TzgrcmQ5OGFj?=
 =?utf-8?B?QWtmcStLWXU1czdTR0NWSDJVdS96M1pTSmY4NnRHZjI2T1RVV1dDU3MyUXNo?=
 =?utf-8?B?b2pmMERJRVZKeEJoV0g4M1diek9SK2JSU3hqOW5rZWU2V3l4S1ZrMFpBbmo1?=
 =?utf-8?B?ME9HWEZUalZzVW9EYlo1WWtGZGt6MUVXakNEUjBkVUlyckFiOFV4MGs5VjVt?=
 =?utf-8?B?UkRSd3U0UmZzVEo5V1NJN3YvckxRU042Z2ZsRzlsRnovMC9CZVAyK0JKemNX?=
 =?utf-8?B?S21MMzVtZ0poN0ljM0pWRWJ1RXJQN0kzUDQzWVZYYXRJdWZHNGhncFMzR3Fx?=
 =?utf-8?B?OTFRTDArWXdhQTBnRCtIYk1MaEVWYXNxaEorbFZ1YTd2V2RiNEhpeGF3V1pp?=
 =?utf-8?B?c0pxS3l0OE1OYXA5MVlKdWFwU0YwSEJsVCswNE1BTHhIQUdXZnhGOC9rMHJt?=
 =?utf-8?B?UWwzeElEb1NvUTBnTUFiUDd3eENORnhxVDlKTTJMNkxNLzlraVJ0RXRDLzJY?=
 =?utf-8?B?WHhaUHRjbk9TQkVLTjVWQitWU2hWWk1VaTVRUFBKNExQK1RMc2xxWnhKQk1V?=
 =?utf-8?B?TFhTSldTOXhPSnNxQUxsVG9XOGtqVU9RVllwSlFwMFh2bjJzUm1tcWVTSzhi?=
 =?utf-8?B?T25DRWNiZ3NLQ1NqZFcySkdTN3AwTHdQaC8zMjEzbGlOSy9oQjNsQjMwWDBT?=
 =?utf-8?B?ZWUvZ2JrR1VLcXNxeEtpR2syYmNKeWtnOTdDd1AwUFBrTWsrSzVmNFVoVjJE?=
 =?utf-8?B?RDBXbmo1M0xPaENJejl6cUJxajZuMWYzT2lDQWJHdGJJVXNKUDNtRGxxMkJM?=
 =?utf-8?B?Qzd0dGVwbkVnZnZzQVRrUlVQckttbGtsQ0RUZnN2N2s5aHJQYjhhM1VLK3ln?=
 =?utf-8?B?cmVxTDFkNzVPRjgybkk4MkgxekpyMWJ6MDdrYU1RNUJaU285Zmwzd3VQWUx6?=
 =?utf-8?B?Z1hocURUU0RSR0ZWckFXdUV4TjRRNXpOUDUvYU1GbHBnTG1LS2kzMXArVVg1?=
 =?utf-8?B?SEd1dE5aNTJUYXBQVUQ0azR5U2pWeEdiZm1HTUtwUmlpaUtCbU0yMjdZWHl6?=
 =?utf-8?B?Z01vcHJYcDl0aVZCdkNHaW5qZFhTVngwZVl6aEdTTzVjOFZoM2pwYmVQQVVZ?=
 =?utf-8?B?MFp6Y0FkTm4wNldZTmlGMzFVYTJxV0haQjNIWFd3c3AvdTR6UWNnOTlSLytN?=
 =?utf-8?B?aGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: YbZ9k92NxshOtsaaEQX+bfMUpB3jVvspwLMNkHw6o3Ak0VTj8Gt1oV1Qi07M92yxn+9GIrNOJMCoz95JD2KG8HKtej/Irb1KC7cJ1aMoYVCm2o25tm+6qSsIy8iwrpZeSFGZhyHXApsvNHpBzh5hFf9iurNwG4X3Gq9Nzwbw7vHXsPcOmBsRxs+y7ICMXpPngoZbl8qvz4KDOIpUXdxfkLZKh3tI1WYdZWlsraJQv1GKePDwPIKyd9lvlTUpybMDPxEBdjWOLknhvKFWz48o4KItUieQB3zIZQvnaiO80j1EwOIr45bQ0kCERhxHuui1nMltu1zT+A2Y0bzgq7nuaxPTRmPzRgo2uVs2CFdwiKYS0AW4LkcH4WRnJEqDMPpqhNRuIMmCY1sMMSWH/w4xe/zhFQm6SsH+8/8PRbf1qpQXhyYcdSyiXJT4ZibiyHXCVmwDv48uoTxysfCOQThEaQ26u0z7TLwTmttQWBUWK7WPXarkK23uGHrDIUcmOqn/bivMqoX1vKItXfNj7vFAH4hAYmu+iE5u0Mmvsqf/VeaieHR5TFFSYaImf4dAP9Dt1dg4JVu8US3o5vsHvMgwNQpQRfPVQ2+6OBBeFG00wWt51f6noEp3KjKxmfE+M9Jvw7fsiEsnqpCIJ3ZhlnJUg9ctOq0ApF2sDENa5OBEJdCy5URz7vdYhi09Va1deFO0ZzZ1I8bpGibDdnwDKkUzn5gzMcrmuUGmKmwPDIvgPbcXOtIOUsVHImVpqiSmeCCWlIV4mLDVcC1UDl7zwgbcsEqbvhEpL3jkRP2NVyr7T4M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec3f061f-b13d-433d-4704-08dbb3663847
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 07:59:41.7929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dJZFs7lo9LRtPvwAyN3s6thoYx022CXo8lg+CYZ6jsjp8me9su5OWh4iHUurAArEpB6DXrMxXm8rLEwEvE8DPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6629
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-12_06,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309120068
X-Proofpoint-GUID: nOz0kfMF_DSqmkibYkQf2VxxlIF5oEM1
X-Proofpoint-ORIG-GUID: nOz0kfMF_DSqmkibYkQf2VxxlIF5oEM1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/09/2023 08:47, Damien Le Moal wrote:
> sas_set_phy_speed() is used only within sas_init.c. Declare this
> function as static.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/libsas/sas_init.c | 4 ++--
>   include/scsi/libsas.h          | 1 -
>   2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
> index 8586dc79f2a0..9c8cc723170d 100644
> --- a/drivers/scsi/libsas/sas_init.c
> +++ b/drivers/scsi/libsas/sas_init.c
> @@ -315,8 +315,8 @@ int sas_phy_reset(struct sas_phy *phy, int hard_reset)
>   }
>   EXPORT_SYMBOL_GPL(sas_phy_reset);
>   
> -int sas_set_phy_speed(struct sas_phy *phy,
> -		      struct sas_phy_linkrates *rates)
> +static int sas_set_phy_speed(struct sas_phy *phy,
> +			     struct sas_phy_linkrates *rates)
>   {
>   	int ret;
>   
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index 87f194925b3c..5ee86b225359 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -679,7 +679,6 @@ extern void sas_resume_ha(struct sas_ha_struct *sas_ha);
>   extern void sas_resume_ha_no_sync(struct sas_ha_struct *sas_ha);
>   extern void sas_suspend_ha(struct sas_ha_struct *sas_ha);
>   
> -int sas_set_phy_speed(struct sas_phy *phy, struct sas_phy_linkrates *rates);
>   int sas_phy_reset(struct sas_phy *phy, int hard_reset);
>   int sas_phy_enable(struct sas_phy *phy, int enable);
>   extern int sas_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);

