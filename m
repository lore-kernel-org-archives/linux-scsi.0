Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8611C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 21:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A31220795
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 21:08:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="MfZMe/tz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgIOVIn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 17:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727716AbgIOVIb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 17:08:31 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44003C06174A
        for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2020 14:08:31 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id c13so5531788oiy.6
        for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2020 14:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=LDekHbwFZghs1RUtaBp9A4+jkOD9LpvIN6BztS/FctI=;
        b=MfZMe/tze/iCQOEBz+yc+pcslUjz+z3l0/5/87MDl4jCG7w/whRP1btthEgIrjvjp/
         TpbdeNwwsgn05eVvjYPtzZbVGdBsTdkuF/Yu7fnawy1k410B69K71suK8blytx8GTD/j
         6tz0xOSX056y2wUogzRQPvvV10ZYz6PEvOfAg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=LDekHbwFZghs1RUtaBp9A4+jkOD9LpvIN6BztS/FctI=;
        b=Anj2uJ2zEVDZwc0zcE1E3hyfAIafejvYLJvZNWiYVwCP12Z4/GZ+qpb11XuU6+w8hZ
         CIQ/tnX6JRjl7+7eNGAJ1TbDfE8Kha6VX6Zg6XnV/5zLt1f0R6s2D0vVrrVSnHHTwNLj
         1RB3BdMew9gASErDx8A1YrOLnqlEf/QJhJCdhkS2CkqesqprgudjQ17oIPBzpMWnzt8X
         0HCdMnKIKBMNHUd1IsDAPxzk375BLJeajE9UmzN8e0IsyiAoEQllGD9fy8aLWutmjdjm
         4Fx7JwyJboXUEO7R32wqP5SlJKOadyn0RGzHgXefIDbdjJW5XuAZWw71qcP6tWthD8ni
         4e/Q==
X-Gm-Message-State: AOAM5328Y53vyz6eruqbkMFmNK1aTdRQ7ScUFIfAKxn2PgE9J43LzIDk
        PkdONeeiV4jr7Q/SdU2LOY+Fr9suB9N+n9nL
X-Google-Smtp-Source: ABdhPJy6iji+2PsbAH0OqBiGHa5zr9xX2M06eKJ42G09d7TjRZgKHKBaTTCSrxLAnORQV2c/41v14g==
X-Received: by 2002:aca:f302:: with SMTP id r2mr876362oih.151.1600204110536;
        Tue, 15 Sep 2020 14:08:30 -0700 (PDT)
Received: from localhost.localdomain ([2600:1700:6970:bea0:ad6f:84dd:178e:bab3])
        by smtp.gmail.com with ESMTPSA id z92sm1926090otb.22.2020.09.15.14.08.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2020 14:08:29 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.0.3.2.26\))
Subject: Re: [PATCH] scsi: alua: fix the race between alua_bus_detach and
 alua_rtpg
From:   Brian Bunker <brian@purestorage.com>
In-Reply-To: <1600167537-12509-1-git-send-email-jitendra.khasdev@oracle.com>
Date:   Tue, 15 Sep 2020 14:08:28 -0700
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com, hare@suse.com,
        loberman@redhat.com, joe.jin@oracle.com, junxiao.bi@oracle.com,
        gulam.mohamed@oracle.com,
        "RITIKA.SRIVASTAVA@oracle.com" <RITIKA.SRIVASTAVA@ORACLE.COM>,
        linux-scsi@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E1362654-C1EC-4971-BFA6-07BF56592540@purestorage.com>
References: <1600167537-12509-1-git-send-email-jitendra.khasdev@oracle.com>
To:     Jitendra Khasdev <jitendra.khasdev@oracle.com>
X-Mailer: Apple Mail (2.3654.0.3.2.26)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Jitendra,

It seems that we are in the same place trying to fix the same thing for =
what is likely our same shared customer. Do you want to try to =
incorporate anything from our fix from PURE? Like maybe remove the =
BUG_ON lines from alua_rtpg if you are sure that the race is eliminated =
with your patch?

See:
https://marc.info/?l=3Dlinux-scsi&m=3D159984129611701&w=3D2
https://marc.info/?l=3Dlinux-scsi&m=3D159983931810954&w=3D2
https://marc.info/?l=3Dlinux-scsi&m=3D159971849210795&w=3D2

Thanks,
Brian

Brian Bunker
SW Eng
brian@purestorage.com



> On Sep 15, 2020, at 3:58 AM, Jitendra Khasdev =
<jitendra.khasdev@oracle.com> wrote:
>=20
> This is patch to fix the race occurs between bus detach and alua_rtpg.
>=20
> It fluses the all pending workqueue in bus detach handler, so it can =
avoid
> race between alua_bus_detach and alua_rtpg.
>=20
> Here is call trace where race got detected.
>=20
> multipathd call stack:
> [exception RIP: native_queued_spin_lock_slowpath+100]
> --- <NMI exception stack> ---
> native_queued_spin_lock_slowpath at ffffffff89307f54
> queued_spin_lock_slowpath at ffffffff89307c18
> _raw_spin_lock_irq at ffffffff89bd797b
> alua_bus_detach at ffffffff8984dcc8
> scsi_dh_release_device at ffffffff8984b6f2
> scsi_device_dev_release_usercontext at ffffffff89846edf
> execute_in_process_context at ffffffff892c3e60
> scsi_device_dev_release at ffffffff8984637c
> device_release at ffffffff89800fbc
> kobject_cleanup at ffffffff89bb1196
> kobject_put at ffffffff89bb12ea
> put_device at ffffffff89801283
> scsi_device_put at ffffffff89838d5b
> scsi_disk_put at ffffffffc051f650 [sd_mod]
> sd_release at ffffffffc051f8a2 [sd_mod]
> __blkdev_put at ffffffff8952c79e
> blkdev_put at ffffffff8952c80c
> blkdev_close at ffffffff8952c8b5
> __fput at ffffffff894e55e6
> ____fput at ffffffff894e57ee
> task_work_run at ffffffff892c94dc
> exit_to_usermode_loop at ffffffff89204b12
> do_syscall_64 at ffffffff892044da
> entry_SYSCALL_64_after_hwframe at ffffffff89c001b8
>=20
> kworker:
> [exception RIP: alua_rtpg+2003]
> account_entity_dequeue at ffffffff892e42c1
> alua_rtpg_work at ffffffff8984f097
> process_one_work at ffffffff892c4c29
> worker_thread at ffffffff892c5a4f
> kthread at ffffffff892cb135
> ret_from_fork at ffffffff89c00354
>=20
> Signed-off-by: Jitendra Khasdev <jitendra.khasdev@oracle.com>
> ---
> drivers/scsi/device_handler/scsi_dh_alua.c | 3 +++
> 1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c =
b/drivers/scsi/device_handler/scsi_dh_alua.c
> index f32da0c..024a752 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -1144,6 +1144,9 @@ static void alua_bus_detach(struct scsi_device =
*sdev)
> 	struct alua_dh_data *h =3D sdev->handler_data;
> 	struct alua_port_group *pg;
>=20
> +	sdev_printk(KERN_INFO, sdev, "%s: flushing workqueues\n", =
ALUA_DH_NAME);
> +	flush_workqueue(kaluad_wq);
> +
> 	spin_lock(&h->pg_lock);
> 	pg =3D rcu_dereference_protected(h->pg, =
lockdep_is_held(&h->pg_lock));
> 	rcu_assign_pointer(h->pg, NULL);
> --=20
> 1.8.3.1
>=20

