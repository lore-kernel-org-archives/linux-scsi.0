From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z: dev
 error handler -> general protection fault, RIP: mvs_task_prep_ata+0x80/0x3a0
Date: Tue, 23 Sep 2014 21:56:05 +0000
Message-ID: <bug-81861-11613-Qg64VngHeJ@https.bugzilla.kernel.org/>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46976 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404AbaIWV4J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2014 17:56:09 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 85B9A202B8
	for <linux-scsi@vger.kernel.org>; Tue, 23 Sep 2014 21:56:08 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 6543720270
	for <linux-scsi@vger.kernel.org>; Tue, 23 Sep 2014 21:56:06 +0000 (UTC)
In-Reply-To: <bug-81861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81861

--- Comment #16 from linux-ide@crashplan.pro ---
When line-by-line dumping the called constants/vars from:
469        del_q = TXQ_MODE_I | tag |
470            (TXQ_CMD_STP << TXQ_CMD_SHIFT) |
471            (MVS_PHY_ID << TXQ_PHY_SHIFT) |
472            (mvi_dev->taskfileset << TXQ_SRS_SHIFT);

using the prepended statements:
        printk("slot=%p ", slot);
        printk(KERN_INFO "TXQ_MODE_I=%d ", TXQ_MODE_I);
        printk(KERN_INFO "tag=%d ", tag);
        printk(KERN_INFO "TXQ_CMD_STP=%d ", TXQ_CMD_STP);
        printk(KERN_INFO "TXQ_CMD_SHIFT=%d ", TXQ_CMD_SHIFT);
        printk(KERN_INFO "MVS_PHY_ID=%d ", MVS_PHY_ID);
        printk(KERN_INFO "TXQ_PHY_SHIFT=%d ", TXQ_PHY_SHIFT);
        del_q = TXQ_MODE_I | tag |
                (TXQ_CMD_STP << TXQ_CMD_SHIFT) |
                (MVS_PHY_ID << TXQ_PHY_SHIFT) |
                (mvi_dev->taskfileset << TXQ_SRS_SHIFT);

the kernel crash occurs after printing "TXQ_CMD_SHIFT" or when trying to output
the value of "MVS_PHY_ID":
[  529.113152] sas: DONE DISCOVERY on port 0, pid:133, result:0
[  529.114313] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[  529.115460] sas: ata7: end_device-6:0:28: dev error handler
[  529.115522] sas: ata8: end_device-6:0:29: dev error handler
[  529.118706] sas: ata9: end_device-6:0:30: dev error handler
[  529.119840] sas: ata10: end_device-6:0:31: dev error handler
[  529.271634] [mvi=ffff8800d3680000, mvi_dev=ffff8800d36836a0 tag=0
slot=ffff8800d36a55b8
[  529.271753] TXQ_MODE_I=268435456 tag=0
[  529.272679] TXQ_CMD_STP=3 TXQ_CMD_SHIFT=29
[  529.273618] MVS_PHY_ID=32768 TXQ_PHY_SHIFT=12 tx_prod=44]
[  529.276091] [mvi=ffff8800d3680000, mvi_dev=ffff8800d3683618 tag=1
slot=ffff8800d36a5610
[  529.276207] TXQ_MODE_I=268435456 tag=1
[  529.277095] TXQ_CMD_STP=3 TXQ_CMD_SHIFT=29
[  529.278038] MVS_PHY_ID=1 TXQ_PHY_SHIFT=12 tx_prod=46]
[  529.280271] [mvi=ffff8800d3680000, mvi_dev=ffff8800d3683618 tag=1
slot=ffff8800d36a5610
[  529.280385] TXQ_MODE_I=268435456 tag=1
[  529.281445] TXQ_CMD_STP=3 TXQ_CMD_SHIFT=29
[  529.282562] MVS_PHY_ID=1 TXQ_PHY_SHIFT=12 tx_prod=48]
[  529.284894] [mvi=ffff8800d3680000, mvi_dev=ffff8800d36837b0 tag=2
slot=ffff8800d36a5668
[  529.285010] TXQ_MODE_I=268435456 tag=2
[  529.286248] TXQ_CMD_STP=3 TXQ_CMD_SHIFT=29
[  529.287555] BUG: unable to handle kernel NULL pointer dereference at
0000000000000257
[  529.290225] IP: [<ffffffffa02888bb>] mvs_task_prep+0x7cb/0xe50 [mvsas]
[  529.291686] PGD 0
[  529.293141] Oops: 0000 [#1] SMP
[  529.294630] Modules linked in: mvsas(OF) libsas scsi_transport_sas
x86_pkg_temp_thermal intel_powerclamp coretemp kvm crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel cryptd serio_raw lpc_ich i915 mei_me mei
drm_kms_helper video netconsole drm configfs mac_hid i2c_algo_bit psmouse r8169
ahci mii libahci

Any suggestions why accessing "MVS_PHY_ID" leads to the kernel NULL pointer
dereference oops?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
