From: Matthew Wilcox <willy@debian.org>
Subject: Re: DAC960 + sym53c8xx conflict
Date: Tue, 17 Aug 2004 01:09:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040817000951.GI28995@parcelfarce.linux.theplanet.co.uk>
References: <1092628387.2548.14.camel@fs2> <20040816112034.GC28995@parcelfarce.linux.theplanet.co.uk> <1092699047.6936.11.camel@fs2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:16788 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S268031AbUHQAJx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2004 20:09:53 -0400
Content-Disposition: inline
In-Reply-To: <1092699047.6936.11.camel@fs2>
List-Id: linux-scsi@vger.kernel.org
To: Michael <mozstuff@yahoo.com>
Cc: Matthew Wilcox <willy@debian.org>, linux-scsi@vger.kernel.org

On Mon, Aug 16, 2004 at 06:30:47PM -0500, Michael wrote:
> On 2.6 I get the message you list as well. I thought maybe 2.6 wasn't
> actually recognizing the raid controller, so I disabled support for the
> 896 chip in the driver so it gives an "unsupported" message, but I still
> lose the dac960 drives.

Crap, I see the problem.  When we fail initialisation, we disable the
device, so DAC960 stops working.  Either we need to not disable the device
when exiting or we need to claim the sym2 device in the dac960 driver
so the sym2 driver never gets called.

I'm going to be away till the end of the week, but for the moment, deleting

        pci_release_regions(pdev);
and
        pci_disable_device(pdev);

from sym2_probe() in drivers/scsi/sym53c8xx_2/sym_glue.c should fix
your problem.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
