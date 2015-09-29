From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 27/32] cxlflash: Fix to prevent stale AFU RRQ
Date: Tue, 29 Sep 2015 15:22:39 -0500
Message-ID: <FAA7C7C9-EFA4-4135-B39D-E0255980A5E8@linux.vnet.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1443223144-9962-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <8737xyuhun.fsf@gamma.ozlabs.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <8737xyuhun.fsf@gamma.ozlabs.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Daniel Axtens <dja@axtens.net>
Cc: Michael Neuling <mikey@neuling.org>, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, David Laight <David.Laight@ACULAB.COM>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

PiBPbiBTZXAgMjgsIDIwMTUsIGF0IDg6MzYgUE0sIERhbmllbCBBeHRlbnMgPGRqYUBheHRlbnMu
bmV0PiB3cm90ZToKPiAKPiAtLS0tLUJFR0lOIFBHUCBTSUdORUQgTUVTU0FHRS0tLS0tCj4gSGFz
aDogU0hBNTEyCj4gCj4gIk1hdHRoZXcgUi4gT2NocyIgPG1yb2Noc0BsaW51eC52bmV0LmlibS5j
b20+IHdyaXRlczoKPiAKPj4gRm9sbG93aW5nIGFuIGFkYXB0ZXIgcmVzZXQsIHRoZSBBRlUgUlJR
IHRoYXQgcmVzaWRlcyBpbiBob3N0IG1lbW9yeQo+PiBob2xkcyBzdGFsZSBkYXRhLiBUaGlzIGNh
biBsZWFkIHRvIGEgY29uZGl0aW9uIHdoZXJlIHRoZSBSUlEgaW50ZXJydXB0Cj4+IGhhbmRsZXIg
dHJpZXMgdG8gcHJvY2VzcyBzdGFsZSBlbnRyaWVzIGFuZC9vciBlbmRsZXNzbHkgbG9vcHMgZHVl
IHRvIGFuCj4+IG91dCBvZiBzeW5jIGdlbmVyYXRpb24gYml0Lgo+PiAKPj4gVG8gZml4LCB0aGUg
QUZVIFJSUSBpbiBob3N0IG1lbW9yeSBuZWVkcyB0byBiZSBjbGVhcmVkIGFmdGVyIGVhY2ggcmVz
ZXQuCj4gCj4gVGhpcyBsb29rcyBnb29kLiBEbyB5b3UgbmVlZCBhbnl0aGluZyB0byBiYWlsIG91
dCBvZiBjeGxmbGFzaF9ycnFfaXJxIGlmCj4gdGhlIGRhdGEgZ29lcyBzdGFsZSBvciB0byBhbGwg
RnMgd2hpbGUgdGhhdCBmdW5jdGlvbiBpcyBydW5uaW5nPwoKV2UncmUgbm90IHBlcmZvcm1pbmcg
YW4gTU1JTyBoZXJlLCBzbyBJJ20gbm90IHN1cmUgaG93IHRoZSBhbGwgRnMgY2hlY2sKd291bGQg
YXBwbHkuIFdlJ3JlIGFsc28gcHJvdGVjdGVkIGZhaXJseSB3ZWxsIGJ5IHRoZSBnZW5lcmF0aW9u
IGJpdC4gSSBzdXBwb3NlCndlIGNvdWxkIGxvb2sgYXQgYWRkaW5nIHNvbWUgdHlwZSBvZiAnbWF4
IGl0ZXJhdGlvbnMnIGNvdW50IHRvIHByb3RlY3QgYWdhaW5zdAphIHJ1bmF3YXkgaGFuZGxlciBi
dXQgdGhhdCB3b3VsZCBiZSBpbiBhIGZ1dHVyZSBwYXRjaC4KCgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eHBwYy1kZXYgbWFpbGluZyBsaXN0Ckxp
bnV4cHBjLWRldkBsaXN0cy5vemxhYnMub3JnCmh0dHBzOi8vbGlzdHMub3psYWJzLm9yZy9saXN0
aW5mby9saW51eHBwYy1kZXY=
