Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D48C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 21:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236888AbiGGViT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 17:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236605AbiGGViS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 17:38:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FB71C138;
        Thu,  7 Jul 2022 14:38:17 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KDGx4005689;
        Thu, 7 Jul 2022 21:38:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=xdUxnpvuZUwUnuoyLo0NnXcjbe1ZaHDRN97//TL1TCw=;
 b=IQHFwu+O8TXiQ6m3Udlfo9CSUtgIXKTpr66vOmm9LFk8dbTWfhUU6JvkjiKGIYmNJjwB
 mTurEaulBphoODvzRpeEkoPwtbn2TKx/X+pgfFQLmk+aW5DjL47S3xfbr2yNbl7vPFNI
 C8PkYp1hn0FpNdtCX29bXpHcG/MiXYmtQMBEn2Oax01/bW0qnVEdEycMgo71D4FY6OOA
 qGRIWjOcfq643L/gzGVvNx2MpxA6saYIZm3OiSyOzcGWZksZPXR4wHf6Gyf/N7b/Hv8d
 yjntZmkzjDbWWPfNfWzRd601E8JHJPVaUlH+qx6lFno/HshHFaJZHbberG9HRhQSEoaJ Jw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubye6h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:38:16 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 267LZuup037522;
        Thu, 7 Jul 2022 21:38:16 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h4udftj59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:38:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQAyuWxbiBqOV7IqABsVnTyy5TF5OdiKPnJ8nGqjEHs0k3MTW3lao75I+leWlD9Q3pur+KUFp9aalL1Ong2QRU1jWFqCbK7OP/5JmlYGlwjmj+bS0pJralgdFJKlZYAtBiXvMp573RB4f2eieUDuwCo52LxVFJx+CDMV1pcz1g6QiRGifvROSlz6x0PsYOnl9BydsE+3bXDOWKYbxgPyY4A/C9P2lp8auMJZHwbCqbK75N0MLr/X5SSGue9eWQtr9JH4C14WYnM4mPzr3h0cSfXTOcWLUHicXK/ypXfGBbosiTvpqZQdLDgNX+AY2+5JbrNDGJUfFGq0W1neHMx7NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xdUxnpvuZUwUnuoyLo0NnXcjbe1ZaHDRN97//TL1TCw=;
 b=YVcNf7OkoWZKcMoO8YdxMQwR/a4Qxnqx2QEMi4KiLWgIUuy+kr/65vHcjwRXmBwKC77L46o1kVjKPUh9g4Oai8UiTpyHYjegBSgUkQwLYlzB3CkUljJoUxa8Iqr8NUyKryX1JidegpkIQjJFE5DZ+u4IxSVJJHEGOR7DnZFyCqqt5DYbG3FAB1metEzSzX3ke+Fyj8KMY9GgEWVBwM+EsQRhpG5v+7NOubzgQE4v6VoPPB/ZNOkGrxBIrXJSaQa8YHr897Phj9agcHdmZ66j/Q4VRgyagM4GZMT6vEko+p1+ZdIjJ0KiFJUZ/ASJyQKFEgC8ROX66es1OLZA12+xow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xdUxnpvuZUwUnuoyLo0NnXcjbe1ZaHDRN97//TL1TCw=;
 b=e36e0/xoMWJLQitKiTvFAd78yCgtKlff1TusKMj7V21D1LzHZUMUEj7YrJ+ktLV0svXTx2YKYDrZ/dsfvB8BUi/hRJJ+qMck36Kp8HxRtsK84SVfoloZrIkZmMvdWHiTKRjCOeo6FycH4jw7LLvCPDshRMjMePw/OSS51hcomIA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB4978.namprd10.prod.outlook.com (2603:10b6:208:30e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Thu, 7 Jul
 2022 21:38:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5395.020; Thu, 7 Jul 2022
 21:38:14 +0000
Message-ID: <43954e86-cfd0-f27a-772a-10a03034ad30@oracle.com>
Date:   Thu, 7 Jul 2022 16:38:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.1
Subject: Re: [PATCH 2/3] target: core: make hw_max_sectors store the sectors
 amount in blocks
Content-Language: en-US
To:     Anastasia Kovaleva <a.kovaleva@yadro.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com
References: <20220630122241.1658-1-a.kovaleva@yadro.com>
 <20220630122241.1658-3-a.kovaleva@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220630122241.1658-3-a.kovaleva@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0312.namprd03.prod.outlook.com
 (2603:10b6:8:2b::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2cec576a-6c50-418b-6040-08da6060ff0d
X-MS-TrafficTypeDiagnostic: BLAPR10MB4978:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tc/rO/oy3pFjfBvsllDOIHhPEmD8SQcNMxtiwYVQandGKBzIjiq0znYJTxLWVnnthKrgrTrIrbjq++tLVyD4jTw33EMQEA3GiPbN8sakerHInA+wfx7WrKGLUiRDlE3Oqa/EI3jRNcXLODhds1GKe3AjG6UdO/w3HWvodKFmSjXHjrOuI2mfVe/IQp2bQu3RMp96n7XGuq+9qFpzE+4MVWEsYO+5WoXHuM1rWBAOO/bS7xo7qNDKTBvlDzsgn8wabeG1q8Vdwv4DKb16+geW8f2jRQRO0ody9A8rwVFEc5MtG81tHH9OMP+MLUNurNdKWkDUmCF5zreJl1psM3oLYMO0VECLBO/v4CRdcXmGae5DczknImnOD+6YvNJE1UcldxGrDjZDWNJNHuIOP/jETH2FZhOBJpYoEco8mLUtpwW1Z0ruFw7GmnzncK2DV+qDFJ5a2+wlU76WDYzw1lKD3uSjbF5VjrmgWwt+qs9HLVWG0RRXHORXtbh0SJXp9qlVe6wTGZ0b1zOIwcSxEjXqOMGgpJgzwcqFPlc15roJhZ5QKJYZrUtJOmixp29cNd8MNBqN7ZqCAq5Yar1kXoHK9vuYY+b6DDzyRLivmqKxRg7lUZqRbEDTKMNkxk42MDMOVMdCv9vpTSfuUawNOQxjUgJU7qjyTnD+E/ZI+1A1DIZKqeLuK0yIkgEMfIytJUu7gxEQ3JOQRuLOUBBBhxRQE6xRiSAoWM7pKDSVGo4PNJdKqSx/9MEKwu83VWIQ9fXy1e7C67kJCAEJgxFIGIycMjvEvCb9Ymkz45TYdsX/9EpKk4sSRUjnFPhGyT4v+db+yeE57fBnhb64MgWsk0ZFMn45Ks5MO+sKXdhYHY3SQFg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(396003)(136003)(376002)(366004)(26005)(53546011)(8936002)(4326008)(2616005)(66556008)(6506007)(8676002)(31686004)(316002)(5660300002)(186003)(36756003)(6512007)(41300700001)(478600001)(6486002)(2906002)(6666004)(66946007)(31696002)(66476007)(83380400001)(38100700002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0dSM3dDc09NOWw0NlZaTkZhRlBQMjBBTGxPSW45dXV3Yy9kdUFYenNmbG03?=
 =?utf-8?B?aFlScVhEei9QTEdRZmNYNjMvMzRCMUhFUXkwZjdGYjdJWGhoOVBDUkdFZHdU?=
 =?utf-8?B?ZzlMUGgva2FEejNQZ0JXM0p1Rjk3eGRRMGtqeDdlcGc2RWJUWmY2NGxZenAx?=
 =?utf-8?B?cWNYUnl1OWVTMFpSbXNNUkkwaGIwa0J5ak9mck5kWmM4VklsR0pyb1lJK3JS?=
 =?utf-8?B?U1FFWFZnMi9sUFNoZTNTS05kMzdUMHFkdlJkK2E1UktTZk9LQkFmUDdBZXR3?=
 =?utf-8?B?c1MxQTBHeGZsWWx5RVNlN1VJclppaFQrZThlaVVJcXRXc3RRTmJRT2I1cUZO?=
 =?utf-8?B?UVpWbnZPNGtZaVpFcE9xMTBkNWphZmw0VzBWdUw3M1lUL2kxUDdBL0U5UElS?=
 =?utf-8?B?VFhZRUVRQjJYc2ZzZGdnZXY0dlVMcTdkY3B6YldNN2d3eEpKOHZSeXlUQXlj?=
 =?utf-8?B?UEc0d21zNWRBQ2RlUi9xWm56YTl4RzBBdHNDUUcvNFFGWmQyQVZkTUZxS3FF?=
 =?utf-8?B?dXVqbzF5STMrN2xRK0VZd096cmJPc016amFFcXN4Q0dibmxQa0o2SkJNV2Y2?=
 =?utf-8?B?QjRuQit1em1EL3ZGTkZFMjIxbFo4bTU1ZEh3OUFJNC9DdDBYbnM1OXJMY2xB?=
 =?utf-8?B?Rm05UVMva2FDT2hPQ3dXdXpxNlYwcG1EblBkSkkxUmJ1STdNRTVQazF6TEN0?=
 =?utf-8?B?Qm4yb3k0M0wyNlZZTGJUM0cwWVFVeWlmTTRSbEFnWnltOGQ3MFdQc2NzV3JP?=
 =?utf-8?B?VUQrUTNDa0NJdmQ3SjgzQU80U3RnZjBBS1JNeVcyeFlxL25EaS9ySnI1OUFL?=
 =?utf-8?B?OHQxRE93T0djZ00xdkU5MGhqSnZNZXpsMlkvQTJ3dWxjZnB2Wm8xTGFGcXRy?=
 =?utf-8?B?L1lTQVIxTnhMTUF3eXhMVU0xN2o2R0lra3grMUV5bm83dGJwQ0dpZVZKSTZB?=
 =?utf-8?B?Wkh6VlJCWFZwZCtObGpRUk5nOHByVDZvWkJjRUZEYnI5eFBESkIwOGdQcHpW?=
 =?utf-8?B?MzRIVCtYeUZEc2ZPNGtBQ1d5Y2dDT3VBMGtKejNlVTU2RXRlNDR3eWRQS0JZ?=
 =?utf-8?B?ZkxWYW5QQTU0SFc4VDRwN0JpSzF6djdMbWdmNHA5N1RQZzBzUzM4dnAybElk?=
 =?utf-8?B?SDdpMlB4YU1HTkc3a0xpV1h4eXE4YU5ncU1LMHcvaXFLWS9BenNhRlBRQUVB?=
 =?utf-8?B?TWNvL0taUXRLbU5OUnpROS8rV0xwQ3JlZHI1OU5UWUUzREhhVWF1THVRNjhO?=
 =?utf-8?B?OHo5R2ovNUxEUlNSamlhNEtQSjYvK0pxdGxCSnpjWGRTcEtlVHFkdThieGgz?=
 =?utf-8?B?ZkduTG9MK1VGVUVVWkpDZVNId0NscU83Y0paRXZreXVRSXlqdlg2VGcwV3Zz?=
 =?utf-8?B?UWdRNDdIUXB5aVhHUGtXS1RMY2Z2SUhPcks1NlpSRG1aWGNzOGRGajlwYjZF?=
 =?utf-8?B?UVlPYjBobVlpbG9SRFFleGJBdzhxT1hnc2FTY1ZZRUcwb1JqaTcrTU9tZG5w?=
 =?utf-8?B?ZWkwR2dKRGhyaTAxTWJjTEE2L0pwN1ZTUEFkRDlxcVM3VmRnVWFIcDd5TUh4?=
 =?utf-8?B?MW9ROGpuSHJpRXY5RkN3UFVzSjZDL0FxaWx3cXJUcWtQN1JVZ2M2dUtRbXM3?=
 =?utf-8?B?YkdxM3Jkc1l2QXFOSGkzc00yaGRnZVZROFMrUmRmWmE1YWQ3MnlTVnQyY2xQ?=
 =?utf-8?B?bTZLVVNNV0wwMkJVTU1GTW1XakpFemRxRm5hQ3MyNEIrVnB3Q0VYemE3UEwv?=
 =?utf-8?B?dlNHbjJTQjNKQ1d5OUh4UkZwSWRlanZJZG5GNmlTMHdaWHlOT3dCdFdoNTMv?=
 =?utf-8?B?WUQzVTVCZ3pmekhZbGpBQTV3bzQvZ3h0d25TUlUwT0xNNFd6SlN6TlkxYjNk?=
 =?utf-8?B?Z3BHNHcrVU1WeW9WclE3bFR6aVJGOW5GWGU3UU9VS0tTdXlSMHRXS2JjY3Rn?=
 =?utf-8?B?czdkZGttbWpXNCtJWlg1TkFkL3RZWEtyU1BmenR0eGNlVEp1ajcwZkRvNEdk?=
 =?utf-8?B?Ujh4R0UxaWJ6dGp6ZlhIYXZPTU1PbEZIMGtjYXYyUDhRWGU2M2EyL09DUFRH?=
 =?utf-8?B?RW5XeFZ4UHYzYWFNeG5veUg1N2hhMFRpN0Vrd2hIdXhZOHZxeG9KemJCK3dB?=
 =?utf-8?B?SGgyRXlZcE4zUDZIZTlEeFdHckw0Vy9pZmVhNUlpKzB6bk9MYXowampSUEV4?=
 =?utf-8?B?Zmc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cec576a-6c50-418b-6040-08da6060ff0d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 21:38:13.9789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iNeD5BoSVpAauR4lFVJnj69DZIA7IHRIcrKSMjKDgTzKsX4LIR3AGwI3bRaxF7iFeBYBkMVLxVlAc7jzqRL46QX65jk+JVqr8fA3SHvedZ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4978
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-07_17:2022-06-28,2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070085
X-Proofpoint-GUID: TBkTLpuckjKo0wr4lW-TlIyyYd-fm8X0
X-Proofpoint-ORIG-GUID: TBkTLpuckjKo0wr4lW-TlIyyYd-fm8X0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/30/22 7:22 AM, Anastasia Kovaleva wrote:
> By default, hw_max_sectors stores its value in 512 blocks in iblock,
> despite the fact that the block size can be 4096 bytes. Change
> hw_max_sectors to store the number of sectors in hw_block_size blocks.
> 
> Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
> Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
> Reviewed-by: Dmitriy Bogdanov <d.bogdanov@yadro.com>
> ---
>  drivers/target/target_core_iblock.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index 378c80313a0f..532a30b31a7c 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -116,7 +116,8 @@ static int iblock_configure_device(struct se_device *dev)
>  	q = bdev_get_queue(bd);
>  
>  	dev->dev_attrib.hw_block_size = bdev_logical_block_size(bd);
> -	dev->dev_attrib.hw_max_sectors = queue_max_hw_sectors(q);
> +	dev->dev_attrib.hw_max_sectors = mult_frac(queue_max_hw_sectors(q),
> +		SECTOR_SIZE, dev->dev_attrib.hw_block_size);

Just another nit. I think it's more common in the target code to put the
sector_size and hw_block_size on different lines. It would be nicest to tab
them over to line with the opening "(" but I guess the hw_block_size line
would be over 80, so something like this is ok:

	dev->dev_attrib.hw_max_sectors = mult_frac(queue_max_hw_sectors(q),
					SECTOR_SIZE,
					dev->dev_attrib.hw_block_size);




>  	dev->dev_attrib.hw_queue_depth = q->nr_requests;
>  
>  	if (target_configure_unmap_from_queue(&dev->dev_attrib, bd))

