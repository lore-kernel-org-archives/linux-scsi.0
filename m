Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3058C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 04:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F61F60F93
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 04:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhJVEUV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 00:20:21 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2928 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229463AbhJVEUV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Oct 2021 00:20:21 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19M2vb9k016544;
        Fri, 22 Oct 2021 04:18:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=2P+9WQKlO+3uoRe6ZgqvKaMyNRWT8Kc0lhX3wlohJm8=;
 b=uS7koApQd5gxEye7JZjJBO3+fw9FyuPZLUWz0Qxk7bx3zUgK5ddadZcC4tmTqjlQHHwv
 PL1fCerz5y4jWB5BQSHp9Erv6xiUhhQaKdcB5xrA3skTQ3hwf0khzlW2uEVpgFbcelp0
 aFLn4M+4+DnrQ1QuMx22ZGFWnItye6mBXSdRBBBGUi5JdgaPxNVi2c1Pum8klcsqX4PG
 8oCzvu83xPapKHhsaRxbOcGAGb0/PtQcoIuDRrscySNjCcqkbP4SYldctTBG03HSPKn4
 RXzzqibS711Z2Cnl4fPjyLs65X1g1wxCQN+Fea5y2HaaHZYuquck0lMDzXLsLP5Agria Tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btrfm8mne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 04:18:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M4Ff7s129344;
        Fri, 22 Oct 2021 04:18:02 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by userp3030.oracle.com with ESMTP id 3bqkv32w09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 04:18:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ipuYSBdftJLhFFsL1ZK30RrLgXV07TP31rGdldwZcAtDXpl5h6CDIsvDoxw8rT0y5xOwBgoZ+StE8D9PvtCQ4ue3r661DZJHqoIMDIMbXkLH8GTmf8T4oq+ASmL59Mm2H+w4N6JCSLiZFaeUH6JXTl9se4hgjGDNlj426+8J69pzl5VyJ0YnmBWrEHA5xj4QjvAAEmnPPdJh1E3S8vlURmLTIIVzJfQeCLOAjZl/R1kXZbbLl+greSYafzJROqmVoQ6iHuZe8PZ65ZMpORJLhuQbEx4QWByBL+96sdhcQNuC9P1UMkanUU8JYRswTdnhhv/8TFuaU9LJdSJdCGK/Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2P+9WQKlO+3uoRe6ZgqvKaMyNRWT8Kc0lhX3wlohJm8=;
 b=hnEPwi8Ute/i8klzNPQo9HN4NdHNHbeJI5k3bI8dwyw83m9ZYU9iMhszckyxrd2/zaCL32VJilIfj8zi2awdCpJUpf6WVHhlKyvdbA15y87xeTl99UdkRKjpICF9GQe4QhLGz7EI9Cu/67Z1XRlB//X/ofjfWQrGX296K2bEODLBa3t7KjAl0DT+MYALxpUDyVEWXwVamTXDZ/NL3+8FFU8CeObc43PNn3uP2Zcl3jNMGcJUd0ScZAzGk1ILG++K8SJ0IYaiMHnrfjfJzoJt8zNhStsSaJ37VrM/I4wjrvQ4WM3JsxlcgDUbkhLAL+yfgHOQNND0kNz79Vyf/iCAGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2P+9WQKlO+3uoRe6ZgqvKaMyNRWT8Kc0lhX3wlohJm8=;
 b=YklZaVGGyLjQ4jM1I4Kop/EiIfpR6QHOInCIgfXKzR1read2yyFfjfL+YeuLSoKPri+rozCFbvpyg33DkBTKdSGjdAZE1lfJE6m7Le5PjkXb6zRT326SHDGqd0Y6N47DLH+gGfjnjbMPkuxn1UXp2IqkXOjPMfrSN3vdviBSJqk=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3388.namprd10.prod.outlook.com (2603:10b6:5:1b1::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.18; Fri, 22 Oct 2021 04:18:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 04:18:00 +0000
Message-ID: <fb6ca898-8a70-e626-b3a2-c3ad1734c953@oracle.com>
Date:   Thu, 21 Oct 2021 23:17:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v4] target: core: remove from tmr_list at lun unlink
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20211018135753.15297-1-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20211018135753.15297-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR12CA0029.namprd12.prod.outlook.com
 (2603:10b6:5:1c0::42) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DM6PR12CA0029.namprd12.prod.outlook.com (2603:10b6:5:1c0::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 04:17:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32054bee-0a28-49c4-efe4-08d99512eebc
X-MS-TrafficTypeDiagnostic: DM6PR10MB3388:
X-Microsoft-Antispam-PRVS: <DM6PR10MB338863CE2B5430C1B1BFA687F1809@DM6PR10MB3388.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: boYzAUe04Z+FtTKA9YY0A6DiebpRxvQifOPo0wNfhybJpsBvOF5J4N5IJqPouep53WSBElbIugGRIiqXkRYnYOabjwbyUcoP2F5gylkpXjhdslY99DtTxPaTxxX0WstMkCBaFXnhnkthqPRfiuYEks6BlT3af813811toN+1YORTionAVdCMzj0cYXNTx6fGYp30aKbL21TogXgIqy244N/uifT6QYXGy0PU7eCmkF4LCtLG1Blfep71OjORCyVBqIGA53rj2nvenI3TcZI7APWDEWdQ/1LFZpx5M5cB3Ga2CP/S/YY1YByIHYV+5vidvakKdCDuP38hZ31BZap5N5G2MeIelydy4dCHmghl9tiY7yzxX3mGDPZCgJ0GIi7Upx17yBQMyN7zwptFoYlvt06D7EGlNXemWgElIHWTsoNDMu5aPiZfvnhErJjbsQjzeCukk8e7fzrZF7vdIT1pTPFyunY4qQeH+04lsUfqzgIYLbCZkdsyhb1WpkW1ixuCLejfZvrs27WotncvdjIo5mGNcAzQT4GJqGqfZxdSg6GSEBtQXvjVsQWC3xeduLoCiHRbbUCYKwJOukAqL+rotHqgolXN+T6xV/mU1aMoXROqKfZ/xpqBaZTgfySVIvG5T57xq3w3ySI9bH/bZo9hEgrrLSHYQuVwziZkO/8PpjNCyZ7WPZi+L7zkRiIk1Oq6gsAApszrApdwyN7wPqJa3FxEGEyOIllktkeRk8TyZlKmM6Mizgy4S2VbQHPc0AN06lPWMxnmzH8YXSbTnDTus895ACFWLiQ5BpjqPu0szDetN9frkmLzfC9uWdl6CNs3hFl8E1Al33C2Uh1zOmlNPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(31696002)(66946007)(83380400001)(36756003)(316002)(4326008)(16576012)(86362001)(110136005)(8936002)(66556008)(38100700002)(8676002)(6706004)(53546011)(966005)(5660300002)(508600001)(186003)(26005)(31686004)(2616005)(956004)(6486002)(66476007)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTlGSE11SXRhaDVuQTkydTd0TWZ0N0M1K050VFNycWhlajMxSmpieGtGOVNV?=
 =?utf-8?B?QVdQZmxXN2EwSFppZnFUR1BIVGpZekdKcjBpWkMzY2tpOFNIOEZMZWErazJN?=
 =?utf-8?B?VU9IcUFsRSt0dWZsQllRVG9zVGRyelRKQnBxZENsazRadVhOZVNKY2x1cnVN?=
 =?utf-8?B?bjUvSDZFU3ZoS3VvV3NheWJmSldLanBjbENYSDBIV1V3TkYzRzVhNHlyRFNx?=
 =?utf-8?B?d2ZCYmV0S203R2lYZllFdzZUMnZZRFNhR1lZQWp5THp5dEQ5ZjM2bWIvSEJh?=
 =?utf-8?B?bVFDdGNCY2EwdEdiZjRha2JDWXVCbXMwMEw0YjlXNU14UFZEQ25KMXNDdUZU?=
 =?utf-8?B?emljMEkrbDZ4ZWNUTFQxbTZXVStZb0M4aWJkeTI2ZTFBT3paakU4dXRDVVcv?=
 =?utf-8?B?dXZ5dnczR1ZEaVdoaDc5NkcyaDVjdmxyaHJGTGNLbk02cmJPTk1ZTFcrbUpF?=
 =?utf-8?B?Q0FKMlREVnh4S2VzQVVHZVVJQS9hM1V6QWg1amRJSUoxVzByTHlIemc3bzV3?=
 =?utf-8?B?aGlIT2tRNldIYU9qOEJJOC9VMWNwSzgrd3F4anNHMVQrdTZCcTdMWjh1cWRp?=
 =?utf-8?B?MVlQaTZySGpBVktiRG9aMTNFalgrekplTy9IUHRnSURYY2ZUQmNGVE13ai9P?=
 =?utf-8?B?Mkp2VWxzM2NlU3ZrQ1NvUHl0SkxjT2wwZ202M1RiZDd6UlprQ0JEeTc5SE9O?=
 =?utf-8?B?MVJRcnBSaUZMSDR4cWFnRThMeGtEK0RJNW9pUjU4aUFYaVVsRDQrRUZPQkdz?=
 =?utf-8?B?eXVkbDRQN0VuWUwvL3hvNjJQQ3BLWXZLSTF6ZGhXYzRTRjZzdFhOVFh1STRZ?=
 =?utf-8?B?WlprdXdyTytqTmUzbzR6eHRPTE0yVkJaMFc1VHQvakduUzZnd3ZjWmplem9N?=
 =?utf-8?B?VjZzTGJzMzRMNnlGbjZGRlhhdEhodEtKaFFaVmNzelBiT1NzRStZRGdvbjQ3?=
 =?utf-8?B?YXE4aFQrWitGVk5ncnVMcGdrOVpKV245U2d1TUpkTzBMUVhSVHdQR3AxUk9U?=
 =?utf-8?B?dkg3bEw0TmhJWWYzdURwVmFGdU5WWThrQnFwbWoxT1RwQTVSSlBKVU5IaHFK?=
 =?utf-8?B?TXhpVVZhTnhkZGdSYm0rYzFwTFE1bTlFaE0vaGZCajJtL0dVUGhMUXpXNUdD?=
 =?utf-8?B?WFUzVTVCTDAvc04rYmp4eXNFREF1QU9KNkt1T2pWSGVWM3IrOE5NS1NhVDRF?=
 =?utf-8?B?NEZYWWRScUhYd0FXdFNOYU1vQkh1UXBFTlZZV1Z1WTF1YUFOMkI5TDZlUktE?=
 =?utf-8?B?U3dBQVBCeW9ZVUxJaVdjbUd5b2oyL1FBaEhkZzg3K3k0b0p6U3EwcnYxRmNn?=
 =?utf-8?B?bU5CZmZDUUFpQk1JY2xxTGY4c2VLTWtqOWMrZ25qdzZtUGlWampqR2JObmVm?=
 =?utf-8?B?dXgxeHMrRmpiVXNlZU5Xa1BHb1dJLzBzcUhjMzY5ZVhETEZla3RWaWVhQ3Jj?=
 =?utf-8?B?T2VDT3Y0akEwZjM1MzM3bmlYVGJlUXgzdlVlakhSSmp3UStqbk1WazV5VzFm?=
 =?utf-8?B?aVhrNGt3WTVZaFMxSGsxcGx2clhHZW9LSDBMTEN3OUNMbVliOHNwMzcreGRO?=
 =?utf-8?B?VzZTQjkycHJTV2lBMHRHclU0QzdXaE40ZjdFWExDZTFPUEJmWkdUN2Zzc21O?=
 =?utf-8?B?UERqOFpHVElLQ1dBVDRtNmE4Y1F5T0RwT0JRckErdFpOcGFvWUNweEVabTlU?=
 =?utf-8?B?ZHJoUWRiN3N6MS9wYTNaYzdEY3RwRFMrYlNXRXd5Z1dCZEFzem1XazR5WDZs?=
 =?utf-8?B?SEtNbDRjYklvQ0x6UWprTVdKK0Rkdysvb1lINnViUXErdXJXWDBKYktUMDR5?=
 =?utf-8?B?VVRVZzFDL0VoejJkamUzWFJhMlVPeCs2QS82Y3B5Lyt6eDFxTmRMMjVJdTJ0?=
 =?utf-8?B?bUgrcThIK2xKSXRsRW1Oc0dEWlczNEEwNzdYdVZqcTlpY3hWKzNXYW5PRFox?=
 =?utf-8?Q?xm/ki0+EsTW9RxKlKx3AkqXfDhkL9lQJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32054bee-0a28-49c4-efe4-08d99512eebc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 04:17:59.9604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: michael.christie@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3388
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=719 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110220024
X-Proofpoint-GUID: tknzHpFUJ6YE7btTwwLbEoaHaUTIGeGp
X-Proofpoint-ORIG-GUID: tknzHpFUJ6YE7btTwwLbEoaHaUTIGeGp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/18/21 8:57 AM, Dmitry Bogdanov wrote:
> Currently TMF commands are removed from de_device.dev_tmf_list at
> the very end of se_cmd lifecycle. But se_lun unlinks from se_cmd
> up on a command status (response) is queued in transport layer.
> It means that LUN and backend device can be deleted meantime and at
> the moment of repsonse completion a panic is occured:
> 
> target_tmr_work()
> 	cmd->se_tfo->queue_tm_rsp(cmd); // send abort_rsp to a wire
> 	transport_lun_remove_cmd(cmd) // unlink se_cmd from se_lun
> - // - // - // -
> <<<--- lun remove
> <<<--- core backend device remove
> - // - // - // -
> qlt_handle_abts_completion()
>   tfo->free_mcmd()
>     transport_generic_free_cmd()
>       target_put_sess_cmd()
>         core_tmr_release_req() {
>           if (dev) { // backend device, can not be null
>             spin_lock_irqsave(&dev->se_tmr_lock, flags); //<<<--- CRASH
> 
> Call Trace:
> NIP [c000000000e1683c] _raw_spin_lock_irqsave+0x2c/0xc0
> LR [c00800000e433338] core_tmr_release_req+0x40/0xa0 [target_core_mod]
> Call Trace:
> (unreliable)
> 0x0
> target_put_sess_cmd+0x2a0/0x370 [target_core_mod]
> transport_generic_free_cmd+0x6c/0x1b0 [target_core_mod]
> tcm_qla2xxx_complete_mcmd+0x28/0x50 [tcm_qla2xxx]
> process_one_work+0x2c4/0x5c0
> worker_thread+0x88/0x690
> 
> For FC protocol it is a race condition, but for iSCSI protocol it is
> easyly reproduced by manual sending iSCSI commands:
> - Send some SCSI sommand
> - Send Abort of that command over iSCSI
> - Remove LUN on target
> - Send next iSCSI command to acknowledge the Abort_Response
> - target panics
> 
> There is no sense to keep the command in tmr_list until response
> completion, so move the removal from tmr_list from the response
> completion to the response queueing when lun is unlinked.
> Move the removal from state list too as it is a subject to the same
> race condition.
> 
> Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> 
> ---
> v4:
>  remove superfluous transport_lookup_tmr_lun that could race with lun
> reset
> v3:
>  remove iscsi fix as not related to the issue
>  avoid double removal from tmr_list
> v2:
>  fix stuck in tmr list in error case
> 
> The issue exists from the very begining.
> I uploaded a scapy script that helps to reproduce the issue at
> https://gist.github.com/logost/cb93df41dd2432454324449b390403c4


Reviewed-by: Mike Christie <michael.christie@oracle.com>
