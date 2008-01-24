From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: [PATCH 1/1] aacraid: fib context lock for management ioctls
Date: Thu, 24 Jan 2008 07:40:10 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F4394BC368@ADPE2K703.adaptec.com>
References: <20071031150216.88cecc21.sfr@canb.auug.org.au><20071101173221.2e1fea42.sfr@canb.auug.org.au>
 <jefxzqqeha.fsf@sykes.suse.de>
 <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE734@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE735@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE736@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE738@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE739@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40DC6C9@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_532ABFBDAAC3A34EB12EBA6CEC2838F4394BC368ADPE2K703adapte_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:51892 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbYAXPkP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jan 2008 10:40:15 -0500
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F40DC6C9@ADPE2K703.adaptec.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: 'Alan Cox' <alan@lxorguk.ukuu.org.uk>, 'Alan Cox' <alan@redhat.com>

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F4394BC368ADPE2K703adapte_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Alan noticed the lack of locking surrounding the driver's dealings with the=
 fib context managed by the trio of ioctls that are used by the RAID manage=
ment applications to retrieve Adapter Initiated FIBs. I merely expanded the=
 fib lock to include the fib context. There have been no field reports of a=
ny issues generally because the applications are relatively static and do n=
ot come and go often enough to stress this area. I bloated this patch a lit=
tle with some space junk.

This attached patch is against current scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's hand=
ling of patch attachments. The following inline patch is 'diff -rub' to pul=
l out the space junk to enable convenient inspection, please use the attach=
ed file to patch.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/commctrl.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff -rub a/commctrl.c b/commctrl.c
--- a/drivers/scsi/aacraid/commctrl.c        2008-01-24 09:44:33.080806785 =
-0500
+++ b/drivers/scsi/aacraid/commctrl.c        2008-01-24 09:50:41.071552674 =
-0500
@@ -243,6 +243,7 @@
         *      Search the list of AdapterFibContext addresses on the adapt=
er
         *      to be sure this is a valid address
         */
+       spin_lock_irqsave(&dev->fib_lock, flags);
        entry =3D dev->fib_list.next;
        fibctx =3D NULL;

@@ -258,17 +259,18 @@
                fibctx =3D NULL;
        }
        if (!fibctx) {
+               spin_unlock_irqrestore(&dev->fib_lock, flags);
                dprintk ((KERN_INFO "Fib Context not found\n"));
                return -EINVAL;
        }

        if((fibctx->type !=3D FSAFS_NTC_GET_ADAPTER_FIB_CONTEXT) ||
                 (fibctx->size !=3D sizeof(struct aac_fib_context))) {
+               spin_unlock_irqrestore(&dev->fib_lock, flags);
                dprintk ((KERN_INFO "Fib Context corrupt?\n"));
                return -EINVAL;
        }
        status =3D 0;
-       spin_lock_irqsave(&dev->fib_lock, flags);
        /*
         *      If there are no fibs to send back, then either wait or retu=
rn
         *      -EAGAIN
@@ -326,7 +328,9 @@
 int aac_close_fib_context(struct aac_dev * dev, struct aac_fib_context * f=
ibctx)
 {
        struct fib *fib;
+       unsigned long flags;

+       spin_lock_irqsave(&dev->fib_lock, flags);
        /*
         *      First free any FIBs that have not been consumed.
         */
@@ -349,6 +353,7 @@
         *      Remove the Context from the AdapterFibContext List
         */
        list_del(&fibctx->next);
+       spin_unlock_irqrestore(&dev->fib_lock, flags);
        /*
         *      Invalidate context
         */

Sincerely - Mark Salyzyn

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F4394BC368ADPE2K703adapte_
Content-Type: application/octet-stream; name="aacraid_fibctx_lock.patch"
Content-Description: aacraid_fibctx_lock.patch
Content-Disposition: attachment; filename="aacraid_fibctx_lock.patch";
	size=3464; creation-date="Thu, 24 Jan 2008 07:23:04 GMT";
	modification-date="Thu, 24 Jan 2008 07:23:04 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21tY3RybC5jIGIvZHJpdmVycy9zY3Np
L2FhY3JhaWQvY29tbWN0cmwuYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21tY3RybC5j
CTIwMDgtMDEtMjQgMDk6NDQ6MzMuMDgwODA2Nzg1IC0wNTAwCisrKyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2NvbW1jdHJsLmMJMjAwOC0wMS0yNCAwOTo1MDo0MS4wNzE1NTI2NzQgLTA1MDAKQEAg
LTI0Myw2ICsyNDMsNyBAQAogCSAqCVNlYXJjaCB0aGUgbGlzdCBvZiBBZGFwdGVyRmliQ29udGV4
dCBhZGRyZXNzZXMgb24gdGhlIGFkYXB0ZXIKIAkgKgl0byBiZSBzdXJlIHRoaXMgaXMgYSB2YWxp
ZCBhZGRyZXNzCiAJICovCisJc3Bpbl9sb2NrX2lycXNhdmUoJmRldi0+ZmliX2xvY2ssIGZsYWdz
KTsKIAllbnRyeSA9IGRldi0+ZmliX2xpc3QubmV4dDsKIAlmaWJjdHggPSBOVUxMOwogCkBAIC0y
NTEsMjQgKzI1MiwyNSBAQAogCQkvKgogCQkgKglFeHRyYWN0IHRoZSBBZGFwdGVyRmliQ29udGV4
dCBmcm9tIHRoZSBJbnB1dCBwYXJhbWV0ZXJzLgogCQkgKi8KLQkJaWYgKGZpYmN0eC0+dW5pcXVl
ID09IGYuZmliY3R4KSB7ICAgLyogV2UgZm91bmQgYSB3aW5uZXIgKi8KKwkJaWYgKGZpYmN0eC0+
dW5pcXVlID09IGYuZmliY3R4KSB7IC8qIFdlIGZvdW5kIGEgd2lubmVyICovCiAJCQlicmVhazsK
IAkJfQogCQllbnRyeSA9IGVudHJ5LT5uZXh0OwogCQlmaWJjdHggPSBOVUxMOwogCX0KIAlpZiAo
IWZpYmN0eCkgeworCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZkZXYtPmZpYl9sb2NrLCBmbGFn
cyk7CiAJCWRwcmludGsgKChLRVJOX0lORk8gIkZpYiBDb250ZXh0IG5vdCBmb3VuZFxuIikpOwog
CQlyZXR1cm4gLUVJTlZBTDsKIAl9CiAKIAlpZigoZmliY3R4LT50eXBlICE9IEZTQUZTX05UQ19H
RVRfQURBUFRFUl9GSUJfQ09OVEVYVCkgfHwKIAkJIChmaWJjdHgtPnNpemUgIT0gc2l6ZW9mKHN0
cnVjdCBhYWNfZmliX2NvbnRleHQpKSkgeworCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZkZXYt
PmZpYl9sb2NrLCBmbGFncyk7CiAJCWRwcmludGsgKChLRVJOX0lORk8gIkZpYiBDb250ZXh0IGNv
cnJ1cHQ/XG4iKSk7CiAJCXJldHVybiAtRUlOVkFMOwogCX0KIAlzdGF0dXMgPSAwOwotCXNwaW5f
bG9ja19pcnFzYXZlKCZkZXYtPmZpYl9sb2NrLCBmbGFncyk7CiAJLyoKIAkgKglJZiB0aGVyZSBh
cmUgbm8gZmlicyB0byBzZW5kIGJhY2ssIHRoZW4gZWl0aGVyIHdhaXQgb3IgcmV0dXJuCiAJICoJ
LUVBR0FJTgpAQCAtMzI2LDcgKzMyOCw5IEBACiBpbnQgYWFjX2Nsb3NlX2ZpYl9jb250ZXh0KHN0
cnVjdCBhYWNfZGV2ICogZGV2LCBzdHJ1Y3QgYWFjX2ZpYl9jb250ZXh0ICogZmliY3R4KQogewog
CXN0cnVjdCBmaWIgKmZpYjsKKwl1bnNpZ25lZCBsb25nIGZsYWdzOwogCisJc3Bpbl9sb2NrX2ly
cXNhdmUoJmRldi0+ZmliX2xvY2ssIGZsYWdzKTsKIAkvKgogCSAqCUZpcnN0IGZyZWUgYW55IEZJ
QnMgdGhhdCBoYXZlIG5vdCBiZWVuIGNvbnN1bWVkLgogCSAqLwpAQCAtMzQ5LDYgKzM1Myw3IEBA
CiAJICoJUmVtb3ZlIHRoZSBDb250ZXh0IGZyb20gdGhlIEFkYXB0ZXJGaWJDb250ZXh0IExpc3QK
IAkgKi8KIAlsaXN0X2RlbCgmZmliY3R4LT5uZXh0KTsKKwlzcGluX3VubG9ja19pcnFyZXN0b3Jl
KCZkZXYtPmZpYl9sb2NrLCBmbGFncyk7CiAJLyoKIAkgKglJbnZhbGlkYXRlIGNvbnRleHQKIAkg
Ki8KQEAgLTQxNCw4ICs0MTksOCBAQAogICoJQGFyZzogaW9jdGwgYXJndW1lbnRzCiAgKgogICoJ
VGhpcyByb3V0aW5lIHJldHVybnMgdGhlIGRyaXZlciB2ZXJzaW9uLgotICogICAgICBVbmRlciBM
aW51eCwgdGhlcmUgaGF2ZSBiZWVuIG5vIHZlcnNpb24gaW5jb21wYXRpYmlsaXRpZXMsIHNvIHRo
aXMgaXMKLSAqICAgICAgc2ltcGxlIQorICoJVW5kZXIgTGludXgsIHRoZXJlIGhhdmUgYmVlbiBu
byB2ZXJzaW9uIGluY29tcGF0aWJpbGl0aWVzLCBzbyB0aGlzIGlzCisgKglzaW1wbGUhCiAgKi8K
IAogc3RhdGljIGludCBjaGVja19yZXZpc2lvbihzdHJ1Y3QgYWFjX2RldiAqZGV2LCB2b2lkIF9f
dXNlciAqYXJnKQpAQCAtNDYzLDcgKzQ2OCw3IEBACiAJdTMyIGRhdGFfZGlyOwogCXZvaWQgX191
c2VyICpzZ191c2VyWzMyXTsKIAl2b2lkICpzZ19saXN0WzMyXTsKLQl1MzIgICBzZ19pbmR4ID0g
MDsKKwl1MzIgc2dfaW5keCA9IDA7CiAJdTMyIGJ5dGVfY291bnQgPSAwOwogCXUzMiBhY3R1YWxf
Zmlic2l6ZTY0LCBhY3R1YWxfZmlic2l6ZSA9IDA7CiAJaW50IGk7CkBAIC01MTcsMTEgKzUyMiwx
MSBAQAogCS8vIEZpeCB1cCBzcmIgZm9yIGVuZGlhbiBhbmQgZm9yY2Ugc29tZSB2YWx1ZXMKIAog
CXNyYmNtZC0+ZnVuY3Rpb24gPSBjcHVfdG9fbGUzMihTUkJGX0V4ZWN1dGVTY3NpKTsJLy8gRm9y
Y2UgdGhpcwotCXNyYmNtZC0+Y2hhbm5lbCAgPSBjcHVfdG9fbGUzMih1c2VyX3NyYmNtZC0+Y2hh
bm5lbCk7CisJc3JiY21kLT5jaGFubmVsCSA9IGNwdV90b19sZTMyKHVzZXJfc3JiY21kLT5jaGFu
bmVsKTsKIAlzcmJjbWQtPmlkCSA9IGNwdV90b19sZTMyKHVzZXJfc3JiY21kLT5pZCk7Ci0Jc3Ji
Y21kLT5sdW4gICAgICA9IGNwdV90b19sZTMyKHVzZXJfc3JiY21kLT5sdW4pOwotCXNyYmNtZC0+
dGltZW91dCAgPSBjcHVfdG9fbGUzMih1c2VyX3NyYmNtZC0+dGltZW91dCk7Ci0Jc3JiY21kLT5m
bGFncyAgICA9IGNwdV90b19sZTMyKGZsYWdzKTsKKwlzcmJjbWQtPmx1bgkgPSBjcHVfdG9fbGUz
Mih1c2VyX3NyYmNtZC0+bHVuKTsKKwlzcmJjbWQtPnRpbWVvdXQJID0gY3B1X3RvX2xlMzIodXNl
cl9zcmJjbWQtPnRpbWVvdXQpOworCXNyYmNtZC0+ZmxhZ3MJID0gY3B1X3RvX2xlMzIoZmxhZ3Mp
OwogCXNyYmNtZC0+cmV0cnlfbGltaXQgPSAwOyAvLyBPYnNvbGV0ZSBwYXJhbWV0ZXIKIAlzcmJj
bWQtPmNkYl9zaXplID0gY3B1X3RvX2xlMzIodXNlcl9zcmJjbWQtPmNkYl9zaXplKTsKIAltZW1j
cHkoc3JiY21kLT5jZGIsIHVzZXJfc3JiY21kLT5jZGIsIHNpemVvZihzcmJjbWQtPmNkYikpOwpA
QCAtNzg2LDkgKzc5MSw5IEBACiAJcGNpX2luZm8uYnVzID0gZGV2LT5wZGV2LT5idXMtPm51bWJl
cjsKIAlwY2lfaW5mby5zbG90ID0gUENJX1NMT1QoZGV2LT5wZGV2LT5kZXZmbik7CiAKLSAgICAg
ICBpZiAoY29weV90b191c2VyKGFyZywgJnBjaV9pbmZvLCBzaXplb2Yoc3RydWN0IGFhY19wY2lf
aW5mbykpKSB7Ci0JICAgICAgIGRwcmludGsoKEtFUk5fREVCVUcgImFhY3JhaWQ6IENvdWxkIG5v
dCBjb3B5IHBjaSBpbmZvXG4iKSk7Ci0JICAgICAgIHJldHVybiAtRUZBVUxUOworCWlmIChjb3B5
X3RvX3VzZXIoYXJnLCAmcGNpX2luZm8sIHNpemVvZihzdHJ1Y3QgYWFjX3BjaV9pbmZvKSkpIHsK
KwkJZHByaW50aygoS0VSTl9ERUJVRyAiYWFjcmFpZDogQ291bGQgbm90IGNvcHkgcGNpIGluZm9c
biIpKTsKKwkJcmV0dXJuIC1FRkFVTFQ7CiAJfQogCXJldHVybiAwOwogfQo=

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F4394BC368ADPE2K703adapte_--
