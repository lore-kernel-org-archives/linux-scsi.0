From: Douglas Gilbert <dgilbert@interlog.com>
Subject: lk 3.17-rc4 blk_mq large write problems
Date: Tue, 09 Sep 2014 23:55:02 -0400
Message-ID: <540FCB96.8000606@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040002080600050203020709"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53965 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaIJDzO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Sep 2014 23:55:14 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp.infotech.no (Postfix) with ESMTP id 076B12041C0
	for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2014 05:55:11 +0200 (CEST)
Received: from smtp.infotech.no ([127.0.0.1])
	by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GuOgygqGrAjr for <linux-scsi@vger.kernel.org>;
	Wed, 10 Sep 2014 05:55:08 +0200 (CEST)
Received: from [192.168.48.86] (host-192.252-160-90.dyn.295.ca [192.252.160.90])
	by smtp.infotech.no (Postfix) with ESMTPA id 2B8A7204167
	for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2014 05:55:07 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------040002080600050203020709
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

A few days ago I was trying to create a large file
(say 16 GB) of zeros on an ext4 file system:
    dd if=/dev/zero bs=64k count=256k of=zero_16g.bin

After about 5 seconds there was a NULL de-reference that
crashed the machine (shown below). This was with a clean
version of lk 3.17-rc4 (from kernel.org) where the target
was a SATA SSD directly connected to a LSI 9300-4i SAS-3
HBA (mpt3sas). Significantly (IMO) the kernel boot line
contained:
    scsi_mod.use_blk_mq=Y

In all cases changing that to "N" fixed the problem. I tried
many things, including a SAS SSD but the problem persisted when
use_blk_mq=Y. It doesn't always oops as shown in the first
case below. There were also:
   - immediate reboots
   - lock-ups without any oops on the console
   - different oopses of a somewhat stranger nature
     (hard to catch as logging everything on a real
      serial port is fiddly) like double bus errors

Rob Elliott has been unable to replicate this problem.

Today I switched to another machine running Debian 7 (the
first machine was Ubuntu 14.04 based); both x86_64.
Built the same kernel on the second machine, this time
with a LSI 9212-4i4e SAS-2 HBA (mpt2sas) and a SAS SSD
directly connected. Roughly speaking it was the same
test case:
   # <create 1 partition on say /dev/sdb>
   # mkfs.ext4 /dev/sdb1
   # mount /dev/sdb1 /mnt/spare
   # cd /mnt/spare
   # dd if=/dev/zero bs=64k count=256k of=zero_16g.bin
   # cd
   # umount /mnt/spare

Usually the dd or the umount would crash. Then after a
crash, following a power cycle, the mount would crash.
Changing to scsi_mod.use_blk_mq=N restored sanity.

Tried some other SAS controllers: couldn't get a MR-9240-4i
(MegaRaid) to work at all on my newer box (doesn't like
PCIe 3 ?). Got a ARC-1882I working and it did not have
problems with the big dd (perhaps the arcmsr driver still
uses the host_lock to serialize commands).

So it could be common, bad code in the mpt2sas and mpt3sas
drivers. Or it could be somewhere else. Perhaps there is
more than one problem.

Testers out there are encouraged to run the above test case.
The SATA and SAS SSDs that I used can consume writes in the
300 to 600 MB/sec range.

Part of the strangeness of this first attached oops is that
blk_mq_timeout_check() appears twice. The second one (typically
from the umount) is a blown stack.

Enjoy.
Doug Gilbert







--------------040002080600050203020709
Content-Type: text/plain; charset=UTF-8;
 name="dd_lk317rc3_oops.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dd_lk317rc3_oops.txt"

QlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2Ug
YXQgICAgICAgICAgIChudWxsKQpJUDogWzxmZmZmZmZmZjgxMjdjZDJlPl0gc2NzaV90aW1l
c19vdXQrMHhlLzB4MmUwClBHRCAyMTQ5ZWMwNjcgUFVEIDIxNDI2NTA2NyBQTUQgMCAKT29w
czogMDAwMCBbIzFdIFNNUCAKTW9kdWxlcyBsaW5rZWQgaW46IHg4Nl9wa2dfdGVtcF90aGVy
bWFsIGt2bV9pbnRlbCBrdm0gbmZzZCBlaGNpX3BjaSBlaGNpX2hjZCBjcmN0MTBkaWZfcGNs
bXVsIHNlcmlvX3JhdyBwYXJwb3J0X3BjIGF1dGhfcnBjZ3NzIG9pZF9yZWdpc3RyeSBleHBv
cnRmcyBuZnMgbG9ja2Qgc3VucnBjIGJpbmZtdF9taXNjIGZ1c2UgbHAgcGFycG9ydCBleHQ0
IGNyYzE2IGpiZDIgdXNiaGlkIHNlcyB4aGNpX2hjZCByODE2OSB1c2Jjb3JlIHVzYl9jb21t
b24KQ1BVOiAzIFBJRDogMCBDb21tOiBzd2FwcGVyLzMgTm90IHRhaW50ZWQgMy4xNy4wLXJj
MyAjNjkKSGFyZHdhcmUgbmFtZTogR2lnYWJ5dGUgVGVjaG5vbG9neSBDby4sIEx0ZC4gWjk3
TS1EM0gvWjk3TS1EM0gsIEJJT1MgRjUgMDUvMzAvMjAxNAp0YXNrOiBmZmZmODgwMjE1MTNl
MDkwIHRpOiBmZmZmODgwMjE1MThjMDAwIHRhc2sudGk6IGZmZmY4ODAyMTUxOGMwMDAKUklQ
OiAwMDEwOls8ZmZmZmZmZmY4MTI3Y2QyZT5dICBbPGZmZmZmZmZmODEyN2NkMmU+XSBzY3Np
X3RpbWVzX291dCsweGUvMHgyZTAKUlNQOiAwMDE4OmZmZmY4ODAyMWZiODNlMTAgIEVGTEFH
UzogMDAwMTAyODIKUkFYOiBmZmZmZmZmZjgxMjdjZDIwIFJCWDogMDAwMDAwMDAwMDAwMDAw
MCBSQ1g6IGZmZmY4ODAwZDNkYzhkNDAKUkRYOiBmZmZmODgwMjBmZTljMGM4IFJTSTogMDAw
MDAwMDAwMDAwMjAwNyBSREk6IGZmZmY4ODAwZDNkYzhjMDAKUkJQOiBmZmZmODgwMjBmZTlj
MGM4IFIwODogZmZmZjg4MDAzNzk3MDA4OCBSMDk6IGZmZmY4ODAwMzc5NzAwMDAKUjEwOiBm
ZmZmODgwMjFlODAyNGU4IFIxMTogMDAwMDAwMDAwMDAwMDAwMiBSMTI6IDAwMDAwMDAwMDAw
MDA0NDkKUjEzOiBmZmZmODgwMDM3OTcwMDAwIFIxNDogZmZmZjg4MDIxZmI4M2VhOCBSMTU6
IGZmZmY4ODAyMTUyMGMwMDAKRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmY4
ODAyMWZiODAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApDUzogIDAwMTAgRFM6
IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzCkNSMjogMDAwMDAwMDAwMDAw
MDAwMCBDUjM6IDAwMDAwMDAyMTQzMjEwMDAgQ1I0OiAwMDAwMDAwMDAwMTQwN2UwClN0YWNr
OgogZmZmZjg4MDBkM2RjOGMwMCBmZmZmODgwMjBmZTljMGM4IGZmZmZmZmZmODExOGYxZDcg
MDAwMDAwMDAwMDAwMjZmYgogZmZmZjg4MDIwZmU5ZDQwMCBmZmZmZmZmZjgxMTkwNWRiIGZm
ZmY4ODAyMTRmYjMzYzAgZmZmZjg4MDAzNzk3MDAwMAogZmZmZmZmZmY4MTE5MDU3MCBmZmZm
ODgwMjFmYjgzZWE4IDAwMDAwMDAwMDAwMDAwMjAgZmZmZmZmZmY4MTE5MzQzMApDYWxsIFRy
YWNlOgogPElSUT4gCiBbPGZmZmZmZmZmODExOGYxZDc+XSA/IGJsa19ycV90aW1lZF9vdXQr
MHgxNy8weDgwCiBbPGZmZmZmZmZmODExOTA1ZGI+XSA/IGJsa19tcV90aW1lb3V0X2NoZWNr
KzB4NmIvMHg5MAogWzxmZmZmZmZmZjgxMTkwNTcwPl0gPyBibGtfbXFfYXR0ZW1wdF9tZXJn
ZSsweGIwLzB4YjAKIFs8ZmZmZmZmZmY4MTE5MzQzMD5dID8gYmxrX21xX3RhZ19idXN5X2l0
ZXIrMHg1MC8weDgwCiBbPGZmZmZmZmZmODExOTA2ODQ+XSA/IGJsa19tcV9ycV90aW1lcisw
eDg0LzB4MTIwCiBbPGZmZmZmZmZmODExOTA2MDA+XSA/IGJsa19tcV90aW1lb3V0X2NoZWNr
KzB4OTAvMHg5MAogWzxmZmZmZmZmZjgxMDc2ZWEyPl0gPyBjYWxsX3RpbWVyX2ZuLmlzcmEu
MzYrMHgxMi8weDcwCiBbPGZmZmZmZmZmODEwNzcwOWE+XSA/IHJ1bl90aW1lcl9zb2Z0aXJx
KzB4MTlhLzB4MjMwCiBbPGZmZmZmZmZmODEwM2Q2ZTU+XSA/IF9fZG9fc29mdGlycSsweGQ1
LzB4MWYwCiBbPGZmZmZmZmZmODEwM2Q5OTU+XSA/IGlycV9leGl0KzB4NDUvMHg1MAogWzxm
ZmZmZmZmZjgxMDJhNmJiPl0gPyBzbXBfYXBpY190aW1lcl9pbnRlcnJ1cHQrMHgzYi8weDUw
CiBbPGZmZmZmZmZmODE0MGRjNGE+XSA/IGFwaWNfdGltZXJfaW50ZXJydXB0KzB4NmEvMHg3
MAogPEVPST4gCiBbPGZmZmZmZmZmODEzMjdkZWI+XSA/IGNwdWlkbGVfZW50ZXJfc3RhdGUr
MHg0Yi8weGMwCiBbPGZmZmZmZmZmODEzMjdkZGQ+XSA/IGNwdWlkbGVfZW50ZXJfc3RhdGUr
MHgzZC8weGMwCiBbPGZmZmZmZmZmODEwNjU1ZTc+XSA/IGNwdV9zdGFydHVwX2VudHJ5KzB4
MjM3LzB4MjcwCkNvZGU6IGU4IGQ4IGIzIGZmIGZmIDg1IGMwIDc1IGNkIGU5IDU0IGZmIGZm
IGZmIDY2IDY2IDY2IDY2IDY2IDY2IDJlIDBmIDFmIDg0IDAwIDAwIDAwIDAwIDAwIDU1IGJl
IDA3IDIwIDAwIDAwIDUzIDQ4IDhiIDlmIGY4IDAwIDAwIDAwIDw0OD4gOGIgMDMgNDggODkg
ZGYgNDggOGIgMjggZTggMjQgYWMgZmYgZmYgODMgYmQgNTQgMDEgMDAgMDAgZmYgClJJUCAg
WzxmZmZmZmZmZjgxMjdjZDJlPl0gc2NzaV90aW1lc19vdXQrMHhlLzB4MmUwCiBSU1AgPGZm
ZmY4ODAyMWZiODNlMTA+CkNSMjogMDAwMDAwMDAwMDAwMDAwMAotLS1bIGVuZCB0cmFjZSA2
NTk3NTJhMzkwZTNkNjJlIF0tLS0KS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZhdGFs
IGV4Y2VwdGlvbiBpbiBpbnRlcnJ1cHQKS2VybmVsIE9mZnNldDogMHgwIGZyb20gMHhmZmZm
ZmZmZjgxMDAwMDAwIChyZWxvY2F0aW9uIHJhbmdlOiAweGZmZmZmZmZmODAwMDAwMDAtMHhm
ZmZmZmZmZjlmZmZmZmZmKQotLS1bIGVuZCBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzog
RmF0YWwgZXhjZXB0aW9uIGluIGludGVycnVwdAo=
--------------040002080600050203020709
Content-Type: text/plain; charset=UTF-8;
 name="mount1_lk317rc4_bug.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="mount1_lk317rc4_bug.txt"

QlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBhdCAwMDAwMDAw
MTdmNmI5MWEwCklQOiBbPGZmZmZmZmZmODEwNmFiMWY+XSBjcHVhY2N0X2NoYXJnZSsweDFm
LzB4NDAKUEdEIDNhNzdlMDY3IFBVRCAwIApUaHJlYWQgb3ZlcnJhbiBzdGFjaywgb3Igc3Rh
Y2sgY29ycnVwdGVkCk9vcHM6IDAwMDAgWyMxXSBTTVAgCk1vZHVsZXMgbGlua2VkIGluOiBm
dXNlIGhmc3BsdXMgaGZzIG1pbml4IHZmYXQgbXNkb3MgZmF0IGV4dDQgY3JjMTYgamJkMiBu
ZnNkIGF1dGhfcnBjZ3NzIG9pZF9yZWdpc3RyeSBleHBvcnRmcyBuZnMgbG9ja2Qgc3VucnBj
IHVzYmhpZCBvaGNpX3BjaSBlaGNpX3BjaSBvaGNpX2hjZCBlaGNpX2hjZCBwYXJwb3J0X3Bj
IGs4dGVtcCBzZXJpb19yYXcgcGFycG9ydCB1c2Jjb3JlIHVzYl9jb21tb24gc2cgbXB0MnNh
cyBzcl9tb2QKQ1BVOiAwIFBJRDogNTAwNSBDb21tOiBtb3VudCBOb3QgdGFpbnRlZCAzLjE3
LjAtcmM0ICMxCkhhcmR3YXJlIG5hbWU6IEFTVVNUZWsgQ29tcHV0ZXIgSU5DLiBLOE4tTFIv
SzhOLUxSLCBCSU9TIDAzMDMgMDQvMTQvMjAwNgp0YXNrOiBmZmZmODgwMDNkMzU0NzkwIHRp
OiBmZmZmODgwMDNkMzM4MDAwIHRhc2sudGk6IGZmZmY4ODAwM2QzMzgwMDAKUklQOiAwMDEw
Ols8ZmZmZmZmZmY4MTA2YWIxZj5dICBbPGZmZmZmZmZmODEwNmFiMWY+XSBjcHVhY2N0X2No
YXJnZSsweDFmLzB4NDAKUlNQOiAwMDE4OmZmZmY4ODAwM2ZjMDNlMDAgIEVGTEFHUzogMDAw
MTAwNDYKUkFYOiAwMDAwMDAwMDAwMDBjZjI4IFJCWDogZmZmZjg4MDAzZDM1NDdmOCBSQ1g6
IDAwMDAwMDAwM2ZjMThjNDAKUkRYOiBmZmZmZmZmZjgxNWI1NzAwIFJTSTogMDAwMDAwMDAw
MDA0N2I4NiBSREk6IGZmZmY4ODAwM2QzNTQ3OTAKUkJQOiAwMDAwMDAwMDAwMDQ3Yjg2IFIw
ODogMDAwMDAwMDAwMDAwMDAwMSBSMDk6IDAwMDAwMDAwMDAwMDAwMDEKUjEwOiAwMDAwMDAw
MDAwMDAwMDAwIFIxMTogMDAwMDAwMDAwMDAwMDAwMCBSMTI6IGZmZmY4ODAwM2ZjMTE3YTAK
UjEzOiAwMDAwMDAwNDg0MjU2N2E0IFIxNDogZmZmZjg4MDAzZDM1NDdmOCBSMTU6IDAwMDAw
MDE2MTk0MTc5YjcKRlM6ICAwMDAwN2Y4NWU3NjM2N2UwKDAwMDApIEdTOmZmZmY4ODAwM2Zj
MDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApDUzogIDAwMTAgRFM6IDAwMDAg
RVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzCkNSMjogMDAwMDAwMDE3ZjZiOTFhMCBD
UjM6IDAwMDAwMDAwMzNkNzUwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwN2YwClN0YWNrOgogZmZm
ZmZmZmY4MTA1ZmExYyBmZmZmODgwMDNhNzFjMTcwIGZmZmY4ODAwM2ZjMTE3YTAgMDAwMDAw
MDAwMDAwMDAwMAogMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDNmYzExNzQwIGZmZmZmZmZm
ODEwNjE4ZDUgMDAwMDAwMDAwMDAwMDdmZQogZmZmZmZmZmY4MTA1ZTkwNSBmZmZmODgwMDNm
YzEyMTAwIGZmZmY4ODAwM2ZjMTE3NDAgMDAwMDAwMDAwMDAwMDAwMApDYWxsIFRyYWNlOgog
PElSUT4gCiBbPGZmZmZmZmZmODEwNWZhMWM+XSA/IHVwZGF0ZV9jdXJyKzB4OWMvMHhmMAog
WzxmZmZmZmZmZjgxMDYxOGQ1Pl0gPyB0YXNrX3RpY2tfZmFpcisweDFmNS8weDRjMAogWzxm
ZmZmZmZmZjgxMDVlOTA1Pl0gPyBzY2hlZF9jbG9ja19sb2NhbCsweDE1LzB4ODAKIFs8ZmZm
ZmZmZmY4MTA1YTYxND5dID8gc2NoZWR1bGVyX3RpY2srMHg2NC8weGUwCiBbPGZmZmZmZmZm
ODEwN2NkNDg+XSA/IHVwZGF0ZV9wcm9jZXNzX3RpbWVzKzB4NTgvMHg4MAogWzxmZmZmZmZm
ZjgxMDg5ZjZkPl0gPyB0aWNrX3NjaGVkX3RpbWVyKzB4NGQvMHgxNTAKIFs8ZmZmZmZmZmY4
MTA3ZDJkOT5dID8gX19ydW5faHJ0aW1lci5pc3JhLjM1KzB4NDkvMHhkMAogWzxmZmZmZmZm
ZjgxMDdkOTA3Pl0gPyBocnRpbWVyX2ludGVycnVwdCsweGY3LzB4MjQwCiBbPGZmZmZmZmZm
ODEwMmMyZjY+XSA/IHNtcF9hcGljX3RpbWVyX2ludGVycnVwdCsweDM2LzB4NTAKIFs8ZmZm
ZmZmZmY4MTQyMzc0YT5dID8gYXBpY190aW1lcl9pbnRlcnJ1cHQrMHg2YS8weDcwCiA8RU9J
PiAKQ29kZTogNDggYzcgYzAgZjQgZmYgZmYgZmYgNWIgZWIgZDkgNjYgOTAgNDggOGIgNDcg
MDggNDggNjMgNDggMTggNDggOGIgODcgODggMDYgMDAgMDAgNDggOGIgNTAgNjAgMGYgMWYg
NDQgMDAgMDAgNDggOGIgODIgYTggMDAgMDAgMDAgPDQ4PiAwMyAwNCBjZCBhMCAyZiA1ZiA4
MSA0OCAwMSAzMCA0OCA4YiA1MiA0MCA0OCA4NSBkMiA3NSBlNSBjMyAKUklQICBbPGZmZmZm
ZmZmODEwNmFiMWY+XSBjcHVhY2N0X2NoYXJnZSsweDFmLzB4NDAKIFJTUCA8ZmZmZjg4MDAz
ZmMwM2UwMD4KQ1IyOiAwMDAwMDAwMTdmNmI5MWEwCi0tLVsgZW5kIHRyYWNlIDE4YzhiYjgx
YTkzMTNiZWUgXS0tLQpLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogRmF0YWwgZXhjZXB0
aW9uIGluIGludGVycnVwdApLZXJuZWwgT2Zmc2V0OiAweDAgZnJvbSAweGZmZmZmZmZmODEw
MDAwMDAgKHJlbG9jYXRpb24gcmFuZ2U6IDB4ZmZmZmZmZmY4MDAwMDAwMC0weGZmZmZmZmZm
OWZmZmZmZmYpCi0tLVsgZW5kIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBl
eGNlcHRpb24gaW4gaW50ZXJydXB0Cg==
--------------040002080600050203020709--
