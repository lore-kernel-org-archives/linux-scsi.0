From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCHv2 0/7] Limit overall SCSI EH runtime
Date: Fri, 12 Jul 2013 09:30:40 -0400
Message-ID: <1373635840.7420.139.camel@localhost.localdomain>
References: <1372661455-122384-1-git-send-email-hare@suse.de>
	 <1373488528.7420.55.camel@localhost.localdomain>
	 <51DF9A25.5030502@cn.fujitsu.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964808Ab3GLNbA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jul 2013 09:31:00 -0400
In-Reply-To: <51DF9A25.5030502@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ren Mingxin <renmx@cn.fujitsu.com>, bmr@redhat.com
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>

On Fri, 2013-07-12 at 13:54 +0800, Ren Mingxin wrote:
> Hi, Ewan:
> 
> I'm wondering how do you test, with a special hardware or self-made
> module?Would you mind pasting your test method() and result?

Hi Rex-

This was tested in a SAN environment with an EMC Symmetrix and
Brocade FC switches.  The error was injected by the following
commands:

portcfg rscnsupr <port> --enable
portdisable <port>

Where <port> is the FC port of the Symmetrix target.

Multipath is used and the test records how long I/O from userspace
takes to complete after the error handling stops and the I/O is
retried on another path.

What happens is that the target never responds to anything the
HBA sends, so commands and TMFs just timeout.  The HBA doesn't
see link down (since it is the target port) and doesn't get an
RSCN.  When the HBA is finally reset, however, it can't login
to the target port and so further I/O gets an immediate error.

Unfortunately, not all SAN environments will exhibit the failing
behavior -- it appears as if in some cases the HBA detects the
problem regardless of the switch portcfg setting.  But this has
been verified to solve the problem of seemingly endless EH
activity in testing at a large customer site.

Also, to be clear, we tested with the "Limit overall SCSI EH
runtime" patchset but not the "New EH command timeout handler".
I think the changes to issue the abort in the timeout handler
are a good idea, though, because there really is no need to
wait for all activity on the host to cease before issuing the
abort as far as I can see.

-Ewan

> 
> Thanks,
> Ren
> 
> >
> > Acked-by: Ewan D. Milne<emilne@redhat.com>
> 


