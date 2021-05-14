Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F64C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 20:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 533976121E
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 20:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhENUSI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 16:18:08 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:53508 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbhENUSH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 16:18:07 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14EKBHoZ023557;
        Fri, 14 May 2021 20:16:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=d22CFXVj6Po/b/UjLi2Sd6YD+FtmUwsAmc3ozRSPmoU=;
 b=KW8P1h4KbZJ8QZ6wy5Z9ws86s+3uzYtkON4TJS9ZsWCZmvlkMgbkCD7gkbHSkCASXUHY
 1f81Vm75rGReND6PJTiB5v7bvLOLZ8Odv6UBB/tH2P8hc8H/Ar5xBG82UYAg3mLSKejT
 GWbGyQeZA25LMGBtesSeILukOtvPcrHyxDaxCGRPjoYLAGAJaxIy4/9ygKflGQstFGw+
 AkPyUsEq1ZTDrqQc/S2ceC34ur7VQABcAkoy6DkLU/y+vOupaXqlZjT2HiXn8eTKN/f2
 5Lb3ejZPZXRPUkHj+RTNduij5FWegj14tnM105Hts4lgjaQv1pLB/c0XDOhELjCpDiMD BA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38gpnen97j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 May 2021 20:16:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14EKEsl3141482;
        Fri, 14 May 2021 20:16:46 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by aserp3020.oracle.com with ESMTP id 38gppf8v4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 May 2021 20:16:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N3z2YyoA8ZUUtCdZ77V8lN/HFW1qfCS+u44IQvWUNJsefq2aF5jFYNH3nGz0/mBtwQETPvj47cPvYPXywaasA80uRcYTcsjjzS8q7cWOdJg8j7SbvLmwzN59EyC5MuFW2x7O776wIi/SA+Gwh4PsJ8pHY+o2O4ffYt2cYnXaYgMZe4jNwkL/LBiqQbSc3rUxtrdCoWsgKqPQKdze/TWuZ9FlhyZvxV0/e4HFfHsH5oMPy0Yt+sFIqhLQ2y4qeR1wKTnXS+/KaeHzq98SOXemHmt16Mb2g3MhTqvahdAE51S6xaEtgZOOleQKWd31ufVEZPqKZJVZSpFaP1oFpm303w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d22CFXVj6Po/b/UjLi2Sd6YD+FtmUwsAmc3ozRSPmoU=;
 b=hg5V9415JX+ZNTpsLthAQCe5ZHQ6JuPKvadoYpqpkvDAbC/1uGYzCmIIChTl6vfATSYZHbqlMNnBnif4Q396Zta9tPLDbgD0xTSzXOBkOFuIHUoVcXTvahBhleeACjhcHiKXF/Y+RIpeiJjQ3vwd4djlo8XkmFmi6RDVsAeT9IalTtWT3f+MEnHMvnIz7kEkxBjEct/M26vnCJB2PoFuFFuoz861zl9y+pk35Hb04sx1Rs3IclMkfc5QSH69kJQ8stpeoG7bHjAkIlD4d+RWcbU7gUjKMFXc2uDorbuzgIIXEq++fVCV+vJ19KRHAAt747ZlmqW8Cf+Npc7CO2VsaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d22CFXVj6Po/b/UjLi2Sd6YD+FtmUwsAmc3ozRSPmoU=;
 b=TkYCPgYlMTM5p7rg8tf/q8vClIPud9dDJqE7uRJ0jMtIYwN0QFuLzu5JDKXg0V3XRZli2Asgw8B0EnulRCLyd4zFljsVoC0rKAf7KAMvSeHq3MvL1EgfjqiZkv/gNHqRtVhnKO5nUnlRUNMR6Qm68yb60asCQf4jg1MLpZe1Few=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4524.namprd10.prod.outlook.com (2603:10b6:806:118::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 14 May
 2021 20:16:44 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4129.025; Fri, 14 May 2021
 20:16:44 +0000
Subject: Re: [PATCH v5 02/24] mpi3mr: base driver code
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com,
        bvanassche@acm.org, hare@suse.de, thenzl@redhat.com
References: <20210513083608.2243297-1-kashyap.desai@broadcom.com>
 <20210513083608.2243297-3-kashyap.desai@broadcom.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <351f8f47-6fe8-1fc6-6e4a-1a23ad0d53b3@oracle.com>
Date:   Fri, 14 May 2021 15:16:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210513083608.2243297-3-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8004:44::22]
X-ClientProxiedBy: BYAPR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:40::14) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:2001:93:8000::3dd] (2606:b400:8004:44::22) by BYAPR04CA0001.namprd04.prod.outlook.com (2603:10b6:a03:40::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Fri, 14 May 2021 20:16:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4668d41e-caa3-4b75-99bb-08d917153198
X-MS-TrafficTypeDiagnostic: SA2PR10MB4524:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB4524672777DD384470EEF2D1E6509@SA2PR10MB4524.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:514;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VUn3cnQHbCEn7yyO7/JTyk86zWN4QGLiBmErmyrp041aozwMxg/UPnNNMoiSjqvM23brF47FWOHIQUpokOYfM0cxYH+DDk3aG6T4A5JfV4hgy8GuZeSmBnu+SEwAYV66TB61cZqAE2oiBgoHOlWovpVz5agFB9kJMHg1KlBudPrRrNtnNXEcpkpnROoKvH7hZt7IWsKDoRZPbRhGox87RpbDr3LfVGmZTZlhG3vrFaGst1qu9f3rchiSH/gXx4rNNUYts/kgxuXWz/i4F9dVUqC8wq43jfj62W9Tc83iKg0c92ec1sn8p51XRiTU0P7MebNUdHpugHUNhl/6RWcW/YTU6R2iBaCI1fV9rep7Qi1xtbTTZ5dbDbUvu6cu7gX0xr3gCRfwiQKfWdvzYioz4JMNrCpW8Y4zOOzdunkUXF4MdoYfhsHEbQRNRT6AJvWeBgyNCr4xJf+jIzYL/zcS0klYYF3ift7WTIq76HYLexSBEeyW7jMh8FFGqdakMiqg8RKIz0sNQO67wcFj5vsLCFHXt8HzN9LYDkySXMQVTK/PNbxUdia3C5lXvuYfIBvb4yRJi02HCRmciFyzAnbqRH5IjUCsdXhSmit8m064dL9gpeWqQUcbMKaVuxgiddVSUrBpfg815SK6AoEdWi/CwIXjUN/7UjCUQM/txu+JIWEw+8f+ejm2TKgqOBMeYrJY/Kzg1QrEojastahCQdF3Ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(39860400002)(376002)(396003)(36756003)(31696002)(8676002)(86362001)(316002)(186003)(8936002)(4744005)(16526019)(53546011)(478600001)(7416002)(36916002)(38100700002)(66946007)(66476007)(5660300002)(2906002)(31686004)(4326008)(66556008)(2616005)(6666004)(44832011)(6486002)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cGVpYTJucEsvVUpCanlZOFhUN1o3OGN6MzdldlZGRStTbVNhOTBKeWtlZXgx?=
 =?utf-8?B?VTB2VUxlazE1azZzVlV0ZGUzK0wvTEdITU1rWXk0Q3NKYUhQZzhFY3dxNThx?=
 =?utf-8?B?VmNNS21GSWlFQXhoNHFGUm1TSGVOMTh3c1psTUZDekM0OXhBNzZ3OEtMRFYw?=
 =?utf-8?B?dUlYZFRCNVRWbzFKenpGejhnUSt3U3MxcllHbEdKOVNoL2VGWEIwVVZZUTMy?=
 =?utf-8?B?Mmh6c3BiOWh1dHhENUFpa091UnVWNUlxMHRoNUVEYkdWbXJoK0hZWkJZbGlO?=
 =?utf-8?B?UW5mNGJkK3BpQUZCNXU1Ti84dGZBa056SVI5Zm01TmowN3d2WktIaVh0dHNs?=
 =?utf-8?B?QTY4VkZ0RGJBZVFkT2ZLbVdyRHMwUWtCeURIbk5wVTlmeXVZaSsrQjhOYS9z?=
 =?utf-8?B?VFpKaXFXTW5JcGQ0UjFPdHJyN24wakNXU0s2Wkg5Z2ZQRVo3OHNidlBmT0Iw?=
 =?utf-8?B?MVBJelNtRmM5WjRXT0ppa3Z0bnpSL1R1Z1NiVjdLSHJYT2wyTVhFNEVpYTlU?=
 =?utf-8?B?bHpyS2gyTytjZncxbnVNdFZ2aE5OdE9oRzJYZGtBY2NSUDVYMFU5ckM5Z0Vs?=
 =?utf-8?B?SElITFJaZ1ltZUhldkhlU1VlWFVMalZzMHVOWHRaVzZJMFljaHlJREpxazNT?=
 =?utf-8?B?a1VId0JXcWVZWHZKMFZnY0NWQzVUWTNBUmFOZGc0bWY5WFM1b0xoT25saFJD?=
 =?utf-8?B?MGw0aXBHYWFycUM2OHo1K0xRTjhVdHRWYXdEU2lieEpsSlVxRzE2R1FVN2JN?=
 =?utf-8?B?dkdQT0xhcTZ0RnRxL0JNWFVRUUMxU3FSb2RnVzZmcWVtZmU1OXZrdlpqa1ht?=
 =?utf-8?B?TUx5OWsvb2JBMW83blBNZG5nN1lQT2lQVndaMTRWNHgyQU5uclBKeUwxYUpV?=
 =?utf-8?B?T0xyei9yMmRHeDFGbnBJUlgvNzRCTWJhbEJzSWdtMk1rR3JSUUdPTEF5Q0Iv?=
 =?utf-8?B?bjJ6RldTUHFINGs5OFZkekpoRVZ0T0g5THVwMnVidUhjMVMzZlhPeFJPUDd4?=
 =?utf-8?B?elFBOXo5RUp5YjUzMExlWC9nQjMrKzdFbmE3aUppU3hxV1M4MDJCSEs0YlBK?=
 =?utf-8?B?UUp3V2RjMWxIMm5IcUlMemZKVnJSRmpJWHZqdE8ra2IweFhSdUkwajlHZlQr?=
 =?utf-8?B?VGdQczNtSVlXeGRxdHFZUVhXZnMzU3p0NWNmZUZTMHpzcWhOTVBFNVJFalRK?=
 =?utf-8?B?aWl3aHk0U012dTZNYjZJenQveW5Od2dCMmhTdjNwMUtvaU1ya1RVZGwwMmJz?=
 =?utf-8?B?R1hIVUdDSGlMdHZHclgySWw2dEIyRG96VVkrOXhCdkkvWUs3QWVoT1VHNWdy?=
 =?utf-8?B?MkJCd0p2dTBDNXA1OElGMVJaK0MrZEZMY01Ja1AzV1B0bnp3MUVJMW0wMTVN?=
 =?utf-8?B?L0cxRVc1L2tubGc5a0pFTWRLcUtBV2NmMUtjWjJXNVNFV3JXYVprSVdnNDNr?=
 =?utf-8?B?YWFsNmFXZmxnS3NYR0R4bjVYeFJvQ25Uei9SUHpZdHgwVER5UDZJTjZCZGwr?=
 =?utf-8?B?VmhhZkRpdE9xK3JweFhhVFloVVh0NG1ocStCZ0o1VXFWYk1MaXR1WGhNdlBD?=
 =?utf-8?B?ZXZETXNnaUtCU3JsQ2Jpc3pTRnU1RkEva3ZCL1E3TUo3OTJWRVRmTEhzM09F?=
 =?utf-8?B?NGxSUWhpenh0eU1JTXpDQ1lFNkFoeCs0NWFJQ2FyVWZGWDdEUlNzeVpzYUZt?=
 =?utf-8?B?cUxtT0V2aG1OYTcvUkZDOG9hMGxmaWdtaTFlS3VOR1Q4U0NWbzZMeGZqaGZW?=
 =?utf-8?B?T3dMUTBFWWQ4NFA0cjAwQUZ1TE00SEorS2lMVWZIUjd3OUU4OXh0SGtBVy9D?=
 =?utf-8?B?WGpNOWNlUDl2TU9WK25nQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4668d41e-caa3-4b75-99bb-08d917153198
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2021 20:16:44.4991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rZzZkAFjNJ9tmuOMP6UXF5eCpoQyh3HAnLF0yopd/j8VrS0LbfZDyvjn1ZXr+JpsKA5A1FmiWKP1PNH0HEWzHtW3VP41TPbiiVeAu1a3psc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4524
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105140161
X-Proofpoint-GUID: YZkdk9JVmOjR2Yy-uykQ0TfLsgVYimx8
X-Proofpoint-ORIG-GUID: YZkdk9JVmOjR2Yy-uykQ0TfLsgVYimx8
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105140160
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 5/13/21 3:35 AM, Kashyap Desai wrote:
> This patch covers basic pci device driver requirements -
> device probe, memory allocation, mapping system registers,
> allocate irq lines etc.
>
> Source is managed in mainly three different files.
>
> mpi3mr_fw.c -	Keep common code which interact with underlying fw/hw.
> mpi3mr_os.c -	Keep common code which interact with scsi midlayer.
> mpi3mr_app.c -	Keep common code which interact with application/ioctl.
> 		This is currently work in progress.
>
> Signed-off-by: Kashyap Desai<kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke<hare@suse.de>
> Cc:sathya.prakash@broadcom.com
> Cc:bvanassche@acm.org
> Cc:hare@suse.de
> Cc:thenzl@redhat.com
> Cc:himanshu.madhani@oracle.com

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

