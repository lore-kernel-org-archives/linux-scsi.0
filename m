From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 19:04:58 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921180458.GF11446@parcelfarce.linux.theplanet.co.uk>
References: <B179AE41C1147041AA1121F44614F0B0DD04DD@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:45254 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267918AbUIUSFA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 14:05:00 -0400
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0DD04DD@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, Jesse Barnes <jbarnes@engr.sgi.com>, Grant Grundler <grundler@parisc-linux.org>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, Sep 21, 2004 at 10:33:36AM -0700, Andrew Vasquez wrote:
> Hmm...adding more confusion to the mix.  I apologize -- my reply was
> not written correctly, yes, the config-read will flush any pending
> writes.  But, the same problem persists -- the RISC will still stop
> responding to requests (config or MMIO) during the soft-reset -- 
> potentially resulting in a MAC (as seen by SGI).
> 
> The 'safe' solution (as suggested by the hw people) was to use PIO to
> issue the soft-reset, then udelay().  

Even that's not safe ;-(
This snippet is from pci 2.3 (section 3.2.5.2) but there's substantially
similar wording in pci 2.2:

  Host bus bridges are permitted to post I/O write transactions that
  originate on the host bus and complete on a PCI bus segment when they
  follow the ordering rules described in this specification and do not
  cause a deadlock. This means that when a host bus bridge posts an I/O
  write transaction that originated on the host bus, it must provide a
  deadlock free environment when the transaction completes on PCI. The
  transaction will complete on the destination PCI bus before completing
  on the originating PCI bus.

  Since memory write transactions may be posted in bridges anywhere
  in the system, and I/O writes may be posted in the host bus bridge,
  a master cannot automatically tell when its write transaction completes
  at the final destination. For a device driver to guarantee that a write
  has completed at the actual target (and not at an intermediate bridge),
  it must complete a read to the same device that the write targeted. The
  read (memory or I/O) forces all bridges between the originating master
  and the actual target to flush all posted data before allowing the
  read to complete. For additional details on device drivers, refer to
  Section 6.5. Refer to Section 3.10., item 6, for other cases where a
  read is necessary.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
