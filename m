Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C104DC433ED
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 22:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91349613BF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 22:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhEEW56 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 May 2021 18:57:58 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:26313 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229893AbhEEW56 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 May 2021 18:57:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620255420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8dJdg6Q3eplx9Sn9VofUsL+yQB4vRYESXTt7yPzwkE4=;
        b=koezviL8a+WWpxWFoaIWAqD2PTh4Nno78h33zWxNRrSC9bpdC7HufzaLXBJOfPhD3u8Ao3
        Ykid7hs/zV6L0cgiUbg3NKRK/8bA0ejG0VtdfkN8z+AD8HJ6kqdtmIb2Th0ntjge2aasdr
        xAioNsD2VI9RhO2E6gnHk7WSEyJINaQ=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2169.outbound.protection.outlook.com [104.47.17.169])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-39-oZa67KZSMW-m0JXNlRM6-g-1; Thu, 06 May 2021 00:56:58 +0200
X-MC-Unique: oZa67KZSMW-m0JXNlRM6-g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iCagx9wtQT/25Oxy0yYZS/2caoj2ZyGFIykpTHNAOf6g+BBqgouua79WE+XW2XDygwPViYLdqWQRIpVnZOi2FwUc+JcFzehHBUTShbOPXlnua2ad7mXnGVwgoBie2RoLwgKPDtnlyGHsa4qJ6dvX1wwaMwyemakLqB8Oui4dkCHuY19uEU7qmkJx/V4yXYwonYiQ3C9GB8kVhfutHIeCOPwYI2rN8sHQK6wCDf/pfl/YH6fzZTsruLKDCsKr4fJwljWHItO9DMNGQ3IibvEqJCsuv6mydUJCXpCJvQOqqoEmpaVDcDTyZae2F0NBoz2lkw7BzstUs1C2oQrUSmqp4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8dJdg6Q3eplx9Sn9VofUsL+yQB4vRYESXTt7yPzwkE4=;
 b=bJPrImqTk5VxVEi26HITPnPpAytHvGmP0WX2XeoaT9EsucpIWwzkbNqBdwox/QsuwAcZFaYRXiN4NdSWD2m33721zXhUgVfS29UhcpjJup6ZbizcX1hN0wKFhUIui8XkyzaWr5d9XkJgVSNq4KZQazWDBg3I1G0M+lETXLF1FthuqSXqwKPXBmjbVQAn9OEFXvwfy3FKwr5dqEmHA3B86NgJ+Q2qT1w+EJv0RhMSeId51kDdVQr2BJpts9VHBYwThxCWDUCMWGVfZbbOjhn+a2k994CfcNpRUdVdfDSPara5+lNPy2wla2H9h2zQLhZnI6YDLcMqz6XYTog3kW4Qdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB6246.eurprd04.prod.outlook.com (2603:10a6:20b:bc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.43; Wed, 5 May
 2021 22:56:56 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.3999.038; Wed, 5 May 2021
 22:56:56 +0000
Subject: Re: [PATCH v3 4/6] scsi: iscsi: fix in-kernel conn failure handling
To:     Mike Christie <michael.christie@oracle.com>, khazhy@google.com,
        martin.petersen@oracle.com, rbharath@google.com,
        krisman@collabora.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20210424221755.124438-1-michael.christie@oracle.com>
 <20210424221755.124438-5-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <5892b3b3-f8f0-76c1-08a3-98ab247b3546@suse.com>
Date:   Wed, 5 May 2021 15:56:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210424221755.124438-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM3PR03CA0060.eurprd03.prod.outlook.com
 (2603:10a6:207:5::18) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM3PR03CA0060.eurprd03.prod.outlook.com (2603:10a6:207:5::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Wed, 5 May 2021 22:56:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98fe1bb3-82dc-4a0f-395b-08d910191520
X-MS-TrafficTypeDiagnostic: AM6PR04MB6246:
X-Microsoft-Antispam-PRVS: <AM6PR04MB62465CAC745EB8E1A9F6EE21DA599@AM6PR04MB6246.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l8hESKl2ov3Z004LoMBqw/kBl7lastChn5P1bD78rZY5Gy3SfA9aYmBSaLQiib8BIQVKYTbqJPtI58dZmWBPep5tpbo3l/dBFTDN/wIXcQnj2BiegQedsusQ09F4SasTBYLslN4PKWcbQVKauwJgr4H4PDkT2tIp3XRHPVMuOKgGcXZKp3Furd2vGyBoFUhYLjB2JXKNPtYhTw9w9KHJDBH92LIpG9JYy/5ehwqQryvs3EGkSGzU39d9Fjf46NRuhGolm1Hpjl4YnKkSTjWyzibqfBRH4qXW8KOttyX0rOq1M3qDC/eOgkdJ/aQ5dbl8f6qdlt1z/Y3c6dOkHpNI5pdpn8txW/ZkJPowxYuv05i90sytcwDa78zfiHMDVpLMIWsWhx536odk0f3/UV5V+UXhF+2o9VlUxRF+tnawFhkbP+xOaMNQ0D7iVjztsFNHLjQbSY2pkiIdUlM59PyJRT6Lv4x90XiizZ6aNdqx1Pp2kcsGuwhAvRnGh/85V39LvRc3YiUxzJVdwvI63OwG+B1OLKXzncyjEKNLkh3T8lL10Q1h6ZbDqE6XxMwsex2CVTRSmTomY+VNT5On5+vnKQKJb3YvnzKGE1meBnA/gGMLys+WmaRPlogF2PO/3t7x7sXrfeemzb8TslRjJwT1XnnyKQFylYJ1Qu3e/6cYl8Q4tC50uKioOc20R9XHRJ96ZwLszL8GFnLX7dFiLcudZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(39850400004)(376002)(366004)(6666004)(36756003)(186003)(66556008)(30864003)(16526019)(2616005)(2906002)(31686004)(316002)(66476007)(8936002)(83380400001)(31696002)(6486002)(16576012)(8676002)(38100700002)(478600001)(53546011)(5660300002)(38350700002)(86362001)(66946007)(26005)(956004)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MGRITms4QklmYlhodmtvTnpseFhZdXhoaDEyMkkrY2VzY1NxQlZsbkRWWk56?=
 =?utf-8?B?TWwzVFlzU0FkaTBDZk9lQ21VYkh0ODVJeFJWZ0d6UzZkeUdEcUEzZWNXbEQ4?=
 =?utf-8?B?cmFNdE9HeVhCZ2kwVkkxaWxTUVRVbi9aM1Y1ZWZ3Wk53NE1qMC9uellQWlJl?=
 =?utf-8?B?YTVMUUNsK3lDNktQbE1uUHNBcjNSME53SVZINkxQNzB5SzZ0emNaWXJRemRC?=
 =?utf-8?B?NFdnOHAyTEQ4M3R1MjNKNmtrYWdQcE5KclBOVzR0eFpGMzJZQWZQN1U4L29R?=
 =?utf-8?B?Q05xTUtucVhxbC85M1Y4M2RUVFh3em5GamVIdk1LdTJEVDdEQmo4Ynh5N1hX?=
 =?utf-8?B?WWsvS1NpM3I2cGZjWVpWNVNlOUV4UjlPbXZPVzVPUFRUeTExTnk1d2hoU1FM?=
 =?utf-8?B?dnVlUXgxN0xROTVKTG54byt5d0x0M1RIRUF1a0lVUEhRR3pZa2k0aUkveXdW?=
 =?utf-8?B?cko1b3VJR0RPU0tSaU96TVlPUTVqT1RtaWxFdkY1L0U3VWR0MmxNMHZydmc0?=
 =?utf-8?B?dlFENmlzL1BrMk9wL1ZQeGxkNndUNWtpVENHQ2RMRTlIRGEydFZvdmxLcFV6?=
 =?utf-8?B?MlkrMVpGc2E2U291OURKVmZHYXNDWU1YVTFzdnZUdkliY0FOK0ZoYnNaUVdE?=
 =?utf-8?B?QmhJWjhLNXdocm5QN1JWc0dSL2dZdnRIQlpGNS9jb3VhSHRMK0RNS2xJUzNO?=
 =?utf-8?B?YkhTVm1CVVJNTHlzcUZzUWxPWkFUdTNzRzFOanprRWdoTHNZaXp6RG9xRlYv?=
 =?utf-8?B?THFmVEZsVkFuLzdtbjJGOWxyY1BJWGpuQjJXZEVFWnBmUldNZWNnR2M4bEtz?=
 =?utf-8?B?RlhDQWF6Q2lmZXBvbHIxV0dCbjc4bHBoV1R2R3JjdTl4UTJBamM3ckRhcG12?=
 =?utf-8?B?T2JyU3JPajJLbVNnQmVyWDFRQzA3Ni8vUmZnZi9UVUl6QWJMSzYwKytrYU9n?=
 =?utf-8?B?Y0ZudWNVeWdqbHFlQjVlRXBkcW5ocHVwZW9RNVRJQkRuMlQweHhBOE9ieHo1?=
 =?utf-8?B?aTdZRlNScDBHRXZGVUpyc2dHeU5YTjdtNXg0dEFubkdaYm5wOHE0QXhBcHEw?=
 =?utf-8?B?OWJXclB3RFBlMGowZDQxcjZXMWVqQkswZy80V1ZWSk54OVNxbE5jOXhmbXYx?=
 =?utf-8?B?MFpreEU0REx4OTBLM3dEYVRTWjJqQlYrVnVQUHpsL2UrOTZ3QU1YZ04wL1pz?=
 =?utf-8?B?YnJWRXZyZHR1ancxTkpoU0RUL2REN2F5ald2TzBpVytBTHAxQzU2cmFMZ000?=
 =?utf-8?B?bDFxL1FsZERCWkUyK2ZydDBnTnQ1YzBRZXRiUVMzdVl4bVpIMGJ3ZXhsbytR?=
 =?utf-8?B?dTVwUkZMYXE1elBCRG9KRVVwVTk3NTZCdGYzaTd3VC9NWVRNQm9JaFd3SjNJ?=
 =?utf-8?B?dXZmN1lCeDJqNTU5L00waWtHTng5V1pzSUg1NVhBejNsdkxQRmZqT21KMXR5?=
 =?utf-8?B?TDlKRlBTOGI4dnNLQlRuc3k0RXBqWW1KZklJTi8zWGJFQjhVNkdKTkZmMHFo?=
 =?utf-8?B?WXh5V2h0OUFqMW9kTUZPaDJkZHJJWDdrWWFmdTdtNUMvL1Q1bGRNNU1CMjdU?=
 =?utf-8?B?clJINFI3NG54dVN1d3d4NXU3MmhvSXA1S2IyMVgrNUxNeGQyTVl4L1BZY1Z2?=
 =?utf-8?B?NnhoS1NoZGFhYStzeXVVbTIzaHZsMy9XTlIzUTZMelVONjZZclV2TTJuY1kr?=
 =?utf-8?B?SjBOeGFraUZqMTRHNjd6a1ZzVFNuMU5ydmVTUmR5aWtZcDB2NmlOTTBSMVJx?=
 =?utf-8?Q?WrPc1fO3BocGzii6DG9ZyIcoxrz7nIcIfDmlLlf?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98fe1bb3-82dc-4a0f-395b-08d910191520
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 22:56:56.7274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2us2yyqjUcVeDVkKt1e+8JdS23BpAwF310EYWdsUqMkrnIgp401bobdNY6IYCSm8HmwLAege7EaSRKV2pKm2Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6246
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/24/21 3:17 PM, Mike Christie wrote:
> The commit 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely
> in kernel space") has the following regressions/bugs that this patch fixes:
> 
> 1. It can return cmds to upper layers like dm-multipath where that can
> retry them. After they are successful the fs/app can send new IO to the
> same sectors, but we've left the cmds running in FW or in the net layer.
> We need to be calling ep_disconnect if userspace is not up.
> 
> This patch only fixes the issue for offload drivers. iscsi_tcp will be
> fixed in separate patch because it doesn't have a ep_disconnect call.
> 
> 2. The drivers that implement ep_disconnect expect that it's called
> before conn_stop. Besides crashes, if the cleanup_task callout is called
> before ep_disconnect it might free up driver/card resources for session1
> then they could be allocated for session2. But because the driver's
> ep_disconnect is not called it has not cleaned up the firmware so the
> card is still using the resources for the original cmd.
> 
> 3. The stop_conn_work_fn can run after userspace has done it's
> recovery and we are happily using the session. We will then end up
> with various bugs depending on what is going on at the time.
> 
> We may also run stop_conn_work_fn late after userspace has called
> stop_conn and ep_disconnect and is now going to call start/bind
> conn. If stop_conn_work_fn runs after bind but before start,
> we would leave the conn in a unbound but sort of started state where
> IO might be allowed even though the drivers have been set in a state
> where they no longer expect IO.
> 
> 4. returning -EAGAIN in iscsi_if_destroy_conn if we haven't yet run
> the in kernel stop_conn function is breaking userspace. We should have
> been doing this for the caller.
> 
> Fixes: 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in kernel space")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 453 ++++++++++++++++------------
>  include/scsi/scsi_transport_iscsi.h |  10 +-
>  2 files changed, 271 insertions(+), 192 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index a61a4f0fa83a..1453b033b5d8 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -86,15 +86,11 @@ struct iscsi_internal {
>  	struct transport_container session_cont;
>  };
>  
> -/* Worker to perform connection failure on unresponsive connections
> - * completely in kernel space.
> - */
> -static void stop_conn_work_fn(struct work_struct *work);
> -static DECLARE_WORK(stop_conn_work, stop_conn_work_fn);
> -
>  static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
>  static struct workqueue_struct *iscsi_eh_timer_workq;
>  
> +static struct workqueue_struct *iscsi_conn_cleanup_workq;
> +
>  static DEFINE_IDA(iscsi_sess_ida);
>  /*
>   * list of registered transports and lock that must
> @@ -1623,12 +1619,6 @@ static DECLARE_TRANSPORT_CLASS(iscsi_connection_class,
>  static struct sock *nls;
>  static DEFINE_MUTEX(rx_queue_mutex);
>  
> -/*
> - * conn_mutex protects the {start,bind,stop,destroy}_conn from racing
> - * against the kernel stop_connection recovery mechanism
> - */
> -static DEFINE_MUTEX(conn_mutex);
> -
>  static LIST_HEAD(sesslist);
>  static DEFINE_SPINLOCK(sesslock);
>  static LIST_HEAD(connlist);
> @@ -2245,6 +2235,106 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
>  }
>  EXPORT_SYMBOL_GPL(iscsi_remove_session);
>  
> +static void iscsi_stop_conn(struct iscsi_cls_conn *conn, int flag)
> +{
> +	ISCSI_DBG_TRANS_CONN(conn, "Stopping conn.\n");
> +
> +	switch (flag) {
> +	case STOP_CONN_RECOVER:
> +		conn->state = ISCSI_CONN_FAILED;
> +		break;
> +	case STOP_CONN_TERM:
> +		conn->state = ISCSI_CONN_DOWN;
> +		break;
> +	default:
> +		iscsi_cls_conn_printk(KERN_ERR, conn, "invalid stop flag %d\n",
> +				      flag);
> +		return;
> +	}
> +
> +	conn->transport->stop_conn(conn, flag);
> +	ISCSI_DBG_TRANS_CONN(conn, "Stopping conn done.\n");
> +}
> +
> +static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
> +{
> +	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop.\n");
> +	/*
> +	 * If this is a termination we have to call stop_conn with that flag
> +	 * so the correct states get set. If we haven't run the work yet try to
> +	 * avoid the extra run.
> +	 */
> +	if (flag == STOP_CONN_TERM) {
> +		cancel_work_sync(&conn->cleanup_work);
> +		iscsi_stop_conn(conn, flag);
> +	} else {
> +		/*
> +		 * Figure out if it was the kernel or userspace initiating this.
> +		 */
> +		if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
> +			iscsi_stop_conn(conn, flag);
> +		} else {
> +			ISCSI_DBG_TRANS_CONN(conn,
> +					     "flush kernel conn cleanup.\n");
> +			flush_work(&conn->cleanup_work);
> +		}
> +		/*
> +		 * Only clear for recovery to avoid extra cleanup runs during
> +		 * termination.
> +		 */
> +		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
> +	}
> +	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop done.\n");
> +}
> +
> +static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
> +{
> +	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
> +	struct iscsi_endpoint *ep = conn->ep;

You set ep here, but then you set it again later? Seems redundant.

> +
> +	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
> +	conn->state = ISCSI_CONN_FAILED;
> +	/*
> +	 * We may not be bound because:
> +	 * 1. Some drivers just loop over all sessions/conns and call
> +	 * iscsi_conn_error_event when they get a link down event.
> +	 *
> +	 * 2. iscsi_tcp does not uses eps and binds/unbinds in stop/bind_conn,
> +	 * and for old tools in destroy_conn.
> +	 */
> +	if (!conn->ep || !session->transport->ep_disconnect)
> +		return;
> +
> +	ep = conn->ep;
> +	conn->ep = NULL;
> +
> +	session->transport->unbind_conn(conn, is_active);
> +	session->transport->ep_disconnect(ep);
> +	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
> +}
> +
> +static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
> +{
> +	struct iscsi_cls_conn *conn = container_of(work, struct iscsi_cls_conn,
> +						   cleanup_work);
> +	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
> +
> +	mutex_lock(&conn->ep_mutex);
> +	iscsi_ep_disconnect(conn, false);
> +
> +	if (system_state != SYSTEM_RUNNING) {
> +		/*
> +		 * userspace is not going to be able to reconnect so force
> +		 * recovery to fail immediately
> +		 */
> +		session->recovery_tmo = 0;
> +	}
> +
> +	iscsi_stop_conn(conn, STOP_CONN_RECOVER);
> +	mutex_unlock(&conn->ep_mutex);
> +	ISCSI_DBG_TRANS_CONN(conn, "cleanup done.\n");
> +}
> +
>  void iscsi_free_session(struct iscsi_cls_session *session)
>  {
>  	ISCSI_DBG_TRANS_SESSION(session, "Freeing session\n");
> @@ -2284,7 +2374,7 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
>  
>  	mutex_init(&conn->ep_mutex);
>  	INIT_LIST_HEAD(&conn->conn_list);
> -	INIT_LIST_HEAD(&conn->conn_list_err);
> +	INIT_WORK(&conn->cleanup_work, iscsi_cleanup_conn_work_fn);
>  	conn->transport = transport;
>  	conn->cid = cid;
>  	conn->state = ISCSI_CONN_DOWN;
> @@ -2341,7 +2431,6 @@ int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
>  
>  	spin_lock_irqsave(&connlock, flags);
>  	list_del(&conn->conn_list);
> -	list_del(&conn->conn_list_err);
>  	spin_unlock_irqrestore(&connlock, flags);
>  
>  	transport_unregister_device(&conn->dev);
> @@ -2456,77 +2545,6 @@ int iscsi_offload_mesg(struct Scsi_Host *shost,
>  }
>  EXPORT_SYMBOL_GPL(iscsi_offload_mesg);
>  
> -/*
> - * This can be called without the rx_queue_mutex, if invoked by the kernel
> - * stop work. But, in that case, it is guaranteed not to race with
> - * iscsi_destroy by conn_mutex.
> - */
> -static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
> -{
> -	/*
> -	 * It is important that this path doesn't rely on
> -	 * rx_queue_mutex, otherwise, a thread doing allocation on a
> -	 * start_session/start_connection could sleep waiting on a
> -	 * writeback to a failed iscsi device, that cannot be recovered
> -	 * because the lock is held.  If we don't hold it here, the
> -	 * kernel stop_conn_work_fn has a chance to stop the broken
> -	 * session and resolve the allocation.
> -	 *
> -	 * Still, the user invoked .stop_conn() needs to be serialized
> -	 * with stop_conn_work_fn by a private mutex.  Not pretty, but
> -	 * it works.
> -	 */
> -	mutex_lock(&conn_mutex);
> -	switch (flag) {
> -	case STOP_CONN_RECOVER:
> -		conn->state = ISCSI_CONN_FAILED;
> -		break;
> -	case STOP_CONN_TERM:
> -		conn->state = ISCSI_CONN_DOWN;
> -		break;
> -	default:
> -		iscsi_cls_conn_printk(KERN_ERR, conn,
> -				      "invalid stop flag %d\n", flag);
> -		goto unlock;
> -	}
> -
> -	conn->transport->stop_conn(conn, flag);
> -unlock:
> -	mutex_unlock(&conn_mutex);
> -}
> -
> -static void stop_conn_work_fn(struct work_struct *work)
> -{
> -	struct iscsi_cls_conn *conn, *tmp;
> -	unsigned long flags;
> -	LIST_HEAD(recovery_list);
> -
> -	spin_lock_irqsave(&connlock, flags);
> -	if (list_empty(&connlist_err)) {
> -		spin_unlock_irqrestore(&connlock, flags);
> -		return;
> -	}
> -	list_splice_init(&connlist_err, &recovery_list);
> -	spin_unlock_irqrestore(&connlock, flags);
> -
> -	list_for_each_entry_safe(conn, tmp, &recovery_list, conn_list_err) {
> -		uint32_t sid = iscsi_conn_get_sid(conn);
> -		struct iscsi_cls_session *session;
> -
> -		session = iscsi_session_lookup(sid);
> -		if (session) {
> -			if (system_state != SYSTEM_RUNNING) {
> -				/* Force recovery to fail immediately */
> -				session->recovery_tmo = 0;
> -			}
> -
> -			iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
> -		}
> -
> -		list_del_init(&conn->conn_list_err);
> -	}
> -}
> -
>  void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
>  {
>  	struct nlmsghdr	*nlh;
> @@ -2534,12 +2552,9 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
>  	struct iscsi_uevent *ev;
>  	struct iscsi_internal *priv;
>  	int len = nlmsg_total_size(sizeof(*ev));
> -	unsigned long flags;
>  
> -	spin_lock_irqsave(&connlock, flags);
> -	list_add(&conn->conn_list_err, &connlist_err);
> -	spin_unlock_irqrestore(&connlock, flags);
> -	queue_work(system_unbound_wq, &stop_conn_work);
> +	if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags))
> +		queue_work(iscsi_conn_cleanup_workq, &conn->cleanup_work);
>  
>  	priv = iscsi_if_transport_lookup(conn->transport);
>  	if (!priv)
> @@ -2869,26 +2884,17 @@ static int
>  iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
>  {
>  	struct iscsi_cls_conn *conn;
> -	unsigned long flags;
>  
>  	conn = iscsi_conn_lookup(ev->u.d_conn.sid, ev->u.d_conn.cid);
>  	if (!conn)
>  		return -EINVAL;
>  
> -	spin_lock_irqsave(&connlock, flags);
> -	if (!list_empty(&conn->conn_list_err)) {
> -		spin_unlock_irqrestore(&connlock, flags);
> -		return -EAGAIN;
> -	}
> -	spin_unlock_irqrestore(&connlock, flags);
> -
> +	ISCSI_DBG_TRANS_CONN(conn, "Flushing cleanup during destruction\n");
> +	flush_work(&conn->cleanup_work);
>  	ISCSI_DBG_TRANS_CONN(conn, "Destroying transport conn\n");
>  
> -	mutex_lock(&conn_mutex);
>  	if (transport->destroy_conn)
>  		transport->destroy_conn(conn);
> -	mutex_unlock(&conn_mutex);
> -
>  	return 0;
>  }
>  
> @@ -2967,7 +2973,7 @@ static int iscsi_if_ep_connect(struct iscsi_transport *transport,
>  }
>  
>  static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
> -				  u64 ep_handle, bool is_active)
> +				  u64 ep_handle)
>  {
>  	struct iscsi_cls_conn *conn;
>  	struct iscsi_endpoint *ep;
> @@ -2978,17 +2984,30 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
>  	ep = iscsi_lookup_endpoint(ep_handle);
>  	if (!ep)
>  		return -EINVAL;
> +
>  	conn = ep->conn;
> -	if (conn) {
> -		mutex_lock(&conn->ep_mutex);
> -		conn->ep = NULL;
> +	if (!conn) {
> +		/*
> +		 * conn was not even bound yet, so we can't get iscsi conn
> +		 * failures yet.
> +		 */
> +		transport->ep_disconnect(ep);
> +		goto put_ep;
> +	}
> +
> +	mutex_lock(&conn->ep_mutex);
> +	/* Check if this was a conn error and the kernel took ownership */
> +	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
> +		ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn cleanup.\n");
>  		mutex_unlock(&conn->ep_mutex);
> -		conn->state = ISCSI_CONN_FAILED;
>  
> -		transport->unbind_conn(conn, is_active);
> +		flush_work(&conn->cleanup_work);
> +		goto put_ep;
>  	}
>  
> -	transport->ep_disconnect(ep);
> +	iscsi_ep_disconnect(conn, false);
> +	mutex_unlock(&conn->ep_mutex);
> +put_ep:
>  	iscsi_put_endpoint(ep);
>  	return 0;
>  }
> @@ -3019,8 +3038,7 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
>  		break;
>  	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
>  		rc = iscsi_if_ep_disconnect(transport,
> -					    ev->u.ep_disconnect.ep_handle,
> -					    false);
> +					    ev->u.ep_disconnect.ep_handle);
>  		break;
>  	}
>  	return rc;
> @@ -3647,18 +3665,134 @@ iscsi_get_host_stats(struct iscsi_transport *transport, struct nlmsghdr *nlh)
>  	return err;
>  }
>  
> +static int iscsi_if_transport_conn(struct iscsi_transport *transport,
> +				   struct nlmsghdr *nlh)
> +{
> +	struct iscsi_uevent *ev = nlmsg_data(nlh);
> +	struct iscsi_cls_session *session;
> +	struct iscsi_cls_conn *conn = NULL;
> +	struct iscsi_endpoint *ep;
> +	uint32_t pdu_len;
> +	int err = 0;
> +
> +	switch (nlh->nlmsg_type) {
> +	case ISCSI_UEVENT_CREATE_CONN:
> +		return iscsi_if_create_conn(transport, ev);
> +	case ISCSI_UEVENT_DESTROY_CONN:
> +		return iscsi_if_destroy_conn(transport, ev);
> +	}

Why aren't these two consecutive switch statements just one? I'm
guessing there's a good reason, but I can't see it.

> +
> +	switch (nlh->nlmsg_type) {
> +	case ISCSI_UEVENT_STOP_CONN:
> +		conn = iscsi_conn_lookup(ev->u.stop_conn.sid, ev->u.stop_conn.cid);
> +		break;
> +	case ISCSI_UEVENT_START_CONN:
> +		conn = iscsi_conn_lookup(ev->u.start_conn.sid, ev->u.start_conn.cid);
> +		break;
> +	case ISCSI_UEVENT_BIND_CONN:
> +		conn = iscsi_conn_lookup(ev->u.b_conn.sid, ev->u.b_conn.cid);
> +		break;
> +	case ISCSI_UEVENT_SEND_PDU:
> +		conn = iscsi_conn_lookup(ev->u.send_pdu.sid, ev->u.send_pdu.cid);
> +		break;
> +	}
> +
> +	if (!conn)
> +		return -EINVAL;
> +
> +	if (nlh->nlmsg_type == ISCSI_UEVENT_STOP_CONN) {
> +		iscsi_if_stop_conn(conn, ev->u.stop_conn.flag);
> +		return 0;
> +	}
> +
> +	/*
> +	 * The following cmds need to be run under the ep_mutex so in kernel
> +	 * conn cleanup (ep_disconnect + unbind and conn) is not done while
> +	 * these are running. They also must not run if we have just run a conn
> +	 * cleanup because they would set the state in a way that might allow
> +	 * IO or send IO themselves.
> +	 */
> +	mutex_lock(&conn->ep_mutex);
> +	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
> +		mutex_unlock(&conn->ep_mutex);
> +		ev->r.retcode = -ENOTCONN;
> +		return 0;
> +	}
> +
> +	switch (nlh->nlmsg_type) {
> +	case ISCSI_UEVENT_BIND_CONN:
> +		if (conn->ep) {
> +			/*
> +			 * For offload boot support where iscsid is restarted
> +			 * during the pivot root stage, the ep will be intact
> +			 * here when the new iscsid instance starts up and
> +			 * reconnects.
> +			 */
> +			iscsi_ep_disconnect(conn, true);
> +		}
> +
> +		session = iscsi_session_lookup(ev->u.b_conn.sid);
> +		if (!session) {
> +			err = -EINVAL;
> +			break;
> +		}
> +
> +		ev->r.retcode =	transport->bind_conn(session, conn,
> +						ev->u.b_conn.transport_eph,
> +						ev->u.b_conn.is_leading);
> +		if (!ev->r.retcode)
> +			conn->state = ISCSI_CONN_BOUND;
> +
> +		if (ev->r.retcode || !transport->ep_connect)
> +			break;
> +
> +		ep = iscsi_lookup_endpoint(ev->u.b_conn.transport_eph);
> +		if (ep) {
> +			ep->conn = conn;
> +			conn->ep = ep;
> +			iscsi_put_endpoint(ep);
> +		} else {
> +			err = -ENOTCONN;
> +			iscsi_cls_conn_printk(KERN_ERR, conn,
> +					      "Could not set ep conn binding\n");
> +		}
> +		break;
> +	case ISCSI_UEVENT_START_CONN:
> +		ev->r.retcode = transport->start_conn(conn);
> +		if (!ev->r.retcode)
> +			conn->state = ISCSI_CONN_UP;
> +		break;
> +	case ISCSI_UEVENT_SEND_PDU:
> +		pdu_len = nlh->nlmsg_len - sizeof(*nlh) - sizeof(*ev);
> +
> +		if ((ev->u.send_pdu.hdr_size > pdu_len) ||
> +		    (ev->u.send_pdu.data_size > (pdu_len - ev->u.send_pdu.hdr_size))) {
> +			err = -EINVAL;
> +			break;
> +		}
> +
> +		ev->r.retcode =	transport->send_pdu(conn,
> +				(struct iscsi_hdr *)((char *)ev + sizeof(*ev)),
> +				(char *)ev + sizeof(*ev) + ev->u.send_pdu.hdr_size,
> +				ev->u.send_pdu.data_size);
> +		break;
> +	default:
> +		err = -ENOSYS;
> +	}
> +
> +	mutex_unlock(&conn->ep_mutex);
> +	return err;
> +}
>  
>  static int
>  iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
>  {
>  	int err = 0;
>  	u32 portid;
> -	u32 pdu_len;
>  	struct iscsi_uevent *ev = nlmsg_data(nlh);
>  	struct iscsi_transport *transport = NULL;
>  	struct iscsi_internal *priv;
>  	struct iscsi_cls_session *session;
> -	struct iscsi_cls_conn *conn;
>  	struct iscsi_endpoint *ep = NULL;
>  
>  	if (!netlink_capable(skb, CAP_SYS_ADMIN))
> @@ -3735,90 +3869,16 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
>  		else
>  			err = -EINVAL;
>  		break;
> -	case ISCSI_UEVENT_CREATE_CONN:
> -		err = iscsi_if_create_conn(transport, ev);
> -		break;
> -	case ISCSI_UEVENT_DESTROY_CONN:
> -		err = iscsi_if_destroy_conn(transport, ev);
> -		break;
> -	case ISCSI_UEVENT_BIND_CONN:
> -		session = iscsi_session_lookup(ev->u.b_conn.sid);
> -		conn = iscsi_conn_lookup(ev->u.b_conn.sid, ev->u.b_conn.cid);
> -
> -		if (conn && conn->ep)
> -			iscsi_if_ep_disconnect(transport, conn->ep->id, true);
> -
> -		if (!session || !conn) {
> -			err = -EINVAL;
> -			break;
> -		}
> -
> -		mutex_lock(&conn_mutex);
> -		ev->r.retcode =	transport->bind_conn(session, conn,
> -						ev->u.b_conn.transport_eph,
> -						ev->u.b_conn.is_leading);
> -		if (!ev->r.retcode)
> -			conn->state = ISCSI_CONN_BOUND;
> -		mutex_unlock(&conn_mutex);
> -
> -		if (ev->r.retcode || !transport->ep_connect)
> -			break;
> -
> -		ep = iscsi_lookup_endpoint(ev->u.b_conn.transport_eph);
> -		if (ep) {
> -			ep->conn = conn;
> -
> -			mutex_lock(&conn->ep_mutex);
> -			conn->ep = ep;
> -			mutex_unlock(&conn->ep_mutex);
> -			iscsi_put_endpoint(ep);
> -		} else
> -			iscsi_cls_conn_printk(KERN_ERR, conn,
> -					      "Could not set ep conn "
> -					      "binding\n");
> -		break;
>  	case ISCSI_UEVENT_SET_PARAM:
>  		err = iscsi_set_param(transport, ev);
>  		break;
> -	case ISCSI_UEVENT_START_CONN:
> -		conn = iscsi_conn_lookup(ev->u.start_conn.sid, ev->u.start_conn.cid);
> -		if (conn) {
> -			mutex_lock(&conn_mutex);
> -			ev->r.retcode = transport->start_conn(conn);
> -			if (!ev->r.retcode)
> -				conn->state = ISCSI_CONN_UP;
> -			mutex_unlock(&conn_mutex);
> -		}
> -		else
> -			err = -EINVAL;
> -		break;
> +	case ISCSI_UEVENT_CREATE_CONN:
> +	case ISCSI_UEVENT_DESTROY_CONN:
>  	case ISCSI_UEVENT_STOP_CONN:
> -		conn = iscsi_conn_lookup(ev->u.stop_conn.sid, ev->u.stop_conn.cid);
> -		if (conn)
> -			iscsi_if_stop_conn(conn, ev->u.stop_conn.flag);
> -		else
> -			err = -EINVAL;
> -		break;
> +	case ISCSI_UEVENT_START_CONN:
> +	case ISCSI_UEVENT_BIND_CONN:
>  	case ISCSI_UEVENT_SEND_PDU:
> -		pdu_len = nlh->nlmsg_len - sizeof(*nlh) - sizeof(*ev);
> -
> -		if ((ev->u.send_pdu.hdr_size > pdu_len) ||
> -		    (ev->u.send_pdu.data_size > (pdu_len - ev->u.send_pdu.hdr_size))) {
> -			err = -EINVAL;
> -			break;
> -		}
> -
> -		conn = iscsi_conn_lookup(ev->u.send_pdu.sid, ev->u.send_pdu.cid);
> -		if (conn) {
> -			mutex_lock(&conn_mutex);
> -			ev->r.retcode =	transport->send_pdu(conn,
> -				(struct iscsi_hdr*)((char*)ev + sizeof(*ev)),
> -				(char*)ev + sizeof(*ev) + ev->u.send_pdu.hdr_size,
> -				ev->u.send_pdu.data_size);
> -			mutex_unlock(&conn_mutex);
> -		}
> -		else
> -			err = -EINVAL;
> +		err = iscsi_if_transport_conn(transport, nlh);
>  		break;
>  	case ISCSI_UEVENT_GET_STATS:
>  		err = iscsi_if_get_stats(transport, nlh);
> @@ -4821,8 +4881,18 @@ static __init int iscsi_transport_init(void)
>  		goto release_nls;
>  	}
>  
> +	iscsi_conn_cleanup_workq = alloc_workqueue("%s",
> +			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_UNBOUND, 0,
> +			"iscsi_conn_cleanup");
> +	if (!iscsi_conn_cleanup_workq) {
> +		err = -ENOMEM;
> +		goto destroy_wq;
> +	}
> +
>  	return 0;
>  
> +destroy_wq:
> +	destroy_workqueue(iscsi_eh_timer_workq);
>  release_nls:
>  	netlink_kernel_release(nls);
>  unregister_flashnode_bus:
> @@ -4844,6 +4914,7 @@ static __init int iscsi_transport_init(void)
>  
>  static void __exit iscsi_transport_exit(void)
>  {
> +	destroy_workqueue(iscsi_conn_cleanup_workq);
>  	destroy_workqueue(iscsi_eh_timer_workq);
>  	netlink_kernel_release(nls);
>  	bus_unregister(&iscsi_flashnode_bus);
> diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
> index d36a72cf049f..3974329d4d02 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -197,15 +197,23 @@ enum iscsi_connection_state {
>  	ISCSI_CONN_BOUND,
>  };
>  
> +#define ISCSI_CLS_CONN_BIT_CLEANUP	1
> +
>  struct iscsi_cls_conn {
>  	struct list_head conn_list;	/* item in connlist */
> -	struct list_head conn_list_err;	/* item in connlist_err */
>  	void *dd_data;			/* LLD private data */
>  	struct iscsi_transport *transport;
>  	uint32_t cid;			/* connection id */
> +	/*
> +	 * This protects the conn startup and binding/unbinding of the ep to
> +	 * the conn. Unbinding includes ep_disconnect and stop_conn.
> +	 */
>  	struct mutex ep_mutex;
>  	struct iscsi_endpoint *ep;
>  
> +	unsigned long flags;
> +	struct work_struct cleanup_work;
> +
>  	struct device dev;		/* sysfs transport/container device */
>  	enum iscsi_connection_state state;
>  };
> 

-- 
Lee Duncan

