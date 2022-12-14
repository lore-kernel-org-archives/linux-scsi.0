Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E24ECC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 13:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237995AbiLNNQf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 08:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237778AbiLNNQd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 08:16:33 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF4D6279
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 05:16:32 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEChvWS009428;
        Wed, 14 Dec 2022 13:16:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=i5CBf5HvAhN60mhuG0v7WH288cWa3m3Myn8RNypWo3w=;
 b=MoTje9KyxFxHIhiFpPIKY25ldyBVMIrShOKsOmNPKBN4ZPFhyqs1NhzCSLLoQbjFqJgA
 X90fXgds9XhzryxfaaoclgwGWayRkHapLXFs69roPDTjM2GikAotT2alYqiuOXAv0kAp
 mddnMHwcll5GoeMpnehFFs9K3OgkzeAufVQzB5EiiAu/znHSJ8pyiqza/qYsbOax7ih7
 SmMLMQBXF3iGtI7204MklAW5UtMn8FQa635M5UHqV8UkOsKrsIpaPyTLdP79m3LhbkRl
 R7//E287xZczY2ZSwQ6OBljFNITxET6Zq6n5yxJYPc9qdmT7ko67n2Z3t9gULsc/pGbp Gw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewt5mc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 13:16:14 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BECEXj2025230;
        Wed, 14 Dec 2022 13:16:14 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyem9nc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 13:16:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCVzfUGJjKNRqMgwCUG9xzVtn0CJncv++n7K5N0mIRMuubeMJN1u7huPaWnEp9hLDOXs39zGwS/LB/Hl44x/7k9fci6YXkwMamLqugVk5Fol/32SfIFtLWN251H7OCIKUttPsmnqTDqcTqe1zRKxaHrrObr6XMJuEgW1opCunJQuiAustLFZ3xfUHWVL+Wog0W7/lPd1jNayFhrHy9ay9yfJgaay+L9JX6MfSpwB9iDnKMuTTA+P4G3Sl9t5aj8//x1Vq1oCnlXEYwcNb86UHjOpc2nLCmchG/AJaFPmAa8prtiOmJzE1vnphu4v9g7gUPHkbAOEeheRlguGLxqcDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i5CBf5HvAhN60mhuG0v7WH288cWa3m3Myn8RNypWo3w=;
 b=IrKb2FcESiPCIu9/SL9v34qSSdZJB7O9lkdGCEx6B2DdM14UXPzsEyJVCCJe2uFTyWVN07jupqj5fWI3PyQVdfXIp1eg6vcY+QiiYpvi+RoCpyrFx/IGCCIEOLxY4Vs9nas34URV5PjK+HzlSj1p9CHgsOTJUI6+bQyp2/yibBE8YR9r18OLO3Ee1A2G4aLgXZQF+v4O7rIGOI/iO2H4d+lyu7Pjd51fFfNqxdhveoPAWpmuuJV4RwkVo+8pKm1JTGFjOW8mCtjrVrhX157/6ilyWwADASZGXXqMSiNI1P39BfX3bGUpr0wdjQG2zPXJ9jiItOGiwrKrPZMnJS50Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5CBf5HvAhN60mhuG0v7WH288cWa3m3Myn8RNypWo3w=;
 b=gX8jh4dCScATtjOGgUsU3LErrCIP00GcjSmafxUSjzVgkQV2M+tVdofU/4oqWZ8TVRzPCoF74VI4zORHpvjhtqhG6HuscBqIuNpi2pbhHvrX9hrtVPVnPfXvAyNNklqNvePBH0m1w6UaqUk5ULxbWVsMKRXbc2q105st6gYvLPw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CO1PR10MB4658.namprd10.prod.outlook.com (2603:10b6:303:91::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Wed, 14 Dec
 2022 13:16:11 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 13:16:11 +0000
Message-ID: <113358cf-dde7-2494-744b-e5017db30948@oracle.com>
Date:   Wed, 14 Dec 2022 13:16:07 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 4/5] scsi: libsas: factor out sas_ata_add_dev()
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com
References: <20221214070608.4128546-1-yanaijie@huawei.com>
 <20221214070608.4128546-5-yanaijie@huawei.com>
 <f808191f-6723-257b-6cd6-3e2db2fa4b27@oracle.com>
 <913a6c69-6aa4-2d18-ecee-2fa8b97c888e@huawei.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <913a6c69-6aa4-2d18-ecee-2fa8b97c888e@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0286.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CO1PR10MB4658:EE_
X-MS-Office365-Filtering-Correlation-Id: 6af63a67-7659-47f8-5a00-08daddd55ec1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ej5UI5ToPl7xlh+h5b/sskbGUNp3WJYu1w/vWF6A9D38rXfTbgvfjj7XV6qvpRW4bBQUd3YCWf24x/Vv3B8e6WFndGYiwB6T0wWoWePbT4Xc8Of8ANDa+UHaPPAyuvKPx+dF6WNc1qmXTeMwcQ1CJwQTxAOf7lQlb5m0ZcpBoxoofONNhLJhO/uOZDwWhe4VWYOS+ixgdxrv9QNfR+F2QdppkUVifRZp556nTwP6OhDZ7npGgIyJ+7797wVLIPEfG5cg0Yo48d589tbKfNs5+8FcY4nURXYXN7s/MWkonNm9ShwnceHYHO4f79FLhCbD5pNRlxx3tpJYGziBWQhgRvVfvxT8XNk3doswoXbQtBuCSvBUddwfAY24SMAwVRt2+IjOfmrQJ7AwZlk1EDQz5PnhdlhjyElsww3Ua02VHmrSmQQKQ43VwQ/mG4RalBPoBn/mDQWdnAu1sw1bEfT40ZfKglwXhz+xYJMbMYM8aos9ltmwy0rGJSlvxCyxBeHwLxKtbE6NosiXorpMGWaXUoHl3VNDxkTqcChbhqmYrvtKhivm7ZeNIAyM/h3KSpxaBgdLijzsO1j/VD20xJxeLDsLvDhGe1uyxdNneLgEVKLhC++QZ01qgI6e9DlRtLD9EV+q8kt4De/WIdek19MFEnrg/9iBwmRNykWd3kqxGGsJnWoUkBDwUJlg3zCE6+oddW2kh25SmWBuJxBAZbJL0/+nFJjvN4H50E2jjM18E6A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199015)(36756003)(31686004)(66946007)(66556008)(66476007)(186003)(26005)(6512007)(8676002)(31696002)(86362001)(41300700001)(478600001)(6486002)(36916002)(2616005)(4326008)(4744005)(2906002)(8936002)(5660300002)(83380400001)(6666004)(53546011)(316002)(6506007)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mnl5OWRDWEZJNkJ6MG9sb0pveVdwdE44WUZldmFGUUFQeDdCcEhOZnpDc3dD?=
 =?utf-8?B?eldpU0ZPa2IrL3ltSE1wZkd4TTV5V0lCTlRwN1FxdHRkYk1kWnVuS2UzYUdR?=
 =?utf-8?B?ejZKaXRCS1Zrak4zTFQwRzFuQTRVMkZOaEx2NTZWYUk0Y2lPNkE2bXphSnFs?=
 =?utf-8?B?YTRueGNBeVN5MUdocEZLbHRJQVBMT2lzR1Z3bzB3WVRCTWZQNlNhUWR6em5X?=
 =?utf-8?B?ZFVRWEFDUWw4YWRLSHVjRmN3YWUyelZSSXRncVkxOGthSExoeWhid2hlVkE2?=
 =?utf-8?B?MTVGQXpIR2JCNmU2Zk1aTGwya0wrNjBvaE1VM0oxWkxTN1JjV2liMnl5aGJ2?=
 =?utf-8?B?K29WSTErMERSRHlrR1VMd0tsVXFHdUtYZVgzRVZ3MUpoTXNhTVZEYXQ0Y1Qx?=
 =?utf-8?B?WEw1QVFpSEFMZHZabUxXVW9CWTZkM2lXVXR0dndCb1VmNEZBMFFxSi92V25I?=
 =?utf-8?B?SzIwRjU4RzVpS0w3VUNqa2FDQjJPdUt4SUhVUGl4V0NlOThUVVUrNVF4K21j?=
 =?utf-8?B?QU1oMlIvRmp1eWlxK3BJRWh3NFNRd3B5cDlvbldFdkRzNk12a2RDcEdodDQr?=
 =?utf-8?B?TWMyQzQzMzVEbU83YURRdkQ3MmNpMGF0NmYzWTlYeURjbnhUMzE4ZnFtR2ly?=
 =?utf-8?B?Q09lbUxZeE15MlNuVFdJaUZxSGpGVWdsek1ITW93clEvbUV3a29mOUc2Qkpo?=
 =?utf-8?B?aHduQnlTVzZ5Z3k2VTAvcVcyNmlhUHBFVFdlaWhXZDBGbTFsdWl1S2lqWTB0?=
 =?utf-8?B?T0xHQlBHaEdNL0M4eTdWbytYWkxuSmNwMTY0WkxsSzlZbWRVTFI0aitZZURa?=
 =?utf-8?B?am5Idk5ncC81c0tRRTlHWmVzVXUvUGlKdWFvMnlBclRSaFkzVlpEbXJqT0JK?=
 =?utf-8?B?U1dDUGN3ZDV2a00rNDhselpaZU9KWGh3V1k2T1BzS1dtaElKZmlsUEY4OHpk?=
 =?utf-8?B?RjBDUnhpQVRHZG1oemJrdmx1Z3RyWGtzQjRVUlN1WGJVWEI1QnZSazJVbkNm?=
 =?utf-8?B?Q0tyN2lHQXdvaWY3QzJPNi9KZFZmTmQzYzJobVEyWlVRNDk4UjBjRWRlU2t2?=
 =?utf-8?B?MElELzQwRis3MG5IeWkySnhJYzUrMUJiMjEvY0hRKy8xWkRQUEpKck5XOE5I?=
 =?utf-8?B?Mkg2RTRBaTcwUnM4cGlKMEMxSy9EczBpTC91NzZudmNCRDhRU21heXpzQmJO?=
 =?utf-8?B?QjcrL0tmTW9SVnl4RXRMc244Q0ZMTVgwME9NUVpKNUJVV3B1bU9abHhjR2p6?=
 =?utf-8?B?b3lwaVhkS0g4WldPanBXRzljbUdxZmw4Q052OFRxK2p1VVF4MVVDOWdLL0FN?=
 =?utf-8?B?K21WUkQ0YmR3U1BLOERsa1IyRHRYUmhVcmFqb0xDalFOQjdyQVZ2b1FTYjhL?=
 =?utf-8?B?TXpSMmxkdWFhZmxiTGlDVk1iZEZkeGo0ZERXMXl3V29MVUpaWHhZUmRQV1VE?=
 =?utf-8?B?dVorL2JMb0FwMi9JUm1XVGs2YWtkdFpQU2Evc3dPczdPNndtQ2QzV0tnenFi?=
 =?utf-8?B?bGlQZ0JiT2c5cUJDS3B2TGFPUGVXTzBRNmN1bndBcVNCdTF0OXlQRnZaMjlK?=
 =?utf-8?B?b3VQbytWczhlS1JRZ2UxVEE1MTJYcEtpbmUrL2pjZHBTZzNaV2tTb2VvdW54?=
 =?utf-8?B?ZmxvRm9ZeXY5RmRWUTNDUzBGQ0FWYkRkTnBIL2tmWUpqVG8reUJPb0IvQVp3?=
 =?utf-8?B?NjVLU3NsbFNxR2xxTW5DYU80OTJvYmF5cVVHWXo0UXdRQS9GWnVYWGJDVmJE?=
 =?utf-8?B?eDY2YkxGMElDcGJ6MFIzaGl1QjBtM2l6Q2M0L1JBbXJWMVdtcjNLTnFjSUFt?=
 =?utf-8?B?QzlMR0k2bHJlcVQrVHFJUDVSZWE1MmJtd1RXL3N0eVc4ejQ3TVJ2UFBWc3hr?=
 =?utf-8?B?ZlZEOS9KZEMyRGtTdzZXOWtLeXo5VEZpbUhNQmVvY3Y5QXY1TnVHaUJnMUFI?=
 =?utf-8?B?ZURyZmZnSWlKNWlSMlFzTHI4bllvb3BNVG9IZDB3QXhQcFlTQmZUbUNGZTJr?=
 =?utf-8?B?WWFlQWZzMEZxNjhrVVF1Z1RuQ3hhb0hqM3FkNUdTQlRtLzJoZ0RISnQxaE5Z?=
 =?utf-8?B?dU1TVWo2ZVV5Mzl2bHRpV3oxb040emlaVElvblFqb2FXUjBla0had1pqZkxj?=
 =?utf-8?B?RFBOUDNnZDFIajFwMEF1TW5NaEtCbXlYdHo5Z2E2aWVxajd5Vk5EaTRoaVJB?=
 =?utf-8?B?WUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6af63a67-7659-47f8-5a00-08daddd55ec1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 13:16:11.6051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2uD6ohbqvaEdWNBgHMtG0ZRXTw4ddcfjiaiA2FMIt4Q5M4dvqeZXhdlPKfmmxjVj7H+A9YqEmOOIM+ukJ+EVog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4658
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_06,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140104
X-Proofpoint-GUID: BATvThsU4yZXk7-kYETSfJIl_aedw_Zu
X-Proofpoint-ORIG-GUID: BATvThsU4yZXk7-kYETSfJIl_aedw_Zu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/12/2022 12:47, Jason Yan wrote:
>> Note: you made the changes as I suggested, so I think that you could 
>> have picked up my RB tag from v2 series, thanks.
> 
> Yeah I used to do that before. But last time Damien educated me that I
> must drop all the RB tags after the patch is changed so I didn't take
> it.

I think that they should be dropped if significant changes are made 
since the original tag was granted - that's for sure.

However if I supply a RB tag but also suggest a smallish change along 
with it and you implement that change in a new version, then it's ok to 
pick up the tag.

At a brief glance, I could not see this policy mentioned in 
submitting-patches.rst .

Thanks!
