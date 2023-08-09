Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BCC3C001DB
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 01:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjHIB0C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Aug 2023 21:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjHIB0B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2023 21:26:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8095B1986;
        Tue,  8 Aug 2023 18:26:01 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 378MiFoj031317;
        Wed, 9 Aug 2023 01:26:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=+39RsJava5utt82jDxGPjkPDjvQ4V8Qbs689HFgwx8g=;
 b=O2vMP6lPN5qWiasYyZZFBru06M+SJxzW+Qm/dxSsYoQTBIO4lCdAc2zSMrLvsYlgVLVF
 oMPxyAsBbVCC2AgOHVm3GA7hs/C6ufwrKwqvissKWKmCxM8waTWit0NmXdJGIdRlVj4Q
 aIdOicR3FkK1TNxrQH+v9lKdeh2Oq99C2Z8pwQ+4tdyhOB9btHY5eaMH05wVWPat8ynd
 w+lSj07UZ9IOneeEfSXbmIy/ycGGq7OVNBlasPrGD5Jwb6QpLftuDLmCu/qUr3lDBVPP
 3CAUjrB0vZI46T7Sjt/uLQdqKR7+JhlTA28O7cpPngQFlfGEVGhZp/7rEfO1LVY6vR4L dw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9dbc7728-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 01:25:59 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3790LIaE021415;
        Wed, 9 Aug 2023 01:25:59 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cvdbdu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 01:25:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MgSjSXYxk5IKmYkReJiU3bV2yiNR9KY3Je9fTuZJ2oVEBAwZvWyDxGJTc8YCopFwzhI3ZWM/824WMOKbiVT8hTzh0DkCN+3orNcncxvZHNPf5KwZ/QGDjoyM9/yGAzfZHrS62vSg3624wsbhv57dumTxVJ1NApC6OTeug5exS0OKTFVbV9PqCdabpe4L/K3PqKdOjMkibt2TgAf8Jzq+/+4HjgD2+v2wfkPcBjO0aGjmBQK+YlxtZUBqzM+0E/LdZdJD2WeuGsaP5nGkbR7mb7G9EtsjdupOpVBQwTVZsson4TEGgGpTv5VTY7bihZTykJRyiTCmarAWS52KJ5FnpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+39RsJava5utt82jDxGPjkPDjvQ4V8Qbs689HFgwx8g=;
 b=VfJGSrtqzksGc6ou33PLqH7+L5KN0C5+0ZsUvne7LUg0kOWXagGqenFE8vxdHa2FC5UrMNbi/rU4Rr5vsQ9zel3yEg8NWlpU7z5xi5+Kus56SQADg7zAQT0qWjMZKYz7Enl/98J+XmwiL1y+mnmRS8aOpz65yL7QHMNP4IQIQ8VCzW03hJHIkPRRHr+YVTFClemCgn8gvVPFHo4khBC1+nPKH1ugqFZUju7eFSziJINbXE6b8u4gnCOIeIpGJlZiQAH22r86boBatnZFvvKbfyYN3C703e4i9chk9mGHnsOeuuX8xvA0TNhEwY2ocFVhcaZ/j8XaZBk4s9Prkc1Z0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+39RsJava5utt82jDxGPjkPDjvQ4V8Qbs689HFgwx8g=;
 b=HgcTcRfEn3WPgEC1MiyqOhVzo5ZoB5+lzzS+yW4f/DKlO4Jlmyt2v9IYMYY+t4q10BMgUSqIn9fwQ3ea3D8SdFPOnwm2Lr1QITxjLvkg01m/XQuK+BOpAP+uRvos5fKK5fQXU3HGbhhv03KxFXX0PnSK9ypCodCOCM+5M/m0iI4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4137.namprd10.prod.outlook.com (2603:10b6:5:217::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Wed, 9 Aug
 2023 01:25:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%6]) with mapi id 15.20.6652.026; Wed, 9 Aug 2023
 01:25:56 +0000
To:     Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        sreekanth.reddy@broadcom.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Perform additional retries if Doorbell read
 returns 0
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a5v1ja8a.fsf@ca-mkp.ca.oracle.com>
References: <20230726112527.14987-1-ranjan.kumar@broadcom.com>
        <20230726112527.14987-2-ranjan.kumar@broadcom.com>
        <yq1o7jsq9lq.fsf@ca-mkp.ca.oracle.com>
        <CAMFBP8MS0hwd9-bfVrPi8yTB3Es-w7ugHwEMyxtb8R-mj8PPCg@mail.gmail.com>
        <yq1sf8ujmf2.fsf@ca-mkp.ca.oracle.com>
        <CAMFBP8Nf6ifVxJnNBv=zq+WyJRZR-2Hiuo4AejLAguE-GWuzJg@mail.gmail.com>
Date:   Tue, 08 Aug 2023 21:25:55 -0400
In-Reply-To: <CAMFBP8Nf6ifVxJnNBv=zq+WyJRZR-2Hiuo4AejLAguE-GWuzJg@mail.gmail.com>
        (Ranjan Kumar's message of "Tue, 8 Aug 2023 12:42:38 +0530")
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SA9PR13CA0091.namprd13.prod.outlook.com
 (2603:10b6:806:24::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM6PR10MB4137:EE_
X-MS-Office365-Filtering-Correlation-Id: e5287fb0-d9a7-4b77-55ce-08db987794c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T2pPK9o/2/lW2N1KRJuWsI3+joHfhocGVYbVONxi9AisQTSr2FDeU853XGusSkg9Vd6wgv0GUxLrHRTXwYb6UcbaUAFhAxSh9DdHSVkUlgLbjK7AM+RtHmjDnE7v24WLON+C73mf5walDP7rz1Z+4A3UPbyLPSiBxpGF2OsadPQWtbVGbm5qOrn/APppQ8Ht1De8NaDNe7o7GOcB3KGH/b1nUAGu9iv44PWfJR8Yhs0oAJJLWbkSUdW2LhGdwcU01Bt89QVJC6L8HyhstUyKJtJCTeJzDiLSMV5KY2S0bE4h7zzWLMANnwqLRpYbddDP/sXiSUqlzhmDMD5ala0zv2pEzVHdHOY1b80lzWHAGS1wC6l1SdUKZ5ukBIPjcuWsPYRNPXrSPIfYcGY0LODnMJat6gmizDZsvt/+ZOoWZKLUQgvcdNeZ5RNft4DSyqgoCwHTY+kupyRibEWEEAdUiUGWLGcf3a1kTkVRLa1q6T1IzroMDcV2XB//BnkvC/UnFiaTTDV/5bGMV+Wiv+wh3uom19cOqXi+AKtZRfy07o43k9oGbq7ar9pR9hi3L44i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(136003)(39860400002)(396003)(366004)(186006)(1800799006)(451199021)(6506007)(26005)(6486002)(36916002)(6512007)(478600001)(38100700002)(66556008)(66946007)(66476007)(4326008)(316002)(41300700001)(8676002)(5660300002)(8936002)(6916009)(4744005)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXZZYTdQNGxadCtKYUtOM2xHVnk0bGxmK3N3ekpjR29LQkhML2o0UGI4N3lo?=
 =?utf-8?B?NlQ2UFJzQVB2TkgrZFlmRi80WWREcXkvNlU0QmFMaCsvOEd4cGhzQmJSd1pH?=
 =?utf-8?B?K1BCd0R4bWtRR05hWDFSQkVXSU9UVithWkxKRTZkTmtseUhnSnJMSVplZXln?=
 =?utf-8?B?Zmo2TWYwcXBsdnNMaFNvTkVXWHlYR0I5MjlrS0kxbGErdzV0TmhraHYvelBW?=
 =?utf-8?B?ZVd2S0J1aElHUHZNWkJnT2ZrNjFwTUVmS0VqWXo3QmsvbHM4aHYzdjl6RW1j?=
 =?utf-8?B?MFFvYlFtNzVrcXNHdTVQVFFoWVFibmNGTEg1ZGx2VHFTS0VxZ0FxdysvN05y?=
 =?utf-8?B?U2gyeXZCWlVKeTRVTUUyT01mRTkyNmlZNXluNUJyaE5pRzFJekV4enFxaGtt?=
 =?utf-8?B?QjRGK0lnbHR0ZnZ3WmZsS2FNY21tQTBvbDFqMXRKOWxseS9WdDdWbyt5RnIx?=
 =?utf-8?B?VzBFOUN5cTRQTGNibU5nM0xaZjRUN2hSMlczc1pRN0RUOXRNR05US3k2bUto?=
 =?utf-8?B?NzBpRUJKT0x4TVUxbWVmQ3hRS2xVb2JZOTJFZkdTT3poMXk4aUtCcExoVXJK?=
 =?utf-8?B?VjFwRU52Y1NoVHBzVjAyeU1jQ3FoNjZMZXpKc0d3dUYyTnpZRmRjblNoQUxO?=
 =?utf-8?B?UG4yTlJMajlSS0NwUEZMdzNpNG5HZDBibzlKV0RKYmVDUUxhMitPN3Vibnl0?=
 =?utf-8?B?MjNnZHN4aG9QbDM4alBaVW1NQ2ZJc3VhRHRaUjRWTmEvTnVsZVhFVnUzYlFX?=
 =?utf-8?B?ZUhPamVQaE1sNVhZQnRtZUNIWGprS2tOMGhSdklES3Q4RnRJQlQ3bklJOGQ3?=
 =?utf-8?B?dHM0NGcwbkRJWjVsaHdRTHprNUdTWFlEMGJtNlNvTnJ4V0hqeWdaUG1vTVJx?=
 =?utf-8?B?b3pBd2xiK3A3L1MyRDRHeUFyb3lYMTkrZVBlbXBwcWcwZEpMQm9WR3B2bjRu?=
 =?utf-8?B?SlpBYVVNMkpIRXl2NUpHNC9neG1YMi9ldFhrZUhqY0krSFI1b2E2MEhOMVdY?=
 =?utf-8?B?ZU5uUVdvQmlteGl5cWNWUTBYYjBVQUw1N08wdTIrQmxkTGdNdEljV3lxWGZq?=
 =?utf-8?B?aStJT1BYaTdVTEZlelJ4dTBSVmwwSnBOZDVYTVBwQU8zVWRVY2NWeFNRWTN1?=
 =?utf-8?B?OXg3M2tUdFJXOVFRM1pibDMrZmdtUWFqSDNGalc1SlVwS2ZjdTVmbGx3RnUr?=
 =?utf-8?B?RWRteGpKbG5VOHIzRGdHRm0zMXVJSjFuZno1NVdDK1JJMFllemlmNm9iQXNp?=
 =?utf-8?B?TWRzcWE0cWtMU1JCb1ZzU1FRMHE3cG1GeGxRY05qdmtUZFdKZTAvamk3Q082?=
 =?utf-8?B?SFNycCszT1NVNktlOXYxbHJmMFg2TS9HamQyZmlhbTdSS2Npb200MktYcUcx?=
 =?utf-8?B?TFA3QWxSbWJpUHRyYVUyQmxKUGNJa1MzN0lGN1F1am9hTVRmeXV3WDFMc21J?=
 =?utf-8?B?QnNwN2hGcU1RU0xSdURkd2g0MmQyMDMydWwxdm13eS9ad1R5M1BuUmp2czk4?=
 =?utf-8?B?Q21tYnVkRy96WlNkZVJpTWt0K2owdnIvc2lqSmg1Z0V6dFhMU25XQ21hL0RX?=
 =?utf-8?B?RlRFV3Z4Nk5LTW9iMjdLRDd1SjhUSzdNeWFQSmw2VmlHWU92RHNmRmpQY1J0?=
 =?utf-8?B?U1hYMmNLWmxOVm45S0d1YnFnbjNBMlJzdHZEcCtLdWlKMEpvamorMXNuWnRD?=
 =?utf-8?B?VHFLMDhidmdaSUVRQjZLUmlDOHRORG1oeWhPcFR2NmEzTWFuTkZzSWtxV2hP?=
 =?utf-8?B?RlJnN0p6WVJIa1N6bU1mNXYrNjZEOVp0MzViT0wrWnJISkxtLzUrUS90dDlU?=
 =?utf-8?B?NEFnTUYxNm81eEdWNFpXb0hMaUtUQTQzdEdmN3ovOEpCVUNhQ0pWSFNmVWpm?=
 =?utf-8?B?bzZaQmFlVUxVdFlpSGtyZGtEMnluK24vbVlHV0N2T292YUVYUkNFVlZ2NjF2?=
 =?utf-8?B?YWUzYlNsU0NsYWRhQkFNeDVucTZtRjVJek9pMU1zMCtjeUU5ZngzOStVRHZx?=
 =?utf-8?B?ZTdlcEhVVzJwcE9xdFFzQTVwZW0zdkdtVGFDT3lYdGJoTkVrc0M3SUNRNXZ0?=
 =?utf-8?B?N0pEVmNqSEl3WXdXQUJlVC9qSUVWK3FLZlJhUW5UcjI2SW9DanIrb2FudEtv?=
 =?utf-8?B?T1ozc0hNMEtqS0NZTkQ2OG5KS21lLzNQWTZUNy8vOFJWWGNYOUZVMXB3WExW?=
 =?utf-8?B?U1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Ff1wB665R22dHR8YXE7bC0bJWOLMikGvC7g3x5MUNAXsWNuDtGdLeKOgiQhAtnEjjs+G2v9RGEG1uHiSeKMpparrb4FKlcK7xCdq3CIEK2QHReRydTpoabgNJNktBwsQgsFMTrVz03r5V73FieRO8DKFKB3DfqLn6af30uc/dlD1QwhxSWF5w11YOpGk/byxj/ZcgqTl6H5jojaguyWVXi6mqax9LDBE+Uq/aQJIk9rDbtSvlUZ6nIVIXr3LQWOEyu5Q2ZnVpVJZopjxCvffR/zY9xXwgVeHUpGKCRGr3TV4BG7pP5ybpoBeZSAQQcSMJ6uoZ8hghYOEISBcvp03YW254vdH5uf5BpazGDCYwiXnOOu9HcdIK5rFAn7KN0t7DNnlAOftLgp6zG+XCHUnfZLjWHy6EtPRoqJSfwImFIX96UTUyrR/4okyeY/Hfaq0ESzhYr7ErERbuXA6qE8yyfdW1rnPP74z8JY/a0gpBmMyBQNqjtlOBbWZ+iQ2ZLfxK6TJaGA7estx5IOuZ8tmxo3K2BH3iRvktSORfqJmZ15tuO9sVSbwcdpJ8JUDv+6GjJajQYIJ+Q/0r2QD2SvKgmPA+GA2zscHS21ZTXKH8d04TXqsZ+rKm9ALKGGUPvU+XfMrI9YjL3Fc+RpnS1bWtaNyX7gJ9oclcrvPrzGErf9Y8V7ljHtG+J+F+5/LufiNoXjMIpwoQk44OlxMDR01MwhAJRpVOJgcEpvxfAayOjM6Z3IkbvKFzlP/x3VrdwUJbLLaV5b+WCAVBK5L1+5Oa0r1QW/7ufTCJLRfYl9dofY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5287fb0-d9a7-4b77-55ce-08db987794c1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 01:25:56.8366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yi8xK9TyGipvJTIsJXsH1zJPmERkWNLNAROsOUv9alRE+8zsIxJdTm8jz9OBEt62UBsB8h56EMZHzJKN2OEQKs9DXgSSrcv/yVMhVap1T/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4137
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-08_24,2023-08-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=697 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308090011
X-Proofpoint-ORIG-GUID: bjiNgK19I9ZEF25hwYq433J1o0vyZ3hH
X-Proofpoint-GUID: bjiNgK19I9ZEF25hwYq433J1o0vyZ3hH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Ranjan,

> But for few registers zero may be a valid value and we don=E2=80=99t want
> those registers to get penalized with 30 read retries where 1/3 reads
> would have sufficed.

If 0 is a valid register value you'll end up always doing 3 retries
before returning. Even if the first register reads were "successful".
Peculiar!

--=20
Martin K. Petersen	Oracle Linux Engineering
