From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Adaptec 2200S with aacraid won't do 64-bit
Date: Tue, 22 Feb 2005 21:55:41 +0000
Message-ID: <20050222215541.GO28741@parcelfarce.linux.theplanet.co.uk>
References: <60807403EABEB443939A5A7AA8A7458BCDC69E@otce2k01.adaptec.com> <049d01c51928$7a83a040$de0167cf@voicenet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:28620 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261287AbVBVVzn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Feb 2005 16:55:43 -0500
Content-Disposition: inline
In-Reply-To: <049d01c51928$7a83a040$de0167cf@voicenet.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tim Wesemann <timuel@voicenet.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, linux-scsi@vger.kernel.org

On Tue, Feb 22, 2005 at 04:50:00PM -0500, Tim Wesemann wrote:
> I was apparently incorrectly basing it on the register's address space from 
> the lspci output. Can you perhaps help me tell a better way to tell if my 
> 2200S card is using "64-bit mode" (as in whatever the hell marketing people 
> mean by 64-bit).

I don't think your problem is "64 bit mode", whatever you mean by that.

> My problem is in a nutshell -- performance. I can't get anything above 
> 40MB/s writes with this card with 5 15k-spin U320 disks in a raid5. I can 
> get better throughput with with a software raid5 running off of my on-board 
> AIC-7902 also running at 66MHz  (but presumably in 64 bit mode), but I need 
> to use this card...

That sounds like the bus is in single-ended mode (which is limited to 40MB/s)
rather than LVD.  Check cabling, terminators, etc.

> Does this mean that PCI won't use "64-bit mode" (as in whatever the hell 
> marketing people mean by 64-bit) unless I have 4GB of system memory?

There's 64-bit *transfers* and 64-bit *addressing* ... but let's not
go into that; the problem isn't on the PCI bus, it's on the SCSI bus.
Even 32-bit, 33MHz PCI is capable of at least 80MB/s.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
