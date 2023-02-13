Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 733DFC636CC
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Feb 2023 16:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjBMQ13 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Feb 2023 11:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjBMQ12 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2023 11:27:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CFB24492
        for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2023 08:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676305563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5j1Ma1y2clXVYgy/SSzEPndVHrV3hCwEM5eslt7nI0Q=;
        b=ACfuxmpiTozfNiEh8+WM4eION2/6K9nNK26bm0rvbOpV12LGBnNxAhQb6VtCqA2dtszHqE
        H70bsC46ZB8p4s/zAK+Oxdo+RJPi/szaY6z+NQJb/NXzmX4yPfN2E8aFpCoutL/VkOOxGl
        zdikxL5ba5tpC0sdnw2qSKMtZjRonGk=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-98-986Ju9wzPV6wT_FKWhgRRw-1; Mon, 13 Feb 2023 11:25:59 -0500
X-MC-Unique: 986Ju9wzPV6wT_FKWhgRRw-1
Received: by mail-qt1-f197.google.com with SMTP id he22-20020a05622a601600b003ba3c280fabso7619219qtb.2
        for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2023 08:25:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5j1Ma1y2clXVYgy/SSzEPndVHrV3hCwEM5eslt7nI0Q=;
        b=EJqM5bHPUMfKEbx+lUH6CzcP2+1xXOxNlaCnO1rL8NbkRlvmOlRBU52lDyZZM2k3SD
         6U3VwrWDr9thLVrJKVi0lIcilsjSPdTW/qm94dvQVTOMN2Tv801NjDL6MXO4ChBx8yJF
         Oq7cN/qJUil018VOe3laGogBK9oCLQc0WFIGvEm+X+km6YoO2Ew0QS2MTyARhSKco9Oi
         Ypleg3QqEa1E05tShO34iX7ob3YMqkH5E77cJOYaCYuo2xz2FqJLEyhdmSfZKiSEeJJ1
         3F3YUH6M9vvRfWOxTXz9lW/eh2aT0wDr66QLAMZn0a0U/pM7jkQVEHV64zknutxFCMZ8
         ec0A==
X-Gm-Message-State: AO0yUKVoAPNb2ZyY4VXfGsKV2h+Ljv+WL/nkM5rnjhgYkY1Xr24GPJ+f
        dwYCUafQ0jaEHO08fsTMTdqPTYXFzAOg4Ob/od8oygJfNlCIcARUdef+FPgH1BtnGVVRpNfcaqW
        CHXHyf5v9TPFrh/pxs4c2cA==
X-Received: by 2002:ac8:4989:0:b0:3b9:bc8c:c200 with SMTP id f9-20020ac84989000000b003b9bc8cc200mr22568790qtq.11.1676305559045;
        Mon, 13 Feb 2023 08:25:59 -0800 (PST)
X-Google-Smtp-Source: AK7set8ovOjeDU1c4YFiSw/aT0D3JImyNrfY5/hhgcuAwbBF6PU988XxOtmfKk+J3NLmD9rXWS7L2A==
X-Received: by 2002:ac8:4989:0:b0:3b9:bc8c:c200 with SMTP id f9-20020ac84989000000b003b9bc8cc200mr22568756qtq.11.1676305558637;
        Mon, 13 Feb 2023 08:25:58 -0800 (PST)
Received: from lobep17 ([2600:6c64:4e7f:603b:6e24:8ff:feb9:533e])
        by smtp.gmail.com with ESMTPSA id e68-20020a37b547000000b0071aacb2c76asm10037678qkf.132.2023.02.13.08.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 08:25:58 -0800 (PST)
Message-ID: <e669443e4d5bbcce8c54c45de9b47e59f56f3b75.camel@redhat.com>
Subject: Re: [PATCH] scsi: target: iscsi: set memalloc_noio with loopback
 network connections
From:   Laurence Oberman <loberman@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        David Jeffery <djeffery@redhat.com>
Cc:     target-devel@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 13 Feb 2023 11:25:57 -0500
In-Reply-To: <2fea4b28-e441-6c77-5bb6-97428c19179f@oracle.com>
References: <20230208200957.14073-1-djeffery@redhat.com>
         <CAFL455kEoLQF+vc2MGmtLdrQ-=U+HJzqgknZmM54iCPJD1p_mA@mail.gmail.com>
         <2fea4b28-e441-6c77-5bb6-97428c19179f@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2023-02-13 at 10:22 -0600, Mike Christie wrote:
> On 2/13/23 5:59 AM, Maurizio Lombardi wrote:
> > st 8. 2. 2023 v 21:10 odesílatel David Jeffery <djeffery@redhat.com
> > > napsal:
> > > 
> > > +       /*
> > > +        * If the iscsi connection is over a loopback device from
> > > using
> > > +        * iscsi and iscsit on the same system, we need to set
> > > memalloc_noio to
> > > +        * prevent memory allocation deadlocks between target and
> > > initiator.
> > > +        */
> > > +       rcu_read_lock();
> > > +       dst = rcu_dereference(conn->sock->sk->sk_dst_cache);
> > > +       if (dst && dst->dev && dst->dev->flags & IFF_LOOPBACK)
> > > +               loopback = true;
> > > +       rcu_read_unlock();
> > 
> > Hi Mike,
> > I tested it, it works. The customer also confirmed that it fixes
> > the
> > deadlock on his setup.
> 
> You never responded about why/how it's used in production. Is it some
> sort
> of clustering or container or what?
> 
> The login related code can still swing back on you if it's run for a
> relogin.
> It would happen if we overqueue and a nop timesout because the iscsi
> recv thread
> is waiting for backend resources like a request/queue slot, or if
> management tools
> disable/enable the tpgt for reconfigs, etc.
> 

Hi Mike,
The use case described is as follows:


"This customer moved their on-premise system to the cloud.
Their on-premise system runs with two servers and one external storage
and uses data mirroring software to mirror data.

When moving to the cloud, customer wanted to implement a data mirror
using data mirror software with two instances to reduce the cost of
using the cloud infrastructure.
To build a system with two instances, we use iSCSI to mirror data
between a local disk on one instance and a local disk on the other
instance.
We coexist iSCSI initiator and target so that data mirroring software
can access each disk through a unified interface."

Thanks
Laurence

