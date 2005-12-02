From: Hugh Dickins <hugh@veritas.com>
Subject: Re: Fw: crash on x86_64 - mm related?
Date: Fri, 2 Dec 2005 20:47:45 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0512022041130.6058@goblin.wat.veritas.com>
References: <20051129092432.0f5742f0.akpm@osdl.org>
 <Pine.LNX.4.63.0512012040390.5777@kai.makisara.local>
 <Pine.LNX.4.64.0512011136000.3099@g5.osdl.org> <1133468882.5232.14.camel@mulgrave>
 <Pine.LNX.4.63.0512012304240.5777@kai.makisara.local>
 <Pine.LNX.4.61.0512021325020.1507@goblin.wat.veritas.com>
 <Pine.LNX.4.63.0512021932590.4506@kai.makisara.local>
 <Pine.LNX.4.61.0512021836100.4940@goblin.wat.veritas.com>
 <Pine.LNX.4.63.0512022131440.4506@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from silver.veritas.com ([143.127.12.111]:25719 "EHLO
	silver.veritas.com") by vger.kernel.org with ESMTP id S1750816AbVLBUr6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Dec 2005 15:47:58 -0500
Received: from linux.wat.veritas.com([10.10.97.50]) (2506 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1EiHoo-0001EbC@megami.veritas.com>
	for <linux-scsi@vger.kernel.org>; Fri, 2 Dec 2005 12:47:46 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
In-Reply-To: <Pine.LNX.4.63.0512022131440.4506@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@osdl.org>, Ryan Richter <ryan@tau.solarneutrino.net>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2 Dec 2005, Kai Makisara wrote:
> On Fri, 2 Dec 2005, Hugh Dickins wrote:
> 
> > It's just that after seeing how sg.c is claiming to dirty even readonly
> > memory, I'm excessively averse to saying we've dirtied memory we haven't.
> > My hangup, I'll get over it!
> > 
> Please don't. I have a very conservative attitude to these things: my 
> priority is to make sure that the data is correct even if it is not the 
> fastest code. I will happily let others point out when I am too 
> conservative.

I'm not certain which way you're directing me now: a conservative
attitude suggests we play safe at the end of st_read, by saying we might
somehow have dirtied memory there, perhaps if someone changes sequence.

As I presently, incompletely have it, to maintain more similarity with
sg.c, I've actually moved away from "dirtied" to "rw" READ or WRITE,
and it will look odd to put WRITE at the end of st_read.

I'm giving up for the evening, and probably won't have a chance to do
more until Sunday - the PageCompound issue still under discussion too.

Hugh
