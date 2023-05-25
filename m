Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E02F8C7EE2F
	for <linux-scsi@archiver.kernel.org>; Thu, 25 May 2023 15:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241776AbjEYPoG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 May 2023 11:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241459AbjEYPoE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 May 2023 11:44:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4574BC0;
        Thu, 25 May 2023 08:44:03 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34PFTpPm028904;
        Thu, 25 May 2023 15:43:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=PfCt2W+L6TFotc+w5A/DhUg1S1NlzNG39fvQGxoJhnc=;
 b=Z/BUT2NlfUkwyvEwq6HkOuUaNPq33FVfGW+/UgZFIXPBM9JC4nHtEmINEUWtS6XSm510
 +7113D4Qt2CuZ2zTVOvoF8mM84Ww/IjnDIujZnD128Emv8bespP3P4sFZXtcPfFMRmrd
 l7U7ZUQMXpIWJIee0ErarxZYynOuELE3kYKn0uuvm1Eud8L0XaEWUfKzBZlCE09IvhLE
 o35aXCF3m11wBsrtghcQTnfuGItdNdvCn17U31JEk7YGbH1AtVg78n0kTX/Vw8gbVLrB
 gySy96xjDO1u98n3HhCFXKaUhNqwrkQ3Lbe7ZUNX73zQedu3c890LHLfX3dhR+FBC5LI eg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qtac1r1d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 May 2023 15:43:58 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34PEhoDR027323;
        Thu, 25 May 2023 15:43:57 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2gh2rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 May 2023 15:43:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eC9WBaqY14Dn0Dp8Sb+otvVORg6LERsh8TQdQ2Ofk/lZ5AVTNRNAcuZRDiSltIqpGJvjdgBiOcJ0BmiMAZKW9++tsuCaDS0/oT12MeObqa2ES9J7+sqxzuCx4byRKszarX2QBA6LwhYk7hFAQoKOacYzaPuy0pfVM0JAWx2iEFBTtLtkbia5CkjMpl/N0P1m3X0y+4QQ9ZSGM2xmzfNOKeBcMsa1xPp6Rn5Pe5sbRlnRHDkEhT20DYqd47i+1DK1xHcv1a1G+bvNbO3/ZwFLCb2gfZSl5jPghgfddBBhYBQYL3iG4Z8+2p8Ke49eUGYvuJdZP/lAsMy8rtzqcayykw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PfCt2W+L6TFotc+w5A/DhUg1S1NlzNG39fvQGxoJhnc=;
 b=M4/wViyIZ/4qD132bgLYpwRW23jrF64gyQxwnkUK6eR4krXldZX6HcyoJXEeWDZUOVGcDMe1tsEP7ijgjjKGNg3OCIVsD14Qzpjztj7MiSNY8BAr5B2bNDDJs63ZDG+C2gJzSuqLfUAwVIKuxA5Hljo+NNEMqOGyFBQiJSvg15jFEs4ocJXwEeHgmEYVljJyQsM/lkF6suwyseZ9qu8ql/bhMmtb+dAzuYdWADjSYTuBKbISpub58XYpaOxXm0O+el0L4Ztjgoov7JkZgWW9O0pzbaoBpctMdyoO+qxPM85dO0hKZI3OKvfp8w95XKSluQI8AJijVQhKd8BFU4Desg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PfCt2W+L6TFotc+w5A/DhUg1S1NlzNG39fvQGxoJhnc=;
 b=jUPMNMHzuGt8AdmKxUIfhkLidIZvm7zY1AxhGRcREFxqBVshE+GvrUGkEnaLeSPM8onztAqZkSK/h4bADxSEct4E+dU6jWKxzyMWfPlAItRDxmXodii5p7vcMMJEeXRcn3GCAjxqiosHcJGDIidDBfJkQOJWExbB0sCl4h0n3u4=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by MN6PR10MB7421.namprd10.prod.outlook.com (2603:10b6:208:46e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Thu, 25 May
 2023 15:43:54 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6433.015; Thu, 25 May 2023
 15:43:54 +0000
Message-ID: <8c843c3a-1ea9-9e6f-3206-bbd98d097593@oracle.com>
Date:   Thu, 25 May 2023 10:43:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 1/3] vhost-scsi: Fix alignment handling with windows
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
References: <20230524233407.41432-1-michael.christie@oracle.com>
 <20230524233407.41432-2-michael.christie@oracle.com>
 <20230525034741-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230525034741-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR07CA0014.namprd07.prod.outlook.com
 (2603:10b6:5:3af::17) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|MN6PR10MB7421:EE_
X-MS-Office365-Filtering-Correlation-Id: 9332a1a5-ef3f-4235-7431-08db5d36d863
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yx5Zakbml0dsPHhdJ/lni7ckepmeDKiOxHhfz3k8fsSE/rr5BulKSZQkS5oSBqlqddQNyEX3BOlkt97nOmXyYk9fMSRxlG/kwdikpp/fxlV3yFbUey1IA8IawOD1Y9uChZyb6F43LLIXqdR9zVj7VGr537LYSo+LE6GRO45tpjL4dpvWlQQ4HnAwFsN+AXMZpe2KRIBu17j4jXbp4vJG0ibM8CEtIiiSKwu/4wAmc8eTjruFulhr1qdf2gbb37cRCniqeccL15C9i7CaQvt5Fm++Nag8LpBV65SlBchNFjKYemcyt1IIxj1nX5IvLVT6MbvBvAxLvBFXG8IY8TGmYCKBjLkKhk/szR+JElfKP0GHt9BExV5BQbxy+5/h30LYvT3yhOxj3hIyLguc9jmVmM4n8OXReU9yqq/x4vGcuUvK3rqPAzxc2pJW9wykbFcSvSIPL6lLzF75iRXAQ31djcJmcXG0P+NB2nEkm3wTwhQyQNcJ087sxTOy4PQU3bkr9Cj7mcmkbZi5wyzvtE4+YVVKckZ+yUyPI8hTv38bnrH6qc/2GMxupfsDXkCy5ZaYXvTSMdPg4W/RqwXCctj+0nQ8amTeuJenYZURp5xk6qpZyBjCk7X1eneEogXbf0Jp/XXAFHzGjucLukBdoWquNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199021)(4326008)(36756003)(53546011)(86362001)(6506007)(8676002)(8936002)(41300700001)(6512007)(186003)(26005)(2616005)(83380400001)(5660300002)(316002)(66476007)(66556008)(478600001)(6916009)(66946007)(6486002)(31696002)(38100700002)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3phREk1b3JpRnZNVkx6NjV3RjE3NlErdUFsVkhmbC91MDVsRjIreEk2d0J3?=
 =?utf-8?B?RWNwYVhqN0I2Q242SnZJQXBiWk9jQjY5Mk9xZ1lvczk0Sm9ydWw2TUVNK1pL?=
 =?utf-8?B?cnVCa0xJU1hqWlJlOFZoWnNWTGtiT0lkYkxqYUFoVEJIV0JaKzQzaStJNWNP?=
 =?utf-8?B?QnlpL1JxaXVIU3JyektKY3o0eGExbEgvY3hhUG8xS1IyR21KUzIwTERUaW0v?=
 =?utf-8?B?M1BBeDFWaVJzMmx5T3RITitySnRIeVVUK2dZL2U3SHJDandxRlN1dHllcGF4?=
 =?utf-8?B?Skc2akplK2FjdmJxdWVPUjZTSURWbVVMcFQ5MCszNVlUUUxyR2FKeFUxQ2dB?=
 =?utf-8?B?RzlKTkJ1SUptVnJlYXhaZHJ5MFdoMWcyNmVXMVIvUkdXYyt4M1NIc3dvMi9a?=
 =?utf-8?B?ckxvOG5QeWtLcVBTc3RqaG5JVlJQM2xnb3pTd09VT2pVV0tINTZMdS9ESURM?=
 =?utf-8?B?aURNUGl1aHZjcGkwNTBkWDRsZ0Q1ZFN2Z2VVZWpkTGd0cTRWTnZwRzNDa3Zz?=
 =?utf-8?B?R1d3V0VFUzJlQWl6SHg1TWVJbjYxcC90NHRTWUtBbDJUWDRwUWNqZEZackF6?=
 =?utf-8?B?d09JVXFEY2FycEY2MWdIVE53UFA3QkkvK09SaS9uNEdZR2pzUk9PNzhhdHIx?=
 =?utf-8?B?SCtBZWlKZWVOeDJzWUEwUmZ3UGdrc3FmeDFxM1AvaS83RWVrdEsvUmdsSjNn?=
 =?utf-8?B?bWdNMkN5bFFQQ1pHdHdzVzg4ZnFRS1c3WGtCU05pYVV5YnlWa2hlM1p2MmtC?=
 =?utf-8?B?WXd4SXRnMmxLSkJDV0dnUVloajlRWUtYTzVGcFV1b1lGQmYvekxrVnZiOW9H?=
 =?utf-8?B?Q0NRd3ErSWJ2ZTlqRlQwNUhPQk9QaFgxdEpZSEl6RktLSHY5aXAvaUNnNmlE?=
 =?utf-8?B?MnRKR3RnNUxhMk13UmxyYmt4ZlNOZWNvL0U5cEFnUUoyVVJKUURiYldYLzdu?=
 =?utf-8?B?WldrOHJ4dXd4aFVUbXdocE9ySlhRMHoxekRyc3FUVXFwaTdadnloaSt3VHNh?=
 =?utf-8?B?b09DeGx3c29iZ1JWaFZJQVkxb1NNQzMyT0Q0K3F4bW9TZkU1bUdOTTY5MEdM?=
 =?utf-8?B?MmQyQkFvSUswYXB1VnhKZ2cxb0paK0IwRXBDTWI0dGJ3TFlJb1I2OVJvdnJn?=
 =?utf-8?B?U2h0OWtSUFYwWHo5bFE3cXBaVHppMS9TNlRvbkVFWHBFc00xMzhobjFlYXBJ?=
 =?utf-8?B?UTM3MTBKVHIxWTB3Y1dtY0dKbmpmdnRDRDNwUnRKMUR4bHR2U0hjMFZWZ2Z6?=
 =?utf-8?B?Y3JrNlZ1Nys3VXBzeW94bGhhUnorZGpOOWlSTnBtYXl0VFVtc1JOS0FQWFd2?=
 =?utf-8?B?MXU3cERiRXJEUUNzelRGZXVHNXBDaTBDUzkyUk9zOTRYci9vU2Rwdkl1QUdH?=
 =?utf-8?B?L0cyOXBWTlJ1N2c3bUQwTzFTbGZVbG1welF6K0xVWXgwWGdNczl3Rm03blcx?=
 =?utf-8?B?Vzd2SUczSUlDSGF6NGQrUGlmU1dIbFNUc3NQU2xqakJNSklpQmFEWEJNUXlD?=
 =?utf-8?B?YlphMEUwY0h4Wkk5U3o5WUdINGJKdzB2aXpJNlVHNHlkbU51YmZzcHltaHFy?=
 =?utf-8?B?dHBWN1pQbVBwd2JSd0ZPeWVTVVhGVFNOWXRwUkkzWUFYclVPZGl1RCsyeER4?=
 =?utf-8?B?aWRzWWgrZUo0TmNDb2pBcGRtdUM2eEJiQzNHTnRUVm9FMXdvYmRyU08zVkdl?=
 =?utf-8?B?YVFycnJSODlmR0k4TWx6UUM3eFp5eHpBQ0hrRy9vODREM2kxZ1RvSFo1MC9i?=
 =?utf-8?B?WnJvb3M5Q2k4YmFuUDRaRDlRK3ROVkNZVFZCc1JsdjNYQnFMKytWWTlPcllF?=
 =?utf-8?B?Q1dRd2tzSFNpOGpWcThtazVmQTZQS3Y4TnNVYTVIUmJRSC95WnNqdjBZdllw?=
 =?utf-8?B?VDVMdm1Xc0dnWjk2Mnowam01STNaSVBoRzlIZ1pWQTUwajNrUTJncWdtUnVC?=
 =?utf-8?B?eWRqMHBPbGFLQWREaUh5ZzlZZDFCanhScTJkT2xuaVNSRjhQT3RpNU8zQ1RI?=
 =?utf-8?B?TFBkc2lEZkpsTXFMekYxYmFOdk1VaHlvMGdia0NaUGVRQ1lSOGk4ampKTmRj?=
 =?utf-8?B?ZXVIYUVSR0p2bVYyUGdaSWpwam5ZZVhiazVINlRaS0thU0E4YWxHVkV5VHlw?=
 =?utf-8?B?S1hncEE2bXE0UzBlR3kzMmpJekEvTjdwQkMvbG53Q2RlRzl5SXhicjlkS1lF?=
 =?utf-8?B?Z0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: s5fmY8bcNpDXcZgN0TXtRs5g9ol/88D0Gkq+hHVTEs5C3S0uWjno1Jl+58EzJSaQ1t5B5wp+Q9YHpJJHTamC18xiI05W2CK0hV8nfMDjuztXC+Yg//YVZTUHFBQAzmAeIBCtlay8ecdUjkfgSpBVBxToPIR6mrkoehf7JXUpMCFIvBIe32gu/2l5Qx5hUPJBgkTOWpLmqRBluTPIse3QxZw3PHx3IY7O5pOVZWzmMefYNVyncPYUMIhFNCzOZkdEN3PG8Lw7jkNyNjCCXNAIgdDmn0x1PDqx/N0VZO54aq/ct33L2wg3Wzoh+K2xwSiGWU1li0JNA5/AAZ9EaptUo+8qAWGaMlF/pYyiVtb9CyqHLWVq9LjBNY6W5aZOpfvYFGb/PYrSk0XmM1FSiwLZ8k0kc8EBPz6WtQw/kZLDNScDymltz7a9/1HJJ8BsuccG7ZkBvqTlaYvz9mhwSHa8Y/4z8SurU+LJfQPZ/H6OuYK+Bjruh2JC9lWUznHQRfpk92FXDGjP9bj2VSAjxFEhh/XJzttRu5KA1GJebVaZGn705EgGofxVDSbAhQIupNqQWS3yWmYk0odOOEYIJ0zRAPXadTwqNiVdpjSnu7Xk0lSx0H1K4Ril+fvdTzdsX+xYaKP90XvIj1Rqu3aFwZlJk6Qn1uXDJIkDM1l87XLZaXiocHM4uMrxalaIVdLrjVlS/0O2pEO2k95YtvCpU2yeLV2UovTLv4Q1WLbRJ/Pzn7AimwP53wihT5ru345Eqi9BKnMqaT3g6mbOd1x/5e7BagR/QVS/XhG+X3hx9CspJlcdTgATq19DHAjVvg3rbiu+4PdB6rabv+rVSzLpMWxjPluLzDPUC/Ha13gcCfJOVi4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9332a1a5-ef3f-4235-7431-08db5d36d863
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 15:43:54.5062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wsgEmZOPwPCZgKoGz1ZgwzzXAUCF+HYRjNLTe0HYNO3L/geulK0Qb9PI23IaXj3gst0v7Lh1bfK/myeiiUoa5oPmH78mkXyDH+WldvCl4vk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7421
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-25_08,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305250130
X-Proofpoint-ORIG-GUID: 9voagsyqFPSHYi8u8skO1lun6jca7ang
X-Proofpoint-GUID: 9voagsyqFPSHYi8u8skO1lun6jca7ang
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/25/23 2:57 AM, Michael S. Tsirkin wrote:
> On Wed, May 24, 2023 at 06:34:05PM -0500, Mike Christie wrote:
>> The linux block layer requires bios/requests to have lengths with a 512
>> byte alignment. Some drivers/layers like dm-crypt and the directi IO code
>> will test for it and just fail. Other drivers like SCSI just assume the
>> requirement is met and will end up in infinte retry loops. The problem
>> for drivers like SCSI is that it uses functions like blk_rq_cur_sectors
>> and blk_rq_sectors which divide the request's length by 512. If there's
>> lefovers then it just gets dropped. But other code in the block/scsi
>> layer may use blk_rq_bytes/blk_rq_cur_bytes and end up thinking there is
>> still data left and try to retry the cmd. We can then end up getting
>> stuck in retry loops where part of the block/scsi thinks there is data
>> left, but other parts think we want to do IOs of zero length.
>>
>> Linux will always check for alignment, but windows will not. When
>> vhost-scsi then translates the iovec it gets from a windows guest to a
>> scatterlist, we can end up with sg items where the sg->length is not
>> divisible by 512 due to the misaligned offset:
>>
>> sg[0].offset = 255;
>> sg[0].length = 3841;
>> sg...
>> sg[N].offset = 0;
>> sg[N].length = 255;
>>
>> When the lio backends then convert the SG to bios or other iovecs, we
>> end up sending them with the same misaligned values and can hit the
>> issues above.
>>
>> This just has us drop down to allocating a temp page and copying the data
>> when this happens. Because this adds a check that needs to loop over the
>> iovec in the main IO path, this patch adds an attribute that can be turned
>> on for just windows.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> 
> I am assuming this triggers rarely, yes?
> 
> If so I would like to find a way to avoid setting an attribute.
> 
> I am guessing the main cost is an extra scan of iov.

The scan and a memory allocation to dup the iter. However, I see
iov_iter_revert and I think that might be what I needed before to
avoid the mem alloc so will try it out.


> vhost_scsi_iov_to_sgl already does a scan, how about changing
> it to fail if misaligned?
> We can then detect the relevant error code and try with a copy.
> 
