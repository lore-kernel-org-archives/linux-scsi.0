From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH-FOR-38] target: Fix READ_CAPACITY_16 regression
Date: Fri, 11 Mar 2011 18:40:43 -0800
Message-ID: <20110311184043.6438fe31.akpm@linux-foundation.org>
References: <1299109971-27268-1-git-send-email-nab@linux-iscsi.org>
	<1299885455.6938.6.camel@mulgrave.site>
	<1299894371.31170.4.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753317Ab1CLCmV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2011 21:42:21 -0500
In-Reply-To: <1299894371.31170.4.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Ben Jarvis <bjarvismn@gmail.com>

On Fri, 11 Mar 2011 17:46:11 -0800 "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> On Fri, 2011-03-11 at 17:17 -0600, James Bottomley wrote:
> > On Wed, 2011-03-02 at 15:52 -0800, Nicholas A. Bellinger wrote:
> > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > > 
> > > Hi James,
> > > 
> > > This patch fixes a regression for READ_CAPACITY to trigger SAI READ_CAPACITY_16 for
> > > >= 0xffffffff virtual backends.  This occured during v4.0.0-rc6 when the backend
> > > read_capacity* handlers where moved into generic target_core_cdb.c code, and the
> > > 'unsigned long long blocks_long' piece was dropped from target_emulate_readcapacity().
> > > 
> > > This fix has been tested with TCM_Loop on .38-rc7 with lio-4.1 and is working as expected
> > > with large block virtual backends:
> > > 
> > > [67826.897061] TARGET_CORE[loopback]->TPG[1]_LUN[0] - Adding READ-WRITE access for LUN in Demo Mode
> > > [67826.897061] scsi 7:0:1:0: Direct-Access     LIO-ORG  FILEIO           4.0  PQ: 0 ANSI: 5
> > > [67826.900933] sd 7:0:1:0: [sdd] 2621440000001 512-byte logical blocks: (1.34 PB/1.19 PiB)
> > > [67826.901510] sd 7:0:1:0: [sdd] Write Protect is off
> > > [67826.901684] sd 7:0:1:0: [sdd] Mode Sense: 2f 00 00 00
> > > 
> > > Please include into scsi-rc-fixes going to Linus for-38 mainline target code.
> > 
> > So the piece you didn't say is that this only affects volumes >2TB
> > volume which misreport the capacity (which is actually what the bug
> > description should have been).
> > 
> > That's hardly an oopsworthy fix at this stage ... I'll put it into misc
> > with a cc stable.
> > 
> 
> This has already been picked up by AKPM last week, and (I assume) will
> be queued to Linus for .38-FINAL via -mm.

Not really.  I often grab important-looking fixes which cross my
desk, in case they end up getting mis-scheduled or mislaid.

> Considering that is a critical fix that is not trigger by some obsecure
> corner case, I am not sure why this would be deferred for for a
> v2.6.38.x release when we already have a proper fix in place..?

2.6.38.1 is OK.  No sane people will run 2.6.38 anyway ;)
