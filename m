Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB0BC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 21:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbhLTVZd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 16:25:33 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:35755 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230336AbhLTVZd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Dec 2021 16:25:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1640035532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oc64vDlzs4VCZAGMe9Kv5NpOl5G0FIQkgsXzogfEYFk=;
        b=WgaUouDIWw4mz2FXDTyCFhOGbrvTuu9n9Z9qfVx5S6CdQcv2rRMbOeYYAbiUTRc/Jt0yCz
        x6XdkYB5gdPji+UVeyOht1+KML9xOxcG662y1sC4h1+CP2Eoh3bMQJu/ZFEbNpLdSzzn5R
        kCfq/GxdZ+7dS1F7j9hGxLy1YHeSpvw=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2058.outbound.protection.outlook.com [104.47.1.58]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-27-6rdeFfEIObGLj09LLAevVw-1; Mon, 20 Dec 2021 22:25:31 +0100
X-MC-Unique: 6rdeFfEIObGLj09LLAevVw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ggaocVR102XNcoK7c4HvJ1RL/haD0RcdVDKfBkndaFSPuqB2uV85B94ZveycBKaJxYpQETkYiSpTxvgUYjaG7WQTMtB31IQ92jNXViYCHk9JBu8FAgoOM96c3eEIkvpnGmb/PQqG5f7RCz50vlByx50XewfIiHjCNS3Neha0o8bbUTwIR6fj+VfNNYB0hccqaq/hE9lh7+dXjZAWtgOMpjz4kMtkJVeVW/BQdE5YVqdotsS6r59elWvHhTBUBFezdLUj2sV+UplM6/z57IPJUXMXi9JydtiRfseC/Y25DxPz18L8z7i7aMAEzcEblHUMmzt8gUWPr+64QXYAMdis1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oc64vDlzs4VCZAGMe9Kv5NpOl5G0FIQkgsXzogfEYFk=;
 b=ffbObGHqhQsNJMdRcWitUqVQi22Gkajqm+RYqjrJcX5YSKWsw9KTGw2qTZzY8+Jm1VzeAwxwGzLkm/8TX614uOembqytnMXGsSMrHSQT4Tu3HAka4YU8ArPKFbgumoamPMiKamsf7lCkLh5Vld85WwgP69z4mMdzFMJD6jcV85iLp+YeA94BfiF40g5kYs03y8NqebFb+UY/ID7QCZvCmurpQXrL8c6lFyN9aJIPQlcVdYqcc9fjWdXCA3LY261m73Rg5Blr8SOqMLJ0ZAd1TlMh6BVWqIYxmwV9ZyVmtb50w1JPlvMbQjiHG6bR0OH/Z5CdZdgJ0fkrl8HQHmVGsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB5928.eurprd04.prod.outlook.com (2603:10a6:20b:a3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Mon, 20 Dec
 2021 21:25:29 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a1b8:1377:d500:aa46]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a1b8:1377:d500:aa46%6]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 21:25:29 +0000
Subject: Re: [PATCH] libiscsi: fix UAF when iscsi_conn_get_param and
 iscsi_conn_teardown concurrent
To:     lixiaokeng <lixiaokeng@huawei.com>, cleech@redhat.com,
        linux-scsi@vger.kernel.org
Cc:     linfeilong <linfeilong@huawei.com>
References: <046ec8a0-ce95-d3fc-3235-666a7c65b224@huawei.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <b4556b30-7418-03f1-155b-7fd8daeedf91@suse.com>
Date:   Mon, 20 Dec 2021 13:25:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <046ec8a0-ce95-d3fc-3235-666a7c65b224@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P192CA0005.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:83::18) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eab3fc39-c9b3-4888-388e-08d9c3ff3f1b
X-MS-TrafficTypeDiagnostic: AM6PR04MB5928:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB592864F8F99790B96A847B1FDA7B9@AM6PR04MB5928.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:37;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tU2KbCNtLmN1IUZnJK+KlAdFPdiDawn8cGpCwSW8AWax7yaIbng41j0mq5CStGbiDRMYpTW0odw/Q8BPAc8VbvRaZ4NgAS7gmce0I0Pjcg20bn/gEXb0e5Pj/f7+ORscjBaxvgSpJ/Oe0gVAWcXg6YGyPPNftQpBkEAnzxhv1cklINoQn4aw2fyTPUptuJovFSns66glVLb7PVvB6I6ViUqsULxXUsymb0A8NEUR4RiAJNnI6F5YJs3WK652L9xfGXJluAf/n3om4v4w+K+RK1IERh9h8iutpBHTbw8gYLhPvm771qfmWvC21yRk6987162+0MR+7ftAS5B4dCiB30QL5fay9oVa578Aw1MGY1pvZtvo1SY1nvp9i8NtQPHeEOrF+yvTcS4RZ3pzSvvoqf4TRScX/t+TL3FQ6jnEvndW7kC/ndFHH1rXGlzp46Au0bHW4k9SzB7ODlomnLbokhrSy4WLi3e9VhVJNu4xMASNBfjcqztEXbjYt3gSCMcDdNSGV/i7GQvxB25pmoS0PeW+TvI5HIUuaapt2/cG2Gmwpufqm1g/Hj2kkwQKYxTW9S34Jdzf0HPeYKThGIo7e/rQMpjLcrng+7Z5Qo/4oG9Xouxoo+FQCr7wqxgMtRWyrxzQGDbhbTIqo9ehWVMvsFaXEnGI9yzxo29f9cwgYg4BJ2t97GwSsiAJleaMyydGLXXEhvStl1IU7C9KaEvV+yuWv1wvyYVL6nY/8aXu25Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(2906002)(5660300002)(38100700002)(316002)(31696002)(86362001)(31686004)(66556008)(36756003)(2616005)(66476007)(4326008)(8936002)(83380400001)(66946007)(508600001)(6666004)(186003)(6512007)(26005)(6506007)(53546011)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZTlJRDRFSzBGT3hUUHNVVnJEdXkzUDhScS9lMjA0aXc0VnFOUFpFQXRwYVdQ?=
 =?utf-8?B?S0RyM2pRby9wVFpxd2hXZHJvaE5zb0tZMm1KYStweWpoODNrYm1qeGc1ZHNi?=
 =?utf-8?B?VHhmc05hN2h5UFNVR3pjbEVLRC8rT0FvU2dDdmRaVW12WjFQM1JFZ0FIcU80?=
 =?utf-8?B?ZkM4NDcwVzhWUVBIdmpyWnlnbGpRcHBCZ3VJMnRNaXpLdUR2MTJiL3dsRVZt?=
 =?utf-8?B?SWI1MGprUFpwYmxZbnE3bEMxRkdHYVUxU1N2bll0bkVJT2htM1RkUWFVcUdW?=
 =?utf-8?B?VHk1ZHMraEdwNCtYSTRIMDlFNENWbVFZQ0QrM2o2eFFqclpzaXVJeGxZQ2FK?=
 =?utf-8?B?aDQwM0FXRFhtMjI2NGNRVFpIUXJIZDd4SUZJTy9oTW5kQ2ZlWjR4UnFzK0lH?=
 =?utf-8?B?aGRNWkVLT2IxZDkwdGdHazZlamgxLzE5SXdjVEFYaEhxL1U5ZTdYTWZnZGdj?=
 =?utf-8?B?UTVVVlk3UmlEdkoybzd6ZGFUZUMwSDFLVko3bXV1dDdJUG9IdURKRlRrajU5?=
 =?utf-8?B?NzNLMzFxYUFhYzJ0VTF0eGR1R1ZacTdtNjFEczNYQWtqQ0p2QlI1cHZFRU5Z?=
 =?utf-8?B?ZzVZRVM0RmRsT2p2TytlR3licU90ck1NRk9ja2xQM3AwYmpGTGhwM053NE1I?=
 =?utf-8?B?anptbklWbndVRDVzc3ZGQisyZmcxdUNhV0VZSjY3S3lXanpndUNkYjl3dmRx?=
 =?utf-8?B?NkhBNlJGTFJZZm1QRmlwR1dlUjU1S2ZDU1IwSjJRREhNT3pZZGpEd3VVanl3?=
 =?utf-8?B?VVNKM0cra3FmY0twek45ZVVCRWRNRklXUW9IM1NRV0VZRDQvbnZOdkJIbUdS?=
 =?utf-8?B?ZWtWNDZJSU9LUHh2eks3QzBPL2s4VW50VmxScEFGOWpwa1lnbGsyOXdCaGMw?=
 =?utf-8?B?Vm9VeWR5cVNXUTBobGpVYWEyL3ZSZ2R0VFVDMWhNc2ZTNG5VczhJUzlwbUFY?=
 =?utf-8?B?YUZRbEQ4OUZMUjlXM3dPZER5Wm9HdFdURFJyZExsVFdiRk5TZjNqSnpWVmRy?=
 =?utf-8?B?NTFBQkRxcjRoVTNSR1JwV2JyT1hQcUs5TDdSNXpVcS9DU1dTeEVsemw5Umg2?=
 =?utf-8?B?RVN1TU9pTEZRdHM2TTVPcXhLUVEwblphSWRadGpvRFJvOEtEelVCTXVMdE1G?=
 =?utf-8?B?Yk4wZytoVU4xc252ODBCNXNZNytHYThvaER5TVRyTVpMNkJqODhPY2lwUmor?=
 =?utf-8?B?SW1mUy9zQ0dVZjJHTGhMb1pxejBkNTIrTnd3bCtiNW05MEN2MXY3eEFLTVpl?=
 =?utf-8?B?ZVlBdFRMTTZ1OG9CZFhPWFZmMTArVnJGL3FQZ25RQk9lTUpwSlk2THpxQlhj?=
 =?utf-8?B?Z2JqVHM0MnRHb3Q5QWxpbDhUNWREc0ZVc0NNaG8xOS9sZlp5NDVaTEdKa0t3?=
 =?utf-8?B?bDZDYWFaaTZGT25BZXlObEJUZkdzaE9mSXV0WXhpMFNqNUQ0bHFrQWYrbEgr?=
 =?utf-8?B?bUNQK1dEbGxFYXFQREpyRHYvODF5elJMVklXSitmOWcyRkJ3MUdxRHpsVDU3?=
 =?utf-8?B?MWpuc2U4N2NqQnJJRzljK0dsNGxYUHpZbThXZkQwdlZpZGZHTVovYWxkeHZK?=
 =?utf-8?B?ZzM4OW9OM2QzSU9MbnZvM05tL2FjVmV1TGI0bXJxOEx6UzJ0SjNFZmU1NkpX?=
 =?utf-8?B?ZCs3aEEvcjBYMTFoTGJBS0NEYTVGZDU5bzdEbHgzRDlhSnExT3hJNm1KdjVO?=
 =?utf-8?B?cE5RMUJRMUhGamlwNmMyYXNxY3ZjMmVyaUJ5dmJRUmFLRlVQT3BMeXlRbFR6?=
 =?utf-8?B?cjFxVEM4bUhWaU9zRDJpOEhrdHEzL2VLWUxZbDY0T0JQcjRDZHQ0c3VQRHNF?=
 =?utf-8?B?SlVwb1VGVjVWRGhTa1YxZUJCYVBBeHJzSGRMM2Z5OUVXaE1CaUw2akExOGl0?=
 =?utf-8?B?bDZvdTlOMHdETklrMTRoRG5mbVNsQmxHZi9TalJWamVXR05yaDVHajgzVGwr?=
 =?utf-8?B?QUJ4d3pqNnpmOFpWZDVVajh3TnY1ZlEvTU53b25MMFBLV1B6NW5HOStHTWhV?=
 =?utf-8?B?Sm1DbFBKUlpUdHJzcU9wS3duOTZFY09tUUtrY1RlemVrYTBrRHlaMnptdnhZ?=
 =?utf-8?B?QmZQeTB0UFhieW5VWm5yS0djRVVKQy80NmZUeWlBNTd3cTd3Wk5rM0JWRTcw?=
 =?utf-8?B?YUZSTU14ZVZUYzlKVitwbzZYN2ZrK2ZRd0kyWXdRYk1wVjJPZEF2Q1g1QTAy?=
 =?utf-8?Q?BH8PiMog5a3ULcSANvS60wE=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eab3fc39-c9b3-4888-388e-08d9c3ff3f1b
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 21:25:29.4179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L9UqChna/sjU+6oBacU071nw2fvsRvKWetcAUoeGBakhRe5nk0qJru/hRGy2qTv+vWaLuLtVAR7sOUL9OyxHuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5928
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/20/21 3:39 AM, lixiaokeng wrote:
> |- iscsi_if_destroy_conn            |-dev_attr_show
>  |-iscsi_conn_teardown
>   |-spin_lock_bh                     |-iscsi_sw_tcp_conn_get_param
> 
>   |-kfree(conn->persistent_address)   |-iscsi_conn_get_param
>   |-kfree(conn->local_ipaddr)
>                                        ==>|-read persistent_address
>                                        ==>|-read local_ipaddr
>   |-spin_unlock_bh
> 
> when iscsi_conn_teardown and iscsi_conn_get_param happen in parallel,
> may trigger UAF issues.
> 
> Signed-off-by: Lixiaokeng<lixiaokeng@huawei.com>
> Signed-off-by: Linfeilong<linfeilong@huawei.com>
> Reported-by: Lu Tixiong<lutianxiong@huawei.com>
> ---
>  drivers/scsi/libiscsi.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 284b939fb1ea..059dae8909ee 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -3100,6 +3100,8 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
>  {
>  	struct iscsi_conn *conn = cls_conn->dd_data;
>  	struct iscsi_session *session = conn->session;
> +	char *tmp_persistent_address = conn->persistent_address;
> +	char *tmp_local_ipaddr = conn->local_ipaddr;
> 
>  	del_timer_sync(&conn->transport_timer);
> 
> @@ -3121,8 +3123,6 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
>  	spin_lock_bh(&session->frwd_lock);
>  	free_pages((unsigned long) conn->data,
>  		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
> -	kfree(conn->persistent_address);
> -	kfree(conn->local_ipaddr);
>  	/* regular RX path uses back_lock */
>  	spin_lock_bh(&session->back_lock);
>  	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
> @@ -3134,6 +3134,8 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
>  	mutex_unlock(&session->eh_mutex);
> 
>  	iscsi_destroy_conn(cls_conn);
> +	kfree(tmp_persistent_address);
> +	kfree(tmp_local_ipaddr);
>  }
>  EXPORT_SYMBOL_GPL(iscsi_conn_teardown);
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

