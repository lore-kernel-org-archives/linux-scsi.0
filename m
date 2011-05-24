From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH]: be2iscsi: Fix MSIX interrupt names
Date: Tue, 24 May 2011 17:09:50 +0200
Message-ID: <1355717.cj2chV3kM3@donald.sf-tec.de>
References: <4DD6AEB7.2090900@redhat.com> <2030549.qtzsKLDxZd@donald.sf-tec.de> <4DDBC529.9020008@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5967075.qcDUxrQa0n"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:48415 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab1EXPKC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2011 11:10:02 -0400
In-Reply-To: <4DDBC529.9020008@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-scsi@vger.kernel.org, Jayamohan.Kallickal@emulex.com, mchristi@redhat.com


--nextPart5967075.qcDUxrQa0n
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

Am Dienstag, 24. Mai 2011, 10:48:09 schrieb Prarit Bhargava:
> On 05/20/2011 04:17 PM, Rolf Eike Beer wrote:
> > This could be simpler if you would use devres and devm_kzalloc() and
> > devm_request_irq(). You simply need to return with error then and the
> > driver core would free everything you already allocated.
> > 
> > Eike
> 
> Thanks for the suggestion Eike.
> 
> I've never used devres before.  This seems to work -- please review as [v3].

No, sorry, this wont work. You need to change your call of pci_enable_device() 
to pcim_enable_device(). Afterwards you should check what else in your probe 
routine can be converted to devres. This is optional, but why duplicate work?

What you need to take care of: resources that you do not allocate by devres 
(e.g. the scsi_host) and which are explicitely freed by you must not be needed 
e.g. in the IRQ handler if that would be freed by devres, i.e.:

int ret;
pcim_enable_device()
beiscsi_hba_alloc()
devm_request_irq()

ret = something();
if (ret != 0) {
 beiscsi_free_hba();
 return ret;
}
// devres would now free IRQs etc.

If an IRQ happens right before it is freed by devres (which could e.g. happen 
if you enable IRQ debugging) you could hit a NULL or stale host pointer. If 
your IRQ handler requires some resources to always be present (e.g. the 
scsi_host) then you must explicitely deregister it before releasing those 
resources. At the end this makes the init savings void. So you better add a 
single check

if (unlikely(my_hba == NULL))
  return IRQ_NONE;

to your IRQ handler to be safe.

Eike
--nextPart5967075.qcDUxrQa0n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk3byj4ACgkQXKSJPmm5/E7mCwCcCkgEwysMmtqCaf+jOl4Ezn7e
sVkAn2Golp/LTTk8oshRJ9mTu87J8lFA
=//9L
-----END PGP SIGNATURE-----

--nextPart5967075.qcDUxrQa0n--

