From: Michael Reed <mdr@sgi.com>
Subject: Re: fc transport creates second set of targets for devices in an
 "md"
Date: Fri, 09 Jun 2006 11:35:24 -0500
Message-ID: <4489A34C.8040007@sgi.com>
References: <448876C8.3090303@sgi.com> <4488864E.2000009@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:7405 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1030254AbWFIQff (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 12:35:35 -0400
In-Reply-To: <4488864E.2000009@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James.Smart@Emulex.Com, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jim Nead <jnead@sgi.com>, James Bottomley <James.Bottomley@SteelEye.com>



Mike Christie wrote:
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
> 
> Even if the rport is removed and the devices under it are removed, md
> can still have a reference to the device so the memory does not
> disappear on it (MD still thinks the device is there but scsi says it is
> gone basically). Because of this, when you plug in the cable again and a
> new rport is created sd.c can end up allocating another sdX value.
> 

So, how about a callback to the driver, md, with the reference so that it
can release said reference?

Mike
