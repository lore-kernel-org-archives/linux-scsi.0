From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] /proc/scsi/map
Date: Tue, 25 Jun 2002 10:49:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D18AD30.7040904@pacbell.net>
References: <Pine.LNX.4.33.0206250920150.8496-100000@geena.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mochel <mochel@osdl.org>
Cc: Nick Bellinger <nickb@attheoffice.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>>Why shouldn't there be a $DRIVERFS/net/ipv4@10.42.135.99/... style
>>hookup for iSCSI devices?  Using whatever physical addressing the
>>kernel uses there, which I assume wouldn't necessarily be restricted
>>to ipv4.  (And not exposing physical network topology -- routing! --
>>in driverfs.)
> 
> 
> You can very well use driverfs to expose those attributes, and is one of 
> the things that we've been discussing at the kernel summit. driverfs will 
> take over the world. But, I still think the device is best represented as 
> a child of the phsysical network device. 

Which one?  I'd certainly hope that drivers wouldn't have to choose which
of the various network interfaces to register under, or register under
every network interface concurrently.  (Or only the ones they might
conceivably be routed to go out on...)  Given a bonded network link (going
out over multiple physical drivers) that'd get hairy.  And what about
devices that host several logical interfaces?  Or when the interfaces get
moved to some other device?

That's why I think a "non-physical" tree (not under $DRIVERFS/root) is more
sensible in such cases.  Which is not to say it's without additional issues
(like how to establish/maintain driver linkages that are DAGs not single
parent trees) but it wouldn't require drivers to dig as deeply into lower
levels of their stack.  (And some network interfaces might well live in
such a non-physical tree, not just iSCSI...)

I think that problem wouldn't quite be isomorphic to multipath access to
devices, though it seems to be related.  "Driver stacking" is an area
that "driverfs" doesn't seem to address quite yet ... not needed in the
simpler driver scenarios, so that's what I'd expect at this stage.

- Dave




