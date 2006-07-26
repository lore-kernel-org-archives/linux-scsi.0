From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] fc transport: extensions for fast fail and dev loss
Date: Tue, 25 Jul 2006 23:33:53 -0400
Message-ID: <44C6E2A1.7070609@emulex.com>
References: <1150829123.16981.1.camel@localhost.localdomain> <44C65116.3030503@cs.wisc.edu> <44C667AD.8090604@emulex.com> <44C689E1.7030709@sgi.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:65195 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932514AbWGZDmA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jul 2006 23:42:00 -0400
In-Reply-To: <44C689E1.7030709@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, aherrman@de.ibm.com, Christoph Hellwig <hch@infradead.org>, duane.grigsby@qlogic.com, "Moore, Eric Dean" <Eric.Moore@lsil.com>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>, Jeremy Higdon <jeremy@sgi.com>

Michael Reed wrote:

> Haven't most drivers / board firmware generally cleaned up any outstanding
> i/o at the time (or shortly thereafter) of the fc_remote_port_delete()
> call?  I would think it reasonable to just require that the driver clean
> up the i/o after calling fc_remote_port_delete().  Is there a significant
> reason to keep the i/o alive in the driver?  The rport has just been
> deleted....  Would this eliminate the need for the callback?  If the
> driver implements this, could it just have a NULL callback routine?

You don't want to kill i/o at the time that the rport loses
connectivity (e.g. when we call delete). The biggest reason is for devices
that support FCP Recovery (Tape being a prime example, but it's not limited
to them). There are also several topology glitches, which can be seconds
in length, which are abberant, and really didn't reflect true device loss.
Why kill and reissue these io's as well ? it really just adds more load to
the system to abort and retry the i/o's.  Also, FC-DA compliance is
recommending that the login and the exchanges stay around as long as
possible (you could argue the diagram mandates it). So, for the best
"FC behavior" you really shouldn't kill the i/o until dev_loss_tmo fires.

-- james s

PS: I think you're highlighting my complaint with the patch. I should
  be renaming the "delete" function as it really isn't delete. The rport
  isn't truly "deleted" until dev_loss_tmo fires.  We didn't consider
  this when we dropped the block/unblock_rport routines in favor of the
  more straight-forward add/delete calls. At this point, I'd rather
  document the lifetime in the api/header than deal with namechanges and
  its affects on drivers/distros.
