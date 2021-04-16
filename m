Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A70AC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 21:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35E18610E7
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 21:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244605AbhDPVmB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 17:42:01 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59772 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235540AbhDPVmA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Apr 2021 17:42:00 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13GLTdoT074376;
        Fri, 16 Apr 2021 21:41:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8D13DZTtSVNff6+5/vMEk8fOBUrYYlCsjgncaYFvb1U=;
 b=rAbUCdufVkK55gkJKJdRkduKtiSM0Qvpmg84rOE8Zf6AuOGZCNhDRSaHo8fvPdkW4KEH
 9tgzZaJIYMmqW958KSEuB59FmNlaO4HS7b+ZuB1zI/yUWu3a9mobG2OsEOkTPmtd5dty
 YiUJIMqrfhIUXyNFXRSccggBpJC5VFqDWQAT1aXd1/N0ihyvUhuUvLa8Le1izh/yXzNu
 b/BA9yAwGEuG3Z7kkL7fAMJvery64/mwcoH9g5L/7KjenVGajVpT7fAkRPybshywi0DA
 m8py/J+iH+/KCYxom2/u625IGaNV+pDnFgd1N/qUqw514etHpp7GfhgBJ631Ic2YZPUx bw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37u1hbthew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 21:41:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13GLVgmV111233;
        Fri, 16 Apr 2021 21:41:34 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2056.outbound.protection.outlook.com [104.47.37.56])
        by userp3020.oracle.com with ESMTP id 37unsxsqsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 21:41:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drdHUsvCe8slLInWSkAExcwx4KOsoGf+u4AgmCJYzIZLOBMgV7SD7EsFXSExXNa1Ou6akXgwr0byG2zRFbGb7rYNDslgX4leyOZTtTzagg8I1Hi5cxyUCTdYee/f8989rhjEHA1RV5m5Y9e41Ut1BkZ+gwgqSpfbXPWjQfA80MFbGejdgi75ybFfbx7yhEioDFZCx+6kUZrym+O09Vq0mOPeQ9026SsYk8wkUVfjWEHUmqBQqQJoK/NyWrFZv940zCyhVwpCv8q4Uhufm/35Sb88shCGuEwsK6ddZvYkHhwDDASwIKkNMK1GmSazG8mBxIkgZWGGrmrec2+8TjqavA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8D13DZTtSVNff6+5/vMEk8fOBUrYYlCsjgncaYFvb1U=;
 b=VcSLrUz6nklHp2fS5AxtZcArAAygX2rJ+0pqUiJYvOraDKZ0i7Ei9qTxnZpTAMnJf9gftD1RI5DTKHJQ1v8GiOwZjYlKwOMnnPgfVBtPMFOkQiTjICESR4R58abdzPH+zjcATgQegxJkhxQGilJ6ySN/9No7PwtCEgJZY7YL4g09iTqE3/q339AcOMh1SmfL885kOti2KmKlh4iYNJU4Oudft9e3n7RghP+S9LLYGlYLNFpf3tdAuV+oMPlU2vfi7Qwsp7efP1rJJxJUw+gfleJ5iETV9rWPoVJgw7z+uUy+ves8T9arEis0cFk6faY1qL2DfALz0yBWWunRbHaJEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8D13DZTtSVNff6+5/vMEk8fOBUrYYlCsjgncaYFvb1U=;
 b=WkUnJX43AXNa3OjXd4hbU8rOE4qt298VT7J/pPzEKzoSqZ3J9DlGTwCtc9DWV4mjHyg6MZuMzujK4tDAF/NzTpTaW7ng+xXFbD+josznaKGLS5DE5nNHa4LjSS09aToDOH7dnjIEWWAXAdjyVfe+SX8PT0tMvuvVwZgUv/kNukM=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4799.namprd10.prod.outlook.com (2603:10b6:a03:2ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Fri, 16 Apr
 2021 21:41:32 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 21:41:32 +0000
Subject: Re: [PATCH v2] target: core: remove from tmr_list at lun unlink
From:   Mike Christie <michael.christie@oracle.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20210416092146.3201-1-d.bogdanov@yadro.com>
 <90139902-5a5d-3e87-0b06-72f8acfcb673@oracle.com>
Message-ID: <6121543b-969b-7d07-00f4-5350902241fd@oracle.com>
Date:   Fri, 16 Apr 2021 16:41:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <90139902-5a5d-3e87-0b06-72f8acfcb673@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0041.namprd03.prod.outlook.com
 (2603:10b6:5:100::18) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM6PR03CA0041.namprd03.prod.outlook.com (2603:10b6:5:100::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 21:41:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58daf717-13ef-4ae1-6615-08d901206666
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4799:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4799E7576FDEEDD9BA4605BAF14C9@SJ0PR10MB4799.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E53ZY1X/EyKkeRw3YxpOGmbwWgSzWC9VXgYi1R+9J/2OvvX5Oc3IFE+S7vxYt9N2mLqiHt6AvEee8FWlxkoVsyiUt3MkUCtrL9LjjPsqtqoRmK4s+EmX3V9ZzTYNwFY2HvqCCvH6WFLdTrq0SUiA8cMPl9zunzDfqScy1wxyswYg3O3KuBw+hqEv6+36Y3m/3PVL1ZsYLGZI/1oFNx6ap474MrLL9BmES8Yd5h+c46i3XHCHvApuM0YqICZq355J1SewGrreVVq9hXwcpFOrA5BiigtuGkfyCsOSo9qKkq98Ap2MH49pkWZ6kpQU/rXwbvyjqlK+/rySh4Yq0qSkNYaZt/k8pg59eMY/x5owKETDn8dg+wtGPTZlZHyEgjRammuawdjM+mJpwM+VTBQzkia/Abp3AwggU8YelITdk966fm54rEIwcBLLaoGmIperuttmzUWYf03ObIZwOBeGOI6aDRWJqUS9TefMN16Wpkv6iYpDaMIWrtn9dNBYDmpkr2CxINCw/+iMNeqyNUcqGgeFMw1cT8/SuqRJ14Y2Fp5Hfhf6UBMmPhcioWXKAFqXIu92bWG6VAeO4mKZX8y0JhGi74yBjQMTt33/AXJ8EQjvHvnG5ua6ICtjIwjka+yDgfFaMZw0JruevOUHbVjfYX+avilSdZp+zLTSXQgXi7lZ+xrtjwP65koC/q7G0tbzCj3u2pRieX1Jcy415/u1SQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(346002)(136003)(396003)(83380400001)(8676002)(86362001)(31686004)(5660300002)(2906002)(478600001)(110136005)(38100700002)(16576012)(31696002)(8936002)(6706004)(956004)(53546011)(66476007)(66946007)(16526019)(2616005)(36756003)(6486002)(26005)(316002)(66556008)(186003)(4326008)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VjdyQnpuMHNVRVJwN1VpNy9US0JjcFVpWm13VkIxL3BaaTNLN0VyRFEzcEVw?=
 =?utf-8?B?Mno4M3dFeTA0RDVjdjQ2Z3lEcnhrMkJ0UTN5ZjlMWHUzSzJXeHlWK0hhWENr?=
 =?utf-8?B?aGtCRE8xNWd0dVRHbjJUd2U2UzlTbTRhaDN6bFVtVitYMVRJT2NNcm9tcCsy?=
 =?utf-8?B?R2ZpNUhHc0Z2Tlo4S0xNSnFrbG9XbnNxRklvdlBSazZ4SzBpbVVLVmJpcVJN?=
 =?utf-8?B?Qk9CVTl4OS9ESjJJd3Rsa1BGMldnbTI3Q1VnOVVYckRtckozQlRGclFOWFZS?=
 =?utf-8?B?RGJkUVFyaVhoZTdKb29xQ0hhTjJTMG1sbGpnQWVxNG9FQmttaThOODUxbkx0?=
 =?utf-8?B?T2taUEZVZTFEUEFUelpxRnRRandYWjMzeEJYOEdnSzVhc0tvOGJDOVJ4aEtv?=
 =?utf-8?B?MDBHalRwY1dRQzNBY25BOWVuaFZPdU5hNkIvRkt5azVGTW1IUVd4b2dUUkZB?=
 =?utf-8?B?ZXk2T3ZoUlpQTmY1ZEliWjl5dWtmYWdtTnJRNU9pTVdOckdZMjZ5MUlnREpX?=
 =?utf-8?B?QTIrMDdCUkVGUElOdkRQWjIvU3pYZmpQZUdyK2xTY2JGajF3VCtEbUxQVEhD?=
 =?utf-8?B?Y0p4ZEdiUk92VVU0WkJYd2xScEIvN2gxOW82OVhSd0J6RXRwZk1BVUhTanYv?=
 =?utf-8?B?UlcwWmdKQ2FFZzltM1RRMXZQZ1pJenhmTDZXd0pHN0pIRjllODZjWGZXRXZ5?=
 =?utf-8?B?SjV5VXFCYm15Z0l5dWgrWEtiRy9BSUZlaW8wdkRXQy9ybXdWU0ZWTjRNUTk5?=
 =?utf-8?B?enJXd1BrOCs0UWNkY3NRTkwyWW1tTktTM09rUStodlBIL2d2TjVqNXJBNlo1?=
 =?utf-8?B?ZXF2UDNFVzZoVU9NbUMvUVR5Qk9wMjVxSWhqRnlkenZGcjZyZEM1K2IvYkow?=
 =?utf-8?B?eTcvbE9yVlJmR0lDUnB0a2xzTzg0K2krc0FRNHpSTnFtc2VpV1RMYlg0MkNq?=
 =?utf-8?B?WjdkWVZGblVmZHVGNGtLbm4rd1pmSU5ORWF4akp0M21qdlMxWVBweEFmWXp0?=
 =?utf-8?B?bHpSaEpLQjJQZVZRckFqMjc2U2hYNDhjOE9JNHROWXo4RjUxNUhXODlSU00z?=
 =?utf-8?B?azY3TlNUWTBhNnU4dUdsR3VlSzJCTk54OWFscEVqYkgzdmFQVnhhWDlsSVdt?=
 =?utf-8?B?OUFhTHZLRDNQK0RJZkYrdllNSllNVSttQWo5UjJwMEhkZGQ0TXRnd2xMM3JB?=
 =?utf-8?B?ZzQzQTFtdyt5ZGNtUlRibFdxVG5UamE4ekRHWjNzMWJTT05WSWhyd1RkYW11?=
 =?utf-8?B?eGwxdFNqZ1VxZWJudHVaOGQvL0k0TThJaVEvZ3lzRVNFQTQwWk82bFIwbjBz?=
 =?utf-8?B?bzRGTnNXSWtTUkZRaVdtZ1NvVVhlK3RjLzZTK1N0dXBoNXV1dS9kWGRBM3NO?=
 =?utf-8?B?YTNRMy9KT0V0eHdGbkNLeFdybWNYT1pDVmExZVM0UUZ3dEYyYnpkSVhlN1Vr?=
 =?utf-8?B?b2tVSU1GZExMbGJHdGNJaldHdFVUajV0eU4xZitFekNjMDRXZnFla2taalVP?=
 =?utf-8?B?QlI4UHkwVTFmNzUvWmJ3cTVnN05KRXgva0oxcUIyYXo4MkZkYk9Sc044cHg3?=
 =?utf-8?B?VXVBSFVoUnI4Zmwyd1ExTUpha1JockpiNzloL0JmcmtPVVZhcU5XQkxDbmRj?=
 =?utf-8?B?aUJtZ1Y3cjQ3TEtic3RsMG5NYlY2S2RTc0thVmhRS1RvY0NEL2ZnYUxwckht?=
 =?utf-8?B?RWp0aFJQT2ZlREd1dnpoUk9URTROVmM0NGF4bkNabnVJeUlEMTY1Zjk3RU1U?=
 =?utf-8?Q?fqwIBcWh2UpQMcpH5lvviKBlmdEs0Msve0f96yT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58daf717-13ef-4ae1-6615-08d901206666
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 21:41:31.9823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m/wrxA+skb2LrBdKApxd76RIEZK2EgG6z30xqJfBdbl+GJgUI/Tr6WLFKomCLYLBY8T7BMzjgUwkYWmsqaJ8bSn5YzdKxrEww9Yo/VcdMEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4799
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9956 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=957 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160151
X-Proofpoint-GUID: 5zlCyDVDPptisdjVCuIUY7lqW9p7Gvu1
X-Proofpoint-ORIG-GUID: 5zlCyDVDPptisdjVCuIUY7lqW9p7Gvu1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9956 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160151
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/21 4:38 PM, Mike Christie wrote:
> On 4/16/21 4:21 AM, Dmitry Bogdanov wrote:
>> Currently TMF commands are removed from de_device.dev_tmf_list at
>> the very end of se_cmd lifecycle. But se_lun unlinks from se_cmd
>> up on a command status (response) is queued in transport layer.
>> It means that LUN and backend device can be deleted meantime and at
>> the moment of repsonse completion a panic is occured:
>>
>> target_tmr_work()
>> 	cmd->se_tfo->queue_tm_rsp(cmd); // send abort_rsp to a wire
>> 	transport_lun_remove_cmd(cmd) // unlink se_cmd from se_lun
>> - // - // - // -
>> <<<--- lun remove
>> <<<--- core backend device remove
>> - // - // - // -
>> qlt_handle_abts_completion()
>>   tfo->free_mcmd()
>>     transport_generic_free_cmd()
>>       target_put_sess_cmd()
>>         core_tmr_release_req() {
>>           if (dev) { // backend device, can not be null
>>             spin_lock_irqsave(&dev->se_tmr_lock, flags); //<<<--- CRASH
>>
> 
> Sorry about this. I was thinking about this patch some more while
> reviewing this version.
> 
> Is there another race possible?
> 
> 1. We have a cmd running in lio.
> 2. The initiator times it out and sends tmf.
> 3. cmd completes.
> 4. target_submit_tmr has called transport_lookup_tmr_lun.
> 5. transport_lookup_tmr_lun has set se_dev and tmr_dev.
> 6. You now remove the lun and device.
> 7. Now you crash on the dev references.
> 
> I think we need to do a percpu_ref_tryget_live in transport_lookup_tmr_lun
> like is done in transport_lookup_cmd_lun. If successful set
> 
> se_cmd->lun_ref_active = true;
> 
> If we get the ref, we drop it in transport_lun_remove_cmd like with
> the non tmr case.
> 

Ignore this. I see we do a percpu_ref_tryget_live in there already.


