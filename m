From: "Cameron, Steve" <Steve.Cameron@hp.com>
Subject: RE: [PATCH] fix cpqfc passthrough ioctl for 2.5.30
Date: Mon, 5 Aug 2002 16:01:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <45B36A38D959B44CB032DA427A6E10640167D018@cceexc18.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> 
> Steve -
> 
> On Fri, Aug 02, 2002 at 04:59:32PM -0500, Stephen Cameron wrote:
> > 
> > This patch fixes the cpqfc passthrough ioctl for 2.5.30.
> > 
> > One question... Is it possible for a user app, by abusing
> > a upperlevel driver (e.g. the sg driver) to put a bogus
> > value into Scsi_Request->upper_level_private?
> 
> You mean upper_private_data, if an upper level driver modifies it
> while you have the Scsi_Request it would be a bug.

Yes, that would be a bug.  I was more paranoid about a malicious
user app abusing the sg driver to put in bogus data into
upper_private_data to erroneously match my address range, and do
something bad from there.  That is, not modify _my_ Scsi_Request,
but construct a Scsi_Request such that when it completed, cpqfc 
thinks it belongs to cpqfc.  (probably overly paranoid.  In any case 
I've subsequently enhanced the patch to prevent exactly that, sent 
to Jens Axboe, since I'd thought my patch didn't make it to 
linux-scsi, because it didn't show up on google yet, since 2 days.)

[...]
> It would be best if this code could be replaced via usage of 
> sg, rather than having its own pass through.

I'm not sure this is the right way to go, see below.
 
> Is the user program trying to send commands to devices that sg did not
> find (linux did not allocate and/or properly set up a Scsi_Device)?

Yes.  Example, the RA4100 is a RAID controller with a FC interface.
it presents logical volumes, which the cpqfc driver presents to linux
as scsi devices.  Also, the physical disks behind the ra4100 may be
addressed.  These are not presented to linux as scsi devices.

If sg nodes were mapped to these physical devices, it would be likely
difficult to tell what was what. (e.g. relating several physical disk 
sg nodes to the sd node of the corresponding raid5 logical volume.)

The Compaq Insight Manager (CIM) agents use the current passthrough
interface to gather status information, etc about the physical disks.
This application is widely deployed from what I understand, so I would
not want to break it by changing the interface suddenly and radically.

-- steve
[patch removed for brevity] 
