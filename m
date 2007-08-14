From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] add container release logic - update fc transport to
	utilize it
Date: Tue, 14 Aug 2007 14:17:54 -0500
Message-ID: <1187119074.3393.30.camel@localhost.localdomain>
References: <1187266579.2918.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:44301 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758469AbXHNTR7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2007 15:17:59 -0400
In-Reply-To: <1187266579.2918.15.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.scsi.org, tore@linepro.no

On Thu, 2007-08-16 at 08:16 -0400, James Smart wrote:
> Consistent with the code in the rest of the transports, when the driver
> module attached or detached to a transport, the transport ignored the
> statuses from transport_container_register() and transport_container_unregister().
> This was particularly bad on the unregister path, because the transport would
> free the transport-internal structure that held all the attribute 
> containers. Thus, if a driver was told to unload, and the unload path
> completed faster than the tear down of the scsi object tree (as a sysfs attribute
> was in use at the time, or whatever), you could get into ugly reuse of a freed
> internal structure. 
> 
> Given that this is a module-global thing, there's no real relationship to
> the create/release (or refcounting) of the device objects that eventually
> bind to the structure.
> 
> I modified the container logic to potentially call back the container owner
> whenever all objects on the container were freed. This allowed the release to
> happen in the background to the LLDD removal.
> 
> Assuming this is how we want to handle this scenario, the other SCSI transports
> need to be updated accordingly.

I'm afraid if you look at your solution, you'll see it still doesn't
quite work:  If the next thing the user does after unloading lpfc is to
unload the transport class, the module is blown away with potentially a
live release callback to now freed code.

Isn't a better way to handle it simply to give
transport_container_unregister() the semantics everyone is expecting
(i.e. to wait for everything to be tidied up and gone)?  That way none
of the transport classes needs updating, and we don't have to handle the
rather nasty release and unload races.

James


