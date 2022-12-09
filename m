Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14EE9C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 10:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiLIKEH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 05:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiLIKEG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 05:04:06 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B3518E05
        for <linux-scsi@vger.kernel.org>; Fri,  9 Dec 2022 02:04:05 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B97nP5j017091;
        Fri, 9 Dec 2022 10:03:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=loCuz4EOD6cf4E97KI5khvL4JKxtTIneVFamYlu544Y=;
 b=vFe1Ttufj/NTfb5ODpPBd11Um/YXuTbEorvkxWcpOz4q2C3wCGmndGjRW7N+fn7J84jx
 HPbhnJLCV5B1B4QKAj1S1k0k29OhdVCv96VnrKrV0B24qo52VVXQM6QomnOC6ysci2f+
 bEGr/FZk4mtOZQfsMswtJIMEVIWRUQsgNdg2/sEvdT6ixW3gBb9tNRHsUJlLr5Zqwux0
 SXreKNijP3Upoj1ALmakVSJpVmVNTRMxosp/Peg+r4fkAvJPhLntzcq+vMUiTG1Bh92a
 MPVvfMeVaQHYatYSZ3jkn4enWK1W7iGP6I838YP2vTVcY6bFS16hhGqM1SCqDvt1qQw3 Lg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mawj6uwe3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:03:55 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B98TKSl032653;
        Fri, 9 Dec 2022 10:03:54 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7fmhwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:03:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RJZPhfQSNE9adJBRkhUFNbGXFKNZlweBwMN1nt6etXQEsW3k1kOxbDWovKaLgHzfDKWZ1ZBDBjqlDhv0MlrxjJtLhSKN/K4+t/ZsVOew9W6bTrIRdeaFmGaLGpaI15IEzdaBYn0AKfSt0oIOe+bW5T3FUPjICd1o/EVMKBom/IaY4MZpa7T7Qd0Xb65nENgC5YkR6YA/x+3RF9bxRXIRMp9G3koKNtIgFmaM9rc7tlb3kyihm//vYUxb5QD0XONE/OMuCbd5sWcxJNqgc3DJhfIo8vZv0tueuf0n+UJwEd3acwr6MF6XEKiNM0Bnd3eXk/RKrF6bspdjOelfikMkTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=loCuz4EOD6cf4E97KI5khvL4JKxtTIneVFamYlu544Y=;
 b=gZTJJ9Vb61X6vk3CL8VwhaVsk6feFG/BpryKp876zkcNm4+7qcgav+6qKOs3TmTWYsfOoxrOnv50h+n9zZFWf/yGWZ17mkRiqxy35gu/bH3g3G1mSzV5gSv09ZP6nlKuPlUllOiZYidDyx6R6JJ5z0h2Nko1swrfd6CZ7vL1kYjfylPvIyL4mG9eK70R0X8olC4VlcXC7Rsx58ySNx7a4RB4C9li9GuO4Zo0ZMW9qSqhUdpVD2XFhTMW4It9UmO8eNZGnrj4MvzafKI9TQj6k0Pbzxq87TQfnBmjfaUK34KbmMznwkgV5vJIQE3IUE3qykvW45RNbhHr81SqeRa01Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=loCuz4EOD6cf4E97KI5khvL4JKxtTIneVFamYlu544Y=;
 b=myMTeBdESlM/p/zhwOarRl4jzFxX6UibNOe1MsJZoS4Vpj5bI85rTZoVghwY00ngWjwvdxk+B8rSc9S09E1YVWKX2xNsFCV46KWjLkkwPbBwuo7aop1YwGXs+ySVgPfIs22qfyhtJN1YF4WLHC1uNDgup54kB/Zhb2XuC4AUWUE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB5733.namprd10.prod.outlook.com (2603:10b6:806:231::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 10:03:52 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 10:03:52 +0000
Message-ID: <96c76679-6c4d-789f-935e-3af564a5b314@oracle.com>
Date:   Fri, 9 Dec 2022 10:03:45 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 05/15] scsi: scsi_dh: Convert to scsi_execute_args
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-6-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221209061325.705999-6-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0065.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::29) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB5733:EE_
X-MS-Office365-Filtering-Correlation-Id: ae5fa43c-d4b9-43e8-0f55-08dad9ccac0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ai2oz8o/QBnEZEI1zIxZsmlNggvAkwswhBl91zhCdOjcknHoyLaPtu/Z8qoe7KP4dGDPFmYnXvUtlC7ihbufUxzL5gupDnuDyDDbYWuGtOtZO0UG/9iizB8QQXndmVuCgYNKDOQRtQYt8MTq9f918iNYp+hPggfPcrchqHmKY8lOK5M+elr0ev8uofDEh8nOnF+/J5g5NvIm4IlLHdlzgXv2j+PU+8hRzUAyu3P+eIitsuM7wu0vEaJ4MmqmsgstAjRvoy2KfAjeeZWqywVxY19Q3YZwAkLrNEK5PUL8lXqE7UAZUQXIKXoA4XRZArvvQvT8E2sa3Y2Vp9dIVvxFgAYcfRwT1n/Ycp6jkR95nzvqJcOV5nEoPqlOWE1gHfVozC+cAlt7ZwTBYGZM/ucJ3sMw0E1hXVcUYngdoRQp7Zm6O9CJb7DlHD9/fkVVPEXDg/Rb6kP1FLOMXoBC50MIu730HnGZyFAdIbC7aQYWy+BOZ/EiH1PK+d9Pa2o8ZvmDyjKjMnAov0XS9OnrQDqL4aq6qXP6kpbsA47bTE2rfQeGrmKNgNvk1WKEOKDaKdXALVE1q04ONtBQ5XVug48ZJNVyBhj7F/tfbl5SQNF/kFDWn92sVvWXvdW8jnn2yX9O00FJRAtgNlcv9N8DemldrBzsCbQzqBE5ydHIVDxRpQtb+hXvXea8HXfNdDFYMZSil5sxSmZidRX+FKUoYHJgIdzfn3Df308W2kJ12olwzY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(376002)(346002)(396003)(366004)(451199015)(2906002)(5660300002)(31686004)(41300700001)(478600001)(6512007)(26005)(186003)(558084003)(66946007)(66476007)(66556008)(36756003)(8676002)(8936002)(38100700002)(316002)(86362001)(31696002)(2616005)(6486002)(6666004)(6506007)(36916002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NG1IQ3dzeU5RRWpQL0xDUEEybVNsKzA5ZTRNMWxNb1RRUmNuQ0xvbGRlcXlY?=
 =?utf-8?B?UzFyL1hjMlRKQUpxZmY5QTBIU1M1V0s2aWRRLzVMQWZ0dGtoRVRHWHpuMk9X?=
 =?utf-8?B?QVpMZjVsMHAweVl3V2txbXo4RHpCZ0NGa3JJeGNQVCsreVpSYTlrWEhoRkNK?=
 =?utf-8?B?RHdSY1FLd3o4KzZlMVRsMm9odSszREtiZERlZlduM0ZFM0huenFDQ3VjM2Vh?=
 =?utf-8?B?SkFvWXNuMlZqdi9ieUhwdHJJZEczZWcveVRYM2tsTldsYjFIbHl1dDFBUU5Y?=
 =?utf-8?B?TVlHcnVyVEoveUpoOUNBdGYxZ1BkNmFwMGh6SnFpQXVlYjlLQ2ZZL1VaQjda?=
 =?utf-8?B?QStQNW1YUUR3Y1ZtZlRBK3hyc1A5SDdRYVo4V3Z5ZXVaUTgwZFNNWTNMenFC?=
 =?utf-8?B?OHdmSFlIQUdaRFJXQ0tudTFpYnNRcVVHcUQ4OEVsZUpxYW03ekZXYTQ5M2VU?=
 =?utf-8?B?TldXblpENDVndStETjN3czJKWXR3dTI2TE9KVWp0Y0Z1d21YNzY0NzRhazVD?=
 =?utf-8?B?YzVLQUNJWUJHcTFTVDNMYm5zUkRzcEtQNjQzR25Nam13TStQMXJsZUlmcHF4?=
 =?utf-8?B?S3V6SmR1RzNqRytWT2tOVURubXBINFVLUnRiU1F5OGVITmkwZThpb2NsWkR1?=
 =?utf-8?B?TlJPbHl3akIra3VLZk9CQTJ4R3Z1OUVOaFZQLzR6b0k4S2U3aGdzcGZZZGtF?=
 =?utf-8?B?SENkdlJOWXl2TThBenoyNm1SZWZQdU9xK3VCc2pESmhnVkhnOURzMzkvb2Rv?=
 =?utf-8?B?TzFvd3ptekNXbHlscUFwTFJUT0M0MDFTaUlPUWVKUE1Wa0lySUI4OURtT2R4?=
 =?utf-8?B?SW1HYXYvaDZPNndhaE13R1RFb3V4cytCQUkrSFdueEpXVXVQR0FKWlRyNmd2?=
 =?utf-8?B?V2cxNENPR3JmeDdQVFc3RlA1R1RTNS9RMFVaeEd2bCtSM2hiOXVGZk5CclMw?=
 =?utf-8?B?MGlYSWFkQ21VcWVXQkxpUkkrdThxNXpHRUN5NHMybCswVXQwb1g0WktWc3Ax?=
 =?utf-8?B?c2VaZG1qN3cyU282ckhKVzZUc01Pa2dXTTYvZmF1UzZUcXhSMGRzVzlQNTAz?=
 =?utf-8?B?alBJZEJ2SWlGeWNBQlJESTlvMWp4UlZnd2ZsOVFsQ1lrbTI4eHBsL1B6d1NX?=
 =?utf-8?B?WlRzS1FmRHBVc08vb1JtaStBV05HbU0yaWtXaTQrNVh2dnFzc1hrZzh0RWFY?=
 =?utf-8?B?V0Z2dURhTkYzQUEvV1hiV09xLzNMaTRJakd0RTdJYXhwSzgvWUREcGV4MGRp?=
 =?utf-8?B?UjBIM2xtSG9ZRFRicWZEUjhnWDJpTGlhZUVaQ2QvQlhnTG1wb1F1a2Vqdk5R?=
 =?utf-8?B?VlJNTlpJM2p4RktvUGtQUklWYzRsVnEvNE9ZTXRWdXZONDNSUUUxY3JkaG8v?=
 =?utf-8?B?VlJHdk1JSGhSMXVLSXNtYXlyUGhIZmVXaUwyOTRadU10T3RjTGRmSG1PN2ZR?=
 =?utf-8?B?QjlHcnJhUW5taXZyeXNMSjVoSEpoUmc2Z3QvVlorQ2ZvRXZ3dy9KR3A3Q2Jn?=
 =?utf-8?B?Si83aWhtUEs1UDVialk2SERoUVV3d2dISEtVVmI4N0pzekt0S2JScHJjRXJa?=
 =?utf-8?B?eTh2aHlHTFUrSkg5MUlLSW9sbFUvVXZaU05YOFlsZ2RTQXZLR0IrRXZQNUNr?=
 =?utf-8?B?UTBtYWI2UG4wc0MxUXU5UlI4WW82bGpHQmJuU1UzbFFmS1JmMHduS3gwRTRa?=
 =?utf-8?B?cEoreXdCc0N5OXVHME5WL0xybnJvejFFUEp5Z0I0YUdGd05QTWNvRHVtcGNj?=
 =?utf-8?B?OHc1RmVGMWtLaVNtbVQwRnhpNGoyeDF1R2loaERqTXU3VkpKQnB3cHlXWWhp?=
 =?utf-8?B?RkVSWUJPOVV5bG9lVk1pWlhVWHhLT1JEdUdmRit0MVJPYlZmazFzb0xFS0ZY?=
 =?utf-8?B?RmZsOEg1cGRpSlJIajZTNVpSWUNqVjk3VTlINHg5SHhZUjdybHBmK2krd2RW?=
 =?utf-8?B?dDhVc2hwM2h4dlN1NWgraTVRRVdqTVgxaUF5Z3Z6QUl1LzlPVi9SblV2Nkxq?=
 =?utf-8?B?MkJPazhpM2wxOXBTdVBHNUt0L0FTSUcyM0J3WmFybUlXc0htdUZtOVY1dWti?=
 =?utf-8?B?Ym9HTWxNNkxVdjI2eG8yRHFkSG5OV21za0NhbmxiOTFJRmcrb004NDVSejdI?=
 =?utf-8?B?WVVyWCt2V01pK3lxZnhDM0E1UVdYdHhhdURsODdLQnFFR3hvQ2tvNWEzdDZD?=
 =?utf-8?B?L3c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae5fa43c-d4b9-43e8-0f55-08dad9ccac0f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 10:03:52.4279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8plj+LJyZvl3O60TdemNeo0IGM/9jHDhojCiZ0BSJYrxrPbM0C75i/wIgQRTKE6J3H/4Wn6GQ/Wf9yBROkLwMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5733
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_04,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090066
X-Proofpoint-GUID: uPN4fWq2dtgF8LJ6ceIqHzAK7Nw1y-Qv
X-Proofpoint-ORIG-GUID: uPN4fWq2dtgF8LJ6ceIqHzAK7Nw1y-Qv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/12/2022 06:13, Mike Christie wrote:
> scsi_execute is going to be removed. Convert the scsi_dh users to
> scsi_execute_args
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>

FWIW,

Reviewed-by: John Garry <john.g.garry@oracle.com>
