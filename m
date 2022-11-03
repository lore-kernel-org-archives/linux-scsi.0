Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 148EDC43219
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Nov 2022 02:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiKCCZ5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Nov 2022 22:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKCCZ4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2022 22:25:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A2C12760;
        Wed,  2 Nov 2022 19:25:55 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2Mc1VO002999;
        Thu, 3 Nov 2022 02:25:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Wg8Ea+g+iHd4aSWWA6OjaA834FKkTAA5cxQh/UBmKBA=;
 b=Qk4Wi4R337bELWe4qtC41GlFyz23y9MuIUkfwVVsVV2H9PYB4JzxsOJubW6Bwu7sX5G/
 jc6wt0xTQynpRQldYTKBvTFtfpxBBk98UkUFm0Iko0bEaTmez9by5c3wHfhsg4Uf2vQ8
 /GKoIOrCigoUCkbMTbepb8igqOypKn9kxHL9Sl5mvfvpCE5CeizI+xYAIJVnHXWiPTN+
 84pxTOKIGmSNpVboXMZ21mkeBF+Gpe2CFAlHf0joIicqb0fOgfhK89uyv+MkN1DMvsSc
 1oRILCCHH6mK+RvdmAubxOVdqpi9CIOWBiOXMr0rrEKl8FGvDRMJkX7SOQf+kzW/VNWq lQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgty33hnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Nov 2022 02:25:40 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A30kGFi027286;
        Thu, 3 Nov 2022 02:25:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtm65yf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Nov 2022 02:25:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dIFX2DW4bi+GXGFESFN8Tc12kty/RNQW7q1ZlLafKfFgjkC1BLPpNFSPhoI7gI5KCI82l8IdtsrlBm6EAMYssNNv5QnIHFeSAqC7WSX3yG6htWuYO+vBUWJnWXz6i4mdbH3jepG/FY2y0dsopOWfKhGtNnagB068LcNh8cQETk/eU2uhJ7LFJoL4qkGSTfi2vx7kztfwB6dUvBZh73gJuSo3K6lylG8PnCV+ZKcoD//liRpUSQXJ3pQRgubde8EsUvKcesGqTCQqfa5SB8JHN/DphzeFHO8yPSHAoSc0cBBfozU7lkf/O2l0/KzwwAQyC3dzK3cLffMEpaju0Pjzgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wg8Ea+g+iHd4aSWWA6OjaA834FKkTAA5cxQh/UBmKBA=;
 b=g0QQIiPx/h2/oJ7A/kO3DH9ntjXkd85LQsGyyKr6sbJs9JOBJH6IgsTqa+VGLsd46qNpAe1NbwO15k37m2shP5yRyKMB7pIBG3j+UYNNRaynNPF6j8Z2UWsX1Xej13UDaFn+PTCPoFCrygR/dk+mX5WNnDbAqNtGkbgn/JpKRjwbS8MBGMXZfZzDjvcCIZ3F/Diq+dv92r1zQYArNtWnDZjsfuRZ9AwJB1IGNPSGoulfZAsiriOjRHpYHgDmJ7+GXMAz0XR3e/7mMUee3+bsA3IlXFxcpqSXQG/sDQRSIj0lk2laF//myjKp8IOpV8fOqHPdjs3baKnqbSlxWnG/sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wg8Ea+g+iHd4aSWWA6OjaA834FKkTAA5cxQh/UBmKBA=;
 b=kerd0b5lLqrzTfsdtwJ1TXf59Tf3eJfrlxfnHRgGKJ/x2XcdihLqM5IKxWanVhfuLsRMDD6dtFSrkBkSSQx5wdClL/y3ikRQADqABGkuGGSH4QrM83sBH416EZOMTQdn6M2x7lvK+lnOg8sJhktLSUrbatmIOeyQCtVEIoFP6oQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA3PR10MB7042.namprd10.prod.outlook.com (2603:10b6:806:317::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Thu, 3 Nov
 2022 02:25:36 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5769.021; Thu, 3 Nov 2022
 02:25:36 +0000
Message-ID: <0d88d3d5-1c19-5d2c-c3a6-8ff67f074117@oracle.com>
Date:   Wed, 2 Nov 2022 21:25:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v3 01/19] block: Add PR callouts for read keys and
 reservation
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-2-michael.christie@oracle.com>
 <569dfa4d-0f0e-a596-1f38-2f4ccc555fe5@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <569dfa4d-0f0e-a596-1f38-2f4ccc555fe5@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR04CA0107.namprd04.prod.outlook.com
 (2603:10b6:610:75::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA3PR10MB7042:EE_
X-MS-Office365-Filtering-Correlation-Id: 0efb4f2b-848a-498e-7ec8-08dabd42b119
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ag7cm1EatkNwjF2Jn9+aylpmNvSisDRKCm88sGXqXBpRZg4kKBKstFKYEkfjN5bBSWfCQnbMiUu2ZUT9PsEaHBpPj0wK/lWUW93e3YjtgeonT8uohDHJamXdaNh9abYPEkQWnPaJb6/+/xaj3b0XCRKcLBZxy8IxO3bLCKQt8tXRnNYVopEICPY656ZrKfckZQDcaQFCP2vcXe/QdfRp8jXqxowum78afCu6Ua3MbD9x5RRR/UfmTipYysaW5IDXLgjkmb79wpT88GPqhL+gUiE6S9NawpcQpwaBzcPUlUz8GhI/1iOJyCz2GbMIOkaWHh/4rcovNWITMfZr1vyC0nrEBcnn1iEYOc1LxrWe44ZwuKyqzr4iM/NmIrumQCjItV2mNLUU9AiTIeJiCnp3bn24IS8HLBt7ck5d7eatZ90WvK7mzYqGd3zw4zDNcmkMHVuROWV2v6PpSdW73jjHYrabBNZByewWXekT0GUhv8fVscekCMWijdWaGNEvl88uTZ1rk/lk2keQWsCeNYKHRhZCa+71kDpHI+ZXMpJ5P+mdG/EaVxK1/quWvxhTcVsxz0N5icrd22wHkyP26PTqTIoRQiTnP3KWN/XXsMplbztKTU/Dc858fOY8+mHiLzJ49MAG+bOTB0PaWE4Vf9uIpfSoa8KvJZqqXAhil8iW7Scfo7U3CQHGc/RIsTITTgZe6nXfRun4L1ogj0kvMWEykXw0xykRqcHvXre5gtSz7Htz2p7oKxyfTdeEZuid5AeV+SsosNKZeyt6VcYp065XHtysKeZ7lm3im5N40K2HYJEIbcedSJkdPyGsvudiYCVY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(366004)(39860400002)(136003)(376002)(451199015)(921005)(66946007)(66476007)(8676002)(66556008)(316002)(2906002)(26005)(4744005)(186003)(6486002)(2616005)(38100700002)(5660300002)(6506007)(53546011)(478600001)(7416002)(31686004)(36756003)(6512007)(86362001)(41300700001)(31696002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0IyaWRVdWRwdFYySDJLVC80SXFwa2JSZzIvVTVhQ0M3eUhWYVZITEVTc3A1?=
 =?utf-8?B?UEQrRGF6QlJyZTFYS0ZMMXpXR0lXZlZKWTd2cUNiSkszQ0JOZXBPcTVabGxL?=
 =?utf-8?B?czZURE54T3R2SmhmL29KdjltUlVQdm4xOWZSWk1tVVBjSnluOWwrd1YyQ213?=
 =?utf-8?B?bkxSUFJRTWR2TDRsM1RPKzcxYTdxVnFxVXRqYWo3YlVyQnhRdGZqSkxJbVNh?=
 =?utf-8?B?WXk1RkZhcW9rTi9ZVk5aeDFzeXBNN0w3bFhjMDVTbVJzbSswWFd6aDRlbWRs?=
 =?utf-8?B?WC8xQkh4a3NUdjlVcU5EZGtqbTl3UEF0TUhVNGxQQm83b2srTnA2L0p1a1RC?=
 =?utf-8?B?YlB2TmtRSk9DMFAzV0FxaVBRU1pZMDhwTUw3aHdvNG5GZE40Z1dUSU9Td3B6?=
 =?utf-8?B?dnpnNlMzSHhUQ1pkbzZtL3QwR2crZytDK2tCdXNYQWh2MnIvNXJUbDIxeklm?=
 =?utf-8?B?NVgyVU9mL0sremNaMERHUFd4cHFmaVJ4K0h3bkxrYXMzdnRxWmQ1NDlwY0Nr?=
 =?utf-8?B?OG9mU3JxVTEzNXUxeTdlRDUxaERDbEcwanZJMUM2Qk1SZWR1Vi9WS3lpcDRQ?=
 =?utf-8?B?cHV5cXBVWWZEWS9yT1Vsdk9oRUVjdmRhc3ptR0RvWmY2RXJyLzRYWWNRaHdz?=
 =?utf-8?B?ZGFZVm9nY3lHblNuMGxUUkJPeHRjcUVXQ3BtWGE3L0VxOGUyWEVKSm9yR2ZZ?=
 =?utf-8?B?TklXRzgybnVxRkZjaFdneWNVOFNVTmtmaUR0Y3Qxck8xM3NvU1EzKythU1lL?=
 =?utf-8?B?bWN5RFczR3dXK2U5c2tBaHF2RzhyNC9vMzRZRXR1bmsrcDNUenVPWmdlTXUv?=
 =?utf-8?B?UEZFVG1KbE5nQ0lUM0llbUpwQXB5MlZMdENadXJKdlp2Z3lKbjhuMjJoVllm?=
 =?utf-8?B?NnV0Z2ZqeExhV0JRN1c5UmttdjMzK0trUzhyZnhqQnVrbVV6SFo2YyswMG5v?=
 =?utf-8?B?NUFmVFV4c0tNT0xGc1Y0Z2pqK2Y3OFZ3TXFBTDlHU1ZjVGN2OUhubnpqTFI4?=
 =?utf-8?B?MEVUMnNBRjl1bGFyZy92YkhiUmNLczhpeFd5eXd1dTU3cEgyV1JZaXlnWGtS?=
 =?utf-8?B?SThwbkE2MzVEaXZINjFIRlczZ3d3WmRINTd2Zndyb3VBR09ZemlrUm1iZlg0?=
 =?utf-8?B?WDYwSFh3MVpEd01FRlV3U3ZKT2VvZUhCWG51MEZTMjlxTlEvdWRCMytrWW5i?=
 =?utf-8?B?SmlQWXh0VFdxRG9JYTRHOTJSWTRNWGROY2lKK0hIRGZVem1PclVnMnVPcnZp?=
 =?utf-8?B?TmlocFp4NFJ3NVZtZ2JwTXVUbFB2aEFKdU05dTFFZVFnNS96QUo1UVNzTytl?=
 =?utf-8?B?SE1vQ3FpVmR1MXJDS0p6NHVvWTVhM3J5S3ZkbWtZRGtoVlo2MEdweUdRdktn?=
 =?utf-8?B?VGtSSHpNMkFjN2lhZ2V6aWdsYmFtK2RVYTJyTW5McHBPOUVkd01ZT2Z3TTVa?=
 =?utf-8?B?WUNLc09LZXpvdzhxNGNlcEJjVHFJNkZXVUVaLytFUUhkdEpRbGVhM25qZ1dt?=
 =?utf-8?B?SHR2M0Vrb2VmVERobTNaMTVFcERVTlkzdER3RTgwdHI5K0c2Skkvd0FFWTNp?=
 =?utf-8?B?NDhSY01WRmRXajJYTmdtQldrRnJnWmZPSnp4TWVWN1VSczNJd09XckdhMmF3?=
 =?utf-8?B?d0J5aXloTnFCZCthQ0ZnNklFOWNrbFF3eHhSMlJaYStyeXA4cVFZeCtoZ2dJ?=
 =?utf-8?B?ZThmcFVVdzdaYTRYeFBHNVYrRDI5cE9WM2N4NlZSYWRET28vZ3N3TkNtR1lL?=
 =?utf-8?B?MG5VMFFVRUp6N2FtSmJsYlRXQUk3TFRXUUN3SFIzeFdPWGZNT3pTL3F2OXp0?=
 =?utf-8?B?aHcyVytydGo1N3B6YmRBcjE1dDJ6WGsvVjVaQWo1WEdPd2ZQa1F1S1RRZWpn?=
 =?utf-8?B?d2lYc0I0RS9zN21CQkxXeFhwb291V0dnTVRHYlRQZm9MT2hZRURoV2dOMXBr?=
 =?utf-8?B?SUdFaEszTkZaVjJpRkFCZS9wQ3pkNTF0VVdpcGttVkhKR0IzbERMSkhraHpL?=
 =?utf-8?B?L1RLc0w3cEE3ZjhLSkJJV3FzUWlNb2kxT2ZrRVhWR3NnUmd1U21ETWtydDZn?=
 =?utf-8?B?UHVJZE42ZGJEYVFQNkhLWlk4c2VhNWF5elFvVzczV1hGdEc4V25neDhIREZO?=
 =?utf-8?B?VWFIK2YxUHdEUjFCNys3UjJmeU5DWXliWEs0K2oyVGxpZ2x4MWZXZjArZFha?=
 =?utf-8?B?K3c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0efb4f2b-848a-498e-7ec8-08dabd42b119
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 02:25:36.4794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yaj9ddQFeAjJ9HfpSr/9IueS6qKJlZg1AEG+4uXEQLKOkjVURx1sBiwie0uT4lL8fKHzDbnZsoK/kcXUXvlDdaMrOZPZKWaUi2oGSJUbgVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7042
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_15,2022-11-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211030014
X-Proofpoint-ORIG-GUID: JhvFLnldbseX18_QLmdL4ZW-CXhH4v76
X-Proofpoint-GUID: JhvFLnldbseX18_QLmdL4ZW-CXhH4v76
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/2/22 5:53 PM, Bart Van Assche wrote:
> On 10/26/22 16:19, Mike Christie wrote:
>> +struct pr_keys {
>> +    u32    generation;
>> +    u32    num_keys;
>> +    u64    keys[];
>> +};
> Is my understanding correct that keys[] is treated as opaque data by the kernel? If so, is it necessary to convert the persistent reservation keys from big endian to CPU endianness? Some SCSI stacks keep reservation keys as __be64 format.

The pr_read_keys/reservation calls work like the pr_register/reserve/
release calls where the scsi and nvme layer convert to/from the cpu
endianness to the specs endiennness (big for scsi and little for nvme).
