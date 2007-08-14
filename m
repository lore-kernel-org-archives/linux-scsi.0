From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] add container release logic - update fc transport to
 utilize it
Date: Tue, 14 Aug 2007 15:26:05 -0400
Message-ID: <46C201CD.4000907@emulex.com>
References: <1187266579.2918.15.camel@localhost.localdomain> <1187119074.3393.30.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:35511 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630AbXHNT0K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2007 15:26:10 -0400
In-Reply-To: <1187119074.3393.30.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.scsi.org, tore@linepro.no

James Bottomley wrote:
> I'm afraid if you look at your solution, you'll see it still doesn't
> quite work:  If the next thing the user does after unloading lpfc is to
> unload the transport class, the module is blown away with potentially a
> live release callback to now freed code.

You're right...  Although, most don't as the transports are dependencies
for the LLDD's, and it's only the LLDDs they care about. But, point taken.

> Isn't a better way to handle it simply to give
> transport_container_unregister() the semantics everyone is expecting
> (i.e. to wait for everything to be tidied up and gone)?  That way none
> of the transport classes needs updating, and we don't have to handle the
> rather nasty release and unload races.

I was hoping you'd give some guidance. This area is black voodoo... :)

Sure - so are you suggesting that transport_container_unregister()
continually loop until successful ?  If not, what other kind of semantic
can we give it that we don't have to muck with the transport classes ?

-- james s


