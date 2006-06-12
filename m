From: Ravi Anand <ravi.anand@qlogic.com>
Subject: Re: [RFC] qla4xxx: TODO for re-submission
Date: Mon, 12 Jun 2006 15:43:25 -0700
Message-ID: <20060612224325.GK7555@ranandlinuxbox.qlogic.org>
References: <8889.1149988615@bebe.enoyolf.org> <448DACD5.6090205@cs.wisc.edu> <20060612211038.GB7555@ranandlinuxbox.qlogic.org> <448DDE31.2090300@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:20713 "EHLO avexch2.qlogic.com")
	by vger.kernel.org with ESMTP id S932637AbWFLWnK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jun 2006 18:43:10 -0400
Content-Disposition: inline
In-Reply-To: <448DDE31.2090300@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Doug Maxey <dwm@bebe.enoyolf.org>, David Somayajulu <davidcs2005@gmail.com>, Duane Grigsby <duane.grigsby@qlogic.com>, linux-scsi@vger.kernel.org, dwm@austin.ibm.com

>On Mon, 12 Jun 2006, Mike Christie wrote:

> Date: Mon, 12 Jun 2006 16:35:45 -0500
> From: Mike Christie <michaelc@cs.wisc.edu>
> To: Ravi Anand <ravi.anand@qlogic.com>
> CC: Doug Maxey <dwm@bebe.enoyolf.org>,
> 	David Somayajulu <davidcs2005@gmail.com>,
> 	Duane Grigsby <duane.grigsby@qlogic.com>,
> 	linux-scsi@vger.kernel.org, dwm@austin.ibm.com
> Subject: Re: [RFC] qla4xxx: TODO for re-submission
> User-Agent: Thunderbird 1.5 (X11/20060313)
> 
> Ravi Anand wrote:
> >> On Mon, 12 Jun 2006, Mike Christie wrote:
> >> Doug Maxey wrote:
> >>> 5) add the block layer code.
> >> Some related issues that we have discussed offlist about this and should
> >> probably be discussed here are:
> >>
> >> - Are we supposed to follow FC's lead and remove the devices (rport,
> >> session, target, scsi_device, etc) if the dev_loss_tmo fires. Currently
> >> for software iscsi, we leave the devices/session. This was to reduce
> >> memory allocations and because software iscsi has to basically poll the
> >> connection during connect as part of the relogin process. So unlike FC
> >> or hw iscsi, if we remove the devices/structs we have to end up
> >> rebuilding some of them right away anyways.
> >>
> >> Removing the devices has the benefit of simplifying the scsi/iscsi code.
> >>
> >> - Scanning. We currently do scanning for open-iscsi in userspace. For
> >> iscsi root this requires distro support. SUSE has it. Fedora is working
> >> on it. There is also Debian and Gentoo users or maintainers posting
> >> about working on it. For qla4xxx, we could stick the scanning in the
> >> kernel like FC and distros would not have to worry about it, but since
> >> they have to get this working for software iscsi do we just keep the
> >> scanning in userspace?
> > 
> > Our preference is also to have the scanning for all the HBA's which
> > does the discovery of the tgt's in the kernel space. This way we are
> > consistent with all the HBA's which does the port discovery like 
> > the FC HBA's. Our iSCSI HBA's is similar in that regard.
> 
> Yeah, but your HBA can also function in connection mode and just use
> open-iscsi's login code too. I am not saying that is that way to go. I
> am just saying that there are alternatives.

Agreed. But it was added later on. So the driver always used the session mode.
> 
> > 
> > As you have already stated, it simplies support from distro perspective 
> > as well.
> > 
> 
> It does for qla4xxx, but I think you then have to go and fix it so
> iscsi_tcp and iscsi_iser sync up with userspace correctly if you convert
> them. Either that or we maintain two ways of scanning for iscsi drivers.

I like the later part. Keeping it seperate.

Ravi







