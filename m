From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: network namespace, netlink and sysfs changes for iSCSI (Re:
 [PATCH 0/9] use network namespace for iSCSI control interfaces)
Date: Tue, 07 Nov 2017 12:45:26 -0800
Message-ID: <1510087526.3118.37.camel@HansenPartnership.com>
References: <20171031224104.17735-1-cleech@redhat.com>
         <20171107180156.GD29597@straylight.hirudinean.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50842 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751674AbdKGUp2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2017 15:45:28 -0500
In-Reply-To: <20171107180156.GD29597@straylight.hirudinean.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Leech <cleech@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

On Tue, 2017-11-07 at 10:01 -0800, Chris Leech wrote:
> Hello,
> 
> I have this set of changes to the iSCSI control interfaces pending
> review, but seeing as it's sysfs and netlink changes there's not a
> lot of feedback from linux-scsi.

Well, it's a bit unlikely that they understand network namespaces.

> I was hoping I could get a brief review on the adding of network
> namespace support here.

Most network namespace work is done on netdev@vger.kernel.org, but they
probably won't understand all the SCSI bits, but perhaps they don't
need to; it's basically the netlink and the filters, right?

The other list that would take a more generic view is the containers
one containers@lists.linux-foundation.org because that's where most
namespace stuff ends up.

James



> Thank you,
> Chris
> 
> On Tue, Oct 31, 2017 at 03:40:55PM -0700, Chris Leech wrote:
> > 
> > This series of changes makes the iSCSI netlink and sysfs control
> > interfaces filtered by network namespace.  This is required to run
> > iscsid in any network namespace other than the initial default one.
> > 
> > Currently the netlink communication will fail if iscsid is started
> > in a non-default network namespace, as there is no kernel side
> > socket.  After fixing that, the rest of these changes are to filter
> > visibility of the iSCSI transport objects by netns.  This allows
> > for multiple iscsid instances to be run, one per netns, each
> > controlling it's own set of iSCSI sessions.
> > 
> > The iSCSI transport objects are filtered, but not the SCSI or block
> > layer devices.  So while iSCSI hosts and sessions become limited to
> > a network namespace, any attached devices remain visible system
> > wide.
> > 
> > This currently only supports iscsi_tcp running in a new namespace,
> > as it creates a virtual host per session.  Support could be added
> > later to allow assignment of iSCSI HBAs to network namespace, much
> > as is done for network interfaces.
> > 
> > Chris Leech (9):
> >   iscsi: create per-net iscsi netlink kernel sockets
> >   iscsi: associate endpoints with a host
> >   iscsi: sysfs filtering by network namespace
> >   iscsi: make all iSCSI netlink multicast namespace aware
> >   iscsi: set netns for iscsi_tcp hosts
> >   iscsi: check net namespace for all iscsi lookups
> >   iscsi: convert flashnode devices from bus to class
> >   iscsi: rename iscsi_bus_flash_* to iscsi_flash_*
> >   iscsi: filter flashnode sysfs by net namespace
> > 
> >  drivers/infiniband/ulp/iser/iscsi_iser.c |   7 +-
> >  drivers/scsi/be2iscsi/be_iscsi.c         |   6 +-
> >  drivers/scsi/bnx2i/bnx2i_iscsi.c         |   6 +-
> >  drivers/scsi/cxgbi/libcxgbi.c            |   6 +-
> >  drivers/scsi/iscsi_tcp.c                 |   7 +
> >  drivers/scsi/qedi/qedi_iscsi.c           |   6 +-
> >  drivers/scsi/qla4xxx/ql4_os.c            |  62 +--
> >  drivers/scsi/scsi_transport_iscsi.c      | 625
> > ++++++++++++++++++++++---------
> >  include/scsi/scsi_transport_iscsi.h      |  63 ++--
> >  9 files changed, 538 insertions(+), 250 deletions(-)
> > 
> > -- 
> > 2.9.5
> > 
> 
