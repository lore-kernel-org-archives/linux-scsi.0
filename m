From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: 2 QLogic 2xxx driver possible problems
Date: Tue, 15 Aug 2006 14:00:51 +0400
Message-ID: <44E19B53.1090509@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out-relay-02.infobox.ru ([85.249.135.211]:29902 "EHLO
	out-relay-02.infobox.ru") by vger.kernel.org with ESMTP
	id S965318AbWHOKB4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Aug 2006 06:01:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-driver@qlogic.com
Cc: linux-scsi@vger.kernel.org

Hello

1. Once, when there were some problems with the target I had the 
following oops:

========================================================================

  11:0:0:0: scsi: Device offlined - not ready after error recovery
BUG: unable to handle kernel NULL pointer dereference at virtual address 
00000000
  printing eip:
c0241964
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP
Modules linked in: qla2xxx firmware_class scsi_transport_fc pcspkr 
w83627hf hwmon_vid eeprom adm1021 i2c_isa binfmt_misc dm_mirror dm_mod 
video button battery ac ehci_hcd sg uhci_hcd e1000 i2c_i801 e7xxx_edac 
i2c_core usbcore
CPU:    0
EIP:    0060:[<c0241964>]    Not tainted VLI
EFLAGS: 00010202   (2.6.17.2 #7)
EIP is at make_class_name+0x28/0x8d
eax: 00000000   ebx: ffffffff   ecx: ffffffff   edx: cc5331f0
esi: 0000000b   edi: 00000000   ebp: 00000000   esp: cadfce8c
ds: 007b   es: 007b   ss: 0068
Process fc_wq_11 (pid: 10579, threadinfo=cadfc000 task=f7928030)
Stack: cc5331f0 c03cb7c4 cc5331f0 c03cb7c4 c03cb7cc c0241b82 c03cb740 
00000000
        e6cd203c cc5331f0 cc533098 f73e3800 00000202 c0241c60 cc533000 
c025b994
        cc533000 e6cd2038 c025b9e5 cc533000 e6cd2000 c025ba79 f73e3814 
dd8d1044
Call Trace:
  <c0241b82> class_device_del+0x93/0x169  <c0241c60> 
class_device_unregister+0x8/0x10
  <c025b994> __scsi_remove_device+0x26/0x60  <c025b9e5> 
scsi_remove_device+0x17/0x20
  <c025ba79> __scsi_remove_target+0x8b/0xb7  <c025badc> 
__remove_child+0x0/0x18
  <c025baf0> __remove_child+0x14/0x18  <c023fb18> 
device_for_each_child+0x23/0x41
  <c025bad3> scsi_remove_target+0x2e/0x37  <f88edb5f> 
fc_rport_final_delete+0x32/0x6a [scsi_transport_fc]
  <c012a4ae> run_workqueue+0x72/0xe6  <f88edb2d> 
fc_rport_final_delete+0x0/0x6a [scsi_transport_fc]
  <c012abd1> worker_thread+0x13b/0x15a  <c01156fe> 
default_wake_function+0x0/0xc
  <c012aa96> worker_thread+0x0/0x15a  <c012d36c> kthread+0x9f/0xc4
  <c012d2cd> kthread+0x0/0xc4  <c0100d35> kernel_thread_helper+0x5/0xb
Code: 89 c8 c3 55 57 56 53 83 ec 04 89 04 24 89 c2 8b 40 4c 8b 38 31 ed 
bb ff ff ff ff 89 d9 89 e8 f2 ae f7 d1 49 89 ce 8b 7a 08 89 d9 <f2> ae 
f7 d1 49 89 ca 8d 4e 02 8d 04 0a ba d0 00 00 00 e8 59 4b
EIP: [<c0241964>] make_class_name+0x28/0x8d SS:ESP 0068:cadfce8c

========================================================================

2. If "rmmod" is called too soon after "modprobe" sometimes the 
following messages appear in the kernel log (I made them one func name 
per line for readability).

========================================================================

ERROR: FC host 'qla2xxx' attempted to flush work, when no workqueue created.
<f88edfdb> fc_remote_port_add+0x31/0x37c [scsi_transport_fc]
<f89e2ea3> qla2x00_reg_remote_port+0x1d4/0x28a [qla2xxx]
<f89e1ae0> qla2x00_do_dpc+0x32a/0x33f [qla2xxx]
<f89e17b6> qla2x00_do_dpc+0x0/0x33f [qla2xxx]
<c012d36c> kthread+0x9f/0xc4
<c012d2cd> kthread+0x0/0xc4
<c0100d35> kernel_thread_helper+0x5/0xb
ERROR: FC host 'qla2xxx' attempted to flush work, when no workqueue created.
<f88edd22> fc_remote_port_rolechg+0x96/0xf6 [scsi_transport_fc]
<f89e2ef5> qla2x00_reg_remote_port+0x226/0x28a [qla2xxx]
<f89e1ae0> qla2x00_do_dpc+0x32a/0x33f [qla2xxx]
<f89e17b6> qla2x00_do_dpc+0x0/0x33f [qla2xxx]
<c012d36c> kthread+0x9f/0xc4
<c012d2cd> kthread+0x0/0xc4
<c0100d35> kernel_thread_helper+0x5/0xb

========================================================================

Kernel is 2.6.17.2.

Vlad
