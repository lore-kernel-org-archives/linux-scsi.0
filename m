From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC] FC pass thru - Rev V
Date: Thu, 12 Feb 2009 01:33:48 +0900
Message-ID: <20090212013215L.fujita.tomonori@lab.ntt.co.jp>
References: <1227043498.4949.21.camel@ogier>
	<1234365225.24194.3.camel@ogier>
	<4992F98B.1060401@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:35687 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755778AbZBKQeN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2009 11:34:13 -0500
In-Reply-To: <4992F98B.1060401@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org, seokmann.ju@qlogic.com, andrew.vasquez@qlogic.com, sven@linux.vnet.ibm.com, futjita.tomonori@lab.ntt.co.jp

On Wed, 11 Feb 2009 18:15:07 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> James Smart wrote:
> > Trying to kick-start this again...  
> > I've updated the prior RFC with the comments from Seokmann,
> > SvenFujita, and Boaz. I would still like review on the
> > blk_xxx completion calls in the std and error paths.
> > 
> > It currently expects that blk_end_request() has been updated
> > by Fujita's patch to incorporate blk_end_bidi_request()
> > functionality :
> > http://marc.info/?l-linux-scsi&m=122785157116659&w=2
> > 
> 
> I did not accept this patch and it did not go in right?

I think that Jens has not merged mine or yours. I don't care about
either but I still think that it's better to kill
blk_end_bidi_request(). It's really confusing API.


> I still don't like it, it's a performance regression.

Hmm, I've not seen the figures. Please show the figures if you insist
a performance regression.

It's about a bidi request. We already have tons of loops, memory
allocations, etc in the path. Do you think that adding one more loop
leads to a notable performance regression?

Well, if you say that it's hacky then I would agree. But your patch
using ~0 is hacky too.
