From: Nick Bellinger <nickb@attheoffice.org>
Subject: Re: [PATCH] /proc/scsi/map
Date: 22 Jun 2002 12:18:19 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1024769900.6875.139.camel@subjeKt>
References: <3D14B2CF.90002@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3D14B2CF.90002@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, 2002-06-22 at 11:24, David Brownell wrote:
> > On the other hand there is the obvious fact that an iSCSI initiator
> > driver is not attached to a bus, and assuming /root/iSCSI.target/disk1
> > etc, is out of the question.  There is a real need for a solution to
> > handle virtual devices (as stated your previous message) that are not
> > assoicated with any physical connectors.  
> 
> There are those who see the IP stack as a kind of logical bus ... :)
> It's just not tied any specific hardware interface; it's "multipathed" in
> some sense. Linking it to an eth0 entry in $DRIVERFS/root/pci0/00:10.0
> would be wrong, since it can also be accessed through eth2.
> 
> Why shouldn't there be a $DRIVERFS/net/ipv4@10.42.135.99/... style hookup
> for iSCSI devices?  Using whatever physical addressing the kernel uses
> there, which I assume wouldn't necessarily be restricted to ipv4.  (And
> not exposing physical network topology -- routing! -- in driverfs.)
> 
> 
Giving the IP stack its own directory (leaf?) under driverfs root sounds
interesting enough and could have some potential uses, but in the case
of iSCSI there are a few problems:

iSCSI Names (aka: iSCSI Qualified Names or IEEE EUI-64 names ) are world
wide unique and are intended to stay with the iSCSI Node throughout its
lifetime, regardless of IP/HBA/NIC/etc changes. Also an iSCSI session
can include multiple TCP connections with each different IP addresses,
so the format of $DRIVERFS/net/ipv4@iSCSI.target.ip is insufficent.

This reiterates the need for a sound logical device naming scheme that
fits into driverfs without mucking up the basic structure.  Not being a
expert on naming, the least offensive format I can think with regard to
iSCSI would be something along the lines of:
  
$DRIVERFS/virt/iscsi/iqn.2002-06.com.foo.super.turbo.disk.array.3543/disk0

being the iqn for an iSCSI Target node as viewed by an iSCSI Initiator
node.  

		Nicholas Bellinger

