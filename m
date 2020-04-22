Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F0FC55186
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 23:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B491F20776
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 23:12:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VHLOJo+O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgDVXMN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 19:12:13 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39934 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725839AbgDVXMN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Apr 2020 19:12:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587597131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9sk9qnoZksaNBw+oUC3ATc/jYj++wvSQBR0wcDheQS4=;
        b=VHLOJo+O1207k4zNPvSxHCvCAq8G71amKR+QHT21NFczwFB+bh16SEtiuVcF4E1xak6lOS
        41Dn1JPVA3rS7Rgtv8EEZyhEP3VZQlquAfBIqHUygTykFUPVfu+Kzd2SgqHPC3EKXBXF/g
        UydINfCBK7qb+oJMjR+sjoQwX/O+ROY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-qVTAb8AHPoaku90A6wX0mg-1; Wed, 22 Apr 2020 19:12:09 -0400
X-MC-Unique: qVTAb8AHPoaku90A6wX0mg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5F0318C35A0;
        Wed, 22 Apr 2020 23:12:07 +0000 (UTC)
Received: from [10.10.117.185] (ovpn-117-185.rdu2.redhat.com [10.10.117.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 226B26084B;
        Wed, 22 Apr 2020 23:12:07 +0000 (UTC)
Subject: Re: [PATCH 1/2] iscsi-target: fix login error when receiving is too
 fast
To:     Pu Hou <houpu@bytedance.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200415080819.27327-1-houpu@bytedance.com>
 <20200415080819.27327-2-houpu@bytedance.com>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <54e574b1-10b4-4385-11fb-773ef152fc2c@redhat.com>
Date:   Wed, 22 Apr 2020 18:12:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200415080819.27327-2-houpu@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/15/20 3:08 AM, Pu Hou wrote:
> iscsi_target_sk_data_ready() could be invoked indirectly
> by iscsi_target_do_login_rx() from workqueue like following:
> 
> iscsi_target_do_login_rx()
>   iscsi_target_do_login()
>     iscsi_target_do_tx_login_io()
>       iscsit_put_login_tx()
>         iscsi_login_tx_data()
>           tx_data()
>             sock_sendmsg_nosec()
>               tcp_sendmsg()
>                 release_sock()
>                   sk_backlog_rcv()
>                     tcp_v4_do_rcv()
>                       tcp_data_ready()
>                         iscsi_target_sk_data_ready()
> 
> At that time LOGIN_FLAGS_READ_ACTIVE is not cleared.
> and iscsi_target_sk_data_ready will not read data
> from the socket. And some iscsi initiator(i.e. libiscsi)
> will wait forever for a reply.
> 
> LOGIN_FLAGS_READ_ACTIVE should be cleared early just after
> doing the receive and before writing to the socket in
> iscsi_target_do_login_rx.
> 
> But sad news is that LOGIN_FLAGS_READ_ACTIVE is also used
> by sk_state_change to do login cleanup if a socket was closed
> at login time. It is supposed to be cleared after the login
> pdu is successfully processed and reponsed.
> 
> So introduce another flag LOGIN_FLAGS_WRITE_ACTIVE to cover
> the transmit part so that sk_state_change could work well
> and clear LOGIN_FLAGS_READ_ACTIVE early so that sk_data_ready
> could also work.
> 
> Signed-off-by: Pu Hou <houpu@bytedance.com>
> ---
>  drivers/target/iscsi/iscsi_target_nego.c | 29 +++++++++++++++++++++++++----
>  include/target/iscsi/iscsi_target_core.h |  1 +
>  2 files changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
> index 685d771b51d4..950339655778 100644
> --- a/drivers/target/iscsi/iscsi_target_nego.c
> +++ b/drivers/target/iscsi/iscsi_target_nego.c
> @@ -622,6 +622,26 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
>  	if (rc < 0)
>  		goto err;
>  
> +	/*
> +	 * LOGIN_FLAGS_READ_ACTIVE is cleared so that sk_data_ready
> +	 * could be trigger again after this.
> +	 *
> +	 * LOGIN_FLAGS_WRITE_ACTIVE is cleared after we successfully
> +	 * processing a login pdu. So that sk_state_chage could do login

I think we need to drop "ing" from processing and do:

process a login pdu, so that sk_state_chage could do login


> +	 * cleanup as need if the socket is closed. If a delay work is
> +	 * ongoing LOGIN_FLAGS_WRITE_ACTIVE or LOGIN_FLAGS_READ_ACTIVE),
> +	 * sk_state_change will leave the cleanup to the delayed work or
> +	 * it will schedule a delayed work to do cleanup.
> +	 */
> +	if (conn->sock) {
> +		struct sock *sk = conn->sock->sk;
> +
> +		write_lock_bh(&sk->sk_callback_lock);
> +		clear_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags);
> +		set_bit(LOGIN_FLAGS_WRITE_ACTIVE, &conn->login_flags);
> +		write_unlock_bh(&sk->sk_callback_lock);
> +	}
> +
>  	pr_debug("iscsi_target_do_login_rx after rx_login_io, %p, %s:%d\n",
>  			conn, current->comm, current->pid);
>  
> @@ -629,7 +649,7 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
>  	if (rc < 0) {
>  		goto err;
>  	} else if (!rc) {
> -		if (iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_READ_ACTIVE))
> +		if (iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_WRITE_ACTIVE))
>  			goto err;
>  	} else if (rc == 1) {
>  		iscsi_target_nego_release(conn);
> @@ -670,9 +690,10 @@ static void iscsi_target_sk_state_change(struct sock *sk)
>  	state = __iscsi_target_sk_check_close(sk);
>  	pr_debug("__iscsi_target_sk_close_change: state: %d\n", state);
>  
> -	if (test_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags)) {
> -		pr_debug("Got LOGIN_FLAGS_READ_ACTIVE=1 sk_state_change"
> -			 " conn: %p\n", conn);
> +	if (test_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags) ||
> +	    test_bit(LOGIN_FLAGS_WRITE_ACTIVE, &conn->login_flags)) {
> +		pr_debug("Got LOGIN_FLAGS_{READ|WRITE}_ACTIVE=1"
> +			 "sk_state_change conn: %p\n", conn);
>  		if (state)
>  			set_bit(LOGIN_FLAGS_CLOSED, &conn->login_flags);
>  		write_unlock_bh(&sk->sk_callback_lock);
> diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
> index 591cd9e4692c..0c2dfc81bf8b 100644
> --- a/include/target/iscsi/iscsi_target_core.h
> +++ b/include/target/iscsi/iscsi_target_core.h
> @@ -570,6 +570,7 @@ struct iscsi_conn {
>  #define LOGIN_FLAGS_CLOSED		2
>  #define LOGIN_FLAGS_READY		4
>  #define LOGIN_FLAGS_INITIAL_PDU		8
> +#define LOGIN_FLAGS_WRITE_ACTIVE	12

12 works but seems odd. The current code uses test/set/clear_bit, so we
want these to be:

#define LOGIN_FLAGS_CLOSED 0
#define LOGIN_FLAGS_READY 1
#define LOGIN_FLAGS_INITIAL_PDU 2
#define LOGIN_FLAGS_WRITE_ACTIVE 3

right?

2, 4, 8 was probably from a time we set the bits our self like:

login_flags |= LOGIN_FLAGS_CLOSED;


>  	unsigned long		login_flags;
>  	struct delayed_work	login_work;
>  	struct iscsi_login	*login;
> 

