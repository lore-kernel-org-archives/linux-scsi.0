From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Subject: RE: [PATCH 1/1] MPT Fusion (v4.00.43) NULL pointer on big endian
 systems causing Expanders not to tear off.
Date: Mon, 23 Feb 2009 09:53:14 +0530
Message-ID: <B73941C4DE6A3D4EA1AE128E9565E24423A0E08A97@inbmail01.lsi.com>
References: <499EA20F.4000604@mpstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og107.obsmtp.com ([64.18.2.167]:42886 "EHLO
	exprod7og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbZBWEXY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Feb 2009 23:23:24 -0500
In-Reply-To: <499EA20F.4000604@mpstor.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin ESTRABAUD <be@mpstor.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>

Hi Benjamin,
This patch will not apply to upstream. We will take this into our internal drivers and when we submit the feature to upstream we will handle it accordingly.
Thanks
Sathya 

-----Original Message-----
From: Benjamin ESTRABAUD [mailto:be@mpstor.com] 
Sent: Friday, February 20, 2009 5:59 PM
To: linux-scsi@vger.kernel.org
Cc: Moore, Eric; Prakash, Sathya
Subject: [PATCH 1/1] MPT Fusion (v4.00.43) NULL pointer on big endian systems causing Expanders not to tear off.

Hi,

Sorry in advance if this patch does not really fit in this Mailing list, since I understand that the LSI MPT Fusion v4.00.43 is not yet included in the official linux tree, but I did not know where else to post it.

This is a minor patch that fixes an issue on big endian systems (such as PPC), where when pulling a SAS cable connected to an expander never causes it to be deleted in the driver, ultimately leaving it on the system.

This causes after one more unplugging and replugging procedure the driver to try and add Phys that are not in use anymore and that were not deleted previously (ghost phys from the previous plugging of the expander with disks).

The bug is shown below:

[  198.225361]  port-0:1:27: trying to add phy phy-0:1:51 fails: it's already part of another port [  198.234109] ------------[ cut here ]------------ [  198.238708] kernel BUG at drivers/scsi/scsi_transport_sas.c:989!
[  198.244697] Oops: Exception in kernel mode, sig: 5 [#1] [  198.249907] NIP: b01c5950 LR: b01c5950 CTR: b018701c
[  198.254861] REGS: e81dfd20 TRAP: 0700   Not tainted  
(2.6.26.3-00018-g04f27eb-dirty)
[  198.262580] MSR: 00029000 <EE,ME>  CR: 24002022  XER: 20000000 [  198.268474] TASK = e80c99b0[665] 'mpt/0' THREAD: e81de000 [  198.273681] GPR00: b01c5950 e81dfdd0 e80c99b0 00000066 00000001
00000001 00000000 00000033
[  198.282149] GPR08: 00000001 b03e9e4c 0000e3e4 b03f0000 84002044 30000000 3ffe6500 00000001 [  198.290616] GPR16: 007fff40 00000000 00800000 00000001 e81dfe3c
e81dfe44 00000017 50015b21
[  198.299084] GPR24: 80001560 00000019 cd9f4258 e96f8f6c cd9f4140 cd9f4140 e96f8ee0 e96f9034 [  198.307740] NIP [b01c5950] sas_port_add_phy+0x138/0x140 [  198.312976] LR [b01c5950] sas_port_add_phy+0x138/0x140 [  198.318118] Call Trace:
[  198.320555] [e81dfdd0] [b01c5950] sas_port_add_phy+0x138/0x140
(unreliable)
[  198.327553] [e81dfdf0] [b01ec9bc] mptsas_probe_one_phy+0x13c/0x5d8 [  198.333757] [e81dfe30] [b01edb24] mptsas_expander_refresh+0x384/0x444
[  198.340219] [e81dfe90] [b01efe68]
mptsas_firmware_event_work+0xb80/0x1044
[  198.347028] [e81dff80] [b002e428] run_workqueue+0x9c/0x138 [  198.352548] [e81dffa0] [b002e85c] worker_thread+0x50/0xb4 [  198.357958] [e81dffd0] [b00319e8] kthread+0x84/0x8c [  198.362865] [e81dfff0] [b0003ab8] kernel_thread+0x44/0x60 [  198.368290] Instruction dump:
[  198.371271] 7f805000 7f1e4800 409effdc 41baff94 7fa3eb78 4bfc536d
7c641b78 3c60b038
[  198.379115] 38bd008c 7f66db78 3863993c 4be572d5 <0fe00000> 48000000
7c0802a6 9421ffe0

The patch below converts the expander's SAS address to the correct endianness so that the driver generates a valid "port_info" pointer using this expander's SAS address.

Without this patch, port_info cannot be valid since the SAS address we are using to find it with is not valid.

This bug does not occur on v3 of the driver, nor on Intel platforms that have different endianness.

-------------------------

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c index ee1edaf..f6ddded 100755
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -4631,6 +4631,7 @@ mptsas_send_expander_event(struct fw_event_work
*fw_event)
    ioc = fw_event->ioc;
    expander_data = (MpiEventDataSasExpanderStatusChange_t *)
        fw_event->event_data;
    memcpy(&sas_address, &expander_data->SASAddress, sizeof(__le64));
+   sas_address = le64_to_cpu(sas_address);
    port_info = mptsas_find_portinfo_by_sas_address(ioc, sas_address);

-------------------------------

Hope this can be of some help, sorry again for the non conventional way to send this patch.

Ben. - MPSTOR.
