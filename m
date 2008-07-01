From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: fcoe cleanups and fcoe TODO
Date: Tue, 1 Jul 2008 07:37:49 -0700
Message-ID: <20080701143749.GA495@plap4-2.qlogic.org>
References: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu> <10A7D0016239E24092DEF05CCC582E4303FE4B55@fmsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:9293 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303AbYGAOhv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jul 2008 10:37:51 -0400
Content-Disposition: inline
In-Reply-To: <10A7D0016239E24092DEF05CCC582E4303FE4B55@fmsmsx411.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Love, Robert W" <robert.w.love@intel.com>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, devel@open-fcoe.org

On Mon, 30 Jun 2008, Love, Robert W wrote:

...
> >I think we need to see more hardware in the end. For now since there is
> >only
> >software fcoe that is out, this could probably be ok and as we see more
> >drivers we can evolve the split for the hardware like was done with
> iscsi.
> >For iscsi we ended up with 4 different offload modules so there was no
> way
> >we could have designed for all of them and the hardware/firmware
> >guys's quirks :)
> >
> We definitely expect this library to evolve as more LLDs use it. 
> 
> >- In general without knowing how hardware is really going to hook into
> >the lib it is hard to say how the rearch is going :) If we cannot
> >move more of the fc_remote_port to the rport (or if we just do not
> >want to move it all there because other drivers like lpfc and qla2xxx
> >will never use it) then we might want to rename the fc_remote_port
> >to avoid confusion with the rport and make it clear that the libfc
> remote
> >port is only needed for libfc operations.
> >
> We'd like to reduce fc_remote_port to nothing and only use fc_rport.
> We're still not sure we can completely achieve this without either
> having some private data or adding fields to the fc_rport.

On the QLogic side, there are several FCoE hardware options for CNAs.
Each of these FCoe offerings will follow in essence software's (the
driver's) current interfaces with existing FC hardware and firmware.
Upstream already has support for one such adapter:

	[SCSI] qla2xxx: Add ISP84XX support.
	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=4d4df1932b6b116aecc81039066fec27f2050762

It's essentially a 1gb FCoE adapter based on our ISP24xx (4gb) FC
chip.  Driver continues to use the standard FW interfaces used by 24xx
firmware.  Future offerings will be similar, but based on more recent
FC chips.

Architecturally, the current FCoE adapters continue to abstract
software from the transport details (FC0/FC1 on FC, and ethernet on
FCoE), so, we forsee the driver continuing to use the currently
implemented 'level0' interfaces (as noted by James S.) of the
fc-transport.

As far as libfc interfacing, there's a few possible
points-of-intersection (this was true even before FCoE):

* generic N-port discovery (assist) -- managing SNS querying,
  typically fairly generic, GID_PT/G_A_NXT.
* initiate logins (PLOGI/PRLI) -- still trying to wrap my hands
  around openfc constructs, my guess would be its fc_remote_port
  objects having similar mapping to the qla2xxx driver's fc_port_t
  structure.
* initiate rport creation -- with login data.

Striking a balance here could be tricky, as qla2xxx is still a
fairly heavy firmware dependent driver (and not simply a
frame-shuttler), we'd need to ensure some sort of bi-directional
interfaces as the firmware is capable of handling implicit logins
outside of software processing.

<snip>
> >Do we want a common userspace interface for the setup like we have with
> >iscsi for the initial merge? If so, we can say the interface is
> unstable
> >for now, because we just do not know how the hardware is going to work
> or
> >we can try and design a interface based on what we learned from iscsi.
> The
> >latter will probably result in a incorrct design since we are only
> >lowly driver engineers and do not know the fun the firmware guys
> >have for us :) However breaking userspace interfaces is a real pain
> >for users. When we did the latter for iscsi it was a tremendous pain
> for
> >users and distro integrators.

I'm in the process of gathering specs on FCoE specific attributes our
hardware (will) export which may be useful from userspace, both
statistics and tuning-knobs...

--
av
