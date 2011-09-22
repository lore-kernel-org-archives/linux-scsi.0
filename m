From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
Subject: [PATCH] [SCSI] libsas panic when single phy disabled on a wide port
Date: Thu, 22 Sep 2011 08:32:23 -0700
Message-ID: <FC1F9E38C0703341A1A750524E2525A9018AE2CF@XYUS-EX22.xyus.xyratex.com>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com> <1316691000.10571.6.camel@dabdike> <FC1F9E38C0703341A1A750524E2525A9018AE2C6@XYUS-EX22.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01CC793C.D3F491CE"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:55256 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750952Ab1IVPdV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2011 11:33:21 -0400
Content-class: urn:content-classes:message
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A9018AE2C6@XYUS-EX22.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Darrick Wong <djwong@us.ibm.com>, Xiangliang Yu <yuxiangl@marvell.com>, Jack Wang <jack_wang@usish.com>, Luben Tuikov <ltuikov@yahoo.com>, James Bottomley <jbottomley@parallels.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01CC793C.D3F491CE
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

When a wide port is being utilized to a target, if one disables only one
of the
phys, we get an OS crash:

BUG: unable to handle kernel NULL pointer dereference at
0000000000000238
IP: [<ffffffff814ca9b1>] mutex_lock+0x21/0x50
PGD 4103f5067 PUD 41dba9067 PMD 0
Oops: 0002 [#1] SMP
last sysfs file: /sys/bus/pci/slots/5/address
CPU 0
Modules linked in: pm8001(U) ses enclosure fuse nfsd exportfs autofs4
ipmi_devintf ipmi_si ipmi_msghandler nfs lockd fscache nfs_acl
auth_rpcgss 8021q fcoe libfcoe garp libfc scsi_transport_fc stp scsi_tgt
llc sunrpc cpufreq_ondemand acpi_cpufreq freq_table ipv6 sr_mod cdrom
dm_mirror dm_region_hash dm_log uinput sg i2c_i801 i2c_core iTCO_wdt
iTCO_vendor_support e1000e mlx4_ib ib_mad ib_core mlx4_en mlx4_core ext3
jbd mbcache sd_mod crc_t10dif usb_storage ata_generic pata_acpi ata_piix
libsas(U) scsi_transport_sas dm_mod [last unloaded: pm8001]

Modules linked in: pm8001(U) ses enclosure fuse nfsd exportfs autofs4
ipmi_devintf ipmi_si ipmi_msghandler nfs lockd fscache nfs_acl
auth_rpcgss 8021q fcoe libfcoe garp libfc scsi_transport_fc stp scsi_tgt
llc sunrpc cpufreq_ondemand acpi_cpufreq freq_table ipv6 sr_mod cdrom
dm_mirror dm_region_hash dm_log uinput sg i2c_i801 i2c_core iTCO_wdt
iTCO_vendor_support e1000e mlx4_ib ib_mad ib_core mlx4_en mlx4_core ext3
jbd mbcache sd_mod crc_t10dif usb_storage ata_generic pata_acpi ata_piix
libsas(U) scsi_transport_sas dm_mod [last unloaded: pm8001]
Pid: 5146, comm: scsi_wq_5 Not tainted
2.6.32-71.29.1.el6.lustre.7.x86_64 #1 Storage Server
RIP: 0010:[<ffffffff814ca9b1>]  [<ffffffff814ca9b1>]
mutex_lock+0x21/0x50
RSP: 0018:ffff8803e4e33d30  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000238 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff8803e664c800 RDI: 0000000000000238
RBP: ffff8803e4e33d40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000238 R14: ffff88041acb7200 R15: ffff88041c51ada0
FS:  0000000000000000(0000) GS:ffff880028200000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000238 CR3: 0000000410143000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process scsi_wq_5 (pid: 5146, threadinfo ffff8803e4e32000, task
ffff8803e4e294a0)
Stack:
 ffff8803e664c800 0000000000000000 ffff8803e4e33d70 ffffffffa001f06e
<0> ffff8803e4e33d60 ffff88041c51ada0 ffff88041acb7200 ffff88041bc0aa00
<0> ffff8803e4e33d90 ffffffffa0032b6c 0000000000000014 ffff88041acb7200
Call Trace:
 [<ffffffffa001f06e>] sas_port_delete_phy+0x2e/0xa0 [scsi_transport_sas]
 [<ffffffffa0032b6c>] sas_unregister_devs_sas_addr+0xac/0xe0 [libsas]
 [<ffffffffa0034914>] sas_ex_revalidate_domain+0x204/0x330 [libsas]
 [<ffffffffa00307f0>] ? sas_revalidate_domain+0x0/0x90 [libsas]
 [<ffffffffa0030855>] sas_revalidate_domain+0x65/0x90 [libsas]
 [<ffffffff8108c7d0>] worker_thread+0x170/0x2a0
 [<ffffffff81091ea0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8108c660>] ? worker_thread+0x0/0x2a0
 [<ffffffff81091b36>] kthread+0x96/0xa0
 [<ffffffff810141ca>] child_rip+0xa/0x20
 [<ffffffff81091aa0>] ? kthread+0x0/0xa0
 [<ffffffff810141c0>] ? child_rip+0x0/0x20
Code: ff ff 85 c0 75 ed eb d6 66 90 55 48 89 e5 48 83 ec 10 48 89 1c 24
4c 89 64 24 08 0f 1f 44 00 00 48 89 fb e8 92 f4 ff ff 48 89 df <f0> ff
0f 79 05 e8 25 00 00 00 65 48 8b 04 25 08 cc 00 00 48 2d
RIP  [<ffffffff814ca9b1>] mutex_lock+0x21/0x50
 RSP <ffff8803e4e33d30>
CR2: 0000000000000238

The following patch is admittedly a band-aid, and does not solve the
root cause, but it still is a good candidate for hardening as a pointer
check before reference.

The real patch is enclosed as an attachment since Outlook is my current
MTA.

Signed-off-by: Mark Salyzyn <mark_salyzyn@xyus.xyratex.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>
Cc: Darrick J Wong <djwong@us.ibm.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Jack Wang <jack_wang@usish.com>

 sas_expander.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -rup scsi-misc-2.6/drivers/scsi/libsas/sas_expander.c
scsi-misc-2.6.new/drivers/scsi/libsas/sas_expander.c
--- scsi-misc-2.6/drivers/scsi/libsas/sas_expander.c	2011-08-31
08:32:21.000000000 -0400
+++ scsi-misc-2.6.new/drivers/scsi/libsas/sas_expander.c
2011-09-22 11:20:06.000000000 -0400
@@ -1769,10 +1769,12 @@ static void sas_unregister_devs_sas_addr
 		sas_disable_routing(parent, phy->attached_sas_addr);
 	}
 	memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
-	sas_port_delete_phy(phy->port, phy->phy);
-	if (phy->port->num_phys =3D=3D 0)
-		sas_port_delete(phy->port);
-	phy->port =3D NULL;
+	if (phy->port) {
+		sas_port_delete_phy(phy->port, phy->phy);
+		if (phy->port->num_phys =3D=3D 0)
+			sas_port_delete(phy->port);
+		phy->port =3D NULL;
+	}
 }
=20
 static int sas_discover_bfs_by_root_level(struct domain_device *root,

______________________________________________________________________
This email may contain privileged or confidential information, which shou=
ld only be used for the purpose for which it was sent by Xyratex. No furt=
her rights or licenses are granted to use such information. If you are no=
t the intended recipient of this message, please notify the sender by ret=
urn and delete it. You may not use, copy, disclose or rely on the informa=
tion contained in it.
 =

Internet email is susceptible to data corruption, interception and unauth=
orised amendment for which Xyratex does not accept liability. While we ha=
ve taken reasonable precautions to ensure that this email is free of viru=
ses, Xyratex does not accept liability for the presence of any computer v=
iruses in this email, nor for any losses caused as a result of viruses.
 =

Xyratex Technology Limited (03134912), Registered in England & Wales, Reg=
istered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
 =

The Xyratex group of companies also includes, Xyratex Ltd, registered in =
Bermuda, Xyratex International Inc, registered in California, Xyratex (Ma=
laysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd =
registered in The People's Republic of China and Xyratex Japan Limited re=
gistered in Japan.
______________________________________________________________________
 =

=0D
------_=_NextPart_001_01CC793C.D3F491CE
Content-Type: application/octet-stream;
	name="libsas_single_wide.patch"
Content-Transfer-Encoding: base64
Content-Description: libsas_single_wide.patch
Content-Disposition: attachment;
	filename="libsas_single_wide.patch"

V2hlbiBhIHdpZGUgcG9ydCBpcyBiZWluZyB1dGlsaXplZCB0byBhIHRhcmdldCwgaWYgb25lIGRp
c2FibGVzIG9ubHkgb25lIG9mIHRoZQpwaHlzLCB3ZSBnZXQgYW4gT1MgY3Jhc2g6CgpCVUc6IHVu
YWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAwMDAwMDAw
MDAwMDAwMjM4CklQOiBbPGZmZmZmZmZmODE0Y2E5YjE+XSBtdXRleF9sb2NrKzB4MjEvMHg1MApQ
R0QgNDEwM2Y1MDY3IFBVRCA0MWRiYTkwNjcgUE1EIDAKT29wczogMDAwMiBbIzFdIFNNUApsYXN0
IHN5c2ZzIGZpbGU6IC9zeXMvYnVzL3BjaS9zbG90cy81L2FkZHJlc3MKQ1BVIDAKTW9kdWxlcyBs
aW5rZWQgaW46IHBtODAwMShVKSBzZXMgZW5jbG9zdXJlIGZ1c2UgbmZzZCBleHBvcnRmcyBhdXRv
ZnM0IGlwbWlfZGV2aW50ZiBpcG1pX3NpIGlwbWlfbXNnaGFuZGxlciBuZnMgbG9ja2QgZnNjYWNo
ZSBuZnNfYWNsIGF1dGhfcnBjZ3NzIDgwMjFxIGZjb2UgbGliZmNvZSBnYXJwIGxpYmZjIHNjc2lf
dHJhbnNwb3J0X2ZjIHN0cCBzY3NpX3RndCBsbGMgc3VucnBjIGNwdWZyZXFfb25kZW1hbmQgYWNw
aV9jcHVmcmVxIGZyZXFfdGFibGUgaXB2NiBzcl9tb2QgY2Ryb20gZG1fbWlycm9yIGRtX3JlZ2lv
bl9oYXNoIGRtX2xvZyB1aW5wdXQgc2cgaTJjX2k4MDEgaTJjX2NvcmUgaVRDT193ZHQgaVRDT192
ZW5kb3Jfc3VwcG9ydCBlMTAwMGUgbWx4NF9pYiBpYl9tYWQgaWJfY29yZSBtbHg0X2VuIG1seDRf
Y29yZSBleHQzIGpiZCBtYmNhY2hlIHNkX21vZCBjcmNfdDEwZGlmIHVzYl9zdG9yYWdlIGF0YV9n
ZW5lcmljIHBhdGFfYWNwaSBhdGFfcGlpeCBsaWJzYXMoVSkgc2NzaV90cmFuc3BvcnRfc2FzIGRt
X21vZCBbbGFzdCB1bmxvYWRlZDogcG04MDAxXQoKTW9kdWxlcyBsaW5rZWQgaW46IHBtODAwMShV
KSBzZXMgZW5jbG9zdXJlIGZ1c2UgbmZzZCBleHBvcnRmcyBhdXRvZnM0IGlwbWlfZGV2aW50ZiBp
cG1pX3NpIGlwbWlfbXNnaGFuZGxlciBuZnMgbG9ja2QgZnNjYWNoZSBuZnNfYWNsIGF1dGhfcnBj
Z3NzIDgwMjFxIGZjb2UgbGliZmNvZSBnYXJwIGxpYmZjIHNjc2lfdHJhbnNwb3J0X2ZjIHN0cCBz
Y3NpX3RndCBsbGMgc3VucnBjIGNwdWZyZXFfb25kZW1hbmQgYWNwaV9jcHVmcmVxIGZyZXFfdGFi
bGUgaXB2NiBzcl9tb2QgY2Ryb20gZG1fbWlycm9yIGRtX3JlZ2lvbl9oYXNoIGRtX2xvZyB1aW5w
dXQgc2cgaTJjX2k4MDEgaTJjX2NvcmUgaVRDT193ZHQgaVRDT192ZW5kb3Jfc3VwcG9ydCBlMTAw
MGUgbWx4NF9pYiBpYl9tYWQgaWJfY29yZSBtbHg0X2VuIG1seDRfY29yZSBleHQzIGpiZCBtYmNh
Y2hlIHNkX21vZCBjcmNfdDEwZGlmIHVzYl9zdG9yYWdlIGF0YV9nZW5lcmljIHBhdGFfYWNwaSBh
dGFfcGlpeCBsaWJzYXMoVSkgc2NzaV90cmFuc3BvcnRfc2FzIGRtX21vZCBbbGFzdCB1bmxvYWRl
ZDogcG04MDAxXQpQaWQ6IDUxNDYsIGNvbW06IHNjc2lfd3FfNSBOb3QgdGFpbnRlZCAyLjYuMzIt
NzEuMjkuMS5lbDYubHVzdHJlLjcueDg2XzY0ICMxIFN0b3JhZ2UgU2VydmVyClJJUDogMDAxMDpb
PGZmZmZmZmZmODE0Y2E5YjE+XSAgWzxmZmZmZmZmZjgxNGNhOWIxPl0gbXV0ZXhfbG9jaysweDIx
LzB4NTAKUlNQOiAwMDE4OmZmZmY4ODAzZTRlMzNkMzAgIEVGTEFHUzogMDAwMTAyNDYKUkFYOiAw
MDAwMDAwMDAwMDAwMDAwIFJCWDogMDAwMDAwMDAwMDAwMDIzOCBSQ1g6IDAwMDAwMDAwMDAwMDAw
MDAKUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogZmZmZjg4MDNlNjY0YzgwMCBSREk6IDAwMDAw
MDAwMDAwMDAyMzgKUkJQOiBmZmZmODgwM2U0ZTMzZDQwIFIwODogMDAwMDAwMDAwMDAwMDAwMCBS
MDk6IDAwMDAwMDAwMDAwMDAwMDAKUjEwOiAwMDAwMDAwMDAwMDAwMDAwIFIxMTogMDAwMDAwMDAw
MDAwMDAwMSBSMTI6IDAwMDAwMDAwMDAwMDAwMDAKUjEzOiAwMDAwMDAwMDAwMDAwMjM4IFIxNDog
ZmZmZjg4MDQxYWNiNzIwMCBSMTU6IGZmZmY4ODA0MWM1MWFkYTAKRlM6ICAwMDAwMDAwMDAwMDAw
MDAwKDAwMDApIEdTOmZmZmY4ODAwMjgyMDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAw
MApDUzogIDAwMTAgRFM6IDAwMTggRVM6IDAwMTggQ1IwOiAwMDAwMDAwMDgwMDUwMDNiCkNSMjog
MDAwMDAwMDAwMDAwMDIzOCBDUjM6IDAwMDAwMDA0MTAxNDMwMDAgQ1I0OiAwMDAwMDAwMDAwMDAw
NmYwCkRSMDogMDAwMDAwMDAwMDAwMDAwMCBEUjE6IDAwMDAwMDAwMDAwMDAwMDAgRFIyOiAwMDAw
MDAwMDAwMDAwMDAwCkRSMzogMDAwMDAwMDAwMDAwMDAwMCBEUjY6IDAwMDAwMDAwZmZmZjBmZjAg
RFI3OiAwMDAwMDAwMDAwMDAwNDAwClByb2Nlc3Mgc2NzaV93cV81IChwaWQ6IDUxNDYsIHRocmVh
ZGluZm8gZmZmZjg4MDNlNGUzMjAwMCwgdGFzayBmZmZmODgwM2U0ZTI5NGEwKQpTdGFjazoKIGZm
ZmY4ODAzZTY2NGM4MDAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwM2U0ZTMzZDcwIGZmZmZmZmZm
YTAwMWYwNmUKPDA+IGZmZmY4ODAzZTRlMzNkNjAgZmZmZjg4MDQxYzUxYWRhMCBmZmZmODgwNDFh
Y2I3MjAwIGZmZmY4ODA0MWJjMGFhMDAKPDA+IGZmZmY4ODAzZTRlMzNkOTAgZmZmZmZmZmZhMDAz
MmI2YyAwMDAwMDAwMDAwMDAwMDE0IGZmZmY4ODA0MWFjYjcyMDAKQ2FsbCBUcmFjZToKIFs8ZmZm
ZmZmZmZhMDAxZjA2ZT5dIHNhc19wb3J0X2RlbGV0ZV9waHkrMHgyZS8weGEwIFtzY3NpX3RyYW5z
cG9ydF9zYXNdCiBbPGZmZmZmZmZmYTAwMzJiNmM+XSBzYXNfdW5yZWdpc3Rlcl9kZXZzX3Nhc19h
ZGRyKzB4YWMvMHhlMCBbbGlic2FzXQogWzxmZmZmZmZmZmEwMDM0OTE0Pl0gc2FzX2V4X3JldmFs
aWRhdGVfZG9tYWluKzB4MjA0LzB4MzMwIFtsaWJzYXNdCiBbPGZmZmZmZmZmYTAwMzA3ZjA+XSA/
IHNhc19yZXZhbGlkYXRlX2RvbWFpbisweDAvMHg5MCBbbGlic2FzXQogWzxmZmZmZmZmZmEwMDMw
ODU1Pl0gc2FzX3JldmFsaWRhdGVfZG9tYWluKzB4NjUvMHg5MCBbbGlic2FzXQogWzxmZmZmZmZm
ZjgxMDhjN2QwPl0gd29ya2VyX3RocmVhZCsweDE3MC8weDJhMAogWzxmZmZmZmZmZjgxMDkxZWEw
Pl0gPyBhdXRvcmVtb3ZlX3dha2VfZnVuY3Rpb24rMHgwLzB4NDAKIFs8ZmZmZmZmZmY4MTA4YzY2
MD5dID8gd29ya2VyX3RocmVhZCsweDAvMHgyYTAKIFs8ZmZmZmZmZmY4MTA5MWIzNj5dIGt0aHJl
YWQrMHg5Ni8weGEwCiBbPGZmZmZmZmZmODEwMTQxY2E+XSBjaGlsZF9yaXArMHhhLzB4MjAKIFs8
ZmZmZmZmZmY4MTA5MWFhMD5dID8ga3RocmVhZCsweDAvMHhhMAogWzxmZmZmZmZmZjgxMDE0MWMw
Pl0gPyBjaGlsZF9yaXArMHgwLzB4MjAKQ29kZTogZmYgZmYgODUgYzAgNzUgZWQgZWIgZDYgNjYg
OTAgNTUgNDggODkgZTUgNDggODMgZWMgMTAgNDggODkgMWMgMjQgNGMgODkgNjQgMjQgMDggMGYg
MWYgNDQgMDAgMDAgNDggODkgZmIgZTggOTIgZjQgZmYgZmYgNDggODkgZGYgPGYwPiBmZiAwZiA3
OSAwNSBlOCAyNSAwMCAwMCAwMCA2NSA0OCA4YiAwNCAyNSAwOCBjYyAwMCAwMCA0OCAyZApSSVAg
IFs8ZmZmZmZmZmY4MTRjYTliMT5dIG11dGV4X2xvY2srMHgyMS8weDUwCiBSU1AgPGZmZmY4ODAz
ZTRlMzNkMzA+CkNSMjogMDAwMDAwMDAwMDAwMDIzOAoKVGhlIGZvbGxvd2luZyBwYXRjaCBpcyBh
ZG1pdHRlZGx5IGEgYmFuZC1haWQsIGFuZCBkb2VzIG5vdCBzb2x2ZSB0aGUgcm9vdCBjYXVzZSwg
YnV0IGl0IHN0aWxsIGlzIGEgZ29vZCBjYW5kaWRhdGUgZm9yIGhhcmRlbmluZyBhcyBhIHBvaW50
ZXIgY2hlY2sgYmVmb3JlIHJlZmVyZW5jZS4KClNpZ25lZC1vZmYtYnk6IE1hcmsgU2FseXp5biA8
bWFya19zYWx5enluQHh5dXMueHlyYXRleC5jb20+CkNjOiBMdWJlbiBUdWlrb3YgPGx0dWlrb3ZA
eWFob28uY29tPgpDYzogRGFycmljayBKIFdvbmcgPGRqd29uZ0B1cy5pYm0uY29tPgpDYzogSmFt
ZXMgQm90dG9tbGV5IDxqYm90dG9tbGV5QHBhcmFsbGVscy5jb20+CkNjOiBYaWFuZ2xpYW5nIFl1
IDx5dXhpYW5nbEBtYXJ2ZWxsLmNvbT4KQ2M6IEphY2sgV2FuZyA8amFja193YW5nQHVzaXNoLmNv
bT4KCiBzYXNfZXhwYW5kZXIuYyB8ICAgMTAgKysrKysrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDYg
aW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLXJ1cCBzY3NpLW1pc2MtMi42L2Ry
aXZlcnMvc2NzaS9saWJzYXMvc2FzX2V4cGFuZGVyLmMgc2NzaS1taXNjLTIuNi5uZXcvZHJpdmVy
cy9zY3NpL2xpYnNhcy9zYXNfZXhwYW5kZXIuYwotLS0gc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Nj
c2kvbGlic2FzL3Nhc19leHBhbmRlci5jCTIwMTEtMDgtMzEgMDg6MzI6MjEuMDAwMDAwMDAwIC0w
NDAwCisrKyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbGlic2FzL3Nhc19leHBhbmRl
ci5jCTIwMTEtMDktMjIgMTE6MjA6MDYuMDAwMDAwMDAwIC0wNDAwCkBAIC0xNzY5LDEwICsxNzY5
LDEyIEBAIHN0YXRpYyB2b2lkIHNhc191bnJlZ2lzdGVyX2RldnNfc2FzX2FkZHIKIAkJc2FzX2Rp
c2FibGVfcm91dGluZyhwYXJlbnQsIHBoeS0+YXR0YWNoZWRfc2FzX2FkZHIpOwogCX0KIAltZW1z
ZXQocGh5LT5hdHRhY2hlZF9zYXNfYWRkciwgMCwgU0FTX0FERFJfU0laRSk7Ci0Jc2FzX3BvcnRf
ZGVsZXRlX3BoeShwaHktPnBvcnQsIHBoeS0+cGh5KTsKLQlpZiAocGh5LT5wb3J0LT5udW1fcGh5
cyA9PSAwKQotCQlzYXNfcG9ydF9kZWxldGUocGh5LT5wb3J0KTsKLQlwaHktPnBvcnQgPSBOVUxM
OworCWlmIChwaHktPnBvcnQpIHsKKwkJc2FzX3BvcnRfZGVsZXRlX3BoeShwaHktPnBvcnQsIHBo
eS0+cGh5KTsKKwkJaWYgKHBoeS0+cG9ydC0+bnVtX3BoeXMgPT0gMCkKKwkJCXNhc19wb3J0X2Rl
bGV0ZShwaHktPnBvcnQpOworCQlwaHktPnBvcnQgPSBOVUxMOworCX0KIH0KIAogc3RhdGljIGlu
dCBzYXNfZGlzY292ZXJfYmZzX2J5X3Jvb3RfbGV2ZWwoc3RydWN0IGRvbWFpbl9kZXZpY2UgKnJv
b3QsCg==

------_=_NextPart_001_01CC793C.D3F491CE--
