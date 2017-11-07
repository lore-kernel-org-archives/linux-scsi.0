From: Chris Leech <cleech@redhat.com>
Subject: Re: [PATCH 0/9] use network namespace for iSCSI control interfaces
Date: Tue, 7 Nov 2017 09:44:13 -0800
Message-ID: <20171107174413.GB29597@straylight.hirudinean.org>
References: <20171031224104.17735-1-cleech@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41734 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753909AbdKGRoP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Nov 2017 12:44:15 -0500
Content-Disposition: inline
In-Reply-To: <20171031224104.17735-1-cleech@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
Cc: Lee Duncan <lduncan@suse.com>

Anyone have comments or criticisms?  Lee?

Suggestions on anyone else I should be pinging for feedback?
These changes are in the iSCSI code, but are all netlink and sysfs
related namespace issues so I get that it's not a typical SCSI review.

- Chris

On Tue, Oct 31, 2017 at 03:40:55PM -0700, Chris Leech wrote:
> This series of changes makes the iSCSI netlink and sysfs control
> interfaces filtered by network namespace.  This is required to run
> iscsid in any network namespace other than the initial default one.
> 
> Currently the netlink communication will fail if iscsid is started in a
> non-default network namespace, as there is no kernel side socket.  After
> fixing that, the rest of these changes are to filter visibility of the
> iSCSI transport objects by netns.  This allows for multiple iscsid
> instances to be run, one per netns, each controlling it's own set of
> iSCSI sessions.
> 
> The iSCSI transport objects are filtered, but not the SCSI or block
> layer devices.  So while iSCSI hosts and sessions become limited to a
> network namespace, any attached devices remain visible system wide.
> 
> This currently only supports iscsi_tcp running in a new namespace, as it
> creates a virtual host per session.  Support could be added later to
> allow assignment of iSCSI HBAs to network namespace, much as is done for
> network interfaces.
> 
> Chris Leech (9):
>   iscsi: create per-net iscsi netlink kernel sockets
>   iscsi: associate endpoints with a host
>   iscsi: sysfs filtering by network namespace
>   iscsi: make all iSCSI netlink multicast namespace aware
>   iscsi: set netns for iscsi_tcp hosts
>   iscsi: check net namespace for all iscsi lookups
>   iscsi: convert flashnode devices from bus to class
>   iscsi: rename iscsi_bus_flash_* to iscsi_flash_*
>   iscsi: filter flashnode sysfs by net namespace
> 
>  drivers/infiniband/ulp/iser/iscsi_iser.c |   7 +-
>  drivers/scsi/be2iscsi/be_iscsi.c         |   6 +-
>  drivers/scsi/bnx2i/bnx2i_iscsi.c         |   6 +-
>  drivers/scsi/cxgbi/libcxgbi.c            |   6 +-
>  drivers/scsi/iscsi_tcp.c                 |   7 +
>  drivers/scsi/qedi/qedi_iscsi.c           |   6 +-
>  drivers/scsi/qla4xxx/ql4_os.c            |  62 +--
>  drivers/scsi/scsi_transport_iscsi.c      | 625 ++++++++++++++++++++++---------
>  include/scsi/scsi_transport_iscsi.h      |  63 ++--
>  9 files changed, 538 insertions(+), 250 deletions(-)
> 
> -- 
> 2.9.5
> 
