From: David Miller <davem@davemloft.net>
Subject: Re: qlogicpti driver hangs the machine
Date: Tue, 23 Sep 2008 21:25:13 -0700 (PDT)
Message-ID: <20080923.212513.184633012.davem@davemloft.net>
References: <Pine.SOC.4.64.0809231753570.14966@math.ut.ee>
	<20080923155917.GE27204@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33354
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751166AbYIXEZZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2008 00:25:25 -0400
In-Reply-To: <20080923155917.GE27204@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: mroos@linux.ee, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org

From: Matthew Wilcox <matthew@wil.cx>
Date: Tue, 23 Sep 2008 09:59:18 -0600

> On Tue, Sep 23, 2008 at 06:06:03PM +0300, Meelis Roos wrote:
> > I tried to use Qlogic wide SE SCSI SBus controllers. First tied one in 
> > Sparcstation 5 (sparc32) with etch and sarge installers, then tried 
> > another in E3500. Both tries on SS5 hung when loadin qlogicpti module. 
> > E3500 conf doesn't autoload SBus drivers and the card was properly 
> > inserted only after installation, so I tried to modprobe qlogicpti after 
> > booting up. This also results in a hang but outputs that much on console 
> > before hanging. Maybe the error handling spinlock lockup gives a clue to 
> > someone...
> 
> What kernel version is this trace from?

FWIW, I personally haven't tested this driver in a long time, did
anyone give it at least a simple test when you made those
->slave_configure changes to this driver?

I'm talking about this one:

commit 9ec76fbf7d6da3e98070a7059699d0ca019b0c9b
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Mon Oct 1 08:07:52 2007 -0600

    [SCSI] qlogicpti: Add a slave_configure method
    
    By configuring targets in slave_configure, we can eliminate a shadow
    queuecommand, a shadow scsi_done, a write to the host template, abuse of
    SCp->Message and SCp->Status, a use of kmap_atomic() and sniffing the
    results of INQUIRY.
    
    Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
    Acked-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>


