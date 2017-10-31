From: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/9] use network namespace for iSCSI control interfaces
Date: Tue, 31 Oct 2017 15:40:55 -0700
Message-ID: <20171031224104.17735-1-cleech@redhat.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBCYMVIPVXQMBBGXY4PHQKGQE3ACVN5Q-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This series of changes makes the iSCSI netlink and sysfs control
interfaces filtered by network namespace.  This is required to run
iscsid in any network namespace other than the initial default one.

Currently the netlink communication will fail if iscsid is started in a
non-default network namespace, as there is no kernel side socket.  After
fixing that, the rest of these changes are to filter visibility of the
iSCSI transport objects by netns.  This allows for multiple iscsid
instances to be run, one per netns, each controlling it's own set of
iSCSI sessions.

The iSCSI transport objects are filtered, but not the SCSI or block
layer devices.  So while iSCSI hosts and sessions become limited to a
network namespace, any attached devices remain visible system wide.

This currently only supports iscsi_tcp running in a new namespace, as it
creates a virtual host per session.  Support could be added later to
allow assignment of iSCSI HBAs to network namespace, much as is done for
network interfaces.

Chris Leech (9):
  iscsi: create per-net iscsi netlink kernel sockets
  iscsi: associate endpoints with a host
  iscsi: sysfs filtering by network namespace
  iscsi: make all iSCSI netlink multicast namespace aware
  iscsi: set netns for iscsi_tcp hosts
  iscsi: check net namespace for all iscsi lookups
  iscsi: convert flashnode devices from bus to class
  iscsi: rename iscsi_bus_flash_* to iscsi_flash_*
  iscsi: filter flashnode sysfs by net namespace

 drivers/infiniband/ulp/iser/iscsi_iser.c |   7 +-
 drivers/scsi/be2iscsi/be_iscsi.c         |   6 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c         |   6 +-
 drivers/scsi/cxgbi/libcxgbi.c            |   6 +-
 drivers/scsi/iscsi_tcp.c                 |   7 +
 drivers/scsi/qedi/qedi_iscsi.c           |   6 +-
 drivers/scsi/qla4xxx/ql4_os.c            |  62 +--
 drivers/scsi/scsi_transport_iscsi.c      | 625 ++++++++++++++++++++++---------
 include/scsi/scsi_transport_iscsi.h      |  63 ++--
 9 files changed, 538 insertions(+), 250 deletions(-)

-- 
2.9.5

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
