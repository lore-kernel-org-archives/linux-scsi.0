Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B20DCEB64D9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jun 2023 18:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjF0Sxc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jun 2023 14:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbjF0SxZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2023 14:53:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1842B198E
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 11:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687891956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c+Zi/oera/3LL+9ypI16CIM2ISxTUbuF03rotFQrqRI=;
        b=AbW6bN1lqQVJt9F4GZRTx6efVnZqiVRTvTby24iQe5JQpMsYIdenQC4HcISYvy+gOfQXTV
        BWk9Tutz3QrzboOCh4bRTc66Qc54jqOKNkSgXIA8v+i+jXoskfO8tiiwxQksW4YEJTmGJx
        55YjIb57DFwF1FAot9PmoFu5879wHTY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-198-wOACCNTTOvy4vjbe61b8rw-1; Tue, 27 Jun 2023 14:52:31 -0400
X-MC-Unique: wOACCNTTOvy4vjbe61b8rw-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-63511adcf45so42933216d6.2
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 11:52:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687891950; x=1690483950;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c+Zi/oera/3LL+9ypI16CIM2ISxTUbuF03rotFQrqRI=;
        b=lybXfxMHxGglkep3fDt+WuOeNNcJk0W932pxAQgmP3KdkZk12Q9KxTXNmHTTPnhdCy
         GUjaQ86guRYZgDhgnpON41S0qm6Q10HAX7llp6h5jyVWEApsetNSjkncz7VEQ8gt1nDC
         ngKzhdhrTNXnmgwhWgEiDHDr7UUV8PM94UF1sQ9d2ArkduU0tbw5DSa/LzvM558Z5lyG
         FIJqnF7E4vi/op7z5wmRwUZugFRbe1Rgm1JKRergpghLnQ/GGxzfaj2flIbKthGYLSd7
         cEOtVoRVhZ4BJKFpE4cd9u1grhhahtkrrX+rv5YSqEzRh0/DKIT3tI38/4BnBB7uCjY9
         YeZg==
X-Gm-Message-State: AC+VfDxzoGYhoaiLxglkiWoay9CHcE/FwAcdXa6oInUpWVWnDgz6brz2
        d7wzZnBc0zTTD8Jn/CA9xCDipkUHuFS/VCoEYZsnONvMav6MPkHQAAI7MAJ620sOPzoMb7RbF9F
        N9vZG/OsEkbuSNumA/yMji85+LsDspvmpoqS0Rgd5CM5O3u/K3bay+867SzS0EgWhKrBLbnWuec
        1YUPEQ/Q==
X-Received: by 2002:a05:6214:2483:b0:635:dbb4:853e with SMTP id gi3-20020a056214248300b00635dbb4853emr9224141qvb.54.1687891950228;
        Tue, 27 Jun 2023 11:52:30 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6Ue70uUIGS+FrfHjB5L8S2P+EqNlquHQv2sPJ+MzEGNkYv/0KCuB0n6IanANnj220yYKbqAQ==
X-Received: by 2002:a05:6214:2483:b0:635:dbb4:853e with SMTP id gi3-20020a056214248300b00635dbb4853emr9224123qvb.54.1687891949767;
        Tue, 27 Jun 2023 11:52:29 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:7f10:16a0:5672:9abf? ([2600:6c64:4e7f:603b:7f10:16a0:5672:9abf])
        by smtp.gmail.com with ESMTPSA id nd9-20020a056214420900b0062de51d8a12sm2566100qvb.26.2023.06.27.11.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 11:52:29 -0700 (PDT)
Message-ID: <593e219f550340347db776bce90a4987f5309218.camel@redhat.com>
Subject: Re: Panic: qla2xxx will panic the systems  when sending
 sg_write_same -T --lba=1 to a device that has no protection
From:   Laurence Oberman <loberman@redhat.com>
To:     linux-scsi <linux-scsi@vger.kernel.org>, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com
Cc:     djeffery@redhat.com, emilne@redhat.com, jpittman@redhat.com
Date:   Tue, 27 Jun 2023 14:52:28 -0400
In-Reply-To: <7434b7a5aee12b78e522dbb7a53601f6cd5e7bd1.camel@redhat.com>
References: <7434b7a5aee12b78e522dbb7a53601f6cd5e7bd1.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-06-27 at 12:29 -0400, Laurence Oberman wrote:
> Hello
>=20
> A customer discovered this on a RHEL 8.8 kernel but the issue also
> exists upstream with the current code in 6.4 for example.
>=20
> [=C2=A0 177.143279]=C2=A0 ? qla2xxx_dif_start_scsi_mq+0xcd8/0xce0 [qla2xx=
x]
> [=C2=A0 177.149165]=C2=A0 ? internal_add_timer+0x42/0x70
> [=C2=A0 177.153372]=C2=A0 qla2xxx_mqueuecommand+0x207/0x2b0 [qla2xxx]
> [=C2=A0 177.158730]=C2=A0 scsi_queue_rq+0x2b7/0xc00
> [=C2=A0 177.162501]=C2=A0 blk_mq_dispatch_rq_list+0x3ea/0x7e0
>=20
> Simple reproducer to a LUN with no protection
> sg_write_same -T --lba=3D1 /dev/sdxx=C2=A0 (or mpath)
>=20
> With the device having no protection we land up with=20
> SCSI_PROT_NORMAL being used so fall through to the BUG()
>=20
> switch (scsi_get_prot_op(GET_CMD_SP(sp))) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case SCSI_PROT_READ_INSERT:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case SCSI_PROT_WRITE_STRIP:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 total_bytes =3D data_bytes;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 data_bytes +=3D dif_bytes;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 break;
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case SCSI_PROT_READ_STRIP:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case SCSI_PROT_WRITE_INSERT:=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case SCSI_PROT_READ_PASS:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case SCSI_PROT_WRITE_PASS:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 total_bytes =3D data_bytes + dif_bytes;=C2=A0=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 break;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 default:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 BUG();
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
>=20
> I also had David Jeffery look at this and his comment was
>=20
> In this particular case, it looks like the issue is just with
> qla2xxx,
> regardless of the hardware. The scsi_disk being sent the command had
> no
> dif protection enabled and there was no dix data.
>=20
> crash> struct scsi_disk.protection_type 0xff34947432176800
> =C2=A0 protection_type =3D 0 '\000',
>=20
> crash> px ((struct scsi_cmnd *)0xff3494740b759138)->prot_sdb[0]
> $7 =3D {
> =C2=A0 table =3D {
> =C2=A0=C2=A0=C2=A0 sgl =3D 0xff3494740b7595a8,
> =C2=A0=C2=A0=C2=A0 nents =3D 0x0,
> =C2=A0=C2=A0=C2=A0 orig_nents =3D 0x0
> =C2=A0 },
> =C2=A0 length =3D 0x0,
> =C2=A0 resid =3D 0x0
> }
>=20
> So a WRITE_SAME_32 prot_op was always going to be SCSI_PROT_NORMAL in
> prot_op. qla2xxx should not crash when passed such a command and
> state.
>=20
>=20
> KDUMP=C2=A0=C2=A0=20
> Linux
> segstorage3
> 6.4.0+
>=20
> [=C2=A0 176.960932] ------------[ cut here ]------------
> [=C2=A0 176.965582] kernel BUG at drivers/scsi/qla2xxx/qla_iocb.c:1459!
> [=C2=A0 176.971540] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> [=C2=A0 176.976795] CPU: 10 PID: 16058 Comm: sg_write_same Kdump: loaded
> Tainted: G S=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 6.4.0+ #1
> [=C2=A0 176.986240] Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL38=
0
> Gen10, BIOS U30 05/17/2022
> [=C2=A0 176.994812] RIP: 0010:qla2xxx_dif_start_scsi_mq+0xcd8/0xce0
> [qla2xxx]
> [=C2=A0 177.001337] Code: ff ff 48 8b 7c 24 40 0f b7 bf 4c 01 00 00 e9 73
> f6
> ff ff 83 3d 68 a0 de ff 01 0f 8e 7b fd ff ff e9 6f fd ff ff e8 b8 7f
> 07
> ce <0f> 0b 66 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90
> 90
> [=C2=A0 177.020217] RSP: 0018:ffffa1c44f86b9e0 EFLAGS: 00010046
> [=C2=A0 177.025470] RAX: 0000000000000008 RBX: ffff961087e29000 RCX:
> 0000000000000000
> [=C2=A0 177.032644] RDX: 0000000000000000 RSI: ffff9617c9e09460 RDI:
> 0000000000000200
> [=C2=A0 177.039818] RBP: ffff9617c9e09588 R08: ffff9617c9e09460 R09:
> 0000000000000200
> [=C2=A0 177.046992] R10: ffff96107800e880 R11: 0000000000000000 R12:
> 00000000000010c0
> [=C2=A0 177.054165] R13: ffff96107800e880 R14: ffff961064c52180 R15:
> ffff961066f8de00
> [=C2=A0 177.061337] FS:=C2=A0 00007f41eef7e740(0000) GS:ffff961f4d800000(=
0000)
> knlGS:0000000000000000
> [=C2=A0 177.069471] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 000000008005003=
3
> [=C2=A0 177.075246] CR2: 000055e1e2591bd8 CR3: 00000008823b2005 CR4:
> 00000000007706e0
> [=C2=A0 177.082420] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [=C2=A0 177.089594] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [=C2=A0 177.096768] PKRU: 55555554
> [=C2=A0 177.099487] Call Trace:
> [=C2=A0 177.101944]=C2=A0 <TASK>
> [=C2=A0 177.104052]=C2=A0 ? __die_body+0x1e/0x60
> [=C2=A0 177.107560]=C2=A0 ? die+0x3c/0x60
> [=C2=A0 177.110454]=C2=A0 ? do_trap+0xe6/0x110
> [=C2=A0 177.113786]=C2=A0 ? qla2xxx_dif_start_scsi_mq+0xcd8/0xce0 [qla2xx=
x]
> [=C2=A0 177.119674]=C2=A0 ? do_error_trap+0x65/0x80
> [=C2=A0 177.123442]=C2=A0 ? qla2xxx_dif_start_scsi_mq+0xcd8/0xce0 [qla2xx=
x]
> [=C2=A0 177.129328]=C2=A0 ? exc_invalid_op+0x50/0x70
> [=C2=A0 177.133184]=C2=A0 ? qla2xxx_dif_start_scsi_mq+0xcd8/0xce0 [qla2xx=
x]
> [=C2=A0 177.139071]=C2=A0 ? asm_exc_invalid_op+0x1a/0x20
> [=C2=A0 177.143279]=C2=A0 ? qla2xxx_dif_start_scsi_mq+0xcd8/0xce0 [qla2xx=
x]
> [=C2=A0 177.149165]=C2=A0 ? internal_add_timer+0x42/0x70
> [=C2=A0 177.153372]=C2=A0 qla2xxx_mqueuecommand+0x207/0x2b0 [qla2xxx]
> [=C2=A0 177.158730]=C2=A0 scsi_queue_rq+0x2b7/0xc00
> [=C2=A0 177.162501]=C2=A0 blk_mq_dispatch_rq_list+0x3ea/0x7e0
> [=C2=A0 177.167143]=C2=A0 __blk_mq_sched_dispatch_requests+0xac/0x670
> [=C2=A0 177.172485]=C2=A0 ? blk_rq_map_user_iov+0x2ae/0x690
> [=C2=A0 177.176952]=C2=A0 ? blk_mq_request_bypass_insert+0x74/0xa0
> [=C2=A0 177.182031]=C2=A0 blk_mq_sched_dispatch_requests+0x37/0x70
> [=C2=A0 177.187110]=C2=A0 blk_mq_run_hw_queue+0x183/0x1b0
> [=C2=A0 177.191402]=C2=A0 blk_execute_rq+0x103/0x230
> [=C2=A0 177.195257]=C2=A0 sg_io+0x17f/0x360
> [=C2=A0 177.198327]=C2=A0 scsi_ioctl_sg_io+0x69/0x90
> [=C2=A0 177.202182]=C2=A0 scsi_ioctl+0x4c6/0x890
> [=C2=A0 177.205688]=C2=A0 ? scsi_block_when_processing_errors+0x26/0xd0
> [=C2=A0 177.211204]=C2=A0 ? multipath_prepare_ioctl+0x50/0x130 [dm_multip=
ath]
> [=C2=A0 177.217247]=C2=A0 dm_blk_ioctl+0x72/0x120 [dm_mod]
> [=C2=A0 177.221637]=C2=A0 blkdev_ioctl+0x1c2/0x280
> [=C2=A0 177.225320]=C2=A0 __x64_sys_ioctl+0x90/0xd0
> [=C2=A0 177.229089]=C2=A0 do_syscall_64+0x3b/0x90
> [=C2=A0 177.232683]=C2=A0 entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> [=C2=A0 177.237762] RIP: 0033:0x7f41ee4397cb
> [=C2=A0 177.241355] Code: 73 01 c3 48 8b 0d bd 56 38 00 f7 d8 64 89 01 48
> 83
> c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 00 00 00
> 0f
> 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8d 56 38 00 f7 d8 64 89 01
> 48
> [=C2=A0 177.260234] RSP: 002b:00007ffe44cf3578 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [=C2=A0 177.267846] RAX: ffffffffffffffda RBX: 000055e1e25909a0 RCX:
> 00007f41ee4397cb
> [=C2=A0 177.275018] RDX: 00007ffe44cf3580 RSI: 0000000000002285 RDI:
> 0000000000000003
> [=C2=A0 177.282191] RBP: 0000000000000003 R08: 0000000000000040 R09:
> 000055e1e2590a50
> [=C2=A0 177.289363] R10: 0000000000000000 R11: 0000000000000246 R12:
> 0000000000000000
> [=C2=A0 177.296535] R13: 00007ffe44cf3638 R14: 000055e1e25909a0 R15:
> 00007ffe44cf3890

Hello Nilesh,
This is not a final patchand will need a cleanup but something I came
up with that will prevent the panic. You probably have better ideas.
I have not signed it as its just a suggestion.


    [PATCH] scsi: qla2xxx avoid a panic due to BUG() if
     a command is sent to a device that has no protection.
   =20
    If a device does not have protection, qla2xx will land up
    defaulting to a BUG() and system panic.
    This is because SCSI_PROT_NORMAL is matched and the
    default used to be BUG().
    This patch avoids the BUG() and prints a WARN
   =20
   =20
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c
b/drivers/scsi/qla2xxx/qla_iocb.c
index b9b3e6f80ea9..3fca7c7b7a92 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1443,6 +1443,12 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct
cmd_type_crc_2 *cmd_pkt,
        dif_bytes =3D (data_bytes / blk_size) * 8;
=20
        switch (scsi_get_prot_op(GET_CMD_SP(sp))) {
+       case SCSI_PROT_NORMAL:
+               total_bytes =3D data_bytes;
+               WARN(1, "device has no protection, command sent
expecting\
+                        DIF or DIX protection with proto_op=3D%d",
+                       cmd->prot_op);
+               break;
        case SCSI_PROT_READ_INSERT:
        case SCSI_PROT_WRITE_STRIP:
                total_bytes =3D data_bytes;



sg_write_same -T --lba=3D1 /dev/mapper/mpathz1

[root@segstorage3 ~]# sg_write_same -T --lba=3D1 /dev/mapper/mpathz1
Write same: transport: Host_status=3D0x07 [DID_ERROR]
Driver_status=3D0x00 [DRIVER_OK]

Write same(32): Sense category: -1, try '-v' option for more
information
Some error occurred, try again with '-v' or '-vv' for more information

segstorage3 login: [  785.431935] ------------[ cut here ]------------
[  785.436586] device has no protection, command sent
expecting			DIF or DIX protection with proto_op=3D0
[  785.436635] WARNING: CPU: 39 PID: 20588 at
drivers/scsi/qla2xxx/qla_iocb.c:1450
qla2xxx_dif_start_scsi_mq+0x4b4/0xd40 [qla2xxx]

[  785.534337] CPU: 39 PID: 20588 Comm: sg_write_same Kdump: loaded
Tainted: G S      W          6.4.0+ #1
[  785.543782] Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380
Gen10, BIOS U30 05/17/2022
[  785.552353] RIP: 0010:qla2xxx_dif_start_scsi_mq+0x4b4/0xd40
[qla2xxx]
[  785.558853] Code: b6 b0 98 00 00 00 48 c7 c7 e0 e9 79 c0 44 89 5c 24
74 89 44 24 70 44 89 4c 24 6c 4c 89 54 24 60 4c 89 44 24 50 e8 dc 67 9e
c0 <0f> 0b 48 8b b5 98 00 00 00 44 8b 4c 24 6c 4c 8b 44 24 50 4c 8b 54
[  785.577731] RSP: 0018:ffffc9000d527988 EFLAGS: 00010086
[  785.582985] RAX: 0000000000000000 RBX: ffff8881160c6000 RCX:
0000000000000027
[  785.590160] RDX: 0000000000000027 RSI: 00000000ffdfffff RDI:
ffff88900dae0848
[  785.597333] RBP: ffff88884be0f948 R08: 0000000000000000 R09:
c0000000ffdfffff
[  785.604506] R10: 0000000000000001 R11: ffffc9000d527820 R12:
0000000000001c68
[  785.611680] R13: ffff8881539d8d80 R14: ffff88813370eb40 R15:
ffff888105910800
[  785.618853] FS:  00007fd53861a740(0000) GS:ffff88900dac0000(0000)
knlGS:0000000000000000
[  785.626987] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  785.632762] CR2: 0000556d74bfabd8 CR3: 000000087696c003 CR4:
00000000007706e0
[  785.639936] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  785.647110] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[  785.654283] PKRU: 55555554
[  785.657002] Call Trace:
[  785.659461]  <TASK>
[  785.661571]  ? __warn+0x85/0x140
[  785.664819]  ? qla2xxx_dif_start_scsi_mq+0x4b4/0xd40 [qla2xxx]
[  785.670709]  ? report_bug+0xfc/0x1e0
[  785.674306]  ? handle_bug+0x3f/0x70
[  785.677815]  ? exc_invalid_op+0x17/0x70
[  785.681669]  ? asm_exc_invalid_op+0x1a/0x20
[  785.685880]  ? qla2xxx_dif_start_scsi_mq+0x4b4/0xd40 [qla2xxx]
[  785.691767]  ? qla2xxx_dif_start_scsi_mq+0x4b4/0xd40 [qla2xxx]
[  785.697651]  qla2xxx_mqueuecommand+0x207/0x2b0 [qla2xxx]
[  785.703007]  scsi_queue_rq+0x2b7/0xc00
[  785.706781]  blk_mq_dispatch_rq_list+0x3ea/0x7e0
[  785.711426]  __blk_mq_sched_dispatch_requests+0xac/0x670
[  785.716770]  ? blk_rq_map_user_iov+0x2ae/0x690
[  785.721238]  ? blk_mq_request_bypass_insert+0x74/0xa0
[  785.726317]  blk_mq_sched_dispatch_requests+0x37/0x70
[  785.731395]  blk_mq_run_hw_queue+0x183/0x1b0
[  785.735688]  blk_execute_rq+0x103/0x230
[  785.739545]  sg_io+0x17f/0x360
[  785.742614]  scsi_ioctl_sg_io+0x69/0x90
[  785.746470]  scsi_ioctl+0x4c6/0x890
[  785.749974]  ? scsi_block_when_processing_errors+0x26/0xd0
[  785.755489]  ? multipath_prepare_ioctl+0x50/0x130 [dm_multipath]
[  785.761531]  dm_blk_ioctl+0x72/0x120 [dm_mod]
[  785.765925]  dm_blk_ioctl+0x72/0x120 [dm_mod]
[  785.770312]  blkdev_ioctl+0x1c2/0x280
[  785.773995]  __x64_sys_ioctl+0x90/0xd0
[  785.777767]  do_syscall_64+0x3b/0x90
[  785.781360]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[  785.786440] RIP: 0033:0x7fd537a397cb
[  785.790034] Code: 73 01 c3 48 8b 0d bd 56 38 00 f7 d8 64 89 01 48 83
c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 00 00 00 0f
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8d 56 38 00 f7 d8 64 89 01 48
[  785.808912] RSP: 002b:00007ffdef6ef068 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  785.816524] RAX: ffffffffffffffda RBX: 0000556d74bf99a0 RCX:
00007fd537a397cb
[  785.823699] RDX: 00007ffdef6ef070 RSI: 0000000000002285 RDI:
0000000000000003
[  785.830873] RBP: 0000000000000003 R08: 0000000000000040 R09:
0000556d74bf9a50
[  785.838046] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[  785.845221] R13: 00007ffdef6ef128 R14: 0000556d74bf99a0 R15:
00007ffdef6ef380
[  785.852396]  </TASK>
[  785.854590] ---[ end trace 0000000000000000 ]---

