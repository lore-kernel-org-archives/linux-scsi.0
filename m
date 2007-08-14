From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] add container release logic - update fc transport to
	utilize it
Date: Tue, 14 Aug 2007 14:39:39 -0500
Message-ID: <1187120379.3393.40.camel@localhost.localdomain>
References: <1187266579.2918.15.camel@localhost.localdomain>
	 <1187119074.3393.30.camel@localhost.localdomain>
	 <46C201CD.4000907@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:52268 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759317AbXHNTjl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2007 15:39:41 -0400
In-Reply-To: <46C201CD.4000907@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.scsi.org, tore@linepro.no

On Tue, 2007-08-14 at 15:26 -0400, James Smart wrote:
> > Isn't a better way to handle it simply to give
> > transport_container_unregister() the semantics everyone is expecting
> > (i.e. to wait for everything to be tidied up and gone)?  That way none
> > of the transport classes needs updating, and we don't have to handle the
> > rather nasty release and unload races.
> 
> I was hoping you'd give some guidance. This area is black voodoo... :)
> 
> Sure - so are you suggesting that transport_container_unregister()
> continually loop until successful ?  If not, what other kind of semantic
> can we give it that we don't have to muck with the transport classes ?

Not looping no, but otherwise that's basically correct.

I was thinking of a wait_event driven system checking for
list_empty(cont->containers.k_list)

I'll cook up a patch.

James


