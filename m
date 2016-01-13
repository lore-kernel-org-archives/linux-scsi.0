From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [dm-devel] [LSF/MM ATTEND][LSF/MM TOPIC] Multipath redesign
Date: Wed, 13 Jan 2016 11:52:39 -0600
Message-ID: <20160113175239.GE24960@octiron.msp.redhat.com>
References: <56961493.5010901@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932507AbcAMRwl (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 12:52:41 -0500
Content-Disposition: inline
In-Reply-To: <56961493.5010901@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>

On Wed, Jan 13, 2016 at 10:10:43AM +0100, Hannes Reinecke wrote:
> Hi all,
> 
> I'd like to attend LSF/MM and would like to present my ideas for a multipath
> redesign.
> 
> The overall idea is to break up the centralized multipath handling in
> device-mapper (and multipath-tools) and delegate to the appropriate
> sub-systems.
> 
> Individually the plan is:
> a) use the 'wwid' sysfs attribute to detect multipath devices;
>    this removes the need of the current 'path_id' functionality
>    in multipath-tools

If all the devices that we support advertise their WWID through sysfs,
I'm all for this. Not needing to worry about callouts or udev sounds
great.

> b) leverage topology information from scsi_dh_alua (which we will
>    have once my ALUA handler update is in) to detect the multipath
>    topology. This removes the need of a 'prio' infrastructure
>    in multipath-tools

What about devices that don't use alua? Or users who want to be able to
pick a specific path to prefer? While I definitely prefer simple, we
can't drop real funtionality to get there. Have you posted your
scsi_dh_alua update somewhere?

I've recently had requests from users to
1. make a path with the TPGS pref bit set be in its own path group with
the highest priority
2. make the weighted prioritizer use persistent information to make its
choice, so its actually useful. This is to deal with the need to prefer a
specific path in a non-alua setup.

Some of the complexity with priorities is there out of necessity.

> c) implement block or scsi events whenever a remote port becomes
>    unavailable. This removes the need of the 'path_checker'
>    functionality in multipath-tools.

I'm not convinced that we will be able to find out when paths come back
online in all cases without some sort of actual polling. Again, I'd love
this to be simpler, but asking all the types of storage we plan to
support to notify us when they are up and down may not be realistic.

> d) leverage these events to handle path-up/path-down events
>    in-kernel

If polling is necessary, I'd rather it be done in userspace. Personally,
I think the checker code is probably the least obectionable part of the
multipath-tools (It's getting all the device information to set up the
devices in the first place and coordinating with uevents that's really
ugly, IMHO).

-Ben
