From: Michael Reed <mdr@sgi.com>
Subject: Re: fc transport creates second set of targets for devices in an
 "md"
Date: Fri, 09 Jun 2006 11:35:52 -0500
Message-ID: <4489A368.3080105@sgi.com>
References: <448876C8.3090303@sgi.com> <1149813836.3276.3.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:10221 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1030275AbWFIQfz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 12:35:55 -0400
In-Reply-To: <1149813836.3276.3.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: James.Smart@Emulex.Com, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jim Nead <jnead@sgi.com>



James Bottomley wrote:
> On Thu, 2006-06-08 at 14:13 -0500, Michael Reed wrote:
>> I created an md device on two fibre channel disks, sde and sdf.
>> I then disabled the switch port to which the hba is connected.
>> After the remote port time out messages, I re-enabled the switch
>> port.  Three things happen that are weird.  First, two unexpected
>> responses while scanning.  Second, the creation of sdm and
>> sdn.  Third, the md device remains inaccessible.
> 
> This is sort of as expected.  What you did was wait out the reconnection
> timer, so the mid layer failed and offlined the devices.  Thus, when
> they come back, they get new instances.  If you'd done a remove-device
> after they went offline, they'd have come back to the same location (as
> long as nothing had them open).  But this is user level stuff.

In this instance, there was no i/o in progress so the mid-layer didn't
take the device off line.  It was simply removed by the transport.

> Basically, when a path goes dead it's up to the multi-path user level to
> remove it an wait for udev to inform it that another SCSI node has
> appeared and has the correct signature to be another path to the device.

Are there notification mechanisms in place such that a driver which has
the device opened (claimed?) will be notified upon it's removal?  Should
there be?  Could it happen via a driver callback?  Udev?  Both?
I like the idea of a callback so that the removal has a chance of being
complete.

Is it possible to do a better job of reconnecting a removed target
to an open sd?

Thanks,
 Mike

> 
>> I don't think this is working the way it's intended to.  I
>> suspect it will cause big problems for multi-path volume managers
>> in a fail back situation.
> 
> James
> 
> 
