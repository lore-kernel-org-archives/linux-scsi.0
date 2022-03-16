Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BAC2C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Mar 2022 03:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343543AbiCPDQk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 23:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234584AbiCPDQj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 23:16:39 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881295E15C
        for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2022 20:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1647400525; x=1678936525;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sot0AHJlgUVRnIwhyXKoN29inAL00VIRRNbp8RwgRFM=;
  b=SMjJQM3UmiDgTPpB/VCK+CVJlap78VNHjFYYGSyowX4QvRX411WRZT8l
   FN2H46fLmSzZFpUQW/KegkqA91tI3MmqQ7ah4eUZ/ko/WdF60q57K7Jhm
   oWNWCxheknoEKLr+WQB3wy7xtBymdPW2+tLqs7rUn5FuokpR4HTV5BxCN
   OnPBeLIlFO+rsZFNLPXFnL4FCut7oA26xz9z+6jAnP+AMdaNKGeL+C4eQ
   PKbU2sm055iE3yhcDCQXxvOrab9XnWkCpkQf5XM7+FdXyaqjXJlKc1tJ7
   g42rM1/MraucKZL2aHWaY8LgjSzxGXvASJH5/DB92TQ6bRQCjX/7qJlx9
   w==;
X-IronPort-AV: E=Sophos;i="5.90,185,1643644800"; 
   d="scan'208";a="196401912"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Mar 2022 11:15:25 +0800
IronPort-SDR: USu+F7MmvHKa51TGAGHRDBfc3dw7R+7lEJHApc2q8WLwLOUPRooExu9j3K5tk1ORsUcANb+vdd
 qU6zYybUN/4fysIgQyud3uh0gStNfMU067U1fXBqHJxA5zwbwaR5IqtrdS5QrFNv66/nR2Mf27
 7ubS7cArfbDHKiorzHQQR6b0Znfn/zo/hByT7z4e59XaVOdbFAC0VhmKofpblZSY+HRugwQbOz
 DDhTrwrOB5nairpHyVlI1rOMPBoJuG/OXkRee568MEjiduZ2e7AytW3UUY6rwdqNbDq/meTMN8
 M6L6l/L1iErSu8oE0l9dl8wi
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 19:46:31 -0700
IronPort-SDR: O8ua0cs+hFuj17PmOz5rywL+G1Hh/ZTNYFjwHchPbujoDEwpQ38/XSNGhggzbtJQ2QY4iMbm8K
 WxIYGQOv6tStkXhB/CpsUf02P8r7505ZHTNgvtGG1VzcWZacHVJPu/zOVyBMYyxlwaa4PiNJvM
 N8oMFuogOywtAhJeSK4IYtHXWRrm4Viet3x8FYgFAp4S6ODTndINlusE2lQMAdaXE0AxEkNLuO
 xPiv7UvZLah16jQbmnDHnGyYcsDCSIzpTuH2KPZToCBo1WFHhXEkPrXHyNuiutcEHlDUIGOUQf
 PKQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 20:15:25 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KJFlJ3KYWz1Rwrw
        for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2022 20:15:24 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1647400524;
         x=1649992525; bh=sot0AHJlgUVRnIwhyXKoN29inAL00VIRRNbp8RwgRFM=; b=
        h0Xu092QLP3Rv2l5misvR0qsAFS4U7GHrOTVGOodX4MD2iNFhtm+QqeJmIxJZ0q0
        eBd2OwViQYLYr3chsXiAp4QWwMkQLMTTY+nvvv/KQvY27BrQposN8/9MPIQaaEup
        j2r8e50dbFYf0q12KwT6Mi39SqbLoCJk1+94kqSEfz/RYpQwokMSMkNqi2zVJKeZ
        5l20mZUfQlcpgV9oj1MWqOhfu3F7b4wkth6uGmNJbIXjF5wSjcK0MChO4YWy3C2m
        qO/HV9ybAonbzGe8/V9c7MdHC9jw6vVYfVcarR3MBAC34v1V7l/vRGY5yjvju08q
        z3cREFcnMVtqWtpTWLl5wA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id PQAuP_uoe4_i for <linux-scsi@vger.kernel.org>;
        Tue, 15 Mar 2022 20:15:24 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KJFlH0CgHz1Rvlx;
        Tue, 15 Mar 2022 20:15:22 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH] scsi: mpt3sas: fix use after free in _scsih_expander_node_remove()
Date:   Wed, 16 Mar 2022 12:15:21 +0900
Message-Id: <20220316031521.422488-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The function mpt3sas_transport_port_remove() called in
_scsih_expander_node_remove() frees the port field of the sas_expander
structure, leading to the following use-after-free spat from Kasan when
the ioc_info() call following that function is executed (e.g. when doing
rmmod of the driver module):

[ 3479.371167] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ 3479.378496] BUG: KASAN: use-after-free in _scsih_expander_node_remove+=
0x710/0x750 [mpt3sas]
[ 3479.386936] Read of size 1 at addr ffff8881c037691c by task rmmod/1531
[ 3479.393524]
[ 3479.395035] CPU: 18 PID: 1531 Comm: rmmod Not tainted 5.17.0-rc8+ #143=
6
[ 3479.401712] Hardware name: Supermicro Super Server/H12SSL-NT, BIOS 2.1=
 06/02/2021
[ 3479.409263] Call Trace:
[ 3479.411743]  <TASK>
[ 3479.413875]  dump_stack_lvl+0x45/0x59
[ 3479.417582]  print_address_description.constprop.0+0x1f/0x120
[ 3479.423389]  ? _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
[ 3479.429469]  kasan_report.cold+0x83/0xdf
[ 3479.433438]  ? _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
[ 3479.439514]  _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
[ 3479.445411]  ? _raw_spin_unlock_irqrestore+0x2d/0x40
[ 3479.452032]  scsih_remove+0x525/0xc90 [mpt3sas]
[ 3479.458212]  ? mpt3sas_expander_remove+0x1d0/0x1d0 [mpt3sas]
[ 3479.465529]  ? down_write+0xde/0x150
[ 3479.470746]  ? up_write+0x14d/0x460
[ 3479.475840]  ? kernfs_find_ns+0x137/0x310
[ 3479.481438]  pci_device_remove+0x65/0x110
[ 3479.487013]  __device_release_driver+0x316/0x680
[ 3479.493180]  driver_detach+0x1ec/0x2d0
[ 3479.498499]  bus_remove_driver+0xe7/0x2d0
[ 3479.504081]  pci_unregister_driver+0x26/0x250
[ 3479.510033]  _mpt3sas_exit+0x2b/0x6cf [mpt3sas]
[ 3479.516144]  __x64_sys_delete_module+0x2fd/0x510
[ 3479.522315]  ? free_module+0xaa0/0xaa0
[ 3479.527593]  ? __cond_resched+0x1c/0x90
[ 3479.532951]  ? lockdep_hardirqs_on_prepare+0x273/0x3e0
[ 3479.539607]  ? syscall_enter_from_user_mode+0x21/0x70
[ 3479.546161]  ? trace_hardirqs_on+0x1c/0x110
[ 3479.551828]  do_syscall_64+0x35/0x80
[ 3479.556884]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 3479.563402] RIP: 0033:0x7f1fc482483b
...
[ 3479.943087] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Fix this by reversing the calls to ioc_info() and
mpt3sas_transport_port_remove().

Fixes: 7d310f241001 ("scsi: mpt3sas: Get device objects using sas_address=
 & portID")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
index 00792767c620..a3a898262f2d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11055,15 +11055,15 @@ _scsih_expander_node_remove(struct MPT3SAS_ADAP=
TER *ioc,
 			    mpt3sas_port->hba_port);
 	}
=20
-	mpt3sas_transport_port_remove(ioc, sas_expander->sas_address,
-	    sas_expander->sas_address_parent, sas_expander->port);
-
 	ioc_info(ioc,
 	    "expander_remove: handle(0x%04x), sas_addr(0x%016llx), port:%d\n",
 	    sas_expander->handle, (unsigned long long)
 	    sas_expander->sas_address,
 	    sas_expander->port->port_id);
=20
+	mpt3sas_transport_port_remove(ioc, sas_expander->sas_address,
+	    sas_expander->sas_address_parent, sas_expander->port);
+
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	list_del(&sas_expander->list);
 	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
--=20
2.35.1

