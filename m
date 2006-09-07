From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi_transport_sas: make minimum and maximum linkrate
	settable quantities
Date: Thu, 07 Sep 2006 12:37:36 -0500
Message-ID: <1157650656.3462.68.camel@mulgrave.il.steeleye.com>
References: <4500412F.7040805@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:24494 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1422675AbWIGRiY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Sep 2006 13:38:24 -0400
In-Reply-To: <4500412F.7040805@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

On Thu, 2006-09-07 at 11:56 -0400, Douglas Gilbert wrote:
> Dropping the double negative I read your last sentence as
> "Only expander phys are visible in our representation."

Only expander and host phys are visible in the sysfs representation.

> However the user may not want a link reset sent immediately.
> For example, in SAS-2 with 6 Gbps available, to force 3 Gbps
> the min_linkrate needs to be increased to 3 Gbps and the
> max_linkrate needs to be decreased to 3 Gbps, then a reset
> sent. It is also possible that the user may want a
> (expander) phy's next negotiated link_rate changed but
> the phy left disabled.

A link reset is merely supposed to renegotiate ... it's not supposed to
be disruptive


> Building SAS discovery into the kernel SAS transport layer
> might be a necessity now but it could cause problems down the
> track. Consideration should be given to having a switch to
> turn it off. SAS discovery in SAS-1 and SAS-1.1 does not
> scale well with every SAS management client (i.e. the SAS
> kernel transport layer) thinking that it has to do a full
> or partial discovery of a potentially large SAS domain

We already have this, but it's optional: aic94xx uses it, mptsas
doesn't.

> every time a BROADCAST(CHANGE) event is received.
> [BTW a link reset causes a BROADCAST(CHANGE) event so sending
> more link resets than necessary will impact performance.]

Yes, these are actually used to update the phy parameters (they trigger
SMP probes to find out what changed).


> In SAS-2 there are several improvements:
>   - higher level SMP commands that move more data
>     in one function (e.g. DISCOVER LIST)
>   - much smarter expanders that can
>      - self config and configure other (older) expanders
>      - indicate to management clients when the are finished
>      - more efficient routing tables (expander based rather
>        than phy based)
>      - support expander based zoning which will control the
>        accessibility of end devices to one another.
> 
> Together these changes could relieve the burden of the SAS
> discovery process on the SAS kernel transport layer. However
> there seems nothing to stop such a kernel layer ploughing
> ahead and doing discovery in the old inefficient way
> making the worst case assumptions.

I'm not really planning to do anything about the new SAS-2 features
until I see expanders which support them.  The current discovery doesn't
reprogram an expander, it queries the route table to see if it's usable
as is and only modifies it if it isn't.  It can also support table to
table routing, so it should support a large chunk of the new features
anyway.

James


