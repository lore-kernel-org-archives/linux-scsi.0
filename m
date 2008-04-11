From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Fri, 11 Apr 2008 16:25:32 -0700
Message-ID: <e9c3a7c20804111625w68b21b24p6fbd85864713d62f@mail.gmail.com>
References: <47E875AD.1000901@rtr.ca> <47E88A13.70808@zytor.com>
	 <47E90019.3050006@rtr.ca> <47E90458.7030801@zytor.com>
	 <47E9383F.3050908@rtr.ca> <20080325192515.GA24234@suse.de>
	 <47E99A02.7040903@rtr.ca> <47E99EBE.7010708@gmail.com>
	 <3ae72650803271229h6e188de1t81ccfb64e5d3a214@mail.gmail.com>
	 <47EBF7D0.6000901@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_14037_24360112.1207956332290"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47EBF7D0.6000901@zytor.com>
Sender: linux-ide-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <htejun@gmail.com>, Mark Lord <lkml@rtr.ca>, Greg KH <gregkh@suse.de>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

------=_Part_14037_24360112.1207956332290
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Mar 27, 2008 at 12:38 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Kay Sievers wrote:
>
> >
> > >
> > >  Probably something like /sys/class/block/MAJ:MIN
> > >
> >
> > "Devices directories" are not supposed to contain duplicate entries.
> > It would slow-down, or may even break things.
> >
> >
> > > or /sys/class/devnums/bMAJ:MIN?
> > >
> >
> > These are no devices belonging to the class "devnums", so it may
> > confuse things which crawl these directories to get "all devices".
> > Current coldplug-like setups will likely add duplicate devices with
> > the wrong subsystem. There are also bus-devices with have a dev_t, and
> > that will make them show up in /sys/class, which might confuse some
> > tools too.
> >
> > I guess we will need to find some other solution as a /sys/class/ for
> > that. And we must prefix the links with 'c' and 'b' because dev_t is
> > not unique across char and block devices.
> >
> >
>
>  It doesn't really seem to be to belong under class at all.  I would suggest
> /sys/dev/char/ and /sys/dev/block/, for char and block respectively.
>

This thread fizzled out without a patch... here goes:

[ note: I'm replying via gmail, so if it has whitespace mangled the
patch please see the attachment ]

-----snip---->
sysfs: add /sys/dev/{char,block} to lookup sysfs path by major:minor

From: Dan Williams <dan.j.williams@intel.com>

Why?:
There are occasions where userspace would like to access sysfs
attributes for a device but it may not know how sysfs has named the
device or the path.  For example what is the sysfs path for
/dev/disk/by-id/ata-ST3160827AS_5MT004CK?  With this change a call to
stat(2) returns the major:minor then userspace can see that
/sys/dev/block/8:32 links to /sys/block/sdc.

What are the alternatives?:
1/ Add an ioctl to return the path: Doable, but sysfs is meant to reduce
   the need to proliferate ioctl interfaces into the kernel, so this
   seems counter productive.

2/ Use udev to create these symlinks: Also doable, but it adds a
   udev dependency to utilities that might be running in a limited
   environment like an initramfs.

Cc: NeilBrown <neilb@suse.de>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>
Cc: Mark Lord <lkml@rtr.ca>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/base/core.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 1 deletions(-)


diff --git a/drivers/base/core.c b/drivers/base/core.c
index 24198ad..de925f8 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -27,6 +27,9 @@

 int (*platform_notify)(struct device *dev) = NULL;
 int (*platform_notify_remove)(struct device *dev) = NULL;
+static struct kobject *dev_kobj;
+static struct kobject *char_kobj;
+static struct kobject *block_kobj;

 #ifdef CONFIG_BLOCK
 static inline int device_is_not_partition(struct device *dev)
@@ -759,6 +762,11 @@ static void device_remove_class_symlinks(struct
device *dev)
 	sysfs_remove_link(&dev->kobj, "subsystem");
 }

+static struct kobject *device_to_dev_kobj(struct device *dev)
+{
+	return dev->class == &block_class ? block_kobj : char_kobj;
+}
+
 /**
  * device_add - add device to device hierarchy.
  * @dev: device.
@@ -775,6 +783,7 @@ int device_add(struct device *dev)
 	struct device *parent = NULL;
 	struct class_interface *class_intf;
 	int error;
+	char devt_str[25];

 	dev = get_device(dev);
 	if (!dev || !strlen(dev->bus_id)) {
@@ -806,9 +815,16 @@ int device_add(struct device *dev)
 		goto attrError;

 	if (MAJOR(dev->devt)) {
+		struct kobject *kobj = device_to_dev_kobj(dev);
+
 		error = device_create_file(dev, &devt_attr);
 		if (error)
 			goto ueventattrError;
+
+		format_dev_t(devt_str, dev->devt);
+		error = sysfs_create_link(kobj, &dev->kobj, devt_str);
+		if (error)
+			goto devtattrError;
 	}

 	error = device_add_class_symlinks(dev);
@@ -854,6 +870,9 @@ int device_add(struct device *dev)
 	device_remove_class_symlinks(dev);
  SymlinkError:
 	if (MAJOR(dev->devt))
+		sysfs_remove_link(device_to_dev_kobj(dev), devt_str);
+ devtattrError:
+	if (MAJOR(dev->devt))
 		device_remove_file(dev, &devt_attr);
  ueventattrError:
 	device_remove_file(dev, &uevent_attr);
@@ -925,12 +944,16 @@ void device_del(struct device *dev)
 {
 	struct device *parent = dev->parent;
 	struct class_interface *class_intf;
+	char devt_str[25];

 	device_pm_remove(dev);
 	if (parent)
 		klist_del(&dev->knode_parent);
-	if (MAJOR(dev->devt))
+	if (MAJOR(dev->devt)) {
+		format_dev_t(devt_str, dev->devt);
+		sysfs_remove_link(device_to_dev_kobj(dev), devt_str);
 		device_remove_file(dev, &devt_attr);
+	}
 	if (dev->class) {
 		device_remove_class_symlinks(dev);

@@ -1055,6 +1078,15 @@ int __init devices_init(void)
 	devices_kset = kset_create_and_add("devices", &device_uevent_ops, NULL);
 	if (!devices_kset)
 		return -ENOMEM;
+	dev_kobj = kobject_create_and_add("dev", NULL);
+	if (!dev_kobj)
+		return -ENOMEM;
+	block_kobj = kobject_create_and_add("block", dev_kobj);
+	if (!block_kobj)
+		return -ENOMEM;
+	char_kobj = kobject_create_and_add("char", dev_kobj);
+	if (!char_kobj)
+		return -ENOMEM;
 	return 0;
 }

@@ -1380,4 +1412,7 @@ void device_shutdown(void)
 			dev->driver->shutdown(dev);
 		}
 	}
+	kobject_put(char_kobj);
+	kobject_put(block_kobj);
+	kobject_put(dev_kobj);
 }

------=_Part_14037_24360112.1207956332290
Content-Type: text/x-patch; name=sysfs-sys-dev-char-block.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fexdukil0
Content-Disposition: attachment; filename=sysfs-sys-dev-char-block.patch

c3lzZnM6IGFkZCAvc3lzL2Rldi97Y2hhcixibG9ja30gdG8gbG9va3VwIHN5c2ZzIHBhdGggYnkg
bWFqb3I6bWlub3IKCkZyb206IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29t
PgoKV2h5PzoKVGhlcmUgYXJlIG9jY2FzaW9ucyB3aGVyZSB1c2Vyc3BhY2Ugd291bGQgbGlrZSB0
byBhY2Nlc3Mgc3lzZnMKYXR0cmlidXRlcyBmb3IgYSBkZXZpY2UgYnV0IGl0IG1heSBub3Qga25v
dyBob3cgc3lzZnMgaGFzIG5hbWVkIHRoZQpkZXZpY2Ugb3IgdGhlIHBhdGguICBGb3IgZXhhbXBs
ZSB3aGF0IGlzIHRoZSBzeXNmcyBwYXRoIGZvcgovZGV2L2Rpc2svYnktaWQvYXRhLVNUMzE2MDgy
N0FTXzVNVDAwNENLPyAgV2l0aCB0aGlzIGNoYW5nZSBhIGNhbGwgdG8Kc3RhdCgyKSByZXR1cm5z
IHRoZSBtYWpvcjptaW5vciB0aGVuIHVzZXJzcGFjZSBjYW4gc2VlIHRoYXQKL3N5cy9kZXYvYmxv
Y2svODozMiBsaW5rcyB0byAvc3lzL2Jsb2NrL3NkYy4KCldoYXQgYXJlIHRoZSBhbHRlcm5hdGl2
ZXM/OgoxLyBBZGQgYW4gaW9jdGwgdG8gcmV0dXJuIHRoZSBwYXRoOiBEb2FibGUsIGJ1dCBzeXNm
cyBpcyBtZWFudCB0byByZWR1Y2UKICAgdGhlIG5lZWQgdG8gcHJvbGlmZXJhdGUgaW9jdGwgaW50
ZXJmYWNlcyBpbnRvIHRoZSBrZXJuZWwsIHNvIHRoaXMKICAgc2VlbXMgY291bnRlciBwcm9kdWN0
aXZlLgoKMi8gVXNlIHVkZXYgdG8gY3JlYXRlIHRoZXNlIHN5bWxpbmtzOiBBbHNvIGRvYWJsZSwg
YnV0IGl0IGFkZHMgYQogICB1ZGV2IGRlcGVuZGVuY3kgdG8gdXRpbGl0aWVzIHRoYXQgbWlnaHQg
YmUgcnVubmluZyBpbiBhIGxpbWl0ZWQKICAgZW52aXJvbm1lbnQgbGlrZSBhbiBpbml0cmFtZnMu
CgpDYzogTmVpbEJyb3duIDxuZWlsYkBzdXNlLmRlPgpDYzogVGVqdW4gSGVvIDxodGVqdW5AZ21h
aWwuY29tPgpDYzogS2F5IFNpZXZlcnMgPGtheS5zaWV2ZXJzQHZyZnkub3JnPgpDYzogR3JlZyBL
SCA8Z3JlZ2toQHN1c2UuZGU+CkNjOiBNYXJrIExvcmQgPGxrbWxAcnRyLmNhPgpDYzogSC4gUGV0
ZXIgQW52aW4gPGhwYUB6eXRvci5jb20+ClNpZ25lZC1vZmYtYnk6IERhbiBXaWxsaWFtcyA8ZGFu
Lmoud2lsbGlhbXNAaW50ZWwuY29tPgotLS0KCiBkcml2ZXJzL2Jhc2UvY29yZS5jIHwgICAzNyAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystCiAxIGZpbGVzIGNoYW5nZWQsIDM2
IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmFz
ZS9jb3JlLmMgYi9kcml2ZXJzL2Jhc2UvY29yZS5jCmluZGV4IDI0MTk4YWQuLmRlOTI1ZjggMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMvYmFzZS9jb3JlLmMKKysrIGIvZHJpdmVycy9iYXNlL2NvcmUuYwpA
QCAtMjcsNiArMjcsOSBAQAogCiBpbnQgKCpwbGF0Zm9ybV9ub3RpZnkpKHN0cnVjdCBkZXZpY2Ug
KmRldikgPSBOVUxMOwogaW50ICgqcGxhdGZvcm1fbm90aWZ5X3JlbW92ZSkoc3RydWN0IGRldmlj
ZSAqZGV2KSA9IE5VTEw7CitzdGF0aWMgc3RydWN0IGtvYmplY3QgKmRldl9rb2JqOworc3RhdGlj
IHN0cnVjdCBrb2JqZWN0ICpjaGFyX2tvYmo7CitzdGF0aWMgc3RydWN0IGtvYmplY3QgKmJsb2Nr
X2tvYmo7CiAKICNpZmRlZiBDT05GSUdfQkxPQ0sKIHN0YXRpYyBpbmxpbmUgaW50IGRldmljZV9p
c19ub3RfcGFydGl0aW9uKHN0cnVjdCBkZXZpY2UgKmRldikKQEAgLTc1OSw2ICs3NjIsMTEgQEAg
c3RhdGljIHZvaWQgZGV2aWNlX3JlbW92ZV9jbGFzc19zeW1saW5rcyhzdHJ1Y3QgZGV2aWNlICpk
ZXYpCiAJc3lzZnNfcmVtb3ZlX2xpbmsoJmRldi0+a29iaiwgInN1YnN5c3RlbSIpOwogfQogCitz
dGF0aWMgc3RydWN0IGtvYmplY3QgKmRldmljZV90b19kZXZfa29iaihzdHJ1Y3QgZGV2aWNlICpk
ZXYpCit7CisJcmV0dXJuIGRldi0+Y2xhc3MgPT0gJmJsb2NrX2NsYXNzID8gYmxvY2tfa29iaiA6
IGNoYXJfa29iajsKK30KKwogLyoqCiAgKiBkZXZpY2VfYWRkIC0gYWRkIGRldmljZSB0byBkZXZp
Y2UgaGllcmFyY2h5LgogICogQGRldjogZGV2aWNlLgpAQCAtNzc1LDYgKzc4Myw3IEBAIGludCBk
ZXZpY2VfYWRkKHN0cnVjdCBkZXZpY2UgKmRldikKIAlzdHJ1Y3QgZGV2aWNlICpwYXJlbnQgPSBO
VUxMOwogCXN0cnVjdCBjbGFzc19pbnRlcmZhY2UgKmNsYXNzX2ludGY7CiAJaW50IGVycm9yOwor
CWNoYXIgZGV2dF9zdHJbMjVdOwogCiAJZGV2ID0gZ2V0X2RldmljZShkZXYpOwogCWlmICghZGV2
IHx8ICFzdHJsZW4oZGV2LT5idXNfaWQpKSB7CkBAIC04MDYsOSArODE1LDE2IEBAIGludCBkZXZp
Y2VfYWRkKHN0cnVjdCBkZXZpY2UgKmRldikKIAkJZ290byBhdHRyRXJyb3I7CiAKIAlpZiAoTUFK
T1IoZGV2LT5kZXZ0KSkgeworCQlzdHJ1Y3Qga29iamVjdCAqa29iaiA9IGRldmljZV90b19kZXZf
a29iaihkZXYpOworCiAJCWVycm9yID0gZGV2aWNlX2NyZWF0ZV9maWxlKGRldiwgJmRldnRfYXR0
cik7CiAJCWlmIChlcnJvcikKIAkJCWdvdG8gdWV2ZW50YXR0ckVycm9yOworCisJCWZvcm1hdF9k
ZXZfdChkZXZ0X3N0ciwgZGV2LT5kZXZ0KTsKKwkJZXJyb3IgPSBzeXNmc19jcmVhdGVfbGluayhr
b2JqLCAmZGV2LT5rb2JqLCBkZXZ0X3N0cik7CisJCWlmIChlcnJvcikKKwkJCWdvdG8gZGV2dGF0
dHJFcnJvcjsKIAl9CiAKIAllcnJvciA9IGRldmljZV9hZGRfY2xhc3Nfc3ltbGlua3MoZGV2KTsK
QEAgLTg1NCw2ICs4NzAsOSBAQCBpbnQgZGV2aWNlX2FkZChzdHJ1Y3QgZGV2aWNlICpkZXYpCiAJ
ZGV2aWNlX3JlbW92ZV9jbGFzc19zeW1saW5rcyhkZXYpOwogIFN5bWxpbmtFcnJvcjoKIAlpZiAo
TUFKT1IoZGV2LT5kZXZ0KSkKKwkJc3lzZnNfcmVtb3ZlX2xpbmsoZGV2aWNlX3RvX2Rldl9rb2Jq
KGRldiksIGRldnRfc3RyKTsKKyBkZXZ0YXR0ckVycm9yOgorCWlmIChNQUpPUihkZXYtPmRldnQp
KQogCQlkZXZpY2VfcmVtb3ZlX2ZpbGUoZGV2LCAmZGV2dF9hdHRyKTsKICB1ZXZlbnRhdHRyRXJy
b3I6CiAJZGV2aWNlX3JlbW92ZV9maWxlKGRldiwgJnVldmVudF9hdHRyKTsKQEAgLTkyNSwxMiAr
OTQ0LDE2IEBAIHZvaWQgZGV2aWNlX2RlbChzdHJ1Y3QgZGV2aWNlICpkZXYpCiB7CiAJc3RydWN0
IGRldmljZSAqcGFyZW50ID0gZGV2LT5wYXJlbnQ7CiAJc3RydWN0IGNsYXNzX2ludGVyZmFjZSAq
Y2xhc3NfaW50ZjsKKwljaGFyIGRldnRfc3RyWzI1XTsKIAogCWRldmljZV9wbV9yZW1vdmUoZGV2
KTsKIAlpZiAocGFyZW50KQogCQlrbGlzdF9kZWwoJmRldi0+a25vZGVfcGFyZW50KTsKLQlpZiAo
TUFKT1IoZGV2LT5kZXZ0KSkKKwlpZiAoTUFKT1IoZGV2LT5kZXZ0KSkgeworCQlmb3JtYXRfZGV2
X3QoZGV2dF9zdHIsIGRldi0+ZGV2dCk7CisJCXN5c2ZzX3JlbW92ZV9saW5rKGRldmljZV90b19k
ZXZfa29iaihkZXYpLCBkZXZ0X3N0cik7CiAJCWRldmljZV9yZW1vdmVfZmlsZShkZXYsICZkZXZ0
X2F0dHIpOworCX0KIAlpZiAoZGV2LT5jbGFzcykgewogCQlkZXZpY2VfcmVtb3ZlX2NsYXNzX3N5
bWxpbmtzKGRldik7CiAKQEAgLTEwNTUsNiArMTA3OCwxNSBAQCBpbnQgX19pbml0IGRldmljZXNf
aW5pdCh2b2lkKQogCWRldmljZXNfa3NldCA9IGtzZXRfY3JlYXRlX2FuZF9hZGQoImRldmljZXMi
LCAmZGV2aWNlX3VldmVudF9vcHMsIE5VTEwpOwogCWlmICghZGV2aWNlc19rc2V0KQogCQlyZXR1
cm4gLUVOT01FTTsKKwlkZXZfa29iaiA9IGtvYmplY3RfY3JlYXRlX2FuZF9hZGQoImRldiIsIE5V
TEwpOworCWlmICghZGV2X2tvYmopCisJCXJldHVybiAtRU5PTUVNOworCWJsb2NrX2tvYmogPSBr
b2JqZWN0X2NyZWF0ZV9hbmRfYWRkKCJibG9jayIsIGRldl9rb2JqKTsKKwlpZiAoIWJsb2NrX2tv
YmopCisJCXJldHVybiAtRU5PTUVNOworCWNoYXJfa29iaiA9IGtvYmplY3RfY3JlYXRlX2FuZF9h
ZGQoImNoYXIiLCBkZXZfa29iaik7CisJaWYgKCFjaGFyX2tvYmopCisJCXJldHVybiAtRU5PTUVN
OwogCXJldHVybiAwOwogfQogCkBAIC0xMzgwLDQgKzE0MTIsNyBAQCB2b2lkIGRldmljZV9zaHV0
ZG93bih2b2lkKQogCQkJZGV2LT5kcml2ZXItPnNodXRkb3duKGRldik7CiAJCX0KIAl9CisJa29i
amVjdF9wdXQoY2hhcl9rb2JqKTsKKwlrb2JqZWN0X3B1dChibG9ja19rb2JqKTsKKwlrb2JqZWN0
X3B1dChkZXZfa29iaik7CiB9Cg==
------=_Part_14037_24360112.1207956332290--
