Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F08ECC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 16:15:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348037AbiCHQQN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 11:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235085AbiCHQQL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 11:16:11 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB2050E01
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 08:15:14 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 228FxDWJ009809;
        Tue, 8 Mar 2022 16:15:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=JhCpsikvIFC0bnl1ljm5DmimGxulM0Xcj3deDDZOUYE=;
 b=gP5CkvZGPQeCMIqYTnq7qK2GZ9CRO2Cso0chFD3aeZgn9A8HA7IFxeWuQtZAd8soFI20
 aPlbHX3gnaA5c1glOE7oiaT0mO6lmuYePwnvywluxrB4s8knIKSPnflpZ23DfRy6Dhtz
 rORCurhmZk001grlt/fbrgfHrE+4Q2PyLkd15vETwrJvkSLeimUdSZWn+PChDNizgzOp
 sM2sG68MrCT5JXoUXhWHjCMGK5NGhPYkyIbAgtxbS3jYMnYf13Tjp0/MQmq7hzbdSHzz
 r+FCKbBfZa4YXOwpdS6KWxxj0f+mIMiCl0G6XlVL+uSf2pQrcwvvXl8FRYeEBbcB5QVY rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9cfbyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 16:15:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 228G6N3U128118;
        Tue, 8 Mar 2022 16:15:04 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by userp3030.oracle.com with ESMTP id 3ekvyv1933-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 16:15:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IiG1hL97JflkS04YvZIBimRDzbhIA8OsVGGwFk4j7khleFhgSpEW972xrNGxCJSzedFBnxjpQEty7n3tTNZVI3pO714hk0HxfRFbQgCJ2vYRH7vvBS5aLkAL3c5yblhuc4S2jbU8nXCJEE8VY9CdBaBjLGwpBenMw4xJ/osiSRnAEGZhqyG41XUQr5c0BOmpmQI+m9nfemHY63ACw9zVZkPxZVTtBSVkx0BXK7BOLlGgDi9ZldylLqWvaPh2KCvePQ+P5J70IcrSQY6QLUF8W7JnPyRg+euH8YA83ZC9r6VSYa5kv09ZsHVh01a1jHyuyx5LIIe5sTvyDHhhqNLmiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JhCpsikvIFC0bnl1ljm5DmimGxulM0Xcj3deDDZOUYE=;
 b=oHJ+o2KSTBdvW1wq405koJpsoutcjjOWH6FXAJ2YAVx6jgmipTrarxxSaHrm8WqqeaxKSymCU03bW13uymBql996ovp0yCj86XVwndDD85/D2Fo9rJckyAY9krCn3RmFcv9oBCvnjvowdurfRNPdwAA7YCoS7m56i0LeJRqrOQUqvx97ZDODZ29bm6V4sSrffjeDR9Sv4aGhzWz8Ju5ph8tliWFeQUpYzsqCAxp1ucFfK3sr+03gVDosAwC/o2/5L1YP/EgWdK0WRm4/THqBrHnnWJxPt1//Dz6sa1jXMESFXn73JRxMiNJKoEpZ0YoYo+IlEeaMuIJ9Mdk6/1ktNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JhCpsikvIFC0bnl1ljm5DmimGxulM0Xcj3deDDZOUYE=;
 b=DnWdr7PDu0F4tIeg8mV1lF9YcLIwy4F4JzoARccak1aHK/2y+k6oUDW81CCBGAqbGKZvVMg0+J3ohwf8XI48Iku6pk/Kw5L9nvSwEyVbS3tFK2LSbOk9VmX0sH5fVecco/Wie9mtGnhsU5pX3oz06+JfhDuACMletzA1TRaxu8U=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN8PR10MB3633.namprd10.prod.outlook.com (2603:10b6:408:b8::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.19; Tue, 8 Mar 2022 16:15:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 16:15:00 +0000
Message-ID: <b70ff951-ac86-f4f8-c5f6-ff29fa184170@oracle.com>
Date:   Tue, 8 Mar 2022 10:14:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [RFC PATCH 1/4] scsi: Allow drivers to set BLK_MQ_F_BLOCKING
Content-Language: en-US
To:     daejun7.park@samsung.com,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "cleech@redhat.com" <cleech@redhat.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "james.bottomley@hansenpartnership.com" 
        <james.bottomley@hansenpartnership.com>
References: <20220308003957.123312-2-michael.christie@oracle.com>
 <20220308003957.123312-1-michael.christie@oracle.com>
 <CGME20220308004023epcas2p12ebd497c14d32f36d0aa6682c0b9d0db@epcms2p7>
 <20220308070049epcms2p78d9e9b9bacd3fb6b52de8eb1eaedb623@epcms2p7>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220308070049epcms2p78d9e9b9bacd3fb6b52de8eb1eaedb623@epcms2p7>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM3PR14CA0131.namprd14.prod.outlook.com
 (2603:10b6:0:53::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5cdc2ba-4120-444f-01c2-08da011ecb6e
X-MS-TrafficTypeDiagnostic: BN8PR10MB3633:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3633C6552A3ADFC398D17EDFF1099@BN8PR10MB3633.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q+PIzh2mq8xIgrc6FWdLeOpYz0TJ27AYvKo69ySKnz3jEq/556D17WwwIHOdoRjhupRKiWdu3egEPp8mANM2uVYcSeGBA5rnRqwmHJRkEmeIPdXxMgiKMWVmlgUgiz2U4pVD+idDVETFfldd2udUELWLGtyg7HQTeTIw9vUP+HUga6Qe1Ov5KfQNt30PYfaSrJBUr1aisndbDYrcq0/VhPdUhClzu13F6Zd2+kyEZHjEE7VvpD3X2+iKX71snXfGfeMS2OI8J+rjNBvSMAZ0sblmgDY5aOUNiRbxaSnmx8TXz8ZI/LIQrVFPdDTH4MDKvYnKEf8NdXQAXJaSllYYq3pP0mFjQEFyMnDcEFaWgL7zO4g+NrTI5fkaIXDi2BSXGLp3C+knQzxnWsH9Lv2N+vk77QcpqDHeIdUG2unFxPJipz+rf5EhE5+4dfp0L47dIIVuTFwSdXWtv1bRaAOT10KIJFTSC6TADK6qR37PP3zRPBG20YSrY5I16rMQBB1BDOl6gxEkFfJkm85qKBRAYfNgipCfj9PhQ0dbxh4ytYxq5LcuNBju1ctmoAygf4FhR+RSPXiZM3kLNhZyeugCcrhGw67vV4CfxwQzQVvJsHEGWsTL3mhDfX2sLBFv/cfUH+cHAZ0QUPB0UY7qucEjiOMSsdjbTrKP4X6un7gooCLdgC+6bBibDlkv/MuOG5scQYi+4MfwalDGxNotLJUMM9hdzY7eFpOoA5Iiznop6xrbE4/pN/6MKhNJHtqdDPA8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(6506007)(186003)(26005)(6486002)(66476007)(66556008)(31696002)(8676002)(53546011)(66946007)(38100700002)(8936002)(5660300002)(2616005)(2906002)(110136005)(31686004)(36756003)(508600001)(6512007)(316002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZE5iTjJ5MWtlYVBycGdGcnplSGh0ZDRNOHk0WExubktaSmwrT3JrL3Y3Vk9y?=
 =?utf-8?B?L3JrZFVaZXNvRW1sZVo5LzB0eGRTOWYybEFJU0NYK2huREFBWFpINGNGUG5s?=
 =?utf-8?B?WTZwbGF2Y3B0NnhHMjhTcm9ha3dEeXlvZy9DbmxVazRKeWM3SnNpdTJieFVt?=
 =?utf-8?B?OUNSenZUUFovbGxZR0V5RE94emtGUmNRY09Ba0krcFd0M1J0OVpiK09TV3Fw?=
 =?utf-8?B?eWtuV3Q1dDZPa1B6cWZPelAxemFCeTNBdHNocmpGa3ovRS8yOW11QVhwWHVR?=
 =?utf-8?B?SURrMHF1SndVek1DZVNXQUd4VGRxRmRXK1FSMnd6Q1cxa0JmWmRWUk1oUGhk?=
 =?utf-8?B?QS9UTTE5c052MXUyU2RzeTRmRHBSaytjQUYrTDdCYml6MVY4OVdqbHJTZXZR?=
 =?utf-8?B?Z3ZYbHJtMTZmNzRMRXJWK2daKzF6cE1LTVBLY0toM2ZlSkVPWGR4TFk4YWpj?=
 =?utf-8?B?dks4b0VSVHBuY1FRNk1DUER1M1ZiNVptQXJ1a0UrRnpNRDdWd2libjUrWlUz?=
 =?utf-8?B?bHlOc1lzUjZZRkdYSEhTZGZ2OVp6cUJkaHNLR295RWNZaHpTVDIzb2U5aTRy?=
 =?utf-8?B?QXNIQUt6ZGZ0MXcydDd1VXoyUHpMQzQ5eHdlV3ZvQ2czcEl1dVVrbUY3N0Zo?=
 =?utf-8?B?VXR1UUVPYnVMd3RobTdMM1RPTSswV3hlVk9ZRGNLYVFFTFlvWGt6ZTVVWVh4?=
 =?utf-8?B?S2M2eHQvbHY0SWFrUXRVQVROYWJWcXdKUzJIaGVodHRPa0laMDZxRDduZDJ0?=
 =?utf-8?B?WkRQRnRhVEU4Q3ZtSHBOMDZ2MWlseXYvY29TaStrdDJyQW1IcmRwUXdHZU5I?=
 =?utf-8?B?WGxNZ1BNQmE5K01ocnJyTzNJQnNwUnFOL1pORWcxY1NWSzhNWnppek4xMVUr?=
 =?utf-8?B?Snd4VXlKTVpXZjI2ZVpjcjFmZzlHL2VrRkMvcWFUVWIwNjRGQnRTczlQbC80?=
 =?utf-8?B?YllDRGQ3eFN6NzhaRmdVNCtvRUwvR1g2M2NwNFRpU0F1K1ZITjNOeUxsWnBL?=
 =?utf-8?B?czhqUXZwbk1hUHhyQ2hMVkkyendHc2Fxb3J1bnVqejhZRGlmSllyRzlFd1JR?=
 =?utf-8?B?akJveFZlRWc3aHlmVlFCK2t4anFUZURsWWNnMXo1bHNqUjc1MEVMMGJPZnA0?=
 =?utf-8?B?K2tFaHEvUWFTeEZ2b1ZUbE4zOTIyVnhhRnZnMGl2UEpNRFNuOWoyMXgveW5o?=
 =?utf-8?B?RXl5dXpvUTJEdlY1VzBuaGkzM0RrUHFpWjVsMU95QmFqNjFleklJZ3FoTVFi?=
 =?utf-8?B?dk9uam14N0RQTkNrR253UzFoTHIvbnJqWHdja2lLaTZZNUZOQ2hoRTNCT2hq?=
 =?utf-8?B?SU96MjUyb3pSM0dkSFlFdFEvM3k5bDNiWC8rc0JRTVZHYmhzSThuVFdjQVY3?=
 =?utf-8?B?RVRKRTEyZzlpbmlvOGtHcVpSTm5BZGthVHR3S0JRd2dDTTNEeU96eUhGK2pz?=
 =?utf-8?B?UlVFVVltZXVuZ2Z1S0FYdnRGM3kzZnMxR2hLbmVKNkc5TmMyVXA3RjFQWUJW?=
 =?utf-8?B?UVhCemcvcitRRHdGK0hydVBrdU51d2RwTjN6aHZUWW04L1BvTXJyL3Rka0kv?=
 =?utf-8?B?Z01VU2RVOENZam1XMHJlMzh5V2hSNVJQMEp5bVBocklRbVUwdjZ4Q3Awa1k4?=
 =?utf-8?B?OU5SYjhrdUZNMlJudFFpWURGUUZhajNkcUd2OVRXYXRRQmMySlVUVFhVbFVE?=
 =?utf-8?B?OSs3T0xUWnYzdGV5SjhkMWZxVkRJSFVSMy93eFp1YzFHcHhMZWR2Y2lzWXVR?=
 =?utf-8?B?bzVpWnJSZGJ0clNLWWJ4emxDOGJvek5Ca1hWR0VmSWswbEhHTUpZbC9tbVBz?=
 =?utf-8?B?eGlsdDRjZVpwUEJJSUhMMTFXWTB1WVIwNjhFTHEwR0FWR1ZUTER3eENaMkdJ?=
 =?utf-8?B?cm9SRm00MkNXbG42dWlzMFZhUnBBSHI5cDJWQWI3dFFJcmxPYXdmbEJ5TkhP?=
 =?utf-8?B?K2tBcTZ1K3ZuT3dUQ2dUQjhtQjhpaC96eGE5eGdQeTF2WDFjQzVwaXlxZ0dU?=
 =?utf-8?B?YTJFUzFnQzdoZkJsOVFtQURpQzJBRVdzTFlGUTVEWnM0aVd4YnFYeDl5Mi9Z?=
 =?utf-8?B?aFdZQmxpcnRUYVVremx1WXI5SVkyYUZ4Z2Q3UGxzaXBlbkRTTkJMVm1xa2cr?=
 =?utf-8?B?dmFyRnV4NW9ocmJ5SnVpMWJxRllqSjNUU0dvN2p2RGZsaHJZOFVNMmFLTWVw?=
 =?utf-8?B?UmovbS9GT0UzbjZlaGE3YnQ5bGNWV2JIMmJCcmVFRkwrRzVoOHFMU1ZhRDcy?=
 =?utf-8?B?aEhyUlBIQmlZbXFlSjdoMkJhUllnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5cdc2ba-4120-444f-01c2-08da011ecb6e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 16:15:00.1227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rl2Muueu45KgYtTi4V/yPmA4EQyp20bnoDv2vd2T3eL3nJwb1wOo59cm1ZhK8CBCW7Go6nyuWysSwe3ZSZGw+r0hJT4d0c9ipn7qgl4JPgM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3633
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10280 signatures=690848
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203080087
X-Proofpoint-ORIG-GUID: icSKeE9QKMyuWmeHJyPlzRzK17Y1Fz-T
X-Proofpoint-GUID: icSKeE9QKMyuWmeHJyPlzRzK17Y1Fz-T
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/8/22 1:00 AM, Daejun Park wrote:
> Hi Mike, 
> 
>> @@ -2952,8 +2954,8 @@ scsi_host_block(struct Scsi_Host *shost)
>>         }
>>
>>         /*
>> -         * SCSI never enables blk-mq's BLK_MQ_F_BLOCKING flag so
>> -         * calling synchronize_rcu() once is enough.
>> +         * Drivers that use this helper enable blk-mq's BLK_MQ_F_BLOCKING flag
>> +         * so calling synchronize_rcu() once is enough.
>>          */
>>         WARN_ON_ONCE(shost->tag_set.flags & BLK_MQ_F_BLOCKING);
> Should we keep this line?
> 
> And I think scsi_host_block() should call synchronize_srcu() rather than
> synchronize_rcu(), if the BLK_MQ_F_BLOCKING flag is used.
>

Sorry, I messed up the comment.

The comment should have been:

Drivers that set the blk-mq BLK_MQ_F_BLOCKING do not use this function
so calling synchronize_rcu() once is enough.

--------------------------

The iscsi drivers that use BLK_MQ_F_BLOCKING use scsi_target_block which
ends up calling blk_mq_wait_quiesce_done. That function will do the right
thing wrt rcu/srcu based on if the BLK_MQ_F_BLOCKING flag was set when
the scsi host was added.

So in the above comment I meant to express drivers that use BLK_MQ_F_BLOCKING
shouldn't call scsi_host_block and right now the WARN call is valid.

However, I could do something like you are suggesting and do a:

if (shost->hostt->queuecommand_may_sleep_blocks)
	synchronize_srcu()
else
	synchronize_rcu()

However, I don't have any way to test it, so I was a little reluctant
to add that.
