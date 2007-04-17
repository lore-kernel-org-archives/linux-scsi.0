From: "Seokmann Ju" <seokmann.ju@qlogic.com>
Subject: RE: Major qla2xxx regression on sparc64
Date: Tue, 17 Apr 2007 11:28:07 -0700
Message-ID: <A6970E9A290F3F4682E1EAD0EA14F32BDF5854@AVEXCH2.qlogic.org>
References: <20070416234705.GA15937@dmccrory-d810.qlogic.org><20070416.170504.02298047.davem@davemloft.net><20070417024107.GE16469@dmccrory-d810.qlogic.org> <20070416.220208.94071670.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7811E.1653B84E"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:51125 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161377AbXDQS17 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Apr 2007 14:27:59 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070416.220208.94071670.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>, Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, ema@debian.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7811E.1653B84E
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello David,
On Mon 4/16/2007 10:02 PM, David Miller wrote:
> > I'm in transit for a redeye to NY so I won't be able to modify the=20
> > patch, If you would be amenable to the above, Seokmann, could you=20
> > rework the patch?
>=20
> Thanks guys.
Here, I've attached updated patch. Please take this.
Sorry for late.

Thank you,

Seokmann
---
diff -Naur linux-2.6.git/drivers/scsi/qla2xxx/qla_gbl.h
linux-2.6.git-nvram/drivers/scsi/qla2xxx/qla_gbl.h
--- linux-2.6.git/drivers/scsi/qla2xxx/qla_gbl.h        2007-04-17
11:06:39.000000000 -0700
+++ linux-2.6.git-nvram/drivers/scsi/qla2xxx/qla_gbl.h  2007-04-17
11:07:24.000000000 -0700
@@ -62,6 +62,7 @@
 extern int ql2xallocfwdump;
 extern int ql2xextended_error_logging;
 extern int ql2xqfullrampup;
+extern int ql2xoverrideinvalidnvram;

 extern void qla2x00_sp_compl(scsi_qla_host_t *, srb_t *);

diff -Naur linux-2.6.git/drivers/scsi/qla2xxx/qla_init.c
linux-2.6.git-nvram/drivers/scsi/qla2xxx/qla_init.c
--- linux-2.6.git/drivers/scsi/qla2xxx/qla_init.c       2007-04-17
11:06:39.000000000 -0700
+++ linux-2.6.git-nvram/drivers/scsi/qla2xxx/qla_init.c 2007-04-17
11:07:24.000000000 -0700
@@ -11,6 +11,11 @@

 #include "qla_devtbl.h"

+#ifdef CONFIG_SPARC
+#include <asm/prom.h>
+#include <asm/pbm.h>
+#endif
+
 /* XXX(hch): this is ugly, but we don't want to pull in exioctl.h */
 #ifndef EXT_IS_LUN_BIT_SET
 #define EXT_IS_LUN_BIT_SET(P,L) \
@@ -1393,6 +1398,42 @@
        }
 }

+/* On sparc systems, obtain port and node WWN from firmware
+ * properties.
+ */
+static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *ha, nvram_t
*nv)
+{
+#ifdef CONFIG_SPARC
+       struct pci_dev *pdev =3D ha->pdev;
+       struct pcidev_cookie *pcp =3D pdev->sysdata;
+       struct device_node *dp =3D pcp->prom_node;
+       u8 *val;
+       int len;
+
+       val =3D of_get_property(dp, "port-wwn", &len);
+       if (val && len >=3D WWN_SIZE)
+               memcpy(nv->port_name, val, WWN_SIZE);
+
+       val =3D of_get_property(dp, "node-wwn", &len);
+       if (val && len >=3D WWN_SIZE)
+               memcpy(nv->node_name, val, WWN_SIZE);
+#endif
+}
+
+static inline int
+qla2x00_override_invalid_nvram(scsi_qla_host_t *ha)
+{
+       if (!ql2xoverrideinvalidnvram) {
+               qla_printk(KERN_WARNING, ha,
+                   "Reload the driver with the ql2xoverrideinvalidnvram
\n");
+               qla_printk(KERN_WARNING, ha,
+                   " module parameter set to a non-zero value to ignore
\n");
+               qla_printk(KERN_WARNING, ha,
+                   " this warning.\n");
+       }
+       return ql2xoverrideinvalidnvram;
+}
+
 /*
 * NVRAM configuration for ISP 2xxx
 *
@@ -1440,7 +1481,58 @@
                qla_printk(KERN_WARNING, ha, "Inconsistent NVRAM
detected: "
                    "checksum=3D0x%x id=3D%c version=3D0x%x.\n", chksum,
nv->id[0],
                    nv->nvram_version);
-               return QLA_FUNCTION_FAILED;
+               if (!qla2x00_override_invalid_nvram(ha))
+                       return QLA_FUNCTION_FAILED;
+               qla_printk(KERN_WARNING, ha, "FC IDs may conflict and
cause "
+                   "miscommunication - please report this to QLogic "
+                   "(linux-driver@qlogic.com).\n");
+
+               /*
+                * Set default initialization control block.
+                */
+               memset(nv, 0, ha->nvram_size);
+               nv->parameter_block_version =3D ICB_VERSION;
+
+               if (IS_QLA23XX(ha)) {
+                       nv->firmware_options[0] =3D BIT_2 | BIT_1;
+                       nv->firmware_options[1] =3D BIT_7 | BIT_5;
+                       nv->add_firmware_options[0] =3D BIT_5;
+                       nv->add_firmware_options[1] =3D BIT_5 | BIT_4;
+                       nv->frame_payload_size =3D
__constant_cpu_to_le16(2048);
+                       nv->special_options[1] =3D BIT_7;
+               } else if (IS_QLA2200(ha)) {
+                       nv->firmware_options[0] =3D BIT_2 | BIT_1;
+                       nv->firmware_options[1] =3D BIT_7 | BIT_5;
+                       nv->add_firmware_options[0] =3D BIT_5;
+                       nv->add_firmware_options[1] =3D BIT_5 | BIT_4;
+                       nv->frame_payload_size =3D
__constant_cpu_to_le16(1024);
+               } else if (IS_QLA2100(ha)) {
+                       nv->firmware_options[0] =3D BIT_3 | BIT_1;
+                       nv->firmware_options[1] =3D BIT_5;
+                       nv->frame_payload_size =3D
__constant_cpu_to_le16(1024);
+               }
+
+               nv->max_iocb_allocation =3D __constant_cpu_to_le16(256);
+               nv->execution_throttle =3D __constant_cpu_to_le16(16);
+               nv->retry_count =3D 8;
+               nv->retry_delay =3D 1;
+
+               nv->port_name[0] =3D 33;
+               nv->port_name[3] =3D 224;
+               nv->port_name[4] =3D 139;
+
+               qla2xxx_nvram_wwn_from_ofw(ha, nv);
+
+               nv->login_timeout =3D 4;
+
+               /*
+                * Set default host adapter parameters
+                */
+               nv->host_p[1] =3D BIT_2;
+               nv->reset_delay =3D 5;
+               nv->port_down_retry_count =3D 8;
+               nv->max_luns_per_target =3D __constant_cpu_to_le16(8);
+               nv->link_down_timeout =3D 60;
        }

 #if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
@@ -3290,6 +3382,28 @@
        spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }

+/* On sparc systems, obtain port and node WWN from firmware
+ * properties.
+ */
+static void qla24xx_nvram_wwn_from_ofw(scsi_qla_host_t *ha, struct
nvram_24xx *nv)
+{
+#ifdef CONFIG_SPARC
+       struct pci_dev *pdev =3D ha->pdev;
+       struct pcidev_cookie *pcp =3D pdev->sysdata;
+       struct device_node *dp =3D pcp->prom_node;
+       u8 *val;
+       int len;
+
+       val =3D of_get_property(dp, "port-wwn", &len);
+       if (val && len >=3D WWN_SIZE)
+               memcpy(nv->port_name, val, WWN_SIZE);
+
+       val =3D of_get_property(dp, "node-wwn", &len);
+       if (val && len >=3D WWN_SIZE)
+               memcpy(nv->node_name, val, WWN_SIZE);
+#endif
+}
+
 int
 qla24xx_nvram_config(scsi_qla_host_t *ha)
 {
@@ -3332,7 +3446,53 @@
                qla_printk(KERN_WARNING, ha, "Inconsistent NVRAM
detected: "
                    "checksum=3D0x%x id=3D%c version=3D0x%x.\n", chksum,
nv->id[0],
                    le16_to_cpu(nv->nvram_version));
-               return QLA_FUNCTION_FAILED;
+               if (!qla2x00_override_invalid_nvram(ha))
+                       return QLA_FUNCTION_FAILED;
+               qla_printk(KERN_WARNING, ha, "FC IDs may conflict and
cause "
+                   "miscommunication - please report this to QLogic "
+                   "(linux-driver@qlogic.com).\n");
+
+               /*
+                * Set default initialization control block.
+                */
+               memset(nv, 0, ha->nvram_size);
+               nv->nvram_version =3D =
__constant_cpu_to_le16(ICB_VERSION);
+               nv->version =3D __constant_cpu_to_le16(ICB_VERSION);
+               nv->frame_payload_size =3D __constant_cpu_to_le16(2048);
+               nv->execution_throttle =3D =
__constant_cpu_to_le16(0xFFFF);
+               nv->exchange_count =3D __constant_cpu_to_le16(0);
+               nv->hard_address =3D __constant_cpu_to_le16(124);
+               nv->port_name[0] =3D 0x21;
+               nv->port_name[1] =3D 0x00 + PCI_FUNC(ha->pdev->devfn);
+               nv->port_name[2] =3D 0x00;
+               nv->port_name[3] =3D 0xe0;
+               nv->port_name[4] =3D 0x8b;
+               nv->port_name[5] =3D 0x1c;
+               nv->port_name[6] =3D 0x55;
+               nv->port_name[7] =3D 0x86;
+               nv->node_name[0] =3D 0x20;
+               nv->node_name[1] =3D 0x00;
+               nv->node_name[2] =3D 0x00;
+               nv->node_name[3] =3D 0xe0;
+               nv->node_name[4] =3D 0x8b;
+               nv->node_name[5] =3D 0x1c;
+               nv->node_name[6] =3D 0x55;
+               nv->node_name[7] =3D 0x86;
+               qla24xx_nvram_wwn_from_ofw(ha, nv);
+               nv->login_retry_count =3D __constant_cpu_to_le16(8);
+               nv->interrupt_delay_timer =3D __constant_cpu_to_le16(0);
+               nv->login_timeout =3D __constant_cpu_to_le16(0);
+               nv->firmware_options_1 =3D
+                   __constant_cpu_to_le32(BIT_14|BIT_13|BIT_2|BIT_1);
+               nv->firmware_options_2 =3D __constant_cpu_to_le32(2 << =
4);
+               nv->firmware_options_2 |=3D
__constant_cpu_to_le32(BIT_12);
+               nv->firmware_options_3 =3D __constant_cpu_to_le32(2 <<
13);
+               nv->host_p =3D __constant_cpu_to_le32(BIT_11|BIT_10);
+               nv->efi_parameters =3D __constant_cpu_to_le32(0);
+               nv->reset_delay =3D 5;
+               nv->max_luns_per_target =3D __constant_cpu_to_le16(128);
+               nv->port_down_retry_count =3D =
__constant_cpu_to_le16(30);
+               nv->link_down_timeout =3D __constant_cpu_to_le16(30);
        }

        /* Reset Initialization control block */
diff -Naur linux-2.6.git/drivers/scsi/qla2xxx/qla_os.c
linux-2.6.git-nvram/drivers/scsi/qla2xxx/qla_os.c
--- linux-2.6.git/drivers/scsi/qla2xxx/qla_os.c 2007-04-17
11:06:39.000000000 -0700
+++ linux-2.6.git-nvram/drivers/scsi/qla2xxx/qla_os.c   2007-04-17
11:07:24.000000000 -0700
@@ -90,6 +90,13 @@
                "depth for a device after a queue-full condition has
been "
                "detected.  Default is 120 seconds.");

+int ql2xoverrideinvalidnvram;
+module_param(ql2xoverrideinvalidnvram, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xoverrideinvalidnvram,
+               "When set and upon detecting an invalid or non-present "
+               "NVRAM state, use doctored settings (potentially
invalid) "
+               "to initialize the HBA.");
+
 /*
  * SCSI host template entry points
  */
@@ -1575,9 +1582,7 @@
                 goto probe_failed;
        }

-       if (qla2x00_initialize_adapter(ha) &&
-           !(ha->device_flags & DFLG_NO_CABLE)) {
-
+       if (qla2x00_initialize_adapter(ha)) {
                qla_printk(KERN_WARNING, ha,
                    "Failed to initialize adapter\n");

@@ -1733,7 +1738,8 @@
        ha->flags.online =3D 0;

        /* Stop currently executing firmware. */
-       qla2x00_try_to_stop_firmware(ha);
+       if (ha->fw_major_version)
+               qla2x00_try_to_stop_firmware(ha);

        /* turn-off interrupts on the card */
        if (ha->interrupts_on)
---

------_=_NextPart_001_01C7811E.1653B84E
Content-Type: application/octet-stream;
	name="nvram_override.patch"
Content-Transfer-Encoding: base64
Content-Description: nvram_override.patch
Content-Disposition: attachment;
	filename="nvram_override.patch"

ZGlmZiAtTmF1ciBsaW51eC0yLjYuZ2l0L2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9nYmwuaCBs
aW51eC0yLjYuZ2l0LW52cmFtL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9nYmwuaAotLS0gbGlu
dXgtMi42LmdpdC9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfZ2JsLmgJMjAwNy0wNC0xNyAxMTow
NjozOS4wMDAwMDAwMDAgLTA3MDAKKysrIGxpbnV4LTIuNi5naXQtbnZyYW0vZHJpdmVycy9zY3Np
L3FsYTJ4eHgvcWxhX2dibC5oCTIwMDctMDQtMTcgMTE6MDc6MjQuMDAwMDAwMDAwIC0wNzAwCkBA
IC02Miw2ICs2Miw3IEBACiBleHRlcm4gaW50IHFsMnhhbGxvY2Z3ZHVtcDsKIGV4dGVybiBpbnQg
cWwyeGV4dGVuZGVkX2Vycm9yX2xvZ2dpbmc7CiBleHRlcm4gaW50IHFsMnhxZnVsbHJhbXB1cDsK
K2V4dGVybiBpbnQgcWwyeG92ZXJyaWRlaW52YWxpZG52cmFtOwogCiBleHRlcm4gdm9pZCBxbGEy
eDAwX3NwX2NvbXBsKHNjc2lfcWxhX2hvc3RfdCAqLCBzcmJfdCAqKTsKIApkaWZmIC1OYXVyIGxp
bnV4LTIuNi5naXQvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYyBsaW51eC0yLjYuZ2l0
LW52cmFtL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMKLS0tIGxpbnV4LTIuNi5naXQv
ZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYwkyMDA3LTA0LTE3IDExOjA2OjM5LjAwMDAw
MDAwMCAtMDcwMAorKysgbGludXgtMi42LmdpdC1udnJhbS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9x
bGFfaW5pdC5jCTIwMDctMDQtMTcgMTE6MDc6MjQuMDAwMDAwMDAwIC0wNzAwCkBAIC0xMSw2ICsx
MSwxMSBAQAogCiAjaW5jbHVkZSAicWxhX2RldnRibC5oIgogCisjaWZkZWYgQ09ORklHX1NQQVJD
CisjaW5jbHVkZSA8YXNtL3Byb20uaD4KKyNpbmNsdWRlIDxhc20vcGJtLmg+CisjZW5kaWYKKwog
LyogWFhYKGhjaCk6IHRoaXMgaXMgdWdseSwgYnV0IHdlIGRvbid0IHdhbnQgdG8gcHVsbCBpbiBl
eGlvY3RsLmggKi8KICNpZm5kZWYgRVhUX0lTX0xVTl9CSVRfU0VUCiAjZGVmaW5lIEVYVF9JU19M
VU5fQklUX1NFVChQLEwpIFwKQEAgLTEzOTMsNiArMTM5OCw0MiBAQAogCX0KIH0KIAorLyogT24g
c3BhcmMgc3lzdGVtcywgb2J0YWluIHBvcnQgYW5kIG5vZGUgV1dOIGZyb20gZmlybXdhcmUKKyAq
IHByb3BlcnRpZXMuCisgKi8KK3N0YXRpYyB2b2lkIHFsYTJ4eHhfbnZyYW1fd3duX2Zyb21fb2Z3
KHNjc2lfcWxhX2hvc3RfdCAqaGEsIG52cmFtX3QgKm52KQoreworI2lmZGVmIENPTkZJR19TUEFS
QworCXN0cnVjdCBwY2lfZGV2ICpwZGV2ID0gaGEtPnBkZXY7CisJc3RydWN0IHBjaWRldl9jb29r
aWUgKnBjcCA9IHBkZXYtPnN5c2RhdGE7CisJc3RydWN0IGRldmljZV9ub2RlICpkcCA9IHBjcC0+
cHJvbV9ub2RlOworCXU4ICp2YWw7CisJaW50IGxlbjsKKworCXZhbCA9IG9mX2dldF9wcm9wZXJ0
eShkcCwgInBvcnQtd3duIiwgJmxlbik7CisJaWYgKHZhbCAmJiBsZW4gPj0gV1dOX1NJWkUpCisJ
CW1lbWNweShudi0+cG9ydF9uYW1lLCB2YWwsIFdXTl9TSVpFKTsKKworCXZhbCA9IG9mX2dldF9w
cm9wZXJ0eShkcCwgIm5vZGUtd3duIiwgJmxlbik7CisJaWYgKHZhbCAmJiBsZW4gPj0gV1dOX1NJ
WkUpCisJCW1lbWNweShudi0+bm9kZV9uYW1lLCB2YWwsIFdXTl9TSVpFKTsKKyNlbmRpZgorfQor
CitzdGF0aWMgaW5saW5lIGludAorcWxhMngwMF9vdmVycmlkZV9pbnZhbGlkX252cmFtKHNjc2lf
cWxhX2hvc3RfdCAqaGEpCit7CisJaWYgKCFxbDJ4b3ZlcnJpZGVpbnZhbGlkbnZyYW0pIHsKKwkJ
cWxhX3ByaW50ayhLRVJOX1dBUk5JTkcsIGhhLAorCQkgICAgIlJlbG9hZCB0aGUgZHJpdmVyIHdp
dGggdGhlIHFsMnhvdmVycmlkZWludmFsaWRudnJhbSBcbiIpOworCQlxbGFfcHJpbnRrKEtFUk5f
V0FSTklORywgaGEsCisJCSAgICAiIG1vZHVsZSBwYXJhbWV0ZXIgc2V0IHRvIGEgbm9uLXplcm8g
dmFsdWUgdG8gaWdub3JlIFxuIik7CisJCXFsYV9wcmludGsoS0VSTl9XQVJOSU5HLCBoYSwKKwkJ
ICAgICIgdGhpcyB3YXJuaW5nLlxuIik7CisJfQorCXJldHVybiBxbDJ4b3ZlcnJpZGVpbnZhbGlk
bnZyYW07Cit9CisKIC8qCiAqIE5WUkFNIGNvbmZpZ3VyYXRpb24gZm9yIElTUCAyeHh4CiAqCkBA
IC0xNDQwLDcgKzE0ODEsNTggQEAKIAkJcWxhX3ByaW50ayhLRVJOX1dBUk5JTkcsIGhhLCAiSW5j
b25zaXN0ZW50IE5WUkFNIGRldGVjdGVkOiAiCiAJCSAgICAiY2hlY2tzdW09MHgleCBpZD0lYyB2
ZXJzaW9uPTB4JXguXG4iLCBjaGtzdW0sIG52LT5pZFswXSwKIAkJICAgIG52LT5udnJhbV92ZXJz
aW9uKTsKLQkJcmV0dXJuIFFMQV9GVU5DVElPTl9GQUlMRUQ7CisJCWlmICghcWxhMngwMF9vdmVy
cmlkZV9pbnZhbGlkX252cmFtKGhhKSkKKwkJCXJldHVybiBRTEFfRlVOQ1RJT05fRkFJTEVEOwor
CQlxbGFfcHJpbnRrKEtFUk5fV0FSTklORywgaGEsICJGQyBJRHMgbWF5IGNvbmZsaWN0IGFuZCBj
YXVzZSAiCisJCSAgICAibWlzY29tbXVuaWNhdGlvbiAtIHBsZWFzZSByZXBvcnQgdGhpcyB0byBR
TG9naWMgIgorCQkgICAgIihsaW51eC1kcml2ZXJAcWxvZ2ljLmNvbSkuXG4iKTsKKworCQkvKgor
CQkgKiBTZXQgZGVmYXVsdCBpbml0aWFsaXphdGlvbiBjb250cm9sIGJsb2NrLgorCQkgKi8KKwkJ
bWVtc2V0KG52LCAwLCBoYS0+bnZyYW1fc2l6ZSk7CisJCW52LT5wYXJhbWV0ZXJfYmxvY2tfdmVy
c2lvbiA9IElDQl9WRVJTSU9OOworCisJCWlmIChJU19RTEEyM1hYKGhhKSkgeworCQkJbnYtPmZp
cm13YXJlX29wdGlvbnNbMF0gPSBCSVRfMiB8IEJJVF8xOworCQkJbnYtPmZpcm13YXJlX29wdGlv
bnNbMV0gPSBCSVRfNyB8IEJJVF81OworCQkJbnYtPmFkZF9maXJtd2FyZV9vcHRpb25zWzBdID0g
QklUXzU7CisJCQludi0+YWRkX2Zpcm13YXJlX29wdGlvbnNbMV0gPSBCSVRfNSB8IEJJVF80Owor
CQkJbnYtPmZyYW1lX3BheWxvYWRfc2l6ZSA9IF9fY29uc3RhbnRfY3B1X3RvX2xlMTYoMjA0OCk7
CisJCQludi0+c3BlY2lhbF9vcHRpb25zWzFdID0gQklUXzc7CisJCX0gZWxzZSBpZiAoSVNfUUxB
MjIwMChoYSkpIHsKKwkJCW52LT5maXJtd2FyZV9vcHRpb25zWzBdID0gQklUXzIgfCBCSVRfMTsK
KwkJCW52LT5maXJtd2FyZV9vcHRpb25zWzFdID0gQklUXzcgfCBCSVRfNTsKKwkJCW52LT5hZGRf
ZmlybXdhcmVfb3B0aW9uc1swXSA9IEJJVF81OworCQkJbnYtPmFkZF9maXJtd2FyZV9vcHRpb25z
WzFdID0gQklUXzUgfCBCSVRfNDsKKwkJCW52LT5mcmFtZV9wYXlsb2FkX3NpemUgPSBfX2NvbnN0
YW50X2NwdV90b19sZTE2KDEwMjQpOworCQl9IGVsc2UgaWYgKElTX1FMQTIxMDAoaGEpKSB7CisJ
CQludi0+ZmlybXdhcmVfb3B0aW9uc1swXSA9IEJJVF8zIHwgQklUXzE7CisJCQludi0+ZmlybXdh
cmVfb3B0aW9uc1sxXSA9IEJJVF81OworCQkJbnYtPmZyYW1lX3BheWxvYWRfc2l6ZSA9IF9fY29u
c3RhbnRfY3B1X3RvX2xlMTYoMTAyNCk7CisJCX0KKworCQludi0+bWF4X2lvY2JfYWxsb2NhdGlv
biA9IF9fY29uc3RhbnRfY3B1X3RvX2xlMTYoMjU2KTsKKwkJbnYtPmV4ZWN1dGlvbl90aHJvdHRs
ZSA9IF9fY29uc3RhbnRfY3B1X3RvX2xlMTYoMTYpOworCQludi0+cmV0cnlfY291bnQgPSA4Owor
CQludi0+cmV0cnlfZGVsYXkgPSAxOworCisJCW52LT5wb3J0X25hbWVbMF0gPSAzMzsKKwkJbnYt
PnBvcnRfbmFtZVszXSA9IDIyNDsKKwkJbnYtPnBvcnRfbmFtZVs0XSA9IDEzOTsKKworCQlxbGEy
eHh4X252cmFtX3d3bl9mcm9tX29mdyhoYSwgbnYpOworCisJCW52LT5sb2dpbl90aW1lb3V0ID0g
NDsKKworCQkvKgorCQkgKiBTZXQgZGVmYXVsdCBob3N0IGFkYXB0ZXIgcGFyYW1ldGVycworCQkg
Ki8KKwkJbnYtPmhvc3RfcFsxXSA9IEJJVF8yOworCQludi0+cmVzZXRfZGVsYXkgPSA1OworCQlu
di0+cG9ydF9kb3duX3JldHJ5X2NvdW50ID0gODsKKwkJbnYtPm1heF9sdW5zX3Blcl90YXJnZXQg
PSBfX2NvbnN0YW50X2NwdV90b19sZTE2KDgpOworCQludi0+bGlua19kb3duX3RpbWVvdXQgPSA2
MDsKIAl9CiAKICNpZiBkZWZpbmVkKENPTkZJR19JQTY0X0dFTkVSSUMpIHx8IGRlZmluZWQoQ09O
RklHX0lBNjRfU0dJX1NOMikKQEAgLTMyOTAsNiArMzM4MiwyOCBAQAogCXNwaW5fdW5sb2NrX2ly
cXJlc3RvcmUoJmhhLT5oYXJkd2FyZV9sb2NrLCBmbGFncyk7CiB9CiAKKy8qIE9uIHNwYXJjIHN5
c3RlbXMsIG9idGFpbiBwb3J0IGFuZCBub2RlIFdXTiBmcm9tIGZpcm13YXJlCisgKiBwcm9wZXJ0
aWVzLgorICovCitzdGF0aWMgdm9pZCBxbGEyNHh4X252cmFtX3d3bl9mcm9tX29mdyhzY3NpX3Fs
YV9ob3N0X3QgKmhhLCBzdHJ1Y3QgbnZyYW1fMjR4eCAqbnYpCit7CisjaWZkZWYgQ09ORklHX1NQ
QVJDCisJc3RydWN0IHBjaV9kZXYgKnBkZXYgPSBoYS0+cGRldjsKKwlzdHJ1Y3QgcGNpZGV2X2Nv
b2tpZSAqcGNwID0gcGRldi0+c3lzZGF0YTsKKwlzdHJ1Y3QgZGV2aWNlX25vZGUgKmRwID0gcGNw
LT5wcm9tX25vZGU7CisJdTggKnZhbDsKKwlpbnQgbGVuOworCisJdmFsID0gb2ZfZ2V0X3Byb3Bl
cnR5KGRwLCAicG9ydC13d24iLCAmbGVuKTsKKwlpZiAodmFsICYmIGxlbiA+PSBXV05fU0laRSkK
KwkJbWVtY3B5KG52LT5wb3J0X25hbWUsIHZhbCwgV1dOX1NJWkUpOworCisJdmFsID0gb2ZfZ2V0
X3Byb3BlcnR5KGRwLCAibm9kZS13d24iLCAmbGVuKTsKKwlpZiAodmFsICYmIGxlbiA+PSBXV05f
U0laRSkKKwkJbWVtY3B5KG52LT5ub2RlX25hbWUsIHZhbCwgV1dOX1NJWkUpOworI2VuZGlmCit9
CisKIGludAogcWxhMjR4eF9udnJhbV9jb25maWcoc2NzaV9xbGFfaG9zdF90ICpoYSkKIHsKQEAg
LTMzMzIsNyArMzQ0Niw1MyBAQAogCQlxbGFfcHJpbnRrKEtFUk5fV0FSTklORywgaGEsICJJbmNv
bnNpc3RlbnQgTlZSQU0gZGV0ZWN0ZWQ6ICIKIAkJICAgICJjaGVja3N1bT0weCV4IGlkPSVjIHZl
cnNpb249MHgleC5cbiIsIGNoa3N1bSwgbnYtPmlkWzBdLAogCQkgICAgbGUxNl90b19jcHUobnYt
Pm52cmFtX3ZlcnNpb24pKTsKLQkJcmV0dXJuIFFMQV9GVU5DVElPTl9GQUlMRUQ7CisJCWlmICgh
cWxhMngwMF9vdmVycmlkZV9pbnZhbGlkX252cmFtKGhhKSkKKwkJCXJldHVybiBRTEFfRlVOQ1RJ
T05fRkFJTEVEOworCQlxbGFfcHJpbnRrKEtFUk5fV0FSTklORywgaGEsICJGQyBJRHMgbWF5IGNv
bmZsaWN0IGFuZCBjYXVzZSAiCisJCSAgICAibWlzY29tbXVuaWNhdGlvbiAtIHBsZWFzZSByZXBv
cnQgdGhpcyB0byBRTG9naWMgIgorCQkgICAgIihsaW51eC1kcml2ZXJAcWxvZ2ljLmNvbSkuXG4i
KTsKKworCQkvKgorCQkgKiBTZXQgZGVmYXVsdCBpbml0aWFsaXphdGlvbiBjb250cm9sIGJsb2Nr
LgorCQkgKi8KKwkJbWVtc2V0KG52LCAwLCBoYS0+bnZyYW1fc2l6ZSk7CisJCW52LT5udnJhbV92
ZXJzaW9uID0gX19jb25zdGFudF9jcHVfdG9fbGUxNihJQ0JfVkVSU0lPTik7CisJCW52LT52ZXJz
aW9uID0gX19jb25zdGFudF9jcHVfdG9fbGUxNihJQ0JfVkVSU0lPTik7CisJCW52LT5mcmFtZV9w
YXlsb2FkX3NpemUgPSBfX2NvbnN0YW50X2NwdV90b19sZTE2KDIwNDgpOworCQludi0+ZXhlY3V0
aW9uX3Rocm90dGxlID0gX19jb25zdGFudF9jcHVfdG9fbGUxNigweEZGRkYpOworCQludi0+ZXhj
aGFuZ2VfY291bnQgPSBfX2NvbnN0YW50X2NwdV90b19sZTE2KDApOworCQludi0+aGFyZF9hZGRy
ZXNzID0gX19jb25zdGFudF9jcHVfdG9fbGUxNigxMjQpOworCQludi0+cG9ydF9uYW1lWzBdID0g
MHgyMTsKKwkJbnYtPnBvcnRfbmFtZVsxXSA9IDB4MDAgKyBQQ0lfRlVOQyhoYS0+cGRldi0+ZGV2
Zm4pOworCQludi0+cG9ydF9uYW1lWzJdID0gMHgwMDsKKwkJbnYtPnBvcnRfbmFtZVszXSA9IDB4
ZTA7CisJCW52LT5wb3J0X25hbWVbNF0gPSAweDhiOworCQludi0+cG9ydF9uYW1lWzVdID0gMHgx
YzsKKwkJbnYtPnBvcnRfbmFtZVs2XSA9IDB4NTU7CisJCW52LT5wb3J0X25hbWVbN10gPSAweDg2
OworCQludi0+bm9kZV9uYW1lWzBdID0gMHgyMDsKKwkJbnYtPm5vZGVfbmFtZVsxXSA9IDB4MDA7
CisJCW52LT5ub2RlX25hbWVbMl0gPSAweDAwOworCQludi0+bm9kZV9uYW1lWzNdID0gMHhlMDsK
KwkJbnYtPm5vZGVfbmFtZVs0XSA9IDB4OGI7CisJCW52LT5ub2RlX25hbWVbNV0gPSAweDFjOwor
CQludi0+bm9kZV9uYW1lWzZdID0gMHg1NTsKKwkJbnYtPm5vZGVfbmFtZVs3XSA9IDB4ODY7CisJ
CXFsYTI0eHhfbnZyYW1fd3duX2Zyb21fb2Z3KGhhLCBudik7CisJCW52LT5sb2dpbl9yZXRyeV9j
b3VudCA9IF9fY29uc3RhbnRfY3B1X3RvX2xlMTYoOCk7CisJCW52LT5pbnRlcnJ1cHRfZGVsYXlf
dGltZXIgPSBfX2NvbnN0YW50X2NwdV90b19sZTE2KDApOworCQludi0+bG9naW5fdGltZW91dCA9
IF9fY29uc3RhbnRfY3B1X3RvX2xlMTYoMCk7CisJCW52LT5maXJtd2FyZV9vcHRpb25zXzEgPQor
CQkgICAgX19jb25zdGFudF9jcHVfdG9fbGUzMihCSVRfMTR8QklUXzEzfEJJVF8yfEJJVF8xKTsK
KwkJbnYtPmZpcm13YXJlX29wdGlvbnNfMiA9IF9fY29uc3RhbnRfY3B1X3RvX2xlMzIoMiA8PCA0
KTsKKwkJbnYtPmZpcm13YXJlX29wdGlvbnNfMiB8PSBfX2NvbnN0YW50X2NwdV90b19sZTMyKEJJ
VF8xMik7CisJCW52LT5maXJtd2FyZV9vcHRpb25zXzMgPSBfX2NvbnN0YW50X2NwdV90b19sZTMy
KDIgPDwgMTMpOworCQludi0+aG9zdF9wID0gX19jb25zdGFudF9jcHVfdG9fbGUzMihCSVRfMTF8
QklUXzEwKTsKKwkJbnYtPmVmaV9wYXJhbWV0ZXJzID0gX19jb25zdGFudF9jcHVfdG9fbGUzMigw
KTsKKwkJbnYtPnJlc2V0X2RlbGF5ID0gNTsKKwkJbnYtPm1heF9sdW5zX3Blcl90YXJnZXQgPSBf
X2NvbnN0YW50X2NwdV90b19sZTE2KDEyOCk7CisJCW52LT5wb3J0X2Rvd25fcmV0cnlfY291bnQg
PSBfX2NvbnN0YW50X2NwdV90b19sZTE2KDMwKTsKKwkJbnYtPmxpbmtfZG93bl90aW1lb3V0ID0g
X19jb25zdGFudF9jcHVfdG9fbGUxNigzMCk7CiAJfQogCiAJLyogUmVzZXQgSW5pdGlhbGl6YXRp
b24gY29udHJvbCBibG9jayAqLwpkaWZmIC1OYXVyIGxpbnV4LTIuNi5naXQvZHJpdmVycy9zY3Np
L3FsYTJ4eHgvcWxhX29zLmMgbGludXgtMi42LmdpdC1udnJhbS9kcml2ZXJzL3Njc2kvcWxhMnh4
eC9xbGFfb3MuYwotLS0gbGludXgtMi42LmdpdC9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfb3Mu
YwkyMDA3LTA0LTE3IDExOjA2OjM5LjAwMDAwMDAwMCAtMDcwMAorKysgbGludXgtMi42LmdpdC1u
dnJhbS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfb3MuYwkyMDA3LTA0LTE3IDExOjA3OjI0LjAw
MDAwMDAwMCAtMDcwMApAQCAtOTAsNiArOTAsMTMgQEAKIAkJImRlcHRoIGZvciBhIGRldmljZSBh
ZnRlciBhIHF1ZXVlLWZ1bGwgY29uZGl0aW9uIGhhcyBiZWVuICIKIAkJImRldGVjdGVkLiAgRGVm
YXVsdCBpcyAxMjAgc2Vjb25kcy4iKTsKIAoraW50IHFsMnhvdmVycmlkZWludmFsaWRudnJhbTsK
K21vZHVsZV9wYXJhbShxbDJ4b3ZlcnJpZGVpbnZhbGlkbnZyYW0sIGludCwgU19JUlVHT3xTX0lS
VVNSKTsKK01PRFVMRV9QQVJNX0RFU0MocWwyeG92ZXJyaWRlaW52YWxpZG52cmFtLAorCQkiV2hl
biBzZXQgYW5kIHVwb24gZGV0ZWN0aW5nIGFuIGludmFsaWQgb3Igbm9uLXByZXNlbnQgIgorCQki
TlZSQU0gc3RhdGUsIHVzZSBkb2N0b3JlZCBzZXR0aW5ncyAocG90ZW50aWFsbHkgaW52YWxpZCkg
IgorCQkidG8gaW5pdGlhbGl6ZSB0aGUgSEJBLiIpOworCiAvKgogICogU0NTSSBob3N0IHRlbXBs
YXRlIGVudHJ5IHBvaW50cwogICovCkBAIC0xNTc1LDkgKzE1ODIsNyBAQAogCQlnb3RvIHByb2Jl
X2ZhaWxlZDsKIAl9CiAKLQlpZiAocWxhMngwMF9pbml0aWFsaXplX2FkYXB0ZXIoaGEpICYmCi0J
ICAgICEoaGEtPmRldmljZV9mbGFncyAmIERGTEdfTk9fQ0FCTEUpKSB7Ci0KKwlpZiAocWxhMngw
MF9pbml0aWFsaXplX2FkYXB0ZXIoaGEpKSB7CiAJCXFsYV9wcmludGsoS0VSTl9XQVJOSU5HLCBo
YSwKIAkJICAgICJGYWlsZWQgdG8gaW5pdGlhbGl6ZSBhZGFwdGVyXG4iKTsKIApAQCAtMTczMyw3
ICsxNzM4LDggQEAKIAloYS0+ZmxhZ3Mub25saW5lID0gMDsKIAogCS8qIFN0b3AgY3VycmVudGx5
IGV4ZWN1dGluZyBmaXJtd2FyZS4gKi8KLQlxbGEyeDAwX3RyeV90b19zdG9wX2Zpcm13YXJlKGhh
KTsKKwlpZiAoaGEtPmZ3X21ham9yX3ZlcnNpb24pCisJCXFsYTJ4MDBfdHJ5X3RvX3N0b3BfZmly
bXdhcmUoaGEpOwogCiAJLyogdHVybi1vZmYgaW50ZXJydXB0cyBvbiB0aGUgY2FyZCAqLwogCWlm
IChoYS0+aW50ZXJydXB0c19vbikK

------_=_NextPart_001_01C7811E.1653B84E--
