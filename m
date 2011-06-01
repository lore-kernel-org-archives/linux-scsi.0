From: <Jayamohan.Kallickal@Emulex.Com>
Subject: RE: [PATCH]: be2iscsi: Fix MSIX interrupt names
Date: Wed, 1 Jun 2011 11:55:52 -0700
Message-ID: <50725EF61B96174EB1803401F1A2E3733508E57DFE@EXMAIL.ad.emulex.com>
References: <4DD6AEB7.2090900@redhat.com> <4DD6AF29.8090903@redhat.com>
 <50725EF61B96174EB1803401F1A2E37335099FC989@EXMAIL.ad.emulex.com>,<4DD6B83B.5000703@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_50725EF61B96174EB1803401F1A2E3733508E57DFEEXMAILademule_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht2.emulex.com ([138.239.113.184]:52662 "EHLO
	exht2.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753444Ab1FAS43 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2011 14:56:29 -0400
In-Reply-To: <4DD6B83B.5000703@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: prarit@redhat.com
Cc: linux-scsi@vger.kernel.org, mchristi@redhat.com

--_002_50725EF61B96174EB1803401F1A2E3733508E57DFEEXMAILademule_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I have taken the original patch from Prarit and made changes to move the al=
location=20
inside the main for loop along with request_irq.

I feel doing devres would be good but going to take some time. However, we =
need to fix this now and hence
am submitting this patch. When we have a final devres solution working and =
tested ,we would move over.

Thanks
Jay
________________________________________
From: Prarit Bhargava [prarit@redhat.com]
Sent: Friday, May 20, 2011 11:51 AM
To: Kallickal, Jayamohan
Cc: linux-scsi@vger.kernel.org; mchristi@redhat.com
Subject: Re: [PATCH]: be2iscsi: Fix MSIX interrupt names

On 05/20/2011 02:33 PM, Jayamohan.Kallickal@Emulex.Com wrote:
> Thanks for the patch. Pl see my comments in line
>
>

np.

> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_m=
ain.c
> index 24e20ba..8d71e47 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -874,16 +874,20 @@ static int beiscsi_init_irqs(struct beiscsi_hba *ph=
ba)
>       struct hwi_controller *phwi_ctrlr;
>       struct hwi_context_memory *phwi_context;
>       int ret, msix_vec, i, j;
> -     char desc[32];
>
>       phwi_ctrlr =3D phba->phwi_ctrlr;
>       phwi_context =3D phwi_ctrlr->phwi_ctxt;
>
>       if (phba->msix_enabled) {
>               for (i =3D 0; i < phba->num_cpus; i++) {
> -                     sprintf(desc, "beiscsi_msix_%04x", i);
> +                     phba->msi_name[i] =3D kzalloc(BEISCSI_MSI_NAME,
> +                                                 GFP_KERNEL);
> +                     if (!phba->msi_name[i])
> +                             goto free_msix_irqs;
> We need to ensure i !=3D 0 before jumping to free_msix_irqs
>

Will fix in next version ... I think I may have to do a bit more work
here because I just realized that if we free_irq() on a non-allocated
irq we'll get an angry message from the kernel ;)  Unfortunately this
may complicate the code.... I'll rework this and see if I can come up
with something better.

> +                     sprintf(phba->msi_name[i], "beiscsi_msix_%04x", i);
>                       msix_vec =3D phba->msix_entries[i].vector;
> -                     ret =3D request_irq(msix_vec, be_isr_msix, 0, desc,
> +                     ret =3D request_irq(msix_vec, be_isr_msix, 0,
> +                                       phba->msi_name[i],
>                                         &phwi_context->be_eq[i]);
>                       if (ret) {
>                               shost_printk(KERN_ERR, phba->shost,
> @@ -915,8 +919,10 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phb=
a)
>       }
>       return 0;
>  free_msix_irqs:
> -     for (j =3D i - 1; j =3D=3D 0; j++)
> +     for (j =3D i - 1; j =3D=3D 0; j++) {
>               free_irq(msix_vec, &phwi_context->be_eq[j]);
> +             kfree(phba->msi_name[i]);
> +     }
>

... I was looking at this, and I'm confused by it.

Should this really be 'j++'?  Or should it be j-- ?

It seems to make sense that this code is j-- ...


>       return ret;
>  }
>
> @@ -4117,10 +4123,13 @@ static void beiscsi_remove(struct pci_dev *pcidev=
)
>               for (i =3D 0; i <=3D phba->num_cpus; i++) {
>                       msix_vec =3D phba->msix_entries[i].vector;
>                       free_irq(msix_vec, &phwi_context->be_eq[i]);
> +                     kfree(phba->msi_name[i]);
>               }
>       } else
> -             if (phba->pcidev->irq)
> +             if (phba->pcidev->irq) {
>                       free_irq(phba->pcidev->irq, phba);
> +                     kfree(phba->msi_name[i]);
> Do we need the free for non-msix case as we are not allocation?
>

Fixed in next version.

<snip>

P.

--_002_50725EF61B96174EB1803401F1A2E3733508E57DFEEXMAILademule_
Content-Type: application/octet-stream;
	name="0001-be2iscsi-Fixing-the-proc-interrupts-problem.patch"
Content-Description: 0001-be2iscsi-Fixing-the-proc-interrupts-problem.patch
Content-Disposition: attachment;
	filename="0001-be2iscsi-Fixing-the-proc-interrupts-problem.patch"; size=3765;
	creation-date="Wed, 01 Jun 2011 18:55:45 GMT";
	modification-date="Wed, 01 Jun 2011 18:55:45 GMT"
Content-Transfer-Encoding: base64

RnJvbSBkYTM5ZWEzYjY2NjUwMDg5NjEyMWRlNTc1YzY2Y2U5YzIzNmZmM2ExIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYXlhbW9oYW4gS2FsbGlja2FsIDxqYXlhbW9oYW4ua2FsbGlj
a2FsQGVtdWxleC5jb20+CkRhdGU6IFdlZCwgMSBKdW4gMjAxMSAxMDo1MzozMSAtMDcwMApTdWJq
ZWN0OiBbUEFUQ0ggMS8xXSBiZTJpc2NzaTogRml4aW5nIHRoZSAvcHJvYy9pbnRlcnJ1cHRzIHBy
b2JsZW0KCiAgIFRoaXMgcGF0Y2ggaXMgYmFzZWQgb24gb25lIGJ5IFByYXJpdCBCaGFyZ2F2YS4g
SSBoYXZlIG1hZGUgbWlub3IKY2hhbmdlcy4KClNpZ25lZC1vZmYtYnk6IFByYXJpdCBCaGFyZ2F2
YSA8cHJhcml0QHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IEpheWFtb2hhbiBLYWxsaWNrYWwg
PGpheWFtb2hhbixrYWxsaWNrYWxAZW11bGV4LmNvbT4KLS0tCiBkcml2ZXJzL3Njc2kvYmUyaXNj
c2kvYmVfbWFpbi5jIHwgICAzNSArKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLQog
ZHJpdmVycy9zY3NpL2JlMmlzY3NpL2JlX21haW4uaCB8ICAgIDMgKysrCiAyIGZpbGVzIGNoYW5n
ZWQsIDMxIGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zY3NpL2JlMmlzY3NpL2JlX21haW4uYyBiL2RyaXZlcnMvc2NzaS9iZTJpc2NzaS9iZV9tYWlu
LmMKaW5kZXggOTRiOWEwNy4uODYxODkyNSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL2JlMmlz
Y3NpL2JlX21haW4uYworKysgYi9kcml2ZXJzL3Njc2kvYmUyaXNjc2kvYmVfbWFpbi5jCkBAIC04
NzUsMzMgKzg3NSw1MSBAQCBzdGF0aWMgaW50IGJlaXNjc2lfaW5pdF9pcnFzKHN0cnVjdCBiZWlz
Y3NpX2hiYSAqcGhiYSkKIAlzdHJ1Y3QgaHdpX2NvbnRyb2xsZXIgKnBod2lfY3RybHI7CiAJc3Ry
dWN0IGh3aV9jb250ZXh0X21lbW9yeSAqcGh3aV9jb250ZXh0OwogCWludCByZXQsIG1zaXhfdmVj
LCBpLCBqOwotCWNoYXIgZGVzY1szMl07CiAKIAlwaHdpX2N0cmxyID0gcGhiYS0+cGh3aV9jdHJs
cjsKIAlwaHdpX2NvbnRleHQgPSBwaHdpX2N0cmxyLT5waHdpX2N0eHQ7CiAKIAlpZiAocGhiYS0+
bXNpeF9lbmFibGVkKSB7CiAJCWZvciAoaSA9IDA7IGkgPCBwaGJhLT5udW1fY3B1czsgaSsrKSB7
Ci0JCQlzcHJpbnRmKGRlc2MsICJiZWlzY3NpX21zaXhfJTA0eCIsIGkpOworCQkJcGhiYS0+bXNp
X25hbWVbaV0gPSBremFsbG9jKEJFSVNDU0lfTVNJX05BTUUsIEdGUF9LRVJORUwpOworCQkJaWYg
KCFwaGJhLT5tc2lfbmFtZVtpXSkgeworCQkJCXJldCA9IC1FTk9NRU07CisJCQkJaWYgKCFpKQor
CQkJCQlyZXR1cm4gcmV0OworCQkJCWdvdG8gZnJlZV9tc2l4X2lycXM7CisJCQl9CisKKwkJCXNw
cmludGYocGhiYS0+bXNpX25hbWVbaV0sICJiZWlzY3NpXyUwMnhfJTAyeCIsCisJCQkJcGhiYS0+
c2hvc3QtPmhvc3Rfbm8sIGkpOwogCQkJbXNpeF92ZWMgPSBwaGJhLT5tc2l4X2VudHJpZXNbaV0u
dmVjdG9yOwotCQkJcmV0ID0gcmVxdWVzdF9pcnEobXNpeF92ZWMsIGJlX2lzcl9tc2l4LCAwLCBk
ZXNjLAorCQkJcmV0ID0gcmVxdWVzdF9pcnEobXNpeF92ZWMsIGJlX2lzcl9tc2l4LCAwLAorCQkJ
CQkgIHBoYmEtPm1zaV9uYW1lW2ldLAogCQkJCQkgICZwaHdpX2NvbnRleHQtPmJlX2VxW2ldKTsK
IAkJCWlmIChyZXQpIHsKIAkJCQlzaG9zdF9wcmludGsoS0VSTl9FUlIsIHBoYmEtPnNob3N0LAog
CQkJCQkgICAgICJiZWlzY3NpX2luaXRfaXJxcy1GYWlsZWQgdG8iCiAJCQkJCSAgICAgInJlZ2lz
dGVyIG1zaXggZm9yIGkgPSAlZFxuIiwgaSk7Ci0JCQkJaWYgKCFpKQorCQkJCWtmcmVlKHBoYmEt
Pm1zaV9uYW1lW2ldKTsKKwkJCQlpZiAoIWkpIHsKIAkJCQkJcmV0dXJuIHJldDsKKwkJCQl9CiAJ
CQkJZ290byBmcmVlX21zaXhfaXJxczsKIAkJCX0KIAkJfQogCQltc2l4X3ZlYyA9IHBoYmEtPm1z
aXhfZW50cmllc1tpXS52ZWN0b3I7Ci0JCXJldCA9IHJlcXVlc3RfaXJxKG1zaXhfdmVjLCBiZV9p
c3JfbWNjLCAwLCAiYmVpc2NzaV9tc2l4X21jYyIsCisJCXBoYmEtPm1zaV9uYW1lW2ldID0ga3ph
bGxvYyhCRUlTQ1NJX01TSV9OQU1FLCBHRlBfS0VSTkVMKTsKKwkJaWYgKCFwaGJhLT5tc2lfbmFt
ZVtpXSkgeworCQkJcmV0ID0gLUVOT01FTTsKKwkJCWdvdG8gZnJlZV9tc2l4X2lycXM7CisJCX0K
KwkJc3ByaW50ZihwaGJhLT5tc2lfbmFtZVtpXSwgImJlaXNjc2lfbWNjXyUwMngiLAorCQkJcGhi
YS0+c2hvc3QtPmhvc3Rfbm8pOworCQlyZXQgPSByZXF1ZXN0X2lycShtc2l4X3ZlYywgYmVfaXNy
X21jYywgMCwgcGhiYS0+bXNpX25hbWVbaV0sCiAJCQkJICAmcGh3aV9jb250ZXh0LT5iZV9lcVtp
XSk7CiAJCWlmIChyZXQpIHsKIAkJCXNob3N0X3ByaW50ayhLRVJOX0VSUiwgcGhiYS0+c2hvc3Qs
ICJiZWlzY3NpX2luaXRfaXJxcy0iCiAJCQkJICAgICAiRmFpbGVkIHRvIHJlZ2lzdGVyIGJlaXNj
c2lfbXNpeF9tY2NcbiIpOwotCQkJaSsrOworCQkJa2ZyZWUocGhiYS0+bXNpX25hbWVbaV0pOwog
CQkJZ290byBmcmVlX21zaXhfaXJxczsKIAkJfQogCkBAIC05MTYsOCArOTM0LDEwIEBAIHN0YXRp
YyBpbnQgYmVpc2NzaV9pbml0X2lycXMoc3RydWN0IGJlaXNjc2lfaGJhICpwaGJhKQogCX0KIAly
ZXR1cm4gMDsKIGZyZWVfbXNpeF9pcnFzOgotCWZvciAoaiA9IGkgLSAxOyBqID09IDA7IGorKykK
Kwlmb3IgKGogPSBpIC0gMTsgaiA+PSAwOyBqLS0pIHsKKwkJa2ZyZWUocGhiYS0+bXNpX25hbWVb
al0pOwogCQlmcmVlX2lycShtc2l4X3ZlYywgJnBod2lfY29udGV4dC0+YmVfZXFbal0pOworCX0K
IAlyZXR1cm4gcmV0OwogfQogCkBAIC00MTIzLDYgKzQxNDMsNyBAQCBzdGF0aWMgdm9pZCBiZWlz
Y3NpX3JlbW92ZShzdHJ1Y3QgcGNpX2RldiAqcGNpZGV2KQogCQlmb3IgKGkgPSAwOyBpIDw9IHBo
YmEtPm51bV9jcHVzOyBpKyspIHsKIAkJCW1zaXhfdmVjID0gcGhiYS0+bXNpeF9lbnRyaWVzW2ld
LnZlY3RvcjsKIAkJCWZyZWVfaXJxKG1zaXhfdmVjLCAmcGh3aV9jb250ZXh0LT5iZV9lcVtpXSk7
CisJCQlrZnJlZShwaGJhLT5tc2lfbmFtZVtpXSk7CiAJCX0KIAl9IGVsc2UKIAkJaWYgKHBoYmEt
PnBjaWRldi0+aXJxKQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL2JlMmlzY3NpL2JlX21haW4u
aCBiL2RyaXZlcnMvc2NzaS9iZTJpc2NzaS9iZV9tYWluLmgKaW5kZXggMDgxYzE3MS4uMWE1NWFl
ZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL2JlMmlzY3NpL2JlX21haW4uaAorKysgYi9kcml2
ZXJzL3Njc2kvYmUyaXNjc2kvYmVfbWFpbi5oCkBAIC0xNjIsNiArMTYyLDggQEAgZG8gewkJCQkJ
CQlcCiAjZGVmaW5lIFBBR0VTX1JFUVVJUkVEKHgpIFwKIAkoKHggPCBQQUdFX1NJWkUpID8gMSA6
ICAoKHggKyBQQUdFX1NJWkUgLSAxKSAvIFBBR0VfU0laRSkpCiAKKyNkZWZpbmUgQkVJU0NTSV9N
U0lfTkFNRSAyMCAvKiBzaXplIG9mIG1zaV9uYW1lIHN0cmluZyAqLworCiBlbnVtIGJlX21lbV9l
bnVtIHsKIAlIV0lfTUVNX0FERE5fQ09OVEVYVCwKIAlIV0lfTUVNX1dSQiwKQEAgLTI4Nyw2ICsy
ODksNyBAQCBzdHJ1Y3QgYmVpc2NzaV9oYmEgewogCXVuc2lnbmVkIGludCBudW1fY3B1czsKIAl1
bnNpZ25lZCBpbnQgbnh0X2NxaWQ7CiAJc3RydWN0IG1zaXhfZW50cnkgbXNpeF9lbnRyaWVzW01B
WF9DUFVTICsgMV07CisJY2hhciAqbXNpX25hbWVbTUFYX0NQVVMgKyAxXTsKIAlib29sIG1zaXhf
ZW5hYmxlZDsKIAlzdHJ1Y3QgYmVfbWVtX2Rlc2NyaXB0b3IgKmluaXRfbWVtOwogCi0tIAoxLjcu
MQoK

--_002_50725EF61B96174EB1803401F1A2E3733508E57DFEEXMAILademule_--
