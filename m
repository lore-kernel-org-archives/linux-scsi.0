From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] aacraid: [Fastboot] Panics for AACRAID driver during 'insmod' for kexec test.
Date: Fri, 30 Mar 2007 10:30:48 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF017A9E55@otce2k301.adaptec.com>
References: <20070330060545.GA16248@in.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C772D8.02B9BFC8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:33796 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbXC3Oau (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Mar 2007 10:30:50 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070330060545.GA16248@in.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vgoyal@in.ibm.com
Cc: Judith Lebzelter <judith@linux-foundation.org>, linux-scsi@vger.kernel.org, fastboot@lists.osdl.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C772D8.02B9BFC8
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Thanks for the info.

Attached is the patch I feel will address this issue. As an added 'perk' =
I have also added the code to detect if the controller was previously =
initialized for interrupted operations by ANY operating system should =
the reset_devices kernel parameter not be set and we are dealing with a =
na=EFve kexec without the addition of this kernel parameter. The reset =
handler is also improved. Related to reset operations, but not pertinent =
specifically to this issue, I have also altered the handling somewhat so =
that we reset the adapter if we feel it is taking too long (three =
minutes) to start up.

We have not unit tested the reset_devices flag propagation to this =
driver code, nor have we unit tested the check for the interrupted =
operations under the conditions of a naively issued kexec. We are =
submitting this modified driver to our Q/A department for integration =
testing in our current programs. I would appreciate an ACK to this patch =
should it resolve the issue described in this thread...

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's =
handling of patches.

This attached patch is against current scsi-misc-2.6
=20
Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

---

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Vivek Goyal [mailto:vgoyal@in.ibm.com]=20
> Sent: Friday, March 30, 2007 2:06 AM
> To: Salyzyn, Mark
> Cc: Judith Lebzelter; linux-scsi@vger.kernel.org; AACRAID;=20
> fastboot@lists.osdl.org
> Subject: Re: [Fastboot] Panics for AACRAID driver during=20
> 'insmod' for kexec test.
>=20
>=20
> On Thu, Mar 29, 2007 at 10:17:18AM -0400, Salyzyn, Mark wrote:
> > I have been working on a patch to the driver to do just=20
> this, reset the
> > adapter during init if necessary. We want to limit the=20
> adapter's reset
> > as it takes time (an additional 45 seconds or longer) for=20
> the Firmware
> > to cycle... I will bump the priority of the testing for this patch.
> >=20
> Hi,
>=20
> Thanks for looking into this. You can make device reset=20
> conditional. Now
> one command line parameter "reset_devices" has been defined=20
> for the kernel.
> You can reset the device only if the user has passed=20
> reset_devices command
> line option otherwise you can continue to boot normaly.
>=20
> I have introduced this parameter to handle the concern that in normal
> BIOS boot total boot time will increase.
>=20
> kexec/kdump will pass this parameter to second kernel so that=20
> device will
> be reset during initialization and normal BIOS boot will=20
> reamin unaffected.
>=20
> Thanks
> Vivek
>=20

------_=_NextPart_001_01C772D8.02B9BFC8
Content-Type: application/octet-stream;
	name="aacraid_kexec.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_kexec.patch
Content-Disposition: attachment;
	filename="aacraid_kexec.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9yeC5jIGIvZHJpdmVycy9zY3NpL2FhY3Jh
aWQvcnguYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9yeC5jCTIwMDctMDMtMzAgMTA6MTA6
MzAuNzU3Mzk0NjE5IC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL3J4LmMJMjAwNy0w
My0zMCAxMDoxMDozNS44MTE3NTc1MjggLTA0MDAKQEAgLTI5NCw3ICsyOTQsNyBAQAogICoJU3Rh
cnQgdXAgcHJvY2Vzc2luZyBvbiBhbiBpOTYwIGJhc2VkIEFBQyBhZGFwdGVyCiAgKi8KIAotdm9p
ZCBhYWNfcnhfc3RhcnRfYWRhcHRlcihzdHJ1Y3QgYWFjX2RldiAqZGV2KQorc3RhdGljIHZvaWQg
YWFjX3J4X3N0YXJ0X2FkYXB0ZXIoc3RydWN0IGFhY19kZXYgKmRldikKIHsKIAlzdHJ1Y3QgYWFj
X2luaXQgKmluaXQ7CiAKQEAgLTQ2NywxNiArNDY3LDE5IEBACiAJaWYgKGJsZWQpCiAJCXByaW50
ayhLRVJOX0VSUiAiJXMlZDogYWRhcHRlciBrZXJuZWwgcGFuaWMnZCAleC5cbiIsCiAJCQlkZXYt
Pm5hbWUsIGRldi0+aWQsIGJsZWQpOwotCWVsc2UKKwllbHNlIHsKIAkJYmxlZCA9IGFhY19hZGFw
dGVyX3N5bmNfY21kKGRldiwgSU9QX1JFU0VUX0FMV0FZUywKIAkJICAwLCAwLCAwLCAwLCAwLCAw
LCAmdmFyLCBOVUxMLCBOVUxMLCBOVUxMLCBOVUxMKTsKLQlpZiAoYmxlZCkKKwkJaWYgKCFibGVk
ICYmICh2YXIgIT0gMHgwMDAwMDAwMSkpCisJCQlibGVkID0gLUVJTlZBTDsKKwl9CisJaWYgKGJs
ZWQgJiYgKGJsZWQgIT0gLUVUSU1FRE9VVCkpCiAJCWJsZWQgPSBhYWNfYWRhcHRlcl9zeW5jX2Nt
ZChkZXYsIElPUF9SRVNFVCwKIAkJICAwLCAwLCAwLCAwLCAwLCAwLCAmdmFyLCBOVUxMLCBOVUxM
LCBOVUxMLCBOVUxMKTsKLQlpZiAoYmxlZCkKKwlpZiAoYmxlZCAmJiAoYmxlZCAhPSAtRVRJTUVE
T1VUKSkKIAkJcmV0dXJuIC1FSU5WQUw7Ci0JaWYgKHZhciA9PSAweDM4MDMwMDBGKSB7IC8qIFVT
RV9PVEhFUl9NRVRIT0QgKi8KKwlpZiAoYmxlZCB8fCAodmFyID09IDB4MzgwMzAwMEYpKSB7IC8q
IFVTRV9PVEhFUl9NRVRIT0QgKi8KIAkJcnhfd3JpdGVsKGRldiwgTVVuaXQucmVzZXJ2ZWQyLCAz
KTsKIAkJbXNsZWVwKDUwMDApOyAvKiBEZWxheSA1IHNlY29uZHMgKi8KIAkJdmFyID0gMHgwMDAw
MDAwMTsKQEAgLTUyNiw2ICs1MjksNyBAQAogewogCXVuc2lnbmVkIGxvbmcgc3RhcnQ7CiAJdW5z
aWduZWQgbG9uZyBzdGF0dXM7CisJaW50IHJlc3RhcnQgPSAwOwogCWludCBpbnN0YW5jZSA9IGRl
di0+aWQ7CiAJY29uc3QgY2hhciAqIG5hbWUgPSBkZXYtPm5hbWU7CiAKQEAgLTUzNCwxNSArNTM4
LDE5IEBACiAJCWdvdG8gZXJyb3JfaW91bm1hcDsKIAl9CiAKKwkvKiBGYWlsdXJlIHRvIHJlc2V0
IGhlcmUgaXMgYW4gb3B0aW9uIC4uLiAqLworCWRldi0+T0lNUiA9IHN0YXR1cyA9IHJ4X3JlYWRi
IChkZXYsIE1Vbml0Lk9JTVIpOworCWlmICgoKChzdGF0dXMgJiAweGZmKSAhPSAweGZmKSB8fCBy
ZXNldF9kZXZpY2VzKSAmJgorCSAgIWFhY19yeF9yZXN0YXJ0X2FkYXB0ZXIoZGV2LCAwKSkKKwkJ
KytyZXN0YXJ0OwogCS8qCiAJICoJQ2hlY2sgdG8gc2VlIGlmIHRoZSBib2FyZCBwYW5pYydkIHdo
aWxlIGJvb3RpbmcuCiAJICovCiAJc3RhdHVzID0gcnhfcmVhZGwoZGV2LCBNVW5pdC5PTVJ4WzBd
KTsKIAlpZiAoc3RhdHVzICYgS0VSTkVMX1BBTklDKSB7Ci0JCWlmICgoc3RhdHVzID0gYWFjX3J4
X2NoZWNrX2hlYWx0aChkZXYpKSA8PSAwKQotCQkJZ290byBlcnJvcl9pb3VubWFwOwotCQlpZiAo
YWFjX3J4X3Jlc3RhcnRfYWRhcHRlcihkZXYsIHN0YXR1cykpCisJCWlmIChhYWNfcnhfcmVzdGFy
dF9hZGFwdGVyKGRldiwgYWFjX3J4X2NoZWNrX2hlYWx0aChkZXYpKSkKIAkJCWdvdG8gZXJyb3Jf
aW91bm1hcDsKKwkJKytyZXN0YXJ0OwogCX0KIAkvKgogCSAqCUNoZWNrIHRvIHNlZSBpZiB0aGUg
Ym9hcmQgZmFpbGVkIGFueSBzZWxmIHRlc3RzLgpAQCAtNTY1LDExICs1NzMsMjMgQEAKIAkgKi8K
IAl3aGlsZSAoISgoc3RhdHVzID0gcnhfcmVhZGwoZGV2LCBNVW5pdC5PTVJ4WzBdKSkgJiBLRVJO
RUxfVVBfQU5EX1JVTk5JTkcpKQogCXsKLQkJaWYodGltZV9hZnRlcihqaWZmaWVzLCBzdGFydCtz
dGFydHVwX3RpbWVvdXQqSFopKSB7CisJCWlmICgocmVzdGFydCAmJgorCQkgIChzdGF0dXMgJiAo
S0VSTkVMX1BBTklDfFNFTEZfVEVTVF9GQUlMRUR8TU9OSVRPUl9QQU5JQykpKSB8fAorCQkgIHRp
bWVfYWZ0ZXIoamlmZmllcywgc3RhcnQrSFoqc3RhcnR1cF90aW1lb3V0KSkgewogCQkJcHJpbnRr
KEtFUk5fRVJSICIlcyVkOiBhZGFwdGVyIGtlcm5lbCBmYWlsZWQgdG8gc3RhcnQsIGluaXQgc3Rh
dHVzID0gJWx4LlxuIiwgCiAJCQkJCWRldi0+bmFtZSwgaW5zdGFuY2UsIHN0YXR1cyk7CiAJCQln
b3RvIGVycm9yX2lvdW5tYXA7CiAJCX0KKwkJaWYgKCFyZXN0YXJ0ICYmCisJCSAgKChzdGF0dXMg
JiAoS0VSTkVMX1BBTklDfFNFTEZfVEVTVF9GQUlMRUR8TU9OSVRPUl9QQU5JQykpIHx8CisJCSAg
dGltZV9hZnRlcihqaWZmaWVzLCBzdGFydCArIEhaICoKKwkJICAoKHN0YXJ0dXBfdGltZW91dCA+
IDYwKQorCQkgICAgPyAoc3RhcnR1cF90aW1lb3V0IC0gNjApCisJCSAgICA6IChzdGFydHVwX3Rp
bWVvdXQgLyAyKSkpKSkgeworCQkJaWYgKGxpa2VseSghYWFjX3J4X3Jlc3RhcnRfYWRhcHRlcihk
ZXYsIGFhY19yeF9jaGVja19oZWFsdGgoZGV2KSkpKQorCQkJCXN0YXJ0ID0gamlmZmllczsKKwkJ
CSsrcmVzdGFydDsKKwkJfQogCQltc2xlZXAoMSk7CiAJfQogCS8qCg==

------_=_NextPart_001_01C772D8.02B9BFC8--
