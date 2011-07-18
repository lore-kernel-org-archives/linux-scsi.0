From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: CONFIG_INTR_REMAP and CONFIG_DMAR dependencies?
Date: Mon, 18 Jul 2011 16:16:02 -0700
Message-ID: <CAE9FiQVUA2bWycDNmKDysPV6SQ1tcniJHUvbSDXpufC75cFVjg@mail.gmail.com>
References: <20110718211620.GD4770@plapp.qlogic.org>
	<CAE9FiQUgbvC6TiSXK-5K9bOsxYeCePoRoU-NBvtitweVBegyEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=bcaec51d2d7acdde4e04a8602e7a
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CAE9FiQUgbvC6TiSXK-5K9bOsxYeCePoRoU-NBvtitweVBegyEA@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux scsi dev <linux-scsi@vger.kernel.org>, linux pci <linux-pci@vger.kernel.org>, suresh.b.siddha@intel.com, hpa@linux.intel.com, Avik Shau <avik.shau@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

--bcaec51d2d7acdde4e04a8602e7a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 18, 2011 at 2:32 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Jul 18, 2011 at 2:16 PM, Andrew Vasquez
> <andrew.vasquez@qlogic.com> wrote:
>> Suresh,
>>
>> Any thoughts/ideas on this? =A0Could you help with the INTR-REMAP
>> messages?
>>
>> Thanks,
>> Andrew Vasquez
>>
>> ----
>>
>> All,
>>
>> We've seen a few reports logged with upstream kernels where qla2xxx is
>> unable to initialize HW due to what appears to be a lack of
>> interrupt routing:
>>
>> =A0 =A0 =A0 =A0[ 1137.271156] qla2xxx 0000:18:00.0: Found an ISP2532, ir=
q 52, iobase 0xffffc90000028000
>> =A0 =A0 =A0 =A0[ 1137.271438] qla2xxx 0000:18:00.0: irq 96 for MSI/MSI-X
>> =A0 =A0 =A0 =A0[ 1137.271447] qla2xxx 0000:18:00.0: irq 97 for MSI/MSI-X
>> =A0 =A0 =A0 =A0[ 1137.271706] qla2xxx 0000:18:00.0: Configuring PCI spac=
e...
>> =A0 =A0 =A0 =A0[ 1137.271725] qla2xxx 0000:18:00.0: setting latency time=
r to 64
>> =A0 =A0 =A0 =A0[ 1137.271732] qla2xxx 0000:18:00.0: enabling Mem-Wr-Inva=
l
>> =A0 =A0 =A0 =A0[ 1137.278705] DRHD: handling fault status reg 2
>> =A0 =A0 =A0 =A0[ 1137.278715] INTR-REMAP: Request device [[18:00.0] faul=
t index 20
>> =A0 =A0 =A0 =A0[ 1137.278717] INTR-REMAP:[fault reason 34] Present field=
 in the IRTE entry is clear
>> =A0 =A0 =A0 =A0[ 1159.389099] qla2xxx 0000:0c:07.0: Cable is unplugged..=
.
>> =A0 =A0 =A0 =A0[ 1167.218478] qla2xxx 0000:18:00.0: Mailbox command time=
out occurred. Scheduling ISP abort. eeh_busy: 0x0
>> =A0 =A0 =A0 =A0[ 1167.218490] qla2xxx 0000:18:00.0: Unable to burst-read=
 optrom segment (100/7ff50400/18389b000).
>> =A0 =A0 =A0 =A0[ 1167.218496] qla2xxx 0000:18:00.0: Reverting to slow-re=
ad.
>> =A0 =A0 =A0 =A0[ 1197.174623] qla2xxx 0000:18:00.0: Unable to burst-read=
 optrom segment (100/7ff50000/18389b000).
>> =A0 =A0 =A0 =A0[ 1197.174632] qla2xxx 0000:18:00.0: Reverting to slow-re=
ad.
>> =A0 =A0 =A0 =A0[ 1197.190613] qla2xxx 0000:18:00.0: Configure NVRAM para=
meters...
>> =A0 =A0 =A0 =A0[ 1197.198582] qla2xxx 0000:18:00.0: Verifying loaded RIS=
C code...
>> =A0 =A0 =A0 =A0[ 1227.142951] qla2xxx 0000:18:00.0: Failed mailbox send =
register test
>> =A0 =A0 =A0 =A0[ 1227.142959] qla2xxx 0000:18:00.0: Failed to initialize=
 adapter

please check attached patch, it should fix that configuration.

Thanks

Yinghai

--bcaec51d2d7acdde4e04a8602e7a
Content-Type: text/x-patch; charset=US-ASCII; name="fix_intr_remapping.patch"
Content-Disposition: attachment; filename="fix_intr_remapping.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqa1xht00

LS0tCiBkcml2ZXJzL2lvbW11L2RtYXIuYyB8ICAgMTEgKysrKysrKysrKysKIGluY2x1ZGUvbGlu
dXgvZG1hci5oIHwgICAgNCArLS0tCiAyIGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyks
IDMgZGVsZXRpb25zKC0pCgpJbmRleDogbGludXgtMi42L2luY2x1ZGUvbGludXgvZG1hci5oCj09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2luY2x1ZGUvbGludXgvZG1hci5oCisrKyBsaW51
eC0yLjYvaW5jbHVkZS9saW51eC9kbWFyLmgKQEAgLTIzMiw5ICsyMzIsNyBAQCBzdHJ1Y3QgZG1h
cl9hdHNyX3VuaXQgewogI2RlZmluZSBmb3JfZWFjaF9hdHNyX3VuaXQoYXRzcikgXAogCWxpc3Rf
Zm9yX2VhY2hfZW50cnkoYXRzciwgJmRtYXJfYXRzcl91bml0cywgbGlzdCkKIAotZXh0ZXJuIGlu
dCBpbnRlbF9pb21tdV9pbml0KHZvaWQpOwotI2Vsc2UgLyogIUNPTkZJR19ETUFSOiAqLwotc3Rh
dGljIGlubGluZSBpbnQgaW50ZWxfaW9tbXVfaW5pdCh2b2lkKSB7IHJldHVybiAtRU5PREVWOyB9
CiAjZW5kaWYgLyogQ09ORklHX0RNQVIgKi8KK2V4dGVybiBpbnQgaW50ZWxfaW9tbXVfaW5pdCh2
b2lkKTsKIAogI2VuZGlmIC8qIF9fRE1BUl9IX18gKi8KSW5kZXg6IGxpbnV4LTIuNi9kcml2ZXJz
L2lvbW11L2RtYXIuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9kcml2ZXJzL2lvbW11
L2RtYXIuYworKysgbGludXgtMi42L2RyaXZlcnMvaW9tbXUvZG1hci5jCkBAIC03MjIsNiArNzIy
LDE3IEBAIGludCBfX2luaXQgZGV0ZWN0X2ludGVsX2lvbW11KHZvaWQpCiAJcmV0dXJuIHJldCA/
IDEgOiAtRU5PREVWOwogfQogCisjaWZuZGVmIENPTkZJR19ETUFSCitpbnQgX19pbml0IGludGVs
X2lvbW11X2luaXQodm9pZCkKK3sKKyAgICAgICAgaWYgKGRtYXJfdGFibGVfaW5pdCgpKSB7Cisg
ICAgICAgICAgICAgICAgcmV0dXJuICAtRU5PREVWOworICAgICAgICB9CisKKyAgICAgICAgZG1h
cl9kZXZfc2NvcGVfaW5pdCgpOworICAgICAgICByZXR1cm4gIC1FTk9ERVY7Cit9CisjZW5kaWYK
IAogaW50IGFsbG9jX2lvbW11KHN0cnVjdCBkbWFyX2RyaGRfdW5pdCAqZHJoZCkKIHsK
--bcaec51d2d7acdde4e04a8602e7a--
