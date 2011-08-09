From: Julia Lawall <julia@diku.dk>
Subject: Re: question about sas_phy_alloc
Date: Tue, 9 Aug 2011 20:30:37 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1108092030170.17143@ask.diku.dk>
References: <Pine.LNX.4.64.1108081458370.22343@ask.diku.dk>
 <20110809175111.GV4364@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:39280 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab1HISap (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2011 14:30:45 -0400
In-Reply-To: <20110809175111.GV4364@tux1.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On Tue, 9 Aug 2011, Darrick J. Wong wrote:

> On Mon, Aug 08, 2011 at 03:03:06PM +0200, Julia Lawall wrote:
> > The definition of sas_phy_free has the comment:
> > 
> >  * Note:
> >  *   This function must only be called on a PHY that has not
> >  *   successfully been added using sas_phy_add().
> > 
> > Does this mean that the function should only be used when a call to 
> > sas_phy_add has taken place and that call has failed?  Or should it also 
> > be used when sas_phy_add has not yet been called and an error occurs?
> > 
> > Concretely, I am wondering about the functions 
> > mpt2sas_transport_add_host_phy and mpt2sas_transport_add_expander_phy in 
> > the file drivers/scsi/mpt2sas/mpt2sas_transport.c.  Each function has a 
> > potential failure on _transport_set_identify before sas_phy_add is called, 
> > and I wonder if sas_phy_free should be called in these cases.
> 
> Based on my reading of all that code and my hazy memories of working on libsas,
> to tear down a sas_phy that has not been sas_phy_add'd, one uses sas_phy_free.
> To tear down a sas_phy that has been sas_phy_add'd, use sas_phy_delete.  More
> concretely, I agree with you that mpt2sas needs a few more sas_phy_free's.
> 
> Shorter answer: {yes, yes, yes}. :)

OK, thanks.  I will submit a patch.

julia
