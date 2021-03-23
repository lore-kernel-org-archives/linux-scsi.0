Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE58C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 16:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6B2C6199F
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 16:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbhCWQ3f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 12:29:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50604 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbhCWQ3D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Mar 2021 12:29:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NGOKux165187;
        Tue, 23 Mar 2021 16:28:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=1ScIhvLv6Nes4C4m0+RtwcGa3nJPqdKwu0NBXEnpmZw=;
 b=l/u8XudfeM39hQbOXyPViMwviv5lB6VzlmNEZnNEG2JxnzOJnqfwI2xYbXMtkaTcK2Bs
 qcuv8vhIFsiGCyoVPK+rW5s4gEq+QBA7teBzSwVRqTwnVI10PRGrpZP86EUJIR1uO/o9
 XI27/RecCcUk2dTr6wuZwZiwmcW/ua7WM3a+nv/Q0tT/KorlLkdCosbp5L54LWq1HqHW
 H7Qbgr+l3UTnyLOWPuhUSl34UExJL8+S9vq9NrfiAokwjLdOCyiQ+Z36H9URoAeScagM
 KzwPjVKWunhpB9mHNT+QMsRjioY7b7PuPHPCcOvqkKxracYMUBxzM8OIdr5TLEy2YHss 6w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37d9pmyps4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 16:28:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NGKPA4136233;
        Tue, 23 Mar 2021 16:28:40 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3020.oracle.com with ESMTP id 37dtxyfe58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 16:28:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5JMq3e7Vvsqg1dAOEye5dxvRjYXdOu9O4a02qleYtFjH/uORXS3itCxZG4YCctEDri7J0gwHz02QDU5drdAidFjiq+GkI//Np0BELhQ8PGuxeSF3D73CQT1RjX8K0q8TOgA9WlIA0IoX9mHNxGRu/Pb/SwFIkSQBqJvPjiLUdlcJC76BmtLUV1DEbVCQgvyd6ehC6QWQZInQN6a+na9nMiPLBPajUi8nlHRZn18gcNtxh872V7U3uS9i2N1fNQap/gxASort4r/lPiZnDtvqGgfo0HxT6q7bwQ/QOLWFM70l7eyw1s/yUdSY/W4EF5BGmw42voNPwBc4i0NpaPufg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ScIhvLv6Nes4C4m0+RtwcGa3nJPqdKwu0NBXEnpmZw=;
 b=SS6yeTUtEix8c7r6DNM3Tdusdxk4MaC/4XMBzZRyJ/aE8LF2ugcgaCLL/s/3nPuwX9ZeVKX1oYsl3+zujeIbN63mhY06ht2+VgDATOV2nfQdsvShPjtZQHwlhw+F9mWY4E+35BRftYcIbE0tHgvhxmN2WmPlUY3o5kmJmYTlXUMhVQhAorpDFx/7IEKyJEewym3vrEKTEG9lYi+wNOKVY/hSm8Xkc+3HPnk3l+TYVRvQeYoMRbK7QyvqI122XQXS4NYcCFg+9tW/YHw2lAqRQcjMN7ifgtkPt+yglhvY7KgT87Ld+8je7mxMAGRWPiQozBeYVdeHr81sXNkpppryAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ScIhvLv6Nes4C4m0+RtwcGa3nJPqdKwu0NBXEnpmZw=;
 b=lkeM9eAy9FPy8kTMQA3eET2z5yO/NOyJvvQOFalDUqH4P7VXJoK9yALThaQ0/W5MBaryyd5UbZm78oLHhGQ/LHo28blxVtfClJV7DP7fLrUmgAmozmLJhp0goqEu47kfurfM+3MtUmwfRaWfoqdRTBgZdF0nfPlGZ47IELRuf88=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4226.namprd10.prod.outlook.com (2603:10b6:a03:210::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 16:28:38 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3955.025; Tue, 23 Mar 2021
 16:28:38 +0000
Subject: Re: [PATCH] target: Fix a double put in transport_free_session
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210323025851.11782-1-lyl2019@mail.ustc.edu.cn>
From:   michael.christie@oracle.com
Message-ID: <9d02b016-c924-79e3-9593-c073da0c769d@oracle.com>
Date:   Tue, 23 Mar 2021 11:28:35 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
In-Reply-To: <20210323025851.11782-1-lyl2019@mail.ustc.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR18CA0064.namprd18.prod.outlook.com
 (2603:10b6:3:22::26) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.5] (73.88.28.6) by DM5PR18CA0064.namprd18.prod.outlook.com (2603:10b6:3:22::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 16:28:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5ce6aa2-e7fa-4d83-fc05-08d8ee18b626
X-MS-TrafficTypeDiagnostic: BY5PR10MB4226:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4226C84C6068D80B60D56317F1649@BY5PR10MB4226.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VoBW5mp93IghqmQ2Lbac2Xf9lZ37kWhRmHlfyCpIK7NOloKcJy0MyjJkhCQ7qaTD7la/0ZZR5dU44YuM8OdshyIvA6UgBWigkDCjih8nz4OJI5Yi56JCNj8A854ZtgLA18pEekT4ahyHaY3tt20egLjDi7uqOJNSbIIGTboLzNuumu9Un0yBMip3L+WuiIqxmm6XZ2jj8/rGtCvHm1VWURU5x1zdgLrWlcuVxA0uKW5DwPy6/A/UwCj3h30YSjZS40RyQ33m6NcWiiMq0gxdewl/I3c2mJFVZehQhulwFHf+LqgDqyRm5+eklLZQxUxmwoIZSs1hKN/ZQ5koDuvp0T4EIPeSCub6gmSys7IcvRTV5Yu25GrhD2U2ybwvkpUqWdN+xYlojOObyzupERjmqRER4X/fCIpd9vewMuBXvP0CYOllcKJeogrJXr/LALjMIvvPLR1QdqlyzviU8zbMlHxTe8oOf61cLEuTW3nsxxtOobZMpccv6vd1cYR+ibiPpb7e5yJOGnM1XgijNDapEog1k2/AptFmJYEJcBD024MmY/tLitHQyC7eaUuKZMXxwNBoJzz3EFinBBY0Nv0mbtBUG5YUKbw+sVDs05C1YyzdTpraPrBZykraq77IYvfDhn17W0j5FNLCYCvCeR0NzuB2HlEmm9JtG2OjdPEVwxA+dQfjYyD+7i4sbn45Use/pSWWwzcJqacHMrkqtw0fHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(346002)(136003)(396003)(9686003)(26005)(2906002)(478600001)(66946007)(16576012)(316002)(5660300002)(86362001)(8676002)(66476007)(4326008)(31686004)(66556008)(6486002)(186003)(16526019)(8936002)(53546011)(38100700001)(2616005)(83380400001)(31696002)(6706004)(36756003)(956004)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NHhlbExQdDBJOXJkNHFZNXliNVJrYmlUWFhYSlhScFZrOTYwU2ZLZXA5VWVv?=
 =?utf-8?B?aFUxZGdma3VtcW95OU5oTm5ROXpMUm1DRHBOQXlCRXpuVncxcmhGU2JwbHg3?=
 =?utf-8?B?THJwTTR6cTVWUlY5b3QxMkxHZmJxeVBXUDdqRUhTQXhUZVJUdzIvVFNENWJz?=
 =?utf-8?B?MythUHlQRnZkakk1c1A0a21YWU9aN050MS9VTGlaNUcySDhwbDJhVUZMRWRK?=
 =?utf-8?B?aENPQlZxUVo5MXRDSkJ4eXdGb2JEa0NKQWhEc0FwdCtUUmdBRkpzang1THdB?=
 =?utf-8?B?eVowL1d4L3lES0NDZHJlLys2K25mTGgrT3RIL1lxcWJ0MTZneDluN0ozNDZ6?=
 =?utf-8?B?bkpLYUlzYVJIYk5CMWw1WjhJTFNSazNObVNRQWtkWWk0cW1UcWJFY3QraTMv?=
 =?utf-8?B?cE9VQmxZUU1pT2ZoRVhMSUZKU2p1cmdCV1pQVDVjRU8wN1VFOENwMG1Xckx1?=
 =?utf-8?B?V0hobkp6M1FDV21wMS9wcU1qWXYrczZFSUc3WVZMTWNtRjRuODg0OWh3ZDh1?=
 =?utf-8?B?d3NGTGhhZ1F4dFR6L2c5WGlzcnZPOGpibDQ2Rm5kQlRnUW1odFlQb3Z2K1Bs?=
 =?utf-8?B?eTQrWnFXQ2dRN01lVmZMajlXRnZvdHE4RFFJcEFHVE1XL1IrK2k1ZEU5NjEz?=
 =?utf-8?B?QklWbTE3VVN4R2wvRnF5TWtTS0ZyNitIcThFSFA3RDRoOHlxdktCTFZlZ1pr?=
 =?utf-8?B?WkZoL3pUR0l5MEVLSWVjMDVDQjlxanNWM2NZYU9yRkJMNjhrYlBiRDVjRFUw?=
 =?utf-8?B?NS93R0tGNVFEbVVCeWZzZFc1T2pScTRwNEVNRDFNT29oczBrL1ljYmRDMWJy?=
 =?utf-8?B?ay9LVWN3YzZNWUJBUHBXaXlncW9oSGF2VHoxUWFXc0ExK2QwdHFxYzZ0RTlR?=
 =?utf-8?B?bHlzRTUwODlpcFd6NDNhZ01JMXRwektOQUZkYnhqc0xTL0RvbForNEFCMU5l?=
 =?utf-8?B?end1SDRRQnNvQklBckVhM2ZKT0hTQlZoZHVGOUZjb3Q3UGJ0aE5ldlQvWUIy?=
 =?utf-8?B?WnUwRURBMGFiMEhlT253TEU0bVVZNW1SbE5vWE1FUTlkYWdzcDVCdVRIU0ZJ?=
 =?utf-8?B?WERidVJEMlkzMWNNZGdVUHg4OCtBK1Y1S0RiY01HM0QydjZlZlhCdm5HMUJa?=
 =?utf-8?B?U3QyOU54QW1ucXlIWmtTSGZpdWtoOHZ0bkZTQXQ2RGY5dS9SK1hGSkIrVGtL?=
 =?utf-8?B?bk0wbkV5SXphYmcvYVc3MzRPTE9tbHdQYjhmajdiTE9YSnkwTVp1KzA0TCtl?=
 =?utf-8?B?K1NGTkpKbUR3dmM2WVVETXZnY3U1QTVaVFFHaVM1KzkydHVWUEVJWFgvNHZ3?=
 =?utf-8?B?U3dSTFU1b0pCcEZxc1JzMWFQTnROZ0crRk0vSjA1KzJpN3IyZzU0aVhyZnQ5?=
 =?utf-8?B?LytzZW1ScGVySU5sNWJZQ0NNNUoyN1AwL0ZwN1kwQXVJMWlLOFQ0WTB3ZGt6?=
 =?utf-8?B?NWd5ejJFQVVPNlpEMmR4MUcwOTdPZmp0RGtJeGRoMnIwWTdlYVRPWjgzK29V?=
 =?utf-8?B?SGQvNDlZZG4zckl2YkVzVEV5K01sYk5LL2VPODdyTm9zbDRDd0wxMFpOZVl4?=
 =?utf-8?B?VWY1ZDhVVXc0cWF3SW5sUXdPUVYxYkR2RjNQcjNDYzRXdTNJSnZwb01SRzkx?=
 =?utf-8?B?VGowdTJjWjY2ZUZLa1BYUDNTL0krRHhvaFNNVC9oYXhrMnRFTk4yUEZNUElK?=
 =?utf-8?B?STlldmcvemhtdjVaVElaQzMxUXdtZ29oNm54UkREaHVEUGVnUjVuL29Rdzhj?=
 =?utf-8?Q?OFMSXPsOwjhci1/jEEuHauTOxrts/YDVNQtVtmL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5ce6aa2-e7fa-4d83-fc05-08d8ee18b626
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 16:28:37.9686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N1QGXEBv1i1byYehc+hKAjwO01Zg2UAKyYrDbJBHNqFXn1u2w1sVhpOy+ORXC+Ml7x+AL+M+06GNcm4G1CiEvgt1ZTB5pSk2NBZ+E4MV5ms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4226
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103230119
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1011 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230119
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/22/21 9:58 PM, Lv Yunlong wrote:
> In transport_free_session, se_nacl is got from se_sess
> with the initial reference. If se_nacl->acl_sess_list is
> empty, se_nacl->dynamic_stop is set to true. Then the first
> target_put_nacl(se_nacl) will drop the initial reference
> and free se_nacl. Later there is a second target_put_nacl()
> to put se_nacl. It may cause error in race.
>> My patch sets se_nacl->dynamic_stop to false to avoid the
> double put.
> 
> Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
> ---
>  drivers/target/target_core_transport.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 5ecb9f18a53d..c266defe694f 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -584,8 +584,10 @@ void transport_free_session(struct se_session *se_sess)
>  		}
>  		mutex_unlock(&se_tpg->acl_node_mutex);
>  
> -		if (se_nacl->dynamic_stop)
> +		if (se_nacl->dynamic_stop) {
>  			target_put_nacl(se_nacl);
> +			se_nacl->dynamic_stop = false;
> +		}
>  
>  		target_put_nacl(se_nacl);
Could you describe the race a little more?

Is the race:

1. thread1 called core_tpg_check_initiator_node_acl and found the acl.
sess->se_node_acl is set to the found acl.
2. thread2 is running transport_free_session. It now grabs the acl_node_mutex
and sees se_nacl->acl_sess_list is empty.
3. thread2 does the dynamic_stop=true operations in transport_free_session.
4. thread1 now calls transport_register_session now adds the sess to acl's
acl_sess_list.

Later when the session that thread 1 created is deleted dynamic_stop is still
set, so we do an extra target_put_nacl?

I'm not sure your patch will handle this race. When we delete the session thread1
created dynamic_node_acl is still set, so this:

                mutex_lock(&se_tpg->acl_node_mutex);
                if (se_nacl->dynamic_node_acl &&
                    !se_tfo->tpg_check_demo_mode_cache(se_tpg)) {
                        spin_lock_irqsave(&se_nacl->nacl_sess_lock, flags);
                        if (list_empty(&se_nacl->acl_sess_list))
                                se_nacl->dynamic_stop = true;

can set dynamic_stop to true again and we can end up doing the extra put still.

On top of the extra put we also do

list_del(&se_nacl->acl_list);

twice so we have to handle that as well.

Is there also another bug in this code. If someone adds an acl while there is a
dynamic acl in place core_tpg_add_initiator_node_acl will clear dynamic_node_acl
but we leave the extra reference, so later when transport_free_session is called
we will not do the extra put.

