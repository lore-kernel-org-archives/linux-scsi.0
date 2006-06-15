From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] make fc transport removal of target configurable
Date: Thu, 15 Jun 2006 11:04:44 +0200
Message-ID: <449122AC.6020004@s5r6.in-berlin.de>
References: <448DF5DA.3070800@sgi.com>	 <20060613070714.GA16358@infradead.org> <448E9C34.6070707@emulex.com>	 <448EDCEB.50702@sgi.com>	 <1150221599.3441.54.camel@mulgrave.il.steeleye.com>	 <448F1403.6090903@sgi.com> <1150228960.3441.72.camel@mulgrave.il.steeleye.com> <449039CF.5090807@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:38344 "EHLO
	hp3.statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S1751373AbWFOJHN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 05:07:13 -0400
In-Reply-To: <449039CF.5090807@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Michael Reed <mdr@sgi.com>, James.Smart@Emulex.Com, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jim Nead <jnead@sgi.com>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>

Mike Christie wrote:
> James Bottomley wrote:
[...]
>> doesn't really buy us anything for the application.  Since the rest of
>> our infrastructure is already event driven, or migrating that way, I
>> really don't see value in introducing an anomaly like this purely for
>> fibre channel.
> 
> For iscsi we do sort of the probe option. The problem with software
> iscsi is that we do not normally get a event that some target is back
> online so from userspace we basically have to probe it. We try to open a
> connection and poll it until it we can connect, then we try to log back
> in. When we log back in, we set the devices online if we have to and we
> set the driver and iscsi state to start accepting IO again.
> 
> For HW iscsi the card can signal an event that it has logged back into a
> target, so we could do like FC. So for qla4xxx, should we follow the FC
> model or software iscsi one that is already there?
> 
> Note, that for software iscsi we could do FC's model too.
[...]

I don't think there is any basic difference between the transports like
FC, iSCSI, or e.g. USB storage, or even parallel SCSI.
 - The SCSI core implements a state model for its abstract* notion of
   "SCSI device"/ "SCSI target" and handles new/ pending/ completed/
   failed tasks according to these devices's states.
   (* = transport independent)
 - The transport layer receives events concerning the state of
   connection with a target or LU. These events come from the
   interconnect (i.e. from the thin or thick layer of software driving
   the interconnect) or from userspace (management interface) or from
   timeouts. According to these events, the transport layer handles the
   transport protocol (login etc.) and triggers state transitions of the
   SCSI core's device model.

There may be differences between transports like from where certain
events come or how long certain timeouts are. Some timeouts are defined
by the protocol spec, others may be configurable by the user. But the
types of connection state transitions ("gone online", "became
unavailable", "came back", "requested to be shut down", "hot
terminated") as well as their consequences for SCSI core and software
layers above it are ultimately the same. Thus, behaviour of SCSI core
like to block or to fail tasks should be the same.

(Connection details on the other hand, like "tied to this unique
identifier" or "routed via this or that path" or "backed by heartbeat
protocol" or whatnot, concern only the transport layer and transport
management, as far as such details are not hidden by the interconnect.)

One problem at the moment is that the mentioned state transitions are
not fully supported by the SCSI core's lowlevel API. We only have "gone
online", "to be blocked", "to be unblocked", "requested to be shut
down". Transport layers currently have to work around this limitation,
and they do it differently and sometimes buggy.
-- 
Stefan Richter
-=====-=-==- -==- -===-
http://arcgraph.de/sr/
