From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: question about sas_phy_alloc
Date: Tue, 9 Aug 2011 10:51:04 -0700
Message-ID: <20110809175111.GV4364@tux1.beaverton.ibm.com>
References: <Pine.LNX.4.64.1108081458370.22343@ask.diku.dk>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50880 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab1HIRvp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2011 13:51:45 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p79HSmwI022235
	for <linux-scsi@vger.kernel.org>; Tue, 9 Aug 2011 13:28:48 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p79Hp5fq415658
	for <linux-scsi@vger.kernel.org>; Tue, 9 Aug 2011 13:51:06 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p79DoqWQ028134
	for <linux-scsi@vger.kernel.org>; Tue, 9 Aug 2011 10:50:52 -0300
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108081458370.22343@ask.diku.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On Mon, Aug 08, 2011 at 03:03:06PM +0200, Julia Lawall wrote:
> The definition of sas_phy_free has the comment:
> 
>  * Note:
>  *   This function must only be called on a PHY that has not
>  *   successfully been added using sas_phy_add().
> 
> Does this mean that the function should only be used when a call to 
> sas_phy_add has taken place and that call has failed?  Or should it also 
> be used when sas_phy_add has not yet been called and an error occurs?
> 
> Concretely, I am wondering about the functions 
> mpt2sas_transport_add_host_phy and mpt2sas_transport_add_expander_phy in 
> the file drivers/scsi/mpt2sas/mpt2sas_transport.c.  Each function has a 
> potential failure on _transport_set_identify before sas_phy_add is called, 
> and I wonder if sas_phy_free should be called in these cases.

Based on my reading of all that code and my hazy memories of working on libsas,
to tear down a sas_phy that has not been sas_phy_add'd, one uses sas_phy_free.
To tear down a sas_phy that has been sas_phy_add'd, use sas_phy_delete.  More
concretely, I agree with you that mpt2sas needs a few more sas_phy_free's.

Shorter answer: {yes, yes, yes}. :)

--D
> 
> julia
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
