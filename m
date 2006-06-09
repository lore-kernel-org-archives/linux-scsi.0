From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: fc transport creates second set of targets for devices in an
 "md"
Date: Fri, 09 Jun 2006 14:34:37 -0500
Message-ID: <4489CD4D.4040505@cs.wisc.edu>
References: <448876C8.3090303@sgi.com> <4488864E.2000009@cs.wisc.edu> <4489A34C.8040007@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:62854 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1030436AbWFITex (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 15:34:53 -0400
In-Reply-To: <4489A34C.8040007@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James.Smart@Emulex.Com, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jim Nead <jnead@sgi.com>, James Bottomley <James.Bottomley@SteelEye.com>

Michael Reed wrote:
> 
> Mike Christie wrote:
>> Michael Reed wrote:
>>> I created an md device on two fibre channel disks, sde and sdf.
>>> I then disabled the switch port to which the hba is connected.
>>> After the remote port time out messages, I re-enabled the switch
>>> port.  Three things happen that are weird.  First, two unexpected
>>> responses while scanning.  Second, the creation of sdm and
>>> sdn.  Third, the md device remains inaccessible.
>>>
>>> I don't think this is working the way it's intended to.  I
>>> suspect it will cause big problems for multi-path volume managers
>>> in a fail back situation.
>>>
>> Even if the rport is removed and the devices under it are removed, md
>> can still have a reference to the device so the memory does not
>> disappear on it (MD still thinks the device is there but scsi says it is
>> gone basically). Because of this, when you plug in the cable again and a
>> new rport is created sd.c can end up allocating another sdX value.
>>
> 
> So, how about a callback to the driver, md, with the reference so that it
> can release said reference?
> 

Look at how DM's userspace multipath tools handle this. Last I looked it
could handle the hotplug events that are fired when a scsi device is
removed or added so as long as you set something like queue_if_no_path
or no_path_retry high enough then it could work.
