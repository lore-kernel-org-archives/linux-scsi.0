From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: need help solving mpt2sas target unplug can hang worker thread
Date: Tue, 20 Mar 2012 17:24:20 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A6067E7324D5@inbmail02.lsi.com>
References: <20120214131541.GA28005@crust.elkhashab.com>
 <A6888A6805518E4EA4AF7072A28264A6067E49FF7F@inbmail02.lsi.com>
 <20120222001650.GA16640@crust.elkhashab.com>
 <A6888A6805518E4EA4AF7072A28264A6067E672DE4@inbmail02.lsi.com>
 <20120309005440.GA28098@crust.elkhashab.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_A6888A6805518E4EA4AF7072A28264A6067E7324D5inbmail02lsic_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:46253 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757346Ab2CTLy0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 07:54:26 -0400
In-Reply-To: <20120309005440.GA28098@crust.elkhashab.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ayman El-Khashab <ayman@elkhashab.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

--_002_A6888A6805518E4EA4AF7072A28264A6067E7324D5inbmail02lsic_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Can you try this patch and test?

Regards,
Nagalakshmi


-----Original Message-----
From: Ayman El-Khashab [mailto:ayman@elkhashab.com]=20
Sent: Friday, March 09, 2012 6:25 AM
To: Nandigama, Nagalakshmi; linux-scsi@vger.kernel.org
Subject: Re: need help solving mpt2sas target unplug can hang worker thread

On Tue, Feb 28, 2012 at 05:18:53PM +0530, Nandigama, Nagalakshmi wrote:
> It seems like you are using older version of mpt2sas driver. Current vers=
ion of mpt2sas driver is 12.100.00.00. Will it be possible to you to test w=
ith the latest or any stable driver? Also can you take update the latest fi=
rmware?
>=20

Ok, I've got now 12.0.0 that I pulled from git.  While it
compiles clean, I can't get far with it b/c it hangs my
system when I insmod the driver.  In the past, I have had to
apply this patch that I submitted long ago and never got
used.

* http://lkml.indiana.edu/hypermail/linux/kernel/1107.1/02101.html

* Changed the type of chip_phys from a u64 to a phys_addr_t.
* Changed ifdef from BITS_PER_LONG to CONFIG_ARCH_DMA_ADDR_T_64BIT so that
* it works on 32 bit systems that have pci address spaces larger than 32
* bits.

I am doing this on a powerpc 460SX with a sas 2008 part,=20
firmware v 9.0

In any case, it doesn't appear that the I need the #ifdef
anymore, but replacing the u64 with phys_addr_t might still
be required. =20

After trying to load the code against 2.6.37, the code
spins infinately in the loop around line 2613 in the
mpt2sas_base.c -- this code specifically.  I added prints in
the loop, so I observed it never got out of this for loop.
It spun until I got this message: ttyS0: 1 input overrun(s)
Without any printks it just sits here for ever with this
being the last printk reached.

    printk("chain_depth =3D %d\n", ioc->chain_depth);
    for (i =3D 0; i < ioc->chain_depth; i++) {
        ioc->chain_lookup[i].chain_buffer =3D pci_pool_alloc(
            ioc->chain_dma_pool , GFP_KERNEL,
            &ioc->chain_lookup[i].chain_buffer_dma);
        if (!ioc->chain_lookup[i].chain_buffer) {
            ioc->chain_depth =3D i;
            goto chain_done;
        }
        total_sz +=3D ioc->request_sz;
    }

Not really sure why it is stuck in this loop and don't know
the best way to debug this.

Thanks
Ayman

--_002_A6888A6805518E4EA4AF7072A28264A6067E7324D5inbmail02lsic_
Content-Type: application/octet-stream; name="chain_lookup_err.patch"
Content-Description: chain_lookup_err.patch
Content-Disposition: attachment; filename="chain_lookup_err.patch"; size=695;
	creation-date="Tue, 20 Mar 2012 11:50:01 GMT";
	modification-date="Tue, 20 Mar 2012 11:51:42 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9tcHQyc2FzL21wdDJzYXNfYmFzZS5jIGIvZHJpdmVy
cy9zY3NpL21wdDJzYXMvbXB0MnNhc19iYXNlLmMKaW5kZXggZTgxY2QwNy4uMGU1OWMzOCAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zY3NpL21wdDJzYXMvbXB0MnNhc19iYXNlLmMKKysrIGIvZHJpdmVy
cy9zY3NpL21wdDJzYXMvbXB0MnNhc19iYXNlLmMKQEAgLTI3NTEsNiArMjc1MSwxMSBAQCBfYmFz
ZV9hbGxvY2F0ZV9tZW1vcnlfcG9vbHMoc3RydWN0IE1QVDJTQVNfQURBUFRFUiAqaW9jLCAgaW50
IHNsZWVwX2ZsYWcpCiAJaW9jLT5jaGFpbl9wYWdlcyA9IGdldF9vcmRlcihzeik7CiAJaW9jLT5j
aGFpbl9sb29rdXAgPSAoc3RydWN0IGNoYWluX3RyYWNrZXIgKilfX2dldF9mcmVlX3BhZ2VzKAog
CSAgICBHRlBfS0VSTkVMLCBpb2MtPmNoYWluX3BhZ2VzKTsKKwlpZiAoIWlvYy0+Y2hhaW5fbG9v
a3VwKSB7CisJCXByaW50ayhNUFQyU0FTX0VSUl9GTVQgImNoYWluX2xvb2t1cDogX19nZXRfZnJl
ZV9wYWdlcyAiCisJCQkiZmFpbGVkXG4iLCBpb2MtPm5hbWUpOworCQlnb3RvIG91dDsKKwl9CiAJ
aW9jLT5jaGFpbl9kbWFfcG9vbCA9IHBjaV9wb29sX2NyZWF0ZSgiY2hhaW4gcG9vbCIsIGlvYy0+
cGRldiwKIAkgICAgaW9jLT5yZXF1ZXN0X3N6LCAxNiwgMCk7CiAJaWYgKCFpb2MtPmNoYWluX2Rt
YV9wb29sKSB7Cgo=

--_002_A6888A6805518E4EA4AF7072A28264A6067E7324D5inbmail02lsic_--
