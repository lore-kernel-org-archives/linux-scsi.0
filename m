From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Sat, 28 Dec 2002 14:02:17 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <775808112.1041109337@aslan.scsiguy.com>
References: <200212282016.gBSKGrF03354@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <200212282016.gBSKGrF03354@localhost.localdomain>
Content-Disposition: inline
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Rik van Riel <riel@conectiva.com.br>, Tomas Szepe <szepe@pinerecords.com>, Marcelo Tosatti <marcelo@conectiva.com.br>, Samuel Flory <sflory@rackable.com>, Janet Morgan <janetmor@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

> gibbs@scsiguy.com said:
>> That hasn't applied since 6.2.10 or so.  2.5.X is still using 6.2.4. 
> 
> The bug report is against 2.5.53 which has 6.2.24 in it, so it still
> needs  fixing.  At a cursory glance at the code, it looks like you don't
> call  scsi_set_pci_device early enough in the detect routine.

I don't see how this enters into it.  The dma mask should be set on
the PCI device in aic7xxx_osm_pci.c just after we enable the device
and set it as a bus master.  The pci device is setup in the host
structure as it is allocated and before it is registered with the
SCSI subsystem.  I can't imagine that the merge function (and thereby
the bounce limit) is selected before the host is even registered.
My guess is that the original call to setup the PCI mask is not happening
due to either a logic bug in ahc_linux_get_memsize() or the logic that
interprets its response in aic7xxx_osm_pci.c.

I'm not in front of a Linux system to debug this, so all I can do is
inspect the code right now.  Perhaps someone with an affected machine
can toss in a few printks and figure this out?

--
Justin
