From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH] scsi: Allow error handling timeout to be specified
Date: Fri, 10 May 2013 15:31:29 +0100
Message-ID: <518D04C1.8090504@redhat.com>
References: <yq1fvxvedg6.fsf@sermon.lab.mkp.net>  <1368189791.3319.31.camel@localhost.localdomain>  <CAC9+an+UBY3Cbxryn3O0KMVMuwdXBpf9EsVJ08tV=5Y0dpkjdA@mail.gmail.com> <1368194460.3319.40.camel@localhost.localdomain> <518D0311.9010208@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587Ab3EJOcI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 May 2013 10:32:08 -0400
In-Reply-To: <518D0311.9010208@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: emilne@redhat.com, Baruch Even <baruch@ev-en.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, michaelc <michaelc@cs.wisc.edu>

On 05/10/2013 03:24 PM, Hannes Reinecke wrote:
> However, this time is only defined _on the initiator_.
> The specification does _NOT_ have any fixed timeout values for _any_
> command. As such it could in theory (and does, if you happen to run
> against certain arrays under certain conditions) take several
> minutes to return a completion.

That's my understanding too - in a multipath configuration we're 
waiting only for our own fast_io_fail_tmo (if set), which is essentially 
an arbitrary, administrator-controlled interval. You can tune it between 
extremes of rapid fault identification vs. paths twitching at every 
transient glitch.

> Yes, that was the idea.
> Which I'll get down to eventually; if only customers wouldn't have
> all these obnoxious issues no-one has ever seen...

The class I've been looking at is really very easy to reproduce and 
we've seen it at least a half dozen times at different sites with 
different FC switches (so it's certainly not that unusual).

To recreate it artificially you just need a target, a host, and a switch 
that can block RSCN propagation on a per-port basis. I've been using 
brocades with the rscnsupr portcfg attribute.

It's important that you block a port on the switch<->target side 
otherwise the host will see a link event which short-circuits everything.

E.g. if you have one port of an array attached to port 1 on a brocade 
the following two commands will set up this scenario:

portcfg rscnsupr 1 --enable
portdisable 1

Regards,
Bryn.

