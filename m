Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F87FC71153
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Sep 2023 22:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239127AbjIDWFN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Sep 2023 18:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235827AbjIDWFM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Sep 2023 18:05:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5459C
        for <linux-scsi@vger.kernel.org>; Mon,  4 Sep 2023 15:05:08 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 384J00Wi002337;
        Mon, 4 Sep 2023 22:05:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=9Pisni3BznEil8jY6zmVsj2F1KGmHhIxiR6ywM3oVMo=;
 b=Nnu9Da3QzAJGLFeL1ACCUpPYN6GXwS7U4rxavvajEBa1rNwOw3yLqDCC6XRayrqTfuTD
 T1S9lo1G/tTwm9BdMZ+TAZd++Nb/gZ8Is1WTDug58kMaSa7eh037fYBtFXd0eDLG+47D
 Vu+ExHaO5R1kv//Epe5sh5wFJPNPMNHJNqz47awm1TQUmVq/mlBMqqJL2BKsk+1KHR/p
 oR0eQ1R2SfwCP1lpcluNXics5BTFAbDfStZlbmoiVrMq65iVZWiXJcPUbz7YlXMnd/Ar
 Xq5pwFKDypMv9HxQb5sV3Ak6QxSE70fW8nQbW11YqxJMfAtIgah7XoqPbps4x+eStOMt 3Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3suwktuwv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Sep 2023 22:05:06 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 384LXjkr007713;
        Mon, 4 Sep 2023 22:05:05 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2042.outbound.protection.outlook.com [104.47.74.42])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suug4240f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Sep 2023 22:05:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BN/CeCa3OHuGPkALP6yQxEMTM5T6lvVApx9Q6gD5wFmjdFWVIkcPdtqTU2driv2KKhatA7Ri8fHtii48HG0TWfLko64iRJEzRkuFB9XoZe65o2+PU8CKxVS1c8HYf3JKI+aZlkkfhlqasbh1wKgBaUiwkesgWK3WFZmQ39kiMGTtTj4euSKWLNV25RG1QM2qSo5guN8SECUiq4Xky7VYaVoxZrmr7+WI129IweNAZ6So3/t2hkJbOfJLpdr35F+6YgDistHk8m8X6zisrAqUgCNom32cNHL4f2zSfKvZcDz697QHi4xCPeAV8CM+n270Z5g84zcAXfXTDHOyXHlAAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Pisni3BznEil8jY6zmVsj2F1KGmHhIxiR6ywM3oVMo=;
 b=i8oucoqsYgU/yF+3NoIXb1h+Ss5dyfqTmY0ewet2nyHhgHgdkiS4WSdYT6BZIF+0We4ddHIs6Sq5VgZ8Z/ISZ+F1NG7mNempREChWk4TmX+XuuoLKWZzrlime1t7V3/Bb/V7NUUSQklIWJvkok1HWBcDqaBMYRsd1xXhc/a7hogfbwdSgKbagnSUq8o1F3G3fKcRTXHbVh9ndDlk/ljPYJLKkzwCVceYH7w2fdzJN2nNOy6tWnMj4anqUdCt/YVTpDVp5lE0m3E4U53BX03NrQULiuQQeTSWG46JpTqVZKDP8bLcL5d6YjOO5xmt+L1Ez0k+DNq37eub4FWxTLvOKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Pisni3BznEil8jY6zmVsj2F1KGmHhIxiR6ywM3oVMo=;
 b=FH+GX7xX4o+J+tR0wA6mM0YRx56Ao0mWqQMytL4DXy3K81wEaZulySOL8xAfnQpz540KVDG85f2oWQX/a72BKgYqpmI6DjGjiTVltqgg4ZEleTo2UFvrSmu0/RLVEwPgu3MGaPqOPgkCfvRv0UoQd+P5ovUa9wOa/KTIpWTIlEo=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.32; Mon, 4 Sep
 2023 22:05:03 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Mon, 4 Sep 2023
 22:05:03 +0000
Message-ID: <12b1a9e6-5970-4945-8849-fc21c868e28a@oracle.com>
Date:   Mon, 4 Sep 2023 17:05:01 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: megaraid_sas: fix deadlock on firmware crashdump
Content-Language: en-US
To:     Junxiao Bi <junxiao.bi@oracle.com>, linux-scsi@vger.kernel.org,
        megaraidlinux.pdl@broadcom.com
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, martin.petersen@oracle.com
References: <20230828221018.19471-1-junxiao.bi@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230828221018.19471-1-junxiao.bi@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR07CA0069.namprd07.prod.outlook.com
 (2603:10b6:4:ad::34) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: ab8c131f-0b67-479e-f2a4-08dbad92fd57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UdjucjZtJ+1XdmSDLuDMD3YT5vVNpauJfL1JXwz+/tZkWoIAVdAr7UUyPRPNy3qNzcwM/JqaRLA0Ac9S817T4MBriIe+DEYnXHFB4LyWK3vvUEgH+4RvnTpr9yUSVPD3SkoRyeKWeVy+G8iBO/AsA/p/fU5cRv4uNqwXhXTSj1qmadmMk7dA9cK2sW5pXh5xIhXJLU6Q7AbMsc3vB9PDkaRjvskBcvOAXB/IJmgvbabIRSnj9FHW0tczPrKQKoZNGGgtPDZ3eZ7NLLyOZjJeArPfjcKRVDt3wpGeiUAphHG+oQkhggf5r8/rKMZ9Ton1g8O8sY6XiqdRjarKoXlleQdK3xAU8SXxdCv9lcGk8Vm6aR6XoH3qC+iK7tJf/eaZqfb+aNSYLw9e6+wdzoBmm4dGMLkto7udXCBiZHVUHfiLfeClkQO5I6EOZlYEM5XlEl1hlZiOHyqiVwD+q0BAS0J6hotdNp0y7v0aMGOGvmIN2mrSumEPgU4hFn5l00r4+4DstaaNWcFCdYlAOQlkK/zZdY8IjcKPM9mSB/yajWjsUw8H6I+GfBcrHVvmtr/JJ6BVWbnPm9X12bHhexqgOd4Bv0HO2wqhULkVg3pPLdQu7wlDr4EbnikqvxpMT6IIdkaS2sg0qSKUYZxwRwb8Xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39860400002)(346002)(136003)(376002)(1800799009)(186009)(451199024)(6486002)(53546011)(6506007)(41300700001)(6512007)(2906002)(36756003)(31696002)(38100700002)(86362001)(316002)(66476007)(478600001)(66946007)(66556008)(83380400001)(4326008)(8936002)(8676002)(26005)(31686004)(2616005)(107886003)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3k1b0lFKzFCYVhBNitjZlgxQlVKUUU1akxPQTdSR2NXQmcxYUdLS1g1aGdX?=
 =?utf-8?B?MjlhREJST0FJd0dXWERvWDg3WkFOaFJuMnByRk9CKzF0TjZ4MkhzbkNDZnU2?=
 =?utf-8?B?T2JlRGM2V2VUSUdyWFRicGZhbzVPVXVGTmxlek9CaVExOTZvMGFYOWVONVVy?=
 =?utf-8?B?MzdvVTBKSmZwZXpsWHA5ekhQNFF0Mndnd2lLODNMajNVN056L1lIYngzZm0v?=
 =?utf-8?B?bmNSbkY2cm1rVE11UWVBMVVicjZnc2txWGlNMktqb3RKM3dXcWhUNEFOV3lN?=
 =?utf-8?B?VW5pMFEySEZkaE9tOGczWDZRSS8zQWdaUGJSR3JROCsrb2JMVGM3a2ppNm0r?=
 =?utf-8?B?emkyT1Rnc3laVW1qVjFvSE1YRXZDamFXMkt6ZzZHR2U3cVlwdXNvSzJGYkl6?=
 =?utf-8?B?Wi9iWC9xY0Z5MlRwcDFBM3pLNTRoYnJUVlhUay9JMUY1SmFsbi80S3dUSG5E?=
 =?utf-8?B?NXJsU1pjcnNzT0xFKzlsb1d4eGtBSVdYMnRYcExvazBpYXoyL1ZIcjJhay9Y?=
 =?utf-8?B?T3dhMUhRbisvVnkyTjlwSHcvSkpBc1QxSXY1V1c1amJNajU0TmFuaEJXcVNz?=
 =?utf-8?B?bDA1WDFTRjZVQmpTdWcwYkVTNGtpL3dBeFNuOGg0UmljRXlFRDNMNEkvU0Zo?=
 =?utf-8?B?REs0M1lzMk01d2I3V1pNckttRUpqU1Bpa3N1R1dxQlBuRTN1OFBPOVJlN0ZH?=
 =?utf-8?B?dzczT01KWFdjRENWdnk4YVNsUjVnakw0RUJRdlBRNmpKY0FvTkpOVjAyUXMr?=
 =?utf-8?B?ZnhuclhzOWJaNjc5ek1ITkcvTjRNOHV2NTQ4NjcwaXhpT0V6OUtneWdCa09T?=
 =?utf-8?B?a0lxcVdEV3lMbENSUmx6UGxNTnNjSFJPTkNNQXFYOXFLNEpBbHFPTDFESy9N?=
 =?utf-8?B?MHR5cDQ3OHZpZk1tSlgreXR3VUdYWGFDQzlhMlpKNlJCWHRsM1dJdVJ2L3V5?=
 =?utf-8?B?VWJtUHdhV1ZaZzFuUEZDRjNSOUVDbE96dHF6UXpqRjdhdGozR3lqRmFlWFA1?=
 =?utf-8?B?cGw3RllObE9lVzBuTTBTaitqeGVVUmw1Qzd5QmU4NStxdXUzOXRkdkRIYVZl?=
 =?utf-8?B?WXJKbGJ2Tyt4VU82SnpKUGU1Z0w5eURUblJUbityTm1Hd1FBQVphSi90YzMr?=
 =?utf-8?B?NzdmK1Y2dWFWcHBvcEN0Vm1QMlVhbEtaU2loeFViTHZiOWE5Mzk3ZkE0WHRF?=
 =?utf-8?B?WmN4aExGanJMQmRhSFgzNGJSbDd4RWNoYjVwSjhhR1dMeTc3eUtySFdkbktF?=
 =?utf-8?B?RWc0enpJSXNOKytFOVBOTU50S2cwYWhUQ3EvZ0daWnRqc2hvQ0p6NTdNa3du?=
 =?utf-8?B?SlZTbVpwSWppTDNESDVQNkJxQUpNNFV1TlJZTitMVUpaWGtqSVhYMVpHZnh2?=
 =?utf-8?B?cDRjaTBRbkY1K25vc01wY2JDaDFKYTNHeGVZK2NEdnlIcmNCclhIZTZjMlds?=
 =?utf-8?B?clorNGovNDV2RWlqQ3U1OE90STVYdzJvdkN5WGFFKy82VFR0WTJUamlQeENx?=
 =?utf-8?B?K2dQMTg5TEdDOE9YYXZ3T0t5U2kwbFBvUndpNHUxcTZzOFNOeEsxYWplOUsv?=
 =?utf-8?B?Qkc3c1MzVGFhT2RUbTlpajVJbGtrQ1k5VC9YYVRheVVJN2NyWC9KcmJsTjRR?=
 =?utf-8?B?MmRjQ1JYbTR2eXc2Mk80NWVSRzFzaGdNeEQrN2Q5UmZEcTNNMkFncm5Xd3Yv?=
 =?utf-8?B?RjluTmpDanlVY0VOdG5BSkM3cU54c0NFelRkU3ZXUGhEaEw3bHZQT2xKNzFV?=
 =?utf-8?B?eE5EWkhEL0ZoeVYyVXlhSmVGRFA0OG1Uc3NMbWVkMTZhS0NGdW4xcXJIcWYw?=
 =?utf-8?B?VEhOSWVlVkIrR1JEM3FOZW9TVzBvVU9xcnhCWGp0QzJ2ejNkaUNOYWpPTnFp?=
 =?utf-8?B?Vjhjb28vRUtXU2tyVWlha3pCMXE5S0EvM2xiMmttQTJHRnhMR29PRFhxOWVF?=
 =?utf-8?B?VWZJK01ySWNtR2xoYTZmVVNZRDFXamp1US9lOW4yYVowK1FQV2FiVlRiaXBS?=
 =?utf-8?B?RTNIbEhOSytBQ2dvRFEvdUI5eVpNY2lDc1FGUGlUM0NaekxTZ3FCOFp6YXF2?=
 =?utf-8?B?RkZoc09nUDl2UjhqWjFaTTloMURFcmRqRDdXSERtNXJsQmhEUnhoSThPdVRl?=
 =?utf-8?B?ME0vdGZaUXBzNUhqYk5mcDU0eHlrZ3IwNFhsMXI1TW9QaWVJOWV4L3hZdm5r?=
 =?utf-8?B?MXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: AB2D6rDnNNpPScXRJuZvD6YhxjY/m2hsFoQg0HaAtX0xADJu9Rcsp7dTHLfpK6nWFQE3K1z/hWTM+0CD9VF6xmK+Dqy6+UDK/gLZ11e+2zHMqpdxGKU6xZY2iFf+743xjvcvIIWiAd/Noj+LmnV8QIACbLydPVz3J98zE891+i30BWq7yHRNh9eMNs98+zVzjgVbRIWEx7VGTQRYOaLG6Xe5D7BFS/ZXrzlu4smKHeP3uRzPzbEAhVM+M/lxp9mMgGLMVzByaEF34LzOaIEmMGUum1yGRgAQTCRwMrr9pXBJZNsv5VdACy0m+pR+vsF7LSsD2eBpCy1Q2BZgh70Ip5gjQunakD3yuyDq4Yzp/FsSf/q1lzb1MKh6NMYseOaUXsVootaVYSx3SkxseHZo0O+gu1vDW6TN+7LBZM3ufmxVXe+5J587YR9uS1pkPSwWaymMn2eI6l78tJuaktaOUvcyb3EQV/ByR1F10hlhDkxI65UGtLuRrgi85B8GP2Vqeu0AU8U5EyL9zrXJeOSbVtV9IjbYo07bzYW2njcmsVinqUP7i/khYaY9HMC3X5OKUbp6XjEkXFehFCtVM7bODk6z5WIn3MTYdLsr1rG0GKxqxLsL7UyNYOs9cpnbUC+PWxi6rbl2Otjp3lGJCwxFzwrPWNlaJecR7SwB0AGc/ImI7c51FMNyAolu9uCeVdOboRzWjuOTb2XA2HzJCpvkJxfoWAyAvlWrikedlh68BC2bDmwe3ajKAz1hK12i/ybU4pkfrB/wuaFeU0wGGNAwR7S1PoKS6I/EYKB6nYos++I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab8c131f-0b67-479e-f2a4-08dbad92fd57
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 22:05:03.1703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4BeG36b7S0Wo3cmYH85siqxtMB7LFhd4ptA+EAVmAFa54BrTVXyh9fZCicdMPkMqkWOoePIcKSyowKS9Zx2pnG+yZg6jc/8s2BqxFy2PtLE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-04_13,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 mlxlogscore=935 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309040199
X-Proofpoint-GUID: ibyPy4UesqYzpxSROxbnJHlnxOZSEAwa
X-Proofpoint-ORIG-GUID: ibyPy4UesqYzpxSROxbnJHlnxOZSEAwa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/28/23 5:10 PM, Junxiao Bi wrote:
> The following processes run into a deadlock. CPU 41 was waiting for CPU 29
> to handle a CSD request while holding spinlock "crashdump_lock", but CPU 29
> was hung by the that spinlock with irq disable.
> 
>   PID: 17360    TASK: ffff95c1090c5c40  CPU: 41  COMMAND: "mrdiagd"
>   !# 0 [ffffb80edbf37b58] __read_once_size at ffffffff9b871a40 include/linux/compiler.h:185:0
>   !# 1 [ffffb80edbf37b58] atomic_read at ffffffff9b871a40 arch/x86/include/asm/atomic.h:27:0
>   !# 2 [ffffb80edbf37b58] dump_stack at ffffffff9b871a40 lib/dump_stack.c:54:0
>    # 3 [ffffb80edbf37b78] csd_lock_wait_toolong at ffffffff9b131ad5 kernel/smp.c:364:0
>    # 4 [ffffb80edbf37b78] __csd_lock_wait at ffffffff9b131ad5 kernel/smp.c:384:0
>    # 5 [ffffb80edbf37bf8] csd_lock_wait at ffffffff9b13267a kernel/smp.c:394:0
>    # 6 [ffffb80edbf37bf8] smp_call_function_many at ffffffff9b13267a kernel/smp.c:843:0
>    # 7 [ffffb80edbf37c50] smp_call_function at ffffffff9b13279d kernel/smp.c:867:0
>    # 8 [ffffb80edbf37c50] on_each_cpu at ffffffff9b13279d kernel/smp.c:976:0
>    # 9 [ffffb80edbf37c78] flush_tlb_kernel_range at ffffffff9b085c4b arch/x86/mm/tlb.c:742:0
>    #10 [ffffb80edbf37cb8] __purge_vmap_area_lazy at ffffffff9b23a1e0 mm/vmalloc.c:701:0
>    #11 [ffffb80edbf37ce0] try_purge_vmap_area_lazy at ffffffff9b23a2cc mm/vmalloc.c:722:0
>    #12 [ffffb80edbf37ce0] free_vmap_area_noflush at ffffffff9b23a2cc mm/vmalloc.c:754:0
>    #13 [ffffb80edbf37cf8] free_unmap_vmap_area at ffffffff9b23bb3b mm/vmalloc.c:764:0
>    #14 [ffffb80edbf37cf8] remove_vm_area at ffffffff9b23bb3b mm/vmalloc.c:1509:0
>    #15 [ffffb80edbf37d18] __vunmap at ffffffff9b23bb8a mm/vmalloc.c:1537:0
>    #16 [ffffb80edbf37d40] vfree at ffffffff9b23bc85 mm/vmalloc.c:1612:0
>    #17 [ffffb80edbf37d58] megasas_free_host_crash_buffer [megaraid_sas] at ffffffffc020b7f2 drivers/scsi/megaraid/megaraid_sas_fusion.c:3932:0
>    #18 [ffffb80edbf37d80] fw_crash_state_store [megaraid_sas] at ffffffffc01f804d drivers/scsi/megaraid/megaraid_sas_base.c:3291:0
>    #19 [ffffb80edbf37dc0] dev_attr_store at ffffffff9b56dd7b drivers/base/core.c:758:0
>    #20 [ffffb80edbf37dd0] sysfs_kf_write at ffffffff9b326acf fs/sysfs/file.c:144:0
>    #21 [ffffb80edbf37de0] kernfs_fop_write at ffffffff9b325fd4 fs/kernfs/file.c:316:0
>    #22 [ffffb80edbf37e20] __vfs_write at ffffffff9b29418a fs/read_write.c:480:0
>    #23 [ffffb80edbf37ea8] vfs_write at ffffffff9b294462 fs/read_write.c:544:0
>    #24 [ffffb80edbf37ee8] SYSC_write at ffffffff9b2946ec fs/read_write.c:590:0
>    #25 [ffffb80edbf37ee8] SyS_write at ffffffff9b2946ec fs/read_write.c:582:0
>    #26 [ffffb80edbf37f30] do_syscall_64 at ffffffff9b003ca9 arch/x86/entry/common.c:298:0
>    #27 [ffffb80edbf37f58] entry_SYSCALL_64 at ffffffff9ba001b1 arch/x86/entry/entry_64.S:238:0
> 
>   PID: 17355    TASK: ffff95c1090c3d80  CPU: 29  COMMAND: "mrdiagd"
>   !# 0 [ffffb80f2d3c7d30] __read_once_size at ffffffff9b0f2ab0 include/linux/compiler.h:185:0
>   !# 1 [ffffb80f2d3c7d30] native_queued_spin_lock_slowpath at ffffffff9b0f2ab0 kernel/locking/qspinlock.c:368:0
>    # 2 [ffffb80f2d3c7d58] pv_queued_spin_lock_slowpath at ffffffff9b0f244b arch/x86/include/asm/paravirt.h:674:0
>    # 3 [ffffb80f2d3c7d58] queued_spin_lock_slowpath at ffffffff9b0f244b arch/x86/include/asm/qspinlock.h:53:0
>    # 4 [ffffb80f2d3c7d68] queued_spin_lock at ffffffff9b8961a6 include/asm-generic/qspinlock.h:90:0
>    # 5 [ffffb80f2d3c7d68] do_raw_spin_lock_flags at ffffffff9b8961a6 include/linux/spinlock.h:173:0
>    # 6 [ffffb80f2d3c7d68] __raw_spin_lock_irqsave at ffffffff9b8961a6 include/linux/spinlock_api_smp.h:122:0
>    # 7 [ffffb80f2d3c7d68] _raw_spin_lock_irqsave at ffffffff9b8961a6 kernel/locking/spinlock.c:160:0
>    # 8 [ffffb80f2d3c7d88] fw_crash_buffer_store [megaraid_sas] at ffffffffc01f8129 drivers/scsi/megaraid/megaraid_sas_base.c:3205:0
>    # 9 [ffffb80f2d3c7dc0] dev_attr_store at ffffffff9b56dd7b drivers/base/core.c:758:0
>    #10 [ffffb80f2d3c7dd0] sysfs_kf_write at ffffffff9b326acf fs/sysfs/file.c:144:0
>    #11 [ffffb80f2d3c7de0] kernfs_fop_write at ffffffff9b325fd4 fs/kernfs/file.c:316:0
>    #12 [ffffb80f2d3c7e20] __vfs_write at ffffffff9b29418a fs/read_write.c:480:0
>    #13 [ffffb80f2d3c7ea8] vfs_write at ffffffff9b294462 fs/read_write.c:544:0
>    #14 [ffffb80f2d3c7ee8] SYSC_write at ffffffff9b2946ec fs/read_write.c:590:0
>    #15 [ffffb80f2d3c7ee8] SyS_write at ffffffff9b2946ec fs/read_write.c:582:0
>    #16 [ffffb80f2d3c7f30] do_syscall_64 at ffffffff9b003ca9 arch/x86/entry/common.c:298:0
>    #17 [ffffb80f2d3c7f58] entry_SYSCALL_64 at ffffffff9ba001b1 arch/x86/entry/entry_64.S:238:0
> 
> The lock is used to sync between different sysfs operations, it didn't
> protect any resource that will be touched by interrupt, it's not required
> to disable irq, replace it with a mutex to fix the deadlock.
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>

Reviewed-by: Mike Christie <michael.christie@oracle.com>

