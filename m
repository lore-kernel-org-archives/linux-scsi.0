Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E31EB64DD
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjGKVBl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjGKVBh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:01:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE2410EF;
        Tue, 11 Jul 2023 14:01:35 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BICwrP019612;
        Tue, 11 Jul 2023 21:01:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=TwdUMTLkIkXmFqGwQrgxfXzaAmPQeHd/IFR+XbRYepo=;
 b=p16rUN2jJQL42NOQqOBQnjTxF5Lu21Nuc9M2O+qq1U9Akm58eXPALp7N0uaTbuSXbeXC
 cF2beYG3U0/8aESdtbsQUf++Cj4P/w/2SiVpRCRjvVVjdodxF91TiFDVNCp6ne0e0dH0
 rNwmgkBdiEEtz/1rUh1v6+hY7+ZjviEJQ/N/JxwOznXiNQtYa223MlK6XQp93ghtBkTF
 gzb7LJycJpiNKKZrFQwb+7XyzqVI/S28c2fzRqw2CqmOf886p9JVhJUbCoFoVkgUcD9H
 /ErTi90po64T7D25UPInqouB330uCkMlbd2UgddpZdKQixnTQLFtjeEcu8OdeVyqDT09 ig== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrgn7uq8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:01:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BJqKgj004275;
        Tue, 11 Jul 2023 21:01:29 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx8brb8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:01:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LRrxYFLUw0PfvoNWX9XhLx/giUp4JDEI4Jf/Q3gOty45B9HdPSbBd6mGVQ4R8GEsrPBasup9LKZs3gpLOM8ywy+LoaFR8gQwEYQBFCXBUgGiXn3sSqdTxPqkaqak5mg5UMPWnTectuFOkTh+whukvlpzqihBbdZuKRd5TdS79uJdcgqHP/jovU/KvvCnkUL882NQIC51Lr5ALeaK9U1EuGlJi4XGlhpz+PR9B5z7HRZFPkxySqamhs41F2i3tgTYcF0ixPwH97rssAsmH38Uu6/3MPIsXIPyf02ARKnr2T2qcrkx5lN4eAT53Eaq735zuPoGdBfhDAO0mVPuv/9cUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TwdUMTLkIkXmFqGwQrgxfXzaAmPQeHd/IFR+XbRYepo=;
 b=dOsf9UzPyZ3u8tRz4jqzjyRq7LfLpP9mE70jitY6R0pafkMWUCuP//j88jXFkllkSLijAfedrd/v1aKm5fhhEtiEXEUlaqHW5Jjr2mm8py64GnNmDDQK2ooFIHhzwc4agHw7kDHWcrTBM1etre4V/55e0w06O5UlIi2k6YJOJU4DZOPIVykzOXxFijAoD1ULFOFUZ2wm0QknuNQUZR5IImzWcXc9Px/Szp6hDbE0a89pt2AAbTgdTwbHQLytk6deaT4WaWWB5ErMFm8hPHFDwuNao+Fumj2fNabl7BWD9dfjSAw7gCE2HORCN9gRVuVib8pKKbk6RXZ7V0ujZlDMlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwdUMTLkIkXmFqGwQrgxfXzaAmPQeHd/IFR+XbRYepo=;
 b=Ii1WgaZ3CKpkxzPwFHrJWqFrSFqVNNi+tFo/AW2biROfe9rfJoz6nM3UYbT24T7+6diSaJBfcQ0XrWBLdmj0+nywqPM360gYvsC0K/efDLoEHNfcZUnm3WJM5D6hdzmMqOdiByUB1iljzoBrRIzo1VA+1TLcU+3CJhwwgGAIjdY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4235.namprd10.prod.outlook.com (2603:10b6:5:210::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.32; Tue, 11 Jul
 2023 21:01:25 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:01:25 +0000
Message-ID: <6b53b833-3c71-2bd9-8fd8-757ecda75c53@oracle.com>
Date:   Tue, 11 Jul 2023 16:01:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 0/2] vhost-scsi: Fix IO hangs when using windows
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
References: <20230709202859.138387-1-michael.christie@oracle.com>
 <20230711183438.GA154686@fedora>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230711183438.GA154686@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR08CA0049.namprd08.prod.outlook.com
 (2603:10b6:4:60::38) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4235:EE_
X-MS-Office365-Filtering-Correlation-Id: b74032a5-65f0-43e2-a919-08db8251fcb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u0KMbdyF2ja+eHLLu3NUBV0r8Msx7gAh3hzlDT8gh+pvkDvgFaXibWXAd4cnIZME5Fi4oWgkxPgvyuOYcAldP425WKRgeo4RVd4x/OTtk4959op1LQvF8K0OrMtk3nmkOaeE+7lTvMNwq1yWgZ0dLQPOa+dgu+AE/kYjzSmV+bFONMdnlvhcLGuq2IKz4wY3lXxZVxGhFGAjBWHOLL1m39iu49IuE7LmY5htJ2xdp5tZZMw56bDooIXyOaKOZF3b9eDohTD3XYSD/Q5W3Mq9EeMvQxpiTPS6kxTmYUH7kjjbI7X5Ms0IPOsb18Lfu512nClqmjRRQVqAzXBDl0BSHzWGaOi56lf72AZ7sISbrnwilai42mGRMin5Q+/xT/CSrZeKORuHPELnybmTdMMIvr1434bD/asUWf0uxjH1Z1wns52BUb96T1/Bv12qKhQRI4yKle4y6du2sPn7DQztKjyHikPe2TVsqqkW6yufCH8TM7KvxtCSAxmaoYOs/R/NkFE6f1wUUNYJg5jmK3rIDWijxslBhx+VaPKObcEpzqgWLbXjYevC8+6iOcYgbvLVe9TGm6c0e5xq/MHn5H82WoEKTIQ8sVzDDIJ5gSftpPOSFID3lLliCWDhDwXFWLbJpYqynqBr+d6VUAkoZQ6fUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(366004)(39860400002)(376002)(451199021)(6486002)(6916009)(4326008)(66476007)(66946007)(66556008)(478600001)(6666004)(26005)(6506007)(53546011)(38100700002)(316002)(31696002)(41300700001)(966005)(6512007)(31686004)(8676002)(8936002)(86362001)(5660300002)(186003)(83380400001)(2616005)(2906002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3lhaUpFMytjWnBOWGRXd2VhUk1OdzNhMlNybHhBN0RrZlYzY01kT1pFQXJY?=
 =?utf-8?B?L2pmNDBqVjZYNndzSTZub0FBbG51T2szN1ZQRHUzVUQ0b2M0M0lTbDhzU05w?=
 =?utf-8?B?Z2M0SGJvc2xTcDhQWEhKaERJai8wckRoSFVRdHFNa1lqMFdtc0s1M2lWSnBN?=
 =?utf-8?B?Q1FXWm1KNmdkMk14b2k3R0NScGtuemFkTnNEVWMzVVIvSzIrcXNYRk5MMHFX?=
 =?utf-8?B?VCtpTlRZZEp4NW9uZ3Bhb3JqSWdmUTM5amlVblZDc3JlMXR2VWpmT2hIMXJt?=
 =?utf-8?B?WW5Sekx0UWpMOFlvZHpBZHkvTTc2WlRqQjNjWWVRZTJmektVaE8ySHpvcmdy?=
 =?utf-8?B?bTZVM2Rka0dVejcxSzFxWC9rM0pJNE9wa1ZWWWJRTzJpaG9VZllHekR0MExv?=
 =?utf-8?B?UHBPVXRzaWNiRk4zTFlMcWxnYXFVV0k1NjRjbWlYTzZSdWtxR2pOZEFQMEQr?=
 =?utf-8?B?cHdqRy81SmdhNitRb1c3WC9LNVptOURvVUZMQ2pXWXdIZHdoVmcySVhnL0pv?=
 =?utf-8?B?dXRRL1FrNVI2LzJLcFowd2ZTdVIwTUJjRXRCR2NQbDJzTXdxUVZYNzIwRUk5?=
 =?utf-8?B?VWQvOE1HckIzSEFUYy8xQ1NPQVVnVkdQZHVidy9xOTFEZjB4KzJLM2F3czNW?=
 =?utf-8?B?RVJZVEM3V2NuemhMSUNKM0RWVkdpNjRYRThOb3U4OENsZjhzN3hJbnl3d1N3?=
 =?utf-8?B?bGViTFc0NjZRWGFyNGYrRFkwY0UwMzdhbzlhWlhXck1hNW10bDAvMUJoK1dF?=
 =?utf-8?B?b1NUM014aHFFZldQY0ppYXQ3WUMybitTcmtpR3JlaUJmdGV3SFNMV1VFaUQ3?=
 =?utf-8?B?eWlZNXFMcUJIUktIaDJITTFFWVNMV1ZlY2JBUGhOSVNZZXJEWFB5SDZmY0NJ?=
 =?utf-8?B?VXNEeGEzRG95cnJ6clVyNU4vdHg1SEVXaVp4ZFlaVjZvL09IQ3MwWEV4a1F3?=
 =?utf-8?B?NlRVYnJPeG9LWDF3VmhZVzJtRjZ2UXhmZkZDc0FpSDhFeHM1Z04wUGsyRHVK?=
 =?utf-8?B?aEVvck9SeEJ0Z0VnZzZOSUFjbDlwWDFvQ2dLT3FEZGh5eWprWU5wSzFsS0NY?=
 =?utf-8?B?NmZ4SnMzU3FWRi84SnpoSUc1Si9RblZEOEJ6Mk5jNHpicjhuamdueCtZS24z?=
 =?utf-8?B?UGNVQ25tRWlmV1hCSjVmQXYxUXNRWTFJbmFUSkhDQzVNNjRoSkdkdzRLVzEx?=
 =?utf-8?B?S0hxWm9ldFlnVmU3RjZHckU4S3NkbktacEZxUFdGbzNXU3VJMlcybVMvUEJ3?=
 =?utf-8?B?SGRyaG81UlNDT2I0cDFFVkhTbFV3bGdJQmxCUU1zaU1nUnZrd3BUbGVBNVlL?=
 =?utf-8?B?TzFCQ1paMUNicEJvZXJXaUhrVHRoOTB5Sm5vdDhDWk1wVDU4WWxJNmRLbytB?=
 =?utf-8?B?RmlNS1o0YnBrVEJUVXhMdVZHblhDQ3RoWXU0T2xXVUVZZVp5bThiS2h2QmVh?=
 =?utf-8?B?anRJcUlyQjJBd0g2VHlOQktVMGI3Vkd5c3EwS0ovWEV3QktteW5YUHNNTjlY?=
 =?utf-8?B?QmVXSmtjY2F4QjgwODBHNkpOREhoL21wTzFyUTAwZU9NS0Z4aVZMdll2dXA2?=
 =?utf-8?B?R0l3NGlRcjRndTR1bFRLQ2xkSXM2di9hcjUyQ2txSU4wdXdrLzhXbSsrZHcw?=
 =?utf-8?B?OTBzMkNmNHBUNnpTYy80V0d5WlIzVk1aU0NGUnNpZHZaekJsaCtUZ0RqeUtS?=
 =?utf-8?B?aUdZQllteVl4c1k5cGxIRzRsNkdHYWhxMHFrdmlET0NLRFZobUdoREVkTEdB?=
 =?utf-8?B?WkhWWHlZcHNwUnhidDI5Mnc1a1B6czlZUkQrL3RKK2gxVlZpVkNldE1nUVV4?=
 =?utf-8?B?WWF4UzdKS2kzNmJiT2xkOHR5SUZ2b3NFcTg0Y0RaRVp5RzBGQ3F2MEFOUGJ2?=
 =?utf-8?B?Q2h0MDVONEV0aWl1elk5Slc4Tzd4WlRINU96WmUxRjY2N0x3NFd1Qmt4cFl6?=
 =?utf-8?B?SXZITWRnTmpZOXVSdEkzUllZNGVwU1RnZmIxUVRzRjNxTHpodG9JMHdIWEVy?=
 =?utf-8?B?c2E1S2dRNmxEOFZuTVRMMHMwaHQ2UjBhQXJTRENoaUVYdVc2ZTBFWE4wNzZM?=
 =?utf-8?B?Rnk4cXpOd1RvVE1QRGkraS8wN0JBMDFCcDVMUXIyVEtvT0hFdzZEWUpHT3Zr?=
 =?utf-8?B?NDhacnZGOWhxSDVVZG80V01GZ1V1d284eTNGaXk2bEIyYm5CbmZaNmtNY1BE?=
 =?utf-8?B?aWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: aTCLe9v+LcxM/A/Ekg2nXOmJPAJbRj7aD4B2gZHQLXoxQuT/FDgXywffbFXm+x+SWC6t/A19+zhx4Gn/HCwdD3QsbrBOdYZnywEQBdP13TkrlmrP96fDNPtvuewb2m/7G3aWPrZAryqLaBvMBVcIqyktjeRZPJXmm3y9msPjpiTkgUz/72QNqCKOxnaceoMGeCRIGNS//hJ9jHSFN+tNOmgkdQZIdZIdwEiwxipeqN/Hfx4xpyDkVywtMYhLVwONskt9wa6WSVnRoKpULqohQelyh2pMglUiRCR1BTDs5SVewCqkf2ceGSliRWL1NKR8wLUqc9W4+F3fh9dRQHc4iGo0T7I1jy6mT9hXCDSNHDjJYKNk2mEmv9QAfNExzu7tV0E4LPdllQx2OLISCnPz4Dkvc62NjY2zvug/4GgfyVY3p99+PJwBrNk3JOUkL9D7+olfXCexFhRaACsy5hbL/9x1QoXlp2CTENwubqnVkC9j6yak0/y/QhGdgfUhf/iu+J4yuRT0gMeNG5yEMvLWs79IQslUv3aC/fUltG/HBwILrYM2mZXFCcsDWeKJwYCpm7rXl4JlX6vFA9lskqDtO7ed5nnyZtfmWDMQoICUJ6RzI24iyp8GkmHJhc+XBLMgnDRC8OnxA3wo7PfE6PiHYaOc88v3YCZCMAqCW5QGpZlJOSxf1eR5ysy279I8a2UesHJ7D4EdyTByc+g1iHsBz5Z8n7HijPPTGlcRa2LUo5Ye6ad0+vJBVCM9rFS1xVGuX1Sca5sMitcZOhcZcl/yzYq888cA+Ji7d9NZtJ+UzCAHs03uM29nUg0XxVTgDb+Urv0IMQAoNJK1mbSLKM3VYTTpIbZ/Hu4qlZoakM07YEU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b74032a5-65f0-43e2-a919-08db8251fcb2
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:01:24.8264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zkJjkSZNj7Fu5GycqsuXA1AdTiPkq3xMacuzQ5O3ptqTXWBz5HDCFZdCqe0L6t3zMjm/tU5AKQTQ+W2FOrfUGTEF3Ws0aFQGsd4YcrvcJrQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4235
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307110190
X-Proofpoint-ORIG-GUID: LANMJyLH9JqXjx0aL6dIfiOPTrr6X4jU
X-Proofpoint-GUID: LANMJyLH9JqXjx0aL6dIfiOPTrr6X4jU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/11/23 1:34 PM, Stefan Hajnoczi wrote:
> On Sun, Jul 09, 2023 at 03:28:57PM -0500, Mike Christie wrote:
>> The following patches were made over Linus's tree and fix an issue
>> where windows guests will send iovecs with offset/lengths that result
>> in IOs that are not aligned to 512. The LIO layer will then send them
>> to Linux's FS/block layer but it requires 512 byte alignment, so
>> depending on the FS/block driver being used we will get IO errors or
>> hung IO.
>>
>> The following patches have vhost-scsi detect when windows sends these
>> IOs and copy them to a bounce buffer. It then does some cleanup in
>> the related code.
> 
> Hang on, virtio-scsi is a SCSI HBA and READs/WRITEs submitted must
> follow the usual constraints on SCSI block limits. Would Windows send
> mis-aligned I/O to a non-virtio-scsi SCSI HBA?

It's like linux where you can config settings like that.

> > Are you sure this is not a bug in the Windows guest driver where block
> limits are being misconfigured?

From what our windows dev told us the guest drivers like here:

https://github.com/virtio-win

don't set the windows AlignmentMask to 512. They tried that and it
resulted in windows crash dump crashing because it doesn't like the
hard alignment requirement.

We thought other apps would have trouble as well, so we tried to add
bounce buffer support to the windows driver, but I think people thought
it was going to be uglier than this patch and in the normal alignment
case might also affect performance. There was some windows driver/layering
and buffer/cmd details that I don't fully understand and took their word
for because I don't know a lot about windows.

In the end we still have to add checks to vhost-scsi to protect against
bad drivers, so we thought we might as well just add bounce buffer support
to vhost-scsi.

