Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D48EB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jun 2023 16:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbjF0QcN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jun 2023 12:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbjF0Qbr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2023 12:31:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888CF26A9
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 09:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687883405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/etYPH5rrYqaXjywsPoOykHk0ey+CBLdEp1RTnzRKPE=;
        b=C2w0YTdq22LnS5QRAD9Mofft+cDHXOHdoyltpY9D/aLjdK07PzoRKfhyrXW2xGG3JjP4QS
        FvaGGIA0Xh0f43F4ZVkd5my3ih/TJyQzbkxFfU7wx1RySVfiGFXa4vscfUXE9fqtxSeeK0
        6g2zPAtsSXya+OmAtbVDkayztKAmW0Y=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-370-u2gr1CWaPli53oT-xkM1dQ-1; Tue, 27 Jun 2023 12:30:01 -0400
X-MC-Unique: u2gr1CWaPli53oT-xkM1dQ-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-765986c0568so354451385a.1
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 09:30:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687883400; x=1690475400;
        h=mime-version:user-agent:content-transfer-encoding:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/etYPH5rrYqaXjywsPoOykHk0ey+CBLdEp1RTnzRKPE=;
        b=ShamRc9W/nU+EB/MyMa5Un/SMSTqm6dTL9fYHRrzDmBiLoouGiMjXn89ENoYhlnsjQ
         EP0IwxIYkKTZChNu7w9ZkoN6oSy4DdODD4QI8thxQlJ2PRV525B1hrQ7bYdipZ5BSlo+
         JbnYUD2cwMNFxKDfNcnu0Fc1iPMjvxdBbdZYE+ftR5xZLdvNPz5yKaVgognADelZ9qIu
         n/hi8xX3QRo92W4F1wLIDQPCjlULuhGiQdDgM6YJP7r6DYa6ltGeC6SzULxSr6kclTJm
         jagfOnb3yL46cFB9bB76sxq2Syx2y1idu7dCL4o5Fp8WsHcayX+HpXZoKxcffLwVrmVb
         iZUw==
X-Gm-Message-State: AC+VfDzrwbTBWR+z0y5mLIIT5IWUNz3lhccOy8wkPiPxEAe/OXYxs64K
        p0kS/GYOoEJX9I0ypubbvJeJx+vvoy9xzwy4yKhfNJbWc3u+8V3ucj4pTB3wJvC9naWl8Zh3phW
        A/QoB3Ur2WfHyUCJ/yUa9F/0wDl6M2emhFLcSfaOIHy0KL0Ixx/lV0Koj/4D+6/9Djf6EtfTaKf
        vdJDSxzA==
X-Received: by 2002:a05:620a:1a9e:b0:767:17a0:e849 with SMTP id bl30-20020a05620a1a9e00b0076717a0e849mr921965qkb.18.1687883400588;
        Tue, 27 Jun 2023 09:30:00 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4oSTTjbSF9uE02Unw47j2UulDLdXqc/UMxbuXQxPwHVy0e004AJjLsX2UI8+ivDqVQXev6og==
X-Received: by 2002:a05:620a:1a9e:b0:767:17a0:e849 with SMTP id bl30-20020a05620a1a9e00b0076717a0e849mr921932qkb.18.1687883400198;
        Tue, 27 Jun 2023 09:30:00 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:7f10:16a0:5672:9abf? ([2600:6c64:4e7f:603b:7f10:16a0:5672:9abf])
        by smtp.gmail.com with ESMTPSA id h13-20020ae9ec0d000000b007592f2016f4sm4078886qkg.110.2023.06.27.09.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 09:29:59 -0700 (PDT)
Message-ID: <7434b7a5aee12b78e522dbb7a53601f6cd5e7bd1.camel@redhat.com>
Subject: Panic: qla2xxx will panic the systems  when sending sg_write_same
 -T --lba=1 to a device that has no protection
From:   Laurence Oberman <loberman@redhat.com>
To:     linux-scsi <linux-scsi@vger.kernel.org>, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com
Cc:     djeffery@redhat.com, emilne@redhat.com, jpittman@redhat.com
Date:   Tue, 27 Jun 2023 12:29:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello

A customer discovered this on a RHEL 8.8 kernel but the issue also
exists upstream with the current code in 6.4 for example.

[  177.143279]  ? qla2xxx_dif_start_scsi_mq+0xcd8/0xce0 [qla2xxx]
[  177.149165]  ? internal_add_timer+0x42/0x70
[  177.153372]  qla2xxx_mqueuecommand+0x207/0x2b0 [qla2xxx]
[  177.158730]  scsi_queue_rq+0x2b7/0xc00
[  177.162501]  blk_mq_dispatch_rq_list+0x3ea/0x7e0

Simple reproducer to a LUN with no protection
sg_write_same -T --lba=3D1 /dev/sdxx  (or mpath)

With the device having no protection we land up with=20
SCSI_PROT_NORMAL being used so fall through to the BUG()

switch (scsi_get_prot_op(GET_CMD_SP(sp))) {
        case SCSI_PROT_READ_INSERT:
        case SCSI_PROT_WRITE_STRIP:
                total_bytes =3D data_bytes;
                data_bytes +=3D dif_bytes;             =20
                break;

        case SCSI_PROT_READ_STRIP:
        case SCSI_PROT_WRITE_INSERT:                                 =20
=C2=A0       case SCSI_PROT_READ_PASS:
        case SCSI_PROT_WRITE_PASS:
                total_bytes =3D data_bytes + dif_bytes; =20
                break;
        default:
                BUG();
        }


I also had David Jeffery look at this and his comment was

In this particular case, it looks like the issue is just with qla2xxx,
regardless of the hardware. The scsi_disk being sent the command had no
dif protection enabled and there was no dix data.

crash> struct scsi_disk.protection_type 0xff34947432176800
  protection_type =3D 0 '\000',

crash> px ((struct scsi_cmnd *)0xff3494740b759138)->prot_sdb[0]
$7 =3D {
  table =3D {
    sgl =3D 0xff3494740b7595a8,
    nents =3D 0x0,
    orig_nents =3D 0x0
  },
  length =3D 0x0,
  resid =3D 0x0
}

So a WRITE_SAME_32 prot_op was always going to be SCSI_PROT_NORMAL in
prot_op. qla2xxx should not crash when passed such a command and state.


KDUMP  =20
Linux
segstorage3
6.4.0+

[  176.960932] ------------[ cut here ]------------
[  176.965582] kernel BUG at drivers/scsi/qla2xxx/qla_iocb.c:1459!
[  176.971540] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[  176.976795] CPU: 10 PID: 16058 Comm: sg_write_same Kdump: loaded
Tainted: G S                 6.4.0+ #1
[  176.986240] Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380
Gen10, BIOS U30 05/17/2022
[  176.994812] RIP: 0010:qla2xxx_dif_start_scsi_mq+0xcd8/0xce0
[qla2xxx]
[  177.001337] Code: ff ff 48 8b 7c 24 40 0f b7 bf 4c 01 00 00 e9 73 f6
ff ff 83 3d 68 a0 de ff 01 0f 8e 7b fd ff ff e9 6f fd ff ff e8 b8 7f 07
ce <0f> 0b 66 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90
[  177.020217] RSP: 0018:ffffa1c44f86b9e0 EFLAGS: 00010046
[  177.025470] RAX: 0000000000000008 RBX: ffff961087e29000 RCX:
0000000000000000
[  177.032644] RDX: 0000000000000000 RSI: ffff9617c9e09460 RDI:
0000000000000200
[  177.039818] RBP: ffff9617c9e09588 R08: ffff9617c9e09460 R09:
0000000000000200
[  177.046992] R10: ffff96107800e880 R11: 0000000000000000 R12:
00000000000010c0
[  177.054165] R13: ffff96107800e880 R14: ffff961064c52180 R15:
ffff961066f8de00
[  177.061337] FS:  00007f41eef7e740(0000) GS:ffff961f4d800000(0000)
knlGS:0000000000000000
[  177.069471] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  177.075246] CR2: 000055e1e2591bd8 CR3: 00000008823b2005 CR4:
00000000007706e0
[  177.082420] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  177.089594] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[  177.096768] PKRU: 55555554
[  177.099487] Call Trace:
[  177.101944]  <TASK>
[  177.104052]  ? __die_body+0x1e/0x60
[  177.107560]  ? die+0x3c/0x60
[  177.110454]  ? do_trap+0xe6/0x110
[  177.113786]  ? qla2xxx_dif_start_scsi_mq+0xcd8/0xce0 [qla2xxx]
[  177.119674]  ? do_error_trap+0x65/0x80
[  177.123442]  ? qla2xxx_dif_start_scsi_mq+0xcd8/0xce0 [qla2xxx]
[  177.129328]  ? exc_invalid_op+0x50/0x70
[  177.133184]  ? qla2xxx_dif_start_scsi_mq+0xcd8/0xce0 [qla2xxx]
[  177.139071]  ? asm_exc_invalid_op+0x1a/0x20
[  177.143279]  ? qla2xxx_dif_start_scsi_mq+0xcd8/0xce0 [qla2xxx]
[  177.149165]  ? internal_add_timer+0x42/0x70
[  177.153372]  qla2xxx_mqueuecommand+0x207/0x2b0 [qla2xxx]
[  177.158730]  scsi_queue_rq+0x2b7/0xc00
[  177.162501]  blk_mq_dispatch_rq_list+0x3ea/0x7e0
[  177.167143]  __blk_mq_sched_dispatch_requests+0xac/0x670
[  177.172485]  ? blk_rq_map_user_iov+0x2ae/0x690
[  177.176952]  ? blk_mq_request_bypass_insert+0x74/0xa0
[  177.182031]  blk_mq_sched_dispatch_requests+0x37/0x70
[  177.187110]  blk_mq_run_hw_queue+0x183/0x1b0
[  177.191402]  blk_execute_rq+0x103/0x230
[  177.195257]  sg_io+0x17f/0x360
[  177.198327]  scsi_ioctl_sg_io+0x69/0x90
[  177.202182]  scsi_ioctl+0x4c6/0x890
[  177.205688]  ? scsi_block_when_processing_errors+0x26/0xd0
[  177.211204]  ? multipath_prepare_ioctl+0x50/0x130 [dm_multipath]
[  177.217247]  dm_blk_ioctl+0x72/0x120 [dm_mod]
[  177.221637]  blkdev_ioctl+0x1c2/0x280
[  177.225320]  __x64_sys_ioctl+0x90/0xd0
[  177.229089]  do_syscall_64+0x3b/0x90
[  177.232683]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[  177.237762] RIP: 0033:0x7f41ee4397cb
[  177.241355] Code: 73 01 c3 48 8b 0d bd 56 38 00 f7 d8 64 89 01 48 83
c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 00 00 00 0f
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8d 56 38 00 f7 d8 64 89 01 48
[  177.260234] RSP: 002b:00007ffe44cf3578 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  177.267846] RAX: ffffffffffffffda RBX: 000055e1e25909a0 RCX:
00007f41ee4397cb
[  177.275018] RDX: 00007ffe44cf3580 RSI: 0000000000002285 RDI:
0000000000000003
[  177.282191] RBP: 0000000000000003 R08: 0000000000000040 R09:
000055e1e2590a50
[  177.289363] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[  177.296535] R13: 00007ffe44cf3638 R14: 000055e1e25909a0 R15:
00007ffe44cf3890

