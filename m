Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EECBBC6FD1D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Mar 2023 21:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbjCOVmh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 17:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbjCOVmf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 17:42:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07FD3E63E;
        Wed, 15 Mar 2023 14:42:33 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FLeHtw016369;
        Wed, 15 Mar 2023 21:42:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=SBv1blB3iu8Ff29VRigtFtVujx1nCdcs5o+juWcMxog=;
 b=LCbsFssI4Je9IU6LamKnCfwmf/JOO2w/hD7Bv6FAnBhYnp8sPdR9EeDeywGjz500fg26
 UP0J3CDyJ5Uk8UFFqJw8sX0UoyhPged+Mr47PAXTkcMG29IX4a4/KcmC2Tf+HRL4zRXH
 0VL66SXO8ae0/6KaRG7YuUyXXRttjiyhxqU7+SMSzhkpajCK4DKQ2D6L76D7juQ1ecoy
 yT6CjQAOiUvcGb+KFRcCr6weC0Cv4EzepDgsnsHbBn+eO1v3Mo75GO7omTjIV19R2qpL
 XspKsXaVvxg+2mmbb99Xgk7Mrd4QEUhNFBTJ3iZZGBrUJhJrRxgPbvNhIiCVKHaQ60sv SA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbp4sr02x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 21:42:25 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32FKkieY014326;
        Wed, 15 Mar 2023 21:42:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pbnbt1syu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 21:42:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZSvth6YdkXibECQJMnuZ8Fgn/2q1LfMXM/l9+iYpuEix62rjBR/FpTQa0yG7MO5JX7HLWwJMnsBP6ltok3EtTKSOQd5DsxsDvOWP+qxGvZFtxymkROayeJjYAc9DX4p5YXuPVsMEfAEVpbeSwtyWD5fBq+i8i9MWUyloBqu4HcyVEnr5kRjQheK7Ze7Vkopb2l8rYpnA1Oe3wvmS/DBtVa4HYxG+KTzJu7aD1gvxnK9w1kQ4QbEbH+bsiKZYSND5gOUCoP+FfpQP9vscmEZd6+zy2S/AN/uI3mi7UJiszzmHvov2jw9nKrCLaiMHyZIkWFAvFh4Upf5lILXLb04pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SBv1blB3iu8Ff29VRigtFtVujx1nCdcs5o+juWcMxog=;
 b=QYqxCCe+6CmmHve4bPWI3viW/MYojkEWSOY8kR4fSwoomM3oiQ+/L60uFHk14nI8++M+Q+GytIz+vI5mIKj8TGMuErsNSN5ViNAqs9wmQtxKo7/3e885UqMV8m8JXtjGn46xjr4PXPcv0pi9Bm8EcFU2Qi+ddE5lyb80V4HaFkHyvB9kq8dszSS1r7Peqa+GGeuALKlTHCIN0FdUDYPhXIaJQrVqYnALwwiPqNYNyJHHe17z2AHAkhndYNjQGyXu2wQF7/15r4P3urK1zt0pNZT7dY7WZICNDH2O96iFrrDQs/BpaRGI9+oNc7HXhPvDgcCjCeGn6HRsaa2/O40tSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBv1blB3iu8Ff29VRigtFtVujx1nCdcs5o+juWcMxog=;
 b=PFOWbJ9qg1NCcNcWK2GzqdWzv5vaHL5CS4c/FXSwrcxX56nBu3ZioK9HmnrDYUei/4rnIa9KaFEvSiVqMypOg6p+00hG9VmuDDVUhKBlhBp4p15woa6QQaRGo4T3pezAyiL4riNr0QR6c3du9d9xWO60CUlFMy8tKBAp2Nkoie0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5566.namprd10.prod.outlook.com (2603:10b6:a03:3d0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 21:42:21 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 21:42:21 +0000
Message-ID: <5a1c2ac4-d7cd-b7fe-cc74-7e58e8fca968@oracle.com>
Date:   Wed, 15 Mar 2023 16:42:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 13/18] scsi: target: Fix multiple LUN_RESET handling
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20230309223312.94595-1-michael.christie@oracle.com>
 <20230309223312.94595-14-michael.christie@oracle.com>
 <20230315161301.GE1031@yadro.com>
 <50afe378-c0e8-7914-377e-ae8c91f82455@oracle.com>
 <20230315191141.GF1031@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230315191141.GF1031@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0214.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::9) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB5566:EE_
X-MS-Office365-Filtering-Correlation-Id: b213c83f-9d43-47bc-eb73-08db259e27de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: opmsc9Lu1Es5i6Korbu9ftSTy8m7MZadh9CbBRcFVmGxFhFljRsdVQtiOKDxMX2zU2JCJPRQC6hiNUfwgMRwZ4ELpAv5p1814TicKgXwbpM+JClaXXA/xbTnyNpl5OwzAeC8tpOTAfMiRHm3pjwOe2GvL/M6AWe6ApMQmIY/cCvsEoLlGtjnFCpkod6HF6H55yggN8AP14waQQePepl8AD40f87taT07MXgZMseIl5q4GsxbD9G9tPG8d4l7fXrrC8b4sdkEfU65C7yoDn67n12Qh8pG2FZDS6eMCNMvU6Jl0OAwJAxZwUmVjh4/+R923UpWYYDGklczuEiwuQ9S2E0SX+yXt6G05Ixn6XYt63G/wUFssIemzJmF5CQ9m1lNJozNV0wGKE8OKtDe1ooA6HzC0p7iNzgT6Ro6dc1poDULAcTxo2ggNqvYHdGqBTQodTOF8gmh2tjEBoYu5HQo3U1cLSMGsNTKRQmshBLPLpwbpMSENMzBtPwNNy/1XC3nglZOcA0ypXjuq35b04gpmFq8yrH4cRV5CygbLc63GNSENMmj9j86i1gCLnvShO91vB66JRHtbDdvy2VLc60r+Irs9q4xS8F7c9Og4enjanSKz3sQZ3i6Ou6nfNHZltFJ7Zu4q+FPtCqZmgKE5cTDfXKwEDCOm7+aY3Ow66Q4DOQ2djLqDO/xrYrPHpLKiifrNzJrJtGPgRsDRzypc2wgXi2jSwclsx6N9lqHYX3j6cE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199018)(31686004)(8936002)(5660300002)(41300700001)(2906002)(31696002)(36756003)(86362001)(38100700002)(478600001)(66556008)(66476007)(8676002)(66946007)(6486002)(6916009)(4326008)(316002)(83380400001)(186003)(53546011)(2616005)(6512007)(26005)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VlgxKzJ0OVBZVDI0Nld5ZzMvak1zZFZPVHBXdGVYckdneGRucCtLMDlNaUF0?=
 =?utf-8?B?V085SlVKNWNEV2JVc1ZKQXM4UjFkU3ZnQmxHSUF6b05LeFhUVlAxNGswV0Zt?=
 =?utf-8?B?UktFS1VMaWFnSitCRVhrYmNUZk1Cc0pjZE5nOE56U25DNWxIQVJkZk5CZURn?=
 =?utf-8?B?V2FIZmdIQnhsdE9tWDJ5WXdtajlNcUZBSGhHZmlPSk9FWGVYVnRUeWNOL0RO?=
 =?utf-8?B?Ulo3cm9pYmJBUVFUWmViUWZ5Z2w5QzBiVUgyRjRZUi9HYzRqRVJvTGJCUGlH?=
 =?utf-8?B?TGV4WVpkb3lMakRHaGZ2Nyt5bS9JYWRaTmVvYkt2WWluMG5IMUVSZ0IySzFU?=
 =?utf-8?B?TkNhSFhGQnlQWVR5YjVsaTJ5YVJ4Vi9XUi9wSlY1am9XRURFSWplUGlTQlcw?=
 =?utf-8?B?Nmk5MjdFTkd6UjZDY05NOEw3dDJmZmlvUVJIVWg5eXl6T09XQkNvdEF1bVhD?=
 =?utf-8?B?OWJMb0taaC9wc0FVbTB0enhHOWNFMGJWcGVEU3Zjek81MENMcGNIODlmOU9S?=
 =?utf-8?B?WkVNUGpUYU0vTHJyWEZBUGNCVVpFbHhGRVl4YUMyb1JiWnk3TFFxdnkzdXps?=
 =?utf-8?B?cTM3dGJxekVMZDhrOUNyL2ZFd1N1L0o1T05vRWNwMVg2ejlWS3JuVHMzcTR3?=
 =?utf-8?B?cVFIZGZYRTlhYm1uVDIvT3VtazhnVGtuYWdVZmtTeUE5N0RZZkJuN0lmNnZs?=
 =?utf-8?B?bHhsTXk1NjdNRkMyNFIrM1NzMnpkZVpxclJBY2VFWnpGclVyTTZndmY0MU9G?=
 =?utf-8?B?bVZ5ekRxZThBRSswZ3prWG90Q1dLdHdreFlweHhvT0FjTUdMODlwRHVNRmNY?=
 =?utf-8?B?QlJ1VDV0MnpHNlg5RVRiTWkrSXJ5QUZIYWs5eVJtVzcwZlZlQWJnSU5sdUNu?=
 =?utf-8?B?Q0FCYXdWdkpCa1pSaWMvSVpPbVZwVUhCU1RFK0hlc2JCckFkMFhFOFR4ZFNU?=
 =?utf-8?B?M2ErM2p3Y1JPblZjeXpBTmJBZ2pSZGlZNXAzUnd6ZzJhOWIrazQzMXFtb04x?=
 =?utf-8?B?VTJHeStxL1BGN2lKNnhUWHVsbGNjaFVYME0zODQyaEwvcndLUWNSdk4rcjJG?=
 =?utf-8?B?MkRRUzFpMmlpbGhURFJJdEVUTWxDVlMwK2wwOGZTSnlrYlRXdkFOcFpXMXJI?=
 =?utf-8?B?OTFFam9qamlzeGJFZTAxMDNiU3lQRDFrV0dCN3pSbnFTMGdlTFREM0FvblNH?=
 =?utf-8?B?akgybFNIVHhickhPYUxqRklIejhJeE9EaUtNS3pMYU9vSjNIWVFGeE5CZGdq?=
 =?utf-8?B?WWo5NURXQ01ZOXQyT05IZkZLcWhNTjBSYzc3a0lKaGxiVXFsRC8wN3JkNmtu?=
 =?utf-8?B?Y1dwTWVIRTU2cmljRHVVS0hHZndDYzdUTzdvNjBPSWlCeGk3TzhBSlVRZWU3?=
 =?utf-8?B?RXE5cUJjdlJsUzJCTG1oTmcxNkExeHZOeGhZR25McnFQUnNEUG1Rb3FOU05T?=
 =?utf-8?B?NnVDV1E5MmlndEUvby9Sd0VleDJ3UVV1dEFNRzdBR3c1dHlwOG8vdStLSXli?=
 =?utf-8?B?djhBRjdVWUNNZHlibnlIQjVtRVU1bFp2QzYxbWx2R052bzUvL0FQUWYzL25M?=
 =?utf-8?B?SDdNaG1GSlJPd0FXTktnNTJNSEhGSjVBMjArL0ZVU0JiYkFROE5nT29CQXNK?=
 =?utf-8?B?NTQ2dVVZQmN4dU5qSmhiR1JQaDRLS2hwMDZFemxwZ1NUZWltTmQzNkl0Q2p6?=
 =?utf-8?B?RnRvcXBOd01zd0FOdFNYOUxJdmxwOTM5MVRVem9Qd3RlOEpoZmJVUGpTa3hY?=
 =?utf-8?B?RUl6N29DMStNLzhQTms2eGU0WWc3bXFLTGdEYndxRkJFWWppaHVicndHUDJx?=
 =?utf-8?B?UWhoZTl4VUJYNVkrdHVNZ0FBSHYxRE9NVUVNeEFtK204dmFaTzR3dmRMVzZ1?=
 =?utf-8?B?bjFTT2FTN0tYTUJON1AwMmNUQ0RLZ1pRcndoWnE5eUdMV1pmbm1FNGdpSnow?=
 =?utf-8?B?QnJOdk9ZeklSNSt1U1UzSXl1c2dHbmgreUttbStkOERUR2IwYm5sbDIyS3l0?=
 =?utf-8?B?UGgwajdMTFlBMzJuRnJleFJ0ZU9ySjhlc09nd05nLzYxblJMU0FTWC9QV1RH?=
 =?utf-8?B?VUMyWGFlS1pmVUJoaTFVaHRLQVA2c09HS1dJWXJ2eHhlamJ4Z1NTNExWQ3RR?=
 =?utf-8?B?bkwxYVNMbGxINjFmdTZ1T1g2a0wra0ZyMkpxQVhYK0lvd1E1cmJYRHVIMUxZ?=
 =?utf-8?B?aFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ks59TU3DfgHKvt/8Y1cG2zqTgj25Dxl+M58vgcw+dsolkWPVcIhiE/EETvu8bbkT0TNchhlpDopNn/aIrWBvuA7lKlk26hmcBmoD4/yQWVQQG6C/FpUMHoMnsf9LIQvVTPpuxJtpgKVoO1gIkN3BRL8DQH+wF6tpB0nc0OZIT6+DySybtttJwgorm4x5oQQ6CJSM2Z3wu4zLrImrXXUJgobFcPVEF2uJA0GfjFTVyJ9T4aRKTbrnkUHWwYaAEZmQkIgMur1k7l/6SfwGVj+F4N1MNAfO7sj4sulsVJOvqaoSUOnHC+rFVdVMNw8f0IRmnk0fSQuUxzbGQEPNOtXywwW/HPoLTDJ1lMOFnF+UyF8JRuS0kxlyiFSIZ7TYujcR6KIERN+TOnFzaADqF+ZLtyj6l0735+YCpqS4X7n1O02QAzoip03iMMT7ys5VgiqhosWy8nCMDLMuLsn94aFn+YgwaZszNDPE7TDP5SVdAYUnGHsSKLdM6TNUnxrvZWei1o6KpcFm81hX3Nx9DZ+K8AfXYwEAskawu5ukePqOQrtBmvrVSNInm3BgOyeDBGkKUArWY7BYHJLCSPsxvchgLlNWO571l1kGmCosIQarL8KWIoE2xlI7YwPgXQzY5NpzVZnQ1XoZCQNHs7f9Q3R+rZG5zY9ssTs9rniyXmqEovUQfEbvCJff1ngA6lDTz0BlFG95w6hz60wf+qMRZ+Pd5utjPDzhVxl7T4VPjcAZE7YUeqS4YsEqscPQas8tVb98VmicWQJFOUsNJnwfwivN6cYSl8hPMKmQbdQFt8R9FVQTNg8T6wI+FmMFp/gJ1w/i589jc7wRbrdJM3JABse07kxGA3BoIYK2gsKZX20HYGor4GuQTpoMZzdFP8ZjozIZ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b213c83f-9d43-47bc-eb73-08db259e27de
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 21:42:20.9694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0rZcYuD70ZXoJf0nceMsJHzPHiqXBtFSSQiAL9CfcGPVmEXmOIOEIvQoHBGRbLT1YqHTWJ0RYp76mhvg29Ei/9cOo4X3gd7LGws1LLHHRck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5566
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_12,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150000
 definitions=main-2303150177
X-Proofpoint-ORIG-GUID: -i2i7F9RqkhRyurAQzQ8SUWNvY-C_SkC
X-Proofpoint-GUID: -i2i7F9RqkhRyurAQzQ8SUWNvY-C_SkC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/15/23 2:11 PM, Dmitry Bogdanov wrote:
> On Wed, Mar 15, 2023 at 11:44:48AM -0500, Mike Christie wrote:
>>
>> On 3/15/23 11:13 AM, Dmitry Bogdanov wrote:
>>> On Thu, Mar 09, 2023 at 04:33:07PM -0600, Mike Christie wrote:
>>>>
>>>> This fixes a bug where an initiator thinks a LUN_RESET has cleaned
>>>> up running commands when it hasn't. The bug was added in:
>>>>
>>>> commit 51ec502a3266 ("target: Delete tmr from list before processing")
>>>>
>>>> The problem occurs when:
>>>>
>>>> 1. We have N IO cmds running in the target layer spread over 2 sessions.
>>>> 2. The initiator sends a LUN_RESET for each session.
>>>> 3. session1's LUN_RESET loops over all the running commands from both
>>>> sessions and moves them to its local drain_task_list.
>>>> 4. session2's LUN_RESET does not see the LUN_RESET from session1 because
>>>> the commit above has it remove itself. session2 also does not see any
>>>> commands since the other reset moved them off the state lists.
>>>> 5. sessions2's LUN_RESET will then complete with a successful response.
>>>> 6. sessions2's inititor believes the running commands on its session are
>>>> now cleaned up due to the successful response and cleans up the running
>>>> commands from its side. It then restarts them.
>>>> 7. The commands do eventually complete on the backend and the target
>>>> starts to return aborted task statuses for them. The initiator will
>>>> either throw a invalid ITT error or might accidentally lookup a new task
>>>> if the ITT has been reallocated already.
>>>>
>>>> This fixes the bug by reverting the patch, and also serializes the
>>>> execution of LUN_RESETs and Preempt and Aborts. The latter is necessary
>>>> because it turns out the commit accidentally fixed a bug where if there
>>>> are 2 LUN RESETs executing they can see each other on the dev_tmr_list,
>>>> put the other one on their local drain list, then end up waiting on each
>>>> other resulting in a deadlock.
>>>
>>> If LUN_RESET is not in TMR list anymore there is no need to serialize
>>> core_tmr_drain_tmr_list.
>>
>> Ah shoot yeah I miswrote that. I meant I needed the serialization for my
>> bug not yours.
> 
> I still did not get why you wrapping core_tmr_drain_*_list by mutex.
> general_tmr_list have only aborts now and they do not wait for other aborts.

Do you mean I don't need the mutex for the bug I originally hit that's described
at the beginning? If your saying I don't need it for 2 resets running at the same
time, I agree. I thought I needed it if we have a RESET and Preempt and Abort:

1. You have 2 sessions. There are no TMRs initially.
2. session1 gets Preempt and Abort. It calls core_tmr_drain_state_list
and takes all the cmds from both sessions and puts them on the local
drain_task_list list.
3. session1 or 2 gets a LUN_RESET, it sees no cmds on the device's
state_lists, and returns success.
4. The initiator thinks the commands were cleaned up by the LUN_RESET.

- It could end up re-using the ITT while the original task being cleaned up is
still running. Then depending on which session got what and if TAS was set, if
the original command completes first then the initiator would think the second
command failed with SAM_STAT_TASK_ABORTED.

- If there was no TAS or the RESET and Preempt and Abort were on the same session
then when we could still hit a bug. We get the RESET response, the initiator might
retry the cmds or fail and the app might retry. The retry might go down a completely
different path on the target (like if hw queue1 was blocked and had the original
command, but this retry goes down hw queue2 due to being received on a different
CPU, so it completes right away). We do some new IO. Then hw queue1 unblocks and
overwrites the new IO.

With the mutex, the LUN_RESET will wait for the Preempt and Abort
which is waiting on the running commands. I could have had Preempt
and Abort create a tmr, and queue a work and go through that path
but I thought it looked uglier faking it.


> 
>>
>>>>
>>>>         if (cmd->transport_state & CMD_T_ABORTED)
>>>> @@ -3596,6 +3597,22 @@ static void target_tmr_work(struct work_struct *work)
>>>>                         target_dev_ua_allocate(dev, 0x29,
>>>>                                                ASCQ_29H_BUS_DEVICE_RESET_FUNCTION_OCCURRED);
>>>>                 }
>>>> +
>>>> +               /*
>>>> +                * If this is the last reset the device can be freed after we
>>>> +                * run transport_cmd_check_stop_to_fabric. Figure out if there
>>>> +                * are other resets that need to be scheduled while we know we
>>>> +                * have a refcount on the device.
>>>> +                */
>>>> +               spin_lock_irq(&dev->se_tmr_lock);
>>>
>>> tmr->tmr_list is removed from the list in the very end of se_cmd lifecycle
>>> so any number of LUN_RESETs can be in lun_reset_tmr_list. And all of them
>>> can be finished but not yet removed from the list.
>>
>> Don't we remove it from the list a little later in this function when
>> we call transport_lun_remove_cmd?
> 
> OMG, yes, of course, you a right. I messed up something.
> 
> But I have concerns still:
> transport_lookup_tmr_lun (where LUN_RESET is added to the list) and
> transport_generic_handle_tmr(where LUN_RESET is scheduled to handle)
> are not serialized. And below you can start the second LUN_RESET while
> transport_generic_handle_tmr is not yet called for it. The _handle_tmr
> could be delayed for a such time that is enough to handle that second
> LUN_RESET and to clear the flag. _handle_tmr will then start the work
> again.

Ah yeah, nice catch.

> 
> Is it worth doing that list management? Is it not enough just wrap
> calling core_tmr_lun_reset() in target_tmr_work by a mutex?

I can just do the mutex.

Was trying to reduce how many threads we use, but the big win is for aborts.
Will work on that type of thing in a separate patchset.


> Better to have a separarte variable used only under lock.
>
Will fix.

