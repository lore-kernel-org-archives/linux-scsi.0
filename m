From: Robert Love <robert.w.love@intel.com>
Subject: Re: Proposal to add sysfs attributes for FCoE in FC Transport layer
Date: Wed, 01 Apr 2009 17:13:28 -0700
Message-ID: <1238631208.15031.42.camel@fritz>
References: <9F784EDD-BC14-4113-B7F2-1E5EBC17B65F@qlogic.com>
	 <49D37349.3070202@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:16311 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757908AbZDBANb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Apr 2009 20:13:31 -0400
In-Reply-To: <49D37349.3070202@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Carnuccio <joe.carnuccio@qlogic.com>, Marcus Barrow <marcus.barrow@qlogic.com>, David Wagner <david.wagner@qlogic.com>

On Wed, 2009-04-01 at 09:59 -0400, James Smart wrote:
> The largest issue I have is - what attributes are really fc/fcoe specific ?
> DCBX and PFC are arguably NIC-related parameters and have no business being
> under the fc transport.  Additionally, whatever we pick, we had better put
> the same or like parameters with lib_fcoe-supporting adapters in the same
> place.
> 
> This is very muddy as some adapters will want present a fc/scsi function
> only, hiding the nic completely; others may present a nic function and
> an fcoe function, and physically share the nic; while others will have
> only the nic and a bunch of software, or a nic with super-features for
> fcoe.  What object belongs where for what attribute ?
> 
> Another thing that should be brought up is the presentation model when
> there are multiple FCF's that an FCOE adapter can talk to. I'm a fan of
> having a new fc_host for every new *initiator* context on a fabric.
> Meaning, there's a fc_host for each N_Port_Id on each fabric (which is
> what we have been doing for NPIV and VSANs). Mean an FCOE port, which
> sees multiple FCFs, or contacts the same FCF on different vlans (which
> map to different VSANs) need to be separate fc_hosts.  Additionally, we

What do you think about having a fcoe_host defined in the FC transport
that can exist for the FIP phase and then create fc_hosts for each
N_Port_ID that is logged into the fabric(s)? 

We could also have a fcoe_fcf structure that would have a similar
relationship with the fcoe_host that the rports have with the fc_host
(at least from the device model perspective). I don't think the
fcoe_host would be coupled with a scsi_host, or fc_host, since there is
no intent to use it for I/O, it would be used to do FIP and then we
switch to fc_hosts just before we log a port into a fabric.

libfcoe has two structures that are used for this purpose
(include/scsi/libfcoe.h), but they're only used by modules that use
libfcoe. Maybe they should be moved up to the transport layer, modified
to fit into the the device model and then have the relevant info exposed
in sysfs.

//Rob

