Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87AEDC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 13:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343668AbiDGNhk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 09:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343669AbiDGNhc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 09:37:32 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEF6102F
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 06:35:26 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237C09Kx006371
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=jPvRta1h0RUDP5weufa23bVYIUVvYHOnOwYFd17wu6o=;
 b=ebJjyVF3Kw9Ai12V4Rnf+IH9nm+5ZcKRAUP94ivV9O7z7s/xZpqzTf80/9nMhGX7X8bo
 uOvsg6/GJ24CpCIDn3fcbquCNURr23wPJbPf9bduAkZrxuOmOlyxpWXrmjToscJUPR4E
 WbcrKUuCaqFwPHyibyPnzk0KN14KcXk8pD+QreJps2d9On8bkpIgNAMVa1OkBgmTYOqe
 dKIzuZPO5ynFY30mX0S1XC1zx8g6AmIYhuQBpu0YOF9a387x0WjCacMNXNsoS+c3dRAD
 DuVa5h+Ht1TKMhWtd9aQRVsShxkrFQWVus2ZQKyyHMNzeWIhDXiW1lon+xmOJV9N653Y cw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d31m0sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:25 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237DLVR1036847
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvs9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:22 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 237DZJLm032479
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:21 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvpy-4;
        Thu, 07 Apr 2022 13:35:21 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: mpt3sas: fix use after free in _scsih_expander_node_remove()
Date:   Thu,  7 Apr 2022 09:35:03 -0400
Message-Id: <164929678997.15424.5303213551009228928.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220322055702.95276-1-damien.lemoal@opensource.wdc.com>
References: <20220322055702.95276-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: -HLHnnq8H9gESl9pea_SkpWKlgmW7GQ9
X-Proofpoint-ORIG-GUID: -HLHnnq8H9gESl9pea_SkpWKlgmW7GQ9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 22 Mar 2022 14:57:02 +0900, Damien Le Moal wrote:

> The function mpt3sas_transport_port_remove() called in
> _scsih_expander_node_remove() frees the port field of the sas_expander
> structure, leading to the following use-after-free splat from Kasan when
> the ioc_info() call following that function is executed (e.g. when doing
> rmmod of the driver module):
> 
> [ 3479.371167] ==================================================================
> [ 3479.378496] BUG: KASAN: use-after-free in _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
> [ 3479.386936] Read of size 1 at addr ffff8881c037691c by task rmmod/1531
> [ 3479.393524]
> [ 3479.395035] CPU: 18 PID: 1531 Comm: rmmod Not tainted 5.17.0-rc8+ #1436
> [ 3479.401712] Hardware name: Supermicro Super Server/H12SSL-NT, BIOS 2.1 06/02/2021
> [ 3479.409263] Call Trace:
> [ 3479.411743]  <TASK>
> [ 3479.413875]  dump_stack_lvl+0x45/0x59
> [ 3479.417582]  print_address_description.constprop.0+0x1f/0x120
> [ 3479.423389]  ? _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
> [ 3479.429469]  kasan_report.cold+0x83/0xdf
> [ 3479.433438]  ? _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
> [ 3479.439514]  _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
> [ 3479.445411]  ? _raw_spin_unlock_irqrestore+0x2d/0x40
> [ 3479.452032]  scsih_remove+0x525/0xc90 [mpt3sas]
> [ 3479.458212]  ? mpt3sas_expander_remove+0x1d0/0x1d0 [mpt3sas]
> [ 3479.465529]  ? down_write+0xde/0x150
> [ 3479.470746]  ? up_write+0x14d/0x460
> [ 3479.475840]  ? kernfs_find_ns+0x137/0x310
> [ 3479.481438]  pci_device_remove+0x65/0x110
> [ 3479.487013]  __device_release_driver+0x316/0x680
> [ 3479.493180]  driver_detach+0x1ec/0x2d0
> [ 3479.498499]  bus_remove_driver+0xe7/0x2d0
> [ 3479.504081]  pci_unregister_driver+0x26/0x250
> [ 3479.510033]  _mpt3sas_exit+0x2b/0x6cf [mpt3sas]
> [ 3479.516144]  __x64_sys_delete_module+0x2fd/0x510
> [ 3479.522315]  ? free_module+0xaa0/0xaa0
> [ 3479.527593]  ? __cond_resched+0x1c/0x90
> [ 3479.532951]  ? lockdep_hardirqs_on_prepare+0x273/0x3e0
> [ 3479.539607]  ? syscall_enter_from_user_mode+0x21/0x70
> [ 3479.546161]  ? trace_hardirqs_on+0x1c/0x110
> [ 3479.551828]  do_syscall_64+0x35/0x80
> [ 3479.556884]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 3479.563402] RIP: 0033:0x7f1fc482483b
> ...
> [ 3479.943087] ==================================================================
> 
> [...]

Applied to 5.18/scsi-fixes, thanks!

[1/1] scsi: mpt3sas: fix use after free in _scsih_expander_node_remove()
      https://git.kernel.org/mkp/scsi/c/87d663d40801

-- 
Martin K. Petersen	Oracle Linux Engineering
