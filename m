From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH] scsi: ses: don't get power status of SES device slot on probe
Date: Wed, 29 Mar 2017 22:02:10 -0300
Message-ID: <1490835730-13181-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54554 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933094AbdC3BCW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Mar 2017 21:02:22 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2U0xB8n062092
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2017 21:02:21 -0400
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29gfqgbycm-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2017 21:02:21 -0400
Received: from localhost
        by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Wed, 29 Mar 2017 22:02:19 -0300
Received: from d24av03.br.ibm.com (d24av03.br.ibm.com [9.8.31.95])
        by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v2U12HYI17629300
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2017 22:02:17 -0300
Received: from d24av03.br.ibm.com (localhost [127.0.0.1])
        by d24av03.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v2U12HBx009861
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2017 22:02:17 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, songliubraving@fb.com
Cc: dan.j.williams@intel.com, axboe@fb.com, hare@suse.de, hch@lst.de, gpiccoli@linux.vnet.ibm.com

The commit 08024885a2a3 ("ses: Add power_status to SES device slot")
introduced the 'power_status' attribute to enclosure components and
the associated callbacks.

There are 2 callbacks available to get the power status of a device:
1) ses_get_power_status() for 'struct enclosure_component_callbacks'
2) get_component_power_status() for the sysfs device attribute
(these are available for kernel-space and user-space, respectively.)

However, despite both methods being available to get power status
on demand, that commit also introduced a call to get power status
in ses_enclosure_data_process().

This dramatically increased the total probe time for SCSI devices
on larger configurations, because ses_enclosure_data_process() is
called several times during the SCSI devices probe and loops over
the component devices (but that is another problem, another patch).

That results in a tremendous continuous hammering of SCSI Receive
Diagnostics commands to the enclosure-services device, which does
delay the total probe time for the SCSI devices __significantly__:

  Originally, ~34 minutes on a system attached to ~170 disks:

    [ 9214.490703] mpt3sas version 13.100.00.00 loaded
    ...
    [11256.580231] scsi 17:0:177:0: qdepth(16), tagged(1), simple(0),
                   ordered(0), scsi_level(6), cmd_que(1)

  With this patch, it decreased to ~2.5 minutes -- a 13.6x faster

    [ 1002.992533] mpt3sas version 13.100.00.00 loaded
    ...
    [ 1151.978831] scsi 11:0:177:0: qdepth(16), tagged(1), simple(0),
                   ordered(0), scsi_level(6), cmd_que(1)

Another downside is that the SCSI device class lock is held during
the executions of ses_enclosure_data_process() since it's a callee
of ses_intf_add(), which is executed under that lock in device_add().
This ends up blocking the parallel SCSI scan functionality because
device_add() depends on that lock, and also the removal of devices
via device_del() (e.g., during an enclosure reboot).

Back to the commit discussion.. on the ses_get_power_status() call
introduced in ses_enclosure_data_process(): impact of removing it.

That may possibly be in place to initialize the power status value
on device probe.  However, those 2 functions available to retrieve
that value _do_ automatically refresh/update it.  So the potential
benefit would be a direct access of the 'power_status' field which
does not use the callbacks...

But the only reader of 'struct enclosure_component::power_status'
is the get_component_power_status() callback for sysfs attribute,
and it _does_ check for and call the .get_power_status callback,
(which indeed is defined and implemented by that commit), so the
power status value is, again, automatically updated.

So, the remaining potential for a direct/non-callback access to
the power_status attribute would be out-of-tree modules -- well,
for those, if they are for whatever reason interested in values
that are set during device probe and not up-to-date by the time
they need it.. well, that would be curious.

So, for out-of-tree modules and people still interested in this
behavior (in case I might have missed something about it, other
than the total probe time impact): let's add a module parameter
to keep that check turned on (disabled by default).

Also, to handle that more properly, set the initial power state
value to '-1' (i.e., uninitialized) instead of '1' (power 'on'),
and check for it in that callback which may do an direct access
to the field value _if_ a callback function is not defined.

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Fixes: 08024885a2a3 ("ses: Add power_status to SES device slot")
---
 drivers/misc/enclosure.c | 6 +++++-
 drivers/scsi/ses.c       | 9 ++++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 65fed7146e9b..d3a8a13c4247 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -148,7 +148,7 @@ struct enclosure_device *
 	for (i = 0; i < components; i++) {
 		edev->component[i].number = -1;
 		edev->component[i].slot = -1;
-		edev->component[i].power_status = 1;
+		edev->component[i].power_status = -1;
 	}
 
 	mutex_lock(&container_list_lock);
@@ -594,6 +594,10 @@ static ssize_t get_component_power_status(struct device *cdev,
 
 	if (edev->cb->get_power_status)
 		edev->cb->get_power_status(edev, ecomp);
+
+	if (ecomp->power_status == -1)
+		return -EINVAL;
+
 	return snprintf(buf, 40, "%s\n", ecomp->power_status ? "on" : "off");
 }
 
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 50adabbb5808..2fafefd419c1 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -36,6 +36,12 @@
 
 #include <scsi/scsi_transport_sas.h>
 
+static bool power_status_on_probe;	/* default: false, 0. */
+module_param(power_status_on_probe, bool, 0644);
+MODULE_PARM_DESC(power_status_on_probe, "get power status of SES device slots "
+					"(enclosure components) at probe time "
+					"(warning: may delay total probe time)");
+
 struct ses_device {
 	unsigned char *page1;
 	unsigned char *page1_types;
@@ -548,7 +554,8 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 					ecomp = &edev->component[components++];
 
 				if (!IS_ERR(ecomp)) {
-					ses_get_power_status(edev, ecomp);
+					if (power_status_on_probe)
+						ses_get_power_status(edev, ecomp);
 					if (addl_desc_ptr)
 						ses_process_descriptor(
 							ecomp,
-- 
1.8.3.1
