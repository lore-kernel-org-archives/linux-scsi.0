From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: 64-bit cleanup
Date: Sat, 5 Jun 2004 00:17:10 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0406042357001.5107-200000@poirot.grange>
References: <1085152512.2258.21.camel@mulgrave>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-445485992-1086387130=:5107"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:26843 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S265941AbUFDWRz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2004 18:17:55 -0400
In-Reply-To: <1085152512.2258.21.camel@mulgrave>
Content-ID: <Pine.LNX.4.44.0406050015140.5107@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1463811839-445485992-1086387130=:5107
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.44.0406050015141.5107@poirot.grange>

On 21 May 2004, James Bottomley wrote:

> On Wed, 2004-05-19 at 14:50, Guennadi Liakhovetski wrote:
> > Ok, here comes the first one. I chose this one because it fixes an actual
> > bug in the driver. This bug was (partially) introduced by myself when
> > porting to 2.6. Partly the reason was that I disliked using
> > function-like macros as lvalues:
> >
> > sg_dma_address(x) = ...
> > sg_dma_len(x) = ...
> >
> > [OT] wouldn't it be better to introduce some macros like
> > set_sg_dma_{address|len}(x, y)?
>
> Actually, no.  struct scatterlist is for the OS platform to use to
> characterise DMA; it's actually a private structure entirely within the
> gift of the architecture to define.  It usually contains bits of
> extraneous data that the driver never sees.  The driver should convert
> struct scatterlist into its own version of the scatterlist that needs
> feeding to the hardware rather than try and use struct scatterlist.

Well, I don't quite understand. What about this code in block/ll_rw_blk.c:
	sg[nsegs].page = bvec->bv_page;
	sg[nsegs].length = nbytes;
	sg[nsegs].offset = bvec->bv_offset;
? So, looks like all architectures should implement these fields in struct
scatterlist, and use them in map_sg. So, isn't it safe to use them from
drivers in a similar way (see patch attached).

> You'll find that lvalue use of sg_dma_len() fails on some platforms that
> actually compute it from page/offset values in the scatterlist.

Actually, I found only 1 platform, where sg_dma_address() cannot be used
as an lvalue:

include/asm-sh/pci.h:#define sg_dma_address(sg) (virt_to_bus((sg)->dma_address))

> Could you (eventually) update tmscsim not to use it?

Don't know if this is correct, but the most consistent way to do it, I was
able to find, was to reproduce the code above for an sg with 1 element and
call pci_map_sg() instead of pci_map_page, thus avoiding assignments like

sg_dma_len(sg) = ...;
sg_dma_address(sg) = ...;

There's still one use of sg_dma_len() as an lvalue left in scsiiom.c on
the RESTORE_PTR path. But (1) at the moment it seems to be safe on all
platforms, (2) I am very suspicious about that code any way and would
appreciate any advise as to if that code is correct, and, if not, what
should be done there.

Emn, ok, in case it is already compalsory, here goes:
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi
---
Guennadi Liakhovetski


---1463811839-445485992-1086387130=:5107
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME="tmscsim-remove-sg_dma-lvalue.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0406050012100.5107@poirot.grange>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME="tmscsim-remove-sg_dma-lvalue.patch"

LS0tIGEvZHJpdmVycy9zY3NpL3Rtc2NzaW0uYwlGcmkgSnVuIDA0IDIxOjQx


OjE4IDIwMDQNCisrKyBiL2RyaXZlcnMvc2NzaS90bXNjc2ltLmMJRnJpIEp1


biAwNCAyMzoyODo1MCAyMDA0DQpAQCAtOTE5LDE4ICs5MTksOCBAQA0KIAlT


Y3NpX0NtbmQgKnBjbWQgPSBwU1JCLT5wY21kOw0KIAlzdHJ1Y3QgcGNpX2Rl


diAqcGRldiA9IHBTUkItPnBTUkJEQ0ItPnBEQ0JBQ0ItPnBkZXY7DQogCWRj


MzkwX2NtZF9zY3BfdCogY21kcCA9ICgoZGMzOTBfY21kX3NjcF90KikoJnBj


bWQtPlNDcCkpOw0KLQkvKiBNYXAgc2Vuc2UgYnVmZmVyICovDQotCWlmIChw


U1JCLT5TUkJGbGFnICYgQVVUT19SRVFTRU5TRSkgew0KLQkJc2dfZG1hX2Fk


ZHJlc3MoJnBTUkItPlNlZ21lbnR4KSA9IGNtZHAtPnNhdmVkX2RtYV9oYW5k


bGUgPSANCi0JCQlwY2lfbWFwX3BhZ2UocGRldiwgdmlydF90b19wYWdlKHBj


bWQtPnNlbnNlX2J1ZmZlciksDQotCQkJCSAgICAgKHVuc2lnbmVkIGxvbmcp


cGNtZC0+c2Vuc2VfYnVmZmVyICYgflBBR0VfTUFTSywgc2l6ZW9mKHBjbWQt


PnNlbnNlX2J1ZmZlciksDQotCQkJCSAgICAgRE1BX0ZST01fREVWSUNFKTsN


Ci0JCXNnX2RtYV9sZW4oJnBTUkItPlNlZ21lbnR4KSA9IHNpemVvZihwY21k


LT5zZW5zZV9idWZmZXIpOw0KLQkJcFNSQi0+U0djb3VudCA9IDE7DQotCQlw


U1JCLT5wU2VnbWVudExpc3QgPSAoUFNHTCkgJnBTUkItPlNlZ21lbnR4Ow0K


LQkJREVCVUcxKHByaW50aygiJXMoKTogTWFwcGVkIHNlbnNlIGJ1ZmZlciAl


cCBhdCAleFxuIiwgX19GVU5DVElPTl9fLCBwY21kLT5zZW5zZV9idWZmZXIs


IGNtZHAtPnNhdmVkX2RtYV9oYW5kbGUpKTsNCi0JLyogTWFrZSBTRyBsaXN0


ICovCQ0KLQl9IGVsc2UgaWYgKHBjbWQtPnVzZV9zZykgew0KKwkvKiBNYXAg


U0cgbGlzdCAqLwkNCisJaWYgKHBjbWQtPnVzZV9zZykgew0KIAkJcFNSQi0+


cFNlZ21lbnRMaXN0ID0gKFBTR0wpIHBjbWQtPnJlcXVlc3RfYnVmZmVyOw0K


IAkJcFNSQi0+U0djb3VudCA9IHBjaV9tYXBfc2cocGRldiwgcFNSQi0+cFNl


Z21lbnRMaXN0LA0KIAkJCQkJICAgcGNtZC0+dXNlX3NnLA0KQEAgLTkzOCwx


OCArOTI4LDM3IEBADQogCQkvKiBUT0RPOiBlcnJvciBoYW5kbGluZyAqLw0K


IAkJaWYgKCFwU1JCLT5TR2NvdW50KQ0KIAkJCWVycm9yID0gMTsNCi0JCURF


QlVHMShwcmludGsoIiVzKCk6IE1hcHBlZCBTRyAlcCB3aXRoICVkICglZCkg


ZWxlbWVudHNcbiIsIF9fRlVOQ1RJT05fXywgcGNtZC0+cmVxdWVzdF9idWZm


ZXIsIHBTUkItPlNHY291bnQsIHBjbWQtPnVzZV9zZykpOw0KLQkvKiBNYXAg


c2luZ2xlIHNlZ21lbnQgKi8NCi0JfSBlbHNlIGlmIChwY21kLT5yZXF1ZXN0


X2J1ZmZlciAmJiBwY21kLT5yZXF1ZXN0X2J1ZmZsZW4pIHsNCi0JCXNnX2Rt


YV9hZGRyZXNzKCZwU1JCLT5TZWdtZW50eCkgPSBjbWRwLT5zYXZlZF9kbWFf


aGFuZGxlID0NCi0JCQlwY2lfbWFwX3BhZ2UocGRldiwgdmlydF90b19wYWdl


KHBjbWQtPnJlcXVlc3RfYnVmZmVyKSwNCi0JCQkJICAgICAodW5zaWduZWQg


bG9uZylwY21kLT5yZXF1ZXN0X2J1ZmZlciAmIH5QQUdFX01BU0ssDQotCQkJ


CSAgICAgcGNtZC0+cmVxdWVzdF9idWZmbGVuLCBzY3NpX3RvX3BjaV9kbWFf


ZGlyKHBjbWQtPnNjX2RhdGFfZGlyZWN0aW9uKSk7DQorCQlERUJVRzEocHJp


bnRrKCIlcygpOiBNYXBwZWQgU0cgJXAgd2l0aCAlZCAoJWQpIGVsZW1lbnRz


XG4iLFwNCisJCQkgICAgICBfX0ZVTkNUSU9OX18sIHBjbWQtPnJlcXVlc3Rf


YnVmZmVyLCBwU1JCLT5TR2NvdW50LCBwY21kLT51c2Vfc2cpKTsNCisJfSBl


bHNlIGlmICgocFNSQi0+U1JCRmxhZyAmIEFVVE9fUkVRU0VOU0UpIHx8IChw


Y21kLT5yZXF1ZXN0X2J1ZmZlciAmJiBwY21kLT5yZXF1ZXN0X2J1ZmZsZW4p


KSB7DQorCQl2b2lkICphZGRyOw0KKwkJdW5zaWduZWQgbG9uZyBsZW5ndGg7


DQorCQlpbnQgZGlyOw0KKw0KKwkJaWYgKHBTUkItPlNSQkZsYWcgJiBBVVRP


X1JFUVNFTlNFKSB7DQorCQkJLyogTWFwIHNlbnNlIGJ1ZmZlciAqLw0KKwkJ


CWFkZHIJPSBwY21kLT5zZW5zZV9idWZmZXI7DQorCQkJbGVuZ3RoCT0gc2l6


ZW9mKHBjbWQtPnNlbnNlX2J1ZmZlcik7DQorCQkJZGlyCT0gRE1BX0ZST01f


REVWSUNFOw0KKwkJCURFQlVHMShwcmludGsoIiVzKCk6IE1hcHBlZCBzZW5z


ZSBidWZmZXIgJXAiLCBfX0ZVTkNUSU9OX18sIHBjbWQtPnNlbnNlX2J1ZmZl


cikpOw0KKwkJfSBlbHNlIHsNCisJCQkvKiBNYXAgc2luZ2xlIHNlZ21lbnQg


Ki8NCisJCQlhZGRyCT0gcGNtZC0+cmVxdWVzdF9idWZmZXI7DQorCQkJbGVu


Z3RoCT0gcGNtZC0+cmVxdWVzdF9idWZmbGVuOw0KKwkJCWRpcgk9IHNjc2lf


dG9fcGNpX2RtYV9kaXIocGNtZC0+c2NfZGF0YV9kaXJlY3Rpb24pOw0KKwkJ


CURFQlVHMShwcmludGsoIiVzKCk6IE1hcHBlZCByZXF1ZXN0IGJ1ZmZlciAl


cCIsIF9fRlVOQ1RJT05fXywgcGNtZC0+cmVxdWVzdF9idWZmZXIpKTsNCisJ


CX0NCisJCW1lbXNldCgmcFNSQi0+U2VnbWVudHgsIDAsIHNpemVvZihzdHJ1


Y3Qgc2NhdHRlcmxpc3QpKTsNCisJCXBTUkItPlNlZ21lbnR4LnBhZ2UJPSB2


aXJ0X3RvX3BhZ2UoYWRkcik7DQorCQlwU1JCLT5TZWdtZW50eC5sZW5ndGgJ


PSBsZW5ndGg7DQorCQlwU1JCLT5TZWdtZW50eC5vZmZzZXQJPSAodW5zaWdu


ZWQgbG9uZylhZGRyICYgflBBR0VfTUFTSzsNCisJCXBTUkItPnBTZWdtZW50


TGlzdAk9ICZwU1JCLT5TZWdtZW50eDsNCisJCXBTUkItPlNHY291bnQJCT0g


cGNpX21hcF9zZyhwZGV2LCAmcFNSQi0+U2VnbWVudHgsIDEsIGRpcik7DQor


CQljbWRwLT5zYXZlZF9kbWFfaGFuZGxlCT0gc2dfZG1hX2FkZHJlc3MoJnBT


UkItPlNlZ21lbnR4KTsNCisJCURFQlVHMShwcmludGsoIiBhdCAleFxuIiwg


Y21kcC0+c2F2ZWRfZG1hX2hhbmRsZSkpOw0KIAkJLyogVE9ETzogZXJyb3Ig


aGFuZGxpbmcgKi8NCi0JCXNnX2RtYV9sZW4oJnBTUkItPlNlZ21lbnR4KSA9


IHBjbWQtPnJlcXVlc3RfYnVmZmxlbjsNCi0JCXBTUkItPlNHY291bnQgPSAx


Ow0KLQkJcFNSQi0+cFNlZ21lbnRMaXN0ID0gKFBTR0wpICZwU1JCLT5TZWdt


ZW50eDsNCi0JCURFQlVHMShwcmludGsoIiVzKCk6IE1hcHBlZCByZXF1ZXN0


IGJ1ZmZlciAlcCBhdCAleFxuIiwgX19GVU5DVElPTl9fLCBwY21kLT5yZXF1


ZXN0X2J1ZmZlciwgY21kcC0+c2F2ZWRfZG1hX2hhbmRsZSkpOw0KKwkJaWYg


KHBTUkItPlNHY291bnQgIT0gMSkNCisJCQllcnJvciA9IDE7DQogCS8qIE5v


IG1hcHBpbmcgIT8gKi8JDQogICAgIAl9IGVsc2UNCiAJCXBTUkItPlNHY291


bnQgPSAwOw0K
---1463811839-445485992-1086387130=:5107--
