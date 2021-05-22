Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 691BBC2B9F2
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DAFF6135A
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhEVEmY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 00:42:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57832 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbhEVEmW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 00:42:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4eqTK070352;
        Sat, 22 May 2021 04:40:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=hLDMP1gqZcFltFH60QnbK6E3J7lGdnEiAS28Kzw373M=;
 b=OnUtXSZCnCB+hXsuWehMvbgUvOkAnG1h/meukqPC1U9NkXEzFlyhhxQeZiOxVDWxr4+K
 aG873PTxl0CtuAmTf86hOIefvIDeveeR0YUjRiWI8sKnk+lSZH1nhlAtUyA2t9uH0Xs+
 kovU8CdZ7V9UGxHWui8zJh/WpiI5OVEaGdky213zAzFSXQmKEnLn9IZQVFW4ukoxAhEH
 3hJwt6k6k3DMWEXpkMUeK+0S3KiU1btI8MoRLgzk3zR8QYJVjdKAstcyWhV1FdVPZ65r
 k4XaDSStOPFGWBZYiWgjj/T2PuH4biZfWce0DodK+RZChCT9fpDXwDt3cwUVdbzs9tNL NA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 38pswn818h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:40:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4aljJ072530;
        Sat, 22 May 2021 04:40:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3030.oracle.com with ESMTP id 38pq2rp5bv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:40:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7XjxmttZTIDSAN0vJYQKNwAy0/VAOY/biSRoVRz7v/NUoH5caOhKuCvl2NP0X218Df5WF3yG78CXetZPXoVCEPEAuLOUKUaRc2usxMxe3PKR8ZoV8vj1YWkrIkRBKRo1bdmSzYY+37FOvelVpCD+MoM62rWEi8qbQBXkmn+JE7NJIAP2+QbUsMwFLyIe/lmm81sgiajwn/GBxTHK/UbngdULmLVkTPUsw7P4dFNbPBtv15CB2WZ5YkelYAkxDu3OPU4pWoT2hFYXGNVchOlTtb1/dK95y5GNPmNQkQkjljY0lpZvqhYU4dhhEUL3lcxZ02++GWFC6lM6tghpz5iXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLDMP1gqZcFltFH60QnbK6E3J7lGdnEiAS28Kzw373M=;
 b=EcpMZewX/xi1vn5r1Jy40XPWUMLup+NrAi08s0k/m0FgATLM+/h4FmEAYldPWrubzuz38igwmmGDjsMkWgZqt3G6FPh5r3HaGgLt0NhIwXXVlDSyfarv3ggaVMHrDFPtLNM6M4z4irCsTiz4bC2pEtXBYPmhjeQ3uieI3hSXj9Wsu9AZknKh/yJy/YC6kdeDx3LBgeuC1fmtMyXkYok2yShepyu+oVQ10Ud3qeMF67/dfLvET24e6pWkgpj+gJALMSyEOqBRpLKHoI4baJcc8lY6bafut09VpGX77nbA9bURMlnDNaPPJkIR9pgZA+YK82khytAXUzVwe2A8+aEs/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLDMP1gqZcFltFH60QnbK6E3J7lGdnEiAS28Kzw373M=;
 b=g+p/E5FBSi3ZhaGAQTGfwmEJeb0MsMcWjmFZZ+s3VdPda8+sB4CZd1Dm2lmKIAHVyXLkWkGbNL44SeFcf2e51bTMk46/C6z1U2QsRizUUw+9xYaIj7MzuvgyWGxwGc8gArjxs6kRc4zpv34pFSkAJ29wZH787dorKOxD6iycPNo=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5481.namprd10.prod.outlook.com (2603:10b6:510:ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Sat, 22 May
 2021 04:40:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 04:40:48 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     hare@suse.com, jejb@linux.ibm.com, trix@redhat.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: aic7xxx: restore several defines for aix7xxx firmware build
Date:   Sat, 22 May 2021 00:40:36 -0400
Message-Id: <162165838887.5676.2613667259013259668.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517132451.1832233-1-trix@redhat.com>
References: <20210517132451.1832233-1-trix@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0201CA0038.namprd02.prod.outlook.com
 (2603:10b6:803:2e::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0201CA0038.namprd02.prod.outlook.com (2603:10b6:803:2e::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sat, 22 May 2021 04:40:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f8e4875-6545-43fd-10df-08d91cdbc56f
X-MS-TrafficTypeDiagnostic: PH0PR10MB5481:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54818CA5582AA605C490E7108E289@PH0PR10MB5481.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YMxf+YQGvNno4W/fHoHZufD8ZNIAm+vGduMU02L3lo193EKikTEA0JJjypB53in2BW3wIugk3m8XeeQSEfOQpCLXGFRMjJzonKIZLGNcv3Boj0IdxRZhs6qyjLW+cDIVUuoHFfK0gspzcIx8xjWRx9M9tLYUO6zPwVSZx+FRTEin8CxQMylloH1/wyvgwh8iH/MKd9bc2zSmSS5cLRnv4E83Qmr10nhnFnWJwVLmQo1jmh4BeTPBscMUp2Msp/cWu8bfuHJTueN2+iesAmoNVHMGmnvEcnWuYqJKYZIJjru4Eb0NW2dyz520yAMmLmOdd0i0SANaO7sI82CZFhs96pdiSunWFhqn3Z+ATSbvmG/dCNDR30/4ESP5O6ZpGcBzGAo3ZW9P8vz97DIJtLTamjTZvU+O7uLxmB9MF74YtuYx/F86B7DaCPWfp2swWbRnwPEQy7X2UHhyIPGg9lCYGJMM3qDile1TN5vQEgAtF0zzxiJO6BzSi5ji3sgRUjbu0HbaJVA6RNlOjrc4lZTgjjNzYl4nfUp2JUKmNV2NSqDQ34uvfK8BJ4hDvt5ahJmbBzDEhT7c3yGyduysg67q777VG8m+hLNNDecimDjBnii/FUJUKNstoWjrtWwmx0fndxKrSHROi6Zje4YzXmRLpmMAOcn412ZqWb62YHwE6SxJ98raMo8zkei9PDnBtO1chXP/aNsLH1/Dx0BOA7To8Nm+gdo7W9SWsPEya/ib8ONjmGKjYjJHaKeUpAG5FBoZcdbWb5Vey9ygmksuSSMp1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(6486002)(6666004)(52116002)(956004)(4744005)(7696005)(66476007)(16526019)(316002)(186003)(8676002)(38100700002)(38350700002)(66556008)(66946007)(8936002)(5660300002)(2906002)(83380400001)(26005)(103116003)(478600001)(966005)(2616005)(86362001)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V3QxV05lZk5MQWVBZEJkZmVJcW5ieUNKQVFwUHVWTnArbjNVS3FHemZwekt1?=
 =?utf-8?B?elF3NVVYSWdmVHF0SW01ZjRUeVEvK1NJUTM2cFV1SUpyV1ZMVFhBOEhyb3V5?=
 =?utf-8?B?N0MwMFdPOHMxNVh2K2orNGN0SEtiSENucUxxN0FDUGtjam9hc2NjZzYvWDhV?=
 =?utf-8?B?N3NWMlR3WEFIU2xZRWVKb0tBTlhFM1U3WWFoQ3lhSktrOHhGV0NMQXd0T3F5?=
 =?utf-8?B?UTdzdWgvL1BWeHh3U3NuWTVXWEtsMEhWUXYxWURhZ0RLdnZFbGhXRDhYK2p0?=
 =?utf-8?B?VXVpdnh0WUhiR09Zd3ZFK1FWQVNRaFVtQlFtU0JVYXpYV0hyWm1RZmxINmh1?=
 =?utf-8?B?Qkplb3hwcjBpSmRvVWRLMnFyNk1QQWZJMmJCK3J1N1MxaE9wdnJoOXIzRVdJ?=
 =?utf-8?B?a1FBK0NaT0ZiODJ0THpqeHBJYWxiZ2g1TzA2b1ZmUVE4Wng0U2dmK3h4RU9k?=
 =?utf-8?B?bCtZdjEvdU1kbU9hS0RkM3BoeFcwQ0tLVGx0eTFnRDJFV2tySmorRVVDSDB4?=
 =?utf-8?B?S0Nia1NLR1NBamI1MGpDOE82NDFNQlh1VEdZUWFpRTZzQmZSMHZHZE04UEFL?=
 =?utf-8?B?UHJodm01Q0VzK1ErYkcwbElKcVR5bFJEMlZXcVNhYlRQTlB0LzFIOUVnSnJK?=
 =?utf-8?B?V09LSDJORXlLZGpjcU1xUEYzUmE1VmRZMHByY3N1dFo2MUcwY2JMQ1BoSTFh?=
 =?utf-8?B?dlV3RU85eTJYUjF5bEJLQ0paeGZSNTBBdVFoaS9OSWpsbmVWVlpKWFRFQWJm?=
 =?utf-8?B?Y1AxV0ZrbkJrV1IzTWVLMTFVdVBzQitKNloyTzYrWUdxMHJlT21PYnVVeVUr?=
 =?utf-8?B?TENkdDhBVUFUWnFDYkphaHBCK2lCcEh0NStIVXhMRGkrTW5YMTFMREo3WHdW?=
 =?utf-8?B?ZmMxd1BTaU9EWDZMRUpTWmFpTFFPeG50R2VEK3FRVXJ5UElPYlFFdEJTOWFY?=
 =?utf-8?B?aDJ3RGFXMkEwY0I4UHVCN01oaE5XaVNIRDRJZkdBMDdwTFdXNVhxYkcwOHhB?=
 =?utf-8?B?cENyZ1d5Vk5wd1hTWGhUL3ZLdTQyVm9JS1hiVVViWVM4QTkwVEdpSmtZbm93?=
 =?utf-8?B?R3FQZWpuS1cwMGIwU0NjSVhGZW9GdDhJZmwzWExxNDdkSDVSZlU4czMxeWVL?=
 =?utf-8?B?TFBkb3R6eUNjNExtMFV4VmhsOFBSZGdQZnBIR2R2anRQVmZpM3ZJbysrNVFn?=
 =?utf-8?B?Q1BNWDRCZms1anExS0liSHh3Z2JCSnk5TEEvZnhnV2loUEZPRldvSVNleGc2?=
 =?utf-8?B?S0tWRVUrWW5TQmYxS0liYitKOFl0K1pDSDVYaDlvamhBOEdncW1GWHNDTUVk?=
 =?utf-8?B?MGwwNUowclB0akR6a2Q0UXdKYjhmMzJBaWQyb1UvNXpMeXpJSk1sMzZIOEt4?=
 =?utf-8?B?bzNwTThTU2ZPaHRwalNuRUs4ZmMvM1YyRWRoRk9sV0JRRzVUamZyT1ptSmRi?=
 =?utf-8?B?QzEzcFhOZWNBNUl6eDVyOGgvVHZ1TmlOQmxRNGVLYXVoc0xPTzY0UWpKRnIy?=
 =?utf-8?B?ZVplQmdMRG02T054N0diaG9ndEZ3d1kzOUU1eFJySmRFZWhva2JzUTNZMGt6?=
 =?utf-8?B?N1B4RW9QdVRUeThaRVhvZ3N2NjM3QW5hTWU1T1Z0SVExY2hBeGVrNDJub29Z?=
 =?utf-8?B?aDJQUFExMEhFSllyMGt0ZXVLdzNZWGpHVjAxUjZNWFpSZHFjK1hKMG4rblhJ?=
 =?utf-8?B?eFVkZGtRNDZWamhqMVRvTlByZ2dPWXA1aWVaRnB6bllDUS9DbHJLeCtWZUxD?=
 =?utf-8?Q?DYg53TA0KgaR3+FkAlECUFXVZge/+TgSHYfuBCA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f8e4875-6545-43fd-10df-08d91cdbc56f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 04:40:48.7074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8lxSWASYW++kAZ3XRt+7DS11BEKkb5NECx6UWauCK5TcDYIm5amRskHY58iFe6IWqoGS1wyVRCkh8e++P9C+wtWUV3Bh1WMfGHTPcvhKb94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5481
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
X-Proofpoint-GUID: Q1i_bmgi3Mw2VeFLtdiseiUoUqPC-lBs
X-Proofpoint-ORIG-GUID: Q1i_bmgi3Mw2VeFLtdiseiUoUqPC-lBs
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 17 May 2021 06:24:51 -0700, trix@redhat.com wrote:

> With CONFIG_AIC7XXX_BUILD_FIRMWARE, there is this
> representative error
> 
> aicasm: Stopped at file ./drivers/scsi/aic7xxx/aic7xxx.seq,
>   line 271 - Undefined symbol MSG_SIMPLE_Q_TAG referenced
> 
> MSG_SIMPLE_Q_TAG used to be defined in
> drivers/scsi/aic7xxx/scsi_message.h as
>   #define MSG_SIMPLE_Q_TAG	0x20 /* O/O */
> 
> [...]

Applied to 5.13/scsi-fixes, thanks!

[1/1] scsi: aic7xxx: restore several defines for aix7xxx firmware build
      https://git.kernel.org/mkp/scsi/c/7e7606330b16

-- 
Martin K. Petersen	Oracle Linux Engineering
