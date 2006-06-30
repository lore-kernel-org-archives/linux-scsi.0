From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH] mptsas: eliminate ghost devices
Date: Fri, 30 Jun 2006 15:07:20 -0600
Message-ID: <20060630210720.GA10260@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39318 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932641AbWF3VSd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jun 2006 17:18:33 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Friday, June 30, 2006 11:54 AM, James Bottomley wrote:
> The attached patch eliminates all these ghosts by not allocating any
> devices for them if the SAS address is the SAS address of the parent.

In older version of sas transport, it wouldn't work unless the ghost
remote phys were reported. I'm glad to see this restriction go away.

> @@ -1647,6 +1649,27 @@ static int mptsas_probe_one_phy(struct d
> 				goto out;
> 
> 		mptsas_parse_device_info(&identify, &phy_info->attached);
>+		if (scsi_is_host_device(parent)) {
>+			struct mptsas_portinfo *port_info;
>+			int i;
>+
>+			mutex_lock(&ioc->sas_topology_mutex);
>+			port_info = mptsas_find_portinfo_by_handle(ioc,
>+
>ioc->handle);
>+			mutex_unlock(&ioc->sas_topology_mutex);
>+
>+			for (i = 0; i < port_info->num_phys; i++)
>+				if
>(port_info->phy_info[i].identify.sas_address ==
>+				    identify.sas_address)
>+					goto out;
>+

This is code segment is not required.  This can be done much simplier.
All hba phys that are connected to an expander will have device type
equal to END_DEVICE and the target_port_protocols set to zero.  Here
is my suggested patch, to apply over previous patch making
expander port_ids zero based.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2006-06-29 17:38:43.000000000 -0600
+++ a/drivers/message/fusion/mptsas.c	2006-06-30 14:57:37.000000000 -0600
@@ -1635,8 +1635,10 @@ static int mptsas_probe_one_phy(struct d
 	if (!mptsas_get_rphy(phy_info) && port && !port->rphy) {
 
 		struct sas_rphy *rphy;
+		struct device *parent;
 		struct sas_identify identify;
 
+		parent = dev->parent->parent;
 		/*
 		 * Let the hotplug_work thread handle processing
 		 * the adding/removing of devices that occur
@@ -1647,6 +1649,17 @@ static int mptsas_probe_one_phy(struct d
 				goto out;
 
 		mptsas_parse_device_info(&identify, &phy_info->attached);
+		if (scsi_is_host_device(parent)) {
+			if (!identify.target_port_protocols &&
+				(identify.device_type == SAS_END_DEVICE))
+				goto out;
+		} else if (scsi_is_sas_rphy(parent)) {
+			struct sas_rphy *parent_rphy = dev_to_rphy(parent);
+			if (identify.sas_address ==
+			    parent_rphy->identify.sas_address)
+				goto out;
+		}
+
 		switch (identify.device_type) {
 		case SAS_END_DEVICE:
 			rphy = sas_end_device_alloc(port);




