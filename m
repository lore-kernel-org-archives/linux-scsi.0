Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 561BFC25B0F
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 03:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbiHLDnc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 23:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbiHLDna (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 23:43:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADCB4E85D;
        Thu, 11 Aug 2022 20:43:29 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BN6fBk023117;
        Fri, 12 Aug 2022 03:43:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=CJQ24cAnAITJRwlhxB23CRAGtZRaofPQAEmNyA/4EP0=;
 b=lsJ2Eru6higYcmN1KK60F/02tAIDXFJpQH8PBlgCjGyrDJrHUhVrf6FYdInDPKTwSci5
 JcFLdvm563utHbjkK0YhiRnuq45LsDppWGbLVHyoAmCsISuIml0EW+2OSsAwTeOVgIJ8
 qk+CP7t+wjtLapDkWgjIC3uOjXAx872eN7hv9soPRWGdhYfxwSCpjTegdvC8AakTh2G0
 dpnJ88bvCw67LyQB8yJPS/RP4Dfo6ewiMJJoF7j244r5c45LYc7Wem8v+QncHhMStbQa
 J/2T9WE2jc1U1f6vpWOHvcf3Tm2d5PoTYaEklPEWI2iua8fa3cCNx6dxhpumg+orLgcf ww== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqj6a9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 03:43:29 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27C04Piw035254;
        Fri, 12 Aug 2022 03:43:27 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqksm8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 03:43:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SSLPQ4VPBOzERa5TGkozmZmfgGf4yqJVQIO4HSAyUWjf0vRnT1ie3ZE6Z67f6ikidqDI7woIfzrl0GUtEk7c9ncxSjLveCsMzy60CcR3rXV1ecwCvTjYl+f0NkWY5fTQJQDOI53LdN9/EPcuqvGnFLPXbI5sbi6+YHOwtETlzFhTJFXCdlFByrm9/BgeXWEh5v7uNAsvR8thq/o1hthII/aNlb1AqAyPLl3Mw1Svzscu9s9rm6kESjPjiMnwfiJts8lRP4gI56Izbi6Wrcq9pKTqmWoilxTjb1ckL9N0kzLd1WzS7T9RwH1jeSTAcu8YL8f/O/EgMAxKYDECuVSbYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CJQ24cAnAITJRwlhxB23CRAGtZRaofPQAEmNyA/4EP0=;
 b=glpKGAGhWy5CqEMmtkqAE5FgYUr3gRCwWt2hZ120WRYUYw4DCtUQ5AiAUzKw4qTeIhKZPgNQ9lInYa6lHo7STP+6GHITelHsTNTCwG5d6hczfSfd+quJCAbDg42pftxKjxaEaxWLeOuKlns5xwb0ervLjFSfvSS/L472LRh53JH2SEFRxW5Ah3PETkjxLKpS4fgCh2IOJLfDyHZmY3cbJROOa2USrkk5e8VYzvhEbUFY/Z06lj2m5zWxJjkY/CYG9s0MPeuSfIPhWzEXqmg/Gx8wF/saoJqCinqrEUbqZpf+Lzhjm+t4bkuD234/ZfdL/vV0ytHx88ivOSKS1knBIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CJQ24cAnAITJRwlhxB23CRAGtZRaofPQAEmNyA/4EP0=;
 b=l1Fid2oaMxMQdq6N+sS5IHcc3cQQy9OnVBfmGkzO+rwPOwycO6hewlVPdZ8IWyySP5+fKQalGrZi4Svjw8WEuYi/YQQZJEtizdp5bhg+LYnNzu0EtRgauYQGMrNVHkbRD+Io4R6KSnxiMB80Ey8V20eOLy1EjAbihClokplS3xY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4171.namprd10.prod.outlook.com (2603:10b6:5:21f::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.16; Fri, 12 Aug 2022 03:43:25 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.025; Fri, 12 Aug 2022
 03:43:25 +0000
Message-ID: <479fd36d-7084-f37b-a2ab-f82105278cad@oracle.com>
Date:   Thu, 11 Aug 2022 22:43:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH 4/6] scsi: target: core: add emulate_rsoc attribute
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20220718120117.4435-1-d.bogdanov@yadro.com>
 <20220718120117.4435-5-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220718120117.4435-5-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR05CA0023.namprd05.prod.outlook.com (2603:10b6:610::36)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cec849f6-75e0-4c70-18c2-08da7c14cfdd
X-MS-TrafficTypeDiagnostic: DM6PR10MB4171:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q2U6g6yjpmylGr2eO3m2xCRdDWUCIaW8FPAnKvMMvRCwfP2xeuUZTP6SxSrUrDq9+5dtKvViRFB5T/4k4Ap0twepGCCEUoXz/48cAzQ/P+2dHq8gHOpDLEqRFjyzhXSmoMgr2ppRlAMV6dCAHn2YDppCGF9v80QKnGaTpH+7YNbySe0j23E/LaikmsYXKu3jbukk+kLoTAt3Szmu48la9aTdEMO80pCGmgZOcJU/ekY+Gv6a/8T44tpRSBlg/+iZcIlvqBA56Pl5r7VGvLBzNk0Q52uxyiL97WV2GpPe5AcCxIs6Mn42+Hd2Li/Ca2Wkkf3PRCZD4anN5myUv4oR+G5RbhSXHKzE3aTMXWrc0gLiK7uNaA7JsFwrHyf6s6Rdyrtq8wk+8ZTXderK9q0O4EusAG2LsK+DPJrMXtJZZ787M3qM3eoTpFwJiaBcCDfGnfwe7uMSvD3b69TEAjdl+j0NRzi2O+j117rhzd/d50opZ0knnW3fqys8X8zGumQWKgPhByP2dEhl2pezPs3Kjhtqskmzfav2uagT04bhQfYACjYtvLIplI9Mq/oCrwVW3SezuvtfNoaD8yIDtV1BP9WOtDDn9kK/rBmj6gxw30NHWU39BT35RlPsckFHJDXO7ARnqrVW1KnzFPEdoftsdtBcpgtkQeMmnWLKCT7W4GqMkVCEwbhp3V29AhnJfzFbONfyXWJCeTFQ7r6/Edfux1wF7ZFwxpG1hGxzDdx/8RaB6xDL/gtEXdMCZPFKOFpY0FZsj3wCYFcFaoSHz0ujAPrGHeJZiCthnKRaxaP8T15F+DLnWjlEmnzeOJ2QzZGx41sQ8g+hHaONDeD/148CffnMUfvTQaZjhObNCff5ezBkfPm0KDqD855Urp3W/E5U
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(396003)(39860400002)(366004)(376002)(53546011)(26005)(6512007)(36756003)(41300700001)(5660300002)(2906002)(6506007)(478600001)(31686004)(6486002)(66556008)(38100700002)(66476007)(8936002)(66946007)(8676002)(2616005)(86362001)(110136005)(31696002)(4326008)(316002)(186003)(558084003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3Z6UHB4N3FJMWdhQkpHY0M2d01IcWNPVnhGTEdQSmtOWUtzQk5ESEY2aUtO?=
 =?utf-8?B?MVZUMThBYVRCK1hLemFiang5N1F6RWhVdVNNbEg2RE02VGttTnRSR1ZkQmlM?=
 =?utf-8?B?R1hGQ25hcUR6RFd6TjQrcDJjczZTcnppREh1MytHZFZ0SmFnaXZiU1ppVnpG?=
 =?utf-8?B?dDNGSG1BRTlnQ2x6bkV0SW1HVU9WSVQyRkVUQStSWFRuKzhvQ1BEWE51T2Ni?=
 =?utf-8?B?VHhHdGhZM0FDV2p3eGpSUncvdW1lRll2TlQrYVVqaVdGUDJDUzRWWmlCMHI3?=
 =?utf-8?B?Z1F5bkh1NDBZRVdLNkU2QktaM2NHUklXajFJZFRJUG5qUnBFc3pUQTFzanpS?=
 =?utf-8?B?WVVLTC9kbi85b0NLRmt2RmV4VGtvRWRpM1JLalRiRWpTajN6NVJLaWlUdko3?=
 =?utf-8?B?clhlSjBsbjl3WnVBRWdSbEFvU0pvTU16YVo5RTZMcU5pR2VZaDJFRytmYlY4?=
 =?utf-8?B?ZUJ0YVVoeGVVV2pRbjZPWFR2aS9LZ0hEZkJqL0QvWkdVUmtiMUVPK3BYbWd6?=
 =?utf-8?B?aWZha1d0SUtNaVk4NGpVRXlXTFBzZnY3Mll6UXF5aEZodlhPYWJzMUdwVXo2?=
 =?utf-8?B?Wk5wblRPR01RNGFTYXNpbDhGVVdRTWdFWXNRMkNBMHJVQVZQaU5aTnRUTkEz?=
 =?utf-8?B?MDBQNUcxbXpUejNFSHo1dWY0cjFnaTZQNjQrME9VcXpIWE5CL1BvMVNRci9M?=
 =?utf-8?B?UWsvbERPaW94MllSdCtnREN0dUFhWW9KakpvWnpudjAzK2hGU2U1YUFlSVJo?=
 =?utf-8?B?NzJGaS8zRCtMUng0ejlzZ1N6OEp6Wm1veWRsaFVxRGowNE53MUVRWFdxRGxJ?=
 =?utf-8?B?VUNCalFiUVFZNW9SSUhzOTZxMnozdWpaRTJ5Qi9IOURzcCtUTHAyZDZhamll?=
 =?utf-8?B?cXRWSlRXSFJNaEJWek8yNFNYbmVHZzhHL0lpMjd6ZjYwNWdjV2w4Yk1aaGdJ?=
 =?utf-8?B?WTNEVHFhLzRjSDFIUzlORmthdHJtNGhTcDZIVDRxWW5HUS9RY3RwZFZjeGlQ?=
 =?utf-8?B?Tll0VTJOWWJyWG52amNNYi9ITFJyRUpVTHNrZTBUVWExQ2R5ZkxyRzlWTHo3?=
 =?utf-8?B?U2R2dmFCRVV6ckxJNmNXTWphRUN0dDk0czBUbVQrSU9KMWw4TzM0Y3Zuc2FM?=
 =?utf-8?B?VzFoMFVLUi9SbzJ0Z3daOTdkUHhheDg1aWtDV21aL0hUM3lWZGNvWXFQd1Vs?=
 =?utf-8?B?STdCNGxlUFJlc1I3WHh5ZUlHTURJT0lxenVlNit3UjNvK3hrZ3cxTms4cUdB?=
 =?utf-8?B?MFVlcHVFek5rdnA3dFFhcnRTTDF2SnhYM0lZdUYwNzB2dmpITG9FbjJSQkFh?=
 =?utf-8?B?ZUJ3SnYvR2xYVEFtWmpQVWZDZTNBWVh2L3dENEE5V3pxbWdMb1VXOE5vUDlC?=
 =?utf-8?B?RTJDZEpnOWFMWUxaTlJhUnFhYmF5WWFCZmxCNkZjaXVlSWs0VmY0bWVPUjgr?=
 =?utf-8?B?aDJVTDhCRHlMM1NNWnluR0VqUVJjWmp5c3ZUTlRSVXkrOEZ5VUFXS2NQT3NW?=
 =?utf-8?B?Q05zbXdXbmovMWlTS21QS01vNkUyZWlDRmFxS2NtREpTMWJ2cUZnZ0JYRzdZ?=
 =?utf-8?B?WTdhdXRuYlJDYUFBSG5lOTFZOHcxZVFXUnhuejd6V1Z4czBrWDZRdzNVZzVt?=
 =?utf-8?B?c1E0NXY0ZDgxTnZ0VXZBR1U5a3h2dzdGSk5NM0JxNDNaYy94NDhQZkxkY1hW?=
 =?utf-8?B?YVdPaTV0blgvWkZienVFSTF4Y2FyTVVGK241RC9DeHAxOG8xcGtzTTBTZHp3?=
 =?utf-8?B?dno4b0hzd1pGL25WclR3bElYTzRKQllnSnRKczRVanVscGR5M0dkVHd0RUF4?=
 =?utf-8?B?cVNrRDRkdFBZYTVyaUpHLzl1QWJnV2JYR1BkN0lIMnBYaFpqT2J6WVhGejdr?=
 =?utf-8?B?NmlhRTVGU3dVWGxpekZvNThldTErM2E4YWJLcTdyMVkzZnFpNGZvbW9pYWlu?=
 =?utf-8?B?TXpGU3lVWFlwQ1E2ZFRaMTBqdTFvNHQ0MnE1WjRIYXZ3cklOT2RNMEl3T1I3?=
 =?utf-8?B?WEFVZDhWTmZodEVtbEJPYXVVb2F2MkZMOU12WDRlZ2hGRFBLdEo4YmZCWUNx?=
 =?utf-8?B?MVJ5L0RubXlTcFRJZkdQbmxzMXhuM2daNFpoSEtaSnJYS2plandmWm1sRHA0?=
 =?utf-8?B?eGJxVkxhSG5LUUN5aVRCTmNObjN2enN1dnZTMmVKMlJaNEkyNU5adzg2Unpj?=
 =?utf-8?B?S0E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cec849f6-75e0-4c70-18c2-08da7c14cfdd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 03:43:25.6160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sr4M9dr/65anXCgfo+hxM+CltzUL4NRp17aDLy+AFMSV96TMHstTkh3rvYDR+545NtJehyHKSAroG6NURcXtuQwSXf+hQqF0JBG22WLbaZI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4171
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-12_02,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 adultscore=0 bulkscore=0 mlxlogscore=987 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208120009
X-Proofpoint-ORIG-GUID: WK_JsYon_1ZA7CTLP0uJ2bQWMxMS7bOj
X-Proofpoint-GUID: WK_JsYon_1ZA7CTLP0uJ2bQWMxMS7bOj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/18/22 7:01 AM, Dmitry Bogdanov wrote:
> Make support of RSOC turned off by emulate_rsoc attibute.
> 

What was the reason for this?

