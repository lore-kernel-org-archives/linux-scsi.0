From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] remove target parent limitiation
Date: Fri, 13 Jan 2006 12:01:53 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1AA5F3@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39316 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1422825AbWAMTCH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 14:02:07 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

On Friday, January 13, 2006 11:04 AM, Christoph Hellwig wrote:

> When James Smart fixed the issue of the userspace scan atributes
> crashing the system with the FC transport class he added a patch to
> let the transport class check if the parent is valid for a given
> transport class.
> 
> When adding support for the integrated raid of fusion sas devices
> we ran into a problem with that, as it didn't allow adding virtual
> raid volumes without the transport class knowing about it.
> 
> So this patch adds a user_scan attribute instead, that takes over from
> scsi_scan_host_selected if the transport class sets it and thus lets
> the transport class control the user-initiated scanning.  As this
> plugs the hole about user-initiated scanning the target_parent hook
> goes away and we rely on callers of the scanning routines to do
> something sensible.
> 
> For SAS this meant I had to switch from a spinlock to a mutex to
> synchronize the topology linked lists, in FC they were completely
> unsynchronized which seems wrong.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

I noticed that rebasing the James git tree this morning, and 
applying this patch, the following was missing.  This patch
submitted earlier by Christoph solves the panic that occurs when
unloading the mptsas modules, and reloading.  Please apply.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


--- scsi-misc-2.6-old/drivers/scsi/scsi_transport_sas.c	2006-01-13
11:44:08.000000000 -0700
+++ scsi-misc-2.6/drivers/scsi/scsi_transport_sas.c	2006-01-13
11:47:06.000000000 -0700
@@ -688,7 +688,17 @@
 	struct Scsi_Host *shost = dev_to_shost(parent->dev.parent);
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
 
-	scsi_remove_target(dev);
+	switch (rphy->identify.device_type) {
+	case SAS_END_DEVICE:
+		scsi_remove_target(dev);
+		break;
+	case SAS_EDGE_EXPANDER_DEVICE:
+	case SAS_FANOUT_EXPANDER_DEVICE:
+		device_for_each_child(dev, NULL, do_sas_phy_delete);
+		break;
+	default:
+		break;
+	}
 
 	transport_remove_device(dev);
 	device_del(dev);
