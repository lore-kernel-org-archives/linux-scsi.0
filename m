From: Nick Bellinger <nickb@attheoffice.org>
Subject: Re: driverfs is not for everything! (was:  [PATCH] /proc/scsi/map)
Date: 23 Jun 2002 23:18:46 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1024895928.12662.192.camel@subjeKt>
References: <59885C5E3098D511AD690002A5072D3C02AB7F52@orsmsx111.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <59885C5E3098D511AD690002A5072D3C02AB7F52@orsmsx111.jf.intel.com>
List-Id: linux-scsi@vger.kernel.org
To: "Grover, Andrew" <andrew.grover@intel.com>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Patrick Mochel <mochel@osdl.org>

On Sun, 2002-06-23 at 16:59, Grover, Andrew wrote:
> > From: Nick Bellinger [mailto:nickb@attheoffice.org] 
> > Giving the IP stack its own directory (leaf?) under driverfs 
> > root sounds
> > interesting enough and could have some potential uses, but in the case
> > of iSCSI there are a few problems:
> 
> I know this is one of those things that has more and more cool possibilities
> the more you think about it but...
> 
> Is the device PHYSICALLY hooked up to the computer? If not, it shouldn't be
> in devicefs.

This is a red herring,  what exactly is the definition of physically
hooked up to the computer?  In the above context it comes out as being a
device inside the machine or within close proximity (ie: USB, IEEE 1394,
etc) and connected by a physical cable.  If this is the case then what
becomes of an Fibre Channel array 10km removed?  What makes this more or
less likely to be in driverfs than a IP storage array that is
"physically connected" via gigabit ethernet cable in the next room?  If
you where getting at devices which use the IP stack exclusively, then
how do iSCSI HBAs with TCP offload engines fit into the mix?  The only
scenario where I see the above statement holding true is if one was to
use iSCSI over a wireless/radio link, then it most definitely could NOT
be part of driverfs. :)

But seriously, I was not implying that every TCP/UDP service should have
its own directory entry within driverfs or that the IP stack should be
included at all,  but rather looking from a wider perspective of how
logical devices not on the machine's bus which _should_ be part of
driverfs will fit into the framework.         

> 
> The device tree (for which devicefs is the fs representation) was originally
> meant to enable good device power management and configuration. driverfs
> wasn't meant to handle iscsi or tcpip (that is, network) connections, nor
> should it have to.

I am by no means fimilar with the original intent of driverfs,  but what
it appears to be morphing into (one of its uses of course) is a tree for
the user to view a list of all the devices within the system.  But again
the notion that only physically connected, and not by network cable
devices have a place in the tree simply does not make sense.  

I am all for keeping the tree as tidy as possible,  but any block level
storage transport regardless of physical (or non-physical :) connection
deserves a place in driverfs,  and will only become more apparent as
storage continues to work itself out onto the network.    

> 
> Regards -- Andy
> 

			Nicholas Bellinger

