Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C513AC636D6
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Feb 2023 19:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjBIT1j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Feb 2023 14:27:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjBIT1h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2023 14:27:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FDA7A9A
        for <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2023 11:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675970808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=akijUhdsZtbO6GrY7g1LPHTtADkehACs6oFy8tM6Z4w=;
        b=P6veRR3oeZXgPJHeBEFiUBjAOaOOQaihaKOOVwzg0d6xihQqFcj4KFwHSsK4yHGnmnLxxO
        /yOZjCRuS0QDGXbI2SYtPnozBms45QcRuDTkO+1nstcFu4y85fmKldqHvmsY5sXpkDpS6U
        AArjcAGxf/8UBk97Wd+8oLRckc+8Uck=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-508-8DY4T-71Oi2JxQx6vo5I1A-1; Thu, 09 Feb 2023 14:26:46 -0500
X-MC-Unique: 8DY4T-71Oi2JxQx6vo5I1A-1
Received: by mail-qt1-f199.google.com with SMTP id t5-20020a05622a180500b003b9c03cd525so1703265qtc.20
        for <linux-scsi@vger.kernel.org>; Thu, 09 Feb 2023 11:26:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=akijUhdsZtbO6GrY7g1LPHTtADkehACs6oFy8tM6Z4w=;
        b=JzrY82vFUM7XEzWufWlXCBdNYXykg4iXy0mknJtLbUNWirvpsEI0hS+G6vlox4tqyz
         foqLn/Rj1DFtUAoPFrZjndq8F+yMk7aurHxoRngYDeC3Jtoyg2xm0LTO4mNDn1O/xhrK
         HMWVb/mc7sAMakCoYT/gmevCqbKx/qhk6CVmW9vCNtflPdPeeS/luFCKM8YaGKIiRmTe
         CpPoNoF1y0IjRKRgrPOgy6V1CM9V2c7SV2xn9RuucXyhf3gWRuSZ4/lAMDUhAgpSViPz
         iHL9mqxxuwyzSJRpmMjh08jivJUY6HkJ26TteDERvScmZGy8lIF2yU0sDMpZlgVLjaGC
         gn8Q==
X-Gm-Message-State: AO0yUKXOE/fe9glE8vkhUgV0jv4xeQYjjOG4B+j98Q4KGJDz0gJrEDzT
        nPvWx1cVye2jRZl3in5zpJ9WotXJa2F+LIyh1B6LxhXwqPhkEkLGzYLYm/yWZt2gHl3Wo6mQ2Bh
        SBaAQ+jppeAvXAm6yYBROgA==
X-Received: by 2002:ac8:7fcd:0:b0:3ba:19e5:3e45 with SMTP id b13-20020ac87fcd000000b003ba19e53e45mr21079031qtk.13.1675970806128;
        Thu, 09 Feb 2023 11:26:46 -0800 (PST)
X-Google-Smtp-Source: AK7set9vrrF2w5Al3fvqHIUnNh/FqiDLAli3cZUHRYIwK1b1hSjOhIxwMzM7+hcFYu3tH0gOx6SFiA==
X-Received: by 2002:ac8:7fcd:0:b0:3ba:19e5:3e45 with SMTP id b13-20020ac87fcd000000b003ba19e53e45mr21078996qtk.13.1675970805679;
        Thu, 09 Feb 2023 11:26:45 -0800 (PST)
Received: from lobep17 ([2600:6c64:4e7f:603b:6e24:8ff:feb9:533e])
        by smtp.gmail.com with ESMTPSA id m28-20020aed27dc000000b003b635a5d56csm1869655qtg.30.2023.02.09.11.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 11:26:45 -0800 (PST)
Message-ID: <6fc6c8c2a94aa46b99f276bf32650ec43d79328d.camel@redhat.com>
Subject: Re: [PATCH] scsi: target: iscsi: set memalloc_noio with loopback
 network connections
From:   Laurence Oberman <loberman@redhat.com>
To:     David Jeffery <djeffery@redhat.com>, target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 09 Feb 2023 14:26:44 -0500
In-Reply-To: <caff1add88d1e46c962ee52aae441769450c4dd9.camel@redhat.com>
References: <20230208200957.14073-1-djeffery@redhat.com>
         <caff1add88d1e46c962ee52aae441769450c4dd9.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2023-02-08 at 15:58 -0500, Laurence Oberman wrote:
> On Wed, 2023-02-08 at 15:09 -0500, David Jeffery wrote:
> > If an admin connects an iscsi initiator to an iscsi target on the
> > same
> > system, the iscsi connection is vulnerable to deadlocks during
> > memory
> > allocations. Memory allocations in the target task accepting the
> > I/O
> > from
> > the initiator can wait on the initiator's I/O when the system is
> > under
> > memory pressure, causing a deadlock situation between the iscsi
> > target and
> > initiator.
> > 
> > When in this configuration, the deadlock scenario can be avoided by
> > use of
> > GFP_NOIO allocations. Rather than force all configurations to use
> > NOIO,
> > memalloc_noio_save/restore can be used to force GFP_NOIO
> > allocations
> > only
> > when in this loopback configuration.
> > 
> > Signed-off-by: David Jeffery <djeffery@redhat.com>
> > ---
> >  drivers/target/iscsi/iscsi_target.c | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> > 
> > diff --git a/drivers/target/iscsi/iscsi_target.c
> > b/drivers/target/iscsi/iscsi_target.c
> > index baf4da7bb3b4..a68e47e2cdf9 100644
> > --- a/drivers/target/iscsi/iscsi_target.c
> > +++ b/drivers/target/iscsi/iscsi_target.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/vmalloc.h>
> >  #include <linux/idr.h>
> >  #include <linux/delay.h>
> > +#include <linux/sched/mm.h>
> >  #include <linux/sched/signal.h>
> >  #include <asm/unaligned.h>
> >  #include <linux/inet.h>
> > @@ -4168,7 +4169,10 @@ int iscsi_target_rx_thread(void *arg)
> >  {
> >  	int rc;
> >  	struct iscsit_conn *conn = arg;
> > +	struct dst_entry *dst;
> >  	bool conn_freed = false;
> > +	bool loopback = false;
> > +	unsigned int flags;
> >  
> >  	/*
> >  	 * Allow ourselves to be interrupted by SIGINT so that a
> > @@ -4186,8 +4190,25 @@ int iscsi_target_rx_thread(void *arg)
> >  	if (!conn->conn_transport->iscsit_get_rx_pdu)
> >  		return 0;
> >  
> > +	/*
> > +	 * If the iscsi connection is over a loopback device from using
> > +	 * iscsi and iscsit on the same system, we need to set
> > memalloc_noio to
> > +	 * prevent memory allocation deadlocks between target and
> > initiator.
> > +	 */
> > +	rcu_read_lock();
> > +	dst = rcu_dereference(conn->sock->sk->sk_dst_cache);
> > +	if (dst && dst->dev && dst->dev->flags & IFF_LOOPBACK)
> > +		loopback = true;
> > +	rcu_read_unlock();
> > +
> > +	if (loopback)
> > +		flags = memalloc_noio_save();
> > +
> >  	conn->conn_transport->iscsit_get_rx_pdu(conn);
> >  
> > +	if (loopback)
> > +		memalloc_noio_restore(flags);
> > +
> >  	if (!signal_pending(current))
> >  		atomic_set(&conn->transport_failed, 1);
> >  	iscsit_take_action_for_connection_exit(conn, &conn_freed);
> 
> I had mentioned to Mike that this was already tested at a large
> customer and in our labs and resolved the deadlocks .
> 
> Regards
> Laurence Oberman
> 

Tested-by:   Laurence Oberman <loberman@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>

I hate  to nag here but we have a pressing customer issue and are keen
to get others to weigh in here.

Regards
Laurence



Thanks
Laurence

