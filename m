From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: [BUG] modprobe qla2300 doesn't complete
Date: Sun, 14 Mar 2004 21:06:42 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040315050642.GA30707@praka.local.home>
References: <20040310221241.GA7903@colo.lackof.org> <20040305041850.GA9124@colo.lackof.org> <20040305071721.GA9684@praka.local.home> <20040305172147.GB17305@colo.lackof.org> <20040309164033.GA21648@praka.local.home> <20040310221241.GA7903@colo.lackof.org> <5.1.0.14.2.20040312232611.044c2e98@mira-sjcm-3.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:4859 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S262266AbUCOF3K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Mar 2004 00:29:10 -0500
Content-Disposition: inline
In-Reply-To: <5.1.0.14.2.20040312232611.044c2e98@mira-sjcm-3.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Lincoln Dale <ltd@cisco.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Grant Grundler <grundler@parisc-linux.org>, linux-scsi@vger.kernel.org

On Fri, 12 Mar 2004, Lincoln Dale wrote:
> At 05:11 PM 12/03/2004, Andrew Vasquez wrote:
> >So, I'm not entirely clear on what else is going on with your
> >configuration.  I'll try to get some runtime on an ia64 machine
> >tomorrow to perform the same test.
> 
> if you have access to some SAN test equipment (e.g. Agilent SAN Tester), or 
> SAN-rootkit (e.g. we have internal tools which can cause RSCN floods, FLOGI 
> floods, PLOGI floods, rogue injection of vast quantities of NS 
> registrations ...), it currently doesn't seem too hard to upset the qla2300 
> into a never-ending incomplete state such that Grant has seen.
> 

Unfortunately (at least locally) we don't have some nice Agilent
hardware.  I have managed to gather some 'traffic generating' hardware
together, but, from what we've seen, the disconnect in
originator/source of the RSCN frames seems to wreak havoc in the BB
credit area.  In any case, we'll try some other options tomorrow.


> have you guys ever considered rate-limiting NS queries following receiving 
> RSCNs?
> 

Well, looking through the code, there are a few additional places
where we could limit processing during loop-resync (i.e. device
discovery) when there are outstanding loop resyncs (RSCNs) without
littering the whole process with tons of:

	if (test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags))
		break;		// skip...


I can take a look at these places.  

With recent QLogic drivers (8.x series included) on 23xx (and 63xx)
ISPs, we started to employ a more fabric non-disruptive method of
handling 'port-type' RSCNs, effectively using a series of ADISCs and
PLOGIs to handle disconnects/additions and movements of ports within a
fabric -- for the initiated, qla_rscn.c contains the complete set of
patterns and logic describing the process.

In a sense, one could consider this 'rate-limiting' in essence, but
given most devices on a fabric are 'passive' in nature, RSCN handling
(including tricks and intelligence) at the lowest-link in the chain
doesn't provide for much in the way of manuverability.

Regards,
Andrew Vasquez
