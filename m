Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C30FCC43460
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 17:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ACFA6113A
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 17:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbhDIRTL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Apr 2021 13:19:11 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38198 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbhDIRTL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2021 13:19:11 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 139HFMeg079404;
        Fri, 9 Apr 2021 17:18:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=UtxgzsDYC9h/sf1u67v4hKyWkMQdr+2qy/S4DjNKV8g=;
 b=c9hiKN2yAsHBpTltSXo3xs3kh6ykNPaRY5R0+PwjWV9GUUowyF7i1xLi5vkwA+3xhanC
 WqtWkxuvtn/Ug5UxBZCrZMu9Xq+/7oZTK1VUa5N34U+foHbplrMqk2TDTu2IF+q0uTGC
 7e0ApovGvhYILo3DStGi7E4w37NI9YTGW25L4FjbSyh+H2oLHqp/6DYKNJUcAEVbgm66
 6AaMpiePJ3yknIKb8aVqSqaWBvWDJ3Fb0e8/ZqapFgaS8WQpGMksUU0z1rmoWgBotgJG
 +796FyKhADeBckRenr+AEANuPv/1lMAvr1LTJGYvoxvfirF0dYIwQ/GTHMQl7OySjhsd SA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37rvawa4sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Apr 2021 17:18:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 139HFShK040098;
        Fri, 9 Apr 2021 17:18:56 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by aserp3020.oracle.com with ESMTP id 37rvb6udp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Apr 2021 17:18:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fZfXhJwOQz8CY4T4rWTOBN37iQ2D0JLW0tU54H0rPRWrDKILXmlIZ05V21nM9r9fugJ+VAe2vt/HrNlPQ9K45fNiT0OLgVv6CdJ1MtL5iIu3edXW6nRTWoMxmZQxVKBCiLd21fBTxgRq1XN6ojUXcn09tStZKxIuOMDMzptsalln6CRQHFmtPPfPFIyF3UptuUa5gY6R4MS1JXpQK3QgLjT+ZNXQm8GjKcrNOH6SVfWOruwJwXPv/zcjlPqsqCaKopMQtQftpRuKRQy+RR5Zx+gnhxiJ1m5kvuac2RjWoPlJlrt3+P8XLlOr8hoUQMvUOmRGw2tzKssm8XITtG+Gmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UtxgzsDYC9h/sf1u67v4hKyWkMQdr+2qy/S4DjNKV8g=;
 b=f/e4Bp3AXVY8A37XY6aiyOZcYx5sW22UyFOEdbwUsZpGLWX/eTbEzKdoO0Cf+U4ojatdAKlNthgCSLnEE/dLiAcT4suTPDnXlQeOgTP3kIWW8jPwOdeXdgwJoKSP7a6GWGHD75t+Rpk8wvPoWbm9wnFEEpyiWavht7hTGpSmjRBVtTJBQ6r229If+wKMVzjXzGm80Na7Zn3sc69xQAKthju184eNDRckz7ISl3/cw1jvALrWFRHwBNRYV5OlOoNwACrSaKfOtb7g3auM0XJ99E2aAQ00fFU4VqPvexfdcyymzV3hfbcx2sww3JuIECatGAYAsJLwQmVFGvPmfBF1EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UtxgzsDYC9h/sf1u67v4hKyWkMQdr+2qy/S4DjNKV8g=;
 b=M1fWqhZF2FiRkavgaIA5oUATRDHzuH2YYL2hASboS2MqQ2iFLRVSUgPWE7DSJvcxtSfoKFV7l/PmzZPEpKJIxu1HQU1WdG3NU9VQ8e44neWKaln9N0sTBV/OWQWYpPovSQoNE6EnaaiYRjNGO/hr3eS4VvqTmPv4XVwrL8+iaDw=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3937.namprd10.prod.outlook.com (2603:10b6:a03:1fe::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Fri, 9 Apr
 2021 17:18:54 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Fri, 9 Apr 2021
 17:18:52 +0000
Subject: Re: [PATCH] target: core: remove from tmr_list at lun unlink
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20210407142140.29947-1-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <f8182d4d-449a-eb00-7564-a230a1daee8a@oracle.com>
Date:   Fri, 9 Apr 2021 12:18:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210407142140.29947-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR04CA0005.namprd04.prod.outlook.com
 (2603:10b6:5:334::10) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM6PR04CA0005.namprd04.prod.outlook.com (2603:10b6:5:334::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Fri, 9 Apr 2021 17:18:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04f31a3c-0593-4047-d864-08d8fb7b8c0b
X-MS-TrafficTypeDiagnostic: BY5PR10MB3937:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3937D2312712CF96FE2A8679F1739@BY5PR10MB3937.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DJqhLChlUFFHzUfF0IPED1i2xATZLDviCKw5C+aEnkXE59zGkLwAVahR3aFIv7D9Maeqb6xQN3F0I/ai818GQjOZbwL/vjE6W105KkLcl2Z/afPLd7qod6AwarNkHAc79R8KSnhyajfQy4ox3Z4a7iwCAZZFr+/EeZ6LM4Oz2Bg91eoUGb864N34rT4DijdsUfwVWQ5PGJ0jIne5XxrpzHTUgokUB8uwHMmPhzhy9h94rCbtjbFQ7qVP1aZA5X23XLRTdZtSIiPN/+gQsQ/LUFir0QCY+djwiQJWT3ruJQS6shjPdrF8egL6S5oYEilAHoi/qkdARaD3ZGgFi9PQiJCRjN1xYw7XVCx3AlBU5ea0UICL23zOBwhioC/x2uP8pPAx/saiBhHFuIGP2m6NrIrGU3RmpkxRNb7wc9as+VU01n91LS5S+bqyJD/swSJG7dx4CZKqfaFNnlMm23yw9Ex6R8XU0nzAGrtDcr5p8JF7J1J7z8Um0aL9DxtQ2IbdOANRFP9hL5qXUGmdRag5Lrr9XhPC7G47UNUi8edFTF6K3s+U2NeOm2rNVyVqNHM6xU0Rj2qdoihgoecJ1mjeH1LdeiRtQSHFYWWkh7xGw2QO5GHjHfDLkZx34caaIkF4BX43BKW9FWWh3esenMpNsxRfuRQKMRYUvvZzJc29P3ihNTPfGMO4WQYEl3IPfifycx7Nnu7+BMoz+iI80vvf5H87IPzRfyAK6TMFG5VJk7dSSOonGWHXMF7jZj+nuEtVJINXSl0qC30rRca9RBAFxsZCY0hpV5AjmsWn4LnA/qEc6OOeqyfUKyQvUJMj9N77
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(136003)(39860400002)(396003)(8936002)(66556008)(966005)(8676002)(5660300002)(4326008)(110136005)(83380400001)(956004)(16576012)(316002)(2616005)(26005)(53546011)(6706004)(31686004)(66476007)(186003)(66946007)(478600001)(86362001)(38100700001)(6486002)(36756003)(2906002)(31696002)(16526019)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VXl2T3VyZURVdnRua1RhQTRRdXFUL0l6QXc5b0I2TnFmSjlyNlY2MyszVUFn?=
 =?utf-8?B?MWNSNDdWVjJLQUY5QjZmOUVTYUxvYzZzY05VeXN6Wm5hS0NYVlhERWRkTDRx?=
 =?utf-8?B?QTNkeDlCS1orcnhnWisrZ3ZnSXRoMTdwNVdLN1U5ZUtEVzJ0d3dEaURQMlNk?=
 =?utf-8?B?TjdxNDl5OW1EU1owandmdWU1Q2NJSGxGeGphUithQnZHeEh6a0NoeGhRUi8w?=
 =?utf-8?B?bWNUZnJnWlJLMFB4cURtZEtpd3BQV25iZkgyUXBGNDg1U0hib0RBWkRiN3ZI?=
 =?utf-8?B?eXpUYXI5T0UxYlRuK2xYQTFwaUwxNml5QTJBeW8wczZDbzdHc1phM3BZU3NT?=
 =?utf-8?B?L3kzdjJtZHY1NDV6c1V5MG15bFl4K2Voc3RJc1hZR01DRVhraHplSk5oR2Y3?=
 =?utf-8?B?Q0VjWHhrSUo0a2lIQTZDUDcxckJLVVJuQlhOakdnVjhtbHhZUEFTdHlBMDN6?=
 =?utf-8?B?WjE5a3M0eEM0V1BJZUpER1hjQ2NDQ0hLNmNOQXZzTm9mc1RmT2hBelBBV0JX?=
 =?utf-8?B?WmpMWE44OXNkTjNleWpWUnRnaS8vRVgxOWtTYlhZS25kNGJobGU4SEdxb2Iw?=
 =?utf-8?B?bUVWd0dNMnUzSVZhUzh0MURUc0JtaTRFZ3hhc0Zsa1ExbmV4N2ZpSkNFbGJ4?=
 =?utf-8?B?Kyt5M2IrU0tPdVdicGRWaXR5dUJIZnpDVDhqdjhtYVVNVEJLRzNFT1dMUlNw?=
 =?utf-8?B?V2h2eFRPNjFXdmpoQmRxNzBxanJPMUNWSGVDcGltYTR6bmV3K0IrWmI5RWdE?=
 =?utf-8?B?ZkYyWDYyeU1jUDR3d3VUbEdjRGxRUDdFM0d2NzFqaVYrUHhHNi9VQ1l4aEZI?=
 =?utf-8?B?aGNIY1JjbThJOUtqQ1FLZmNQOXQzNFVtWGFWeGNrRDNnTHlYbFlhWWdjaXVI?=
 =?utf-8?B?ek01WkhXbE5ySzQ4YWM3c3RTMzFPeWM4bkU3MnJRUTRCL2E3RW9lOHl5YXNB?=
 =?utf-8?B?V09vWW5pd0docFN3ckxzOUhVMW1ETy9SVHBYNHYvM2xzQ0RmYkhJZEhoYng2?=
 =?utf-8?B?dTNFRWJkWFh3L2E5d0xOcElWcGxXeURwZW93QkpJbVBrRTZSVFJlWndmV2ds?=
 =?utf-8?B?czRsdHpWeUp6S3YzNk4ycXMvNzlPUkNab0pSU1M4eWZqcFl1dFlLWEpwMG5n?=
 =?utf-8?B?T1lqNTdRck11NWJydHpMODY0Z0tOVnBrSGN5S29tcTRNeCttT1E4SWlkaXl0?=
 =?utf-8?B?M3pJaUZvMkpuQUcxdzRQU0NLWnNXaDRHL2NleVRpRjRvcGtXVmxxMFZTcnU2?=
 =?utf-8?B?RVIwb0Q0VDRhVGwxM3pmWXd6RHlsRE1NT0VBMHFvS1d1MWFSSG5vRmliSUVN?=
 =?utf-8?B?SDZSejVVa3B5Vm5XdDBhSkQxcW96b0ZJbXUvNEplL3F0UFlBZkZ2bExvWVhF?=
 =?utf-8?B?YWdKUHNIaXlENTlIYnNXT202NWs4Nm96MXdMSlJPU2s4YVhGVEhFbjdZcEoy?=
 =?utf-8?B?ZlVDUmplTTVaN0oxT0NrU3h3TEFqYmkvVEg0TXdnTkxMbU0yYWg1aGQrRUkz?=
 =?utf-8?B?d3ZrVWN0cXI3K3pTVEw2SlpyalRpL1daaVNUUDJyYlgvVk1keWxoK2NSWS9w?=
 =?utf-8?B?Z0pVSytST1I0S2VkTWpOQU5jc1I2RFVtQUNsN2Z3TEp3SlljV3dPTVpmUHRX?=
 =?utf-8?B?RnVjdkFBalZUVEFUd1MrR3RaM2Z2aFhWazRQdEcxTWhnNEJqanVQOGUyNGVr?=
 =?utf-8?B?S1NNZjUrUHJ5WXBTQmY4NjgvVUFzTzVqanhkRThMbjV0dWlza2xCVnFMWUVm?=
 =?utf-8?Q?FswdY+v1SuPOBaVjsZvXyPv9PcKP8ivjlqQPUqV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04f31a3c-0593-4047-d864-08d8fb7b8c0b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 17:18:52.3250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xWbmJpHbo1/EEXzET/1oz6gmsxu/DB+fPAqUuvKUdY6k6XepnJ9Wjnjr3VwSU0+xLDJetLlvlto7tCK4BPIPvqj+zcqvRl3gd8HwlA0tHhQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3937
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9949 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104090124
X-Proofpoint-ORIG-GUID: iJQgr0ODbMkc_4OzK13FQX9MmwBZK87f
X-Proofpoint-GUID: iJQgr0ODbMkc_4OzK13FQX9MmwBZK87f
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9949 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 impostorscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104090124
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/21 9:21 AM, Dmitry Bogdanov wrote:
> Currently TMF commands are removed from de_device.dev_tmf_list at
> the very end of se_cmd lifecycle. But se_lun unlinks from se_cmd
> up on a command status (response) is queued in transport layer.
> It means that LUN and backend device can be deleted meantime and at
> the moment of repsonse completion a panic is occured:
> 
> target_tmr_work()
> 	cmd->se_tfo->queue_tm_rsp(cmd); // send abort_rsp to a wire
> 	transport_lun_remove_cmd(cmd) // unlink se_cmd from se_lun
> — // — // — // —
> <<<--- lun remove
> <<<--- core backend device remove
> — // — // — // —
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
> The issue exists from the very begining.
> I uploaded a script that helps to reproduce the issue at
> https://urldefense.com/v3/__https://gist.github.com/logost/cb93df41dd2432454324449b390403c4__;!!GqivPVa7Brio!KN-N7Ult7Itn2AzY6LdP2vm0D81UIjpbCyOAH3uf2OoLGUykpGP3dJTQlLm9m71MjsxY$ 
> ---
>  drivers/target/target_core_tmr.c       |  9 ---------
>  drivers/target/target_core_transport.c | 19 +++++++++++++++++--
>  2 files changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
> index 7347285471fa..323a173010c1 100644
> --- a/drivers/target/target_core_tmr.c
> +++ b/drivers/target/target_core_tmr.c
> @@ -50,15 +50,6 @@ EXPORT_SYMBOL(core_tmr_alloc_req);
>  
>  void core_tmr_release_req(struct se_tmr_req *tmr)
>  {
> -	struct se_device *dev = tmr->tmr_dev;
> -	unsigned long flags;
> -
> -	if (dev) {
> -		spin_lock_irqsave(&dev->se_tmr_lock, flags);
> -		list_del_init(&tmr->tmr_list);
> -		spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
> -	}
> -
>  	kfree(tmr);
>  }
>  
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 5ecb9f18a53d..4d9968f43cf1 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -667,6 +667,20 @@ static void target_remove_from_state_list(struct se_cmd *cmd)
>  	spin_unlock_irqrestore(&dev->queues[cmd->cpuid].lock, flags);
>  }
>  
> +static void target_remove_from_tmr_list(struct se_cmd *cmd)
> +{
> +	struct se_device *dev = NULL;
> +	unsigned long flags;
> +

This is just a nit. Maybe just do:

struct se_device *dev = NULL;
unsigned long flags;

if (!(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
	return;

dev = cmd->se_tmr_req->tmr_dev;
spin_lock_irqsave(&dev->se_tmr_lock, flags);
list_del_init(&cmd->se_tmr_req->tmr_list);
spin_unlock_irqrestore(&dev->se_tmr_lock, flags);


It will look like target_remove_from_state_list. Below I was expecting
some sort of twist ending with the extra if in there. But we just wanted
to run the function for tmrs.


> +	if (cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
> +		dev = cmd->se_tmr_req->tmr_dev;
> +
> +	if (dev) {
> +		spin_lock_irqsave(&dev->se_tmr_lock, flags);
> +		list_del_init(&cmd->se_tmr_req->tmr_list);
> +		spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
> +	}
> +}
>  /*
>   * This function is called by the target core after the target core has
>   * finished processing a SCSI command or SCSI TMF. Both the regular command
> @@ -678,8 +692,6 @@ static int transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
>  {
>  	unsigned long flags;
>  
> -	target_remove_from_state_list(cmd);
> -
>  	/*
>  	 * Clear struct se_cmd->se_lun before the handoff to FE.
>  	 */

Right below this line we clear se_cmd->selun. I think that should go in
transport_lun_remove_cmd since it's the function that does the put and now
with your changes we handle all the last refs there.


> @@ -719,6 +731,9 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
>  	if (!lun)
>  		return;
>  
> +	target_remove_from_state_list(cmd);
> +	target_remove_from_tmr_list(cmd);
> +
>  	if (cmpxchg(&cmd->lun_ref_active, true, false))
>  		percpu_ref_put(&lun->lun_ref);
>  }
>
