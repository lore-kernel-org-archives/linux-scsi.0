From: Frank Hempel <lists@frankoni.net>
Subject: aic7xxx: tape always rewinds since linux-2.6.15
Date: Tue, 17 Jul 2007 19:32:38 +0200
Message-ID: <469CFD36.4090306@frankoni.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070902020505070806080405"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rom173.server4you.de ([62.75.222.246]:42650 "EHLO
	ursus.sytes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbXGQRjY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 13:39:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070902020505070806080405
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I have expierenced a problem with the aic7xxx driver or the scsi tape 
support in the linux kernel.

[Problem Description]
Under linux kernels since 2.6.15 every "action" I issue to the tape 
drive (I mainly do this via <mt> from the cpio package) is done but 
additionaly to every mt call a tape rewind is done too. So for example 
positioning the tape at some particular position is impossible because 
after the positioning itself it is rewinded automagically.
Under kernels before and including 2.6.14.7 this problem did not occur.

[My Hardware Setup]
*i686 pc style hardware
*Adaptec 2940 Ultra SCSI adapter (aic7880)
*attached tape drive: HP SureStore DAT40 (C5683A)

[Kernel Config]
see attachments for relevant switches

[What I Have Done Until Now]
*I testet kernel 2.6.22.1 to verify the problem still exists in latest 
kernel
*I compiled and used mt from latest unpatched cpio-2.9 (to make sure it 
is not related to the heavily patched debian version)
*I compiled debug code for aic7xxx in the kernels (unfortunatly the 
debug output don't show any inregularities (see attachments))
*I verified that mt is not just telling me wrong file numbers or block 
positions: with reading a file from tape with dd it turns out that the 
tape position must have been the tape start (using kernel 2.6.15+)
*I reverted the two patches I found stated in changelog of 2.6.15 
relating the aic7xxx module. This is "aci7xxx: reset handler selects a 
wrong command" and "aic7xxx: remove scsi_assign_lock usage". It did not 
solve the problem, even taking the complete aic7xxx_osm.c from 2.6.14.7 
to the 2.6.15 source tree did not change the situation. So the problem 
may be somewhere else in the aic7xxx-module.

[Attachments]
kernel-config                 ... the relevant scsi-switches for all the 
kernels I used
14.7.dmesg                    ... the (hopefully) relevant dmesg output 
from 2.6.14.7 kernel
14.7.mt-status-after-boot     ... the output of "mt status" after boot 
(tape was at block 0)
14.7.mt-fsf-2.kern.log        ... the kernel output during "mt fsf 2"
14.7.mt-status-after-mt-fsf-2 ... the output of "mt status" after "mt 
fsf 2" (file number is now *2*)
15.dmesg                      ... the (hopefully) relevant dmesg output 
from 2.15 kernel
15.mt-status-after-boot       ... the output of "mt -f /dev/st0 status" 
after boot (tape was at block 0)
15.mt-fsf-2.kern.log          ... the kernel output during "mt -f 
/dev/st0 fsf 2"
15.mt-status-after-mt-fsf-2   ... the output of "mt status" after "mt -f 
/dev/st0 fsf 2" (file number is now *0*)


If this might really be a problem in the aic7xxx module I hope I could 
and can help pointing it out. So if I should do something else to give 
you more or more precise information please let me know...

Thank you very much...
Frank


--------------070902020505070806080405
Content-Type: text/plain;
 name="kernel-config"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel-config"

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y

#
# SCSI Transport Attributes
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set

#
# SCSI low-level drivers
#
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=2047
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_SATA is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_FC is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA2XXX=y
# CONFIG_SCSI_QLA21XX is not set
# CONFIG_SCSI_QLA22XX is not set
# CONFIG_SCSI_QLA2300 is not set
# CONFIG_SCSI_QLA2322 is not set
# CONFIG_SCSI_QLA6312 is not set
# CONFIG_SCSI_QLA24XX is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set

--------------070902020505070806080405
Content-Type: text/plain;
 name="14.7.dmesg.relevant"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="14.7.dmesg.relevant"

TGludXggdmVyc2lvbiAyLjYuMTQuNy12YW5pbGxhIChyb290QHN0cnVwcGkpIChnY2MgdmVy
c2lvbiA0LjEuMiAyMDA2MTExNSAocHJlcmVsZWFzZSkgKERlYmlhbiA0LjEuMS0yMSkpICMx
IFR1ZSBKdWwgMTcgMDM6MjI6MzggQ0VTVCAyMDA3ClsuLi5dClNDU0kgc3Vic3lzdGVtIGlu
aXRpYWxpemVkClsuLi5dCkFDUEk6IFBDSSBJbnRlcnJ1cHQgMDAwMDowMDowYS4wW0FdIC0+
IEdTSSAxOCAobGV2ZWwsIGxvdykgLT4gSVJRIDE3CmFoY19wY2k6MDoxMDowOiBoYXJkd2Fy
ZSBzY2IgNjQgYnl0ZXM7IGtlcm5lbCBzY2IgNTIgYnl0ZXM7IGFoY19kbWEgOCBieXRlcwpz
Y3NpMCA6IEFkYXB0ZWMgQUlDN1hYWCBFSVNBL1ZMQi9QQ0kgU0NTSSBIQkEgRFJJVkVSLCBS
ZXYgNy4wCiAgICAgICAgPEFkYXB0ZWMgMjk0MCBVbHRyYSBTQ1NJIGFkYXB0ZXI+CiAgICAg
ICAgYWljNzg4MDogVWx0cmEgV2lkZSBDaGFubmVsIEEsIFNDU0kgSWQ9NywgMTYvMjUzIFND
QnMKCiAgVmVuZG9yOiBIUCAgICAgICAgTW9kZWw6IEM1NjgzQSAgICAgICAgICAgIFJldjog
QzkwOAogIFR5cGU6ICAgU2VxdWVudGlhbC1BY2Nlc3MgICAgICAgICAgICAgICAgICBBTlNJ
IFNDU0kgcmV2aXNpb246IDAyCiB0YXJnZXQwOjA6MDogQmVnaW5uaW5nIERvbWFpbiBWYWxp
ZGF0aW9uCnNjc2kwOkE6MDowOiBJTklUSUFUT1JfTVNHX09VVCBieXRlIDB4YzAKc2NzaTA6
QTowOjA6IElOSVRJQVRPUl9NU0dfT1VUIGJ5dGUgMHgxCnNjc2kwOkE6MDowOiBJTklUSUFU
T1JfTVNHX09VVCBieXRlIDB4MgpzY3NpMDpBOjA6MDogSU5JVElBVE9SX01TR19PVVQgYnl0
ZSAweDMKc2NzaTA6QTowOjA6IElOSVRJQVRPUl9NU0dfT1VUIGJ5dGUgMHgxCnNjc2kwOkE6
MDowOiBJTklUSUFUT1JfTVNHX09VVCBQSEFTRU1JUyBpbiBNZXNzYWdlLWluIHBoYXNlCnNj
c2kwOkE6MDowOiBJTklUSUFUT1JfTVNHX0lOIGJ5dGUgMHgxCnNjc2kwOkE6MDowOiBJTklU
SUFUT1JfTVNHX0lOIGJ5dGUgMHgyCnNjc2kwOkE6MDowOiBJTklUSUFUT1JfTVNHX0lOIGJ5
dGUgMHgzCnNjc2kwOkE6MDowOiBJTklUSUFUT1JfTVNHX0lOIGJ5dGUgMHgxCnNjc2kwOkE6
MDowOiBBc3NlcnRpbmcgQVROIGZvciByZXNwb25zZQpzY3NpMDpBOjA6MDogSU5JVElBVE9S
X01TR19JTiBQSEFTRU1JUyBpbiBNZXNzYWdlLW91dCBwaGFzZQpzY3NpMDpBOjA6MDogSU5J
VElBVE9SX01TR19PVVQgYnl0ZSAweDEKc2NzaTA6QTowOjA6IElOSVRJQVRPUl9NU0dfT1VU
IGJ5dGUgMHgzCnNjc2kwOkE6MDowOiBJTklUSUFUT1JfTVNHX09VVCBieXRlIDB4MQpzY3Np
MDpBOjA6MDogSU5JVElBVE9SX01TR19PVVQgYnl0ZSAweDQ1CnNjc2kwOkE6MDowOiBJTklU
SUFUT1JfTVNHX09VVCBieXRlIDB4MApzY3NpMDpBOjA6MDogSU5JVElBVE9SX01TR19PVVQg
UEhBU0VNSVMgaW4gTWVzc2FnZS1pbiBwaGFzZQpzY3NpMDpBOjA6MDogSU5JVElBVE9SX01T
R19JTiBieXRlIDB4MQpzY3NpMDpBOjA6MDogSU5JVElBVE9SX01TR19JTiBieXRlIDB4Mwpz
Y3NpMDpBOjA6MDogSU5JVElBVE9SX01TR19JTiBieXRlIDB4MQpzY3NpMDpBOjA6MDogSU5J
VElBVE9SX01TR19JTiBieXRlIDB4NDUKc2NzaTA6QTowOjA6IElOSVRJQVRPUl9NU0dfSU4g
Ynl0ZSAweDAKIHRhcmdldDA6MDowOiB3aWRlIGFzeW5jaHJvbm91cy4Kc2NzaTA6QTowOjA6
IElOSVRJQVRPUl9NU0dfSU4gUEhBU0VNSVMgaW4gQ29tbWFuZCBwaGFzZQogdGFyZ2V0MDow
OjA6IERvbWFpbiBWYWxpZGF0aW9uIHNraXBwaW5nIHdyaXRlIHRlc3RzCnNjc2kwOkE6MDow
OiBJTklUSUFUT1JfTVNHX09VVCBieXRlIDB4YzAKc2NzaTA6QTowOjA6IElOSVRJQVRPUl9N
U0dfT1VUIGJ5dGUgMHgxCnNjc2kwOkE6MDowOiBJTklUSUFUT1JfTVNHX09VVCBieXRlIDB4
MwpzY3NpMDpBOjA6MDogSU5JVElBVE9SX01TR19PVVQgYnl0ZSAweDEKc2NzaTA6QTowOjA6
IElOSVRJQVRPUl9NU0dfT1VUIGJ5dGUgMHgxOQpzY3NpMDpBOjA6MDogSU5JVElBVE9SX01T
R19PVVQgYnl0ZSAweDgKc2NzaTA6QTowOjA6IElOSVRJQVRPUl9NU0dfT1VUIFBIQVNFTUlT
IGluIE1lc3NhZ2UtaW4gcGhhc2UKc2NzaTA6QTowOjA6IElOSVRJQVRPUl9NU0dfSU4gYnl0
ZSAweDEKc2NzaTA6QTowOjA6IElOSVRJQVRPUl9NU0dfSU4gYnl0ZSAweDMKc2NzaTA6QTow
OjA6IElOSVRJQVRPUl9NU0dfSU4gYnl0ZSAweDEKc2NzaTA6QTowOjA6IElOSVRJQVRPUl9N
U0dfSU4gYnl0ZSAweDE5CnNjc2kwOkE6MDowOiBJTklUSUFUT1JfTVNHX0lOIGJ5dGUgMHg4
CiB0YXJnZXQwOjA6MDogRkFTVC0xMCBXSURFIFNDU0kgMjAuMCBNQi9zIFNUICgxMDAgbnMs
IG9mZnNldCA4KQpzY3NpMDpBOjA6MDogSU5JVElBVE9SX01TR19JTiBQSEFTRU1JUyBpbiBD
b21tYW5kIHBoYXNlCiB0YXJnZXQwOjA6MDogRW5kaW5nIERvbWFpbiBWYWxpZGF0aW9uCihz
Y3NpMDpBOjE6MCk6IFNhdyBTZWxlY3Rpb24gVGltZW91dCBmb3IgU0NCIDB4Mgooc2NzaTA6
QToyOjApOiBTYXcgU2VsZWN0aW9uIFRpbWVvdXQgZm9yIFNDQiAweDMKKHNjc2kwOkE6Mzow
KTogU2F3IFNlbGVjdGlvbiBUaW1lb3V0IGZvciBTQ0IgMHgyCihzY3NpMDpBOjQ6MCk6IFNh
dyBTZWxlY3Rpb24gVGltZW91dCBmb3IgU0NCIDB4Mwooc2NzaTA6QTo1OjApOiBTYXcgU2Vs
ZWN0aW9uIFRpbWVvdXQgZm9yIFNDQiAweDIKKHNjc2kwOkE6NjowKTogU2F3IFNlbGVjdGlv
biBUaW1lb3V0IGZvciBTQ0IgMHgzCihzY3NpMDpBOjg6MCk6IFNhdyBTZWxlY3Rpb24gVGlt
ZW91dCBmb3IgU0NCIDB4Mgooc2NzaTA6QTo5OjApOiBTYXcgU2VsZWN0aW9uIFRpbWVvdXQg
Zm9yIFNDQiAweDMKKHNjc2kwOkE6MTA6MCk6IFNhdyBTZWxlY3Rpb24gVGltZW91dCBmb3Ig
U0NCIDB4Mgooc2NzaTA6QToxMTowKTogU2F3IFNlbGVjdGlvbiBUaW1lb3V0IGZvciBTQ0Ig
MHgzCihzY3NpMDpBOjEyOjApOiBTYXcgU2VsZWN0aW9uIFRpbWVvdXQgZm9yIFNDQiAweDIK
KHNjc2kwOkE6MTM6MCk6IFNhdyBTZWxlY3Rpb24gVGltZW91dCBmb3IgU0NCIDB4Mwooc2Nz
aTA6QToxNDowKTogU2F3IFNlbGVjdGlvbiBUaW1lb3V0IGZvciBTQ0IgMHgyCihzY3NpMDpB
OjE1OjApOiBTYXcgU2VsZWN0aW9uIFRpbWVvdXQgZm9yIFNDQiAweDMKc3Q6IFZlcnNpb24g
MjAwNTA4MzAsIGZpeGVkIGJ1ZnNpemUgMzI3NjgsIHMvZyBzZWdzIDI1NgpBdHRhY2hlZCBz
Y3NpIHRhcGUgc3QwIGF0IHNjc2kwLCBjaGFubmVsIDAsIGlkIDAsIGx1biAwCnN0MDogdHJ5
IGRpcmVjdCBpL286IHllcyAoYWxpZ25tZW50IDUxMiBCKSwgbWF4IHBhZ2UgcmVhY2hhYmxl
IGJ5IEhCQSAxMDQ4NTc1ClsuLi5d
--------------070902020505070806080405
Content-Type: text/plain;
 name="14.7.mt-status-after-boot.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="14.7.mt-status-after-boot.out"

drive type = 114
drive status = 637534208
sense key error = 0
residue count = 0
file number = 0
block number = 0

--------------070902020505070806080405
Content-Type: text/plain;
 name="14.7.mt-fsf-2.kern.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="14.7.mt-fsf-2.kern.log"

Jul 17 17:10:07 struppi kernel: (scsi0:A:0:0): SCB 2: requests Check Status
Jul 17 17:10:07 struppi kernel: (scsi0:A:0:0): Sending Sense
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x80
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x1
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x2
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x3
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x1
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT PHASEMIS in Message-in phase
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x1
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x2
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x3
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x1
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: Asserting ATN for response
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN PHASEMIS in Message-out phase
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x1
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x3
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x1
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x19
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x8
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT PHASEMIS in Message-in phase
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x1
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x3
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x1
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x19
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x8
Jul 17 17:10:07 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN PHASEMIS in Command phase
Jul 17 17:10:07 struppi kernel: (scsi0:A:0:0): Handled Sense Residual of 10 bytes
Jul 17 17:10:07 struppi kernel: Copied 22 bytes of sense data:
Jul 17 17:10:07 struppi kernel: 0x70 0x0 0x6 0x0 0x0 0x0 0x0 0xe 0x0 0x0 0x0 0x0 0x29 0x0 0x0 0x0 
Jul 17 17:10:07 struppi kernel: 0x0 0x0 0x0 0x0 0x0 0x0 
Jul 17 17:10:07 struppi kernel: st0: Block limits 1 - 16777215 bytes.

--------------070902020505070806080405
Content-Type: text/plain;
 name="14.7.mt-status-after-mt-fsf-2.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="14.7.mt-status-after-mt-fsf-2.out"

drive type = 114
drive status = 637534208
sense key error = 0
residue count = 0
file number = 2
block number = 0

--------------070902020505070806080405
Content-Type: text/plain;
 name="15.dmesg.relevant"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="15.dmesg.relevant"

TGludXggdmVyc2lvbiAyLjYuMTUtdmFuaWxsYSAocm9vdEBzdHJ1cHBpKSAoZ2NjIHZlcnNp
b24gNC4xLjIgMjAwNjExMTUgKHByZXJlbGVhc2UpIChEZWJpYW4gNC4xLjEtMjEpKSAjNSBU
dWUgSnVsIDE3IDE0OjU3OjE0IENFU1QgMjAwNwpbLi4uXQpTQ1NJIHN1YnN5c3RlbSBpbml0
aWFsaXplZApbLi4uXQpBQ1BJOiBQQ0kgSW50ZXJydXB0IDAwMDA6MDA6MGEuMFtBXSAtPiBH
U0kgMTggKGxldmVsLCBsb3cpIC0+IElSUSAxNwphaGNfcGNpOjA6MTA6MDogaGFyZHdhcmUg
c2NiIDY0IGJ5dGVzOyBrZXJuZWwgc2NiIDUyIGJ5dGVzOyBhaGNfZG1hIDggYnl0ZXMKc2Nz
aTAgOiBBZGFwdGVjIEFJQzdYWFggRUlTQS9WTEIvUENJIFNDU0kgSEJBIERSSVZFUiwgUmV2
IDcuMAogICAgICAgIDxBZGFwdGVjIDI5NDAgVWx0cmEgU0NTSSBhZGFwdGVyPgogICAgICAg
IGFpYzc4ODA6IFVsdHJhIFdpZGUgQ2hhbm5lbCBBLCBTQ1NJIElkPTcsIDE2LzI1MyBTQ0Jz
CgogIFZlbmRvcjogSFAgICAgICAgIE1vZGVsOiBDNTY4M0EgICAgICAgICAgICBSZXY6IEM5
MDgKICBUeXBlOiAgIFNlcXVlbnRpYWwtQWNjZXNzICAgICAgICAgICAgICAgICAgQU5TSSBT
Q1NJIHJldmlzaW9uOiAwMgogdGFyZ2V0MDowOjA6IEJlZ2lubmluZyBEb21haW4gVmFsaWRh
dGlvbgpzY3NpMDpBOjA6MDogSU5JVElBVE9SX01TR19PVVQgYnl0ZSAweGMwCnNjc2kwOkE6
MDowOiBJTklUSUFUT1JfTVNHX09VVCBieXRlIDB4MQpzY3NpMDpBOjA6MDogSU5JVElBVE9S
X01TR19PVVQgYnl0ZSAweDIKc2NzaTA6QTowOjA6IElOSVRJQVRPUl9NU0dfT1VUIGJ5dGUg
MHgzCnNjc2kwOkE6MDowOiBJTklUSUFUT1JfTVNHX09VVCBieXRlIDB4MQpzY3NpMDpBOjA6
MDogSU5JVElBVE9SX01TR19PVVQgUEhBU0VNSVMgaW4gTWVzc2FnZS1pbiBwaGFzZQpzY3Np
MDpBOjA6MDogSU5JVElBVE9SX01TR19JTiBieXRlIDB4MQpzY3NpMDpBOjA6MDogSU5JVElB
VE9SX01TR19JTiBieXRlIDB4MgpzY3NpMDpBOjA6MDogSU5JVElBVE9SX01TR19JTiBieXRl
IDB4MwpzY3NpMDpBOjA6MDogSU5JVElBVE9SX01TR19JTiBieXRlIDB4MQpzY3NpMDpBOjA6
MDogQXNzZXJ0aW5nIEFUTiBmb3IgcmVzcG9uc2UKc2NzaTA6QTowOjA6IElOSVRJQVRPUl9N
U0dfSU4gUEhBU0VNSVMgaW4gTWVzc2FnZS1vdXQgcGhhc2UKc2NzaTA6QTowOjA6IElOSVRJ
QVRPUl9NU0dfT1VUIGJ5dGUgMHgxCnNjc2kwOkE6MDowOiBJTklUSUFUT1JfTVNHX09VVCBi
eXRlIDB4MwpzY3NpMDpBOjA6MDogSU5JVElBVE9SX01TR19PVVQgYnl0ZSAweDEKc2NzaTA6
QTowOjA6IElOSVRJQVRPUl9NU0dfT1VUIGJ5dGUgMHg0NQpzY3NpMDpBOjA6MDogSU5JVElB
VE9SX01TR19PVVQgYnl0ZSAweDAKc2NzaTA6QTowOjA6IElOSVRJQVRPUl9NU0dfT1VUIFBI
QVNFTUlTIGluIE1lc3NhZ2UtaW4gcGhhc2UKc2NzaTA6QTowOjA6IElOSVRJQVRPUl9NU0df
SU4gYnl0ZSAweDEKc2NzaTA6QTowOjA6IElOSVRJQVRPUl9NU0dfSU4gYnl0ZSAweDMKc2Nz
aTA6QTowOjA6IElOSVRJQVRPUl9NU0dfSU4gYnl0ZSAweDEKc2NzaTA6QTowOjA6IElOSVRJ
QVRPUl9NU0dfSU4gYnl0ZSAweDQ1CnNjc2kwOkE6MDowOiBJTklUSUFUT1JfTVNHX0lOIGJ5
dGUgMHgwCiB0YXJnZXQwOjA6MDogd2lkZSBhc3luY2hyb25vdXMuCnNjc2kwOkE6MDowOiBJ
TklUSUFUT1JfTVNHX0lOIFBIQVNFTUlTIGluIENvbW1hbmQgcGhhc2UKc2NzaTA6QTowOjA6
IElOSVRJQVRPUl9NU0dfT1VUIGJ5dGUgMHhjMApzY3NpMDpBOjA6MDogSU5JVElBVE9SX01T
R19PVVQgYnl0ZSAweDEKc2NzaTA6QTowOjA6IElOSVRJQVRPUl9NU0dfT1VUIGJ5dGUgMHgz
CnNjc2kwOkE6MDowOiBJTklUSUFUT1JfTVNHX09VVCBieXRlIDB4MQpzY3NpMDpBOjA6MDog
SU5JVElBVE9SX01TR19PVVQgYnl0ZSAweDE5CnNjc2kwOkE6MDowOiBJTklUSUFUT1JfTVNH
X09VVCBieXRlIDB4OApzY3NpMDpBOjA6MDogSU5JVElBVE9SX01TR19PVVQgUEhBU0VNSVMg
aW4gTWVzc2FnZS1pbiBwaGFzZQpzY3NpMDpBOjA6MDogSU5JVElBVE9SX01TR19JTiBieXRl
IDB4MQpzY3NpMDpBOjA6MDogSU5JVElBVE9SX01TR19JTiBieXRlIDB4MwpzY3NpMDpBOjA6
MDogSU5JVElBVE9SX01TR19JTiBieXRlIDB4MQpzY3NpMDpBOjA6MDogSU5JVElBVE9SX01T
R19JTiBieXRlIDB4MTkKc2NzaTA6QTowOjA6IElOSVRJQVRPUl9NU0dfSU4gYnl0ZSAweDgK
IHRhcmdldDA6MDowOiBGQVNULTEwIFdJREUgU0NTSSAyMC4wIE1CL3MgU1QgKDEwMCBucywg
b2Zmc2V0IDgpCnNjc2kwOkE6MDowOiBJTklUSUFUT1JfTVNHX0lOIFBIQVNFTUlTIGluIENv
bW1hbmQgcGhhc2UKIHRhcmdldDA6MDowOiBEb21haW4gVmFsaWRhdGlvbiBza2lwcGluZyB3
cml0ZSB0ZXN0cwogdGFyZ2V0MDowOjA6IEVuZGluZyBEb21haW4gVmFsaWRhdGlvbgooc2Nz
aTA6QToxOjApOiBTYXcgU2VsZWN0aW9uIFRpbWVvdXQgZm9yIFNDQiAweDMKKHNjc2kwOkE6
MjowKTogU2F3IFNlbGVjdGlvbiBUaW1lb3V0IGZvciBTQ0IgMHgyCihzY3NpMDpBOjM6MCk6
IFNhdyBTZWxlY3Rpb24gVGltZW91dCBmb3IgU0NCIDB4Mwooc2NzaTA6QTo0OjApOiBTYXcg
U2VsZWN0aW9uIFRpbWVvdXQgZm9yIFNDQiAweDIKKHNjc2kwOkE6NTowKTogU2F3IFNlbGVj
dGlvbiBUaW1lb3V0IGZvciBTQ0IgMHgzCihzY3NpMDpBOjY6MCk6IFNhdyBTZWxlY3Rpb24g
VGltZW91dCBmb3IgU0NCIDB4Mgooc2NzaTA6QTo4OjApOiBTYXcgU2VsZWN0aW9uIFRpbWVv
dXQgZm9yIFNDQiAweDMKKHNjc2kwOkE6OTowKTogU2F3IFNlbGVjdGlvbiBUaW1lb3V0IGZv
ciBTQ0IgMHgyCihzY3NpMDpBOjEwOjApOiBTYXcgU2VsZWN0aW9uIFRpbWVvdXQgZm9yIFND
QiAweDMKKHNjc2kwOkE6MTE6MCk6IFNhdyBTZWxlY3Rpb24gVGltZW91dCBmb3IgU0NCIDB4
Mgooc2NzaTA6QToxMjowKTogU2F3IFNlbGVjdGlvbiBUaW1lb3V0IGZvciBTQ0IgMHgzCihz
Y3NpMDpBOjEzOjApOiBTYXcgU2VsZWN0aW9uIFRpbWVvdXQgZm9yIFNDQiAweDIKKHNjc2kw
OkE6MTQ6MCk6IFNhdyBTZWxlY3Rpb24gVGltZW91dCBmb3IgU0NCIDB4Mwooc2NzaTA6QTox
NTowKTogU2F3IFNlbGVjdGlvbiBUaW1lb3V0IGZvciBTQ0IgMHgyCnN0OiBWZXJzaW9uIDIw
MDUwODMwLCBmaXhlZCBidWZzaXplIDMyNzY4LCBzL2cgc2VncyAyNTYKc3QgMDowOjA6MDog
QXR0YWNoZWQgc2NzaSB0YXBlIHN0MDw0PnN0MDogdHJ5IGRpcmVjdCBpL286IHllcyAoYWxp
Z25tZW50IDUxMiBCKSwgbWF4IHBhZ2UgcmVhY2hhYmxlIGJ5IEhCQSAxMDQ4NTc1ClsuLi5d

--------------070902020505070806080405
Content-Type: text/plain;
 name="15.mt-status-after-boot.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="15.mt-status-after-boot.out"

drive type = 114
drive status = 637534208
sense key error = 0
residue count = 0
file number = 0
block number = 0

--------------070902020505070806080405
Content-Type: text/plain;
 name="15.mt-fsf-2.kern.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="15.mt-fsf-2.kern.log"

Jul 17 17:31:58 struppi kernel: (scsi0:A:0:0): SCB 3: requests Check Status
Jul 17 17:31:58 struppi kernel: (scsi0:A:0:0): Sending Sense
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x80
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x1
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x2
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x3
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x1
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT PHASEMIS in Message-in phase
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x1
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x2
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x3
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x1
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: Asserting ATN for response
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN PHASEMIS in Message-out phase
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x1
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x3
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x1
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x19
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT byte 0x8
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_OUT PHASEMIS in Message-in phase
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x1
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x3
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x1
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x19
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN byte 0x8
Jul 17 17:31:58 struppi kernel: scsi0:A:0:0: INITIATOR_MSG_IN PHASEMIS in Command phase
Jul 17 17:31:58 struppi kernel: (scsi0:A:0:0): Handled Sense Residual of 10 bytes
Jul 17 17:31:58 struppi kernel: Copied 22 bytes of sense data:
Jul 17 17:31:58 struppi kernel: 0x70 0x0 0x6 0x0 0x0 0x0 0x0 0xe 0x0 0x0 0x0 0x0 0x29 0x0 0x0 0x0 
Jul 17 17:31:58 struppi kernel: 0x0 0x0 0x0 0x0 0x0 0x0 
Jul 17 17:31:58 struppi kernel: st0: Block limits 1 - 16777215 bytes.

--------------070902020505070806080405
Content-Type: text/plain;
 name="15.mt-status-after-mt-fsf-2.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="15.mt-status-after-mt-fsf-2.out"

drive type = 114
drive status = 637534208
sense key error = 0
residue count = 0
file number = 0
block number = 0

--------------070902020505070806080405--
