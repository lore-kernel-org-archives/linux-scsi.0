Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B27C00A8F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 10:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbjJXKrQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 06:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbjJXKrP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 06:47:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A79109
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2023 03:47:12 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39O8lSle029415;
        Tue, 24 Oct 2023 10:46:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=+1o7DRh3qhnZG9jADPS/ejMB6+rCy0RGZae0iU/qlJU=;
 b=ExY8Hu0JKw8S6zsRaMhXwuXj13s8ekDkMXRvoQk669xbMqoI13i2mg84/GLc0HwX3vbo
 SMZllRlw2vpYACST99kRHnjH+cQMUd9sMlP7T28k6+aSFEavr5lmA/B9so6jHIcnvLlR
 uVi2lU0RnPSe8xI+PiugGt0hHqa48Y9pK4KyMAlUrJd1wYj1neHwCnjHwIiqTKAY+URI
 JGhHpAVknAbOryRUgcvEsmuRvgXtbPzIWG+RRTZI2wvNNqn0a8xdCBnP4C9MxBbZ0VRY
 0XByFdanwvVHYLKoCLXDYJ3OpROpq02jVc0AHSX6Zzmv8gm9sj+UkYTMgJ8QaNaiPCOI PQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv581n7dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 10:46:49 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39O8jgiA019015;
        Tue, 24 Oct 2023 10:46:48 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tv535bxgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 10:46:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HKLB3w6VmGVGzwqqlWuVgzCS4Y/TSdKytYvEWedQWbzmlpBvzsSpzyWPkhUK0VrSw06UBEYMpqDl0qfCmvSZG/3iMw5rBK0utDj6aA4oaTQzuYyy0tzn9PP+K/F1b+swGujRnZQ2bnoPJNgdyP7f2aWYM+xWUt6o5zErUhww7lyvU6rJgjZ3YLQK1UJMCEXQJMtLPWD4c/rGVK+KvikioIjEuG/rSNoSMeWgvjHNreroNngAex90BkWx1py/TYw8U8iK1wDzLCuBaGJLRWZ1wc+HjIMlTKXYRwRD31q6ZjHicp8zb/+XRrSXN6wGHAJc8RjAqZaI2xIegbyYtx0kxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1o7DRh3qhnZG9jADPS/ejMB6+rCy0RGZae0iU/qlJU=;
 b=Wg5QzrvvcvEUFSQOVb5GpIqi1fhWdMhsg076dHXS//XSXXLX86PSfLJS3gqi3V48h5q93JlC8mpJu5cffznNFus8RPKjtgjHmFHjpDMc9fqY5RsN8z8iyVb+td49ncnfifk4EjNevPGXb3hAgednzTWwNwqrFgoMg5qhShxZZUe93r0drWiwSA7n0oD69I0j4PnxCNEcxGwVl6UM/+QgQvw2vIV3l1/+eynGYmyYuvrE85QORAdzTN9nNIOJAKZ0ybldDhGZgdmFuB9TBzpN39yOVCuyGvIeJm+PKrhY0HKbkeUsmxlO/GrPysr5TH98Otd6uigBGb78dQO296HFhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1o7DRh3qhnZG9jADPS/ejMB6+rCy0RGZae0iU/qlJU=;
 b=LbuPReHifQZ4x/CCEoKeRiUyXA9Q22Hu1VqE8Y+8faRVxeX9RYAVzURoiGcaWriM5PwuQT/JXgvKfFvDnK5LXuOhXoUw1BM1elNie1NZp5MqBTV1DRgVxMJUY/5Ne20ExnQigPONEIWV8zySlrWRA5ZIeCJq14OdyfDOraWHj6I=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB7906.namprd10.prod.outlook.com (2603:10b6:610:1cc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.29; Tue, 24 Oct
 2023 10:46:46 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::2c06:9358:c246:b366]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::2c06:9358:c246:b366%2]) with mapi id 15.20.6907.032; Tue, 24 Oct 2023
 10:46:46 +0000
Message-ID: <4da00d15-2715-bd87-daed-16b348535782@oracle.com>
Date:   Tue, 24 Oct 2023 11:46:43 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] [RFC] scsi: mvsas: Try to enable MSI
Content-Language: en-US
To:     Marek Vasut <marex@denx.de>, linux-scsi@vger.kernel.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jason Yan <yanaijie@huawei.com>
References: <20231022200329.60844-1-marex@denx.de>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20231022200329.60844-1-marex@denx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0249.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB7906:EE_
X-MS-Office365-Filtering-Correlation-Id: a89fbfe4-bff4-4fe4-7a4f-08dbd47e84a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ooyQwkDXDmnnZ1Dwcol6Q/j/AqVIV4pCPzEXrWb/MzmPDlzWBc51nWYzs89lDczE9dhBeY95lICt5CBrBz99B+d9+HTMsHwsp9QbDW9DTKCgfwyepQnclvJpXSuAIoYREAYC00wQOuSb7jEWXyynM2N6xPX2ifCHhRqi56nWDn88b/MrjoVel2jO8VnVb+ZWVK8XJAvpw1oyqyTo5pF6RtiPuiuTdPQrNV/OhQwG+OCvzkyxErkypJI8YvBeeMabj6jM528ajivRu+FaYHoQKjE5Nt5xNuhl5yOBlMki0TBBpAt2whzgwV3SO3fShKNXLqPEwkbhted7epA8yw/BvVw47Et6fQXgKYddQOIE/ebobpscIBMHmqMAkxsgCAjOSJ3xvCFVT+dJtzwUTmkNbHdaQn+npBdrgnkpiOBWJKFnJMID0IMkOeUYacoUHHhtgW+a0k0gemS08YASnIF687ap+PZ/MTMQwBBwNgikeuG64pCCI4L79zevxB1OLbzRUiMYEHGUo7hQ5gm8e6zU0Jagvbo2HzuPECSB0YZHhvKozvTJKxUkiOAdJyDe/jPoA32ZTSh7l+WnSuTSOQlAfvsml62yueGUHyWJvxZzIuE7TI7+XivjQ2InPacxzQmAegkCuNMnYyLICTTJBI7cxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(136003)(39860400002)(376002)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(26005)(31686004)(38100700002)(2906002)(41300700001)(31696002)(86362001)(5660300002)(36756003)(8676002)(8936002)(4326008)(2616005)(478600001)(66556008)(6506007)(66476007)(54906003)(316002)(53546011)(6666004)(66946007)(83380400001)(6512007)(6486002)(36916002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVFaZlZxYmduZWxlWXR2c3FwWFhKNTBXeC82RnM1SURHdTg1c2tiR1VaRld1?=
 =?utf-8?B?WkdQNTNsdVFQcnBVYXF1RG9NVy9JaDh4ZUdJZ1BBRFhqV2ZIYWIxcGRkam54?=
 =?utf-8?B?MnRlTGNGZEVMM1hLblU0K0tGbUhLWjR0U0NRQ2xsMnRIakp0UnphQzNTR1FM?=
 =?utf-8?B?RnVLYXN1U280WUt5ak5OK2VKTWhuTDVTdUhPMUhuekJTU0JSYW43eUluRkZw?=
 =?utf-8?B?VW8xeU1mdzhPa29ZajdhZmpkMGhQS0J5KytlYS8vOVRYSlpoNG5HOG1WTEY3?=
 =?utf-8?B?NngrcGE4UFgxSEFKZGt5Ryt1V1gwMTRIeGdnK0dVM1p3WVJGQjY5ZGhWcDdI?=
 =?utf-8?B?eEVTcDBxejRMd3RUWHpmaFJPNjM5UXhGR2NIWU9YYzg2SDhGT1NSa2lSUWw2?=
 =?utf-8?B?T0k1M1NMZW1JM3I1ZVZveXdjOXhKU2Z6M1hucmI0OXMrNmdKZFByZFRBV09G?=
 =?utf-8?B?a05WZk9vMDhNdUZ5Ulk1aFdSa1NMWHhvQzRFYTZRM1JJRlQxOHhUMlV1ZFhE?=
 =?utf-8?B?VW1JbjNhMzFNbFFXMit5TStwb3czd0NndVdwL1QwS2RPYXkyNUM2NHE0blpD?=
 =?utf-8?B?K0cxNnAxVXAxd0M5ZmlsZU5NTzdNUnVCdGdWQkhIOUt4andlbzFUSGp4NXEr?=
 =?utf-8?B?K2RDWWkzV0x3UjRvdDRyOEw3ekdad1VqWjRkbkJQRE5vUmQ2UkxPdHJ3L3FJ?=
 =?utf-8?B?ZUgvQVk0RENHZjJraGNSQ2pJWlJRUlAxZG9jeHRpajIrdTdDcDJvZVB6aWpN?=
 =?utf-8?B?KzJmWFNFay9hT3YvTHhPMTVlSVNQeVRPQXh0S2xwcGlXM3dDbEFNUUFoeHpv?=
 =?utf-8?B?RElNMnZWTTdHakc0bnA3TDhmd2pUTVNHUUFMTnhrZTlhUFZpa0ZxT1RrdlJY?=
 =?utf-8?B?ZS9NMGxqVHBTWnl5MHJIcUdsekNVdDQvZTdnYndheEIyY0VpeitZWHBZQmtE?=
 =?utf-8?B?U2FYVUJZdDVxU0k2U1VKRVd0QVR0NU1IK2wwRUNtZC9JTW1maGo3dk00alZt?=
 =?utf-8?B?T1dkRHdWbnN4MnBTaVRqbzFmY0d3VU1PY1k5ZitISlhINUExN0w1R1owSGZS?=
 =?utf-8?B?RjZ5UHBjS1h4VnBsdVR3U1dza2ZBQlg1aW12THZodnpOMU1NejJINWtqeTcw?=
 =?utf-8?B?bUxGNnhSQ2xOcmtlcnhNNUZCbFYrNEwvTXN1SmFZdWNJVnZDeDF2YVRsTW81?=
 =?utf-8?B?dFM3b3ZWbGo4bndVVk5JaFpYRGJqZGI1RmFZYm12ME04TVBFNDJ1MWhtQkFZ?=
 =?utf-8?B?ZlVBWDRobnJjNFBiRkRmdGtyOU1JUHBJZjk4dEd5cDNnV0puajdDTVBMTlBj?=
 =?utf-8?B?dWMwR1NKRjRRRG5rNEs1OVRzdmdoV3QzaURLZGJoVE5aSUdNUGg1K29GRFpL?=
 =?utf-8?B?Nm81WFBBbnNkU0ZMMzV5MENaNDBaK0dlazVSWGZMNHRpRTFQVXFISzFkZkRZ?=
 =?utf-8?B?WWpZZVUrL3ZtRklIWU4yektSblg4cnVBYmJGZE4xVUZkcCtvTGg5enBxVzF0?=
 =?utf-8?B?bURaY3hWMkFWVEIwRGlmNnpjbzRHb1Z1R1VXYXE5YjcrNXB2SjRKVGVyQlIy?=
 =?utf-8?B?SGM0WFc5T2t5U1hLbEJHczBPTDJZMloxNmZsV1JBd3oraTBJaUc3ZGV5eU9F?=
 =?utf-8?B?MjR4ZUlZOGpMd3hseTc2S1JSd2M2ZnZ0dCtBaHRkQkFkdE02cFlxL2VJTTZj?=
 =?utf-8?B?VVdaejRPRGlLREJ3MXM5SkhkUG1Tb2pzVmNQVG1hdmI1S0VNcm5zQml3NE5G?=
 =?utf-8?B?WDh1RUZDckpnbGU0K2FELy8xemdzMlNPbXZaRVE0V21xZW03Znc1QnNob2VX?=
 =?utf-8?B?eXowV2VPTUtuU1FSQ3NWcTlCVkk5WG9Pc21CbzllM2p5UVZHZ3FPWi8wUm5o?=
 =?utf-8?B?RHNlRk5rSllGRUJxbmVtZXFnZFdkcEpocm9jbGdWK095NUtjcTFsSFBFbDRm?=
 =?utf-8?B?Z1RlMU5zR1g5SUZ3SkR2WmtLWmlVTGh0bE1UdmNPd1VkWUdqNmRMdDRub0s0?=
 =?utf-8?B?RDU1VEpUTDJmcllnMVlOWGl3ajNoS0ZnbkNhYlYxSndyV3orMThPOWtNdWYw?=
 =?utf-8?B?V2xtY09tMDJlQnJOd0x1NEljRnJmbmdVZEh6Ym82TDY3TVp1YUhXY2tyM2Fr?=
 =?utf-8?Q?r93IW4cjKeBJn+swDskRmmooM?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: iAR2BHu420fULBcIsp/HlFPntUM7spAtnT1RxNWe0AWig6tGPlAeiMPFGXMkHRn5c+uzAQDQdPOraquVne59jX7bevTId8dSOy3BrpoTdEdeIgSFtjIfxQL7cNxKZqhFLJO0Lopkx01mcmzell0DKaneD6Kd8/SqX6tkMHmrxugsmjebnNllDclr9ZW5twUL4tAmfeBk9l3pCx7Nb/YdrYV917x2LgOWPA4U0xFlkRT2FYT+RBo/SwbKcdaaUkz9F2ttCUTL1tA0BXI+OyoAwvVdb/ML4zVq7lK1c1NaTQReIIh4MMJ6VmvGHruTX8Ow7EaHxNWKX1uq8TlHzoUH8gQ2EggFwoDJcxbGNlU41lqpEOBTEsfLfbzIRM6pLNYo0NDJB9ZEa3YKB+L/i9KbqHd9JYsxTyiSPMbsKJHlfmsViM/QsBKQEWtspCfPlpay7hsAEIVdZokW8uOEbYfS2D4n1xOXFF39tT29G1qSta71A7eDb1tYhKrdYpaPx98fOkPNAjBcxjctZJYHxjVBLcya05Z9ds3BQuFJmmUkmn4G/Yp0Hd2XzDt93+dBuDJOOuSvEaVDmyzynF/DYb8pHUdZoZBZv7SteG9b+LLEn+C77Um9tUPF+mvOyzofiOADIS5n+JFNk29kmY7f1GxolzJU+fj5b/cDcuZScC1+FyJzi8/pcFdBQuCLtX5RXS3EleEto/dSn1kQt9MQya3Uf2Tj0pAJYNrSKpQKbqnC5FMwPtxV9KdnnJ6313haL6OwP0qx1h+k6JJqg3kofBkPrm7ZpWn3CPE+K5sKwO4bNcTK3bhSIKsfrlEwEQ6nmbNm9QU4AHntmhT/liMsrlNf/0CMqaUiQQX4cZlxE+0397gCY4KHJgLaxTysDNJXAyxRz+7ar8+ZBQkZEYTj/hwVIw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a89fbfe4-bff4-4fe4-7a4f-08dbd47e84a1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2023 10:46:46.1153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2HWfIGOMMeUx403N18hWIKAHDh1ODWQVNmXQqoDSsKN1XHs0ItYGia8hG4ic88fQ0iA7lvgN+eYc7U3kFGlYjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7906
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-24_10,2023-10-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310240090
X-Proofpoint-GUID: zx0r6Q4VcVfFwY6cD_a0-rBMf70ep0he
X-Proofpoint-ORIG-GUID: zx0r6Q4VcVfFwY6cD_a0-rBMf70ep0he
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/10/2023 21:03, Marek Vasut wrote:
> This seems to be needed on OCZ RevoDrive 3 X2 / RevoDrive 350
> OCZ Technology Group, Inc. RevoDrive 3 X2 PCIe SSD 240 GB (Marvell SAS Controller) [1b85:1021] (rev 02)
> 

By chance do you have any documentation on this controller which tells 
us that it requires MSI?

> Without MSI enabled, the controller fails as follows:
> "
> mvsas 0000:00:02.0: mvsas: PCI-E x0, Bandwidth Usage: UnKnown Gbps
> scsi host0: mvsas
> sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> ata1.00: qc timeout after 5000 msecs (cmd 0xec)
> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata1.00: qc timeout after 10000 msecs (cmd 0xec)
> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata1.00: qc timeout after 30000 msecs (cmd 0xec)
> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
> sas: sas_probe_sata: for direct-attached device 0000000000000000 returned -19
> sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> ata2.00: qc timeout after 5000 msecs (cmd 0xec)
> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata2.00: qc timeout after 10000 msecs (cmd 0xec)
> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata2.00: qc timeout after 30000 msecs (cmd 0xec)
> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
> sas: sas_probe_sata: for direct-attached device 0100000000000000 returned -19
> "
> 
> With this patch, the controller detects the two SSD drives on it:
> "
> mvsas 0000:00:02.0: mvsas: PCI-E x0, Bandwidth Usage: UnKnown Gbps
> scsi host0: mvsas
> sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> ata1.00: ATA-8: OCZ-REVODRIVE350, 2.50, max UDMA/133
> ata1.00: 234441648 sectors, multi 1: LBA48 NCQ (depth 32)
> ata1.00: configured for UDMA/133
> sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
> scsi 0:0:0:0: Direct-Access     ATA      OCZ-REVODRIVE350 2.50 PQ: 0 ANSI: 5
> sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> ata2.00: ATA-8: OCZ-REVODRIVE350, 2.50, max UDMA/133
> ata2.00: 234441648 sectors, multi 1: LBA48 NCQ (depth 32)
> ata2.00: configured for UDMA/133
> sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
> scsi 0:0:1:0: Direct-Access     ATA      OCZ-REVODRIVE350 2.50 PQ: 0 ANSI: 5
> scsi 0:0:0:0: Attached scsi generic sg0 type 0
> sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/112 GiB)
> sd 0:0:1:0: [sdb] 234441648 512-byte logical blocks: (120 GB/112 GiB)
> sd 0:0:1:0: Attached scsi generic sg1 type 0
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:1:0: [sdb] Write Protect is off
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> sd 0:0:0:0: [sda] Preferred minimum I/O size 512 bytes
> sd 0:0:1:0: [sdb] Preferred minimum I/O size 512 bytes
> sd 0:0:0:0: [sda] Attached SCSI disk
> sd 0:0:1:0: [sdb] Attached SCSI disk
> "
> 
> I am not sure whether this is the correct fix, or whether this should
> be a controller specific quirk instead, considering how this is likely
> a legacy controller driver.

pci_enable_msi() switches from pin-based interrupts to MSI. So currently 
the driver relies on pin-based. As such, I would be more inclined to 
quirk the driver for this controller.

> 
> The enablement of MSIs has been part of this driver before, but was
> removed without any real explanation in commit:
> 20b09c2992fe ("[SCSI] mvsas: add support for 94xx; layout change; bug fixes")
> The enablement of MSIs is also part of the 'oczpcie' driver, which is
> really an ancient fork of this driver with a lot of variable renames
> and such.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> ---
> Note that the "PCI-E x0, Bandwidth Usage: UnKnown Gbps" is due to QEMU
>       vfio-pci VT-d passthrough, for some reason this is what it reports.
>       The issue with PCI MSI happens on real hardware too, this vfio/VT-d
>       is just debugging convenience.
> Note that this would be nice to have in stable series, but I'm reluctant
>       to ask for that in order to avoid breaking other peoples' machines.
>       Maybe a default-off kernel parameter for the mvsas module would be
>       acceptable for stable?
> ---
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Jason Yan <yanaijie@huawei.com>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>   drivers/scsi/mvsas/mv_init.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
> index 43ebb331e2167..6850e39237d3e 100644
> --- a/drivers/scsi/mvsas/mv_init.c
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -571,6 +571,8 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
>   	rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
>   	if (rc)
>   		goto err_out_shost;
> +	/* Try to enable MSI, this is needed at least on OCZ RevoDrive 3 X2 */
> +	pci_enable_msi(pdev);

You should check the return code.

Thanks,
John
