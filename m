From: "Yu, Luming" <luming.yu@intel.com>
Subject: RE: [linux-usb-devel] Re: Linux 2.6.16-rc3
Date: Wed, 15 Feb 2006 13:58:51 +0800
Message-ID: <3ACA40606221794F80A5670F0AF15F840AF2824B@pdsmsx403>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-acpi-owner@vger.kernel.org
To: Sanjoy Mahajan <sanjoy@mrao.cam.ac.uk>, "Brown, Len" <len.brown@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>, akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org, axboe@suse.de, James.Bottomley@steeleye.com, greg@kroah.com, linux-acpi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, lk@bencastricum.nl, helgehaf@aitel.hist.no, fluido@fluido.as, gbruchhaeuser@gmx.de, Nicolas.Mailhot@LaPoste.net, perex@suse.cz, tiwai@suse.de, patrizio.bassi@gmail.com, bni.swe@gmail.com, arvidjaar@mail.ru, p_christ@hol.gr, ghrt@dial.kappa.ro, jinhong.hu@gmail.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, bcrl@kvack.org
List-Id: linux-scsi@vger.kernel.org

>> I don't think anybody claimed this isn't a regression for the 600X.
>
>I narrowed it further.  The short story is that this commit (diff below
>sig) makes the second S3 sleep go into the endless loop, if the loaded
>modules are exactly thermal, processor, intel_agp, and agpgart:

If you believe this patch is the root cause of the regression you have
been seeing. Then, I would say the thing is a little bit different with
ec_intr=0 and ec_intr=1. Basically, ec_intr=0 will disable EC related
ACPI interrupt before finishing _Qxx method execution , but ec_intr=1
always enable EC interrupt.  This could cause some hardware/BIOS
events get lost under ec_intr=0, which shouldn't lost.

We need to figure out what's going on here rather than falling back to
ec_intr=0 behavior.

--Luming
