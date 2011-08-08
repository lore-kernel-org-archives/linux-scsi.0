From: Julia Lawall <julia@diku.dk>
Subject: question about sas_phy_alloc
Date: Mon, 8 Aug 2011 15:03:06 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1108081458370.22343@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:36190 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab1HHNDL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2011 09:03:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

The definition of sas_phy_free has the comment:

 * Note:
 *   This function must only be called on a PHY that has not
 *   successfully been added using sas_phy_add().

Does this mean that the function should only be used when a call to 
sas_phy_add has taken place and that call has failed?  Or should it also 
be used when sas_phy_add has not yet been called and an error occurs?

Concretely, I am wondering about the functions 
mpt2sas_transport_add_host_phy and mpt2sas_transport_add_expander_phy in 
the file drivers/scsi/mpt2sas/mpt2sas_transport.c.  Each function has a 
potential failure on _transport_set_identify before sas_phy_add is called, 
and I wonder if sas_phy_free should be called in these cases.

julia
