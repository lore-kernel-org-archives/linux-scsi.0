From: Matthew Wilcox <willy@debian.org>
Subject: Re: recent sym2 breakage
Date: Mon, 16 Aug 2004 12:42:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040816114227.GD28995@parcelfarce.linux.theplanet.co.uk>
References: <20040816000146.3f484151.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:26303 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267552AbUHPLm2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2004 07:42:28 -0400
Content-Disposition: inline
In-Reply-To: <20040816000146.3f484151.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, linuxppc64-dev@lists.linuxppc.org

On Mon, Aug 16, 2004 at 12:01:46AM -0700, Andrew Morton wrote:
> It runs OK, but a `halt -p' spits nasty messages, then hangs.
> 
> Can someone suggest what changes caused this?

Reviewing the diff between 2.6.7 and 2.6.8.1 doesn't show any significant
changes to the sym2 driver (lots of 0/NULL changes, and ppc64 is weird,
but not /that/ weird ;-)

So it must be something sym2 is using.  The obvious candidate is the
change to drivers/scsi/scsi_transport_spi.c in the spi_dv_retrain
function.  If you pull that out, does it work better?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
