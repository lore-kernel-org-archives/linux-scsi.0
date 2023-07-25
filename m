Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A31F8C0729B
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 11:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbjGYLKy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 07:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbjGYLKZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 07:10:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD48E7;
        Tue, 25 Jul 2023 04:09:33 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36P7oYtP000839;
        Tue, 25 Jul 2023 11:09:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=0v6vPuU+UoF6oLoliSsU7wHY/2ADDFgfQtYtUsuRlPM=;
 b=LgDt/zzIgSA42fr9G/11XccXjoNdOBetSeS+104WHCiHpPznH4GhFY/Z4ZtVhZBpxPT6
 WH70P1r8IwuOrO8Bk+cpOu34XbcYNXG+L2VEBLcpj85OLjWHyiVacr7v99V+yglV/ISg
 Fkx8ftC3a+ct1pjxKNqDHiLTMl7UAhhKHugb5A7HzhFNmpxcjENDGsg2DeOrlPNgB3E1
 Eao1HL/LXtV5h7u2GNaf0gaojexAw3g2hINRrPwUxaKqGGh7QObD3lJNIg416MVQOHEE
 ZYTOYn3LWWbOLzMIIEcDY90bjLrPt6oG2DSaopgUWKAwxJ/O/2jC5moBt4lCPiZwU5gO zg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05hdvsey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 11:09:21 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36PA8rr8037238;
        Tue, 25 Jul 2023 11:09:20 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j4knac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 11:09:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OxNh350l00Q5hEv7k+L9LY6OW1fLmsc1lDuYZFV1Qf0qljmdLfDoSKHpf4ldJJyCUTTcj+Ald/rypJjTde+BriMxkqDAEZKqXR0mldJGkexDTuxDCvKyk0ZFiSmrN8YxU0MptpfVg5/Qv79dOwtxLjANBdZNB4JuJQi37M8jKzDcUFVAJLQRo4+KmRQ7aYu8cCAkMyIEktqiemBviZInP5SgEFv2cN9PbH09LxIt9MnCwM5uUo8dUUeKxkjErG1UApvwrX8JdLpltOuNMgKM11Or4g2chUenuDuhS+EOWWtmqFDv2OGsvDBBddkV9E1grOyNETr0VmPpjG1QCwTBqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0v6vPuU+UoF6oLoliSsU7wHY/2ADDFgfQtYtUsuRlPM=;
 b=ZIsiuXMGroGFKRd/dIZG6NDKLOHc3N5tVj//oS2JK/VxjUD5P1c7Ur3UltJRtGQlvp6utrBQEYPcaohgBeoPrwtuARkzmN9iz0xoGrwUE/eE3t6giICKxHGa/VA+/Hay9rN68De0atOtVFxrdbdWGpRJ0jlEyJOwBnbbeAg1apNU1W9CKDNkKG9y50RyqgSrID9sU1bdyfTBtMrLtfAeq53lik785tRt+BmjYoa6ak3fUXQJFBfzzKFNHDy4Ogl5imS5pHDz5AtDwKE5KTBsWNY5AscmNwtvauMKLrwY/dt44IKIKXlSN6eC11574FX8aridytr/CQembHEducTc0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0v6vPuU+UoF6oLoliSsU7wHY/2ADDFgfQtYtUsuRlPM=;
 b=N6NlW09fi8nFzptv65Ntqm3LR0810kvpvh92rxGyHLYNlh1Xn/L2HD0RiwdKAsQ7UClWlt4U8Iu3EKaooDUdW5qyOZbMp0sQSM+nOQw2gEoVEAPQXhr+oYDS/DUdVBQqxiwIquoSZyBHfd42tMzl3gV4StJmm0Sgcq2PHO+L9O4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BLAPR10MB5107.namprd10.prod.outlook.com (2603:10b6:208:324::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 11:09:17 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Tue, 25 Jul 2023
 11:09:16 +0000
Message-ID: <a06d2032-cba4-19e8-2717-e764f51f8f31@oracle.com>
Date:   Tue, 25 Jul 2023 12:09:11 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 1/9] ata: remove reference to non-existing
 error_handler()
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20230721163229.399676-1-nks@flawful.org>
 <20230721163229.399676-2-nks@flawful.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230721163229.399676-2-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0474.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BLAPR10MB5107:EE_
X-MS-Office365-Filtering-Correlation-Id: 507d30d3-90eb-4e6a-3cd1-08db8cff95c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YU0ClOLgBbmZOpjTMnHewCjnOPQAfFGORmNlAO0MhyH+IyXJOpUd/dcfup5GAdG55oYI3E6ZaLuZsuWGpPaDHb0kR6ZPuzCWUbHkydRrD7JPjXpQO5AQ1zvoLyBwfvdupOhjYs7MW/agLguWifzHyv+jYVaHfuOOte4H9RrD8b7kTSNQVmg64PgJiO6M1IlABx05LkUzORvPgGepqQWe4N3YSJPbis2mswO+zQNV3sue6G0KNYjCnS0GbOmMb2gLG16GZOtGHzwh6/pvA+z8Y2dJwXDiudgySl6WBI0Fe2X3AtYhAzl9vpeRniK0ntpZ6K0GpqpkKhKVIgP+EXJoQkiDiSxPZOXqzww7MEdfYLW3ynifCrZU6YMRFQWLu/lldDev09FGUCk1afEKpCMx21nTYbvu5ibj3MCp7JHBMUm+3etF8ICnSzKlBlsYmgL9uar5dHFId/QzciqDNV9ee/M8VEFA1R8p9ALKd2AWsdw4Pzr8c7YWgEYEfuY7Inf4tRDjwSBbiF7PO87udnuYK+Rr/puRtcskYmsMHefpyxOzs7wSyIjBLRkdtapLweq6Sl0lv+W2KBnDbeDUqDTQkpZIOEEaoe70LzkTt4AwtpuMGEBGaWMwmrdredD59y3HnWbTj7r8k9lTvxpGLeWFCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199021)(2616005)(6486002)(36916002)(6666004)(478600001)(86362001)(6512007)(31696002)(36756003)(26005)(53546011)(6506007)(5660300002)(41300700001)(316002)(8676002)(8936002)(4326008)(2906002)(54906003)(110136005)(66946007)(38100700002)(66476007)(66556008)(4744005)(186003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THZ6b3llUFJoNVcwNFBJY3prOTF6SzJJeGtnWnl5c0xGRnlYVnJDLzdkeVU1?=
 =?utf-8?B?Rnh4UkRuaDVFbTY1c0haWEdla2I1dkFacE9iQVBvT1BPb1VsS3ZORDc2K1F5?=
 =?utf-8?B?c1NQb1FXbm5MT1NwSHVJZGtvU0NNejl4OE5YeFRPaElDUkZpaEVqWXFwVG5N?=
 =?utf-8?B?ZjFwVnNxTitGTUsyalNwVGg5ZUN5VVM0dTJTWThkR1BnN2dqZjJSNjdmbFB6?=
 =?utf-8?B?THdHY3RxcWJaV3BUaHVMaTZMWWxhREtQSXpsamJPNkRDZ290akpjWmFTa1Zz?=
 =?utf-8?B?MXlGMWlzTk9hdmVwbVN0R0RmQUl2Q28zNko3UTkvaEozMW9nNmpLbFUyOW9J?=
 =?utf-8?B?VFl5dEZheTRUS2t0UWJQdE9IdGNHUHBnRWYvdmt6bkRHeXllVURJYWUxUVdp?=
 =?utf-8?B?MkJTSzBLOFdFaTFzT1psa2t5L3VWU3R5RFBKTkwzQ21PYUVTNEJkczd2NjQ1?=
 =?utf-8?B?NWlhQmVsaTBZSkZPRWZWbDZZZVV1aitoNEJKM1FPQnZhaDlLQWpQM0Q0MkFP?=
 =?utf-8?B?OGhONlUwZFl0Tm5jSEZLckx6bEkyb0dRTjJwS2FIZ2pOaWNSMnVSUFBJR0o4?=
 =?utf-8?B?Rm5PMXNwcjZMeE5oWGI5YzMyMEYvK0czeWxQQWwydVZjSlRhVXFleUp2d2M5?=
 =?utf-8?B?WXBuMVRML1BMWXlQVE11ejFnYVc0YStIeHBWYjV0VnZod21yaGhYWXNwc1Y1?=
 =?utf-8?B?WjJzVlJvYU02Ymp5Nkg1WVJWSGJuTzhpVlZjeDBFUkhEbzkzNTVUYjV5WGtj?=
 =?utf-8?B?VWMxUVdEL1pvU3hTMklBVEZodnJzdGRoTC9wSnZnMlhkNnF4dWdBQ3V2cnZQ?=
 =?utf-8?B?TFZHdHB1ek5IUTFiZi9KOGRERk5MZjVRWGZCeDMrQThLRy9mVlVJcElxN0ty?=
 =?utf-8?B?TnNDQWVGa21uSEFOMlF2bS9tbUJ2a3h0OGJxUi9hVzBZRlN0SVg5NDF6ZXUv?=
 =?utf-8?B?OHRKTUJyNkE4QUtMTE9oclVWeEtHRHVlV3RDR1cxN2ZEWFJlbzBJa1V0cS9B?=
 =?utf-8?B?ZFB6ZWt2eGtscTFaK1RURnZWNWFDSmFGSGlmTTd1TmNkUWZUM0NBY1FWR2NP?=
 =?utf-8?B?SlpXOHNTTVpuWWhTLzF6aVc2ZUVSb2NNblBFU0prYUF6akdOWStGRENTSVI2?=
 =?utf-8?B?ZmJmSm14L2RMWHpZZUFlamVUVVEyejh5SFlQZDRzZkFYb0l4RnVkOHJBQjJI?=
 =?utf-8?B?M1d2RjgvS1pyOUFxUjRhUEl3N0o0QTBWZTNiV1oxcFVELzByYmx5SEJ1UUkx?=
 =?utf-8?B?T28rdmZvL0N4QkR1dUhVNzc0TTQwcDhtbFpjaDlWaHhteGR2QmRHV21GT0Jz?=
 =?utf-8?B?c0VUSXZpQ0RHNm9yRjlOSzJvVUZTSVlhYUVxT0RyR0Vvc1g3cm1yd1YyRmxG?=
 =?utf-8?B?ck9ZZ0FNRTF1T1ZNNW5BdFlCaU1IOEhWS0ZrM29lQjg2RWZPUzQ5K1o3UDRx?=
 =?utf-8?B?VmNGcjNTMjdlREduRjMvcTNvWmljUXZabnJBM0lEQ1Y5K1gxR2piUE92SFQ1?=
 =?utf-8?B?eDFkTFRjTmcyV2xEUXQ4eXJZR01aWTNzZ0N0SmErMGJQQW82c2o4d0VZQXNn?=
 =?utf-8?B?SU45WXYxemk5cFhkSTRpZnBUd3BHZW9TY2xWdDBpeEw1YS8wODZpUXlhZ3ph?=
 =?utf-8?B?VUtCQnhtZU1SMExNS240Y2k4dkZvWHZsaUFWc0E1SmpkeGoxSmgyN3ZaVm1v?=
 =?utf-8?B?aW5GNGhpcVNSNFE0Wmp5ZHZQQWNTQ0hsK251em4vNStvcE1xUUQ4UlVRTy9a?=
 =?utf-8?B?Z2p0Qyt0Rk12OWZWaUlEUlgrNXNmNXhrUXByN3RvR2NwQzYxTXgwcGsyV3BJ?=
 =?utf-8?B?WG0zMmNEbzJOaTBTdGhFeU45Vlp4SGNpTXIyREcvbGpQc3c5dlBTYTRHYWRQ?=
 =?utf-8?B?K0oyUGUzRXJUK3BxdCtrNFRickVWaHpoc1grMU8wVWxXeEdGRXRhNDgxSlRQ?=
 =?utf-8?B?ZnZTVFF2V1dxSHFIcmRHRURSY0svNFI2V3ZHU1p0dVRVYmZvNHBzZ2dHNzIz?=
 =?utf-8?B?VXVPMVlraWhEMkRFOVdQaHBSY2xWZWpsZzBEQU1wWG5hTEM5MEtONEo3Z0NF?=
 =?utf-8?B?cGNBYTBCRE5EQzhvaHlUWXhDZjdZQTA4WGVtS2dhSWhFemE3ZlRyanRTeG1p?=
 =?utf-8?B?dWQrMmp4RVZQQlhjZTNzbWlQQW1ubWNnZHl5QlBHYzBkdm1WaUw5TEtKRTVJ?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: i+5snU98KnBbhCfCT4PWbPvJ8ZNaNiN0Xwn+tmBfud98ouAGPZlQacPu/8HQcR1cnyueO2tiTtwfqAMBzbD7/JWjzxkiOwcBI3LP2tC3AXlQ01JrshObQ2ptmN6gMhxcwQQLFSw6LvkBkxIUVgZvnTZyEopVhSY96HMra2XQdUL1do3vBF1wUJaHgNHwiPXtgI4etbW/gCPUxychGV7cKAvOV6YVW8WDxTemr+watVaGU9c5x+C4oxlorClzTJnagm+f/XZb4ml7GeVBBED4szyhZP4sVy1oqv1hDBwjJecyWgR0uOWfpl/G5egd5Pad8WH8oxcqY7fNghItMF/Fld++2becRgnqzdOdNyvJPL4Ljid/PdEvHMqhsVho9fJiLF2SgEjDZKPtRPEV6QrfN0+SpBkdfm3iI90KZWBiWW9hVrZk6DmLvaXWSuR1BIWkSACHxxEY1231/mLoKdaQL00chRA93X90r0KCahqnyJ4w1SYPlxlHnKWeUUATj+90pFM1wpH1P58DEddW1cnDTZj0jG17LRr0T2tOO4o4QOABeg0/CyBq9mhTXsqoA+GOJe1haUxke8gAWacigM+RjPNxtmAFhZDsJ4WilBKpUwHg2y0DX6FHyCHhaUJLQvmXv2yax+000l0Qv92daGOn7kG0cKnlQpggWrRCiEzA2wzCElm+i7wDEA9npaKyCLjj/Oe9ItrOHQHobSVJ9KZ51Q7vJEPARoVrDJ1KMbTT8Ahwl/mFPXfzSFEHGFXujOQUTtYYnyiwAf5g4BolsYCFW9YWkuSJZ6PEF7eJxDv3g91AOmEY/rm0/9jOLWd3UxHBEjPlvNw64VoboPDz8bLPXANkFNzc4rpHC9n1yP1+YFDJr2HzqCSwHpJjAHj8Cg8HCYA/MGYEN5XMyicKYU3MLQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 507d30d3-90eb-4e6a-3cd1-08db8cff95c5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 11:09:16.2743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L+CLFSr9k4hMLC9qpzRHG1I4UkCn8tFUKdph2zolCZ0d78j+wZXS5pFdtvfb4LgLWZPgk6pjxvdnxNho9ELaMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5107
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_06,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=958
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307250097
X-Proofpoint-ORIG-GUID: pLwNMEwdWPJVGoxFBuYF3MQF-1gWa0q5
X-Proofpoint-GUID: pLwNMEwdWPJVGoxFBuYF3MQF-1gWa0q5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/07/2023 17:32, Niklas Cassel wrote:

Reviewed-by: John Garry <john.g.garry@oracle.com>

> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 820f7a3a2749..3eeea76c30de 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1785,7 +1785,7 @@ static inline struct ata_queued_cmd *ata_qc_from_tag(struct ata_port *ap,
>   {
>   	struct ata_queued_cmd *qc = __ata_qc_from_tag(ap, tag);
>   
> -	if (unlikely(!qc) || !ap->ops->error_handler)
> +	if (unlikely(!qc))
>   		return qc;

nit: It might be better to explicitly return 'NULL' here. Or maybe 
combine with "if ((qc->flags & (ATA_QCFLAG_ACTIVE" check to have only 1x 
point where we return NULL, like

if (!qc || (qc->flags & (ATA_QCFLAG_ACTIVE ...
	retrun NULL;
return qc;

>   
>   	if ((qc->flags & (ATA_QCFLAG_ACTIVE |
> -- 

