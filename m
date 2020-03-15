Return-Path: <SRS0=ks1E=5A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29470C10DCE
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Mar 2020 17:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4CC4206B1
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Mar 2020 17:59:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GfOeItt0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbgCOR7Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Mar 2020 13:59:16 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44588 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728985AbgCOR7Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Mar 2020 13:59:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584295155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VPzudV6QdSHOqDNy4FSg18sWmWGQbJ2KncNyWIWgXeI=;
        b=GfOeItt0VTth5AmX5ZqowKkh3zAaMN2lKNsQrKNxSM/X4Jk0Tb6nBHV9c5laaLLPwOShtJ
        WUgd4opfGROXTRuNXK+Aej5SF4bM4QpHcpN5hx0wsK4I5CaB3vQUnObersuZ+nzqdfriR0
        CWefa9UpJUsZosLfAT81mFngykyx8Ao=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-loWalu3jMtOG8EyUS23MIQ-1; Sun, 15 Mar 2020 13:59:13 -0400
X-MC-Unique: loWalu3jMtOG8EyUS23MIQ-1
Received: by mail-qt1-f200.google.com with SMTP id q7so14491661qtp.16
        for <linux-scsi@vger.kernel.org>; Sun, 15 Mar 2020 10:59:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VPzudV6QdSHOqDNy4FSg18sWmWGQbJ2KncNyWIWgXeI=;
        b=qCKeCndoZCr+F85e0yQn/XAeO4RD4lckota2OvH8XKU7wzOc0XQv0KihfdNvbUd/Kk
         uf3I5aEXWjg0apOYbuGde6/HfFj7wRiwj/tHpu1KNsLB01XMzB+1nySnN1hqCB5MyvFl
         uBh+PIXyXVtPfU5/gfxFk18VKh8BKl2TJvImJCW3k+6nX++hUmQ0ouI5d1iBWj0oWJkm
         TApj5xGbVzsWDOHF+baHKpABLyvQXJd+TeO1Zaej+4m36jyeQNR6wZk9RFo9bTGHPeCY
         drWnXEL3C9McHwaUxwJgc9NXSpkvGQy9P5Ak2PUYEGkvRCdpD29NazbKzWv0Gs5RaAdz
         FVrg==
X-Gm-Message-State: ANhLgQ2SEUZt1V8K8vp5uvK0cySjQl3Vfkw/dxwkPTTE9Ixy+58JenMa
        dCUSISuVS2sQNjcxGrdNuP0fZRYgyyzaJyPxhg8iq97fxl0rH6EFRo2JJ9yJ495f6o0kB8x2+GL
        OfFN9cVXl6Ah4GU/k056LJg==
X-Received: by 2002:a0c:f744:: with SMTP id e4mr1079327qvo.9.1584295152903;
        Sun, 15 Mar 2020 10:59:12 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsXAfNYm+wKRmee/9RQiC7Ch+7yIv4sG1b8KTGqXJ9284TdjgFoUNnUjgm/QIQhXEKa9306ZQ==
X-Received: by 2002:a0c:f744:: with SMTP id e4mr1079310qvo.9.1584295152413;
        Sun, 15 Mar 2020 10:59:12 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e80:f1:2941:4bf6:8ce7:6ce9])
        by smtp.gmail.com with ESMTPSA id h138sm5103878qke.86.2020.03.15.10.59.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Mar 2020 10:59:11 -0700 (PDT)
Message-ID: <e57c1763dd99ea958c9834a53ae5688a775c9444.camel@redhat.com>
Subject: Re: commit ab118da4c10a70b8437f5c90ab77adae1835963e causes ib_srpt
 to fail connections served by target LIO
From:   Laurence Oberman <loberman@redhat.com>
To:     Max Gurtovoy <maxg@mellanox.com>,
        rdmadev <rdma-dev-team@redhat.com>, linux-rdma@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "Van Assche, Bart" <bvanassche@acm.org>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     Rupesh Girase <rgirase@redhat.com>
Date:   Sun, 15 Mar 2020 13:59:10 -0400
In-Reply-To: <0bef0089-0c46-8fb7-9e44-61654c641cbd@mellanox.com>
References: <88bab94d2fd72f3145835b4518bc63dda587add6.camel@redhat.com>
         <0bef0089-0c46-8fb7-9e44-61654c641cbd@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-5.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2020-03-15 at 18:47 +0200, Max Gurtovoy wrote:
> On 3/14/2020 11:30 PM, Laurence Oberman wrote:
> > Hello Bart, Leon and Max
> 
> Hi Laurence,
> 
> thanks for the great analysis and the fast response !!
> 
> > 
> > Max had reached out to me to test a new set of patches for SRQ.
> > I had not tested upstream ib_srpt on an LIO target for quite a
> > while,
> > only ib_srp client tests had been run of late.
> > During a baseline test before applying Max's patches it was
> > apparent
> > that something had broken ib_srpt connections within LIO target
> > since
> > 5.5.
> > 
> > Note thet ib_srp client connectivity with the commit functions
> > fine,
> > it's just the target that breaks with this commit.
> > 
> > After a long bisect this is the commit that seems to break it.
> > While it's not directly code in ib_srpt, its code in mlx5 vport
> > ethernet connectivity that then breaks ib_srpt connectivity over
> > mlx5
> > IB RDMA with LIO.
> 
> I was able to connect in loopback and also from remote initiator
> with 
> this commit.
> 
> So I'm not sure that this commit is broken.
> 
> I used Bart's scripts to configure the target and to connect to it
> in 
> loopback (after some modifications for the updated
> kernel/sysfs/configfs 
> interface).
> 
> I did see an issue to connect from remote initiator, but after
> reloading 
> openibd in the initiator side I was able to connect.
> 
> So I suspect you had the same issue - that also should be debugged.
> 
> > 
> > I will let Leon and others decide but reverting the below commit
> > allows
> > SRP connectivity to an LIO target to work again.
> 
> I added prints to "mlx5_core_modify_hca_vport_context" function and 
> found that we don't call it in "pure" mlx5 mode with PFs.
> 
> Maybe you can try it too...
> 
> I was able to check my patches on my system and I'll send them soon.
> 
> Thanks again Laurence and Bart.
> 
> > 
> > Max, I will test your new patches once we have a decision on this.
> > 
> > Client
> > Linux ibclient.lab.eng.bos.redhat.com 5.6.0-rc5+ #1 SMP Thu Mar 12
> > 16:58:19 EDT 2020 x86_64 x86_64 x86_64 GNU/Linux
> > 
> > Server with reverted commit
> > Linux fedstorage.bos.redhat.com 5.6.0-rc5+ #1 SMP Sat Mar 14
> > 16:39:35
> > EDT 2020 x86_64 x86_64 x86_64 GNU/Linux
> > 
> > commit ab118da4c10a70b8437f5c90ab77adae1835963e
> > Author: Leon Romanovsky <leonro@mellanox.com>
> > Date:   Wed Nov 13 12:03:47 2019 +0200
> > 
> >      net/mlx5: Don't write read-only fields in
> > MODIFY_HCA_VPORT_CONTEXT
> > command
> >      
> >      The MODIFY_HCA_VPORT_CONTEXT uses field_selector to mask
> > fields
> > needed
> >      to be written, other fields are required to be zero according
> > to
> > the
> >      HW specification. The supported fields are controlled by
> > bitfield
> >      and limited to vport state, node and port GUIDs.
> >      
> >      Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> >      Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> > b/drivers/net/ethernet/mellanox/mlx5
> > index 30f7848..1faac31f 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> > @@ -1064,26 +1064,13 @@ int
> > mlx5_core_modify_hca_vport_context(struct
> > mlx5_core_dev *dev,
> >   
> >          ctx = MLX5_ADDR_OF(modify_hca_vport_context_in, in,
> > hca_vport_context);
> >          MLX5_SET(hca_vport_context, ctx, field_select, req-
> > > field_select);
> > 
> > -       MLX5_SET(hca_vport_context, ctx, sm_virt_aware, req-
> > > sm_virt_aware);
> > 
> > -       MLX5_SET(hca_vport_context, ctx, has_smi, req->has_smi);
> > -       MLX5_SET(hca_vport_context, ctx, has_raw, req->has_raw);
> > -       MLX5_SET(hca_vport_context, ctx, vport_state_policy, req-
> > > policy);
> > 
> > -       MLX5_SET(hca_vport_context, ctx, port_physical_state, req-
> > > phys_state);
> > 
> > -       MLX5_SET(hca_vport_context, ctx, vport_state, req-
> > > vport_state);
> > 
> > -       MLX5_SET64(hca_vport_context, ctx, port_guid, req-
> > >port_guid);
> > -       MLX5_SET64(hca_vport_context, ctx, node_guid, req-
> > >node_guid);
> > -       MLX5_SET(hca_vport_context, ctx, cap_mask1, req-
> > >cap_mask1);
> > -       MLX5_SET(hca_vport_context, ctx, cap_mask1_field_select,
> > req-
> > > cap_mask1_perm);
> > 
> > -       MLX5_SET(hca_vport_context, ctx, cap_mask2, req-
> > >cap_mask2);
> > -       MLX5_SET(hca_vport_context, ctx, cap_mask2_field_select,
> > req-
> > > cap_mask2_perm);
> > 
> > -       MLX5_SET(hca_vport_context, ctx, lid, req->lid);
> > -       MLX5_SET(hca_vport_context, ctx, init_type_reply, req-
> > > init_type_reply);
> > 
> > -       MLX5_SET(hca_vport_context, ctx, lmc, req->lmc);
> > -       MLX5_SET(hca_vport_context, ctx, subnet_timeout, req-
> > > subnet_timeout);
> > 
> > -       MLX5_SET(hca_vport_context, ctx, sm_lid, req->sm_lid);
> > -       MLX5_SET(hca_vport_context, ctx, sm_sl, req->sm_sl);
> > -       MLX5_SET(hca_vport_context, ctx, qkey_violation_counter,
> > req-
> > > qkey_violation_counter);
> > 
> > -       MLX5_SET(hca_vport_context, ctx, pkey_violation_counter,
> > req-
> > > pkey_violation_counter);
> > 
> > +       if (req->field_select & MLX5_HCA_VPORT_SEL_STATE_POLICY)
> > +               MLX5_SET(hca_vport_context, ctx,
> > vport_state_policy,
> > +                        req->policy);
> > +       if (req->field_select & MLX5_HCA_VPORT_SEL_PORT_GUID)
> > +               MLX5_SET64(hca_vport_context, ctx, port_guid, req-
> > > port_guid);
> > 
> > +       if (req->field_select & MLX5_HCA_VPORT_SEL_NODE_GUID)
> > +               MLX5_SET64(hca_vport_context, ctx, node_guid, req-
> > > node_guid);
> > 
> >          err = mlx5_cmd_exec(dev, in, in_sz, out, sizeof(out));
> >   ex:
> >          kfree(in);
> >   
> > 
> 
> 


Hi Max
Re:

"
So I'm not sure that this commit is broken.
..
..
I added prints to "mlx5_core_modify_hca_vport_context" function and
found that we don't call it in "pure" mlx5 mode with PFs.

Maybe you can try it too...
"

The thing is without this commit we connect immediately, no delay no
issue and I am changing nothing else other than reverting here.

So this clearly has a bearing directly on the functionality.

I will look at adding more debug, but with this commit in there is nor
evidence even of an attempt to connect and fail.

Its silently faling.

Regards
Laurence




