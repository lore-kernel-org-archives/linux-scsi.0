Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD75C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Mar 2022 16:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238496AbiCRQrS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Mar 2022 12:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbiCRQrR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2022 12:47:17 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4ADC29C947
        for <linux-scsi@vger.kernel.org>; Fri, 18 Mar 2022 09:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1647621956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KASHpunu/a2K5Et2xZbHMBPAADhRl9ph2lQrIn4EM7w=;
        b=Vx5rmq+Fb0fJJ0psKLjh02/mVgzhLDOBC0nR52HfFgwYFIPmlOzMnX33s8UhOIdZRk2yp9
        XPNflpZyUzWsNU7WcnKXS147aZIMUvYu1OlS24vGt5g9kAv/QXGLNUyF9udBGyxqvZkTB6
        MEE5D5asusLCV1D++mcj7hm6s0G139s=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2058.outbound.protection.outlook.com [104.47.14.58]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-36-sToDVSuqPmKExfupwNlg8A-1; Fri, 18 Mar 2022 17:45:54 +0100
X-MC-Unique: sToDVSuqPmKExfupwNlg8A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A8D+K+vE3Sf4AjmiS6hxZm/pgA9eDMrYO1wCLnUVME3GUaC0z5D8N6H4orVgMJazUaQMQ8WhELBbSp3XDSsMwwNR8N2MsDGbWw9QLH83sGzeDRaW8PuHar1SAbV/0P6FeA0Zg46j90imLxYHbpAH1ctt09zHMngbjPFvp0c4pLoxNnZYleR8hQul6zjw14zLH/F5aa5t7T6lWMvpU43JDOlgnjQo7hQByYS6vQmstJv127NcK+LjRhNvKflOtFPbWTVgURCCuJm8yiUqgWOJcuhNNMKDyk+oK8JRngkXMXp0KPxiyqpR5Zeb6A81hPot5tV6lKUJJMKaDPlyaaK6Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KASHpunu/a2K5Et2xZbHMBPAADhRl9ph2lQrIn4EM7w=;
 b=l4CofjSz9mokyrfg+MmpTuwYQM1NJIXv0h4HwmcEHTBui/KieWQk+5sryUhljL3DLsd/XRI96xmuPYYtQjIxy3P7jkbW2xXuTzxsPiRmxNNyti7rwb/265qV4KOV/kQrxbyveRg47xxXzL1i5FYdmU5IjoKtlHXRxOFaKiPantLP+HCx/dmslph/8egVtAqVp5r6vWFIFTTzOvaJhyRBk5sF1i12bE7iuSa7vl2Yg3/VSr96BnvVIfNiH1/TVDIjJf7Fc40Pmw4P/55AY57QrBnx5b2mmn6G4Ek8CfGriXoE9hUR3tx5mpBXc7IG8zss0X0yuPnHBFry7Qe8/6bi+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by PAXPR04MB8426.eurprd04.prod.outlook.com (2603:10a6:102:1ca::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.18; Fri, 18 Mar
 2022 16:45:53 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::14d7:55aa:6af:72d7]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::14d7:55aa:6af:72d7%6]) with mapi id 15.20.5081.017; Fri, 18 Mar 2022
 16:45:53 +0000
Message-ID: <b10127f9-9818-e595-5e12-1052e9478978@suse.com>
Date:   Fri, 18 Mar 2022 09:45:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 05/12] scsi: iscsi: Run recv path from workqueue
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220308002747.122682-1-michael.christie@oracle.com>
 <20220308002747.122682-6-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220308002747.122682-6-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0061.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::9) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe795224-df0f-4cd1-697c-08da08fec3f4
X-MS-TrafficTypeDiagnostic: PAXPR04MB8426:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB8426858577A06BF53562104EDA139@PAXPR04MB8426.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T1oqxeo/HKakfWifn3jfcGlw2ybAGBUva2hkaImNbhaifW2ZTPuY2ZFIVHioF0LnvBCPL7uz+HjvbTTneYhsjd6HNsc7xUwSa7mCqY0AsCrYONige0HZEQih182uqS/8Dk/nAt8rMhvXC5LfnymzdbKpO8yMUBC2yQxfNZs/r2cBHnM2o5d/BrS3ZNOlzyOYGcTNRHxbJeO/iVO+tV8kEoNT+Vp3pcOExBdtIxoyWuaiJl9KvD0YvixNoZQ6qmL2OouUrE5GNlwCo2qYUmiAbLhUBr84RETewSPhlcKFUnLcCVlAHaxZX7gLJdveLLyhbQ/OiQQm8tH6CjrfyvlHcntfvGpf2iMNXrUWmtKkgttR4MUKy+GYPM1V7qf/wzUmoyF0KpwC9DmEKSOEAfMXBKDOtKM6uWGlcOWh89Tc1pkSmzDY0w8Sc2Rio9qLuyQ92iOKPNIueHsBdDqplLQw1hHsQ7J8rnZHzfe7UwL3STQwRu2m61hOKiiOsCFzoyeOLb+etKoB9H9Dgub8x8WCNcDOJLW72WyfizWS+TPvsSXyKSwbVZklRR6S6YQyWe2qySj1jnCPkJ6mmhQdj/yfA25qZcupqBAgvPKhQM1xZuKmTRqkizxKN0YuscPBKUW7WeRlXGoVHuoK3VEjQH71viLHYpoMzmiU8AE5BtcFnizf+VEqwztaLjnfBto+DdEeRnlQTtaKlALaK4SKL98P8dqalu/GD8n+Qtu5SiKw8hg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(26005)(186003)(2616005)(31686004)(38100700002)(53546011)(6666004)(6506007)(6512007)(5660300002)(2906002)(508600001)(86362001)(8676002)(36756003)(316002)(31696002)(66476007)(66556008)(6486002)(66946007)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RURzbTRKNWZsWUJpZ3Z1YVhDSHppRFZld3hjYzNjRFlTTHordGM2RS9PVEl4?=
 =?utf-8?B?d1RzenI4K2JPNGJIM3ZuNy8zd0NnU1JhVGtRRjMrQVBOOWd5ZzZNRWUyRXlz?=
 =?utf-8?B?Q25pZlk4bWY3R3pqU0wwb2k4c0duQUpjTTEwdndpWUNORVE2Y1VESEpsZGlM?=
 =?utf-8?B?YXFFQ2NpMTdqQnhrWDZQWllqU0NqbGNVaENqbmM2R09EMmJYN3A1MG9NRDQ1?=
 =?utf-8?B?bkhFMUp2RnhIdTI3Wk5VNDJBUGdyRyt0b05zNXptOExzZWJJaHRyekVQM2hu?=
 =?utf-8?B?WXpqU1JBSTZMdm52QURSQnRkd1prMk1kcTZpSFE3UEQxNnpta1h6M1lzQThh?=
 =?utf-8?B?SDQ2UDBrK3NZZUZibmticWpHeEkwenNCL1ZOUlpuK1pORUdRSy9RSmhZMEJ4?=
 =?utf-8?B?Y293MjZrOUZSaDV0OUV0RHMveUN6eEF4NFpObWtoN29KMTI1VW4wUStZVjlM?=
 =?utf-8?B?dGRyWEgxVHFrN3pNaWJJK2toNEtmczlmSWQvNzJzQjFOVHBwdk5wK2l0amth?=
 =?utf-8?B?VENhMFRVL1haMGJiZ015KzdSLzhNeEhjejFsNjRvcFFKbmlwbG9yZWVRUWta?=
 =?utf-8?B?amVNZ2Vrd0orVCtJYzFUeVdRTTEyMlRVeThSb3VoVzBBMCtKY25UYWlyLzlV?=
 =?utf-8?B?SGtSZi9zcTk0L2VCM2tzTkV0Zjh3RnhnQUdtR3RyV2dYZ0F5bkdSWEJib2Y1?=
 =?utf-8?B?dEl6SlAraGNYbG13aEVoZDM4ZEZSSU1SZXdRd05YUmFld3J4aHptb1dpaVAx?=
 =?utf-8?B?RVdnYzhrSm9TdUlEN2ZMSGI2TGw4a1IydzYxUUJIUmlRd2JJeVpSUHNsMmtT?=
 =?utf-8?B?eDlKSktWUWhuTEF1TEtMYmxBTG5jeXdwYzdSeDROMWFyTXZuVnRTSUNPWlhZ?=
 =?utf-8?B?SWp4VG9vTXU2K29iWU5oU1lacUNOMExhWm1DZzlyWURNRWh0OWNmMnl5dWNn?=
 =?utf-8?B?TGMrNDNGeDc4K0dKWUFPV1JTMTJYTS95aFN1Y09iSldPSmJhVTVLcENvRnE2?=
 =?utf-8?B?STZhU1hSY1ZHVDA2S2FLUHlURVg3VjFjY0dLZ210SE4zSEU5VUZDRWUyOU9t?=
 =?utf-8?B?ejZEUURxeDZxbTNYWXREMWtXV3ZObUkvWVljMjlPcXVDeUN5bnRNMG1mMGo3?=
 =?utf-8?B?S3RyL2RMeGV4ZjBnQTZJMlV4VTQzdW0yNVp0SjBEdUsrWk5UYTdkcmdXQ0pO?=
 =?utf-8?B?VjlMOWs0OW9nTjF0WVF4N2ZjV0x4dGlFTE54SDgyTjBQN0ZFZkxIUTZWa1Bp?=
 =?utf-8?B?TmtUSlVsSFRYWFNUN1kyVzVCeDFLS1UvejFwbUwzQjMrbC9yaFI5bXR0SU1K?=
 =?utf-8?B?bVlhWkE1SW5UeERVeGJaRXhMb0JqMFBjV2pxNXplV0JoY1JSUHJJRGVGcldH?=
 =?utf-8?B?TVBlYUMrTFNrUUdYbERKeEFTdWlrZ0JITzE1bzBZSytuYUorN0VJc0NodXBX?=
 =?utf-8?B?blZ1Z0xSQ1c0djNtQlB2SzlrVnNsMXZjajF0Z28rVXdndTJmL0lFMVR6OGI4?=
 =?utf-8?B?K1FRVVhMWFRLd2Y1MDhYSUUvM1BLeVlHK2dWL09NWURKRitucGp2T2lFN3ky?=
 =?utf-8?B?WWs1R2ExUFoyZFpOM1BGaE10NXFreE14V0tHNTROcEJBbkJHNGlLZ0c0aVlk?=
 =?utf-8?B?UXQrZ3ZiUUViemFJQ2RJUU5MZTY5dk1SUEhhTFhNWkxsZTQxUGZjbjBSR0NJ?=
 =?utf-8?B?ekJYelM0SmRRam5SM1hvL0E4R3NmN2lMM0s4L3ZwTzJhNTI4VDluMVhhTXQ3?=
 =?utf-8?B?ZWdDc0pGTFlUVzJIT0t0Sld1bmhWSnl2cFhQa2x0N0Q4dVEweVRmTWpkb094?=
 =?utf-8?B?QWNWZzNodjMyNXV5WHlxVm1ncklWelR4ZTMxLzhkNXM0N0x5TDhEb2R1Y2xm?=
 =?utf-8?B?YzFRKzZ1UXE5blg5UDhHR1ozeG9CZHNyeGNpVjJ3TWRlMnhMa3pTTjY5OGU1?=
 =?utf-8?Q?Gg25K6VQ9AcwttrrRH53rbJ7WAeukZK9?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe795224-df0f-4cd1-697c-08da08fec3f4
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 16:45:53.0511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o8bmrrpDR6may3rQNtCitiE+OOVEZBvXk91cjvIGcLmq+UijOuutHPBMyCtkZd1GsRRBcTkDmefv+H2EM41odA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8426
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 16:27, Mike Christie wrote:
> We don't always want to run the recv path from the network softirq
> because when we have to have multiple sessions sharing the same CPUs some
> sessions can eat up the napi softirq budget and affect other sessions or
> users. This patch allows us to queue the recv handling to the iscsi
> workqueue so we can have the scheduler/wq code try to balance the work and
> CPU use across all sessions's  worker threads.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/iscsi_tcp.c | 62 +++++++++++++++++++++++++++++++---------
>   drivers/scsi/iscsi_tcp.h |  2 ++
>   2 files changed, 51 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index f274a86d2ec0..261599938fc9 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -52,6 +52,10 @@ static struct iscsi_transport iscsi_sw_tcp_transport;
>   static unsigned int iscsi_max_lun = ~0;
>   module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
>   
> +static bool iscsi_use_recv_wq;
> +module_param_named(use_recv_wq, iscsi_use_recv_wq, bool, 0644);
> +MODULE_PARM_DESC(use_recv_wq, "Set to true to read iSCSI data/headers from the iscsi_q workqueue. The default is false which will perform reads from the network softirq context.");

I'm just curious why you chose to make this a module parameter, leaving 
the current default.

> +
>   static int iscsi_sw_tcp_dbg;
>   module_param_named(debug_iscsi_tcp, iscsi_sw_tcp_dbg, int,
>   		   S_IRUGO | S_IWUSR);
> @@ -122,20 +126,13 @@ static inline int iscsi_sw_sk_state_check(struct sock *sk)
>   	return 0;
>   }
>   
> -static void iscsi_sw_tcp_data_ready(struct sock *sk)
> +static void iscsi_sw_tcp_recv_data(struct iscsi_conn *conn)
>   {
> -	struct iscsi_conn *conn;
> -	struct iscsi_tcp_conn *tcp_conn;
> +	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
> +	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
> +	struct sock *sk = tcp_sw_conn->sock->sk;
>   	read_descriptor_t rd_desc;
>   
> -	read_lock_bh(&sk->sk_callback_lock);
> -	conn = sk->sk_user_data;
> -	if (!conn) {
> -		read_unlock_bh(&sk->sk_callback_lock);
> -		return;
> -	}
> -	tcp_conn = conn->dd_data;
> -
>   	/*
>   	 * Use rd_desc to pass 'conn' to iscsi_tcp_recv.
>   	 * We set count to 1 because we want the network layer to
> @@ -144,13 +141,48 @@ static void iscsi_sw_tcp_data_ready(struct sock *sk)
>   	 */
>   	rd_desc.arg.data = conn;
>   	rd_desc.count = 1;
> -	tcp_read_sock(sk, &rd_desc, iscsi_sw_tcp_recv);
>   
> -	iscsi_sw_sk_state_check(sk);
> +	tcp_read_sock(sk, &rd_desc, iscsi_sw_tcp_recv);
>   
>   	/* If we had to (atomically) map a highmem page,
>   	 * unmap it now. */
>   	iscsi_tcp_segment_unmap(&tcp_conn->in.segment);
> +
> +	iscsi_sw_sk_state_check(sk);
> +}
> +
> +static void iscsi_sw_tcp_recv_data_work(struct work_struct *work)
> +{
> +	struct iscsi_conn *conn = container_of(work, struct iscsi_conn,
> +					       recvwork);
> +	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
> +	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
> +	struct sock *sk = tcp_sw_conn->sock->sk;
> +
> +	lock_sock(sk);
> +	iscsi_sw_tcp_recv_data(conn);
> +	release_sock(sk);
> +}
> +
> +static void iscsi_sw_tcp_data_ready(struct sock *sk)
> +{
> +	struct iscsi_sw_tcp_conn *tcp_sw_conn;
> +	struct iscsi_tcp_conn *tcp_conn;
> +	struct iscsi_conn *conn;
> +
> +	read_lock_bh(&sk->sk_callback_lock);
> +	conn = sk->sk_user_data;
> +	if (!conn) {
> +		read_unlock_bh(&sk->sk_callback_lock);
> +		return;
> +	}
> +	tcp_conn = conn->dd_data;
> +	tcp_sw_conn = tcp_conn->dd_data;
> +
> +	if (tcp_sw_conn->queue_recv)
> +		iscsi_conn_queue_recv(conn);
> +	else
> +		iscsi_sw_tcp_recv_data(conn);
>   	read_unlock_bh(&sk->sk_callback_lock);
>   }
>   
> @@ -557,6 +589,8 @@ iscsi_sw_tcp_conn_create(struct iscsi_cls_session *cls_session,
>   	conn = cls_conn->dd_data;
>   	tcp_conn = conn->dd_data;
>   	tcp_sw_conn = tcp_conn->dd_data;
> +	INIT_WORK(&conn->recvwork, iscsi_sw_tcp_recv_data_work);
> +	tcp_sw_conn->queue_recv = iscsi_use_recv_wq;
>   
>   	tfm = crypto_alloc_ahash("crc32c", 0, CRYPTO_ALG_ASYNC);
>   	if (IS_ERR(tfm))
> @@ -606,6 +640,8 @@ static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
>   	 */
>   	kernel_sock_shutdown(sock, SHUT_RDWR);
>   
> +	iscsi_suspend_rx(conn);
> +
>   	sock_hold(sock->sk);
>   	iscsi_sw_tcp_conn_restore_callbacks(conn);
>   	sock_put(sock->sk);
> diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
> index 791453195099..850a018aefb9 100644
> --- a/drivers/scsi/iscsi_tcp.h
> +++ b/drivers/scsi/iscsi_tcp.h
> @@ -28,6 +28,8 @@ struct iscsi_sw_tcp_send {
>   
>   struct iscsi_sw_tcp_conn {
>   	struct socket		*sock;
> +	struct work_struct	recvwork;
> +	bool			queue_recv;
>   
>   	struct iscsi_sw_tcp_send out;
>   	/* old values for socket callbacks */

Other than my question above, I'm fine with this.

Reviewed-by: Lee Duncan <lduncan@suse.com>

