From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 17:25:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921162535.GB11446@parcelfarce.linux.theplanet.co.uk>
References: <B179AE41C1147041AA1121F44614F0B0012AD90D@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:20412 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267828AbUIUQZg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 12:25:36 -0400
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0012AD90D@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jesse Barnes <jbarnes@engr.sgi.com>, Grant Grundler <grundler@parisc-linux.org>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, Sep 21, 2004 at 08:58:23AM -0700, Andrew Vasquez wrote:
> From what I can gather from the hw engineers, the config-read will not
> guarantee a flush of posted writes.

I believe your hardware engineers to be mistaken.  See PCI 2.2, Appendix
E, section E.2:

2. Memory writes can be posted in both directions in a bridge. I/O and
   Configuration writes are not posted. (I/O writes can be posted in the
   Host Bridge, but some restrictions apply.) Read transactions (Memory,
   I/O, or Configuration) are not posted.

5. A read transaction must push ahead of it through the bridge any posted
   writes originating on the same side of the bridge and posted before the
   read. Before the read transaction can complete on its originating bus,
   it must pull out of the bridge any posted writes that originated on
   the opposite side and were posted before the read command completes
   on the read-destination bus.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
