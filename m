From: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
Subject: [RFC] enclosure & ses: modernize and add target power management
Date: Fri, 11 Nov 2011 11:14:29 -0500
Message-ID: <1321028069.21400.24.camel@nebulus.xyus.xyratex.com>
References: <CAA9_cmcgqQx4WZaWoSM=mgBAHNNZ6Y1RgZ5OwjW11qrspOcR1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-MiVRmB5xWkZd0pnPsfIk"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex198.xyratex.com ([194.131.166.198]:60317 "EHLO
	XY01EX22.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932163Ab1KKQOe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2011 11:14:34 -0500
In-Reply-To: <CAA9_cmcgqQx4WZaWoSM=mgBAHNNZ6Y1RgZ5OwjW11qrspOcR1A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>


--=-MiVRmB5xWkZd0pnPsfIk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The enclosed code change suggestion is proposed to modernize the
enclosure drivers. The changes outlined are but only compile &
checkpatch tested so do not propagate. We will be testing this on a real
enclosure... Inspection is invited. We would however like the answer to
a question (with two parts) and a few others:

1) Is /sys/.../enclosure_device:#/device_power an acceptable node name
for switching the power on and off for the target?
2) Do you think that target power management be made part of the Linux
power management hierarchy (and clues/pointers to how would be
nice :-) )
3) Add other enclosure bits (eg: Lock & LED control) while we are here?
4) Should the enclosure_component retained values be changed to
bit-fields?
5) Does Evolution work better than Outlook for delivering patch content?

Coincident repair of enclosure and ses device support. Fix problems with
setting enclosure values careful to preserve other settings. Corrected
fault setting as well. Modernize code. Add support for Device Power
Management.

Future: Add target device power-cycle to error recovery escalation,
between target reset and host bus adapter reset (has to be added to each
lib<transport> handler, difficult to visualize in error-handler common
code :-( ) ?

Signed-off-by: mark_salyzyn@us.xyratex.com

include/linux/enclosure.h |    6 +++
drivers/misc/enclosure.c  |   45 +++++++++++++++++++-----
drivers/scsi/ses.c        |   83
+++++++++++++++++++++++++++++++++-------------
3 files changed, 103 insertions(+), 31 deletions(-)

diff -rup a/include/linux/enclosure.h b/include/linux/enclosure.h
--- a/include/linux/enclosure.h 2011-11-11 10:14:07.000000000 -0500
+++ b/include/linux/enclosure.h 2011-11-11 10:09:00.000000000 -0500
@@ -79,6 +79,11 @@ struct enclosure_component_callbacks {
int (*set_locate)(struct enclosure_device *,
  struct enclosure_component *,
  enum enclosure_component_setting);
+ void (*get_device_power)(struct enclosure_device *,
+    struct enclosure_component *);
+ int (*set_device_power)(struct enclosure_device *,
+   struct enclosure_component *,
+   enum enclosure_component_setting);
};


@@ -91,6 +96,7 @@ struct enclosure_component {
int fault;
int active;
int locate;
+ int device_power;
enum enclosure_status status;
};

diff -rup a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
--- a/drivers/misc/enclosure.c 2011-11-11 10:19:45.000000000 -0500
+++ b/drivers/misc/enclosure.c 2011-11-11 10:36:35.000000000 -0500
@@ -416,10 +416,10 @@ static ssize_t set_component_fault(struc
{
struct enclosure_device *edev =3D to_enclosure_device(cdev->parent);
struct enclosure_component *ecomp =3D to_enclosure_component(cdev);
- int val =3D simple_strtoul(buf, NULL, 0);
+ unsigned long val;

- if (edev->cb->set_fault)
- edev->cb->set_fault(edev, ecomp, val);
+ if (!strict_strtoul(buf, 0, &val) && edev->cb->set_fault)
+ edev->cb->set_fault(edev, ecomp, (int)val);
return count;
}

@@ -474,10 +474,10 @@ static ssize_t set_component_active(stru
{
struct enclosure_device *edev =3D to_enclosure_device(cdev->parent);
struct enclosure_component *ecomp =3D to_enclosure_component(cdev);
- int val =3D simple_strtoul(buf, NULL, 0);
+ unsigned long val;

- if (edev->cb->set_active)
- edev->cb->set_active(edev, ecomp, val);
+ if (!strict_strtoul(buf, 0, &val) && edev->cb->set_active)
+ edev->cb->set_active(edev, ecomp, (int)val);
return count;
}

@@ -498,10 +498,34 @@ static ssize_t set_component_locate(stru
{
struct enclosure_device *edev =3D to_enclosure_device(cdev->parent);
struct enclosure_component *ecomp =3D to_enclosure_component(cdev);
- int val =3D simple_strtoul(buf, NULL, 0);
+ unsigned long val;

- if (edev->cb->set_locate)
- edev->cb->set_locate(edev, ecomp, val);
+ if (!strict_strtoul(buf, 0, &val) && edev->cb->set_locate)
+ edev->cb->set_locate(edev, ecomp, (int)val);
+ return count;
+}
+
+static ssize_t get_component_device_power(struct device *cdev,
+     struct device_attribute *attr, char *buf)
+{
+ struct enclosure_device *edev =3D to_enclosure_device(cdev->parent);
+ struct enclosure_component *ecomp =3D to_enclosure_component(cdev);
+
+ if (edev->cb->get_device_power)
+ edev->cb->get_device_power(edev, ecomp);
+ return snprintf(buf, 40, "%d\n", ecomp->device_power);
+}
+
+static ssize_t set_component_device_power(struct device *cdev,
+     struct device_attribute *attr,
+     const char *buf, size_t count)
+{
+ struct enclosure_device *edev =3D to_enclosure_device(cdev->parent);
+ struct enclosure_component *ecomp =3D to_enclosure_component(cdev);
+ unsigned long val;
+
+ if (!strict_strtoul(buf, 0, &val) && edev->cb->set_device_power)
+ edev->cb->set_device_power(edev, ecomp, (int)val);
return count;
}

@@ -522,6 +546,8 @@ static DEVICE_ATTR(active, S_IRUGO | S_I
   set_component_active);
static DEVICE_ATTR(locate, S_IRUGO | S_IWUSR, get_component_locate,
   set_component_locate);
+static DEVICE_ATTR(device_power, S_IRUGO | S_IWUSR,
get_component_device_power,
+    set_component_device_power);
static DEVICE_ATTR(type, S_IRUGO, get_component_type, NULL);

static struct attribute *enclosure_component_attrs[] =3D {
@@ -529,6 +555,7 @@ static struct attribute *enclosure_compo
&dev_attr_status.attr,
&dev_attr_active.attr,
&dev_attr_locate.attr,
+ &dev_attr_device_power.attr,
&dev_attr_type.attr,
NULL
};
diff -rup a/drivers/scsi/ses.c b/drivers/scsi/ses.c
--- a/drivers/scsi/ses.c 2011-11-11 10:14:19.000000000 -0500
+++ b/drivers/scsi/ses.c 2011-11-11 10:35:14.000000000 -0500
@@ -167,18 +167,38 @@ static void ses_get_fault(struct enclosu
ecomp->fault =3D (desc[3] & 0x60) >> 4;
}

+static void ses_read_page2_descriptor(struct enclosure_device *edev,
+       struct enclosure_component *ecomp,
+       unsigned char *desc)
+{
+ unsigned char *desc_ptr =3D ses_get_page2_descriptor(edev, ecomp);
+
+ if (desc_ptr)
+ memcpy(desc, desc_ptr, 4);
+ /* preserve active state */
+ if (ecomp->active)
+ desc[2] |=3D 0x80;
+ else
+ desc[2] &=3D ~0x80;
+ /* Clear all reserved/alternate-purpose bits */
+ desc[2] &=3D 0xE7;
+ desc[3] &=3D 0x3C;
+}
+
static int ses_set_fault(struct enclosure_device *edev,
  struct enclosure_component *ecomp,
enum enclosure_component_setting val)
{
unsigned char desc[4] =3D {0 };

+ ses_read_page2_descriptor(edev, ecomp, desc);
switch (val) {
case ENCLOSURE_SETTING_DISABLED:
/* zero is disabled */
+ desc[3] &=3D ~0x20;
break;
case ENCLOSURE_SETTING_ENABLED:
- desc[2] =3D 0x02;
+ desc[3] |=3D 0x20;
break;
default:
/* SES doesn't do the SGPIO blink settings */
@@ -214,12 +234,46 @@ static int ses_set_locate(struct enclosu
{
unsigned char desc[4] =3D {0 };

+ ses_read_page2_descriptor(edev, ecomp, desc);
switch (val) {
case ENCLOSURE_SETTING_DISABLED:
/* zero is disabled */
+ desc[2] &=3D ~0x02;
+ break;
+ case ENCLOSURE_SETTING_ENABLED:
+ desc[2] |=3D 0x02;
+ break;
+ default:
+ /* SES doesn't do the SGPIO blink settings */
+ return -EINVAL;
+ }
+ return ses_set_page2_descriptor(edev, ecomp, desc);
+}
+
+static void ses_get_device_power(struct enclosure_device *edev,
+    struct enclosure_component *ecomp)
+{
+ unsigned char *desc;
+
+ desc =3D ses_get_page2_descriptor(edev, ecomp);
+ if (desc)
+ ecomp->device_power =3D (desc[3] & 0x10) ? 0 : 1;
+}
+
+static int ses_set_device_power(struct enclosure_device *edev,
+   struct enclosure_component *ecomp,
+   enum enclosure_component_setting val)
+{
+ unsigned char desc[4] =3D {0 };
+
+ ses_read_page2_descriptor(edev, ecomp, desc);
+ switch (val) {
+ case ENCLOSURE_SETTING_DISABLED:
+ /* one is disabled */
+ desc[3] |=3D 0x10;
break;
case ENCLOSURE_SETTING_ENABLED:
- desc[2] =3D 0x02;
+ desc[3] &=3D ~0x10;
break;
default:
/* SES doesn't do the SGPIO blink settings */
@@ -234,13 +288,15 @@ static int ses_set_active(struct enclosu
{
unsigned char desc[4] =3D {0 };

+ ses_read_page2_descriptor(edev, ecomp, desc);
switch (val) {
case ENCLOSURE_SETTING_DISABLED:
/* zero is disabled */
+ desc[2] &=3D ~0x80;
ecomp->active =3D 0;
break;
case ENCLOSURE_SETTING_ENABLED:
- desc[2] =3D 0x80;
+ desc[2] |=3D 0x80;
ecomp->active =3D 1;
break;
default:
@@ -256,6 +312,8 @@ static struct enclosure_component_callba
.get_status =3D ses_get_status,
.get_locate =3D ses_get_locate,
.set_locate =3D ses_set_locate,
+ .get_device_power =3D ses_get_device_power,
+ .set_device_power =3D ses_set_device_power,
.set_active =3D ses_set_active,
};

@@ -264,25 +322,6 @@ struct ses_host_edev {
struct enclosure_device *edev;
};

-#if 0
-int ses_match_host(struct enclosure_device *edev, void *data)
-{
- struct ses_host_edev *sed =3D data;
- struct scsi_device *sdev;
-
- if (!scsi_is_sdev_device(edev->edev.parent))
- return 0;
-
- sdev =3D to_scsi_device(edev->edev.parent);
-
- if (sdev->host !=3D sed->shost)
- return 0;
-
- sed->edev =3D edev;
- return 1;
-}
-#endif  /*  0  */
-
static void ses_process_descriptor(struct enclosure_component *ecomp,
   unsigned char *desc)
{


--=-MiVRmB5xWkZd0pnPsfIk
Content-Disposition: attachment; filename="enclosure_add_power.patch"
Content-Type: text/x-patch; name="enclosure_add_power.patch"; charset="UTF-8"
Content-Transfer-Encoding: base64

Q29pbmNpZGVudCByZXBhaXIgb2YgZW5jbG9zdXJlIGFuZCBzZXMgZGV2aWNlIHN1cHBvcnQuIEZp
eCBwcm9ibGVtcyB3aXRoDQpzZXR0aW5nIGVuY2xvc3VyZSB2YWx1ZXMgY2FyZWZ1bCB0byBwcmVz
ZXJ2ZSBvdGhlciBzZXR0aW5ncy4gQ29ycmVjdGVkDQpmYXVsdCBzZXR0aW5nIHRvLiBNb2Rlcm5p
emUgY29kZS4gQWRkIHN1cHBvcnQgZm9yIERldmljZSBQb3dlciBFbmFibGUuDQoNClNpZ25lZC1v
ZmYtYnk6IG1hcmtfc2FseXp5bkB1cy54eXJhdGV4LmNvbQ0KDQogaW5jbHVkZS9saW51eC9lbmNs
b3N1cmUuaCB8ICAgIDYgKysrDQogZHJpdmVycy9taXNjL2VuY2xvc3VyZS5jICB8ICAgNDUgKysr
KysrKysrKysrKysrKysrKy0tLS0tDQogZHJpdmVycy9zY3NpL3Nlcy5jICAgICAgICB8ICAgODMg
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLQ0KIDMgZmlsZXMg
Y2hhbmdlZCwgMTAzIGluc2VydGlvbnMoKyksIDMxIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC1ydXAg
YS9pbmNsdWRlL2xpbnV4L2VuY2xvc3VyZS5oIGIvaW5jbHVkZS9saW51eC9lbmNsb3N1cmUuaA0K
LS0tIGEvaW5jbHVkZS9saW51eC9lbmNsb3N1cmUuaAkyMDExLTExLTExIDEwOjE0OjA3LjAwMDAw
MDAwMCAtMDUwMA0KKysrIGIvaW5jbHVkZS9saW51eC9lbmNsb3N1cmUuaAkyMDExLTExLTExIDEw
OjA5OjAwLjAwMDAwMDAwMCAtMDUwMA0KQEAgLTc5LDYgKzc5LDExIEBAIHN0cnVjdCBlbmNsb3N1
cmVfY29tcG9uZW50X2NhbGxiYWNrcyB7DQogCWludCAoKnNldF9sb2NhdGUpKHN0cnVjdCBlbmNs
b3N1cmVfZGV2aWNlICosDQogCQkJICBzdHJ1Y3QgZW5jbG9zdXJlX2NvbXBvbmVudCAqLA0KIAkJ
CSAgZW51bSBlbmNsb3N1cmVfY29tcG9uZW50X3NldHRpbmcpOw0KKwl2b2lkICgqZ2V0X2Rldmlj
ZV9wb3dlcikoc3RydWN0IGVuY2xvc3VyZV9kZXZpY2UgKiwNCisJCQkgICBzdHJ1Y3QgZW5jbG9z
dXJlX2NvbXBvbmVudCAqKTsNCisJaW50ICgqc2V0X2RldmljZV9wb3dlcikoc3RydWN0IGVuY2xv
c3VyZV9kZXZpY2UgKiwNCisJCQkgIHN0cnVjdCBlbmNsb3N1cmVfY29tcG9uZW50ICosDQorCQkJ
ICBlbnVtIGVuY2xvc3VyZV9jb21wb25lbnRfc2V0dGluZyk7DQogfTsNCiANCiANCkBAIC05MSw2
ICs5Niw3IEBAIHN0cnVjdCBlbmNsb3N1cmVfY29tcG9uZW50IHsNCiAJaW50IGZhdWx0Ow0KIAlp
bnQgYWN0aXZlOw0KIAlpbnQgbG9jYXRlOw0KKwlpbnQgZGV2aWNlX3Bvd2VyOw0KIAllbnVtIGVu
Y2xvc3VyZV9zdGF0dXMgc3RhdHVzOw0KIH07DQogDQpkaWZmIC1ydXAgYS9kcml2ZXJzL21pc2Mv
ZW5jbG9zdXJlLmMgYi9kcml2ZXJzL21pc2MvZW5jbG9zdXJlLmMNCi0tLSBhL2RyaXZlcnMvbWlz
Yy9lbmNsb3N1cmUuYwkyMDExLTExLTExIDEwOjE5OjQ1LjAwMDAwMDAwMCAtMDUwMA0KKysrIGIv
ZHJpdmVycy9taXNjL2VuY2xvc3VyZS5jCTIwMTEtMTEtMTEgMTA6MzY6MzUuMDAwMDAwMDAwIC0w
NTAwDQpAQCAtNDE2LDEwICs0MTYsMTAgQEAgc3RhdGljIHNzaXplX3Qgc2V0X2NvbXBvbmVudF9m
YXVsdChzdHJ1Yw0KIHsNCiAJc3RydWN0IGVuY2xvc3VyZV9kZXZpY2UgKmVkZXYgPSB0b19lbmNs
b3N1cmVfZGV2aWNlKGNkZXYtPnBhcmVudCk7DQogCXN0cnVjdCBlbmNsb3N1cmVfY29tcG9uZW50
ICplY29tcCA9IHRvX2VuY2xvc3VyZV9jb21wb25lbnQoY2Rldik7DQotCWludCB2YWwgPSBzaW1w
bGVfc3RydG91bChidWYsIE5VTEwsIDApOw0KKwl1bnNpZ25lZCBsb25nIHZhbDsNCiANCi0JaWYg
KGVkZXYtPmNiLT5zZXRfZmF1bHQpDQotCQllZGV2LT5jYi0+c2V0X2ZhdWx0KGVkZXYsIGVjb21w
LCB2YWwpOw0KKwlpZiAoIXN0cmljdF9zdHJ0b3VsKGJ1ZiwgMCwgJnZhbCkgJiYgZWRldi0+Y2It
PnNldF9mYXVsdCkNCisJCWVkZXYtPmNiLT5zZXRfZmF1bHQoZWRldiwgZWNvbXAsIChpbnQpdmFs
KTsNCiAJcmV0dXJuIGNvdW50Ow0KIH0NCiANCkBAIC00NzQsMTAgKzQ3NCwxMCBAQCBzdGF0aWMg
c3NpemVfdCBzZXRfY29tcG9uZW50X2FjdGl2ZShzdHJ1DQogew0KIAlzdHJ1Y3QgZW5jbG9zdXJl
X2RldmljZSAqZWRldiA9IHRvX2VuY2xvc3VyZV9kZXZpY2UoY2Rldi0+cGFyZW50KTsNCiAJc3Ry
dWN0IGVuY2xvc3VyZV9jb21wb25lbnQgKmVjb21wID0gdG9fZW5jbG9zdXJlX2NvbXBvbmVudChj
ZGV2KTsNCi0JaW50IHZhbCA9IHNpbXBsZV9zdHJ0b3VsKGJ1ZiwgTlVMTCwgMCk7DQorCXVuc2ln
bmVkIGxvbmcgdmFsOw0KIA0KLQlpZiAoZWRldi0+Y2ItPnNldF9hY3RpdmUpDQotCQllZGV2LT5j
Yi0+c2V0X2FjdGl2ZShlZGV2LCBlY29tcCwgdmFsKTsNCisJaWYgKCFzdHJpY3Rfc3RydG91bChi
dWYsIDAsICZ2YWwpICYmIGVkZXYtPmNiLT5zZXRfYWN0aXZlKQ0KKwkJZWRldi0+Y2ItPnNldF9h
Y3RpdmUoZWRldiwgZWNvbXAsIChpbnQpdmFsKTsNCiAJcmV0dXJuIGNvdW50Ow0KIH0NCiANCkBA
IC00OTgsMTAgKzQ5OCwzNCBAQCBzdGF0aWMgc3NpemVfdCBzZXRfY29tcG9uZW50X2xvY2F0ZShz
dHJ1DQogew0KIAlzdHJ1Y3QgZW5jbG9zdXJlX2RldmljZSAqZWRldiA9IHRvX2VuY2xvc3VyZV9k
ZXZpY2UoY2Rldi0+cGFyZW50KTsNCiAJc3RydWN0IGVuY2xvc3VyZV9jb21wb25lbnQgKmVjb21w
ID0gdG9fZW5jbG9zdXJlX2NvbXBvbmVudChjZGV2KTsNCi0JaW50IHZhbCA9IHNpbXBsZV9zdHJ0
b3VsKGJ1ZiwgTlVMTCwgMCk7DQorCXVuc2lnbmVkIGxvbmcgdmFsOw0KIA0KLQlpZiAoZWRldi0+
Y2ItPnNldF9sb2NhdGUpDQotCQllZGV2LT5jYi0+c2V0X2xvY2F0ZShlZGV2LCBlY29tcCwgdmFs
KTsNCisJaWYgKCFzdHJpY3Rfc3RydG91bChidWYsIDAsICZ2YWwpICYmIGVkZXYtPmNiLT5zZXRf
bG9jYXRlKQ0KKwkJZWRldi0+Y2ItPnNldF9sb2NhdGUoZWRldiwgZWNvbXAsIChpbnQpdmFsKTsN
CisJcmV0dXJuIGNvdW50Ow0KK30NCisNCitzdGF0aWMgc3NpemVfdCBnZXRfY29tcG9uZW50X2Rl
dmljZV9wb3dlcihzdHJ1Y3QgZGV2aWNlICpjZGV2LA0KKwkJCQkgICAgc3RydWN0IGRldmljZV9h
dHRyaWJ1dGUgKmF0dHIsIGNoYXIgKmJ1ZikNCit7DQorCXN0cnVjdCBlbmNsb3N1cmVfZGV2aWNl
ICplZGV2ID0gdG9fZW5jbG9zdXJlX2RldmljZShjZGV2LT5wYXJlbnQpOw0KKwlzdHJ1Y3QgZW5j
bG9zdXJlX2NvbXBvbmVudCAqZWNvbXAgPSB0b19lbmNsb3N1cmVfY29tcG9uZW50KGNkZXYpOw0K
Kw0KKwlpZiAoZWRldi0+Y2ItPmdldF9kZXZpY2VfcG93ZXIpDQorCQllZGV2LT5jYi0+Z2V0X2Rl
dmljZV9wb3dlcihlZGV2LCBlY29tcCk7DQorCXJldHVybiBzbnByaW50ZihidWYsIDQwLCAiJWRc
biIsIGVjb21wLT5kZXZpY2VfcG93ZXIpOw0KK30NCisNCitzdGF0aWMgc3NpemVfdCBzZXRfY29t
cG9uZW50X2RldmljZV9wb3dlcihzdHJ1Y3QgZGV2aWNlICpjZGV2LA0KKwkJCQkgICAgc3RydWN0
IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIsDQorCQkJCSAgICBjb25zdCBjaGFyICpidWYsIHNpemVf
dCBjb3VudCkNCit7DQorCXN0cnVjdCBlbmNsb3N1cmVfZGV2aWNlICplZGV2ID0gdG9fZW5jbG9z
dXJlX2RldmljZShjZGV2LT5wYXJlbnQpOw0KKwlzdHJ1Y3QgZW5jbG9zdXJlX2NvbXBvbmVudCAq
ZWNvbXAgPSB0b19lbmNsb3N1cmVfY29tcG9uZW50KGNkZXYpOw0KKwl1bnNpZ25lZCBsb25nIHZh
bDsNCisNCisJaWYgKCFzdHJpY3Rfc3RydG91bChidWYsIDAsICZ2YWwpICYmIGVkZXYtPmNiLT5z
ZXRfZGV2aWNlX3Bvd2VyKQ0KKwkJZWRldi0+Y2ItPnNldF9kZXZpY2VfcG93ZXIoZWRldiwgZWNv
bXAsIChpbnQpdmFsKTsNCiAJcmV0dXJuIGNvdW50Ow0KIH0NCiANCkBAIC01MjIsNiArNTQ2LDgg
QEAgc3RhdGljIERFVklDRV9BVFRSKGFjdGl2ZSwgU19JUlVHTyB8IFNfSQ0KIAkJICAgc2V0X2Nv
bXBvbmVudF9hY3RpdmUpOw0KIHN0YXRpYyBERVZJQ0VfQVRUUihsb2NhdGUsIFNfSVJVR08gfCBT
X0lXVVNSLCBnZXRfY29tcG9uZW50X2xvY2F0ZSwNCiAJCSAgIHNldF9jb21wb25lbnRfbG9jYXRl
KTsNCitzdGF0aWMgREVWSUNFX0FUVFIoZGV2aWNlX3Bvd2VyLCBTX0lSVUdPIHwgU19JV1VTUiwg
Z2V0X2NvbXBvbmVudF9kZXZpY2VfcG93ZXIsDQorCQkgICBzZXRfY29tcG9uZW50X2RldmljZV9w
b3dlcik7DQogc3RhdGljIERFVklDRV9BVFRSKHR5cGUsIFNfSVJVR08sIGdldF9jb21wb25lbnRf
dHlwZSwgTlVMTCk7DQogDQogc3RhdGljIHN0cnVjdCBhdHRyaWJ1dGUgKmVuY2xvc3VyZV9jb21w
b25lbnRfYXR0cnNbXSA9IHsNCkBAIC01MjksNiArNTU1LDcgQEAgc3RhdGljIHN0cnVjdCBhdHRy
aWJ1dGUgKmVuY2xvc3VyZV9jb21wbw0KIAkmZGV2X2F0dHJfc3RhdHVzLmF0dHIsDQogCSZkZXZf
YXR0cl9hY3RpdmUuYXR0ciwNCiAJJmRldl9hdHRyX2xvY2F0ZS5hdHRyLA0KKwkmZGV2X2F0dHJf
ZGV2aWNlX3Bvd2VyLmF0dHIsDQogCSZkZXZfYXR0cl90eXBlLmF0dHIsDQogCU5VTEwNCiB9Ow0K
ZGlmZiAtcnVwIGEvZHJpdmVycy9zY3NpL3Nlcy5jIGIvZHJpdmVycy9zY3NpL3Nlcy5jDQotLS0g
YS9kcml2ZXJzL3Njc2kvc2VzLmMJMjAxMS0xMS0xMSAxMDoxNDoxOS4wMDAwMDAwMDAgLTA1MDAN
CisrKyBiL2RyaXZlcnMvc2NzaS9zZXMuYwkyMDExLTExLTExIDEwOjM1OjE0LjAwMDAwMDAwMCAt
MDUwMA0KQEAgLTE2NywxOCArMTY3LDM4IEBAIHN0YXRpYyB2b2lkIHNlc19nZXRfZmF1bHQoc3Ry
dWN0IGVuY2xvc3UNCiAJCWVjb21wLT5mYXVsdCA9IChkZXNjWzNdICYgMHg2MCkgPj4gNDsNCiB9
DQogDQorc3RhdGljIHZvaWQgc2VzX3JlYWRfcGFnZTJfZGVzY3JpcHRvcihzdHJ1Y3QgZW5jbG9z
dXJlX2RldmljZSAqZWRldiwNCisJCQkJICAgICAgc3RydWN0IGVuY2xvc3VyZV9jb21wb25lbnQg
KmVjb21wLA0KKwkJCQkgICAgICB1bnNpZ25lZCBjaGFyICpkZXNjKQ0KK3sNCisJdW5zaWduZWQg
Y2hhciAqZGVzY19wdHIgPSBzZXNfZ2V0X3BhZ2UyX2Rlc2NyaXB0b3IoZWRldiwgZWNvbXApOw0K
Kw0KKwlpZiAoZGVzY19wdHIpDQorCQltZW1jcHkoZGVzYywgZGVzY19wdHIsIDQpOw0KKwkvKiBw
cmVzZXJ2ZSBhY3RpdmUgc3RhdGUgKi8NCisJaWYgKGVjb21wLT5hY3RpdmUpDQorCQlkZXNjWzJd
IHw9IDB4ODA7DQorCWVsc2UNCisJCWRlc2NbMl0gJj0gfjB4ODA7DQorCS8qIENsZWFyIGFsbCBy
ZXNlcnZlZC9hbHRlcm5hdGUtcHVycG9zZSBiaXRzICovDQorCWRlc2NbMl0gJj0gMHhFNzsNCisJ
ZGVzY1szXSAmPSAweDNDOw0KK30NCisNCiBzdGF0aWMgaW50IHNlc19zZXRfZmF1bHQoc3RydWN0
IGVuY2xvc3VyZV9kZXZpY2UgKmVkZXYsDQogCQkJICBzdHJ1Y3QgZW5jbG9zdXJlX2NvbXBvbmVu
dCAqZWNvbXAsDQogCQkJIGVudW0gZW5jbG9zdXJlX2NvbXBvbmVudF9zZXR0aW5nIHZhbCkNCiB7
DQogCXVuc2lnbmVkIGNoYXIgZGVzY1s0XSA9IHswIH07DQogDQorCXNlc19yZWFkX3BhZ2UyX2Rl
c2NyaXB0b3IoZWRldiwgZWNvbXAsIGRlc2MpOw0KIAlzd2l0Y2ggKHZhbCkgew0KIAljYXNlIEVO
Q0xPU1VSRV9TRVRUSU5HX0RJU0FCTEVEOg0KIAkJLyogemVybyBpcyBkaXNhYmxlZCAqLw0KKwkJ
ZGVzY1szXSAmPSB+MHgyMDsNCiAJCWJyZWFrOw0KIAljYXNlIEVOQ0xPU1VSRV9TRVRUSU5HX0VO
QUJMRUQ6DQotCQlkZXNjWzJdID0gMHgwMjsNCisJCWRlc2NbM10gfD0gMHgyMDsNCiAJCWJyZWFr
Ow0KIAlkZWZhdWx0Og0KIAkJLyogU0VTIGRvZXNuJ3QgZG8gdGhlIFNHUElPIGJsaW5rIHNldHRp
bmdzICovDQpAQCAtMjE0LDEyICsyMzQsNDYgQEAgc3RhdGljIGludCBzZXNfc2V0X2xvY2F0ZShz
dHJ1Y3QgZW5jbG9zdQ0KIHsNCiAJdW5zaWduZWQgY2hhciBkZXNjWzRdID0gezAgfTsNCiANCisJ
c2VzX3JlYWRfcGFnZTJfZGVzY3JpcHRvcihlZGV2LCBlY29tcCwgZGVzYyk7DQogCXN3aXRjaCAo
dmFsKSB7DQogCWNhc2UgRU5DTE9TVVJFX1NFVFRJTkdfRElTQUJMRUQ6DQogCQkvKiB6ZXJvIGlz
IGRpc2FibGVkICovDQorCQlkZXNjWzJdICY9IH4weDAyOw0KKwkJYnJlYWs7DQorCWNhc2UgRU5D
TE9TVVJFX1NFVFRJTkdfRU5BQkxFRDoNCisJCWRlc2NbMl0gfD0gMHgwMjsNCisJCWJyZWFrOw0K
KwlkZWZhdWx0Og0KKwkJLyogU0VTIGRvZXNuJ3QgZG8gdGhlIFNHUElPIGJsaW5rIHNldHRpbmdz
ICovDQorCQlyZXR1cm4gLUVJTlZBTDsNCisJfQ0KKwlyZXR1cm4gc2VzX3NldF9wYWdlMl9kZXNj
cmlwdG9yKGVkZXYsIGVjb21wLCBkZXNjKTsNCit9DQorDQorc3RhdGljIHZvaWQgc2VzX2dldF9k
ZXZpY2VfcG93ZXIoc3RydWN0IGVuY2xvc3VyZV9kZXZpY2UgKmVkZXYsDQorCQkJICAgc3RydWN0
IGVuY2xvc3VyZV9jb21wb25lbnQgKmVjb21wKQ0KK3sNCisJdW5zaWduZWQgY2hhciAqZGVzYzsN
CisNCisJZGVzYyA9IHNlc19nZXRfcGFnZTJfZGVzY3JpcHRvcihlZGV2LCBlY29tcCk7DQorCWlm
IChkZXNjKQ0KKwkJZWNvbXAtPmRldmljZV9wb3dlciA9IChkZXNjWzNdICYgMHgxMCkgPyAwIDog
MTsNCit9DQorDQorc3RhdGljIGludCBzZXNfc2V0X2RldmljZV9wb3dlcihzdHJ1Y3QgZW5jbG9z
dXJlX2RldmljZSAqZWRldiwNCisJCQkgIHN0cnVjdCBlbmNsb3N1cmVfY29tcG9uZW50ICplY29t
cCwNCisJCQkgIGVudW0gZW5jbG9zdXJlX2NvbXBvbmVudF9zZXR0aW5nIHZhbCkNCit7DQorCXVu
c2lnbmVkIGNoYXIgZGVzY1s0XSA9IHswIH07DQorDQorCXNlc19yZWFkX3BhZ2UyX2Rlc2NyaXB0
b3IoZWRldiwgZWNvbXAsIGRlc2MpOw0KKwlzd2l0Y2ggKHZhbCkgew0KKwljYXNlIEVOQ0xPU1VS
RV9TRVRUSU5HX0RJU0FCTEVEOg0KKwkJLyogb25lIGlzIGRpc2FibGVkICovDQorCQlkZXNjWzNd
IHw9IDB4MTA7DQogCQlicmVhazsNCiAJY2FzZSBFTkNMT1NVUkVfU0VUVElOR19FTkFCTEVEOg0K
LQkJZGVzY1syXSA9IDB4MDI7DQorCQlkZXNjWzNdICY9IH4weDEwOw0KIAkJYnJlYWs7DQogCWRl
ZmF1bHQ6DQogCQkvKiBTRVMgZG9lc24ndCBkbyB0aGUgU0dQSU8gYmxpbmsgc2V0dGluZ3MgKi8N
CkBAIC0yMzQsMTMgKzI4OCwxNSBAQCBzdGF0aWMgaW50IHNlc19zZXRfYWN0aXZlKHN0cnVjdCBl
bmNsb3N1DQogew0KIAl1bnNpZ25lZCBjaGFyIGRlc2NbNF0gPSB7MCB9Ow0KIA0KKwlzZXNfcmVh
ZF9wYWdlMl9kZXNjcmlwdG9yKGVkZXYsIGVjb21wLCBkZXNjKTsNCiAJc3dpdGNoICh2YWwpIHsN
CiAJY2FzZSBFTkNMT1NVUkVfU0VUVElOR19ESVNBQkxFRDoNCiAJCS8qIHplcm8gaXMgZGlzYWJs
ZWQgKi8NCisJCWRlc2NbMl0gJj0gfjB4ODA7DQogCQllY29tcC0+YWN0aXZlID0gMDsNCiAJCWJy
ZWFrOw0KIAljYXNlIEVOQ0xPU1VSRV9TRVRUSU5HX0VOQUJMRUQ6DQotCQlkZXNjWzJdID0gMHg4
MDsNCisJCWRlc2NbMl0gfD0gMHg4MDsNCiAJCWVjb21wLT5hY3RpdmUgPSAxOw0KIAkJYnJlYWs7
DQogCWRlZmF1bHQ6DQpAQCAtMjU2LDYgKzMxMiw4IEBAIHN0YXRpYyBzdHJ1Y3QgZW5jbG9zdXJl
X2NvbXBvbmVudF9jYWxsYmENCiAJLmdldF9zdGF0dXMJCT0gc2VzX2dldF9zdGF0dXMsDQogCS5n
ZXRfbG9jYXRlCQk9IHNlc19nZXRfbG9jYXRlLA0KIAkuc2V0X2xvY2F0ZQkJPSBzZXNfc2V0X2xv
Y2F0ZSwNCisJLmdldF9kZXZpY2VfcG93ZXIJPSBzZXNfZ2V0X2RldmljZV9wb3dlciwNCisJLnNl
dF9kZXZpY2VfcG93ZXIJPSBzZXNfc2V0X2RldmljZV9wb3dlciwNCiAJLnNldF9hY3RpdmUJCT0g
c2VzX3NldF9hY3RpdmUsDQogfTsNCiANCkBAIC0yNjQsMjUgKzMyMiw2IEBAIHN0cnVjdCBzZXNf
aG9zdF9lZGV2IHsNCiAJc3RydWN0IGVuY2xvc3VyZV9kZXZpY2UgKmVkZXY7DQogfTsNCiANCi0j
aWYgMA0KLWludCBzZXNfbWF0Y2hfaG9zdChzdHJ1Y3QgZW5jbG9zdXJlX2RldmljZSAqZWRldiwg
dm9pZCAqZGF0YSkNCi17DQotCXN0cnVjdCBzZXNfaG9zdF9lZGV2ICpzZWQgPSBkYXRhOw0KLQlz
dHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXY7DQotDQotCWlmICghc2NzaV9pc19zZGV2X2RldmljZShl
ZGV2LT5lZGV2LnBhcmVudCkpDQotCQlyZXR1cm4gMDsNCi0NCi0Jc2RldiA9IHRvX3Njc2lfZGV2
aWNlKGVkZXYtPmVkZXYucGFyZW50KTsNCi0NCi0JaWYgKHNkZXYtPmhvc3QgIT0gc2VkLT5zaG9z
dCkNCi0JCXJldHVybiAwOw0KLQ0KLQlzZWQtPmVkZXYgPSBlZGV2Ow0KLQlyZXR1cm4gMTsNCi19
DQotI2VuZGlmICAvKiAgMCAgKi8NCi0NCiBzdGF0aWMgdm9pZCBzZXNfcHJvY2Vzc19kZXNjcmlw
dG9yKHN0cnVjdCBlbmNsb3N1cmVfY29tcG9uZW50ICplY29tcCwNCiAJCQkJICAgdW5zaWduZWQg
Y2hhciAqZGVzYykNCiB7DQo=


--=-MiVRmB5xWkZd0pnPsfIk--
