Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B064C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 19:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5286B64EB4
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 19:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhBSTmR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Feb 2021 14:42:17 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58582 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbhBSTmO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Feb 2021 14:42:14 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JJcRHw195994;
        Fri, 19 Feb 2021 19:41:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=uiA+ZLPnQ2grc33RD6M0YIwhrdjUqPaCBk2bj2AvesI=;
 b=wGh+SIIgpWCdwwyBjRnzCfuw+8s0boa3TAAz1ITqDgHQ6b4Zbh6JT9gziaR9/vhl2Nqc
 +1AIt1vagB753KOglpH090kqe8x4yNgnPU1ONP0m9bmPXQZ7ITbN3hlT3px6z+mpC43U
 afZpUc5BKc1BSK9+PtdTKG406Kxh+p4h9Suj16SA3JPjujtRwgyIwR48Uqf10s+s+0oo
 mYzeBYTp/WGg71AnBuhgM+WIoXln5aq3oA8v6Co7fqM30TiRwlfWtCBQNga/0HDMb4F4
 RWhV2gQpc4tkWTKcy77SMeBWKCRbb1OjtYbXWtaDjFHOfwmyFziqSAC55lFNDbIpMvoB gQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36p49bjs3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 19:41:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JJZns7064470;
        Fri, 19 Feb 2021 19:41:24 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2059.outbound.protection.outlook.com [104.47.36.59])
        by userp3020.oracle.com with ESMTP id 36prhw1dt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 19:41:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BaXhS4L3yuZ0O+kfNyC6XibVzN+X1219gqL1RXNsy4gSmmsUQHznyJncIjLz2dB7Rt0msf+1tRaHlE0eirvOUSgDzTTI0w0obeDL4pns0lODAxoLo4P2xIKWVqaZKh3hvXo41ZYh8tJdtzVnsUDV8BlzsnJ7rxGIGPX40+EpgR0oWn8LGJoaLEAN9DqouqEEqk+zyTV1t7PkI8kfQ9/Ncjc97gJVpX+d4efVJW6uZcEDC67iKGemjSYmO1/1SJ9wlk0lkxKZCuGQPicKTKCS4c/br5QoXkUUPHHQqOM/8diGeOtgRwI1O6aUheD+iJlQFHl5umiSbAMVWOZxmevZtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uiA+ZLPnQ2grc33RD6M0YIwhrdjUqPaCBk2bj2AvesI=;
 b=XVEt7E8fSaT145/Od6G0cdLWp9Uc4DTsebXfuI1JQeRDFxq6Juo5NcmSWrs5bB0nRWciGQQOQbd63+JQN1EdyFc1cMODzqevL0GdsF1KO+mCH0/PiyMDuWbois3/gIY6Qu6NGvboNqts3OAE2lsuTPYBgpztG7rNkzDTrmqNZaneenLpMsujuX/CVrMxpP3BdC0ZoRol7Hb2qaGg1owXqSQM3lPy5pvd1TaVo61ZWE4E3RgDQIsJQDwtj7eIr6UgcalyOMTQ49C9CHssQm82jifdxGqO9hq41qEwvTgrhJbWKftpVZEn7l+Cl1oNRKkcolf0jH2/vwxT7vv+ndqCKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uiA+ZLPnQ2grc33RD6M0YIwhrdjUqPaCBk2bj2AvesI=;
 b=R6a9dmWQCMx3TjuOob9z9y+wdUNLbGdXP7EIqhE0kRXwNmLo51Re+wLdailjAt8S+SmvYrt0j6dpoYbETJfgdh1uByyF5CWhvLxexIGurWGcqM1LYuNEhscUIS1jWTrtEGknW9xamwnU2TtYFZQQG82KIi+/zHLkU4a6ai/IHds=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3701.namprd10.prod.outlook.com (2603:10b6:a03:125::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Fri, 19 Feb
 2021 19:41:22 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Fri, 19 Feb 2021
 19:41:21 +0000
Subject: Re: [PATCH 15/25] target: add gfp_t arg to target_cmd_init_cdb
To:     Bodo Stroesser <bostroesser@gmail.com>, mst@redhat.com,
        stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com, hch@lst.de,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20210217202811.5575-1-michael.christie@oracle.com>
 <20210217202811.5575-16-michael.christie@oracle.com>
 <c6781cb3-ded7-6ecb-a711-963512313c3e@gmail.com>
From:   michael.christie@oracle.com
Message-ID: <1d193535-d03f-3521-3587-80995e8ba608@oracle.com>
Date:   Fri, 19 Feb 2021 13:41:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <c6781cb3-ded7-6ecb-a711-963512313c3e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.31]
X-ClientProxiedBy: SJ0PR05CA0153.namprd05.prod.outlook.com
 (2603:10b6:a03:339::8) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.74.102.159] (138.3.200.31) by SJ0PR05CA0153.namprd05.prod.outlook.com (2603:10b6:a03:339::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.10 via Frontend Transport; Fri, 19 Feb 2021 19:41:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59319f69-b462-4825-ba77-08d8d50e55bb
X-MS-TrafficTypeDiagnostic: BYAPR10MB3701:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3701F492175132390D99CE01F1849@BYAPR10MB3701.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V2BsgrsZ/S8jdgLvUkhRHsmElceXxM9xhZMwy1EECqwOA7foVyNxQF2Ap+ViPGqDU8KcTv39zp8Qjcu+JS+3+SxITr4OVxW8Cpkse3RfNLnWKr/S1UnhSyeSnCS4yu+nFJGfs4vwVNe6LyxtVzvatRWY42DBvqOC9e15bG/6HDy1h8/FSNRVaaATpMRZxrM63fudHNqLkzkwX8e8R+Ym74lGIMx5l4USyoDuECZDdz7PL409voa0+UmX0NUCF1nThhscheiehkXbp8ofJ5mJCM1huNW02kTUektOPjn0RMe+Rh5ntpENJf3dSWhWZu39xmnNYy/Y7zHJHRYXC5luj9oEMjWxMpxnzWJkMb3R33gkCqAqH2fNGw1LV1nijAjhcTe5f7Q0vgAlw2hPd0HM6hhIM52MvvWqDa9xZXSrd7dR0MOhMqgPpHFehLPMSUlQK0kuexND2mKTrQg3QMrIJRN+EM46NJyDLTio2KIGya0XVSpAsHBN9j2ph47MwIl7L9Ej8+XLoX/ia31R+u2KvQlzhwT8mUu3TjkxiAPSj7GGaCBgArpkbxTjZTBgsWARpAxB+gqJ8wQhGykudb13Kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(346002)(39860400002)(396003)(9686003)(316002)(2616005)(26005)(8676002)(8936002)(186003)(6486002)(2906002)(83380400001)(16526019)(478600001)(5660300002)(956004)(36756003)(86362001)(31686004)(66476007)(31696002)(53546011)(66946007)(66556008)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cERDc2loQlVsUG91MGJQTDhwRTdncEt2Y0c5YzJndTBqU2xGbGkvQ2dIMnBV?=
 =?utf-8?B?Q2d0Mk5RN0hhYVhmWDhaWXk0NG5UdmdkNTFhY1ZxWDVXQnJxVEt5aVEvNVhR?=
 =?utf-8?B?NjhBbE9oakpyK0dTNVFBU1NlTVo5RHpnVjFWdGlDcnRDeHF6cUJZRDFKTHJh?=
 =?utf-8?B?NTVZNG1tRWZ2TEV6cDBYMGVHQ0VYV2M5Z3ZPbGpCYzI4eG5mM0pvVnYreVFX?=
 =?utf-8?B?SEcwc1FWdWhPMm9qVXhlalJCaHhjak1WZFdoZkV3dlBJeHV6VzZMbGFqNmVD?=
 =?utf-8?B?SC9ZRkQvZTAxdVVvbXZnL2RxYUR6TzlJdktISWpGUVd6WmNTMFdzbnErODVE?=
 =?utf-8?B?ejYvUmVDRWFaQmEzaU1iLzF3RzFaUlhlQkg5VC9adTNGZHFmU2dYSTVBaW1p?=
 =?utf-8?B?WVBDejhHV1pJdGFFSU5vcjBJL081UjcvRVFkcWZRdmdaQkFTbFdRTVVWY1pE?=
 =?utf-8?B?UzNuSjcrSkp0bTJwNkVNZW9OU3pOTGs5WUYwMmplcEhML3Yxd3ZaRjdyTGYr?=
 =?utf-8?B?aUIxdURIYU9hV0NFd2c3a2hUM2d0Ly9FWGUzTGlQamhTVmxWTW5rNTl6NnBx?=
 =?utf-8?B?RTdLNjZVbmNlWmVUUnAxYi9KRXJoSEVGQlBmTjNsRXJOdHp2YUV1MzcxK3dn?=
 =?utf-8?B?d2dzSDlhdE5xZFNldzNwQUs5MldXSkluM2hjZFRBMDh1NDI1Uit5dnFoaERn?=
 =?utf-8?B?Qzg3N05Md2F4bWlRVFIwZkltSDFUNk1iZC96eEVrdkRiNzM5b2NwcFBMTTd5?=
 =?utf-8?B?N1RMRml2am0wQjdjbjRudVkvbFV0b09pRjgzeDU0VldQY0UvSGp3bkhPeGZU?=
 =?utf-8?B?TEJEUk9OeXB2WjdYMEUrR2lGeTZZNjNMM3p1clNWUDI1azJtVldwMWowOHpE?=
 =?utf-8?B?T2pOS1VEN0NZVVVJQitRY2VNbHgyWG5jcy9SbXBWR3dLaG9PVG9GTmo3SUNa?=
 =?utf-8?B?Sk9HZE9UQlhHSU91cGloKzFndWtPd042eVF1WWxrTUgzelBha3ZBSEVTL2lr?=
 =?utf-8?B?UjY3aVB1b0ZiRGVoTC8rTEdqK0YrUG5xakN0cHpXazJMTUlxVVN0aXJ3NmNI?=
 =?utf-8?B?OWJkRkYrdXh4TTc5anlnU0sxd2kxN0VVb3MyKzhMTkUwY1Arckc5bURtekZR?=
 =?utf-8?B?Z0xiaXVZd1hhOGx1Yng3UWI0bTYxTERpNis2Wnp0RnZiY3J6VThRZjRoN2Za?=
 =?utf-8?B?U3g0NFpyNmZyOUlVbXR5TTcwRWE0V3FGT1FPc2dJYkdGUytMQlJZTU9nMGZ5?=
 =?utf-8?B?djAxRXJWczZQUXRpZ2J0ZzRGd0lEVFJESytTZEluRTFpWXlPbVdHOG84RWp0?=
 =?utf-8?B?QldJeWp2VC9BaXdONXhYTzF0Y3hqakdFR0cwTVowNTR5UnRiSHFWM3lBYThL?=
 =?utf-8?B?elJXVGV2Z1BUc004ODJqaUhTOFRWbitFeTk3WmszMVozUXJuclJ0eGZNblZ5?=
 =?utf-8?B?UEhBcnFVUE5INHRFMkEvMFZ6SVhQV2FIWWhPRDY3cUFOUDdJdkIwbnUvYlRV?=
 =?utf-8?B?RXdrbXBDT2JCaUljS3N0aGtOQm9hMnlVQnlmTDc2ek03VXR5YVRHWDIwbjVs?=
 =?utf-8?B?MHRObmtxRDZMcjRKeW4waVFTTlF5S1ZjdURIYyt1b1VwY21UK0s0N1ZieEk5?=
 =?utf-8?B?cWlxdWVzdmg0WkpITU5Ob29NYWROWHY5c0VQNDk1dlQ2K1V1Ujh3V2dqRzNw?=
 =?utf-8?B?dlZCRVRvdTA3a2hrZWVZa1hOaWg3YVRxZDU1SlB1b0ZlQllEeFBEd2dDeWtv?=
 =?utf-8?Q?ZrNqS34iqOCjQcxqfrglMdwojYAHQ/ttsuhysE9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59319f69-b462-4825-ba77-08d8d50e55bb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2021 19:41:21.9238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SNtVgL6AUELG/w9kn1L/PQRNwfth4db9KSxirv72jA2pnh6+zxlLqJNIOs0kM92iHaLgzHQuSNyKhDc2CYOxiBWF+0XiLdKDnpU9KVfunGs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3701
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102190155
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190155
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/19/21 1:32 PM, Bodo Stroesser wrote:
> On 17.02.21 21:28, Mike Christie wrote:
>> tcm_loop could be used like a normal block device, so we can't use
>> GFP_KERNEL. This adds a gfp_t arg to target_cmd_init_cdb and covnerts
>> the users. For every driver but loop I kept GFP_KERNEL. For loop and
>> xcopy I switched to GFP_NOIO.
> 
> 
> In the patch below for xcopy GFP_KERNEL is inserted.

The code is correct. I'll fix the commit message. I thought it needed
to be NOIO when I first made the patch. I later realized we would never
hit an issue since it's outside the main IO path that would get executed if
WRITEs were done to satisfy the GFP_KERNEL alloc in the xcopy code.


> 
>>
>> This will also be useful in the later patches where loop needs to
>> do target_submit_prep from interrupt context to get a ref to the
>> se_device, and so it will need to use GFP_ATOMIC.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Tested-by: Laurence Oberman <loberman@redhat.com>
>> ---
>>   drivers/infiniband/ulp/srpt/ib_srpt.c  |  3 ++-
>>   drivers/scsi/qla2xxx/tcm_qla2xxx.c     |  3 ++-
>>   drivers/target/iscsi/iscsi_target.c    |  3 ++-
>>   drivers/target/loopback/tcm_loop.c     |  3 ++-
>>   drivers/target/target_core_transport.c | 14 ++++++++------
>>   drivers/target/target_core_xcopy.c     |  2 +-
>>   drivers/target/tcm_fc/tfc_cmd.c        |  2 +-
>>   drivers/vhost/scsi.c                   |  2 +-
>>   drivers/xen/xen-scsiback.c             |  2 +-
>>   include/target/target_core_fabric.h    |  5 +++--
>>   10 files changed, 23 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
>> index 87741e0b4bca..51c386a215f5 100644
>> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
>> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
>> @@ -1537,7 +1537,8 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
>>           goto busy;
>>       }
>>   -    if (target_submit_prep(cmd, srp_cmd->cdb, sg, sg_cnt, NULL, 0, NULL, 0))
>> +    if (target_submit_prep(cmd, srp_cmd->cdb, sg, sg_cnt, NULL, 0, NULL, 0,
>> +                   GFP_KERNEL))
>>           return;
>>         target_submit(cmd);
>> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>> index 56394d901791..12a2265eb2de 100644
>> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>> @@ -492,7 +492,8 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
>>       if (rc)
>>           return rc;
>>   -    if (target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0))
>> +    if (target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0,
>> +                   GFP_KERNEL))
>>           return 0;
>>         target_submit(se_cmd);
>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>> index f2107705f2ea..566adfde1661 100644
>> --- a/drivers/target/iscsi/iscsi_target.c
>> +++ b/drivers/target/iscsi/iscsi_target.c
>> @@ -1166,7 +1166,8 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
>>         target_get_sess_cmd(&cmd->se_cmd, true);
>>   -    cmd->sense_reason = target_cmd_init_cdb(&cmd->se_cmd, hdr->cdb);
>> +    cmd->sense_reason = target_cmd_init_cdb(&cmd->se_cmd, hdr->cdb,
>> +                        GFP_KERNEL);
>>       if (cmd->sense_reason) {
>>           if (cmd->sense_reason == TCM_OUT_OF_RESOURCES) {
>>               return iscsit_add_reject_cmd(cmd,
>> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
>> index 461f4125fcab..677e4b8f0642 100644
>> --- a/drivers/target/loopback/tcm_loop.c
>> +++ b/drivers/target/loopback/tcm_loop.c
>> @@ -156,7 +156,8 @@ static void tcm_loop_submission_work(struct work_struct *work)
>>         if (target_submit_prep(se_cmd, sc->cmnd, scsi_sglist(sc),
>>                      scsi_sg_count(sc), sgl_bidi, sgl_bidi_count,
>> -                   scsi_prot_sglist(sc), scsi_prot_sg_count(sc)))
>> +                   scsi_prot_sglist(sc), scsi_prot_sg_count(sc),
>> +                   GFP_NOIO))
>>           return;
>>         target_submit(se_cmd);
>> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
>> index 1f35cce6e92b..6c88ca832da6 100644
>> --- a/drivers/target/target_core_transport.c
>> +++ b/drivers/target/target_core_transport.c
>> @@ -1427,7 +1427,7 @@ transport_check_alloc_task_attr(struct se_cmd *cmd)
>>   }
>>     sense_reason_t
>> -target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb)
>> +target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb, gfp_t gfp)
>>   {
>>       sense_reason_t ret;
>>   @@ -1448,8 +1448,7 @@ target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb)
>>        * setup the pointer from __t_task_cdb to t_task_cdb.
>>        */
>>       if (scsi_command_size(cdb) > sizeof(cmd->__t_task_cdb)) {
>> -        cmd->t_task_cdb = kzalloc(scsi_command_size(cdb),
>> -                        GFP_KERNEL);
>> +        cmd->t_task_cdb = kzalloc(scsi_command_size(cdb), gfp);
>>           if (!cmd->t_task_cdb) {
>>               pr_err("Unable to allocate cmd->t_task_cdb"
>>                   " %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
>> @@ -1638,6 +1637,7 @@ EXPORT_SYMBOL_GPL(target_init_cmd);
>>    * @sgl_bidi_count: scatterlist count for bidirectional READ mapping
>>    * @sgl_prot: struct scatterlist memory protection information
>>    * @sgl_prot_count: scatterlist count for protection information
>> + * @gfp_t: gfp allocation type
>>    *
>>    * Returns:
>>    *    - less than zero to signal failure.
>> @@ -1648,11 +1648,12 @@ EXPORT_SYMBOL_GPL(target_init_cmd);
>>   int target_submit_prep(struct se_cmd *se_cmd, unsigned char *cdb,
>>                  struct scatterlist *sgl, u32 sgl_count,
>>                  struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
>> -               struct scatterlist *sgl_prot, u32 sgl_prot_count)
>> +               struct scatterlist *sgl_prot, u32 sgl_prot_count,
>> +               gfp_t gfp)
>>   {
>>       sense_reason_t rc;
>>   -    rc = target_cmd_init_cdb(se_cmd, cdb);
>> +    rc = target_cmd_init_cdb(se_cmd, cdb, gfp);
>>       if (rc)
>>           goto send_cc_direct;
>>   @@ -1788,7 +1789,8 @@ void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
>>       if (rc)
>>           return;
>>   -    if (target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0))
>> +    if (target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0,
>> +                   GFP_KERNEL))
>>           return;
>>         target_submit(se_cmd);
>> diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
>> index e86cc6135587..d31ed071cb08 100644
>> --- a/drivers/target/target_core_xcopy.c
>> +++ b/drivers/target/target_core_xcopy.c
>> @@ -554,7 +554,7 @@ static int target_xcopy_setup_pt_cmd(
>>       }
>>       cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
>>   -    if (target_cmd_init_cdb(cmd, cdb))
>> +    if (target_cmd_init_cdb(cmd, cdb, GFP_KERNEL))
>>           return -EINVAL;
>>         cmd->tag = 0;
>> diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
>> index 1376501ee3d0..410b723f9d79 100644
>> --- a/drivers/target/tcm_fc/tfc_cmd.c
>> +++ b/drivers/target/tcm_fc/tfc_cmd.c
>> @@ -555,7 +555,7 @@ static void ft_send_work(struct work_struct *work)
>>           goto err;
>>         if (target_submit_prep(&cmd->se_cmd, fcp->fc_cdb, NULL, 0, NULL, 0,
>> -                   NULL, 0))
>> +                   NULL, 0, GFP_KERNEL))
>>           return;
>>         target_submit(&cmd->se_cmd);
>> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
>> index 76508d408bb3..93f5631b469c 100644
>> --- a/drivers/vhost/scsi.c
>> +++ b/drivers/vhost/scsi.c
>> @@ -811,7 +811,7 @@ static void vhost_scsi_submission_work(struct work_struct *work)
>>         if (target_submit_prep(se_cmd, cmd->tvc_cdb, sg_ptr,
>>                      cmd->tvc_sgl_count, NULL, 0, sg_prot_ptr,
>> -                   cmd->tvc_prot_sgl_count))
>> +                   cmd->tvc_prot_sgl_count, GFP_KERNEL))
>>           return;
>>         target_submit(se_cmd);
>> diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
>> index 7bf9a6bede6d..eb3d8e35cbcd 100644
>> --- a/drivers/xen/xen-scsiback.c
>> +++ b/drivers/xen/xen-scsiback.c
>> @@ -368,7 +368,7 @@ static void scsiback_cmd_exec(struct vscsibk_pend *pending_req)
>>               pending_req->sc_data_direction, TARGET_SCF_ACK_KREF);
>>         if (target_submit_prep(se_cmd, pending_req->cmnd, pending_req->sgl,
>> -                   pending_req->n_sg, NULL, 0, NULL, 0))
>> +                   pending_req->n_sg, NULL, 0, NULL, 0, GFP_KERNEL))
>>           return;
>>         target_submit(se_cmd);
>> diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
>> index 86b0d4a7df92..0543ab107723 100644
>> --- a/include/target/target_core_fabric.h
>> +++ b/include/target/target_core_fabric.h
>> @@ -157,10 +157,11 @@ int    target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
>>   int    target_submit_prep(struct se_cmd *se_cmd, unsigned char *cdb,
>>           struct scatterlist *sgl, u32 sgl_count,
>>           struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
>> -        struct scatterlist *sgl_prot, u32 sgl_prot_count);
>> +        struct scatterlist *sgl_prot, u32 sgl_prot_count, gfp_t gfp);
>>   void    target_submit(struct se_cmd *se_cmd);
>>   sense_reason_t transport_lookup_cmd_lun(struct se_cmd *);
>> -sense_reason_t target_cmd_init_cdb(struct se_cmd *, unsigned char *);
>> +sense_reason_t target_cmd_init_cdb(struct se_cmd *se_cmd, unsigned char *cdb,
>> +                   gfp_t gfp);
>>   sense_reason_t target_cmd_parse_cdb(struct se_cmd *);
>>   void    target_submit_cmd(struct se_cmd *, struct se_session *, unsigned char *,
>>           unsigned char *, u64, u32, int, int, int);
>>

