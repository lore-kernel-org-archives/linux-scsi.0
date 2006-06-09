From: Michael Reed <mdr@sgi.com>
Subject: Re: fc transport creates second set of targets for devices in an
 "md"
Date: Fri, 09 Jun 2006 11:26:36 -0500
Message-ID: <4489A13C.9040602@sgi.com>
References: <448876C8.3090303@sgi.com> <44888134.70805@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:11500 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1030282AbWFIQ0k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 12:26:40 -0400
In-Reply-To: <44888134.70805@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jim Nead <jnead@sgi.com>, Michael Reed <mdr@sgi.com>



James Smart wrote:
> The data that would be most interesting is a recursive listing of the
> device via the /sys/devices tree.  This would show the host, rports,
> targets, and sdevs.  Getting a copy of this both before, when missing,
> and after they are reconnected. The additional contents to look at
> is : contents of /sys/class/fc_remote_ports.

I'll capture data and post later today.

> 
> Also - it's unlikely that FC is to blame here. The above data would
> show whether we had the same WWN's, reused target id's or not, and
> what the midlayer reassigned to h/c/t/l's. It would show if the FC
> transport is in error or not.

Agree.  Sometimes the title is used to draw attention to a problem.  ;)
It worked.

> 
> Relative to volume managers - yes, they have some difficulty. However,
> the tact they plan on taking is to bind the device based on the udev
> name that get built on it. Which means - md would have issues, but DM
> is planning for it.

So, do any volume managers work correctly now?  By "correct" I mean,
when the device returns, will they be able to access it?

> 
> I do have a request to make an option for the transport to not remove
> the devices upon disconnect.

I understand why.  If this does what I suspect it will, please add SGI
to the list.  We should probably discuss requirements.

Mike

> 
> -- james
> 
> Michael Reed wrote:
>> I created an md device on two fibre channel disks, sde and sdf.
>> I then disabled the switch port to which the hba is connected.
>> After the remote port time out messages, I re-enabled the switch
>> port.  Three things happen that are weird.  First, two unexpected
>> responses while scanning.  Second, the creation of sdm and
>> sdn.  Third, the md device remains inaccessible.
>>
>> I don't think this is working the way it's intended to.  I
>> suspect it will cause big problems for multi-path volume managers
>> in a fail back situation.
>>
>> Mike
>>
> 
