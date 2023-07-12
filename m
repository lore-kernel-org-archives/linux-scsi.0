Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C09BFEB64DD
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 16:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbjGLQF1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 12:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbjGLQFZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 12:05:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F252F1999;
        Wed, 12 Jul 2023 09:05:24 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CEixwn000426;
        Wed, 12 Jul 2023 16:05:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=+9t9ioog+jSBl+IRgVIVa+uUsoyXaVSo12mqGD1DLXM=;
 b=LmYRFEGW3xT9SztNgxnRGg4C2FfkxChsWRuC0huww39CWzbkzby9zCCK/j1cBSgU6j6I
 QoUrKX8AiI639kr2c5PJshl8ECzJUi0aOHdrxiSha1WLd7nIFGLTMo7mmvoxgufIZlr1
 4PqGCb0GApUQ5W8QsgAIvnKQen+pn3ysocnvYdsxx2C+ScC80h8yDaSl9bw0ftbEUVz5
 sy3l7deBVVRB9yYtixxxTYNFCX42JGhFQ3oJ+YGeZtI2nGUVEckOzjyaC3vtG+neIro5
 R/Mgz6CUvg2RChjrTfNBSAZXzY7mBVeIoSlBJ5ttjXaIW2gX6cxcIQZ5ifJerorsl/7Q kw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rr5h168y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 16:05:17 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36CF9KsE000797;
        Wed, 12 Jul 2023 16:05:16 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rqd2b38b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 16:05:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9RVo90Yx63WDhjNaQWyUsCifLzq2NgxIQiP7TbqoftIdCnl7XFfMHNFd7ZZzdRVLu7lyumSFVtK4wn6yEFTQjidJK1uFmlQpCu9A213FpljGdfiK5qklRgFK3dcijmD/jKmvUIR/d4g0T3whsoDVnaf2OnwXSU5B/aaEPoeOqDyVCwn/Gt8VCxMORzSUXKycFyX3WZvFGK5nwyFXHT/WL+fmhMBIJppOV8ep9lNq7uL8WFmDETKm2QCbuFRwjQj/JxH6ZPqwwUiGnrs55cKljDgCFZMdbCdkejwwQKXqlygaIfoXorg6WW9rpEafEzsnJ7LDncV2lX4gUwbJ3OB4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+9t9ioog+jSBl+IRgVIVa+uUsoyXaVSo12mqGD1DLXM=;
 b=Ni6W/SpLWpZmBm9GcwA8UrBmmNvOg/xkNQyzOHLtRLtM1cPP0Rkv92DpGlyOFnS66T4hZnaMFl6Cx3+ZMAmfIdcN4d8fKUNjJr6ExAiThP5bYG7PdNO/BmNFak49P1pp74RrdAOiLvw6qeZ+cwLuqHEDVDTMNC1FpnV6/ymqPqDj70Pl95rQIavmSpyL9Y5aJgJV3ZCgu7exUyeemfkPFIyikvNhwv5SUz42RlmV/D9B8VwwM45Q1RtPDX5gUlOVzNg02UpPrulZUlQnLnePBRiCa73c8PY9FT9yKttN1SyHfFqCaRblm8kDse1czEd8IUax/pUAWmKV19phqMsFhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+9t9ioog+jSBl+IRgVIVa+uUsoyXaVSo12mqGD1DLXM=;
 b=KlYXKMfHCiO0GhAeQ/8NOpUy8oeQ/f7qQO+OapwTzfhsQ4Vfx0hVgEXZ5eL1Ni22jiEfqjTSncuJsdCRXojzBzjmhhrdpQDULL9ubAOtDQCKDtXY6DAzq0p4lzsuLafYRCjQehgTFZPK16QJ2T77cZZM+K6dezTVF5/oWwi24MA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by PH0PR10MB4408.namprd10.prod.outlook.com (2603:10b6:510:39::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Wed, 12 Jul
 2023 16:05:13 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.022; Wed, 12 Jul 2023
 16:05:13 +0000
Message-ID: <41d2d3aa-b537-686a-f2b4-1e0a861cebc8@oracle.com>
Date:   Wed, 12 Jul 2023 11:05:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 0/2] vhost-scsi: Fix IO hangs when using windows
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@redhat.com>, vrozenfe@redhat.com,
        yvugenfi@redhat.com, mdean@redhat.com
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
References: <20230709202859.138387-1-michael.christie@oracle.com>
 <20230711183438.GA154686@fedora>
 <6b53b833-3c71-2bd9-8fd8-757ecda75c53@oracle.com>
 <20230712142656.GB215287@fedora>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230712142656.GB215287@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR08CA0002.namprd08.prod.outlook.com
 (2603:10b6:5:80::15) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|PH0PR10MB4408:EE_
X-MS-Office365-Filtering-Correlation-Id: 85283895-4122-4459-bebb-08db82f1c66f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AM2bApAsAXQV9fiJfoB+k71dqh6vwsg7i6BOnuercVFj3TjgjLFBrcuNfiy/oxAXguqgXZxPpcWFJOdhfSdo6kZus7LL6uXF1qy1UhSNNNEFd2Ef6WuhMpo7qD39a1u6OGBI4oWSY7FZhqDGVCtV4SCcwvDwq3YGzhZ6zI/d4pGt2Y9/Opd7WmqKtBiO56EttVaoy92IvsULZwMf3VWx9l8rXGXalzLE+IM3xdTZ55rhu0HYSZTuBTsRsFezVYAjQ6rgVVcuov6EFcdT/8ySvHRDC2HeWpLVAG65LsDIN74Nqv5tEgMLWAUjHLdGzWLYTFP+wA4yNalZeuM4idThS6jbZAIphXT7XbVqy3/deIvivaoVG28Z7lFehdYKdUSRuiZxJ6kPzIsMysBSNmW1Laf7Y5PO0SmlgeVAsf9gJjRekWAdKAQ6iifOYDqr8Zr1Znxm+dg8+7/iX1go1fwRjzHE2tILGaWYV7vsGCiYiuAeRvrinmINLIMJDbaSrnE2EfN1VpssWDaAzE+OyikrRx0gfB9E6D/cXbYv12DB8eS3tOxUnk3tEwMnuREgfTiMAy5ZraH638pSkMAZ6t5fBR8+2cO2iV8l+1EWbEMFm3r3E2UwmHyEviYry92ZYfx2I8B6XAH44h4bLRYHnf/37g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199021)(41300700001)(2906002)(31686004)(7416002)(8936002)(8676002)(316002)(5660300002)(66556008)(66476007)(4326008)(66946007)(53546011)(26005)(6506007)(86362001)(38100700002)(31696002)(6512007)(83380400001)(966005)(6486002)(2616005)(478600001)(36756003)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ym9LMDgra01IWHQrRWdaWVRsMXZHWW9RWFBWazZ2K0ZDNk13WExXRGFhVVhl?=
 =?utf-8?B?M0svODI0d0IxQ0VHVUtscFdlVEdXUTc3M1pzOE9QVHBpaWc2dWJKN1l2dHRq?=
 =?utf-8?B?OGlaZTk3WmMxQ0VVMzhHRTBEb0VncGE0Vkk4TDAvRmQ3Uk9Cc0UrcjdWbVhi?=
 =?utf-8?B?NGtkOXowU0ExM3JidVpzcGNCdGNqanVrbU9QM3BNZkF3QS83VVVJdmpFclJS?=
 =?utf-8?B?UTJ4T0ZqYTc2ZkI5eU9tMVlsRlNWbzYzVHUyU3V3M09mVWx1cStkTnFvOTZ0?=
 =?utf-8?B?L1JVOFFteDJPNWxacEVBOEJsdFZEUnlOdHJpb1d1L3ROUFZGbCtRMkxIRlpO?=
 =?utf-8?B?aXVWU1hiM3k4VkRSQnk1VzVPMHpKYUU0SHJNc0VvMG5UZHh3MlRZOS9mNmRr?=
 =?utf-8?B?ekVLcFFXRzFxNWIyS1ViTmVBaCtjVm5zR0xsNUJxUjNwK1YwUjQ3MVpXaEN2?=
 =?utf-8?B?YWVFRUZHU0Y1M2wwRDF6SlhYK0VkYm51Tmd1WnNySlB2enN1UEc5eWxvRHgx?=
 =?utf-8?B?enpWV1VlTXlVSmJIdmxuZkYremVTQ1RmM0drNmFyanhzRldHOFRxZXdBalVz?=
 =?utf-8?B?R25YeUk4eno1S25pdDV2ZEMxa1NuVEZOWXdBNVJSUWtuT1BPbHVuSkl6Zkht?=
 =?utf-8?B?VGdZSmpLb0dsZDJBUUYrTms2Y01EbVpHV0tieTdzR2I3V25EY0kwMW5ycDhw?=
 =?utf-8?B?Uk9rTSs1bUpuSTJSTkkxWUJPOFlNSExnRTI2ZThaeTJnbElIdVVIN05neTFF?=
 =?utf-8?B?aW92bG9yUFlHNXJvaHlMSnFkVEo4eTB2WXNXOEFNemt4djJDbFVkbFRiQUlX?=
 =?utf-8?B?bENNYVdjUGs5Qk1kdWdaaW1jZ0FWYk5UZGFmVUlobkRWNEJ4TURIYUhiSFFX?=
 =?utf-8?B?aTd6UDlHK0d5b1ZPa0ZlYW1tc3RjeTBrSzNsRUJpYXIrd1NGd1ZIcVR5bjdI?=
 =?utf-8?B?dTVwa2NoOTV3SUQySFRRR2tReUtGU0JsZFRrQ21VaHQ0V0pFbXBuaExCTWdD?=
 =?utf-8?B?M3lmaTNqaUp1UW00MUh2cXJaelFranhoNjQyMnpHd1VJS21oSFhOQzJsTjV1?=
 =?utf-8?B?TnNqTFVpc0tNMThZbXFwcVlMbHRzdTI5OSs0OWZJODdMNUZmQnlmUEFjTzg4?=
 =?utf-8?B?OXZUdmRCYXYrY0RsSmI1cEc5bldQTjhVV1U1K2N2NjlFcVU2cnVrRFN4QzA3?=
 =?utf-8?B?VDU0VHNoWFlhcUVkQmJBQndGd2dLdEZIZFd1Y2wyM0pUekl4c0poVmJKUjdI?=
 =?utf-8?B?c1ZEcUMzYWFHZi9OWUZIZitDRCtyN3dpeGlDZUM1VzNFb1o4aFZvRHZ0VllZ?=
 =?utf-8?B?dGZ5a2pqYVVpSXVHNnFKd1pSWjRETjMxMGRsLzBYb2FWNXFlTzJzMGxQcmFn?=
 =?utf-8?B?QnZ5aU5IOG9TeDZHa2U1MmM2YUdBSnNxVmljRlVSTUxXTHJnbEd6eGZYUjRn?=
 =?utf-8?B?WkQ0MHRhRTdJdEpSU0xEa1RENWxqUjlHaUErSlJoTUs4RkxqYzNuNFEvbVo1?=
 =?utf-8?B?U3huZVZZTy9ONG9jQWl1RHp4dGJFbEM5TEk4SHNTcWRQNHpnbDdXdm1nMXFo?=
 =?utf-8?B?djl0NmZGa0tXMzV2K2xCYXdQZ3VSYVUzTms2d1VIcjJWLzQ3RTk4S3dwZllw?=
 =?utf-8?B?QldicjlsY29ZdHpadXZCV3lIWDBJU25hN0M1NmRBOHBuZzJKaWVXT0hiazVw?=
 =?utf-8?B?T0Rxc1J1Z3htbFk5R0RMQUFsRWQ3WjFhMjZDUlBibHkzbkl1MGJhZm9aOHpa?=
 =?utf-8?B?dnNWa2IxUFBYcUlaS1IvRnNXMVRSbjlMTUVSSWkraHNNT2RJV1VCZ0JweG0v?=
 =?utf-8?B?TWtUSlpCL3E3cjZXRW5yL0FuRExuTForT1F6SEZESXN3RnpnUEdQZHFYMWc2?=
 =?utf-8?B?K21qUXpFOXhPdkNnK25JZmlWM2VZaHhMWUdUc2JVdEtiR29sdUpmZlV2Z0ow?=
 =?utf-8?B?UFBkWFB2dmNhYVBGYmxreW5kSWZsMTRwTnpib3dsRzBGcERyejhXMHhWRFFU?=
 =?utf-8?B?eFJTZWJGVThFKytCNmdwUkdCYy9wU1R5alhUbmp2KzI3L1lmUTVNcVZWMjg0?=
 =?utf-8?B?aWltL1N5M2Z6UHlYdVZhZmE2aDg4d3VZZk0vMU1sMmVINjVkODRKdFZWcVVO?=
 =?utf-8?B?dTVWTjJ3a2h6WjNidGtCclVRRFU5ZjRmSGxTdTJRK1hQNGM3OHBDWCtob2Va?=
 =?utf-8?B?bEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 9p4x/DpN4dSL+XQWUvznhxPMtg2FoSoTRa03c2XOeQbXe7BETRExr2k3Z980FYnVnudfwwCCq/si4UPq9Y9sAmzH8oexNCRUWteydSO7uMBlpB7pEl2l0vB0KaHUDTsZn1HilJISnmLyUL5tFtAkEjxAoMEQyiTK6CO04Qg2IeedMZojQzY5e+CDczKkCEQNohwAitHMi8NMHhOLqKkGhIxyn7Z4Wfr1ESUotPCTJYKnQX2+cY+63ZAl/A/thVdMqgrm81JeSBkl644DkZ/NIYnhKIKYbPAd574oUERBefiXmJp8HNZdos7THTEQVxgQMZ1wtTjQtXxn1H8qmWID8VPMVXCITXcDTfKcFtrHJfXjg8mYZfVvmkaSh/3NOr39mvGFVuiTtGPc4UBNDk6bgOVRLlyI4ygxpV0aHo2PgNan8AA/Lkmtp5dSJ4DggmSIHlq4nBPFJNrA5pwbUWq3bRYIbP1sr8JMZo+Y9tzo7XykG4cU4z62dCVb3nIyKSmq4ViOFp3XCs/z9XAt0hnhFoMVBzYhKH9t8nZa6Y5co+DzQX3c26xh/wLyvVuS5Ky9cjRuN6/CIO2lHu51wTGTg8/EucBI9wtgeuB1CYuALwB2vEXlK6WCWRYpGyQj5TAZE5QIc2x23ZXIKyvs3AcHcGduYeqzZl/xdjReyrRC/gOVQcRseCq9qRo/871S65CujrhFsx927oYRvogLNN26jQZAgcuXsi6CuMHTnKRQq8Oxzqa5/Y4SJ5qi9wxSahi3YGhTwalVD16srxmlrxZaebFYhdf0WL8yVQGS8Mg22SiAgwrUzfPxhLjdCLzNf2KlcD+Y0/nD+RXnG/dyO9hNO4wFKDzIpKbV4/6/kixEjoM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85283895-4122-4459-bebb-08db82f1c66f
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2023 16:05:13.2340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gbRjvqY+pfj4NaTm+jdGcdi8vxlfxyMZiKMm71MqRUqQ7VTRlSdWOfeTDYYIw+MLQYCeQJpATWTlPN28dqcCTwKSNNvMGY/Jp3GPO4loDUY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_11,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307120144
X-Proofpoint-ORIG-GUID: PBXoOUI2QgCuxbfn1-2BgR8g6zEgu4VS
X-Proofpoint-GUID: PBXoOUI2QgCuxbfn1-2BgR8g6zEgu4VS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/12/23 9:26 AM, Stefan Hajnoczi wrote:
> On Tue, Jul 11, 2023 at 04:01:22PM -0500, Mike Christie wrote:
>> On 7/11/23 1:34 PM, Stefan Hajnoczi wrote:
>>> On Sun, Jul 09, 2023 at 03:28:57PM -0500, Mike Christie wrote:
>>>> The following patches were made over Linus's tree and fix an issue
>>>> where windows guests will send iovecs with offset/lengths that result
>>>> in IOs that are not aligned to 512. The LIO layer will then send them
>>>> to Linux's FS/block layer but it requires 512 byte alignment, so
>>>> depending on the FS/block driver being used we will get IO errors or
>>>> hung IO.
>>>>
>>>> The following patches have vhost-scsi detect when windows sends these
>>>> IOs and copy them to a bounce buffer. It then does some cleanup in
>>>> the related code.
>>>
>>> Hang on, virtio-scsi is a SCSI HBA and READs/WRITEs submitted must
>>> follow the usual constraints on SCSI block limits. Would Windows send
>>> mis-aligned I/O to a non-virtio-scsi SCSI HBA?
>>
>> It's like linux where you can config settings like that.
>>
>>>> Are you sure this is not a bug in the Windows guest driver where block
>>> limits are being misconfigured?
>>
>> From what our windows dev told us the guest drivers like here:
>>
>> https://github.com/virtio-win
>>
>> don't set the windows AlignmentMask to 512. They tried that and it
>> resulted in windows crash dump crashing because it doesn't like the
>> hard alignment requirement.
>>
>> We thought other apps would have trouble as well, so we tried to add
>> bounce buffer support to the windows driver, but I think people thought
>> it was going to be uglier than this patch and in the normal alignment
>> case might also affect performance. There was some windows driver/layering
>> and buffer/cmd details that I don't fully understand and took their word
>> for because I don't know a lot about windows.
>>
>> In the end we still have to add checks to vhost-scsi to protect against
>> bad drivers, so we thought we might as well just add bounce buffer support
>> to vhost-scsi.
> 
> CCing virtio-win developers so they can confirm how the vioscsi driver
> is supposed to handle request alignment.
> 
> My expectation is that the virtio-scsi device will fail mis-aligned I/O
> requests.

I don't think you can just change the driver's behavior to fail now,
because apps send mis-aligned IO and its working as long as they have less
than 256 bio vecs.

We see mis-aligned IOs during boot and also from random non window's apps.
If we just start to fail then it would be a regression when the app no
longer works or the OS fails to start up.
