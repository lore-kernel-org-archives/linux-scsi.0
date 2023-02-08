Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5396C05027
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Feb 2023 21:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbjBHVAO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Feb 2023 16:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjBHVAM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2023 16:00:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038394FCE5
        for <linux-scsi@vger.kernel.org>; Wed,  8 Feb 2023 12:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675889886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c19y15vFgdgq3qzwbs9TNv81UfD0n+GAFQYuUQ5/imc=;
        b=CJz4N6DFYjq9LKrm0CpohqwnK1WryyIVD2la8uckk9FkZNvB7P7YlV4wzfEEvmD1w/RUXn
        4I4id3RFNpqq+PWNC8R1Bw7gCUPn8qCtPyMIdO30gX+PR+hhv7s2XfrN1GIudRm8Ke0n8q
        AGSqI7EMINXUwWSRX6aheSMFQTpX3rc=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-658-ePWps6WwNMqhexjnRS3P8A-1; Wed, 08 Feb 2023 15:58:04 -0500
X-MC-Unique: ePWps6WwNMqhexjnRS3P8A-1
Received: by mail-qv1-f70.google.com with SMTP id c10-20020a05621401ea00b004c72d0e92bcso29942qvu.12
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2023 12:58:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=c19y15vFgdgq3qzwbs9TNv81UfD0n+GAFQYuUQ5/imc=;
        b=AfECOtP8Oi/qI7TEUMSh6diTWOjazC8MsSetftOBcPxcUHHImuyDKBXHTZJ+2VeMap
         4cr+LwytSXk4jDQvfqfuS7QDg+l46UHm7RMVTQhbG5rGkv/RD6Yh+54elbbJDS8HT5zy
         qyn9kJepSbSFJ7HMG4Smld33WUbce3Nqfm7YxHqk17FXrQOTfaXCaQAxygM8h143S/77
         LIeNSgp8fnxxrCvacSK3JLpwdPJ+hL6/d7MYkSS0RRMIdex2gozCq/krB4YG5WG7yYM8
         kUK7ZWv5bripjRWPmCiTO+4uv0paNf/Gzn1CZqWAaLAm+1shjD1zO65IHwN41GNnT1X/
         4Bqg==
X-Gm-Message-State: AO0yUKVBBD36ByCTIFpm1+t8nmd6H14orV/xxajL4QbNLU6mOtxAcUWa
        3Iyu/6U05qHUYSXnn1emdaM1vQbv1Esdoyg7r898d7ParHFkD64cHUH5P95buxkGeN5QGuj6qwc
        aU+9iQMkvZSmlnN2CSEGYfg==
X-Received: by 2002:ac8:5a54:0:b0:3ba:1acd:4f8 with SMTP id o20-20020ac85a54000000b003ba1acd04f8mr15598463qta.42.1675889883753;
        Wed, 08 Feb 2023 12:58:03 -0800 (PST)
X-Google-Smtp-Source: AK7set/wovYixPV1h2XRRqRycKSEi/i0QxGQmfsuo8Z2G3dqDhLj5NeHfUw6BSXS4RMUzWS1RX9f9A==
X-Received: by 2002:ac8:5a54:0:b0:3ba:1acd:4f8 with SMTP id o20-20020ac85a54000000b003ba1acd04f8mr15598433qta.42.1675889883403;
        Wed, 08 Feb 2023 12:58:03 -0800 (PST)
Received: from lobep17 ([2600:6c64:4e7f:603b:6e24:8ff:feb9:533e])
        by smtp.gmail.com with ESMTPSA id r19-20020ac87953000000b003b6953fbb8fsm12168420qtt.32.2023.02.08.12.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 12:58:02 -0800 (PST)
Message-ID: <caff1add88d1e46c962ee52aae441769450c4dd9.camel@redhat.com>
Subject: Re: [PATCH] scsi: target: iscsi: set memalloc_noio with loopback
 network connections
From:   Laurence Oberman <loberman@redhat.com>
To:     David Jeffery <djeffery@redhat.com>, target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 08 Feb 2023 15:58:01 -0500
In-Reply-To: <20230208200957.14073-1-djeffery@redhat.com>
References: <20230208200957.14073-1-djeffery@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2023-02-08 at 15:09 -0500, David Jeffery wrote:
> If an admin connects an iscsi initiator to an iscsi target on the
> same
> system, the iscsi connection is vulnerable to deadlocks during memory
> allocations. Memory allocations in the target task accepting the I/O
> from
> the initiator can wait on the initiator's I/O when the system is
> under
> memory pressure, causing a deadlock situation between the iscsi
> target and
> initiator.
> 
> When in this configuration, the deadlock scenario can be avoided by
> use of
> GFP_NOIO allocations. Rather than force all configurations to use
> NOIO,
> memalloc_noio_save/restore can be used to force GFP_NOIO allocations
> only
> when in this loopback configuration.
> 
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c
> b/drivers/target/iscsi/iscsi_target.c
> index baf4da7bb3b4..a68e47e2cdf9 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -16,6 +16,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/idr.h>
>  #include <linux/delay.h>
> +#include <linux/sched/mm.h>
>  #include <linux/sched/signal.h>
>  #include <asm/unaligned.h>
>  #include <linux/inet.h>
> @@ -4168,7 +4169,10 @@ int iscsi_target_rx_thread(void *arg)
>  {
>  	int rc;
>  	struct iscsit_conn *conn = arg;
> +	struct dst_entry *dst;
>  	bool conn_freed = false;
> +	bool loopback = false;
> +	unsigned int flags;
>  
>  	/*
>  	 * Allow ourselves to be interrupted by SIGINT so that a
> @@ -4186,8 +4190,25 @@ int iscsi_target_rx_thread(void *arg)
>  	if (!conn->conn_transport->iscsit_get_rx_pdu)
>  		return 0;
>  
> +	/*
> +	 * If the iscsi connection is over a loopback device from using
> +	 * iscsi and iscsit on the same system, we need to set
> memalloc_noio to
> +	 * prevent memory allocation deadlocks between target and
> initiator.
> +	 */
> +	rcu_read_lock();
> +	dst = rcu_dereference(conn->sock->sk->sk_dst_cache);
> +	if (dst && dst->dev && dst->dev->flags & IFF_LOOPBACK)
> +		loopback = true;
> +	rcu_read_unlock();
> +
> +	if (loopback)
> +		flags = memalloc_noio_save();
> +
>  	conn->conn_transport->iscsit_get_rx_pdu(conn);
>  
> +	if (loopback)
> +		memalloc_noio_restore(flags);
> +
>  	if (!signal_pending(current))
>  		atomic_set(&conn->transport_failed, 1);
>  	iscsit_take_action_for_connection_exit(conn, &conn_freed);


I had mentioned to Mike that this was already tested at a large
customer and in our labs and resolved the deadlocks .

Regards
Laurence Oberman

