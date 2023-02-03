Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D33C05027
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Feb 2023 16:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbjBCQKF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Feb 2023 11:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjBCQKE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2023 11:10:04 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9262D7A91
        for <linux-scsi@vger.kernel.org>; Fri,  3 Feb 2023 08:10:03 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 313CgjxY020622;
        Fri, 3 Feb 2023 15:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=soeVMkaeKNO6TXDm0P4MCH0XmC6ObwqgOizljE5tDkM=;
 b=kxhEuXpUqXdpa8gI00gPE906ueX14XTw/S0bIXj2iVGjE4ptDgyIrF8jn1MRZx6TztLj
 Gw7fIsCs6k99m8KX/e5uVRV/lYEVqYOM0nHPvumK9nHXmk4xzJxkfxjZq6odqYATyYzQ
 BrM31ZQo0a8brT5qxgF48cIMfSobFoRwfvcD3vhUv9N6IvrFBNPHBMEBKzUZ+RP91Ter
 w6Lz9VqgF5+ssrlXiKKot4OaW63LnafFXD6gw0jxPnh68BlcJ27RlQKQbsl8/PWVE7Sj
 q0XHF5wOe5jtiAT4UAIHLN9SX/kJeix2WWDmu49D2DOYgmlgNhLxz16/i9d5w8YRSmqO 6Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nfmbg5upa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Feb 2023 15:08:59 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 313ETIfh004942;
        Fri, 3 Feb 2023 15:08:58 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nct5hrqfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Feb 2023 15:08:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HuIGYv4LU+IyA/mGk73JUC5GQLwAQi54m9JCL7bKOH2NCfAwWxwJwKX0x+Q7a8y79GgmMD2TEdG5TF/ow51w6ZLXGCZ5Py+kF8spiQ200qJpOrNRxA/SUGcvMlW7n0ycwLcWou78C4Bk5JbwsLC524YPFMw1UxjFeylaTCqXbVVdNbt7w45hexJrTXncoGsh0KtgyM/jHwhe0wgjZrnYOBzopJptLa4gESCzXbKgNPzJ9HQu+Bew03tk6hxocXIe18l7gBZp5+yWz9VBQCMv3SjEc1a4tb+mIakHyr2P7VJJBQvr0dpAOWF+/qVT032YZbhGf6PoAGm8clxNSrFoxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=soeVMkaeKNO6TXDm0P4MCH0XmC6ObwqgOizljE5tDkM=;
 b=DofwTZKL2aqxZH/QH7yVVnN3wG3K8tgZnHUW8vNLSSTWnT8xWVl1OrmssolLamyYEZnicx9qjJNbOGM+o6BIhbuL1cRnH31TqFxdFeHH3GTo8jYyLwbhXyQxuoAK6c0oDhP9hJRF6c7fB1FkYZ5+o2iz2W9GG8zHb8yHDJGdwPFtuyU2BIgEPscvxT2sKsuo3Tq7pT09e3RfFvB4FfHwZ25BeQtJbsQdFX87rDEYmrHGwUqQrE6XXYUNdhgBOPMydlirGZ6mx7WrguXtgHoHi3F9XWViP3y5QVVy1Vp80hG8b+i2H4+6o+SZ2cazXQJeit+RpfZOsKzYbtdNB1/vqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=soeVMkaeKNO6TXDm0P4MCH0XmC6ObwqgOizljE5tDkM=;
 b=hVCs7JAf5b+10QiVrjIdQFE9dLoj2ux6MoAEpvstBLSBY0OUpQqokb+9a7XRV1nLtERfpy+R6THHNtRR5e2RliHha0j/d6M3aEhbwzSwzV06jUY0EnbZfUueKFaKyCLD5ur8/axpGSnZIrVbmTwx3L1aHl6kexPZuN6XuPe7SuY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4663.namprd10.prod.outlook.com (2603:10b6:510:34::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.9; Fri, 3 Feb 2023 15:08:56 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6086.008; Fri, 3 Feb 2023
 15:08:55 +0000
Message-ID: <9a967719-d7da-09fa-3de8-a54f0f96f475@oracle.com>
Date:   Fri, 3 Feb 2023 09:08:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 1/2] scsi: core: Extend struct scsi_exec_args
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230202220412.561487-1-bvanassche@acm.org>
 <20230202220412.561487-2-bvanassche@acm.org>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230202220412.561487-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR20CA0012.namprd20.prod.outlook.com
 (2603:10b6:610:58::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4663:EE_
X-MS-Office365-Filtering-Correlation-Id: 3183bd2d-2dd1-4dc2-67eb-08db05f8916c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CDGeQ9hMCO04QC2R+jtWRMoGn97dLlChw8AITjZP87N/nNqfvFAB0yGj//HhmiOx+N3ZnPnZsycYkAK0Bl4WC+tBwhgCsE7SkKkcqwWeRLxaXMt3Dw1SjU1cmZcl4RmMk2XWIrM6uN292iEjg2Ou3Uh90dk7j2LGzcLZTGfXGFripLNAld+3XRFqStcdu9KgHT+0qvu0jxLspCAixLn+hQhCoSLguzS+rzLn0Do67zyLVE3vI7nu7JxDzziMlwmVbZMMaGTA55LYMFJ83vG42NQv2Nw9VXBxGEO/gwbCKWhYQyKf3ZBkW3M2L7DA00NDLLSBSU2W6RngCrlMQvwtNq8iKYoRJ0cqJhXXMtMhhS9cJK5ejdwj2YuCOBhAH5XIN/DqbXW3X7dm1Mk53oLOgKY9VtCnDOqEtgqEq7FbeTH/QvZfqMPJrMNUKzNEXcklo9bB2dmKWt5IhfioYu/MsYHRw71TenvTKJuZGv2YsdpV5d3+TRrJmlt4SonusybA9LO3RyT3njGqdWuTf5tOlOiMbdFWDOwjNEUUbfds7WtHdwPt+mA6/QO36Nzqj+RGxg9PM194gsl1H5j6eEB4qg8YKcm5DcKZOtfFFJohsZJsylTIYJlR/uSWD9wyHiQ2sRp2quik5oxrszuWiJdBJQUxRCo+t6/uWzAUPStQhpb0e4XC1CgMTCSPCCjlvFqfc8q+LYwWNZY8NDStovVqZGttjatyKXnbdrwu9G2tBrA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(346002)(376002)(136003)(39860400002)(451199018)(2616005)(83380400001)(36756003)(41300700001)(2906002)(316002)(66946007)(66556008)(66476007)(4326008)(8676002)(6636002)(8936002)(53546011)(54906003)(38100700002)(6506007)(86362001)(31696002)(6512007)(26005)(186003)(110136005)(6486002)(478600001)(4744005)(5660300002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cEV0MVFzTVdSRG9UbGhRaUJoT0ErWGVpY2tuQWFsRnM5SGdJdlBLbzNVVmt5?=
 =?utf-8?B?Tk5JdUlNRDFEdEFTSVdUU3dFZFBmcVovVUxWY0RRczNwWUVHSkFoZE14cExt?=
 =?utf-8?B?M1MrVVE4dzd2akR5NDhZWnhRMDQwRHpkT29tRVcxM21waW1HcGVhL2FLSlJi?=
 =?utf-8?B?aW1PRVNjUEFFdVo4bmJ6d1hWakhPNWl6dDZidkMzbTdYeDI0QTJ6K0t5d09p?=
 =?utf-8?B?MUJFVUJwOWx3cG44UXJmVzgrSUdmYUNkYmdKWE1Bd0hwNWYrOGVrOHNZU0U4?=
 =?utf-8?B?dWNkLzl5ZjVPOTUwY21NY09yL2syV3FkaWttQUNRMXhHTzgzVlZvTS9xNG5U?=
 =?utf-8?B?MTIwSmcrWDdQblYvZVh0VGN5dENWSGdMNnJvT2tIOFFVSFJIRjF6N2xnUVNR?=
 =?utf-8?B?OFpDZkZ2ZjlrNEVzSnZkMVZ5T0VBaytsMXJXZlVSVHkrMnF2aEFRYnFKeWNG?=
 =?utf-8?B?Ull1VDZNSFhoWGs5VSs5NExzVmdTMnYvT1BwRFdSQ0VOVkFwczRNM2k3MU42?=
 =?utf-8?B?OHh6RUpxaTlTelNmaHErM3g2TW12TmxmQUFxdDZXS3NVdzhyUWg2NHZMOC9y?=
 =?utf-8?B?QWE5dmRlYWJDcHE4L2FZd0VDWW4vbXhIZmlOVGhTcnlhSDRDZnVIbTRqREFH?=
 =?utf-8?B?ZVRSUUlsazUrWHpZeWI4d2FHNklRQjEwcnJyckFPT2pPeGRvMnZGZDFlb1V0?=
 =?utf-8?B?UXUzT1ZMdlk4K1RLUmE2T1VqZ1h2TXJXM21wSnBLSzJVMWUrbWV5b0lMZXpK?=
 =?utf-8?B?RkdoQ3FTY2ZxVktrOVIwTWI1ZjRnRHhrNG5lM0UyNEd3dnVTVSs4SEFJOVBP?=
 =?utf-8?B?NUNlNTI0K0lBV1ozRkFodGhhY01hL05sM0xpak5BbTVFYkRNUUtyajlVNHMv?=
 =?utf-8?B?S2xvdzNGNWsyRTI0dVk1RmdCZFlFRlNlcEJXZGoyMktoMS9DZUt6QzhmMGg4?=
 =?utf-8?B?bXJBWjA3RUd5RjU0cGpSWkpxTzY4RERxQUxMOXQzTGtRWG5YT3I5UTMzbVFI?=
 =?utf-8?B?QzRreE5ZRVZ1SkQvSC80allmZFVvb1U4a1dYOFJxaDd0S08vQjhhQ21jN29a?=
 =?utf-8?B?ZkNjbjM5TDdQTWRER3VBdVpzRFJxSUxKeVI2U2tFTENBaGNlSmRuNmxUMUc4?=
 =?utf-8?B?cWFCbE9PRk45VEJSR2pyVlJ1YmJKcS9ickc2SnNMY3JyQVUxZzJSRmRIcXli?=
 =?utf-8?B?L1M5c1RBcmJDczBPcDFlaEhoOXRlZE5wbTdRTGVLWmFTazY0am0vTDJhSHpm?=
 =?utf-8?B?a09UcGdHRFphbW5jWTZzR3dkZ1QxWG04ZUpqZnRCMk11VDVTWlNaZ2dIZ3RJ?=
 =?utf-8?B?S1pSdHVKOUJWRDJmRkszUFd3YlB4a0ZNVUxXb2V1cWIvZUVTQ2M3Vk8vSGEr?=
 =?utf-8?B?TXNJeWhkUTI5TG5HK0l3VmVPTjlTa21JZmFLa2kxY1pJblBtdkN1RHBZM1dG?=
 =?utf-8?B?VlJpTFNnbERqTjVpMXN4QnBCeWFRaFZPU2FnY1UwSVo5ZG1YWUxYTTJ3a2la?=
 =?utf-8?B?V2hkbmYzVGNVNTFYYVNQSE1HSVRKemNZWDRQUTFJd0FFZ01Da2ZDRnVuSEdi?=
 =?utf-8?B?UVRWVjNMQVJGeTdhS2xVeWZpOWd5ZDRGU0NVclIzbVBNclRPT0JOOHlmZTZF?=
 =?utf-8?B?Z0N5RXVJdys3U3ZodWtERyswakJNbnQ2SThrekllUUJpTTBJRmhQQUNQbG1a?=
 =?utf-8?B?TnFBd1crVkNKOWJmVWsyVXIwbGxRdW1uTjVqNUMzbWpJaWlsajdTR0dVSVBx?=
 =?utf-8?B?c1dBMUkxRGRuREN1eGNHSEtMSzhzNXRibGdIUVhjT3Rmc2VuV3k0UW14b1VW?=
 =?utf-8?B?VHFMU0d1bGJxSlBZMDlCSFJrUmVUSmpGWVRNRzV5T09SSkJTWGp2ZTU4MW42?=
 =?utf-8?B?VTVyWng1cSs5RXc0dGUrNVpNaFFUeWk5WkE0WVdpRVJ2MjM4WDhuQnNiaTgz?=
 =?utf-8?B?SmVYWjhnOWdCUExiK2FySkJzQ1ducWpZbnM4VWJRM2tBODIyNkgzc3hJWC85?=
 =?utf-8?B?MWZqa3NyOUhzbHJwd095TC9SdTBoSnRycDFUdlVBUGZacXVNZ3dQV1lIT2or?=
 =?utf-8?B?dW1CcmVYb1R5VytHRldMcGZieUVsWENBS016MEpTYURoT2tZTGFqSUgvQjZH?=
 =?utf-8?B?WGNyb3dpSjJtNlAxbzR5S1ZrbkpwNzNUT1B0VnJhWlJTaStPUk4yVkVrMHlR?=
 =?utf-8?B?VHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Xbxqg9IJMQPgWatAqDF8ghtMkPfffw7XGiBugQoisgrS8zcISqU7/ncyZGG8ZLycvUGS8P8YfN2KOy6iBSJ0e62YRiUQWpFWB24v5ft4v63VuVpSVOvgD5/uC/Cm6x85aLz9k9ssDNtOwDj9nrJ2ftGcXgNvrrN4mTkUduaNv4H2GWqsLfod44aLGE441qqSMfxg5EmC7TS2gowExclb8ertbTFBILtQ7SrhwmWgPthwDf16j89u7np+9aLdfq3ghXVEJZZb8kugoYSfvRNehWtVUqLvLnQAQIjSSQeK+xIlgL+QLFyJr5G5wJ6j7t34K7Nr9n5G0mXaGdil2FNEnbXvSN9UzF5UJ/egBHg+SLLdkN1T6CZUc/FrEKVlnwiRtpj7e5VNLuIhNDnmWQSCQ+5cTcNOQ5Yd8P+HLFHpxigRuv24Zpes6Mtx14AK+iVB7/3GiNkeDrAJtdhTBXRNtayeoGCrfSFud9bEKaS9Ivfyutu6c05VyBq+CLT3cU0/lER16dEONZhqUpJr9uQlnAt+j5ySBGvdopm4rmk8TaYQJox70/xM88jG+YEpLlnnQI+XOWHj+RYGahL84ZFYWfW39wDrKVxOZBGrX5IqKm7Mu+90bpjvyGUNIEGD4iycWpwzGmmqZk+7CV8G4yogYkFOmsAwMXWvwptl7RZkym/RsstCqeklVAm1selejpZeFh/DkmZyTTO45pPTbpNyFcdNWFFpmuZd3Bem+fUuSV3MZMqTmyd1s2mXd5jlWy0GAGpsQUzfmTeipuJ0CPWkwI4/V7564pA9rbJlvRAR4kIwfmnmDlo58YL4qQDgC5VTvLPYLfQBJBqwpHqDSiH2TfvN2nd3306NsqfOMm7b6eQIpWW6EZePhc9JGYQBhjNjXQOAJU+pMG0DrLMdPlyikA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3183bd2d-2dd1-4dc2-67eb-08db05f8916c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 15:08:55.4917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sai+9xkf5e2MNbqnm8DDjkbKB7yRM2f7VGswkiS34++w3vZPLhXuJwfj9moERjON3ceiTNLzto6PZy0HcszLC5idCrF1NrlS/IawojSEluw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4663
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-03_14,2023-02-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302030140
X-Proofpoint-ORIG-GUID: Cj8_4iSRbP0S2hoeJI260i0v3FjPcgWW
X-Proofpoint-GUID: Cj8_4iSRbP0S2hoeJI260i0v3FjPcgWW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/2/23 4:04 PM, Bart Van Assche wrote:
> Allow SCSI LLDs to specify RQF_* and SCMD_* flags.
> 
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_lib.c    | 3 ++-
>  include/scsi/scsi_device.h | 2 ++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>

