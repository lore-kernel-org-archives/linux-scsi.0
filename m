Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A45C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 22:39:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35191613C1
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 22:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbhDPWje (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 18:39:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34948 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234662AbhDPWjd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Apr 2021 18:39:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13GMa7ll152312;
        Fri, 16 Apr 2021 22:39:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=b+WFe/HcRw64NGPz7/c+j1qyXkdlMYQpIi334nfruMc=;
 b=ayDeh3qQ3jVY1J/ryY7QRfAiJuxpXoa8Su923+InSynyxzqK0BCNr/0xhhgkHZrMFfDP
 13ziEFG5QCthKBWlnSdpdNHdvGgBb6dyEDDQYKTnlcq6M21zshgWOT5SxkC28m9a89Vu
 sX626tNf0xNLRbWrYvXo2SSTAPfTxVmj3zw8VvMRwTvjkzU/LIvlxzIYl7dn0k8hHvEG
 eo/s/UgEcEVRLkk5mM1Kd4+DVYD8Ux1a08ufTLkTmj/E5cgQsQevdwz+syPE0iteAMPN
 doxEUlHgtxyLbl0L2IkeuQz10Fp04RaklEjHbZapj6nY6vG1YCs4EkHFDsaXNVDRHDKg vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37u4nnted5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 22:39:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13GMZssH042762;
        Fri, 16 Apr 2021 22:39:07 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3020.oracle.com with ESMTP id 37unx556ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 22:39:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KawNmeMIkKfBHCgdd3dfXtXtifydCdjqendrJ2V8RGDBTam7in4sY1BAEJ8p7ff9FTVngk5qMzPnqEG0OH3nvLsnRKDWTzFb00fnuTvsWbnB/II7oT1b4jyg09Es1f4Np/M3kxVdueU0o6Ui5LeKWSq1XdZp7B+Tqz386Eo6R7BNBJiaKGf4n2j6OlPcyZ4ByTYDjuHUWrkgOZcdcJq5YihJVU4p2/0fYUCG5PTB9S1Jw4erT7EhGKmXvszJdgJZXuCOZIGFZ2RTBink5RPDUoo31GNy1xcZLTzNeszh/inS9y0wvyL48foK2v/uwuNtr9C/O0Akx7QFuRIsokwYtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+WFe/HcRw64NGPz7/c+j1qyXkdlMYQpIi334nfruMc=;
 b=nZ/94Th2jIz8ppR77Ssm8qbTz2II9/6R5QpXVa3AcSAbTmgwE+MaFQweuCeFRI1+S7wDrmv0pzCfPbBzAle6mDUplFPoMhmo9ieB7kCFEcvk+eTC3FTQd9jNpg1gcE5MXYGI/4b5+pys426R5jBKOHfS02LIEdvE0R9zIX6FXFsi+3fGL7lH/hsOdXvJdPVtWlwWYpsj2SlIYfqJkIzFLPLZ6FTF7T9gV733wxTPp7nbq4IZ+X1+B6NoyhpqbOZf3+bHJIUPn+cWW0ZTnb3gb5Zb1KyUVuKMgd7VviXt3KV6hIPFbH92OPqR8Sjp7O2astaZ/pcQ+w5TdariocRoqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+WFe/HcRw64NGPz7/c+j1qyXkdlMYQpIi334nfruMc=;
 b=bs2eUrJ55vIJcWphSTJ42VmcwOxoUn20FLl5Sud4PsbHAh5W+4ltOrdmD41F87HwicOmBYwh2QveE65bHWM+7zX9sAE2L59M9ss+uIY6jB+h7CsB8MmBHCXt1V0bpjNnvnTVRsmotO3LWgK3cuvUwb90dbJ+83x/Q7R93fqigu4=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4797.namprd10.prod.outlook.com (2603:10b6:a03:2d8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Fri, 16 Apr
 2021 22:39:04 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 22:39:04 +0000
Subject: Re: [PATCH v2] target: core: remove from tmr_list at lun unlink
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20210416092146.3201-1-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <d4a19bc6-a89a-7572-b726-31df86fc84fd@oracle.com>
Date:   Fri, 16 Apr 2021 17:39:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210416092146.3201-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM3PR12CA0063.namprd12.prod.outlook.com
 (2603:10b6:0:56::31) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM3PR12CA0063.namprd12.prod.outlook.com (2603:10b6:0:56::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 22:39:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7df72420-c871-4d4d-8b54-08d901287075
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4797:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB47977D1C1DF9B59210AD8F0CF14C9@SJ0PR10MB4797.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mqmrTyPEND3q741tCsF1DCa25EX7vqYybn0Y5NjhzqtwsS4ORkChKmzZ3MPglQrA9QJKboey8ef90+hDHkL7X+LnKqPtldFcTucRJ5EXXQcT4ypetvrFdWlApazBeyilXckBJLVQqcwXtZqHygj+Osde4amlg8lDqQRd6NSHY9gy2ZHxVTIFrz/zrhayj3qsKRis7ev686ALjZ7I/58VUOp1Oo3VHmRROdm7NdhatNj1vJgLZ59n99b4kNfPfK3wkUOPlg7gjpLSt+Ep7TZgZbs3teIZd/ZLNNiV3ham+KRieFcESG3ZoNTdy99+zV8pwXWJWsvefuZ0hbPuOSve2ap/OEc5/d0ZbxzCBhJh/KxsBzf6i0o3TQ9ARBFb4qj9KOOrEvnWNLcZkN9is1qrDSDG/SYDnesxP/Ey/ME6yNgmjFT3QDqTs6LNwb4mLHZksr2ScDVfkb07SyEuVLh36FoqWOeKHAXtLKMX8kF0sHxDHmsTJyKZRzgH4p1JbYdq1SwpFiYQyBnQ9sFAKveB4/ZLqp+qw+aMJnkKq8/5cpzp/OzdwP5fGWgH5wfnqHnTWg+/GMYtcYF5+q7/h1/O66RLMWLfFpEjtl44PjXEbZGbEQX+RxmqY7TVpR2TkGceN5VVAk4tV+1FQGkq1jlBsbcI4VtkAqS+ivyRy60sGmAZMUPsMb57z3ejUNAPl1dmB7OtW+1sUVhv0hAPiRz7+5EVJPnbZbQDa1PwliWrw2KgN5FALYrUKzjdMU1N570JQIdlAxMzftmoLcldPDailWM2x23y9H2FUFXP6ly//EY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(39860400002)(136003)(346002)(66556008)(66476007)(66946007)(31696002)(53546011)(36756003)(16576012)(316002)(110136005)(83380400001)(5660300002)(86362001)(8676002)(8936002)(38100700002)(26005)(6486002)(6706004)(2616005)(956004)(16526019)(186003)(4326008)(478600001)(966005)(31686004)(2906002)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MCtuYXpTNTVsNXNmdTZFSUVQOXl5RXhEcW5wS3YzajBwV3ZvSjlmUllTcGNq?=
 =?utf-8?B?dFZzTENhZEhZS1J1aU5TYUp5aDRNWnhud01PWGFnTEdpQVhIaXZTZk9mYTRr?=
 =?utf-8?B?Q2lDYnlOWDd1ZUZ5a1FFanAweXpmczh1Yi9QMWF6SE9GZHhibHhZY1JWR084?=
 =?utf-8?B?RGF3QTNoajFWMW9jT0pJbTlyUkRveHlyMVp2ZVdSWjI0eUdhdXRabmhFY2Zj?=
 =?utf-8?B?Rkg3ZzBiVEd2V2FPL0N0K2hOcnIzWnJzRzhJdkdkbkxKanpKQTJFQVhIZjJy?=
 =?utf-8?B?czVBRHVXOEtUazJsTVZBdXNXUkJkUktPcFFnRDAxTk16cTZXd2tqS3RyU2Fo?=
 =?utf-8?B?dmdYRnN4djRtb2dBRjZIcWowTGNub2loQ0FVc3dnZEZUdzdPK1ZVKytPaS9l?=
 =?utf-8?B?N0RFZy9QOTZpVFJ1TnhxREQ4c2U3cXBaUXhjTTBMUVMvanBFVk0vWThkQWt5?=
 =?utf-8?B?RmhTVXZhQ09aTzhud1BoaEZORiszelNiczFXWllnekVwVnI0Q3VJbnlvZzIw?=
 =?utf-8?B?bGR0Z0hPZEFhV3ZkRmRORzUxR3lDN1BYTWt0Snh4WTFEUGo0R2UvZ0JmOVd0?=
 =?utf-8?B?REpsS1dITDdHYzVoUnNiQ0FlQkM5dlVnNkRwTVA0QnVUY1lxNlhDVzJybm9l?=
 =?utf-8?B?eHQ2N3o0REFpbzVkdzNTQ3FZQzI2R2pYQXBLZ0pZR3dvcTNzUUlraGptc2NF?=
 =?utf-8?B?M1R1enZBbi85QVFrOTFLK2p4WkJtSEd5Zmd1MGcxbjNRQ0lpNngva2JXQ0JD?=
 =?utf-8?B?cGRqbGtheXV1NGdxeEV0V2t4T000MjJBd3ozaFh6QklaUkkxc1hESXlDbDB5?=
 =?utf-8?B?dEhYT3JKbjY1L0g2clMvTTJGQ0grOWo0Qkw0aGM0NGdHVUpaV2xydTRhWVhw?=
 =?utf-8?B?SlA1QnUrVEUwUHBYN1dkempDVkhTbXh1Vnp6OElQQ2hhVUxtTS96R25uOWVk?=
 =?utf-8?B?M2w0amZZNlJMZWdHaU5jbnZUaENOcG5MbEp3OEdrTjlBNk5vckxOYXVyNkJ6?=
 =?utf-8?B?NEgrK2hmc1pzTmZEcGg3eGQxeC9aMXVaRmpOazd6dXRGVmtjM1ZQOVpDcWVK?=
 =?utf-8?B?Sm52U1p0MGxzMDdwUzJXaHhmUlpDTTJkU09KakJaR0xGNTlNZ0dkZFJ4cTBk?=
 =?utf-8?B?QUZYb0dzSXlEQTRLbStveFlzajlqM1JXOVF1VzJKWUVEcGcyUmE3bDV2WWhX?=
 =?utf-8?B?L0lQZ2JxUlZtNXdyUmFmdFpVY2tmMFlEUHRqZWN2NUVISXFZa0I4cEZoK1J6?=
 =?utf-8?B?bUpQSGxTV3c5TTNtbDRqNmRjZGlHUjcwZ1hyanlzK0xtRHYxOGZLMityUkhp?=
 =?utf-8?B?ZWRHTUtSZHhWWGpWNXY3ZHhTNTJqN3dJODZJR3dCQ0tjK2w2REtaTFBJbHQ0?=
 =?utf-8?B?SG9zdnJLV3l6K2t3MHJvVXV0bno2cXZkME9qanZ0R3J1YUNJcEFtUjBxUDd0?=
 =?utf-8?B?WldiWE1FdW9KN2RMcGZ4akFHYmtBMThIOWlmUHBmaCtkNTRvT0Uxekc1NmRG?=
 =?utf-8?B?eGIxT1JEb1YzQU9QRXJ6Tzc0b3V1QThuUSsrQ0RUOFFvc29kSkNqTDJhUi9L?=
 =?utf-8?B?QVdvVjB5R0xsbUJWdjJLRWN1U0Z2VnMyUi9JTmhBWTBmN1V0VDFVL25tQ2NG?=
 =?utf-8?B?S1lkV1o4T2xublhvUGVjWnFBMEhDK0dUTStXZ2xQeE0wM1pSL3YxTUlab1lE?=
 =?utf-8?B?QW9keGxEeVRJWmN3ZFY5aFVGL3FkeEdDTUh4NmdXRUpuaHBhcndEL2F6RHRR?=
 =?utf-8?Q?7E+pmMno6IEKsmWRCtePlgRneX9vJggCpP2vsOY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7df72420-c871-4d4d-8b54-08d901287075
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 22:39:04.8236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: deT3CgW4ndHXGVeaRizYA/vXnCawiEiTTmY599jaqRI7muy6Sp5eAbRLIMiLgrDc9Yt3oonEcWHZciw31sSiNubRpE1z0nXpyF750LMR0Ec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4797
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9956 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160158
X-Proofpoint-ORIG-GUID: 4y1uunsqBf38FwBmSPaGktFjkz9yuZQk
X-Proofpoint-GUID: 4y1uunsqBf38FwBmSPaGktFjkz9yuZQk
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9956 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/21 4:21 AM, Dmitry Bogdanov wrote:
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
> v2:
>  fix cmd stuck in tmr list in error case in iscsi
>  move clearing cmd->se_lun to transport_lun_remove_cmd
> 
> The issue exists from the very begining.
> I uploaded a scapy script that helps to reproduce the issue at
> https://urldefense.com/v3/__https://gist.github.com/logost/cb93df41dd2432454324449b390403c4__;!!GqivPVa7Brio!MjANCRIp5ZrtKYonxEKclROOwOe7s-adKHLiUd2Njis6m1774RMpLGNkHyapFf68BwFr$ 
> ---
>  drivers/target/iscsi/iscsi_target.c    |  2 +-
>  drivers/target/target_core_tmr.c       |  9 --------
>  drivers/target/target_core_transport.c | 29 +++++++++++++++++++-------
>  3 files changed, 23 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index d0e7ed8f28cc..3311b031a812 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -2142,7 +2142,7 @@ iscsit_handle_task_mgt_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
>  	 * TMR TASK_REASSIGN.
>  	 */
>  	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
> -	target_put_sess_cmd(&cmd->se_cmd);
> +	transport_generic_free_cmd(&cmd->se_cmd, false);
>  	return 0;
>  }

Doh. I see how I got all confused. I guess this path leaks the lun_ref
taken by transport_lookup_tmr_lun. It looks like an old issue and nothing
to do with your patch.

I'm not sure if we are supposed to be calling transport_generic_free_cmd
twice. It looks like it works ok, because your patch added the "cmd->se_lun = NULL"
in transport_lun_remove_cmd, so we won't do a double list deletion.
It feels dirty though. I can feel Bart saying, "Mike did you see the comment
at the top of the function". :)

Maybe it's best to more cleanly unwind what was setup in the rror path. I think we
can fix lun_ref leak too.

So instead of doing transport_generic_free_cmd above do transport_lun_remove_cmd
to match/undo the transport_lookup_tmr_lun call in iscsit_handle_task_mgt_cmd?
