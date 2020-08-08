Return-Path: <SRS0=ejtk=BS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB0C0C433DF
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Aug 2020 11:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC7F22065E
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Aug 2020 11:32:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S8PQscwt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgHHLcB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Aug 2020 07:32:01 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42918 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726125AbgHHLb7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Aug 2020 07:31:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596886317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=khr56tqitgbpYsYTYM2VRcEiOVSL+m4Xi7+Cn3YoZgI=;
        b=S8PQscwt9nL0dCFECQp6cpvfjrIzmFNtPsnYuBQA1P9WQg4D5Mi2rJxcd0jJU20Wf1GFkw
        Fg0yU7r8a3mQ0AUNJUOwoPLnX9AYq54Qosh31QGFwFdKn0FU2QhrnNVOcXc59YIvqYb9J0
        IydWaM98oe+PzDDi2X6JoZTBH+wdGUE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-ERh1RUInOA29DD9j-xkHBg-1; Sat, 08 Aug 2020 07:31:54 -0400
X-MC-Unique: ERh1RUInOA29DD9j-xkHBg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C35201DE0;
        Sat,  8 Aug 2020 11:31:40 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C7038AC2C;
        Sat,  8 Aug 2020 11:31:40 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 078BVdX0010897;
        Sat, 8 Aug 2020 07:31:39 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 078BVdQg010893;
        Sat, 8 Aug 2020 07:31:39 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Sat, 8 Aug 2020 07:31:39 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Joel Becker <jlbec@evilplan.org>,
        Christoph Hellwig <hch@lst.de>
cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: target core warning
Message-ID: <alpine.LRH.2.02.2008080725350.10490@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

I report that I get this warning on shutdown with the kernel 5.8. The 
warning is 100% reproducible.

Is it a known problem? Should I bisect it?

Mikulas

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 0 PID: 2777 at lib/refcount.c:28 refcount_warn_saturate+0xe1/0x100
Modules linked in: sha256_generic libsha256 blowfish_generic blowfish_common cbc essiv authenc dm_crypt dm_loop dm_mod dax msr iscsi_target_mod target_core_pscsi target_core_file target_core_mod configfs cpufreq_userspace cpufreq_powersave cpufreq_ondemand cpufreq_conservative autofs4 ipv6 ext4 crc32c_generic crc16 mbcache jbd2 hpfs nls_cp852 msdos fat snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore matroxfb_base matroxfb_g450 matroxfb_accel cfbfillrect cfbimgblt cfbcopyarea matroxfb_DAC1064 g450_pll matroxfb_misc floppy fuse powernow_k6 pcspkr evdev via_agp agpgart pata_it821x hid_generic usbhid hid sg e1000 ehci_pci pata_via uhci_hcd ehci_hcd libata usbcore usb_common unix
CPU: 0 PID: 2777 Comm: rmdir Not tainted 5.8.0 #1
Hardware name: System Manufacturer Product Name/VA-503, BIOS 4.51 PG 01/11/01
EIP: refcount_warn_saturate+0xe1/0x100
Code: 56 40 c1 c6 05 42 5f 47 c1 01 e8 fa 2d e4 ff 0f 0b 58 c3 8d b6 00 00 00 00 68 98 56 40 c1 c6 05 44 5f 47 c1 01 e8 df 2d e4 ff <0f> 0b 59 c3 eb 19 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
EAX: 00000026 EBX: deb83238 ECX: c145f08c EDX: c145f088
ESI: deb83098 EDI: e0a6d950 EBP: 00000000 ESP: de371ed0
DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068 EFLAGS: 00010286
CR0: 80050033 CR2: 082d6dfc CR3: 1e901000 CR4: 00000090
Call Trace:
 ? configfs_remove_default_groups+0x33/0x60 [configfs]
 ? target_fabric_drop_tpg+0xa/0x20 [target_core_mod]
 ? configfs_rmdir+0x193/0x2e0 [configfs]
 ? vfs_rmdir+0x53/0x160
 ? do_rmdir+0x144/0x180
 ? do_syscall_32_irqs_on+0x34/0x1a0
 ? exc_page_fault+0x183/0x3e0
 ? do_int80_syscall_32+0x6/0x20
 ? entry_INT80_32+0xf1/0xf1
---[ end trace 59dc38640589748b ]---

