Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10CDCC678DB
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 17:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbjCGRiD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 12:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbjCGRh0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 12:37:26 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EB151CA8;
        Tue,  7 Mar 2023 09:33:29 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 327GwvKZ009633;
        Tue, 7 Mar 2023 17:33:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Kh4sT6YmFVA/Sk+UHUKTawstl89N21XF6wZK67Rhnx8=;
 b=qOJXUdJsdTKHYrWM509FEKRAzStZoyFc5nqAjX6W76AYEa5qXQclCyVN9X9VNzqHSGfw
 wQZF63oQGJ/L0yHoqzc2HFYQ1IuMdfsZbwmxI/Mk1XtnlVZR0+6oPR+ewYUvB639pPXr
 /H0bcX2dTqumJtMnQkYw7PoPSX0e8v9VtduqNV4nneFDcj8Tz0av8fBBkb5VRGfO3LVJ
 cGxqvlPvjNZUWIarmxLOoOGQSfqFxvYvmyS2884miRGLu9zIfiFmGrdLqD9QR7Hf5iXB
 1RF+YZGhSmGxHVTmtqOwR+ZkoK4MQeXbYiZI9XW3nhpcBabnGm56XPQqgVTWuQU213C4 yw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p415hx5p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 17:33:19 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 327HKiIE011468;
        Tue, 7 Mar 2023 17:33:18 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p4u2j3vgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 17:33:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKcyrnPaGZQiIRAFmNYRQj0x/LvZb7Zy5ttEccV4aueqKIJtRazXryQK/AuSjrDzaEmmGxf5rPWe8O4EHZ+crog0rAHTKK6WwFA/EZjwV4w419MacB5gZ352BO7bY/vCBtHbuSBOcjGbZwRDm3aeC3O40dLwD3ar5bholVENTFf43yHiZ4gR3Rjf9/MkDA7avEI2C6zBrP5SWiJGVzpqqsOPFbFJjpOX8dgi2LsJemYTYfkz3A+rSKMRbTlGqJMt5uYqCHl2w+3afY8dxByWONdsSiJ/PQsQN7qJ8DXsyjFXN0Qli5pTjMTrPY8Mgvpe3xFItbHQPPXO4StzHBlWMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kh4sT6YmFVA/Sk+UHUKTawstl89N21XF6wZK67Rhnx8=;
 b=fcZD7e6Q9wBq8El2IQeJEF6xFhTnoUXymiobVcX37CU81RBQKRCPqi2pSD9ENeCOgvoVyuzmZ6wTURVpNXN8HcjMBdDH1b4JrKjsN04OPRQNf18eyPEcE8QtDpr6bjRPvjXE0D5MtMN8PMXixRJWIDl3krwr+SgjA4xf3eg1N/2UWrsFlTH2rBUzeYBGJWr+L3kWJBQLkeuwD+s5AHGtLeqMqlbEQjCOqoYC/MZ8ZBjVRQtl0H91M5+nMTusjJ5CTvWQpj+ozcA9XPRbGNH7Pm4yrA4Sh6skj+rws/n84Ltggmy1lfAQ2dSrgPLhXvFi0KWXXWY/2r/JE4dLaNEXlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kh4sT6YmFVA/Sk+UHUKTawstl89N21XF6wZK67Rhnx8=;
 b=JBZasF641khjgRC7J8qAWRKAj2oyBhkHleznE/UcZL9Hl0norraexmlKDiykcfFHsq4XmD/FfYdnDNF4rv50SXPOdq2jJkUX3ZlhzwfDRfTYdBI3TujbU/OOzZY5865gHnNfdRncM9O0GujMMpPhorCnPs/HD2zbNEyXrvu1jIk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM4PR10MB6183.namprd10.prod.outlook.com (2603:10b6:8:8b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.29; Tue, 7 Mar 2023 17:33:13 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.028; Tue, 7 Mar 2023
 17:33:13 +0000
Message-ID: <f5d334f3-29c5-5b90-33e6-9b42f4196996@oracle.com>
Date:   Tue, 7 Mar 2023 11:33:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 0/5] scsi: target: make RTPI an TPG identifier
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
        linux@yadro.com
References: <20230301084512.21956-1-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230301084512.21956-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0173.namprd03.prod.outlook.com
 (2603:10b6:5:3b2::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DM4PR10MB6183:EE_
X-MS-Office365-Filtering-Correlation-Id: 04040d4a-f3ba-4e58-a19b-08db1f320762
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UGD6RTkwS3hLklJuYErSsvFmQFxVlKRl54qiy5ViQpKEsQQnR33+0S2ECyGW/2Lspku4mQRrhzoxKRYAI2oJVrbOAcT8STxmkfJG+YFPop6HdcpxhlQyuNyaJ0L2ac9re0xLpCpXd2wvgiKxd6W7aiEz4mSCAs4ulSRR7YeN7tq75bVch7OKuF1lGO5hgNilEqt0FPE2TtzmNA7T0gmkf5HFtCXhewDovrjTAN+0RCo+6iko7+Jiyy8nYD09QzjB1mAN1N0r2qf/Ptr8o6cjwp2+CMuTjnbQtG1fs7zKKJ3NsASSc1FUrzgEd9kIwGCPsOwI3Zbb59QbUGUqSfcvuhwX/j5QEkLCW+4j5LwakH/sMTULkqOBYFMl8jv8X98PQnHJ03QYHSzeEuykckSIac3VXjJGUEySQajbWeO+WrAvzS6W4G7XB20JMYU/GSH6mxkFftOsOixP/9VxpNxELFZtom9BCa1Ft2rSy47bqX0tnwCKxJ5YZC2P4HqUULE2Hl0ZZBDB+zD2nIHxIT8jwpc7i/S/ACsa1l/UyO3vkUhe1gOTVuOBpKdPU5Zu0ZO3BUtF8mYIrcqw6FPzEGOe+sfl+PjByxYSUt4+Xu8vfI6qs6eS6Y1FFti9/3SJgwXENMA2hQtHb/ihxV5onuU7YhIXx3zDTeRUqs/sQSiMMEFXrZtCn6ntJCzW1OaHTnr4DaEggnAliKh2rLJzdYDBLyUGopkPY12hfbSvpARiaFE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(136003)(376002)(346002)(366004)(451199018)(31686004)(2906002)(2616005)(26005)(4326008)(558084003)(66946007)(66476007)(8676002)(66556008)(5660300002)(186003)(6512007)(41300700001)(6506007)(53546011)(36756003)(38100700002)(8936002)(478600001)(6486002)(31696002)(110136005)(86362001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUhLNk1oUjBITEVtY1V0ZENMc2laT2pNbXhuUGd1ci9NS2ZmSVJjcDJjQmpZ?=
 =?utf-8?B?VGZINUNRSXcwZ1NNTGFWOW9zaEtpT0c4UzN3V2cyMzBuRTAxaUpETGFoYndr?=
 =?utf-8?B?U01vbWIrU0JCSlpES2t4SWpwYllkZU9abGhNbW9LbFU2aE5zT2F6TG9KVDhv?=
 =?utf-8?B?Znhack1sVkE2THR0dEpRZ2U5WFlOUXVCMkpERHlVb2g0TklEODA3ZjRYZXhN?=
 =?utf-8?B?NnNaemswd0MvZnVlTlhLVmtuazZEV3RHSzByak4xRWtZSWZkMFZ3azR6Q2l0?=
 =?utf-8?B?Wk4wUVdKRWI3K0RaMlRwdDVtSUZZQStxNlBJRnJmd3lOTTJrMTJiY3k0TFQ2?=
 =?utf-8?B?WHcrRGVpeFgvOWJiSmtuamNEOEJ6akZmSS9rSXY0NlhKOGxtL2VGS093cnM3?=
 =?utf-8?B?TXFqVXA2TmtaRWlpNUxocWVjQ2RranhPNE9Xei9ibTVaY2VmeDNndGxwd3J3?=
 =?utf-8?B?WE5wTnc4NDN0eUptWnNnVXB0bG1qcXJNNjBzZFdCL0l1MmJCb3AreWlNRWNt?=
 =?utf-8?B?RUdhSlZyVTM2U3RjMmNYRytKd2QwVXJIaGN1SG5Fd29sYWNqMlloQ2cwRWsz?=
 =?utf-8?B?Y0JtcklpNU5VbVYyenBLTUVFV2Y1NUJZK1pOZ2ZZcEpmU2VtTGdaa05vdWlB?=
 =?utf-8?B?WExrUG1oS2F0S2xST25INEJMOFVsdzFKZ0FjOEVvSVRBby9saVlXYi9sUlA0?=
 =?utf-8?B?V1BKZDRUR0QyZ1k5TURCQ1Y1cUJYWE1wekw5SGhpSGFhRmVjRUlPNU5lbFlh?=
 =?utf-8?B?bm1kRFpGU1QxbGNqcmhWaHJ6LzVGelU3SlJ5M3EveHVZTXdqNkJWSlZVS0J3?=
 =?utf-8?B?aXdrL21OcEVtZGVkS0RaQ0doc2paRnl6Yk52cnVvVlhOcWJiNDZUejFzL1RM?=
 =?utf-8?B?VWF6b0NoV3NCTHhkaU1kQlJhN3lVYUY5VUpVQUdoV0diZGRBOEtIc0Y3UVlD?=
 =?utf-8?B?S2ZWbmU2RDFoWE5Fak1SYjZMQ2F4T2E4dWd6cXpOTXo4RDdlOFp3LzVhTGY1?=
 =?utf-8?B?Q2lKTlNVWnZGeGM0STRLWWkvSVBNVTJGR3Z2L3RjcHRYZXgreVNGVUZtUnZJ?=
 =?utf-8?B?VU8wREpQcC9wRnpOM2hCUWYrdGYzSFNLYlRUVmJ3YUt3S3BsTFRldUhHS3pH?=
 =?utf-8?B?SmNOdlVOQ2tjcDFaNERaRS9aU1ZTazBvNVJuVWh6bUdmMVNZNEQ0bUYxL2dW?=
 =?utf-8?B?YStuYkJJZ0JQbGJZd0lOdS85MG1DQlhqeVRNTmY0U21lOGI5ckMyVVJPSEpj?=
 =?utf-8?B?NkZNVk44eDA5RWRYWEVTcnc0QzJnUElBUWxTWGxyU3hTbEVFOGVZSTJyMEFI?=
 =?utf-8?B?eW8rRzdJUm94ZnphTzBtN04xbDRKVEtxaHQ2QlVHdHIwd3JTMHE1Y2VLZTdT?=
 =?utf-8?B?UVQ4TmgwQXJDbVIzT1dxOWVFN09sUk1DdUVpM29McExNKzdUUWp0eWxQZzJv?=
 =?utf-8?B?eUhWQmZxVGtaVGtNaGJZOHFWb0JLeXBqRFRESlhhR1VGdmFVeDNQQlNkS05j?=
 =?utf-8?B?V1p2UUE3ZU92cWw4QXpLUjhiTzh4YXZybHRhWTdhV0tqT1hWYm9hZ1EzVDE2?=
 =?utf-8?B?N3BBWFpNR3htbDI3K2JOTVQ4MVRRNlhHS3NqMm04TkhtLzc5RGNtK3lVYWNS?=
 =?utf-8?B?cTNPZGpHcEplK2RLWThFaUlHNlU4SnVnaHNjZnhvYm8yTkgzTjdORHpHYU5a?=
 =?utf-8?B?QWgwb1NTM0xueHpwU21lZEtsZ2VxbmZyWElWSXpJT1U2dENxVXMwUVZKRXlH?=
 =?utf-8?B?V0RFTjNJZ0tPRHlkTTl5K2wyeEdlVWRLTGN0ZXUvbG5qTm1ydFkrOE54TzVS?=
 =?utf-8?B?VDkwbVFhSURtRHJKNG1menplbFBOVjlLSEk4NHJXVEtQZEhhRFVtZlAyY0Yy?=
 =?utf-8?B?S2s5LzJ6aWsrSGFiN0RyQmFqSmd2ZGxUN2pNd3dqeDlHWGxrUXdoRzVTdEYr?=
 =?utf-8?B?UTkzNmNRaE9uM2Q2L1JJV1J2RlpNZWtFYW5yS0hUa1RLbnFQTC9Fb2E3blJm?=
 =?utf-8?B?YTVhd1VYOWZ3bFprZ2JoZUU2QVBJQ1dCdWZGU2k4ay9vVWRtM2xkS3k5RzNj?=
 =?utf-8?B?TU1DMEFmdDdmK015cThDUjBtMHR2VXF2K0JlYWVVNVBoVHBnL1llZnc1YWlN?=
 =?utf-8?B?NVFyYi8yRUdFM3lydU9Td3Z0UEFuc3BNaktVaTVldEtJNG5oSTVjNGQzRHp6?=
 =?utf-8?B?MlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NpnTQd9d+4zX102YpJHtCWfy2XtJ4NRFcedl0FspqyijnkTOsci3jDr6Rh8+kWdN14qDwLq3dgn/205oebOD78TJlQDFAPJys/eua7eK96rO8us+xwKYHl8rwAbiDPHf09kq1l+MDmPBDCW3aPBZiWlcB17kDTR3vSBeLmeV0ESx/g0rM8hDOFt8km2sUN/mLGztQrB/LWCh53SxrWap2iHt7B3AwzcUFzHoa27PIRH/NUcjdpMMqOV8DkLpHcFuh/nhNH0mbEVmOsHMQzfMdTiWCvgs9yfmHS3AanmFldJ71xm2X3e5yqnTj7DhYXFHArjbO45b13ZWjh1/v0l6BzAHcX9+mwYjEYzh4c3uI58QNDWOdj2xYLTwbNIMCyDG6Ev7PySmIbuGV1Bty0Zf/F+3CbMY/o/S5itaS6mJrJ8jbuou5y9WfTfI9LZ8yLzN9fJW+fj8L0PzSTrM3WjyQ7r6SJurrsA7Pn10lLrGXvuQ8VQKP5bCNoTOqjjONNYmEkJFABdp/DkMjiWovpxu4yzijixDY1b0TOUCwzlBAOCF/7WMpFOg4HkBt6O/938ydQ1jeNzJGDrcg33UybUk+9G0cHuVkzx3i13Y2R1VJbCZjBX76sE2I+Wx1GTxf6LAz5OfKOJNOoNhFMMvFe0NfOKm6paviy1U4qRzTqlEXp0KTmYSLMqJkAu2lHoqhD2sbCF3Uj1fA0Xj7r54j2SSCjXr3KnY6zp0OoqHdPpQSvsX3ZbIAWWGlCUTzKGWboh2Aiqc9U/xaHgxKydFameXsqOvSR2M2pDoeR6TsG4xF3U7lsrqXUAGdkwOrQ8W3BLg
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04040d4a-f3ba-4e58-a19b-08db1f320762
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 17:33:13.7349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cju1zgt8RL3swAg43gF3XdPRRHy1aIMGBEx5i4Yg4j7tqdP2c9dfpNHskRN3SAAIu2DSamgz2JPhS0+/9+gU/YyiZpxjO2kj9n8cjGbcLS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6183
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_12,2023-03-07_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070157
X-Proofpoint-GUID: 9VK3peYTTIRW6W4xkauOX9_W3hRuYBz6
X-Proofpoint-ORIG-GUID: 9VK3peYTTIRW6W4xkauOX9_W3hRuYBz6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/23 2:45 AM, Dmitry Bogdanov wrote:
> The patchset based on 6.3/scsi-queue.
> 

Reviwed-by: Mike Christie <michael.christie@oracle.com>
