From: James Smart <James.Smart@Emulex.Com>
Subject: Re: fc transport creates second set of targets for devices in an
 "md"
Date: Thu, 08 Jun 2006 15:57:40 -0400
Message-ID: <44888134.70805@emulex.com>
References: <448876C8.3090303@sgi.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:16347 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S964956AbWFHT5o
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jun 2006 15:57:44 -0400
In-Reply-To: <448876C8.3090303@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>

The data that would be most interesting is a recursive listing of the
device via the /sys/devices tree.  This would show the host, rports,
targets, and sdevs.  Getting a copy of this both before, when missing,
and after they are reconnected. The additional contents to look at
is : contents of /sys/class/fc_remote_ports.

Also - it's unlikely that FC is to blame here. The above data would
show whether we had the same WWN's, reused target id's or not, and
what the midlayer reassigned to h/c/t/l's. It would show if the FC
transport is in error or not.

Relative to volume managers - yes, they have some difficulty. However,
the tact they plan on taking is to bind the device based on the udev
name that get built on it. Which means - md would have issues, but DM
is planning for it.

I do have a request to make an option for the transport to not remove
the devices upon disconnect.

-- james

Michael Reed wrote:
> I created an md device on two fibre channel disks, sde and sdf.
> I then disabled the switch port to which the hba is connected.
> After the remote port time out messages, I re-enabled the switch
> port.  Three things happen that are weird.  First, two unexpected
> responses while scanning.  Second, the creation of sdm and
> sdn.  Third, the md device remains inaccessible.
> 
> I don't think this is working the way it's intended to.  I
> suspect it will cause big problems for multi-path volume managers
> in a fail back situation.
> 
> Mike
> 
