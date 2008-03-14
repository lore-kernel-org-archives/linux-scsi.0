From: Hannes Reinecke <hare@suse.de>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Fri, 14 Mar 2008 15:13:50 +0100
Message-ID: <47DA881E.3080500@suse.de>
References: <20080313210655.GA13468@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080202000004050909060108"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:46982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbYCNONw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Mar 2008 10:13:52 -0400
In-Reply-To: <20080313210655.GA13468@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Tony Jones <tonyj@suse.de>, Kay Sievers <kay.sievers@vrfy.org>

This is a multi-part message in MIME format.
--------------080202000004050909060108
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Greg KH wrote:
> Here's a huge patch from Tony and Kay that converts the scsi layer to
> use struct device instead of class_device.
> 
> It doesn't seem like it could be split up any smaller due to the
> interconectedness of the whole mess, if you have any suggestions
> otherwise, it would be appreciated.
> 
> If you want, I can take this through my tree as it does depend on a
> previous IB patch to make that portion of the patch much smaller.
> 
> After this, all of the class_device code is now finally gone from the
> kernel!
> 
Unfortunately, it doesn't apply cleanly to the current scsi-misc tree.
I've modified it so that it actually compiles.

Good that you've sent it; now I can finally push my scsi target rework
patches.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------080202000004050909060108
Content-Type: text/plain;
 name="convert_scsi_layer_to_use_struct_device"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="convert_scsi_layer_to_use_struct_device"

From: Tony Jones <tonyj@suse.de>
Subject: SCSI: convert struct class_device to struct device

It's big, but there doesn't seem to be a way to split it up smaller...

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>

---
 block/bsg.c                           |   11 +-
 drivers/ata/ahci.c                    |    4 +-
 drivers/ata/libata-scsi.c             |   15 +-
 drivers/base/attribute_container.c    |   77 +++---
 drivers/base/transport_class.c        |   14 +-
 drivers/infiniband/ulp/srp/ib_srp.c   |  134 +++++-----
 drivers/infiniband/ulp/srp/ib_srp.h   |    2 +-
 drivers/message/fusion/mptscsih.c     |  122 +++++----
 drivers/message/fusion/mptscsih.h     |    2 +-
 drivers/misc/enclosure.c              |  118 +++++----
 drivers/scsi/3w-9xxx.c                |    9 +-
 drivers/scsi/3w-xxxx.c                |    9 +-
 drivers/scsi/aacraid/aachba.c         |    2 +-
 drivers/scsi/aacraid/aacraid.h        |    4 +-
 drivers/scsi/aacraid/linit.c          |   93 ++++---
 drivers/scsi/arcmsr/arcmsr.h          |    4 +-
 drivers/scsi/arcmsr/arcmsr_attr.c     |  163 +++++++-----
 drivers/scsi/ch.c                     |   13 +-
 drivers/scsi/hosts.c                  |   34 ++--
 drivers/scsi/hptiop.c                 |   14 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c      |   44 ++--
 drivers/scsi/ibmvscsi/ibmvstgt.c      |   25 +-
 drivers/scsi/ipr.c                    |  140 +++++-----
 drivers/scsi/lpfc/lpfc_attr.c         |  484 +++++++++++++++++---------------
 drivers/scsi/lpfc/lpfc_crtn.h         |    4 +-
 drivers/scsi/megaraid/megaraid_mbox.c |   13 +-
 drivers/scsi/ncr53c8xx.c              |    7 +-
 drivers/scsi/osst.c                   |   76 +++---
 drivers/scsi/pcmcia/sym53c500_cs.c    |   14 +-
 drivers/scsi/qla2xxx/qla_attr.c       |  177 +++++++------
 drivers/scsi/qla2xxx/qla_gbl.h        |    4 +-
 drivers/scsi/raid_class.c             |   73 +++---
 drivers/scsi/scsi_sas_internal.h      |   24 +-
 drivers/scsi/scsi_sysfs.c             |  150 ++++++-----
 drivers/scsi/scsi_transport_fc.c      |  385 ++++++++++++++------------
 drivers/scsi/scsi_transport_iscsi.c   |  107 ++++----
 drivers/scsi/scsi_transport_sas.c     |  157 ++++++-----
 drivers/scsi/scsi_transport_spi.c     |  185 +++++++------
 drivers/scsi/scsi_transport_srp.c     |   26 +-
 drivers/scsi/sd.c                     |   78 +++---
 drivers/scsi/ses.c                    |   28 +-
 drivers/scsi/sg.c                     |   36 ++--
 drivers/scsi/st.c                     |   83 +++---
 include/linux/attribute_container.h   |   28 +-
 include/linux/bsg.h                   |    2 +-
 include/linux/enclosure.h             |   11 +-
 include/linux/libata.h                |    2 +-
 include/linux/raid_class.h            |   12 +-
 include/linux/transport_class.h       |    6 +-
 include/scsi/scsi_device.h            |   10 +-
 include/scsi/scsi_host.h              |    7 +-
 include/scsi/scsi_transport.h         |    2 +-
 include/scsi/scsi_transport_fc.h      |   14 +-
 include/scsi/scsi_transport_sas.h     |   12 +-
 include/scsi/sd.h                     |    4 +-
 55 files changed, 1763 insertions(+), 1511 deletions(-)

--------------080202000004050909060108--
