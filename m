From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: new interfaces
Date: Wed, 26 May 2004 23:07:16 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0405262305580.4272-200000@poirot.grange>
References: <20040526114521.GA24166@infradead.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1695247627-1085605636=:4272"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:45447 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S265803AbUEZVKP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 17:10:15 -0400
In-Reply-To: <20040526114521.GA24166@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Linux SCSI list <linux-scsi@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1463811839-1695247627-1085605636=:4272
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Wed, 26 May 2004, Christoph Hellwig wrote:

> On Sun, May 23, 2004 at 11:19:58PM +0200, Guennadi Liakhovetski wrote:
> >
> > Whereas, DCBCnt is incremented on slave_alloc, decremented on
> > slave_destroy and used in a couple more places. So, is it safe to assume
> > that DeviceCnt is redundant and remove it in a next patch?... Then it
> > might be already safe to move scan_devices as you suggest?
>
> Looks like a way to go.  I'm not sure what scan_device is supposed to
> do as I already wrote, but from looking at when it's set/cleared I'm
> pretty sure it tries to indicate whethere we're currently scanning for
> devices.  And useing slave_alloc/slave_configure is a much safer way to
> find that out then guessing from the commands sent.

So, here's the first one - remove DeviceCnt.

Thanks
Guennadi
---
Guennadi Liakhovetski


---1463811839-1695247627-1085605636=:4272
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="tmscsim-remove-DeviceCnt.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0405262307160.4272@poirot.grange>
Content-Description: 
Content-Disposition: attachment; filename="tmscsim-remove-DeviceCnt.patch"

ZGlmZiAtdSBhL2RyaXZlcnMvc2NzaS9zY3NpaW9tLmMgYi9kcml2ZXJzL3Nj
c2kvc2NzaWlvbS5jDQotLS0gYS9kcml2ZXJzL3Njc2kvc2NzaWlvbS5jCTI2
IE1heSAyMDA0IDE5OjQ5OjAwDQorKysgYi9kcml2ZXJzL3Njc2kvc2NzaWlv
bS5jCTI2IE1heSAyMDA0IDIwOjIzOjMyDQpAQCAtMTMwMiw3ICsxMzAyLDYg
QEANCiAgICBpZiAocERDQiA9PSBwQUNCLT5wRENCUnVuUm9iaW4pIHBBQ0It
PnBEQ0JSdW5Sb2JpbiA9IHBEQ0ItPnBOZXh0RENCOw0KICAgIGtmcmVlIChw
RENCKTsgDQogICAgcEFDQi0+RENCQ250LS07DQotICAgLyogcEFDQi0+RGV2
aWNlQ250LS07ICovDQogfTsNCiANCiANCkBAIC0xNTkwLDcgKzE1ODksNiBA
QA0KIAkgIHsNCiAJICAgICAvKiBkZXZpY2UgZm91bmQ6IGFkZCAqLyANCiAJ
ICAgICBkYzM5MF9hZGRfZGV2IChwQUNCLCBwRENCLCBwdHIpOw0KLQkgICAg
IGlmIChwQUNCLT5zY2FuX2RldmljZXMpIHBBQ0ItPkRldmljZUNudCsrOw0K
IAkgIH0NCiAJaWYoIChwY21kLT5kZXZpY2UtPmlkID09IHBBQ0ItPnBTY3Np
SG9zdC0+bWF4X2lkIC0gMSkgJiYNCiAJICAgIChwY21kLT5kZXZpY2UtPmx1
biA9PSBwQUNCLT5wU2NzaUhvc3QtPm1heF9sdW4gLSAxKSApDQpkaWZmIC11
IGEvZHJpdmVycy9zY3NpL3Rtc2NzaW0uYyBiL2RyaXZlcnMvc2NzaS90bXNj
c2ltLmMNCi0tLSBhL2RyaXZlcnMvc2NzaS90bXNjc2ltLmMJMjYgTWF5IDIw
MDQgMjA6MjY6MjENCisrKyBiL2RyaXZlcnMvc2NzaS90bXNjc2ltLmMJMjYg
TWF5IDIwMDQgMjA6MjQ6MDENCkBAIC0xNzM0LDcgKzE3MzQsNiBAQA0KICAg
ICBwQUNCLT5BZGFwdGVySW5kZXggPSBpbmRleDsNCiAgICAgcEFDQi0+c3Rh
dHVzID0gMDsNCiAgICAgcHNoLT50aGlzX2lkID0gZGMzOTBfZWVwcm9tQnVm
W2luZGV4XVtFRV9BREFQVF9TQ1NJX0lEXTsNCi0gICAgcEFDQi0+RGV2aWNl
Q250ID0gMDsNCiAgICAgcEFDQi0+RENCQ250ID0gMDsNCiAgICAgcEFDQi0+
VGFnTWF4TnVtID0gMiA8PCBkYzM5MF9lZXByb21CdWZbaW5kZXhdW0VFX1RB
R19DTURfTlVNXTsNCiAgICAgcEFDQi0+QUNCRmxhZyA9IDA7DQpAQCAtMjA4
OSw3ICsyMDg4LDcgQEANCiAgIFNQUklOVEYoIiAgICAgICAgICAgIExvc3Qg
YXJiaXRyYXRpb25zICVpLCBTZWwuIGNvbm5lY3RlZCAlaSwgQ29ubmVjdGVk
OiAlc1xuIiwgDQogCSAgcEFDQi0+U2VsTG9zdCwgcEFDQi0+U2VsQ29ubiwg
cEFDQi0+Q29ubmVjdGVkPyAiWWVzIjogIk5vIik7DQogICAgDQotICBTUFJJ
TlRGKCJOciBvZiBhdHRhY2hlZCBkZXZpY2VzOiAlaSwgTnIgb2YgRENCczog
JWlcbiIsIHBBQ0ItPkRldmljZUNudCwgcEFDQi0+RENCQ250KTsNCisgIFNQ
UklOVEYoIk5yIG9mIERDQnM6ICVpXG4iLCBwQUNCLT5EQ0JDbnQpOw0KICAg
U1BSSU5URigiTWFwIG9mIGF0dGFjaGVkIExVTnM6ICUwMnggJTAyeCAlMDJ4
ICUwMnggJTAyeCAlMDJ4ICUwMnggJTAyeFxuIiwNCiAJICBwQUNCLT5EQ0Jt
YXBbMF0sIHBBQ0ItPkRDQm1hcFsxXSwgcEFDQi0+RENCbWFwWzJdLCBwQUNC
LT5EQ0JtYXBbM10sIA0KIAkgIHBBQ0ItPkRDQm1hcFs0XSwgcEFDQi0+RENC
bWFwWzVdLCBwQUNCLT5EQ0JtYXBbNl0sIHBBQ0ItPkRDQm1hcFs3XSk7DQpk
aWZmIC11IGEvZHJpdmVycy9zY3NpL3Rtc2NzaW0uaCBiL2RyaXZlcnMvc2Nz
aS90bXNjc2ltLmgNCi0tLSBhL2RyaXZlcnMvc2NzaS90bXNjc2ltLmgJMjQg
TWF5IDIwMDQgMTk6MjI6MDINCisrKyBiL2RyaXZlcnMvc2NzaS90bXNjc2lt
LmgJMjYgTWF5IDIwMDQgMjA6MjM6MTQNCkBAIC0xOTYsMTAgKzE5Niw4IEBA
DQogDQogVUNIQVIJCVNSQkNvdW50Ow0KIFVDSEFSCQlBZGFwdGVySW5kZXg7
CS8qOyBudGggQWRhcHRlciB0aGlzIGRyaXZlciAqLw0KLVVDSEFSCQlEZXZp
Y2VDbnQ7DQogVUNIQVIJCURDQkNudDsNCiANCi0vKiAweDEwOiAqLw0KIFVD
SEFSCQlUYWdNYXhOdW07DQogVUNIQVIJCUFDQkZsYWc7DQogVUNIQVIJCUdt
b2RlMjsNCkBAIC0yMTMsMTMgKzIxMSwxMSBAQA0KIFBTUkIJCXBGcmVlU1JC
Ow0KIFBTUkIJCXBUbXBTUkI7DQogDQotLyogMHgyYzogKi8NCiBVQ0hBUgkJ
bXNnaW4xMjNbNF07DQogVUNIQVIJCURDQm1hcFtNQVhfU0NTSV9JRF07DQog
VUNIQVIJCUNvbm5lY3RlZDsNCiBVQ0hBUgkJcGFkOw0KIA0KLS8qIDB4MzA6
ICovDQogI2lmIGRlZmluZWQoVVNFX1NQSU5MT0NLUykgJiYgVVNFX1NQSU5M
T0NLUyA+IDEgJiYgKGRlZmluZWQoQ09ORklHX1NNUCkgfHwgREVCVUdfU1BJ
TkxPQ0tTID4gMCkNCiBzcGlubG9ja190CWxvY2s7DQogI2VuZGlmDQpAQCAt
MjMwLDIwICsyMjYsMTcgQEANCiBVQ0hBUgkJSWdub3JlX0lSUTsJLyogTm90
IHVzZWQgKi8NCiANCiBQREVWREVDTDE7CQkJLyogUG9pbnRlciB0byBQQ0kg
Y2ZnLiBzcGFjZSAqLw0KLS8qIDB4NDAvMHgzYzogKi8NCisNCiBVTE9ORwkJ
Q21kczsNCiBVSU5UCQlTZWxMb3N0Ow0KIFVJTlQJCVNlbENvbm47DQogVUlO
VAkJQ21kSW5ROw0KIFVJTlQJCUNtZE91dE9mU1JCOw0KIAkNCi0vKiAweDU0
LzB4NTA6ICovDQogc3RydWN0IHRpbWVyX2xpc3QJV2FpdGluZ19UaW1lcjsN
Ci0vKiAweDY4LzB4NjQ6ICovDQorDQogREMzOTBfU1JCCVRtcFNSQjsNCi0v
KiAweGNjLzB4Yzg6ICovDQogREMzOTBfU1JCCVNSQl9hcnJheVtNQVhfU1JC
X0NOVF07IAkvKiA1MCBTUkJzICovDQotLyogMHhmYTQvMHhmYTA6ICovDQog
fTsNCiANCiB0eXBlZGVmICBzdHJ1Y3QgIF9BQ0IJIERDMzkwX0FDQiwgKlBB
Q0I7DQo=
---1463811839-1695247627-1085605636=:4272--
