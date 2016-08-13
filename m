From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Time to make dynamically allocated devt the default for scsi disks?
Date: Sat, 13 Aug 2016 09:29:07 -0700
Message-ID: <CAPcyv4gDw49gZBO=Y+K9krgth68OUHcs8urGDNXiZzLNa6kotg@mail.gmail.com>
References: <CAPcyv4jK8W52ss2FhJDa=95B_1q8Szv4AmH0f7p_jzyfEXv0Ag@mail.gmail.com>
 <1471047451.2407.95.camel@HansenPartnership.com> <CAPcyv4jqEaBY1atyrjG3G4PYOzaoLvAMfHgK1PD0Si=MRRwAuw@mail.gmail.com>
 <CAPcyv4i=85fCAm1A5Zh2+nYSw7vwXOD=i-B0g4m2eJ+XkEW3tw@mail.gmail.com> <1471101800.2397.9.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11433a668f60730539f67fa7
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1471101800.2397.9.camel@HansenPartnership.com>
Sender: linux-block-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Dave Hansen <dave.hansen@intel.com>
List-Id: linux-scsi@vger.kernel.org

--001a11433a668f60730539f67fa7
Content-Type: text/plain; charset=UTF-8

On Sat, Aug 13, 2016 at 8:23 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2016-08-12 at 21:57 -0700, Dan Williams wrote:
>> On Fri, Aug 12, 2016 at 5:29 PM, Dan Williams <
>> dan.j.williams@intel.com> wrote:
>> > On Fri, Aug 12, 2016 at 5:17 PM, James Bottomley
>> > <James.Bottomley@hansenpartnership.com> wrote:
>> > > On Fri, 2016-08-12 at 14:29 -0700, Dan Williams wrote:
>> > > > Before spending effort trying to flush the destruction of old
>> > > > bdi
>> > > > instances before new ones are registered, is it rather time to
>> > > > complete the conversion of sd to only use dynamically allocated
>> > > > devt?
>> > >
>> > > Do we have to go that far?  Surely your fix is extensible: the
>> > > only
>> > > reason it doesn't work for us is that the gendisk holds the
>> > > parent
>> > > without a reference, so we can free the SCSI device before its
>> > > child
>> > > gendisk (good job no-one actually uses gendisk->parent after
>> > > we've
>> > > released it ...).  If we fix that it would mean SCSI can't
>> > > release the
>> > > sdev until after the queue is dead and the bdi namespace
>> > > released, so
>> > > isn't something like this the easy fix?
>> > >
>> > > James
>> > >
>> > > ---
>> > >
>> > > diff --git a/block/genhd.c b/block/genhd.c
>> > > index fcd6d4f..54ae4ae 100644
>> > > --- a/block/genhd.c
>> > > +++ b/block/genhd.c
>> > > @@ -514,7 +514,7 @@ static void register_disk(struct device
>> > > *parent, struct gendisk *disk)
>> > >         struct hd_struct *part;
>> > >         int err;
>> > >
>> > > -       ddev->parent = parent;
>> > > +       ddev->parent = get_device(parent);
>> > >
>> > >         dev_set_name(ddev, "%s", disk->disk_name);
>> > >
>> > > @@ -1144,6 +1144,7 @@ static void disk_release(struct device
>> > > *dev)
>> > >         hd_free_part(&disk->part0);
>> > >         if (disk->queue)
>> > >                 blk_put_queue(disk->queue);
>> > > +       put_device(dev->parent);
>> > >         kfree(disk);
>> > >  }
>> > >  struct class block_class = {
>> >
>> > Looks ok at first glance to me.
>> >
>> > We do hold a reference on the parent device, but it gets dropped at
>> > device_unregister() time and this moves it out to the final put.
>
> We do?  Where?

Yes, register_disk() does "ddev->parent = parent" and then
"device_add(ddev)".  device_add() takes the parent reference.

>
>> > However, this does leave static devt block-device-drivers that
>> > register a disk without a parent device susceptible to the race...
>> > I think those exist given all the drivers still using add_disk()
>> > after commit 52c44d93c26f "block: remove ->driverfs_dev".
>
> It does?  The race is the fact that the parent can be removed before
> the child meaning if the parent name is re-registered before the child
> dies we get a duplicate name in bdi space.

No, the race is that the *name* of the parent isn't released until the
child is both unregistered and put.  The device core is already
ensuring that the parent is not released until all descendants have
been removed.

>
>> So I tried the attached and it makes the libnvdimm unit tests start
>> crashing.
>
> Well, the attached is clearly buggy, isn't it?  You're trying to do a
> get on the parent before the parent is actually set.

Ah, yes, thank you.  Fixed up v2 attached that passes my tests.

> Why don't you
> just try the incremental patch I sent instead of trying to rework it?

I reworked it because it is the bdi that holds this extra dependency
on the disk's parent, not the disk itself.

>
>>   A couple crash logs attached.  Not yet sure what assumption
>> is getting violated, but how about that conversion of scsi to use
>> dynamic devt? ;-)
>
> It's completely orthogonal.  The problem is in hierarchy lifetimes:
> switching from static to dynamic allocation won't change that at all.
>  You don't see this problem in nvme because the parent control device's
> lifetime belongs to the controller not the disk.  In SCSI the parent is
> our representation of the SCSI device whose lifetime is governed at the
> SCSI level and effectively represents the disk.
>

No, it's only the name.  We could achieve the same by teaching the
block core to manage the "sd_index_ida" instead of the sd driver
itself, but the v2-patch attached works and does not introduce that
layering violation.

--001a11433a668f60730539f67fa7
Content-Type: application/octet-stream; name=patch-v2
Content-Disposition: attachment; filename=patch-v2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_irteba5g0

YmxvY2s6IGV4dGVuZCB0aGUgbGlmZXRpbWUgb2YgZGlzayBwYXJlbnQgZGV2aWNlcwoKRnJvbTog
RGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+CgpDb21taXQgZGYwOGMzMmNl
M2JlICJibG9jazogZml4IGJkaSB2cyBnZW5kaXNrIGxpZmV0aW1lIG1pc21hdGNoIiBmaXhlZAp0
aGUgY2FzZSB3aGVyZSB0aGUgYmRpIGlzIG5hbWVkIGZyb20gYSBnZW5kaXNrIHdpdGggYSBkeW5h
bWljYWxseQphbGxvY2F0ZWQgZGV2dC4gIEhvd2V2ZXIgdGhpcyBsZWF2ZXMgdGhlIGJ1ZyBpbiBw
bGFjZSBob2xlIGZvciBkcml2ZXJzCnVzaW5nIGEgc3RhdGljIGRldnQgbGlrZSBzZC4gIEphbWVz
IG9ic2VydmVzIHRoYXQgZm9yIHNjc2kgd2UgY2FuCmFkZHJlc3MgdGhlIGlzc3VlIGJ5IGJ1aWxk
aW5nIG9uIHRoZSBpbml0aWFsIGZpeCB0byBleHRlbmQgdGhlIGxpZmV0aW1lCm9mIHRoZSBkaXNr
IGRldmljZSB1bnRpbCB0aGUgYmRpIGlzIHJlbGVhc2VkLiAgVGhpcyBlZmZlY3RpdmVseSBtYWtl
cwp0aGUgbGlmZXRpbWUgb2YgYSBzdGF0aWNhbGx5IGFsbG9jYXRlZCBkZXZ0IGlkZW50aWNhbCB0
byB0aGF0IG9mIGEKZHluYW1pY2FsbHkgYWxsb2NhdGVkIGRldnQuCgpIb3dldmVyLCB0aGlzIGxl
YXZlcyBhIGhvbGUgZm9yIGJsb2NrIGRldmljZSBkcml2ZXJzIHRoYXQgdXNlIGEKc3RhdGljYWxs
eSBhbGxvY2F0ZWQgZGV2dCwgYnV0IGRvIG5vdCBzcGVjaWZ5IGEgcGFyZW50IGRldmljZS4gVGhv
c2UKZHJpdmVycyBpZiB0aGV5IGV4aXN0LCBzaG91bGQgbW92ZSB0byBkeW5hbWljYWxseSBhbGxv
Y2F0ZWQgZGV2dCwgb3IKcmVnaXN0ZXIgYSBwYXJlbnQgZGV2aWNlIGlmIHRoZXkgYXJlIG9uIGEg
aG90cGx1ZyBjYXBhYmxlIGJ1cy4KCkNjOiBCYXJ0IFZhbiBBc3NjaGUgPGJhcnQudmFuYXNzY2hl
QHNhbmRpc2suY29tPgpDYzogSmVucyBBeGJvZSA8YXhib2VAZmIuY29tPgpDYzogIk1hcnRpbiBL
LiBQZXRlcnNlbiIgPG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tPiwKQ2M6IENocmlzdG9waCBI
ZWxsd2lnIDxoY2hAbHN0LmRlPgpDYzogVGVqdW4gSGVvIDx0akBrZXJuZWwub3JnPgpDYzogRGF2
ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGludGVsLmNvbT4sClN1Z2dlc3RlZC1ieTogSmFtZXMgQm90
dG9tbGV5IDxKYW1lcy5Cb3R0b21sZXlAaGFuc2VucGFydG5lcnNoaXAuY29tPgpTaWduZWQtb2Zm
LWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4KLS0tCiBibG9jay9n
ZW5oZC5jICAgICAgICAgICAgICAgfCAgIDEyICsrKysrKystLS0tLQogaW5jbHVkZS9saW51eC9i
YWNraW5nLWRldi5oIHwgICAgMiArLQogbW0vYmFja2luZy1kZXYuYyAgICAgICAgICAgIHwgICAx
MyArKysrKysrKysrKy0tCiAzIGZpbGVzIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDggZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYmxvY2svZ2VuaGQuYyBiL2Jsb2NrL2dlbmhkLmMKaW5k
ZXggZmNkNmQ0ZmFlNjU3Li44NDVjMTVkNzM1N2EgMTAwNjQ0Ci0tLSBhL2Jsb2NrL2dlbmhkLmMK
KysrIGIvYmxvY2svZ2VuaGQuYwpAQCAtNTA2LDcgKzUwNiw3IEBAIHN0YXRpYyBpbnQgZXhhY3Rf
bG9jayhkZXZfdCBkZXZ0LCB2b2lkICpkYXRhKQogCXJldHVybiAwOwogfQogCi1zdGF0aWMgdm9p
ZCByZWdpc3Rlcl9kaXNrKHN0cnVjdCBkZXZpY2UgKnBhcmVudCwgc3RydWN0IGdlbmRpc2sgKmRp
c2spCitzdGF0aWMgdm9pZCByZWdpc3Rlcl9kaXNrKHN0cnVjdCBnZW5kaXNrICpkaXNrKQogewog
CXN0cnVjdCBkZXZpY2UgKmRkZXYgPSBkaXNrX3RvX2RldihkaXNrKTsKIAlzdHJ1Y3QgYmxvY2tf
ZGV2aWNlICpiZGV2OwpAQCAtNTE0LDggKzUxNCw2IEBAIHN0YXRpYyB2b2lkIHJlZ2lzdGVyX2Rp
c2soc3RydWN0IGRldmljZSAqcGFyZW50LCBzdHJ1Y3QgZ2VuZGlzayAqZGlzaykKIAlzdHJ1Y3Qg
aGRfc3RydWN0ICpwYXJ0OwogCWludCBlcnI7CiAKLQlkZGV2LT5wYXJlbnQgPSBwYXJlbnQ7Ci0K
IAlkZXZfc2V0X25hbWUoZGRldiwgIiVzIiwgZGlzay0+ZGlza19uYW1lKTsKIAogCS8qIGRlbGF5
IHVldmVudHMsIHVudGlsIHdlIHNjYW5uZWQgcGFydGl0aW9uIHRhYmxlICovCkBAIC02MDIsNiAr
NjAwLDcgQEAgdm9pZCBkZXZpY2VfYWRkX2Rpc2soc3RydWN0IGRldmljZSAqcGFyZW50LCBzdHJ1
Y3QgZ2VuZGlzayAqZGlzaykKIAkJV0FSTl9PTigxKTsKIAkJcmV0dXJuOwogCX0KKwlkaXNrX3Rv
X2RldihkaXNrKS0+cGFyZW50ID0gcGFyZW50OwogCWRpc2tfdG9fZGV2KGRpc2spLT5kZXZ0ID0g
ZGV2dDsKIAogCS8qIC0+bWFqb3IgYW5kIC0+Zmlyc3RfbWlub3IgYXJlbid0IHN1cHBvc2VkIHRv
IGJlCkBAIC02MTQsMTEgKzYxMywxMSBAQCB2b2lkIGRldmljZV9hZGRfZGlzayhzdHJ1Y3QgZGV2
aWNlICpwYXJlbnQsIHN0cnVjdCBnZW5kaXNrICpkaXNrKQogCiAJLyogUmVnaXN0ZXIgQkRJIGJl
Zm9yZSByZWZlcmVuY2luZyBpdCBmcm9tIGJkZXYgKi8KIAliZGkgPSAmZGlzay0+cXVldWUtPmJh
Y2tpbmdfZGV2X2luZm87Ci0JYmRpX3JlZ2lzdGVyX293bmVyKGJkaSwgZGlza190b19kZXYoZGlz
aykpOworCWJkaV9yZWdpc3Rlcl9kaXNrKGJkaSwgZGlzayk7CiAKIAlibGtfcmVnaXN0ZXJfcmVn
aW9uKGRpc2tfZGV2dChkaXNrKSwgZGlzay0+bWlub3JzLCBOVUxMLAogCQkJICAgIGV4YWN0X21h
dGNoLCBleGFjdF9sb2NrLCBkaXNrKTsKLQlyZWdpc3Rlcl9kaXNrKHBhcmVudCwgZGlzayk7CisJ
cmVnaXN0ZXJfZGlzayhkaXNrKTsKIAlibGtfcmVnaXN0ZXJfcXVldWUoZGlzayk7CiAKIAkvKgpA
QCAtMTE0NCw2ICsxMTQzLDkgQEAgc3RhdGljIHZvaWQgZGlza19yZWxlYXNlKHN0cnVjdCBkZXZp
Y2UgKmRldikKIAloZF9mcmVlX3BhcnQoJmRpc2stPnBhcnQwKTsKIAlpZiAoZGlzay0+cXVldWUp
CiAJCWJsa19wdXRfcXVldWUoZGlzay0+cXVldWUpOworCisJLyogc2VlIGJkaV9yZWdpc3Rlcl9k
aXNrKCkgKi8KKwlwdXRfZGV2aWNlKGRldi0+cGFyZW50KTsKIAlrZnJlZShkaXNrKTsKIH0KIHN0
cnVjdCBjbGFzcyBibG9ja19jbGFzcyA9IHsKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvYmFj
a2luZy1kZXYuaCBiL2luY2x1ZGUvbGludXgvYmFja2luZy1kZXYuaAppbmRleCA0M2I5M2E5NDdl
NjEuLmRmOWUxYTc2NjE1NyAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9iYWNraW5nLWRldi5o
CisrKyBiL2luY2x1ZGUvbGludXgvYmFja2luZy1kZXYuaApAQCAtMjQsNyArMjQsNyBAQCBfX3By
aW50ZigzLCA0KQogaW50IGJkaV9yZWdpc3RlcihzdHJ1Y3QgYmFja2luZ19kZXZfaW5mbyAqYmRp
LCBzdHJ1Y3QgZGV2aWNlICpwYXJlbnQsCiAJCWNvbnN0IGNoYXIgKmZtdCwgLi4uKTsKIGludCBi
ZGlfcmVnaXN0ZXJfZGV2KHN0cnVjdCBiYWNraW5nX2Rldl9pbmZvICpiZGksIGRldl90IGRldik7
Ci1pbnQgYmRpX3JlZ2lzdGVyX293bmVyKHN0cnVjdCBiYWNraW5nX2Rldl9pbmZvICpiZGksIHN0
cnVjdCBkZXZpY2UgKm93bmVyKTsKK2ludCBiZGlfcmVnaXN0ZXJfZGlzayhzdHJ1Y3QgYmFja2lu
Z19kZXZfaW5mbyAqYmRpLCBzdHJ1Y3QgZ2VuZGlzayAqZGlzayk7CiB2b2lkIGJkaV91bnJlZ2lz
dGVyKHN0cnVjdCBiYWNraW5nX2Rldl9pbmZvICpiZGkpOwogCiBpbnQgX19tdXN0X2NoZWNrIGJk
aV9zZXR1cF9hbmRfcmVnaXN0ZXIoc3RydWN0IGJhY2tpbmdfZGV2X2luZm8gKiwgY2hhciAqKTsK
ZGlmZiAtLWdpdCBhL21tL2JhY2tpbmctZGV2LmMgYi9tbS9iYWNraW5nLWRldi5jCmluZGV4IDhm
ZGU0NDNmMzZkNy4uYjYyMWM4ZThjZDY4IDEwMDY0NAotLS0gYS9tbS9iYWNraW5nLWRldi5jCisr
KyBiL21tL2JhY2tpbmctZGV2LmMKQEAgLTgyNSw4ICs4MjUsOSBAQCBpbnQgYmRpX3JlZ2lzdGVy
X2RldihzdHJ1Y3QgYmFja2luZ19kZXZfaW5mbyAqYmRpLCBkZXZfdCBkZXYpCiB9CiBFWFBPUlRf
U1lNQk9MKGJkaV9yZWdpc3Rlcl9kZXYpOwogCi1pbnQgYmRpX3JlZ2lzdGVyX293bmVyKHN0cnVj
dCBiYWNraW5nX2Rldl9pbmZvICpiZGksIHN0cnVjdCBkZXZpY2UgKm93bmVyKQoraW50IGJkaV9y
ZWdpc3Rlcl9kaXNrKHN0cnVjdCBiYWNraW5nX2Rldl9pbmZvICpiZGksIHN0cnVjdCBnZW5kaXNr
ICpkaXNrKQogeworCXN0cnVjdCBkZXZpY2UgKm93bmVyID0gZGlza190b19kZXYoZGlzayk7CiAJ
aW50IHJjOwogCiAJcmMgPSBiZGlfcmVnaXN0ZXIoYmRpLCBOVUxMLCAiJXU6JXUiLCBNQUpPUihv
d25lci0+ZGV2dCksCkBAIC04MzUsOSArODM2LDE3IEBAIGludCBiZGlfcmVnaXN0ZXJfb3duZXIo
c3RydWN0IGJhY2tpbmdfZGV2X2luZm8gKmJkaSwgc3RydWN0IGRldmljZSAqb3duZXIpCiAJCXJl
dHVybiByYzsKIAliZGktPm93bmVyID0gb3duZXI7CiAJZ2V0X2RldmljZShvd25lcik7CisKKwkv
KgorCSAqIEZvciBzdGF0aWNhbGx5IGFsbG9jYXRlZCBkZXZ0IGRpc2tzLCBsaWtlIHNjc2ksIHRo
ZSBkaXNrJ3MKKwkgKiBwYXJlbnQgaG9sZHMgdGhlIGxpZmV0aW1lIGZvciB0aGUgZGV2dC4gIFBy
ZXZlbnQgdGhlIHBhcmVudAorCSAqIGZyb20gcmVsZWFzaW5nIHRoZSBkZXZ0IGZvciByZXVzZSB1
bnRpbCB0aGUgZGlzayBpcyByZWxlYXNlZC4KKwkgKi8KKwlnZXRfZGV2aWNlKG93bmVyLT5wYXJl
bnQpOworCiAJcmV0dXJuIDA7CiB9Ci1FWFBPUlRfU1lNQk9MKGJkaV9yZWdpc3Rlcl9vd25lcik7
CitFWFBPUlRfU1lNQk9MKGJkaV9yZWdpc3Rlcl9kaXNrKTsKIAogLyoKICAqIFJlbW92ZSBiZGkg
ZnJvbSBiZGlfbGlzdCwgYW5kIGVuc3VyZSB0aGF0IGl0IGlzIG5vIGxvbmdlciB2aXNpYmxlCg==
--001a11433a668f60730539f67fa7--
