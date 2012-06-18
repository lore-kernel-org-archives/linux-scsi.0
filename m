From: Praveen Murali <pmurali@logicube.com>
Subject: [PATCH 3/3] Fix device detection issues with mvsas driver
Date: Mon, 18 Jun 2012 11:35:37 -0700
Message-ID: <1340044537.3712.23.camel@praveen-debian.lg.local>
Reply-To: pmurali@logicube.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-a9gAr3sOPBKjp6NRHCY+"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o144.mxlogic.net ([208.65.144.67]:36296 "EHLO
	p01c11o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2FRSo2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jun 2012 14:44:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-a9gAr3sOPBKjp6NRHCY+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

  I am using the Marvell SAS HBA (MV64460/64461/64462 System Controller,
Revision B (rev 01)), on a system running Ubuntu 12.04 stock kernel. And
i am seeing some drive detection issues with SATA drives, mostly during
hotplugging the drives; the issue gets exaggerated when we keep removing
and plugging in drives.=20

=46rom dmesg, after starting the LibATA debugs, it looks like the
ata_eh_revalidate_and_attach fails because ata_dev_read_id fails to get
the IDENTIFY command response. I see "both IDENTIFYs aborted, assuming
NODEV" for all these drives that go undetected. At this point, if I
unload and reload the mvsas driver, these drives detect fine. So, I
hooked up a SATA analyzer between the HBA and one of the drives, and
restarted the test. From what I can see, even though the drive responds
to the IDENTIFY command, the upper layer detects an error and discards
the response. On further debugging it was evident that the error was
being detected in the FIS.=20

 After going thru the mvsas driver, I see that the driver allocates a
DMA area for an FIS pool (for as many as 33 FIS's) and initializes it to
0. And each ATA command is allocated a FIS area from this pool during
the command prep; but its never cleared.=20

This change initializes the FIS area before using it and it fixes the
drive detection issue. I have tested it with kernel 3.2.0.=20

---
 drivers/scsi/mvsas/mv_sas.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index a4884a5..31bfd4e 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -21,6 +21,16 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
  * USA
+ *
+ * Changelog:
+ *	Praveen Murali <pmurali@logicube.com>	May 15, 2012
+ *		Cleanup and prepare the FIS index before issuing the
+ *		ATA command (during prep: mvs_task_prep_ata). This is
+ *		to overcome the drive detection issue where the SATA drives
+ *		fail to get detected during hotplug since the ATA module
+ *		(libATA) detects errors set in the FIS eventhough the SATA
+ *		analyzer shows that the IDENTIFY command was successfull.
+ *
 */
=20
 #include "mv_sas.h"
@@ -458,6 +468,10 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 			mvi_dev->device_id);
 		return -EBUSY;
 	}
+
+	/* cleanup and prepare the aloocated FIS index */
+	memset( SATA_RECEIVED_D2H_FIS(mvi_dev->taskfileset), 0, sizeof(struct
dev_to_host_fis) );
+
 	slot =3D &mvi->slot_info[tag];
 	slot->tx =3D mvi->tx_prod;
 	del_q =3D TXQ_MODE_I | tag |
--=20
1.7.10


--=-a9gAr3sOPBKjp6NRHCY+
Content-Disposition: attachment;
	filename="0003-Fix-device-detection-issues-with-mvsas-driver.patch"
Content-Transfer-Encoding: base64
Content-Type: text/x-patch;
	name="0003-Fix-device-detection-issues-with-mvsas-driver.patch";
	charset="UTF-8"

RnJvbSAwYWMxYzYxZGNhNGNlMzAzYzcyMzNjM2VkNjVjMDNlYjJiZmZmMjhjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogUHJhdmVlbiBNdXJhbGkgPHBtdXJhbGlAbG9naWN1YmUuY29t
Pg0KRGF0ZTogVGh1LCAxNCBKdW4gMjAxMiAxODozMDowMSAtMDcwMA0KU3ViamVjdDogW1BBVENI
IDMvM10gRml4IGRldmljZSBkZXRlY3Rpb24gaXNzdWVzIHdpdGggbXZzYXMgZHJpdmVyDQoNClRo
aXMgY2hhbmdlIGZpeGVzIHRoZSBkcml2ZSBkZXRlY3Rpb24gaXNzdWUgd2hlcmUgdGhlIFNBVEEg
ZHJpdmVzIGZhaWwgdG8NCmdldCBkZXRlY3RlZCBkdXJpbmcgaG90cGx1ZyBzaW5jZSB0aGUgQVRB
IG1vZHVsZSAobGliQVRBKSBkZXRlY3RzIGVycm9ycyBzZXQNCmluIHRoZSBGSVMgZXZlbnRob3Vn
aCB0aGUgU0FUQSBhbmFseXplciBzaG93cyB0aGF0IHRoZSBJREVOVElGWSBjb21tYW5kIHdhcw0K
c3VjY2Vzc2Z1bGwuDQotLS0NCiBkcml2ZXJzL3Njc2kvbXZzYXMvbXZfc2FzLmMgfCAgIDE0ICsr
KysrKysrKysrKysrDQogMSBmaWxlIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKykNCg0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc2NzaS9tdnNhcy9tdl9zYXMuYyBiL2RyaXZlcnMvc2NzaS9tdnNhcy9t
dl9zYXMuYw0KaW5kZXggYTQ4ODRhNS4uMzFiZmQ0ZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2Nz
aS9tdnNhcy9tdl9zYXMuYw0KKysrIGIvZHJpdmVycy9zY3NpL212c2FzL212X3Nhcy5jDQpAQCAt
MjEsNiArMjEsMTYgQEANCiAgKiBhbG9uZyB3aXRoIHRoaXMgcHJvZ3JhbTsgaWYgbm90LCB3cml0
ZSB0byB0aGUgRnJlZSBTb2Z0d2FyZQ0KICAqIEZvdW5kYXRpb24sIEluYy4sIDU5IFRlbXBsZSBQ
bGFjZSwgU3VpdGUgMzMwLCBCb3N0b24sIE1BIDAyMTExLTEzMDcNCiAgKiBVU0ENCisgKg0KKyAq
IENoYW5nZWxvZzoNCisgKglQcmF2ZWVuIE11cmFsaSA8cG11cmFsaUBsb2dpY3ViZS5jb20+CU1h
eSAxNSwgMjAxMg0KKyAqCQlDbGVhbnVwIGFuZCBwcmVwYXJlIHRoZSBGSVMgaW5kZXggYmVmb3Jl
IGlzc3VpbmcgdGhlDQorICoJCUFUQSBjb21tYW5kIChkdXJpbmcgcHJlcDogbXZzX3Rhc2tfcHJl
cF9hdGEpLiBUaGlzIGlzDQorICoJCXRvIG92ZXJjb21lIHRoZSBkcml2ZSBkZXRlY3Rpb24gaXNz
dWUgd2hlcmUgdGhlIFNBVEEgZHJpdmVzDQorICoJCWZhaWwgdG8gZ2V0IGRldGVjdGVkIGR1cmlu
ZyBob3RwbHVnIHNpbmNlIHRoZSBBVEEgbW9kdWxlDQorICoJCShsaWJBVEEpIGRldGVjdHMgZXJy
b3JzIHNldCBpbiB0aGUgRklTIGV2ZW50aG91Z2ggdGhlIFNBVEENCisgKgkJYW5hbHl6ZXIgc2hv
d3MgdGhhdCB0aGUgSURFTlRJRlkgY29tbWFuZCB3YXMgc3VjY2Vzc2Z1bGwuDQorICoNCiAqLw0K
IA0KICNpbmNsdWRlICJtdl9zYXMuaCINCkBAIC00NTgsNiArNDY4LDEwIEBAIHN0YXRpYyBpbnQg
bXZzX3Rhc2tfcHJlcF9hdGEoc3RydWN0IG12c19pbmZvICptdmksDQogCQkJbXZpX2Rldi0+ZGV2
aWNlX2lkKTsNCiAJCXJldHVybiAtRUJVU1k7DQogCX0NCisNCisJLyogY2xlYW51cCBhbmQgcHJl
cGFyZSB0aGUgYWxvb2NhdGVkIEZJUyBpbmRleCAqLw0KKwltZW1zZXQoIFNBVEFfUkVDRUlWRURf
RDJIX0ZJUyhtdmlfZGV2LT50YXNrZmlsZXNldCksIDAsIHNpemVvZihzdHJ1Y3QgZGV2X3RvX2hv
c3RfZmlzKSApOw0KKw0KIAlzbG90ID0gJm12aS0+c2xvdF9pbmZvW3RhZ107DQogCXNsb3QtPnR4
ID0gbXZpLT50eF9wcm9kOw0KIAlkZWxfcSA9IFRYUV9NT0RFX0kgfCB0YWcgfA0KLS0gDQoxLjcu
MTANCg0K


--=-a9gAr3sOPBKjp6NRHCY+--
