From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 1/5] aacraid: simplify non-dasd support
Date: Thu, 2 Feb 2006 08:54:27 -0500
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F0217F1EB@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C62800.2EC4BC84"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:29109 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1751070AbWBBNy2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Feb 2006 08:54:28 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Hammer, Jack" <Jack_Hammer@adaptec.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C62800.2EC4BC84
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On December 01, 2005 12:55PM Christoph Hellwig
[mailto:hch@infradead.org] writes
> On Wed, Nov 30, 2005 at 02:29:10PM -0500, Salyzyn, Mark wrote:
> > Christoph Hellwig [mailto:hch@infradead.org] writes:
> > > NACK on the write filter.  If we can agree on it beeing=20
> > > useful (and I must admit I tend to the contrary opinion)
> > > it should be done in higher layers.
> > Our customers won't stand still if we do not write (and=20
> > read) protect the raid components. So you propose the
> > introduction of an sdev->io_protect flag?
> write a patch to do it and argue for it. in the driver it's in the
> wrong place for certain and not acceptable by any means.

I have enclosed the patch to drivers/scsi/scsi.c in support of write
protection. Before this patch, the writeable flag is only checked in
sd.c. With this patch we spread a wider net and cover requests from all
sources including sg.c (which smartmontools access). It is possible to
drop the check in sd.c, this patch does not take that action, expect it
to be part of a later cleanup.

This will allow the aacraid, ips, megaraid and possibly other hardware
RAID drivers to export the physical components safely for status
interrogation by combining the setting of no_uld_attach and writeable
device flags in the slave configure function.

Signed-off-by: Mark Salyzyn <Mark_Salyzyn@adaptec.com>

------_=_NextPart_001_01C62800.2EC4BC84
Content-Type: application/octet-stream;
	name="wprotect2.patch"
Content-Transfer-Encoding: base64
Content-Description: wprotect2.patch
Content-Disposition: attachment;
	filename="wprotect2.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvc2NzaS5jIGIvZHJpdmVycy9zY3NpL3Njc2kuYwotLS0g
YS9kcml2ZXJzL3Njc2kvc2NzaS5jCTIwMDYtMDEtMTYgMDc6NTY6MDguMDAwMDAwMDAwIC0wNTAw
CisrKyBiL2RyaXZlcnMvc2NzaS9zY3NpLmMJMjAwNi0wMi0wMiAwODo0MDozNi41MjI5Mjc5MTAg
LTA1MDAKQEAgLTYyMSw2ICs2MjEsMjMgQEAKIAkJZ290byBvdXQ7CiAJfQogCisJLyoKKwkgKiBE
ZXZpY2Ugb3IgTExEIHdyaXRlIHByb3RlY3QgZW5mb3JjZW1lbnQuCisJICovCisJaWYgKHVubGlr
ZWx5KCFjbWQtPmRldmljZS0+d3JpdGVhYmxlKSAmJgorCSAgICAoY21kLT5zY19kYXRhX2RpcmVj
dGlvbiA9PSBETUFfVE9fREVWSUNFKSkgeworCQljbWQtPnJlc3VsdCA9IERJRF9PSyA8PCAxNgor
CQkgICAgICAgICAgICB8IENPTU1BTkRfQ09NUExFVEUgPDwgOAorCQkgICAgICAgICAgICB8IFNB
TV9TVEFUX0NIRUNLX0NPTkRJVElPTjsKKwkJY21kLT5zZW5zZV9idWZmZXJbMF0gPSAweEYwOwor
CQljbWQtPnNlbnNlX2J1ZmZlclsyXSA9IERBVEFfUFJPVEVDVDsKKwkJY21kLT5zZW5zZV9idWZm
ZXJbN10gPSA2OworCQljbWQtPnNlbnNlX2J1ZmZlclsxMl0gPSBEQVRBX1BST1RFQ1QgPDwgMTsK
KwkJY21kLT5zZW5zZV9idWZmZXJbMTNdID0gMHgwNTsKKwkJc2NzaV9kb25lKGNtZCk7CisJCWdv
dG8gb3V0OworCX0KKwogCXNwaW5fbG9ja19pcnFzYXZlKGhvc3QtPmhvc3RfbG9jaywgZmxhZ3Mp
OwogCXNjc2lfY21kX2dldF9zZXJpYWwoaG9zdCwgY21kKTsgCiAK

------_=_NextPart_001_01C62800.2EC4BC84--
