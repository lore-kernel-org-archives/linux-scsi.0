Return-Path: <SRS0=ks1E=5A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45243C0044D
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Mar 2020 01:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D1E12076A
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Mar 2020 01:31:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G6Ap19A2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgCOBbD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 Mar 2020 21:31:03 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31131 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727201AbgCOBbD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 14 Mar 2020 21:31:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584235862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=8CoCO9BuyBEqvya4HXtKrOYdV1k6uEasDFwQvH0OSFY=;
        b=G6Ap19A2auvfl6ez1xdcmCuz6vliRH9eAuy7vMzivmo/8u76QUteceWBtt7ix66zgGHnrR
        kxO64FnDokJlSbs8YbCu0/p5eNC8CeLAPho7Jjt7aoVysyQJ2lCmhOkUvB3wjCX8SpdGCp
        GKvKufcdLq5wyZZsW8nQZZ83RMUSAv0=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-mVcR2dqKPWizJBGm_jYRiw-1; Sat, 14 Mar 2020 17:30:04 -0400
X-MC-Unique: mVcR2dqKPWizJBGm_jYRiw-1
Received: by mail-qt1-f198.google.com with SMTP id d6so12402334qtn.2
        for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2020 14:30:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=8CoCO9BuyBEqvya4HXtKrOYdV1k6uEasDFwQvH0OSFY=;
        b=ZPlP50M2pjOHQHAS61qNcM9soT5o7ehXvMbvoJAjVuDA+zCQhvSKacMuN2lt54kaQr
         aBSqNpmIYG2P7y7BCGjx0aCmCDS4pO/zORKeX613czN0w/8AE4hFM17+Qy7UzebfXzYL
         GXBHHepzkK/TCYPq3EKeZGPGV2HvJyAkvsZInXsfPzuG6QP3m9Kjbc+GgV+dzdVqGvlJ
         fwFwdjVUQ9jbYxJkFxnWDlEHxSVuq+OKIlowRiT2zyk0T6hOoiFOTOLOo6rT+rHc+Al2
         aI6t2idO+5AC8FeFp0hbHyYIwI6VsEohb4m6t0LJ3rndHnIJZ4ipEoArZCAxzs6QlIqv
         bIvA==
X-Gm-Message-State: ANhLgQ2ohtKQNqQ99dFGdQXVswLxIDNifZd4H780Vf9iDS/GS4QT+2Xb
        xYUjMTsxJZyBciWSwOVmqAaKcihXtoxv7jykCF9wz2EL8WkNJRlNYmvEfNnXUXbCTIqPEE7ZN7+
        iC6/wzuWLryfRHjJTMOaH3g==
X-Received: by 2002:a37:e47:: with SMTP id 68mr19006889qko.17.1584221403749;
        Sat, 14 Mar 2020 14:30:03 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvjuBBhQnSSAQJ+lHpYB4VtMAI5AzGTFEGz6x2A/AuiKNu/LQLlUeUxMBnLiVarSP8wOZWR8w==
X-Received: by 2002:a37:e47:: with SMTP id 68mr19006878qko.17.1584221403364;
        Sat, 14 Mar 2020 14:30:03 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e80:f1:2941:4bf6:8ce7:6ce9])
        by smtp.gmail.com with ESMTPSA id a15sm5646320qko.122.2020.03.14.14.30.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 Mar 2020 14:30:02 -0700 (PDT)
Message-ID: <88bab94d2fd72f3145835b4518bc63dda587add6.camel@redhat.com>
Subject: commit ab118da4c10a70b8437f5c90ab77adae1835963e causes ib_srpt to
 fail connections served by target LIO
From:   Laurence Oberman <loberman@redhat.com>
To:     rdmadev <rdma-dev-team@redhat.com>, linux-rdma@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "Van Assche, Bart" <bvanassche@acm.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     Rupesh Girase <rgirase@redhat.com>
Date:   Sat, 14 Mar 2020 17:30:00 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-5.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Bart, Leon and Max

Max had reached out to me to test a new set of patches for SRQ.
I had not tested upstream ib_srpt on an LIO target for quite a while,
only ib_srp client tests had been run of late.
During a baseline test before applying Max's patches it was apparent
that something had broken ib_srpt connections within LIO target since
5.5.

Note thet ib_srp client connectivity with the commit functions fine, 
it's just the target that breaks with this commit.

After a long bisect this is the commit that seems to break it.
While it's not directly code in ib_srpt, its code in mlx5 vport
ethernet connectivity that then breaks ib_srpt connectivity over mlx5
IB RDMA with LIO.

I will let Leon and others decide but reverting the below commit allows
SRP connectivity to an LIO target to work again.

Max, I will test your new patches once we have a decision on this.

Client
Linux ibclient.lab.eng.bos.redhat.com 5.6.0-rc5+ #1 SMP Thu Mar 12
16:58:19 EDT 2020 x86_64 x86_64 x86_64 GNU/Linux

Server with reverted commit
Linux fedstorage.bos.redhat.com 5.6.0-rc5+ #1 SMP Sat Mar 14 16:39:35
EDT 2020 x86_64 x86_64 x86_64 GNU/Linux

commit ab118da4c10a70b8437f5c90ab77adae1835963e
Author: Leon Romanovsky <leonro@mellanox.com>
Date:   Wed Nov 13 12:03:47 2019 +0200

    net/mlx5: Don't write read-only fields in MODIFY_HCA_VPORT_CONTEXT
command
    
    The MODIFY_HCA_VPORT_CONTEXT uses field_selector to mask fields
needed
    to be written, other fields are required to be zero according to
the
    HW specification. The supported fields are controlled by bitfield
    and limited to vport state, node and port GUIDs.
    
    Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
    Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
b/drivers/net/ethernet/mellanox/mlx5
index 30f7848..1faac31f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -1064,26 +1064,13 @@ int mlx5_core_modify_hca_vport_context(struct
mlx5_core_dev *dev,
 
        ctx = MLX5_ADDR_OF(modify_hca_vport_context_in, in,
hca_vport_context);
        MLX5_SET(hca_vport_context, ctx, field_select, req-
>field_select);
-       MLX5_SET(hca_vport_context, ctx, sm_virt_aware, req-
>sm_virt_aware);
-       MLX5_SET(hca_vport_context, ctx, has_smi, req->has_smi);
-       MLX5_SET(hca_vport_context, ctx, has_raw, req->has_raw);
-       MLX5_SET(hca_vport_context, ctx, vport_state_policy, req-
>policy);
-       MLX5_SET(hca_vport_context, ctx, port_physical_state, req-
>phys_state);
-       MLX5_SET(hca_vport_context, ctx, vport_state, req-
>vport_state);
-       MLX5_SET64(hca_vport_context, ctx, port_guid, req->port_guid);
-       MLX5_SET64(hca_vport_context, ctx, node_guid, req->node_guid);
-       MLX5_SET(hca_vport_context, ctx, cap_mask1, req->cap_mask1);
-       MLX5_SET(hca_vport_context, ctx, cap_mask1_field_select, req-
>cap_mask1_perm);
-       MLX5_SET(hca_vport_context, ctx, cap_mask2, req->cap_mask2);
-       MLX5_SET(hca_vport_context, ctx, cap_mask2_field_select, req-
>cap_mask2_perm);
-       MLX5_SET(hca_vport_context, ctx, lid, req->lid);
-       MLX5_SET(hca_vport_context, ctx, init_type_reply, req-
>init_type_reply);
-       MLX5_SET(hca_vport_context, ctx, lmc, req->lmc);
-       MLX5_SET(hca_vport_context, ctx, subnet_timeout, req-
>subnet_timeout);
-       MLX5_SET(hca_vport_context, ctx, sm_lid, req->sm_lid);
-       MLX5_SET(hca_vport_context, ctx, sm_sl, req->sm_sl);
-       MLX5_SET(hca_vport_context, ctx, qkey_violation_counter, req-
>qkey_violation_counter);
-       MLX5_SET(hca_vport_context, ctx, pkey_violation_counter, req-
>pkey_violation_counter);
+       if (req->field_select & MLX5_HCA_VPORT_SEL_STATE_POLICY)
+               MLX5_SET(hca_vport_context, ctx, vport_state_policy,
+                        req->policy);
+       if (req->field_select & MLX5_HCA_VPORT_SEL_PORT_GUID)
+               MLX5_SET64(hca_vport_context, ctx, port_guid, req-
>port_guid);
+       if (req->field_select & MLX5_HCA_VPORT_SEL_NODE_GUID)
+               MLX5_SET64(hca_vport_context, ctx, node_guid, req-
>node_guid);
        err = mlx5_cmd_exec(dev, in, in_sz, out, sizeof(out));
 ex:
        kfree(in);
 

