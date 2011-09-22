From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
Subject: [PATCH] [SCSI] pm8001 DEV_IS_GONE infinite retry
Date: Thu, 22 Sep 2011 08:50:01 -0700
Message-ID: <FC1F9E38C0703341A1A750524E2525A9018AE2D8@XYUS-EX22.xyus.xyratex.com>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com> <1316691000.10571.6.camel@dabdike> <FC1F9E38C0703341A1A750524E2525A9018AE2C6@XYUS-EX22.xyus.xyratex.com> <FC1F9E38C0703341A1A750524E2525A9018AE2CF@XYUS-EX22.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01CC793F.4A31200E"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:46366 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751794Ab1IVPwL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2011 11:52:11 -0400
Content-class: urn:content-classes:message
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A9018AE2CF@XYUS-EX22.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jack Wang <jack_wang@usish.com>, James Bottomley <jbottomley@parallels.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01CC793F.4A31200E
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On the pm8001, when a device is in the process of going away (device
power off or hot plug), depending on the timing, the driver would return
SAS_PHY_DOWN as the return value to the queuecommand DEV_IS_GONE logic.
The net result is an near infinite retry (especially if SAS debugging is
enabled), the logs will fill with:

kernel: mpi_ssp_completion 2119:e21:SSP IO status 0x13 tag 0xcc1c0000
dlen=3D90 param=3D0xe
kernel: wwn=3D5000c50034069e86  cdb=3D12 00 00 00 5a 00 00 00 00 00 00 =
00 00
00 00 00
kernel: sas: lldd_execute_task returned: 138
kernel: sas: lldd_execute_task returned: 138
kernel: sas: lldd_execute_task returned: 138
kernel: sas: lldd_execute_task returned: 138
kernel: sas: lldd_execute_task returned: 138
kernel: sas: lldd_execute_task returned: 138
kernel: sas: lldd_execute_task returned: 138
. . .

This patch changes to leverage the port_attached logic to complete the
command with a status of PHY_DOWN so that the disposition can be handled
immediately and correctly.

The real patch is enclosed as an attachment since Outlook is my current
MTA.

Signed-off-by: Mark Salyzyn <mark_salyzyn@xyus.xyratex.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: Jack Wang <jack_wang@usish.com>

 pm8001_sas.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff -ru scsi-misc-2.6/drivers/scsi/pm8001/pm8001_sas.c
scsi-misc-2.6.new/drivers/scsi/pm8001/pm8001_sas.c
--- scsi-misc-2.6/drivers/scsi/pm8001/pm8001_sas.c	2011-08-31
08:32:21.000000000 -0400
+++ scsi-misc-2.6.new/drivers/scsi/pm8001/pm8001_sas.c	2011-09-22
11:36:24.000000000 -0400
@@ -385,21 +385,8 @@
 	do {
 		dev =3D t->dev;
 		pm8001_dev =3D dev->lldd_dev;
-		if (DEV_IS_GONE(pm8001_dev)) {
-			if (pm8001_dev) {
-				PM8001_IO_DBG(pm8001_ha,
-					pm8001_printk("device %d not
ready.\n",
-					pm8001_dev->device_id));
-			} else {
-				PM8001_IO_DBG(pm8001_ha,
-					pm8001_printk("device %016llx
not "
-					"ready.\n",
SAS_ADDR(dev->sas_addr)));
-			}
-			rc =3D SAS_PHY_DOWN;
-			goto out_done;
-		}
 		port =3D &pm8001_ha->port[sas_find_local_port_id(dev)];
-		if (!port->port_attached) {
+		if (DEV_IS_GONE(pm8001_dev) || !port->port_attached) {
 			if (sas_protocol_ata(t->task_proto)) {
 				struct task_status_struct *ts =3D
&t->task_status;
 				ts->resp =3D SAS_TASK_UNDELIVERED;

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
------_=_NextPart_001_01CC793F.4A31200E
Content-Type: application/octet-stream;
	name="pm8001_DEV_IS_GONE.patch"
Content-Transfer-Encoding: base64
Content-Description: pm8001_DEV_IS_GONE.patch
Content-Disposition: attachment;
	filename="pm8001_DEV_IS_GONE.patch"

T24gdGhlIHBtODAwMSwgd2hlbiBhIGRldmljZSBpcyBpbiB0aGUgcHJvY2VzcyBvZiBnb2luZyBh
d2F5IChwb3dlciBvZmYgb3IgaG90IHBsdWcpLCBkZXBlbmRpbmcgb24gdGhlIHRpbWluZywgdGhl
IGRyaXZlciB3b3VsZCByZXR1cm4gU0FTX1BIWV9ET1dOIGFzIHRoZSByZXR1cm4gdmFsdWUgdG8g
dGhlIHF1ZXVlY29tbWFuZCBERVZfSVNfR09ORSBsb2dpYy4gVGhlIG5ldCByZXN1bHQgaXMgYW4g
bmVhciBpbmZpbml0ZSByZXRyeSAoZXNwZWNpYWxseSBpZiBTQVMgZGVidWdnaW5nIGlzIGVuYWJs
ZWQpLCB0aGUgbG9ncyB3aWxsIGZpbGwgd2l0aDoKCmtlcm5lbDogbXBpX3NzcF9jb21wbGV0aW9u
IDIxMTk6ZTIxOlNTUCBJTyBzdGF0dXMgMHgxMyB0YWcgMHhjYzFjMDAwMCBkbGVuPTkwIHBhcmFt
PTB4ZQprZXJuZWw6IHd3bj01MDAwYzUwMDM0MDY5ZTg2ICBjZGI9MTIgMDAgMDAgMDAgNWEgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKa2VybmVsOiBzYXM6IGxsZGRfZXhlY3V0ZV90
YXNrIHJldHVybmVkOiAxMzgKa2VybmVsOiBzYXM6IGxsZGRfZXhlY3V0ZV90YXNrIHJldHVybmVk
OiAxMzgKa2VybmVsOiBzYXM6IGxsZGRfZXhlY3V0ZV90YXNrIHJldHVybmVkOiAxMzgKa2VybmVs
OiBzYXM6IGxsZGRfZXhlY3V0ZV90YXNrIHJldHVybmVkOiAxMzgKa2VybmVsOiBzYXM6IGxsZGRf
ZXhlY3V0ZV90YXNrIHJldHVybmVkOiAxMzgKa2VybmVsOiBzYXM6IGxsZGRfZXhlY3V0ZV90YXNr
IHJldHVybmVkOiAxMzgKa2VybmVsOiBzYXM6IGxsZGRfZXhlY3V0ZV90YXNrIHJldHVybmVkOiAx
MzgKLiAuIC4KClRoaXMgcGF0Y2ggY2hhbmdlcyB0byBsZXZlcmFnZSB0aGUgcG9ydF9hdHRhY2hl
ZCBsb2dpYyB0byBjb21wbGV0ZSB0aGUgY29tbWFuZCB3aXRoIGEgc3RhdHVzIG9mIFBIWV9ET1dO
IHNvIHRoYXQgdGhlIGRpc3Bvc2l0aW9uIGNhbiBiZSBoYW5kbGVkIGltbWVkaWF0ZWx5IGFuZCBj
b3JyZWN0bHkuCgpTaWduZWQtb2ZmLWJ5OiBNYXJrIFNhbHl6eW4gPG1hcmtfc2FseXp5bkB4eXVz
Lnh5cmF0ZXguY29tPgpDYzogSmFtZXMgQm90dG9tbGV5IDxqYm90dG9tbGV5QHBhcmFsbGVscy5j
b20+CkNjOiBKYWNrIFdhbmcgPGphY2tfd2FuZ0B1c2lzaC5jb20+CgogcG04MDAxX3Nhcy5jIHwg
ICAxNSArLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMTQg
ZGVsZXRpb25zKC0pCgpkaWZmIC1ydSBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9wbTgwMDEv
cG04MDAxX3Nhcy5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9wbTgwMDEvcG04MDAx
X3Nhcy5jCi0tLSBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9wbTgwMDEvcG04MDAxX3Nhcy5j
CTIwMTEtMDgtMzEgMDg6MzI6MjEuMDAwMDAwMDAwIC0wNDAwCisrKyBzY3NpLW1pc2MtMi42Lm5l
dy9kcml2ZXJzL3Njc2kvcG04MDAxL3BtODAwMV9zYXMuYwkyMDExLTA5LTIyIDExOjM2OjI0LjAw
MDAwMDAwMCAtMDQwMApAQCAtMzg1LDIxICszODUsOCBAQAogCWRvIHsKIAkJZGV2ID0gdC0+ZGV2
OwogCQlwbTgwMDFfZGV2ID0gZGV2LT5sbGRkX2RldjsKLQkJaWYgKERFVl9JU19HT05FKHBtODAw
MV9kZXYpKSB7Ci0JCQlpZiAocG04MDAxX2RldikgewotCQkJCVBNODAwMV9JT19EQkcocG04MDAx
X2hhLAotCQkJCQlwbTgwMDFfcHJpbnRrKCJkZXZpY2UgJWQgbm90IHJlYWR5LlxuIiwKLQkJCQkJ
cG04MDAxX2Rldi0+ZGV2aWNlX2lkKSk7Ci0JCQl9IGVsc2UgewotCQkJCVBNODAwMV9JT19EQkco
cG04MDAxX2hhLAotCQkJCQlwbTgwMDFfcHJpbnRrKCJkZXZpY2UgJTAxNmxseCBub3QgIgotCQkJ
CQkicmVhZHkuXG4iLCBTQVNfQUREUihkZXYtPnNhc19hZGRyKSkpOwotCQkJfQotCQkJcmMgPSBT
QVNfUEhZX0RPV047Ci0JCQlnb3RvIG91dF9kb25lOwotCQl9CiAJCXBvcnQgPSAmcG04MDAxX2hh
LT5wb3J0W3Nhc19maW5kX2xvY2FsX3BvcnRfaWQoZGV2KV07Ci0JCWlmICghcG9ydC0+cG9ydF9h
dHRhY2hlZCkgeworCQlpZiAoREVWX0lTX0dPTkUocG04MDAxX2RldikgfHwgIXBvcnQtPnBvcnRf
YXR0YWNoZWQpIHsKIAkJCWlmIChzYXNfcHJvdG9jb2xfYXRhKHQtPnRhc2tfcHJvdG8pKSB7CiAJ
CQkJc3RydWN0IHRhc2tfc3RhdHVzX3N0cnVjdCAqdHMgPSAmdC0+dGFza19zdGF0dXM7CiAJCQkJ
dHMtPnJlc3AgPSBTQVNfVEFTS19VTkRFTElWRVJFRDsK

------_=_NextPart_001_01CC793F.4A31200E--
