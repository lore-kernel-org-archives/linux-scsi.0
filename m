From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Display SPI transfer agreement in common code
Date: Sun, 6 Mar 2005 17:53:21 +0000
Message-ID: <20050306175321.GU28741@parcelfarce.linux.theplanet.co.uk>
References: <20050306171817.GS28741@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:30675 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261448AbVCFRxV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Mar 2005 12:53:21 -0500
Content-Disposition: inline
In-Reply-To: <20050306171817.GS28741@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Sun, Mar 06, 2005 at 05:18:17PM +0000, Matthew Wilcox wrote:
> Introduce a generic SPI function to print the negotiated transfer
> agreement.  It's based on the implementation in sym53c8xx_2/sym_misc.c.
> I have changes in my tree to make 53c700, ncr53c8xx and sym2 use it.
> Other drivers need to be converted to use the SPI transport layer first.

I'd just like to have a quick discussion about this actually.  I'd like
to reduce the SCSI verbosity at boot.  Currently, the sym2 driver does
something like this:

scsi1 : sym-2.2.0
  Vendor: SEAGATE   Model: ST39204LC         Rev: HP04
  Type:   Direct-Access                      ANSI SCSI revision: 03
 target1:0:6: tagged command queuing enabled, command queue depth 16.
 target1:0:6: Beginning Domain Validation
 target1:0:6: asynchronous.
 target1:0:6: wide asynchronous.
 target1:0:6: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 16)
 target1:0:6: Ending Domain Validation

I don't think it's terribly useful to print out all the intermediate
steps, so I'd like to introduce a flag that would inhibit printing the
transfer agreement and then print it once at the end, leaving to messages
more like:

scsi1 : sym-2.2.0
  Vendor: SEAGATE   Model: ST39204LC         Rev: HP04
  Type:   Direct-Access                      ANSI SCSI revision: 03
 target1:0:6: tagged command queuing enabled, command queue depth 16.
 target1:0:6: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 16)

My impression is that James originally added the Beginning and Ending
messages to indicate that messages in between were produced as a result
of doing DV, and if no messages are produced, we don't need to print them
any more.  That saves us 4 lines per target.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
