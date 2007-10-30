From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH] sysfs: add filter function to groups
Date: Tue, 30 Oct 2007 09:55:08 +0100
Message-ID: <20071030095508.00a24b8f@gondolin.boeblingen.de.ibm.com>
References: <1193671019.3383.13.camel@localhost.localdomain>
	<1193676852.2655.21.camel@lov.site>
	<1193677071.3383.56.camel@localhost.localdomain>
	<20071029181814.25410e00@gondolin.boeblingen.de.ibm.com>
	<1193678646.3383.76.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:65223 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbXJ3I4B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Oct 2007 04:56:01 -0400
In-Reply-To: <1193678646.3383.76.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 29 Oct 2007 12:24:06 -0500,
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> > Can you determine which subset of the attributes you want just before
> > actually creating the group? Then you could do something like:
> > 
> > create_group(grp, kobj)
> > {
> > 	grp->update_creation_mask(kobj);
> > 	actually_create_attrs();
> > }
> 
> That's actually what we currently do (at least in hand coded form) in
> the current transport classes.  However, it leads to one separate group
> for each attached class.  With the filter approach, we only need one
> constructed group for every transport class.

I meant doing it in the core. You still have one group for all cases,
but immediately before creating the attributes, the core checks back
which ones it should create. (Of course, that doesn't solve your
problems if you dynamically want to change availability of attributes
later on. You would need a different mechanism for that.)
