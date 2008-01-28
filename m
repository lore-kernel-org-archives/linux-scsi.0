From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: [PATCH 1/1] aacraid: fib context lock for management ioctls (take 2)
Date: Mon, 28 Jan 2008 12:16:52 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F4395CF508@ADPE2K703.adaptec.com>
References: <20071031150216.88cecc21.sfr@canb.auug.org.au><20071101173221.2e1fea42.sfr@canb.auug.org.au>
 <jefxzqqeha.fsf@sykes.suse.de>
 <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE734@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE735@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE736@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE738@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE739@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40DC6C9@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F4394BC368@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_532ABFBDAAC3A34EB12EBA6CEC2838F4395CF508ADPE2K703adapte_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:53852 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944AbYA1UQx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jan 2008 15:16:53 -0500
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F4394BC368@ADPE2K703.adaptec.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: 'Alan Cox' <alan@lxorguk.ukuu.org.uk>, 'Alan Cox' <alan@redhat.com>

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F4395CF508ADPE2K703adapte_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

The first patch was a bit too aggressive and nested the locks (!) unit test=
ing was in error.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/commctrl.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Salyzyn, Mark
> Sent: Thursday, January 24, 2008 10:40 AM
> To: 'linux-scsi@vger.kernel.org'
> Cc: 'Alan Cox'; 'Alan Cox'
> Subject: [PATCH 1/1] aacraid: fib context lock for management ioctls
>
> Alan noticed the lack of locking surrounding the driver's
> dealings with the fib context managed by the trio of ioctls
> that are used by the RAID management applications to retrieve
> Adapter Initiated FIBs. I merely expanded the fib lock to
> include the fib context. There have been no field reports of
> any issues generally because the applications are relatively
> static and do not come and go often enough to stress this
> area. I bloated this patch a little with some space junk.
>
> This attached patch is against current scsi-misc-2.6.
>
> ObligatoryDisclaimer: Please accept my condolences regarding
> Outlook's handling of patch attachments. The following inline
> patch is 'diff -rub' to pull out the space junk to enable
> convenient inspection, please use the attached file to patch.
>
> Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
>
>  drivers/scsi/aacraid/commctrl.c |   29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
>
> diff -rub a/commctrl.c b/commctrl.c
> --- a/drivers/scsi/aacraid/commctrl.c        2008-01-24
> 09:44:33.080806785 -0500
> +++ b/drivers/scsi/aacraid/commctrl.c        2008-01-24
> 09:50:41.071552674 -0500
> @@ -243,6 +243,7 @@
>          *      Search the list of AdapterFibContext
> addresses on the adapter
>          *      to be sure this is a valid address
>          */
> +       spin_lock_irqsave(&dev->fib_lock, flags);
>         entry =3D dev->fib_list.next;
>         fibctx =3D NULL;
>
> @@ -258,17 +259,18 @@
>                 fibctx =3D NULL;
>         }
>         if (!fibctx) {
> +               spin_unlock_irqrestore(&dev->fib_lock, flags);
>                 dprintk ((KERN_INFO "Fib Context not found\n"));
>                 return -EINVAL;
>         }
>
>         if((fibctx->type !=3D FSAFS_NTC_GET_ADAPTER_FIB_CONTEXT) ||
>                  (fibctx->size !=3D sizeof(struct aac_fib_context))) {
> +               spin_unlock_irqrestore(&dev->fib_lock, flags);
>                 dprintk ((KERN_INFO "Fib Context corrupt?\n"));
>                 return -EINVAL;
>         }
>         status =3D 0;
> -       spin_lock_irqsave(&dev->fib_lock, flags);
>         /*
>          *      If there are no fibs to send back, then
> either wait or return
>          *      -EAGAIN

Here is the offending portion of the previous patch (two chunks):

> @@ -326,7 +328,9 @@
>  int aac_close_fib_context(struct aac_dev * dev, struct
> aac_fib_context * fibctx)
>  {
>         struct fib *fib;
> +       unsigned long flags;
>
> +       spin_lock_irqsave(&dev->fib_lock, flags);
>         /*
>          *      First free any FIBs that have not been consumed.
>          */
> @@ -349,6 +353,7 @@
>          *      Remove the Context from the AdapterFibContext List
>          */
>         list_del(&fibctx->next);
> +       spin_unlock_irqrestore(&dev->fib_lock, flags);
>         /*
>          *      Invalidate context
>          */
>
> Sincerely - Mark Salyzyn

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F4395CF508ADPE2K703adapte_
Content-Type: application/octet-stream; name="aacraid_fibctx_lock2.patch"
Content-Description: aacraid_fibctx_lock2.patch
Content-Disposition: attachment; filename="aacraid_fibctx_lock2.patch";
	size=3013; creation-date="Mon, 28 Jan 2008 12:15:00 GMT";
	modification-date="Mon, 28 Jan 2008 12:15:00 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21tY3RybC5jIGIvZHJpdmVycy9zY3Np
L2FhY3JhaWQvY29tbWN0cmwuYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21tY3RybC5j
CTIwMDgtMDEtMjggMTU6MDk6NDIuNTU2ODU1MzI1IC0wNTAwCisrKyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2NvbW1jdHJsLmMJMjAwOC0wMS0yOCAxNToxMDo1OS4xMTUwMDE4NjYgLTA1MDAKQEAg
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
LUVBR0FJTgpAQCAtNDE0LDggKzQxNiw4IEBACiAgKglAYXJnOiBpb2N0bCBhcmd1bWVudHMKICAq
CiAgKglUaGlzIHJvdXRpbmUgcmV0dXJucyB0aGUgZHJpdmVyIHZlcnNpb24uCi0gKiAgICAgIFVu
ZGVyIExpbnV4LCB0aGVyZSBoYXZlIGJlZW4gbm8gdmVyc2lvbiBpbmNvbXBhdGliaWxpdGllcywg
c28gdGhpcyBpcwotICogICAgICBzaW1wbGUhCisgKglVbmRlciBMaW51eCwgdGhlcmUgaGF2ZSBi
ZWVuIG5vIHZlcnNpb24gaW5jb21wYXRpYmlsaXRpZXMsIHNvIHRoaXMgaXMKKyAqCXNpbXBsZSEK
ICAqLwogCiBzdGF0aWMgaW50IGNoZWNrX3JldmlzaW9uKHN0cnVjdCBhYWNfZGV2ICpkZXYsIHZv
aWQgX191c2VyICphcmcpCkBAIC00NjMsNyArNDY1LDcgQEAKIAl1MzIgZGF0YV9kaXI7CiAJdm9p
ZCBfX3VzZXIgKnNnX3VzZXJbMzJdOwogCXZvaWQgKnNnX2xpc3RbMzJdOwotCXUzMiAgIHNnX2lu
ZHggPSAwOworCXUzMiBzZ19pbmR4ID0gMDsKIAl1MzIgYnl0ZV9jb3VudCA9IDA7CiAJdTMyIGFj
dHVhbF9maWJzaXplNjQsIGFjdHVhbF9maWJzaXplID0gMDsKIAlpbnQgaTsKQEAgLTUxNywxMSAr
NTE5LDExIEBACiAJLy8gRml4IHVwIHNyYiBmb3IgZW5kaWFuIGFuZCBmb3JjZSBzb21lIHZhbHVl
cwogCiAJc3JiY21kLT5mdW5jdGlvbiA9IGNwdV90b19sZTMyKFNSQkZfRXhlY3V0ZVNjc2kpOwkv
LyBGb3JjZSB0aGlzCi0Jc3JiY21kLT5jaGFubmVsICA9IGNwdV90b19sZTMyKHVzZXJfc3JiY21k
LT5jaGFubmVsKTsKKwlzcmJjbWQtPmNoYW5uZWwJID0gY3B1X3RvX2xlMzIodXNlcl9zcmJjbWQt
PmNoYW5uZWwpOwogCXNyYmNtZC0+aWQJID0gY3B1X3RvX2xlMzIodXNlcl9zcmJjbWQtPmlkKTsK
LQlzcmJjbWQtPmx1biAgICAgID0gY3B1X3RvX2xlMzIodXNlcl9zcmJjbWQtPmx1bik7Ci0Jc3Ji
Y21kLT50aW1lb3V0ICA9IGNwdV90b19sZTMyKHVzZXJfc3JiY21kLT50aW1lb3V0KTsKLQlzcmJj
bWQtPmZsYWdzICAgID0gY3B1X3RvX2xlMzIoZmxhZ3MpOworCXNyYmNtZC0+bHVuCSA9IGNwdV90
b19sZTMyKHVzZXJfc3JiY21kLT5sdW4pOworCXNyYmNtZC0+dGltZW91dAkgPSBjcHVfdG9fbGUz
Mih1c2VyX3NyYmNtZC0+dGltZW91dCk7CisJc3JiY21kLT5mbGFncwkgPSBjcHVfdG9fbGUzMihm
bGFncyk7CiAJc3JiY21kLT5yZXRyeV9saW1pdCA9IDA7IC8vIE9ic29sZXRlIHBhcmFtZXRlcgog
CXNyYmNtZC0+Y2RiX3NpemUgPSBjcHVfdG9fbGUzMih1c2VyX3NyYmNtZC0+Y2RiX3NpemUpOwog
CW1lbWNweShzcmJjbWQtPmNkYiwgdXNlcl9zcmJjbWQtPmNkYiwgc2l6ZW9mKHNyYmNtZC0+Y2Ri
KSk7CkBAIC03ODYsOSArNzg4LDkgQEAKIAlwY2lfaW5mby5idXMgPSBkZXYtPnBkZXYtPmJ1cy0+
bnVtYmVyOwogCXBjaV9pbmZvLnNsb3QgPSBQQ0lfU0xPVChkZXYtPnBkZXYtPmRldmZuKTsKIAot
ICAgICAgIGlmIChjb3B5X3RvX3VzZXIoYXJnLCAmcGNpX2luZm8sIHNpemVvZihzdHJ1Y3QgYWFj
X3BjaV9pbmZvKSkpIHsKLQkgICAgICAgZHByaW50aygoS0VSTl9ERUJVRyAiYWFjcmFpZDogQ291
bGQgbm90IGNvcHkgcGNpIGluZm9cbiIpKTsKLQkgICAgICAgcmV0dXJuIC1FRkFVTFQ7CisJaWYg
KGNvcHlfdG9fdXNlcihhcmcsICZwY2lfaW5mbywgc2l6ZW9mKHN0cnVjdCBhYWNfcGNpX2luZm8p
KSkgeworCQlkcHJpbnRrKChLRVJOX0RFQlVHICJhYWNyYWlkOiBDb3VsZCBub3QgY29weSBwY2kg
aW5mb1xuIikpOworCQlyZXR1cm4gLUVGQVVMVDsKIAl9CiAJcmV0dXJuIDA7CiB9Cg==

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F4395CF508ADPE2K703adapte_--
