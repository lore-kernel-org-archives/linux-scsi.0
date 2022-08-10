Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CA1EC25B07
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Aug 2022 03:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiHJD24 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 23:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiHJD2z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 23:28:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D55D642F2;
        Tue,  9 Aug 2022 20:28:54 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0E8UG026805;
        Wed, 10 Aug 2022 03:28:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=5K33Fu8BL2VIR39f9UuCNJOS00Vcgz4zYgse+OpvPw8=;
 b=Bp86r8u8fAXAqufiffPPReHidAX06pEt5pVMwpgE9bb24CrzLvnTFlv56ENHadpOfQJV
 XDNXXTNUYfkHxyAh1KBpybzJ0XmcdQUw0d38q7hpyjAdYzJSrLKx5SoJXHhPTwyPufNY
 FaZvVSVPQdulPMqQYsFIerS0RsnQhgRH0yMLa4tIWGrLeR2kt31Oxgu8YoBaCZKzMe/g
 NkWQKYfal0/R59LttQ+CwA0Wgc0WA5NvSsNUSfjOY0V/f9Dp7A2BXAA8gZ4hJ/kvFUIr
 24pXz89/AFL91Yp2W3ZHacRCA94XEZnCRB7Knmx2IKWb1z7AGCG3QhSOM4QnDA9r55u4 pw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqbgqfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:28:34 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0Aswb024110;
        Wed, 10 Aug 2022 03:28:33 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqfrr4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:28:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zo/dJzqhwYzxWSkuTOUvHzXUfcxfBvunUKz/5oGSkx+Mv9f/4QXacE0XUFa/hOp1JByDnqMqtS/90MPsZS8VDLxE8k2q5cd5/XsYHd/hXJG+8QqwOSv632dVl1B4hxMknUX9Zq0lY+7duXARoPA3GZcESHaLhO7v47eLT1M0c0NpBGm1dU/4LgWDaHEG6r8tlwQN71kAyzzJ0wpEiuHA09RISTfYpV61rgOHOx35Df1i2OurxUom7xy5gjtm+b2dmgSkslm7rE8Br3ZXR+zhrkPTXgm/4thvnCCxOYUW4frOcpEtpvS83HRUyxTjHHEBuxJZcbyXDPM+nFWEdH7gKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5K33Fu8BL2VIR39f9UuCNJOS00Vcgz4zYgse+OpvPw8=;
 b=aqmygHnJoquJpCXkTUGRCKDqbCziFBjua12RuxaOnOqnTd9hyZMOVMWq3MQ/fGcKv6UrXxaNqw0XZaqUcqaCwKt8ZvSJ+xghnBTn+yq1SzPkUBcKq04pH63eIPo41DYcKO/ixYlDBrCfu/bf/Vyj3bP4zp8qYqm/4gMeyY6WJXndNS9KmVFh3BqgUUqmdhgAZlOUF7cMidvmim3YvJZhrzRObZb4TrxFvHI9oDKV8DBARAfVcpG7uOytuYhBj4/lu6Vx2qfE+7iv5uZINo1Wqzw9AYJJNWzjT183PQqs/9crWaypOXz5xlra8l7Su8TdMUQGGj+cmqeMbg1SLR8Z0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5K33Fu8BL2VIR39f9UuCNJOS00Vcgz4zYgse+OpvPw8=;
 b=RmG8G9ia16170lTZ7gaWuhh1Hfb7qYBJ8TtGmBuO9qb7d3MTulMS7BGxvqQ7G6vq+a7eNP7CWlgMiYFbSGmw4f1jqs9u/nzhcgr0qWyLc6z3mvs8tzMp4nemXaP/t6c/HNNyV/GAriRxzqAXNHNTqpGKCGFApQi+k6JftiShYGI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH2PR10MB4375.namprd10.prod.outlook.com (2603:10b6:610:7d::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Wed, 10 Aug 2022 03:28:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:28:30 +0000
Message-ID: <3d2e8c97-3097-4eb9-8852-3a41e42555df@oracle.com>
Date:   Tue, 9 Aug 2022 22:28:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH v2 04/20] scsi: Add support for block PR read
 keys/reservation.
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        hch@lst.de, linux-nvme@lists.infradead.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-5-michael.christie@oracle.com>
 <a3117849-420b-65fb-dafa-c2a464482f7b@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <a3117849-420b-65fb-dafa-c2a464482f7b@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR20CA0025.namprd20.prod.outlook.com
 (2603:10b6:610:58::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 631dc4d1-ed33-4b31-9b31-08da7a806596
X-MS-TrafficTypeDiagnostic: CH2PR10MB4375:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2eKbNQj8wEE+Bxe9Y8fdhCKLG5JP0zQ+gGIWyM9To+r6JvT8UjDBIcpoUxrgIhXx1NfGpTmLZWclyKmcPUb2YlGqnMSKqt7XvRGy88KyvVibW3Rw9JpK6VR9sZz7HCsaqypGLtwLZ2wgOQWgNQlgsUOZqX2jE6V/Jx8joLBG/iP/dGY+ZtcV2OCOrw9LLcjt8qqBiRLbLfu/2N7eW4XR/CKS/rOwyqvbfNPViBfxdDOQ07xEg/ZNis9VC6ickntu4WUEfQiOY/X8C5TVgpyjAHZxfV51BLDy1QCYn0obxSZTjFHMFPErLlBxTeQosJc31xLWvUCHsZfvaWv60D5yVENLtscJKtVjqB+9pQiHCUjuzSL8pU7UKXefXdf8wX6Q2J7jIiq6n23TrW/JZgr9sUtd+4goWk2SIMvhO4xjOFOKWVw506KEwK4z8mTWyjEwlfXheHnYtI5FIZw38Em+ZXXHpI+WeqG/K1LLVgT9x/I/cUUXTXImEMQR5Xl4eRLd1NGLN6ePH/XAYqpR/F1U7ZWJMBZE2Ju+tfQV6IQouYBGj8CgtI7skV3MYJj5H5LkSRpDsuBMKleIkqYYsP4qxyKjE+Kt4EPWbMYhRzveMWhSTbRLnyBLyP/pjc3oVhhNBQ8nLP00B5fSrmo650nHEr2hfRTm6Ws/cl81IPE1Sr+yfdbUpW/jb9PsPAeU+oAuPD06iTbAmy+NKPYsxugWonSQGnR5zbf5e24N6oDG7iVVW6RlQA7VdBQG32zUu1rxFOMPvcvEcZJZXDfDmKl/Jc0WwjSDE319XjX9UiNyGahvcB2EAvQRFS0cfT7vGaLt8/nHutrYXx8P3A6sItgZMR68HVrX9Ix9+o3mGzaIRLM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(376002)(346002)(396003)(366004)(5660300002)(2906002)(66946007)(36756003)(478600001)(316002)(6486002)(31686004)(8936002)(41300700001)(921005)(2616005)(38100700002)(6506007)(53546011)(26005)(86362001)(31696002)(6512007)(66476007)(8676002)(66556008)(186003)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KzlqY21UWlV6RVpLZzJLVldkY0ZXb201UWduK1czaUN2bVNBaGhWNUdmeEIv?=
 =?utf-8?B?Z0IrTHhZUEFVeUd2Qkl4TTdBZlk2MEZCdnBSRDZsMGZHS2tZVXdibUxUMWJ1?=
 =?utf-8?B?TmE0TWNNVXJCMXBIY0JwTkt4Mlk1NkR6UUdWTGVzWXBIWjVZQXBlQzhsa2dS?=
 =?utf-8?B?R0ZDNjZWZHk1end3TFBNMmpLTTZ5Q2E5Qk41UUhYU0hxVFh0K1dRNi9FeE0z?=
 =?utf-8?B?aTR0dU1zZ01YS0o5RlQ4SjJKUkV5bkZjZERIUkluTkh5NXNEcG9uTVFNRlA4?=
 =?utf-8?B?VTMzcVZVUm1jTzFGY1VUVEpQUmE5VXVMbWc3QzhGbHAzOG0zNWM3Q3A3L0RM?=
 =?utf-8?B?bkxwWFd1OTJnbkQxOUtCSHpIclVQb1pRZ01YOE5KTW9nOVJaVkxGcXVoYUl6?=
 =?utf-8?B?d1pDZk1mNjZ4Si9lNE5wOEFIdElRdDB2SFJhMGUrcStzWWJEVGs0VG03eFQ0?=
 =?utf-8?B?NnZkNjczeEQ0bC9UNnY0NmpVQmp2QlhwZEZoUERHdTIyRG9tSGI3b2VOamlo?=
 =?utf-8?B?eWx2TWh2L1RUK2VOUjQyaTcvUmt0Rm1YYTVrNEFnWDNrRTUrdDEza2l2cDk4?=
 =?utf-8?B?aFhQbnVGQXd0UjF2R2tFSlZkNktHTnVnMnZEYW9PVkE5dnc4NUpDV0ZpcFJp?=
 =?utf-8?B?bit4bWp0N3F4R1h0clMrbk5kTWI5NTVDSm1sMEVvcEtQT1NJNGJzSVZQbzJi?=
 =?utf-8?B?SFVTbVd5SGZHenM5WEd2Q0x2eXFNMDEwNVJvcnZ2QWFZR2pvOGlXcVBieklk?=
 =?utf-8?B?ZEdCR3BXaGZ6Rittc1JaU3l6VGN3ZGNWSWhsak5qNkZabmx6NHphOXZnSkdx?=
 =?utf-8?B?Mi9YQXNsUjZBSVpUbWxaMmJPZUNRMEgxZjI4SDFqcEVBcEZOYndPR0lLRFFt?=
 =?utf-8?B?QUo5SnhTR3Z0WkFmdjNJZzRLdjViWUI5c3ZNcnQ5a2Rpdkh1QXYxWGh0a1N5?=
 =?utf-8?B?QkQ2ek1RRmhOU0QxRVgvT3RScm9mMU5oSmNITFRraXE5NjBGRXhLMmczV1hm?=
 =?utf-8?B?Vm5mRW91eWEyMGlBN01KQWRjSXIwRGlYRzlWRHRtRldnS2dnRnZOVmFzM1R6?=
 =?utf-8?B?QTlHbnBnV21BMVhXaFpBeVUzOGs4SXVHTUd1dGg2RW96ZjQ5Mm9TZlRaRDlG?=
 =?utf-8?B?SGJ4THBlTUt2SGs2MkphZy9pc25Sdk0rZUxra25nS3R0VUhCWEJSMW5PaWZr?=
 =?utf-8?B?L1ZwdkFuR0hVY3l0M3h3MFZlb3VCa2ViRzZENGErMjlIZFp2eEFibXk4MVhB?=
 =?utf-8?B?UDhETDhRbzZSVDlYM3hSNVBiSTkwUlZlN0xWL1h3aHY3TGY5Vk1ocm1VQ2NZ?=
 =?utf-8?B?ak1EUHNSdU9DRDc4UlQwMnZSQkFBcFFhYW92SkdSQ29oeDFIbWZ3bUdVWU1K?=
 =?utf-8?B?eDliMkw0K0NPb3VTZU9SSmpjMGNMaTIrbUJDMStvSWN0UXRqaTR4OEhuL0VJ?=
 =?utf-8?B?T1NPcG1yM3BneHoralpzRndwcjhHKzN1YlFUVTRoMUNRVWs4UXBwU0RIQU5m?=
 =?utf-8?B?Nnc2SmtEZ05vaENDa1hpMGplenJsWXpXWTY1R0VHM1I2a0hUYis4SEJ4NktI?=
 =?utf-8?B?cVQrVTR2SU5rc3FQaFJ3SzFDKzdSZCtvYzUreXpOcTZDcHJCeWlVZHQxYkNZ?=
 =?utf-8?B?U3lCUkZKOG4xc3l2ZHdHTm9nbWR5Tk5ENHFhZHBpaGlDMExiMlZ3ZUNhZEU0?=
 =?utf-8?B?a0lOMGZPSkZ4dFJLWk5OTkhIaEZTcDBqK1UycEdRK1cyTExzbVVROU1NYlRQ?=
 =?utf-8?B?UkJWVEw4RmltcDdTS0tvc05hOURKTm4zVW9rTnF1My9IVWlXWkhIK2ZIVlo2?=
 =?utf-8?B?NGVpUzAvc1hHUHQvUER5MmNYOWdTTFN0QUI1YUtFTHQwSm5ES2R5eU03Y3pv?=
 =?utf-8?B?ZFRwZzZSTXZGamFrbFpubkxXMWxXRVNiQkFNdGs1RFp2cmVPY1AweEY1VEZS?=
 =?utf-8?B?Qnc3bG9jUTdxS2R0YW9zcGllYlhSS3dhNkNKdlRuM2dGOC9KVEVkazVldGVL?=
 =?utf-8?B?ZDlRNlVkc1RaR1FSeGNKNkN4UDlrWVFRRExsaW84S0lrOC9qdklKOFJWakpG?=
 =?utf-8?B?U3lERTFXbkNYM0F1dGtnV2I5RitxemRtcGZRMnlRT0QxSXQwUUt3NGhBQUl2?=
 =?utf-8?B?NDdwVzZuVUxRRlZ4ZlVjai8xTWx6ZGNlZm84bkNVR0tYc1FLd3loMGU3WllG?=
 =?utf-8?B?OVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 631dc4d1-ed33-4b31-9b31-08da7a806596
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 03:28:30.7305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GSDvQ25l+XTG3IZoVyvod3LPxM4Edldm3EtKAxvBF/RQbI8EsbOx4g1bg9mVZoBCj3zWKFKJe5Gox2ReH3hUASyBvSR39a/aFCvLLDS5HuM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4375
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100009
X-Proofpoint-GUID: S4zR36ToCsgEd9mHAYP7njPh7aFrqMnH
X-Proofpoint-ORIG-GUID: S4zR36ToCsgEd9mHAYP7njPh7aFrqMnH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/9/22 2:26 PM, Bart Van Assche wrote:
> On 8/8/22 17:04, Mike Christie wrote:
>> +static int sd_pr_in_command(struct block_device *bdev, u8 sa,
>> +                unsigned char *data, int data_len)
>> +{
>> +    struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
>> +    struct scsi_device *sdev = sdkp->device;
>> +    struct scsi_sense_hdr sshdr;
>> +    u8 cmd[10] = { 0, };
>> +    int result;
> 
> Isn't "{ }" instead of "{ 0, }" the preferred way to zero-initialize a data structure?

The original code used { 0, } and that seems common sd.c. { } was not used in sd.c.

I didn't see anything in coding-style.rst. It does not make any difference to me
other than it's better to be consistent unless we are supposed to be transitioning
to a new style.

> 
>> +
>> +    cmd[0] = PERSISTENT_RESERVE_IN;
>> +    cmd[1] = sa;
> 
> Can the above two assignments be moved into the initializer of cmd[]?
> 

Yes, but it was like the first comment. The original code didn't do
that and it seemed more common to not do it. Do we want to switch
or are we transitioning? It does not matter to me. Both are simple changes.

