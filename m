Return-Path: <SRS0=ks1E=5A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB8A0C10F29
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Mar 2020 18:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 730DD206B1
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Mar 2020 18:36:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M28jGrQW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgCOSg3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Mar 2020 14:36:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37217 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727399AbgCOSg3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Mar 2020 14:36:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584297387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jraVrUBAI4D3MXQsq3TmgeIZw7JcaGlpDsWUNKo06Fs=;
        b=M28jGrQWc8Gqhn1FKCllBRDTyV12hUIh/ZOuBErGoruFGUo++IfoT0tFpuYQMgQEMavBXd
        8kAvXfJzoVLowp13AYr4fJIQ8MLdzV6T81JF/dX+1bsrTtAYHh2ANhuBo+njwCyAs3qfH8
        V9GInntM4UoE1i5THnMPAr5yKgOa/OM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-CctG6Gy1OlS4GobhLLjUcg-1; Sun, 15 Mar 2020 14:36:24 -0400
X-MC-Unique: CctG6Gy1OlS4GobhLLjUcg-1
Received: by mail-qk1-f200.google.com with SMTP id m6so15164380qkm.2
        for <linux-scsi@vger.kernel.org>; Sun, 15 Mar 2020 11:36:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jraVrUBAI4D3MXQsq3TmgeIZw7JcaGlpDsWUNKo06Fs=;
        b=JjcDuxHKWsoPtZQEn4bb+x53KnVTFDeCacN4u+5O7vTmiP/Hd1m/Qvkts5WCxF1S6f
         uVOKp/FzxoAkeMMM3zMlpb4taKcEygj8uguTgef6HmQUtC5JdpsK3nkbIew307+2T5dj
         XHNUCwfi94t5G5C4nBQIDvul5h8p2oQLkICziDAceC14HtoQrNDD5wClv4nwPbZ0UEJo
         kztu76x1SuRECD31IOIdJAd12zQPAlQleO/PQgsXVFI+LQLMWZFJw1Olsh4pb6s9Uchy
         mm6KcoYMIxvB/BY4+rs9hnoNTfHoJMLdrQS0a0IlG7Yp6N0MM9f/deSt9x7pEMsWL9CD
         cu+w==
X-Gm-Message-State: ANhLgQ2dmWkivfBVeYZcrC7YHG8IPN7fkWjHOBpDUi7I9rbpXnTpeDGU
        i6p/BIoaqDXUdSAhAhOVABPtC2AAFwpQ1QHGxSAvuMVS5w+A2CtpvEad7t3CmU0Vy3Im9OMq3Jr
        WRAONV1G45u7B8E3f5NUzxA==
X-Received: by 2002:ac8:4d97:: with SMTP id a23mr22290644qtw.176.1584297383581;
        Sun, 15 Mar 2020 11:36:23 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vunsX0q3xmZdLOAEoyGAmZ0EIoG3NKStfcrN0CnQx5lBeaC5IN6/COGh9OcvTSt8SN+PM05CQ==
X-Received: by 2002:ac8:4d97:: with SMTP id a23mr22290621qtw.176.1584297383173;
        Sun, 15 Mar 2020 11:36:23 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e80:f1:2941:4bf6:8ce7:6ce9])
        by smtp.gmail.com with ESMTPSA id r29sm12550925qkk.85.2020.03.15.11.36.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Mar 2020 11:36:22 -0700 (PDT)
Message-ID: <8695fb0f34588616aded629127cc3fa2799fa7cb.camel@redhat.com>
Subject: Re: commit ab118da4c10a70b8437f5c90ab77adae1835963e causes ib_srpt
 to fail connections served by target LIO
From:   Laurence Oberman <loberman@redhat.com>
To:     Max Gurtovoy <maxg@mellanox.com>,
        rdmadev <rdma-dev-team@redhat.com>, linux-rdma@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "Van Assche, Bart" <bvanassche@acm.org>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     Rupesh Girase <rgirase@redhat.com>
Date:   Sun, 15 Mar 2020 14:36:21 -0400
In-Reply-To: <6d5415e3-9314-331a-fade-7593c6a27290@mellanox.com>
References: <88bab94d2fd72f3145835b4518bc63dda587add6.camel@redhat.com>
         <0bef0089-0c46-8fb7-9e44-61654c641cbd@mellanox.com>
         <e57c1763dd99ea958c9834a53ae5688a775c9444.camel@redhat.com>
         <6d5415e3-9314-331a-fade-7593c6a27290@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-5.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2020-03-15 at 20:20 +0200, Max Gurtovoy wrote:
> On 3/15/2020 7:59 PM, Laurence Oberman wrote:
> > On Sun, 2020-03-15 at 18:47 +0200, Max Gurtovoy wrote:
> > > On 3/14/2020 11:30 PM, Laurence Oberman wrote:
> > > > Hello Bart, Leon and Max
> > > 
> > > Hi Laurence,
> > > 
> > > thanks for the great analysis and the fast response !!
> > > 
> > > > Max had reached out to me to test a new set of patches for SRQ.
> > > > I had not tested upstream ib_srpt on an LIO target for quite a
> > > > while,
> > > > only ib_srp client tests had been run of late.
> > > > During a baseline test before applying Max's patches it was
> > > > apparent
> > > > that something had broken ib_srpt connections within LIO target
> > > > since
> > > > 5.5.
> > > > 
> > > > Note thet ib_srp client connectivity with the commit functions
> > > > fine,
> > > > it's just the target that breaks with this commit.
> > > > 
> > > > After a long bisect this is the commit that seems to break it.
> > > > While it's not directly code in ib_srpt, its code in mlx5 vport
> > > > ethernet connectivity that then breaks ib_srpt connectivity
> > > > over
> > > > mlx5
> > > > IB RDMA with LIO.
> > > 
> > > I was able to connect in loopback and also from remote initiator
> > > with
> > > this commit.
> > > 
> > > So I'm not sure that this commit is broken.
> > > 
> > > I used Bart's scripts to configure the target and to connect to
> > > it
> > > in
> > > loopback (after some modifications for the updated
> > > kernel/sysfs/configfs
> > > interface).
> > > 
> > > I did see an issue to connect from remote initiator, but after
> > > reloading
> > > openibd in the initiator side I was able to connect.
> > > 
> > > So I suspect you had the same issue - that also should be
> > > debugged.
> > > 
> > > > I will let Leon and others decide but reverting the below
> > > > commit
> > > > allows
> > > > SRP connectivity to an LIO target to work again.
> > > 
> > > I added prints to "mlx5_core_modify_hca_vport_context" function
> > > and
> > > found that we don't call it in "pure" mlx5 mode with PFs.
> > > 
> > > Maybe you can try it too...
> > > 
> > > I was able to check my patches on my system and I'll send them
> > > soon.
> > > 
> > > Thanks again Laurence and Bart.
> > > 
> > > > Max, I will test your new patches once we have a decision on
> > > > this.
> > > > 
> > > > Client
> > > > Linux ibclient.lab.eng.bos.redhat.com 5.6.0-rc5+ #1 SMP Thu Mar
> > > > 12
> > > > 16:58:19 EDT 2020 x86_64 x86_64 x86_64 GNU/Linux
> > > > 
> > > > Server with reverted commit
> > > > Linux fedstorage.bos.redhat.com 5.6.0-rc5+ #1 SMP Sat Mar 14
> > > > 16:39:35
> > > > EDT 2020 x86_64 x86_64 x86_64 GNU/Linux
> > > > 
> > > > commit ab118da4c10a70b8437f5c90ab77adae1835963e
> > > > Author: Leon Romanovsky <leonro@mellanox.com>
> > > > Date:   Wed Nov 13 12:03:47 2019 +0200
> > > > 
> > > >       net/mlx5: Don't write read-only fields in
> > > > MODIFY_HCA_VPORT_CONTEXT
> > > > command
> > > >       
> > > >       The MODIFY_HCA_VPORT_CONTEXT uses field_selector to mask
> > > > fields
> > > > needed
> > > >       to be written, other fields are required to be zero
> > > > according
> > > > to
> > > > the
> > > >       HW specification. The supported fields are controlled by
> > > > bitfield
> > > >       and limited to vport state, node and port GUIDs.
> > > >       
> > > >       Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > > >       Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > > > 
> > > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> > > > b/drivers/net/ethernet/mellanox/mlx5
> > > > index 30f7848..1faac31f 100644
> > > > --- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> > > > @@ -1064,26 +1064,13 @@ int
> > > > mlx5_core_modify_hca_vport_context(struct
> > > > mlx5_core_dev *dev,
> > > >    
> > > >           ctx = MLX5_ADDR_OF(modify_hca_vport_context_in, in,
> > > > hca_vport_context);
> > > >           MLX5_SET(hca_vport_context, ctx, field_select, req-
> > > > > field_select);
> > > > 
> > > > -       MLX5_SET(hca_vport_context, ctx, sm_virt_aware, req-
> > > > > sm_virt_aware);
> > > > 
> > > > -       MLX5_SET(hca_vport_context, ctx, has_smi, req-
> > > > >has_smi);
> > > > -       MLX5_SET(hca_vport_context, ctx, has_raw, req-
> > > > >has_raw);
> > > > -       MLX5_SET(hca_vport_context, ctx, vport_state_policy,
> > > > req-
> > > > > policy);
> > > > 
> > > > -       MLX5_SET(hca_vport_context, ctx, port_physical_state,
> > > > req-
> > > > > phys_state);
> > > > 
> > > > -       MLX5_SET(hca_vport_context, ctx, vport_state, req-
> > > > > vport_state);
> > > > 
> > > > -       MLX5_SET64(hca_vport_context, ctx, port_guid, req-
> > > > > port_guid);
> > > > 
> > > > -       MLX5_SET64(hca_vport_context, ctx, node_guid, req-
> > > > > node_guid);
> > > > 
> > > > -       MLX5_SET(hca_vport_context, ctx, cap_mask1, req-
> > > > > cap_mask1);
> > > > 
> > > > -       MLX5_SET(hca_vport_context, ctx,
> > > > cap_mask1_field_select,
> > > > req-
> > > > > cap_mask1_perm);
> > > > 
> > > > -       MLX5_SET(hca_vport_context, ctx, cap_mask2, req-
> > > > > cap_mask2);
> > > > 
> > > > -       MLX5_SET(hca_vport_context, ctx,
> > > > cap_mask2_field_select,
> > > > req-
> > > > > cap_mask2_perm);
> > > > 
> > > > -       MLX5_SET(hca_vport_context, ctx, lid, req->lid);
> > > > -       MLX5_SET(hca_vport_context, ctx, init_type_reply, req-
> > > > > init_type_reply);
> > > > 
> > > > -       MLX5_SET(hca_vport_context, ctx, lmc, req->lmc);
> > > > -       MLX5_SET(hca_vport_context, ctx, subnet_timeout, req-
> > > > > subnet_timeout);
> > > > 
> > > > -       MLX5_SET(hca_vport_context, ctx, sm_lid, req->sm_lid);
> > > > -       MLX5_SET(hca_vport_context, ctx, sm_sl, req->sm_sl);
> > > > -       MLX5_SET(hca_vport_context, ctx,
> > > > qkey_violation_counter,
> > > > req-
> > > > > qkey_violation_counter);
> > > > 
> > > > -       MLX5_SET(hca_vport_context, ctx,
> > > > pkey_violation_counter,
> > > > req-
> > > > > pkey_violation_counter);
> > > > 
> > > > +       if (req->field_select &
> > > > MLX5_HCA_VPORT_SEL_STATE_POLICY)
> > > > +               MLX5_SET(hca_vport_context, ctx,
> > > > vport_state_policy,
> > > > +                        req->policy);
> > > > +       if (req->field_select & MLX5_HCA_VPORT_SEL_PORT_GUID)
> > > > +               MLX5_SET64(hca_vport_context, ctx, port_guid,
> > > > req-
> > > > > port_guid);
> > > > 
> > > > +       if (req->field_select & MLX5_HCA_VPORT_SEL_NODE_GUID)
> > > > +               MLX5_SET64(hca_vport_context, ctx, node_guid,
> > > > req-
> > > > > node_guid);
> > > > 
> > > >           err = mlx5_cmd_exec(dev, in, in_sz, out,
> > > > sizeof(out));
> > > >    ex:
> > > >           kfree(in);
> > > >    
> > > > 
> > 
> > Hi Max
> > Re:
> > 
> > "
> > So I'm not sure that this commit is broken.
> > ..
> > ..
> > I added prints to "mlx5_core_modify_hca_vport_context" function and
> > found that we don't call it in "pure" mlx5 mode with PFs.
> > 
> > Maybe you can try it too...
> > "
> > 
> > The thing is without this commit we connect immediately, no delay
> > no
> > issue and I am changing nothing else other than reverting here.
> > 
> > So this clearly has a bearing directly on the functionality.
> > 
> > I will look at adding more debug, but with this commit in there is
> > nor
> > evidence even of an attempt to connect and fail.
> > 
> > Its silently faling.
> 
> please send me all the configuration steps you run after booting the 
> target + steps in the initiator (can be also in attached file).
> 
> I'll try to follow this.
> 
> Btw, did you try loopback initiator ?
> 
> -Max.
> 
> 
> > 
> > Regards
> > Laurence
> > 
> > 
> > 
> > 
> 
> 

Hi Max

Did not try loopback because here we have actual physical connectity as
that is what our customers use.

Connected back to back with MLX5 cx4 HCA dual ports at EDR 100
Thi sis my standard configuration used for all upstream and Red Hat
kernel testing.

Reboot server and client and then first prepare server

Server
----------

the prepare.sh script run is after boot on the server


#!/bin/bash
./load_modules.sh
./create_ramdisk.sh
targetcli restoreconfig
# Set the srp_sq_size
for i in
/sys/kernel/config/target/srpt/0xfe800000000000007cfe900300726e4e
/sys/kernel/config/target/srpt/0xfe800000000000007cfe900300726e4f
do 
	echo 16384 > $i/tpgt_1/attrib/srp_sq_size
done

[root@fedstorage ~]# cat load_modules.sh 
#!/bin/bash
modprobe mlx5_ib
modprobe ib_srpt
modprobe ib_srp
modprobe ib_umad

[root@fedstorage ~]# cat ./create_ramdisk.sh
#!/bin/bash
mount -t tmpfs -o size=130g tmpfs /mnt
cd /mnt
for i in `seq 1 30`; do dd if=/dev/zero of=block-$i bs=1024k count=4000
; done



Client
--------

Once server is ready

Run ./start_opensm.sh on client (I sont use the SM on a switch as we
are back to back)

[root@ibclient ~]# cat ./start_opensm.sh 
#!/bin/bash
rmmod ib_srpt
opensm -F opensm.1.conf &
opensm -F opensm.2.conf &

I will semail the conf only to you as well as the targecli config as th
eout is long.


Then run start_srp.sh

[root@ibclient ~]# cat ./start_srp.sh 
run_srp_daemon  -V -f /etc/ddn/srp_daemon.conf -R 30 -T 10 -t 7000
-ance -i mlx5_0 -p 1 1>/root/srp1.log 2>&1 &
run_srp_daemon  -V -f /etc/ddn/srp_daemon.conf -R 30 -T 10 -t 7000
-ance -i mlx5_1 -p 1 1>/root/srp2.log 2>&1 &

[root@ibclient ~]# cat /etc/ddn/srp_daemon.conf
a      queue_size=128,max_cmd_per_lun=32,max_sect=32768





