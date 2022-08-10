Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94382C19F2D
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Aug 2022 03:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiHJDfF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 23:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiHJDee (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 23:34:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680BE647E6;
        Tue,  9 Aug 2022 20:34:32 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0E8VD026805;
        Wed, 10 Aug 2022 03:34:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=dCo8sS/fKOLwmNMw276tQHX9XSveWua8jOevfh2tbjM=;
 b=TUVbOKAyiyTGz/AsVmUO/l7qhv8v3fYXX5juun/32qpEmQuHeJZqBfsiGMJJubQ0EEwz
 +cd3Ov3tRnab7WFlVaVe5AuRI7MI8gZFwLyIv9zRTHAfXu0n+GVBMUks2ZMSDGv24AHP
 Dns3INAfF8++Zr4At90Mj4DBQyXMNTKbtV43fGcophtUoL0MY9Zf5NyIUXu4FZ9tMVJi
 62CwpzSfRgEU/P8zYTOu7ZYHsQgEvwXxmKB/Inz+CNZeOsKUtLY9lyrdHc6XjBko9eV7
 xIVtxlZGMeG+h0sixNgs+SEVwMHqUo/SjTxPhrAlzT1DPK6miYXQBJx3u+0O9sytOR8G VQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqbgqq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:34:19 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0YFxu005087;
        Wed, 10 Aug 2022 03:34:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqh8v45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:34:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cyhs5a32sAWYj26G6pLJtvGPNVNrOC6LglQGMgoXlr4mO2AHzemwMlZ/wzGdzLnoKnG+l0rIju0Mjm7o3j87QgQ00I8s3MbDCUOS4SEtix+z2mCFuzsg+s3USqmv+t8i5tj2QWjwnwDV683dN+J+S2ihFbIJtjCVVguXMsRFSEYGDMOcYzPm5A+UZISyffWIk8pEO3SOYe5H6E67lkRIr+Q4shiiJ0kWkntkPHr2NQFdvv6BcMyNzFgdGNaedHPxcGMhnSKGzNr0+e/EXiS0xk6g3cxrnfDWZt26OU2DFCuVJsj+piMQQ2pZctxfT32EUTg2v4EXLpJXhnwiE1tUcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dCo8sS/fKOLwmNMw276tQHX9XSveWua8jOevfh2tbjM=;
 b=dZeqnXYjM45NkBjJO82eaM/VdoLevVYpFVlUCgUyerGqomQYnKCxAUpz0UfbQZfrKso3Ty6Fw0/yTIbdycDvboK8Pq3PUzBSEqsF+OSahLVgHRgmvAZT0E206xhvuaMCxlygcA5F8TaZrWQrTAr3SprVCYvSOg3fGmXaOgrkrLt7AufLwuyEWWmEUDaz57/FgixEH8OM5bmy3tcrJTVFQeSx1UeUmyxY4zYcZlySY6nI+21u3k3GBzvgPRN9WDDcZbJGQsgX92BEuOMnHMn5HRySN+oZ8XzmjpF/MFAjaeDGot3xYTGc1yUmnPk3l8LecwiO1NSYof7uBbjX2H3uOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dCo8sS/fKOLwmNMw276tQHX9XSveWua8jOevfh2tbjM=;
 b=jjleJ3sbtB21jyjQy6otD5gWGKFGmWzHEwEf7CM4MvNA5oF2rSqH8NY/6PItk2zYmW5++jL9jDNHtYcxQdCYI9u93z4T2xrI+nWRB9tg2s0qHvPVd8giU853Lk1srcHdeBRn2ZgfG/C4SgVamQlrmOHDIm+oD/zMamyVAoDzhMI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH2PR10MB4375.namprd10.prod.outlook.com (2603:10b6:610:7d::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Wed, 10 Aug 2022 03:34:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:34:15 +0000
Message-ID: <6d814bf5-e1c6-af57-613d-ea02c8bc2ebc@oracle.com>
Date:   Tue, 9 Aug 2022 22:34:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH v2 12/20] block,nvme,scsi,dm: Add blk_status to pr_ops
 callouts.
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-13-michael.christie@oracle.com>
 <20220809072155.GF11161@lst.de>
 <4af2a4d3-04d1-966a-5fd5-5e443b593c8b@oracle.com>
 <4768d11e-06c6-1b74-9822-b2421a3f59bb@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <4768d11e-06c6-1b74-9822-b2421a3f59bb@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR07CA0026.namprd07.prod.outlook.com
 (2603:10b6:610:20::39) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24f7994d-2714-431d-c0cb-08da7a81333e
X-MS-TrafficTypeDiagnostic: CH2PR10MB4375:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fXuIDKlp2owv0QSzxiE88pC/+fIEKCQ+GquMUe4Kyf2beiBgkw0irbHOmJHxXua/DxLmQAxeeUr4PcD1Ni6FiJrlcTGpSVx/Ruu/5URgnx4eDTmK9HXc4IcGvO4yvc/GVEMMyPjH+qFeDcn7UiIegDp01hodJx75mmGYeyvLR/h1O/FWtX+4nv6aRTdcn65yZDdjp96cjEimTugyAL5hnCOJ7xPYW5Qr1XfzTtuNzRQ9DGildaT3fPRV6Xx4oJ01jP7gFloIqu4FKn5acCG3VN1pqiLADzT+bnAv9nEViVu/SoSMSlQJE60bAHAx8vNcLRIpDQh2KXK1t5VnB0WisXjvDl+yhtZ8/X8CQvGKi2+ry9Nrh6TQBOZq0DBfDqYy6qzkPmqNndP8FhCIQUNZ8+4Q2/MmrdsqJYROKuwxVqAOK/PeByt+ux5F5IaBen/6CqdLKubuSGjs0ZaBg/ExlLP68vZuEde7Equu6d4+DXue/VIZYTiN9ys34zqVj4WCjc6NJ9HGakoeF2vbOUMCuNwogneSoiZWKqe7oVR7h4+FsKOmOdoJEc7vr7W/9HcfoE9kh+npM7S9byTA9n1TX7Kl1JR03NwvbS41YQa5JCIYfJd6R9BMHK57Q5WUcaycd1vUrTT830JAywiBvmpu9JLYeeM7x1XSrv7nuLBbG7kM2dYC4hhoQgvykucKTgdPyhy9I2UUBbjjGlgjfnHAk6k4D33klUFeg8uiIFC6jJqaaG7svE+IR/aWEBI8WB+92JeqAZhqV4w3s1gdZfMOywyNyGcZSMoVzvlojbx8OEAJkV75klsWujQYchV4otLF17mnHYR91/mkP6Wn464b/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(376002)(346002)(396003)(366004)(5660300002)(2906002)(66946007)(36756003)(478600001)(110136005)(316002)(6486002)(31686004)(8936002)(41300700001)(2616005)(38100700002)(6506007)(53546011)(26005)(86362001)(31696002)(6512007)(66476007)(4326008)(8676002)(66556008)(186003)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ck0xcnZ0U1BTTmNpWG9RRjdNTVF3K2lVQ0ZGUTZIMDlzWkdmRmMzcGo1V21X?=
 =?utf-8?B?QXFVMTQ2cmM5RmxLemh0aWN3NzY5Mitxc1RpVThJb1F5ZEdaaXZGeWx3Q0lR?=
 =?utf-8?B?L09lRFNxT0tMcnZtaklZOTJpVFNwNHI3bFl0ZGZxTWJEVW0reFZUYWVyU05F?=
 =?utf-8?B?UmFrOUdPMnovekZaM29JNW1mWEVMRkZ0czluck4zNTAyMzgrT2JNd1RxdFFJ?=
 =?utf-8?B?WlV0UVdacWZJUFpLYndKZmdHSW8vUXl3dDJFWUNCMC9veXpzSzdpT3lBWUlo?=
 =?utf-8?B?OUNoK3h3N2o0YjJXN3VjQnNwd3Z4cnRaZ3pCbnRzRWlsNUF1YklXbWJyMjJ1?=
 =?utf-8?B?MXpiTXQxVUdUcGhaY0FPSXpOTjRxUEsrSDJaN3BROGpNTmxiejNRVU5EYkRK?=
 =?utf-8?B?NGJNemFYVDFCaVIyQVVkVkxQSmdoVWxYVU5uaU5IaTVISjdraHVEdlNuK1RR?=
 =?utf-8?B?Y0h6VzI2NU5OWEducDFWYTJBTzRmRGNmZll6VGpoTlR2OG1SdnNQNjYwN2xM?=
 =?utf-8?B?VEFUdHhhM2NvOEpCZWRlOUo4REVObi9LSnYyN1JNTDNMak5GNkpEMnlXV1RI?=
 =?utf-8?B?blR0bk9zeUhlUWxITXJLdUpDYjZZRlVtRTdFYzRORXZIdHI1dG15UjNKT1Ax?=
 =?utf-8?B?RCtQYWRnVzl1WlZSRUVhS2dyYWF5RGxHZnVxaG5Kd08zWUEwYi9xSEVNdXJ3?=
 =?utf-8?B?eEFtZ2pqa3VPNE9hSWFTb1lhdWUzZnJyT3V5cTRaM0FHTDd2dmQzMmYrRmgw?=
 =?utf-8?B?Y3ZGQ2NBSC9YV2wrdVBxdW1KRFkrbW12c25iY2J0Mk5xak0zTSszOG5Tdmxw?=
 =?utf-8?B?RTR2QXpLOVVIUXduNm5aUkpMOGJZVjlIZUhwZWpMU01pc2dDY3BKY2Q5Ungv?=
 =?utf-8?B?aE1vSnFXbEtMVE1NVkQ3MjRGZUVySkFCV3NtS3lTbEt5S2h0YW5mU0xDNzRI?=
 =?utf-8?B?dFpEYnRuNkRtTy82QW8weVlRRE1Xb3dJUkhFbCtWbThBNFFiS2xTaFN3VWFB?=
 =?utf-8?B?bDZoNm5xYzZ2UnFDUTJaUEhaa090WjRBYWNkazBiNityamFNWUgweEhwU0Nt?=
 =?utf-8?B?WWE0Vzd4M2dSbmZKQm5JWEVvNzR1OHhYaENSZTBhVXBOc3JEckt4UHN3REFt?=
 =?utf-8?B?S2gxbnNvbHF3SDVHLysyTTFMdVRiOEhQVkgxdlJ4MG5BcklIWHRCYUFHMnlS?=
 =?utf-8?B?UGczQjlDcTgvWVlpc3pGR2wwV0xmVTJwelJ1Q2ZUcFMrRWFFTlFtejVxZ1la?=
 =?utf-8?B?aFQyVDUrZDBsbFVQY0t1SmRJSDBIWEptcEZpRHFXVDJldnlVY1N4SWU2bkM4?=
 =?utf-8?B?a2ZRcWtrYXFlRHFPUnk1YlRpc2pteWR5a0VGRE1HMVExTFdNN00rL3dYWVVl?=
 =?utf-8?B?a3lVWHdZamhiSVJDWUpTVVFFUFdpOHFIN0tXeVh0elRhaVNsckt5WXhSai8y?=
 =?utf-8?B?eXRLSTBlUzY1M25UdnhKZ01PUW1KUE1ycDJRZkU4VGIrRUhIeGVlQVcwS09Y?=
 =?utf-8?B?V1J5K3BYdm5pRVczck1hMWVLZWFVc0FsRDQ5TTMzWkg5WTlmOU9QUDgxOVJs?=
 =?utf-8?B?RmdwUVIxZXJ2QU1BdVgzTkFwbkxKRnpzdWd5OStyTlcyZHBORC9uUUpCVEJQ?=
 =?utf-8?B?ZmNWZHZ6UU1JSFg4M2tvZDZ5c3E1dDd3SEQydDdXVlJhUDVVbkpKVmRPNE8v?=
 =?utf-8?B?Y0ZqdXFKaDBrc3BwVHd6c2h2R0J6WHVZVHRsVi9kNjZpckowbzBEbXJ4RHVN?=
 =?utf-8?B?dXdIejkwR1pLWHlJaVVhZk95MkdTbWcvVE9VWVRkR3p0cWxYSklMWmVzUitL?=
 =?utf-8?B?N1Fjdk8zc0xjblRMWU5OcGtNandEMVdTdE5wMGxwd1Z6VFhzM3grOHRuWHZa?=
 =?utf-8?B?VlkwUjFqcXdkNnlLLzA4djBuVXhwMURNYnd2QXc1TjgrZFB1cW9ZRTljZ09B?=
 =?utf-8?B?cHhneEhTcVMyNWtpQUF1TmhaOUpPMWgzcnVuMDVyV0FoLzdUb3ZDUUtkL3FU?=
 =?utf-8?B?MHF2ejhKSmRjMS8zeE9FaWVxOVJqQ0FnOTRSWDF6cGd0bUZiRGZwcFltSHRU?=
 =?utf-8?B?ZndNYVBHaFFiMk1La01vZHplUnhNdkwzSVF2TFJjOVNBcXA1eWNIVGZ0ajFi?=
 =?utf-8?B?VkUyTklqNG0yUWtremEzWGljSHFYSzYrZVNEUnBEd1VEK0Q3Qzg4Snpac3Mr?=
 =?utf-8?B?akE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24f7994d-2714-431d-c0cb-08da7a81333e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 03:34:15.7029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ESxBGOLpItr9G3z0yp1f0cIIL3OTJFSZ64Z2YlsYVdBf1x6umF/u2rRuKV40vvcdmgigwmejQvxom+uINTVIr1MPHJ34boZzt6SCrnCPXg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4375
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=988 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100009
X-Proofpoint-GUID: QqBs539NXERf_TEVO5v3nIIxlH1pup1w
X-Proofpoint-ORIG-GUID: QqBs539NXERf_TEVO5v3nIIxlH1pup1w
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/9/22 2:33 PM, Bart Van Assche wrote:
> On 8/9/22 11:08, Mike Christie wrote:
>> On 8/9/22 2:21 AM, Christoph Hellwig wrote:
>>> On Mon, Aug 08, 2022 at 07:04:11PM -0500, Mike Christie wrote:
>>>> To handle both cases, this patch adds a blk_status_t arg to the pr_ops
>>>> callouts. The lower levels will convert their device specific error to
>>>> the blk_status_t then the upper levels can easily check that code
>>>> without knowing the device type. It also allows us to keep userspace
>>>> compat where it expects a negative -Exyz error code if the command fails
>>>> before it's sent to the device or a device/tranport specific value if the
>>>> error is > 0.
>>>
>>> Why do we need two return values here?
>>
>> I know the 2 return values are gross :) I can do it in one, but I wasn't sure
>> what's worse. See below for the other possible solutions. I think they are all
>> bad.
>>
>>
>> 0. Convert device specific conflict error to -EBADE then back:
>>
>> sd_pr_command()
>>
>> .....
>>
>> /* would add similar check for NVME_SC_RESERVATION_CONFLICT in nvme */
>> if (result == SAM_STAT_CHECK_CONDITION)
>>     return -EBADE;
>> else
>>     return result;
>>
>>
>> LIO then just checks for -EBADE but when going to userspace we have to
>> convert:
>>
>>
>> blkdev_pr_register()
>>
>> ...
>>     result = ops->pr_register()
>>     if (result < 0) {
>>         /* For compat we must convert back to the nvme/scsi code */
>>         if (result == -EBADE) {
>>             /* need some helper for this that calls down the stack */
>>             if (bdev == SCSI)
>>                 return SAM_STAT_RESERVATION_CONFLICT
>>             else
>>                 return NVME_SC_RESERVATION_CONFLICT
>>         } else
>>             return blk_status_to_str(result)
>>     } else
>>         return result;
>>
>>
>> The conversion is kind of gross and I was thinking in the future it's going
>> to get worse. I'm going to want to have more advanced error handling in LIO
>> and dm-multipath. Like dm-multipath wants to know if an pr_op failed because
>> of a path failure, so it can retry another one, or a hard device/target error.
>> It would be nice for LIO if an PGR had bad/illegal values and the device
>> returned an error than I could detect that.
>>
>>
>> 1. Drop the -Exyz error type and use blk_status_t in the kernel:
>>
>> sd_pr_command()
>>
>> .....
>> if (result < 0)
>>     return -errno_to_blk_status(result);
>> else if (result == SAM_STAT_CHECK_CONDITION)
>>     return -BLK_STS_NEXUS;
>> else
>>     return result;
>>
>> blkdev_pr_register()
>>
>> ...
>>     result = ops->pr_register()
>>     if (result < 0) {
>>         /* For compat we must convert back to the nvme/scsi code */
>>         if (result == -BLK_STS_NEXUS) {
>>             /* need some helper for this that calls down the stack */
>>             if (bdev == SCSI)
>>                 return SAM_STAT_RESERVATION_CONFLICT
>>             else
>>                 return NVME_SC_RESERVATION_CONFLICT
>>         } else
>>             return blk_status_to_str(result)
>>     } else
>>         return result;
>>
>> This has similar issues as #0 where we have to convert before returning to
>> userspace.
>>
>>
>> Note: In this case, if the block layer uses an -Exyz error code there's not
>> BLK_STS for then we would return -EIO to userspace now. I was thinking
>> that might not be ok but I could also just add a BLK_STS error code
>> for errors like EINVAL, EWOULDBLOCK, ENOMEM, etc so that doesn't happen.
>>
>>
>> 2. We could do something like below where the low levels are not changed but the
>> caller converts:
>>
>> sd_pr_command()
>>     /* no changes */
>>
>> lio()
>>     result = ops->pr_register()
>>     if (result > 0) {
>>         /* add some stacked helper again that goes through dm and
>>          * to the low level device
>>          */
>>         if (bdev == SCSI) {
>>             result = scsi_result_to_blk_status(result)
>>         else
>>             result = nvme_error_status(result)
>>
>>
>> This looks simple, but it felt wrong having upper layers having to
>> know the device type and calling conversion functions.
> 
> Has it been considered to introduce a new enumeration type instead of choosing (0), (1) or (2)?
> 

The problem is that userspace currently gets the nvme status value or the
scsi_cmnd->result which can be host/status byte values like with SG IO.
So you could you just do a new enum or add every possible error to blk_status_t
but before passing back to userspace you still have to then convert to what
format userspace is getting today. So for scsi devices, you have to mimic
the host_byte.
