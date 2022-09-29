Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B094C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 21:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiI2VpC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 17:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiI2Vo7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 17:44:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5344D3D5A6;
        Thu, 29 Sep 2022 14:44:58 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28TKTZ56022963;
        Thu, 29 Sep 2022 21:44:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=jnZDkbaoqmKnu/fDVjf3vHUNmbsuzXmnx12ymJmZHRk=;
 b=19rtq2W+Pa2gmL9OQR7Tdc2PgLNkjNY6ymJV7WQN3iE9jEgdkSgLRSU7YEe8uRuGEKeM
 VFcjmar1PlerB/ogeF0UBzz5JQwAnXP5mn9qKW5DhE8ElK9Nnvp2/tX4tkXMttewsj5+
 XGrvs3Y+caID77D+XSrdTaByTTsKpZRGEfGVSYXHYHQHLNbyOgY0/rgfIPK4smYy7bSz
 fxmR4ousAUtsT2f9lNOenaE8OEPaS7r4fve2NxiF0KNNZ0IntyMKIyqhaA/9IkwvDZYP
 Ub7KLT5FWabSwQMBsR1p8Zl0wY5WLbtu6+nVhwCt6pvjAQUV+eDv5jr6Pv1NVrEbi4hm dA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jstet6nrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 21:44:52 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28TL8x1g002234;
        Thu, 29 Sep 2022 21:44:51 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtps82uc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 21:44:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GHvE7/iiWaWAqLngma8msP6iOC1BnL9nh8PL/zTWvo9EKTYz87tGcqUXZo9pihI2vw5DLnd2qJV+eshvyDp6JfL0Zm5gLtH4QFS+qWawmAJbdKbFyuuSw70PXs4QRhXmsSsJAizfQL1Cp/LBQB6SNk7BqSNLIzIlc8vIAotXKCx+ESPl9Ob6zK3iVTDR0zUy13cwuVyJZkB4cr5eIle3DDINPYWmvSCAlUGA1VerX9TODqqr2zZFJCeA/Fo73aD3hWo9eh+gFhG00bdAODYBs+wzAW9Ea615EGeG7KyxFI5iNZQy4ygkvmLXfIYLlkXJwNEFxViaGPQBPUqRUx9bUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jnZDkbaoqmKnu/fDVjf3vHUNmbsuzXmnx12ymJmZHRk=;
 b=kARNaiOrcis2dZ1/n20i6Krd0JQgCJz441dAadQviMkmFoIgyKeuQye7BxRLq16MMjJrt0Pwr08cB2kbCoXGC9ipBeJmXsRqDIHTpGn/dtp+4AfcSjLd+EuMDKxPX2jpeYl2LFa9b2zv+2FO4ccLMf0193Y98/2OC4HBlHtH2JNUcx4CbqMw8LPAgVsegrCxqCpX2KW3hCuvyvi1ajlgwylonScCK5883BtQu6+PwyHXk5jGddKntqYUFzNzQMlsikFRyzibbPkNA/ZauPKNeo2mLEBLQMwjuCBSe2msCnqV61Q9n7BVmPCaooKndPKHrr+OvL83kcnSyrjT4JNzxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jnZDkbaoqmKnu/fDVjf3vHUNmbsuzXmnx12ymJmZHRk=;
 b=O1GMg+qYalInqxPdd7H3r4CY9yIDXZGzmFxaz6TF7UV6SwwkO62MVt+cg29IhQwjb3ZEvx6n6T64PbXqJBF40YMBkE8syWtG1PIasjh5Yczem63Hvyl+m2RQWoD+x5fZ06JAgnJkW0y9+RmYpeCbLmwvn16I+g3pNMlouao3wCk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4803.namprd10.prod.outlook.com (2603:10b6:303:92::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.20; Thu, 29 Sep 2022 21:44:48 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 21:44:48 +0000
Message-ID: <09f62f4c-8ce8-52bc-7c97-ac73679662f8@oracle.com>
Date:   Thu, 29 Sep 2022 16:44:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 0/4] target: fix bugs in Persistent Reservations
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux@yadro.com
References: <20220909090425.14479-1-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220909090425.14479-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0091.namprd04.prod.outlook.com
 (2603:10b6:610:75::6) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4803:EE_
X-MS-Office365-Filtering-Correlation-Id: 96374cf2-0f9c-4a7f-aadb-08daa263d4cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OJ1Efb5IhqnZnI8BcdVWcNPt05GHaQX0bZPV3fbBBQHv2trCcV98hgxKBTHi9Ez1FfWYU4Ijlocag9qyxm+1GYIvpEajrjWuRvKjY+CtMPSC/hHZK5ioPNjqGBCXTuoVB8tbqHjZrFwq9UjM4N26saifnY2y0qvg9fOdV3cDe99GmQbVicSJGu20vUrpANcXUD2UdWfbATlrkfdECg5q1zyr6ZSsVR82cLj09cotjP4FPbQd5okJoTgzaW/S+eEcd3Oefbt8O04oFIlRaIafKuMFDfyfJFRKFf1drRt6CayDS/3+iXLeUBFsAEOWlILbgOTwn4yxUNRySJiltInzOLmux65A+eGK8gI3mo/u4n2DlrJHocNsvImwLAzdogyn/2/TyMs6IWAe4D85/fX0oBdn9Col2o0zdfIxb7G4S9gr8qxtP3PaM1N3TU0aWkrGN3anIzinR/iAeB45OztCVzIwgVOWEBilWZ1GM6n2R0+g6qTLE3OU5yU3wp/uQ8AcrXA7xsZ2v1wqWQ6CI7B4pB1+K/XwvQtzyutl0u2ObJWVyIjJbyENckpB3hAvkFA5VpGaOgF9mG1liYeDvrpMvVIYC/SzOPfIH/C69nKXL43vKj8fujbKXlkw8RpAa0Tx3rOqu5x45PoqcVjDlF6614xFshEpn+Tur74WIO9gfx46Ntck5+RU4Mw4ZONTY9U6gCWDt3NX8PEFCeoucXME+AKYXFQ9G0vTzzV4x/LJuYz4UAlayz/9BCGlKJX/utcHe8NN38ajnHXrSMK58zbqIf5lhAOHzY+WSixEmuG0k0U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199015)(8936002)(186003)(2616005)(36756003)(53546011)(4744005)(26005)(86362001)(6506007)(66946007)(66556008)(66476007)(8676002)(6512007)(4326008)(110136005)(38100700002)(316002)(31696002)(478600001)(5660300002)(41300700001)(6486002)(83380400001)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGpFaDZjNk9NTXdiblJlSkFtM2hoTE54M2ZXMDdGeVZTR1J5VXhoWGdYc0I1?=
 =?utf-8?B?S2pXakdtRTE1cXRObGVpSUc0aGhuTHZhdjN5SEVWTlpzTExrMWFubGpRemtj?=
 =?utf-8?B?bysvYlgxQlZXZWl3bUdZNEhoNDVJeWxlZTN2cU5ndkE0NHRsaDNHUm01cURw?=
 =?utf-8?B?UTN5TUJaMXV2V1hvSTlCRVUvMEI3R1FZYjZYQytCOHpqaEdyVjJMQ3B5VThn?=
 =?utf-8?B?NzZPMnkxZ3BOMC9BcG5kQU8yV1E4dXAyYmh2emtCc3IxN2NqV2o3WDhzMTA1?=
 =?utf-8?B?S0ZLUi9Sa0lpaEQ3bXV5T2p5czJUdW1UTHVjNTVhSHRMY3BXZ1lFQldiZzJT?=
 =?utf-8?B?Q3VWbU5aOXArdERYeWQ0QjlTdjZPekZ2QjRCK2Irc3VHUW5XMFo5Y3gzYmlC?=
 =?utf-8?B?a2ExMGlVMk1FZVcyVHcyRG1RRDkvTzhEaEtlYTIyRnp1eDFjYVNEZ0R0d1RU?=
 =?utf-8?B?cW50anNRSzNwMkptdEVSK0JhWEM5MGltcFBPNXJlQXNVc0g4OXFMMGg2b3JC?=
 =?utf-8?B?RUN5VlRXWHM3OUpWd2xiMVRrWThKaGFML1JpRm45ZGxhdEQzSFRrN21VOTFR?=
 =?utf-8?B?MThjTi9KNVhubkZBcEVibE5mWmMxNktIcXRic1lMdUN4VDdEMkhCeFE2bkhm?=
 =?utf-8?B?ZnFIMVp2RjZqaVovem5VWDB2Q0dNT3NwRThIVDVzWEFaTitqQ2FPNEY4YUJp?=
 =?utf-8?B?QXZ5d1ZFd1lEL3NCRnBPTVBrd3hEMHpBcWhnS2xsY1NkZkp1NGYrVFM2U3h5?=
 =?utf-8?B?U1VHUWtNMXZ4Uzg1bVF2NlVjY1NGaDcxNEs4Wkc4NGd3eUd1NzhmK1hMTmVt?=
 =?utf-8?B?dnAycTZHbTYvUVV5R0kwVmtjQUhtdktjWDNSRmc3TVlNS2x6K0xFUDhURE9o?=
 =?utf-8?B?b25INUxTOFEvWHpoMnh1QW90NzJZVnJtYUJTRW0rZzhJQUl2Q0Fkd0NJUlJY?=
 =?utf-8?B?Q3ZaalJYZGt2eVgrWVNXY1h5QWc2MnVFVU9aR1RsTjlmOWRCNHU1OWVLUU9q?=
 =?utf-8?B?ektEUUs2K0h4bTJONFdCKzhzTy9TOEpXN3NrMGxOUUJzYm9HazBVUzdXQ0Z3?=
 =?utf-8?B?dEVDNHdZbHhydlpzblk3RHdwR0c1bVpYVVdnZ283emowSUxmVFhlVVZGM2xI?=
 =?utf-8?B?d3ltT0I0VndFYUx3NFArMFU3SzNKTUUxR0xGL3liU3VJZ0pUSG54SWRKL0ht?=
 =?utf-8?B?KzBNU29ESTB1K29xcU85V05GMEI5T0dDdjcrY01sUzJOR25mYVV4akE0d0V3?=
 =?utf-8?B?SFRyczZxeGVVVll4R3ZTSkowT1dPYWY1azhMWWxHZlZQaEM4anlIWC96cFcw?=
 =?utf-8?B?Mm1GdDFnY2EvQzVGcmJQTHF2WGU0VU40RFUvNlpFUFZaTWEyUFlXRk9wNlQ3?=
 =?utf-8?B?NmY1VWkyRWRKcG1zQmhlR01vMkhIMzlkRmxVTHcrd1FsRm1yNFJLdGZIZzJk?=
 =?utf-8?B?N2hXeElPQkxDNm96cEhvaDNzdElxVDRtWHp4dTdvNCt4dTg1ME1QS1BHdjBw?=
 =?utf-8?B?OFR6TlpUcDNabDN5QkhuU29XVWtQa1M3b1puRncrSDBJLzN4U1dZTzdYOHly?=
 =?utf-8?B?dWxaZGdHbytNVEdVbnZHU0hGU1F6U1N6RzhsS0ZtQ3RIVHhWWW1vcjIybTVD?=
 =?utf-8?B?OEFjNWk1MERMSzR1L1hBWFNwckZGOHRvSlJvcjBUZlYxNGNLSyt5NjV4TVc4?=
 =?utf-8?B?S0RsdCtORm5rMDJhNncwaCtwcVJqNFFoZUJoYzFFT0NkN0VkUUhkWG12K25G?=
 =?utf-8?B?NE5XUTJlYlFycTZBSS91cFhOZEVHc0FJZFFkaVN2SnovUjVRbHgwb0djakZl?=
 =?utf-8?B?QUk0RVFsN3ZHZERsSS82bVpuTm5iRkszelFFcTFRS0JkaUpDd1d6ODFXZG16?=
 =?utf-8?B?NlprNzBNQndEZE92cW5KRWYzWXdZQUpZS0JLR2toR3o1S0x5eGlyVG9CM3B5?=
 =?utf-8?B?SzcvVjFwd1B5SFR3VkptNnpzMklLdi9taFk3aDFxN284TW1VN3hHVWZYVGVW?=
 =?utf-8?B?QTdoL29iZ0ZpdDFmU282UzhNVVZDc1llMDEvOThnTDJtSSs0cjF2eUpscTd4?=
 =?utf-8?B?U2FDLzZYUm9MQ2FzeW9GbHJEZkozMGhHaTloT2puTmJUT2pyYVhzbmRyTkhh?=
 =?utf-8?B?WDRGSXJxd3ZqNk5FS3VnUjRnNE5JcjVtWGNVRXBSc2IyalYxTWZRanpteEp5?=
 =?utf-8?B?Y1E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96374cf2-0f9c-4a7f-aadb-08daa263d4cd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 21:44:48.5025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VmBK8Ov/FCwfda/SABrmxdm5N/wGiFX7JNWx/SbUL7t+ZcuKiebv771CwSu/RHBfcPJFMa9Fm73XE8J0slQI4yKxbxzmG4q3LHpl8LShtD0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4803
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_13,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=973 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209290137
X-Proofpoint-GUID: VYk-xQBCX1pTYlGOp6fl6ptOoWpHmXW9
X-Proofpoint-ORIG-GUID: VYk-xQBCX1pTYlGOp6fl6ptOoWpHmXW9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/9/22 4:04 AM, Dmitry Bogdanov wrote:
> This patch set fixes few rare bugs and deviations from standard in
> PREEMPT AND ABORT and REGISTER AND MOVE operations.
> 
> v2:
>   remove superfluous parentheses
>   fix indentation
> 
> Dmitry Bogdanov (4):
>   target: core: fix preempt and abort for allreg res
>   target: core: fix memory leak in preempt_and_abort
>   target: core: abort all preempted regs if requested
>   target: core: new key must be used for moved PR


Reviewed-by: Mike Christie <michael.christie@oracle.com>
