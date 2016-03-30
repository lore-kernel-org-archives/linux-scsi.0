From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: Patch: Make the iscsi lld create a WQ_HIGHPRI workqueue itself
Date: Wed, 30 Mar 2016 09:04:40 -0700
Message-ID: <CACyXjPzkQowe3Fu3S63kBrNuf3J5ewX67+uVXY5KRj_RapK5Kw@mail.gmail.com>
References: <CACyXjPxwz4znmt7g9ptYdpzkfF1Ok7KKJa2ceyKxg00buSfmcA@mail.gmail.com>
	<56F9C3ED.8080704@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11423c2ca93d93052f464dd8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:33034 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbcC3QEm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Mar 2016 12:04:42 -0400
Received: by mail-yw0-f173.google.com with SMTP id h65so64110448ywe.0
        for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2016 09:04:41 -0700 (PDT)
In-Reply-To: <56F9C3ED.8080704@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

--001a11423c2ca93d93052f464dd8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 28, 2016 at 4:53 PM, Mike Christie <mchristi@redhat.com> wrote:
> On 03/28/2016 03:46 PM, Richard Sharpe wrote:
>> Hi folks,
>>
>> We noticed recently while testing with large numbers of iSCSI
>> connections that iscsid was going to heroic lengths to change the nice
>> value of the iSCSI work queue to -20. It becomes very expensive with
>> hundreds of connections.
>>
>> This small patch has the LLD do the work,
>>
>> Feedback welcome.

[...]

>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index 6bffd91..abaefe1 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -2615,9 +2615,11 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_ho=
st_template *sht,
>>       ihost =3D shost_priv(shost);
>>
>>       if (xmit_can_sleep) {
>> +             int wq_flags =3D __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_HIGHPRI=
;
>
>
> I do not think we need to or are supposed to be setting __WQ_LEGACY. It
> looks like it was only to catch the case here

Attached is a patch the removes that flag and also WQ_MEM_RECLAIM
because none of the work items placed on the queue do allocations with
GPF_KERNEL, as far as I can tell.

--=20
Regards,
Richard Sharpe
(=E4=BD=95=E4=BB=A5=E8=A7=A3=E6=86=82=EF=BC=9F=E5=94=AF=E6=9C=89=E6=9D=9C=
=E5=BA=B7=E3=80=82--=E6=9B=B9=E6=93=8D)

--001a11423c2ca93d93052f464dd8
Content-Type: application/octet-stream;
	name="0001-Make-the-iscsi-lld-create-a-WQ_HIGHPRI-workqueue.patch"
Content-Disposition: attachment;
	filename="0001-Make-the-iscsi-lld-create-a-WQ_HIGHPRI-workqueue.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_imf1m5l00

RnJvbSBkZmFiOThkZTZjMGJkODQ2ODRlZmE0NjkyZjU3M2Q0NmY4YjNkNzk4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSaWNoYXJkIFNoYXJwZSA8cnNoYXJwZUBudXRhbml4LmNvbT4K
RGF0ZTogTW9uLCAyOCBNYXIgMjAxNiAxMzozNjoxOCAtMDcwMApTdWJqZWN0OiBbUEFUQ0hdIE1h
a2UgdGhlIGlzY3NpIGxsZCBjcmVhdGUgYSBXUV9ISUdIUFJJIHdvcmtxdWV1ZS4KClRoZSBvcGVu
LWlzY3NpIHRvb2xzIGdvIHRvIGhlcm9pYyBlZmZvcnRzIHRvIGNoYW5nZSB0aGUgbmljZSB2YWx1
ZSBvZgp0aGUgaXNjc2kgd29ya3F1ZXVlIHRvIC0yMC4gSXQgc2NhbnMgYWxsIHByb2Nlc3NlcyBp
biAvcHJvYyBhbmQKd2hlbiBpdCBmaW5kcyB0aGUgb25lIGl0IGlzIGludGVyZXN0ZWQgaW4gY2Fs
bHMgc2V0cHJpb3JpdHkuCgpXaGVuIHlvdSBhcmUgY29ubmVjdGluZyB0byBhIHJlYXNvbmFibGUg
bnVtYmVyIG9mIGlTQ1NJIHRhcmdldHMgdGhpcwpjYW4gYmUgY29zdGx5LgoKVGhpcyBzbWFsbCBw
YXRjaCBoYXMgdGhlIGlzY3NpIExMRCBkbyB0aGUgd29yayBpdHNlbGYuIEl0IHNlZW1zIGxpa2UK
dGhlIGxlYXN0IGludHJ1c2l2ZSB3YXkgdG8gYWNoZWl2ZSB0aGUgcmVzdWx0LgoKQWxzbyByZW1v
dmVkIHRoZSBXUV9NRU1fUkVDTEFJTSBmbGFnIGFzIGxpYmlzY3NpIGRvZXMgbm90IGRvIGFueQpt
ZW1vcnkgYWxsb2NzIGludm9sdmluZyBHUEZfS0VSTkVMIGluIGl0cyB3b3JrcXVldWVzLgoKQSBz
bWFsbCBwYXRjaCB3aWxsIGJlIG5lZWRlZCBpbiB0aGUgb3Blbi1pc2NzaSB1c2Vyc3BhY2UgdG9v
bHMKYXMgd2VsbC4KClNpZ25lZC1vZmYtYnk6IFJpY2hhcmQgU2hhcnBlIDxyZWFscmljaGFyZHNo
YXJwZUBnbWFpbC5jb20+Ci0tLQogZHJpdmVycy9zY3NpL2xpYmlzY3NpLmMgfCAgICA2ICsrKysr
LQogMSBmaWxlcyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zY3NpL2xpYmlzY3NpLmMgYi9kcml2ZXJzL3Njc2kvbGliaXNjc2ku
YwppbmRleCA2YmZmZDkxLi4yYzg2NGQwIDEwMDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvbGliaXNj
c2kuYworKysgYi9kcml2ZXJzL3Njc2kvbGliaXNjc2kuYwpAQCAtMjYwMiw2ICsyNjAyLDkgQEAg
RVhQT1JUX1NZTUJPTF9HUEwoaXNjc2lfaG9zdF9hZGQpOwogICoKICAqIFRoaXMgc2hvdWxkIGJl
IGNhbGxlZCBieSBwYXJ0aWFsIG9mZmxvYWQgYW5kIHNvZnR3YXJlIGlzY3NpIGRyaXZlcnMuCiAg
KiBUbyBhY2Nlc3MgdGhlIGRyaXZlciBzcGVjaWZpYyBtZW1vcnkgdXNlIHRoZSBpc2NzaV9ob3N0
X3ByaXYoKSBtYWNyby4KKyAqCisgKiBOb3RlIHRoYXQgd2UgYXJlIGNyZWF0aW5nIGFuIG9yZGVy
ZWQgd29ya3F1ZXVlLiBZb3UgbXVzdCBub3QgcGxhY2Ugd29yaworICogb24gaXQgdGhhdCBhbGxv
Y2F0ZXMgbWVtb3J5IHdpdGggR1BGX0tFUk5FTC4KICAqLwogc3RydWN0IFNjc2lfSG9zdCAqaXNj
c2lfaG9zdF9hbGxvYyhzdHJ1Y3Qgc2NzaV9ob3N0X3RlbXBsYXRlICpzaHQsCiAJCQkJICAgaW50
IGRkX2RhdGFfc2l6ZSwgYm9vbCB4bWl0X2Nhbl9zbGVlcCkKQEAgLTI2MTcsNyArMjYyMCw4IEBA
IHN0cnVjdCBTY3NpX0hvc3QgKmlzY3NpX2hvc3RfYWxsb2Moc3RydWN0IHNjc2lfaG9zdF90ZW1w
bGF0ZSAqc2h0LAogCWlmICh4bWl0X2Nhbl9zbGVlcCkgewogCQlzbnByaW50ZihpaG9zdC0+d29y
a3FfbmFtZSwgc2l6ZW9mKGlob3N0LT53b3JrcV9uYW1lKSwKIAkJCSJpc2NzaV9xXyVkIiwgc2hv
c3QtPmhvc3Rfbm8pOwotCQlpaG9zdC0+d29ya3EgPSBjcmVhdGVfc2luZ2xldGhyZWFkX3dvcmtx
dWV1ZShpaG9zdC0+d29ya3FfbmFtZSk7CisJCWlob3N0LT53b3JrcSA9IGFsbG9jX29yZGVyZWRf
d29ya3F1ZXVlKCIlcyIsIFdRX0hJR0hQUkksCisJCQkJCQlpaG9zdC0+d29ya3FfbmFtZSk7CiAJ
CWlmICghaWhvc3QtPndvcmtxKQogCQkJZ290byBmcmVlX2hvc3Q7CiAJfQotLSAKMS43LjEKCg==
--001a11423c2ca93d93052f464dd8--
