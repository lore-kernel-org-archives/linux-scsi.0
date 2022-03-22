Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF18C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Mar 2022 05:59:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236977AbiCVGA0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Mar 2022 02:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237017AbiCVGAQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2022 02:00:16 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EDD27B29
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2022 22:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1647928727; x=1679464727;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7lynrs43AFuj+W0DPIFB8yBQxJilujfLhAUVSuVnQVg=;
  b=GGDleOKkfrwHhEEGi0Qp0/HhjhDouzAweDr56DgUu2QFWrjFg5uNBU8s
   WT2wGatyz4fQMeq/mhPZc4C3fATzBPDmJh92Rzcgb0pzK083TNFKW7Koi
   ojfYVVBh7XI/Ig2/xBzVMLAwIbYrAtoWEdw1oXPzCt6njdbBcQbfLGYFq
   VLhsxKXuBnKuq/yoiwzfG8Lm+MT30a7xKTxSAM+YAJ9vtbgoP6txyAWkd
   ihIeTJzA2L7kiHf7bUCjDb3gOEJhWnj0nV9aNQP/++os+YyDdEYhyYoqn
   /1/IlbTtnGN0VWx7669NBz/FmrCOunpmoapuY8zBf18nKkzdufajNe/mY
   g==;
X-IronPort-AV: E=Sophos;i="5.90,200,1643644800"; 
   d="scan'208";a="300080884"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 22 Mar 2022 13:58:45 +0800
IronPort-SDR: EY3HOZAe5pWquf8jw+LxVCj1icyMzfrGNkmCXvCQB1CL7CeJXcurqd8wd684u6Q2MYFcKZpILT
 GJkX3ukACGOfQteYs/LfMjfrhZGNKsdMtKYR3pXd0ivupOAF26VlK9Kp0PSA8olYLio6av3k/P
 gF6tMQCaB6oG6Q3q3A3RkeCa6A9rUgaycJE8X+x91rUsdjObEJW78EeidVWIumS1/gDinOT7Xm
 0urBsp/sUJE29HJdvaPAILDD1pUgf8GLg6AlfwXO7d/YvajteakQQhegfFuNc1W2r+rrOi0hrZ
 BK3JFdMDPLqAnzycX8MZIeZh
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 22:29:44 -0700
IronPort-SDR: e182Hs9RAiTP/mgeFh/01+t7QCjM8qvZ4eMsRTb90Lb+S5I8gxFPEG2TPBLbYDmEd+aYtsF83f
 2xGaOQepZ5T9ahVMu9XKXCYxbwAKKa19oA/XNrgoePDDA34uKiahUvkm5wns6sxB0xl4zB7bFW
 fjGW/+uPgrRLkzXIFpysD0SoYmisTs7ZUDucYvBjI3YL0vpdDzslBYO7QV8Ekw8rm8zfkeawq3
 h7Tvmqf8aJhNGe+5cHEcnMBo9hkgQsjHcu8vy0Tcc0Y3XC0d6/5O8MAIOThFzQp85AA2eyiC8B
 YgE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 22:58:47 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KN1514kQhz1SVnx
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2022 22:58:45 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1647928725;
         x=1650520726; bh=7lynrs43AFuj+W0DPIFB8yBQxJilujfLhAUVSuVnQVg=; b=
        Yb4CY/M7WMJGlenFOSjVD8rZdFlUGFK61gisnKTtqOBeIhhPOX2Crp0uRLxeuz1m
        vTNKmXgwoBZCW1twmamowluAjdnjA3MA5gzRavQrlT6OjWOvNWZUl6U1QMxIGrWE
        ck4hM1AkUosqMpwCr8zT6klA33AJwCoorOi0pzwsVvbnHqac5Q1PzI8oVhGP85l2
        cnIQWbqqDjnV/WBhktcDeVVrpgdjJ4oOTs5q1Dz2PMbVExzLwIY7LU5PLI6qLsdC
        AdLdu6h+hoUUzCSlEyAKPltxzrM0a57S87kLlNhi4pGXKulCx/h8L/u40zSBexXt
        wQM+2Wt4Ed2TPDA1pjJ9Ow==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id gsbhrcHnBVB6 for <linux-scsi@vger.kernel.org>;
        Mon, 21 Mar 2022 22:58:45 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KN1500gHwz1Rvlx;
        Mon, 21 Mar 2022 22:58:43 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v2] scsi: mpt3sas: fix use after free in _scsih_expander_node_remove()
Date:   Tue, 22 Mar 2022 14:57:02 +0900
Message-Id: <20220322055702.95276-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The function mpt3sas_transport_port_remove() called in
_scsih_expander_node_remove() frees the port field of the sas_expander
structure, leading to the following use-after-free splat from Kasan when
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

Fix this by introducing the local variable port_id to store the port ID
value before executing mpt3sas_transport_port_remove(). This local
variable is then used in the call to ioc_info() instead of dereferencing
the freed port structure.

Fixes: 7d310f241001 ("scsi: mpt3sas: Get device objects using sas_address=
 & portID")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
Changes from v1:
* Use local variable to store the port ID instead of reversing the calls
  to ioc_info() and mpt3sas_transport_port_remove().

 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
index 00792767c620..7e476f50935b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11035,6 +11035,7 @@ _scsih_expander_node_remove(struct MPT3SAS_ADAPTE=
R *ioc,
 {
 	struct _sas_port *mpt3sas_port, *next;
 	unsigned long flags;
+	int port_id;
=20
 	/* remove sibling ports attached to this expander */
 	list_for_each_entry_safe(mpt3sas_port, next,
@@ -11055,6 +11056,8 @@ _scsih_expander_node_remove(struct MPT3SAS_ADAPTE=
R *ioc,
 			    mpt3sas_port->hba_port);
 	}
=20
+	port_id =3D sas_expander->port->port_id;
+
 	mpt3sas_transport_port_remove(ioc, sas_expander->sas_address,
 	    sas_expander->sas_address_parent, sas_expander->port);
=20
@@ -11062,7 +11065,7 @@ _scsih_expander_node_remove(struct MPT3SAS_ADAPTE=
R *ioc,
 	    "expander_remove: handle(0x%04x), sas_addr(0x%016llx), port:%d\n",
 	    sas_expander->handle, (unsigned long long)
 	    sas_expander->sas_address,
-	    sas_expander->port->port_id);
+	    port_id);
=20
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	list_del(&sas_expander->list);
--=20
2.35.1

