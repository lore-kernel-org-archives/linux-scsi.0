From: James.Smart@Emulex.Com
Subject: RE: [PATCH] LLDD dynamic scan aids
Date: Thu, 18 Nov 2004 08:36:36 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C12E730@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C4CD73.9FFA4C2A"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:19866 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261771AbUKRNhA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2004 08:37:00 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C4CD73.9FFA4C2A
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> > - Allows scsi_scan_host() to be called at times other than=20
> just first attachment.
>=20
> I'm not too happy about that, and we had that discussion already when
> discussing the aacraid dynamic container addition / removal.=20

Hmmm. I found the following discussion in Aug 2003 =
(http://marc.theaimsgroup.com/?l=3Dlinux-scsi&m=3D106183721811209&w=3D2).=
 The argument is about exporting scsi_scan_host_selected() and =
alternatively using scsi_rescan_device().

This patch does not export scsi_scan_host_selected() - it simply updates =
the internals of scsi_scan_host() so the rescan flag is not always =
hardcoded to 0 - which would always take the "optimized" path for =
scanning the first time, making it callable only upon first attachment.

Given that scsi_rescan_device() works on a lun level, the lldd has no =
notion of what luns exist on the target, nor the appropriate scan logic =
for luns on a target (blacklist, etc), scsi_rescan_device() isn't =
appropriate to use (and would be very cumbersome).

If there's a different set of arguments, let me know.

> > - Provides a new interface to scan a single target entity.
> >=20
> > This allows our LLDD to automatically detect new device=20
> additions after a cable/fabric change, or upon insertion of a=20
> new FC device.
> >=20
> > Note: We opted for a "scan target" interface as, on large=20
> configurations, scanning everything on the link via=20
> scsi_scan_host() was overkill.
> >=20
>=20
> >  	scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
> > -				SCAN_WILD_CARD, 0);
> > +				SCAN_WILD_CARD, shost->rescan);
> > +	shost->rescan=3D1;
>=20
> this is missing whitespaces.  Also ->rescan is not used anywhere.

?? Must have been late (or early).  The diff itself clearly shows the =
use of ->rescan in the call to scsi_scan_host_selected(). Missing =
whitespace ?? The only reference I can figure out is if the tabs were =
removed, and if so, it was an inadvertant paste into the mail message.

In further consideration, I should have set the rescan flag prior to the =
call so that a second call while the first is outstanding will not =
encounter an issue. Attached is an update.

-- James S


------_=_NextPart_001_01C4CD73.9FFA4C2A
Content-Type: application/octet-stream;
	name="scan.patch"
Content-Transfer-Encoding: base64
Content-Description: scan.patch
Content-Disposition: attachment;
	filename="scan.patch"

ZGlmZiAtdU5yIGxpbnV4LTIuNi4xMC1yYzIvZHJpdmVycy9zY3NpL3Njc2lfc2Nhbi5jIGxpbnV4
LTIuNi4xMC1yYzIucGF0Y2gvZHJpdmVycy9zY3NpL3Njc2lfc2Nhbi5jCi0tLSBsaW51eC0yLjYu
MTAtcmMyL2RyaXZlcnMvc2NzaS9zY3NpX3NjYW4uYwkyMDA0LTExLTE3IDEzOjU4OjQwLjAwMDAw
MDAwMCAtMDUwMAorKysgbGludXgtMi42LjEwLXJjMi5wYXRjaC9kcml2ZXJzL3Njc2kvc2NzaV9z
Y2FuLmMJMjAwNC0xMS0xOCAwODoxODoxOC45MjYzNTIyNjQgLTA1MDAKQEAgLTEyMjIsOCArMTIy
MiwyMiBAQAogICoqLwogdm9pZCBzY3NpX3NjYW5faG9zdChzdHJ1Y3QgU2NzaV9Ib3N0ICpzaG9z
dCkKIHsKKwlpbnQgcmVzY2FuID0gc2hvc3QtPnJlc2NhbjsKKwlzaG9zdC0+cmVzY2FuPTE7CiAJ
c2NzaV9zY2FuX2hvc3Rfc2VsZWN0ZWQoc2hvc3QsIFNDQU5fV0lMRF9DQVJELCBTQ0FOX1dJTERf
Q0FSRCwKLQkJCQlTQ0FOX1dJTERfQ0FSRCwgMCk7CisJCQkJU0NBTl9XSUxEX0NBUkQsIHJlc2Nh
bik7Cit9CisKKy8qKgorICogc2NzaV9zY2FuX3NpbmdsZV90YXJnZXQgLSBzY2FuIHRoZSBnaXZl
biBTQ1NJIHRhcmdldAorICogQHNob3N0OiAgICAgICAgIGFkYXB0ZXIgdG8gc2NhbgorICogQGNo
YW46ICAgICAgICAgIGNoYW5uZWwgdG8gc2NhbgorICogQGlkOiAgICAgICAgICAgIHRhcmdldCBp
ZCB0byBzY2FuCisgKiovCit2b2lkIHNjc2lfc2Nhbl9zaW5nbGVfdGFyZ2V0KHN0cnVjdCBTY3Np
X0hvc3QgKnNob3N0LCAKKwl1bnNpZ25lZCBpbnQgY2hhbiwgdW5zaWduZWQgaW50IGlkKQorewor
CXNjc2lfc2Nhbl9ob3N0X3NlbGVjdGVkKHNob3N0LCBjaGFuLCBpZCwgU0NBTl9XSUxEX0NBUkQs
IDEpOwogfQogCiB2b2lkIHNjc2lfZm9yZ2V0X2hvc3Qoc3RydWN0IFNjc2lfSG9zdCAqc2hvc3Qp
CmRpZmYgLXVOciBsaW51eC0yLjYuMTAtcmMyL2RyaXZlcnMvc2NzaS9zY3NpX3N5bXMuYyBsaW51
eC0yLjYuMTAtcmMyLnBhdGNoL2RyaXZlcnMvc2NzaS9zY3NpX3N5bXMuYwotLS0gbGludXgtMi42
LjEwLXJjMi9kcml2ZXJzL3Njc2kvc2NzaV9zeW1zLmMJMjAwNC0xMS0xNyAxMzo1ODo0MC4wMDAw
MDAwMDAgLTA1MDAKKysrIGxpbnV4LTIuNi4xMC1yYzIucGF0Y2gvZHJpdmVycy9zY3NpL3Njc2lf
c3ltcy5jCTIwMDQtMTEtMTcgMTM6NTg6NDAuMDAwMDAwMDAwIC0wNTAwCkBAIC0yNyw2ICsyNyw3
IEBACiBFWFBPUlRfU1lNQk9MKHNjc2lfaG9zdF9hbGxvYyk7CiBFWFBPUlRfU1lNQk9MKHNjc2lf
YWRkX2hvc3QpOwogRVhQT1JUX1NZTUJPTChzY3NpX3NjYW5faG9zdCk7CitFWFBPUlRfU1lNQk9M
KHNjc2lfc2Nhbl9zaW5nbGVfdGFyZ2V0KTsKIEVYUE9SVF9TWU1CT0woc2NzaV9yZW1vdmVfaG9z
dCk7CiBFWFBPUlRfU1lNQk9MKHNjc2lfaG9zdF9nZXQpOwogRVhQT1JUX1NZTUJPTChzY3NpX2hv
c3RfcHV0KTsKZGlmZiAtdU5yIGxpbnV4LTIuNi4xMC1yYzIvaW5jbHVkZS9zY3NpL3Njc2lfaG9z
dC5oIGxpbnV4LTIuNi4xMC1yYzIucGF0Y2gvaW5jbHVkZS9zY3NpL3Njc2lfaG9zdC5oCi0tLSBs
aW51eC0yLjYuMTAtcmMyL2luY2x1ZGUvc2NzaS9zY3NpX2hvc3QuaAkyMDA0LTExLTE3IDEzOjU4
OjQwLjAwMDAwMDAwMCAtMDUwMAorKysgbGludXgtMi42LjEwLXJjMi5wYXRjaC9pbmNsdWRlL3Nj
c2kvc2NzaV9ob3N0LmgJMjAwNC0xMS0xNyAxMzo1ODo0MC4wMDAwMDAwMDAgLTA1MDAKQEAgLTQ1
NCw2ICs0NTQsNyBAQAogCXVuc2lnbmVkIHVuY2hlY2tlZF9pc2FfZG1hOjE7CiAJdW5zaWduZWQg
dXNlX2NsdXN0ZXJpbmc6MTsKIAl1bnNpZ25lZCB1c2VfYmxrX3RjcToxOworCXVuc2lnbmVkIHJl
c2NhbjoxOwogCiAJLyoKIAkgKiBIb3N0IGhhcyByZXF1ZXN0ZWQgdGhhdCBubyBmdXJ0aGVyIHJl
cXVlc3RzIGNvbWUgdGhyb3VnaCBmb3IgdGhlCkBAIC01MjcsNiArNTI4LDggQEAKIGV4dGVybiBz
dHJ1Y3QgU2NzaV9Ib3N0ICpzY3NpX2hvc3RfYWxsb2Moc3RydWN0IHNjc2lfaG9zdF90ZW1wbGF0
ZSAqLCBpbnQpOwogZXh0ZXJuIGludCBfX211c3RfY2hlY2sgc2NzaV9hZGRfaG9zdChzdHJ1Y3Qg
U2NzaV9Ib3N0ICosIHN0cnVjdCBkZXZpY2UgKik7CiBleHRlcm4gdm9pZCBzY3NpX3NjYW5faG9z
dChzdHJ1Y3QgU2NzaV9Ib3N0ICopOworZXh0ZXJuIHZvaWQgc2NzaV9zY2FuX3NpbmdsZV90YXJn
ZXQoc3RydWN0IFNjc2lfSG9zdCAqLCB1bnNpZ25lZCBpbnQsCisJdW5zaWduZWQgaW50KTsKIGV4
dGVybiB2b2lkIHNjc2lfcmVtb3ZlX2hvc3Qoc3RydWN0IFNjc2lfSG9zdCAqKTsKIGV4dGVybiBz
dHJ1Y3QgU2NzaV9Ib3N0ICpzY3NpX2hvc3RfZ2V0KHN0cnVjdCBTY3NpX0hvc3QgKik7CiBleHRl
cm4gdm9pZCBzY3NpX2hvc3RfcHV0KHN0cnVjdCBTY3NpX0hvc3QgKnQpOwo=

------_=_NextPart_001_01C4CD73.9FFA4C2A--
