From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH v2] scsi: ses: don't get power status of SES device slot on probe
Date: Wed,  5 Apr 2017 12:18:19 -0300
Message-ID: <1491405499-5429-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34571 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753805AbdDEPTA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2017 11:19:00 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v35FDs0a110600
        for <linux-scsi@vger.kernel.org>; Wed, 5 Apr 2017 11:18:59 -0400
Received: from e24smtp04.br.ibm.com (e24smtp04.br.ibm.com [32.104.18.25])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29n14wymmj-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 05 Apr 2017 11:18:59 -0400
Received: from localhost
        by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Wed, 5 Apr 2017 12:18:57 -0300
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
        by d24relay04.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v35FIona33095916
        for <linux-scsi@vger.kernel.org>; Wed, 5 Apr 2017 12:18:55 -0300
Received: from d24av02.br.ibm.com (localhost [127.0.0.1])
        by d24av02.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v35FIYgg029479
        for <linux-scsi@vger.kernel.org>; Wed, 5 Apr 2017 12:18:35 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, songliubraving@fb.com, dan.j.williams@intel.com
Cc: jejb@linux.vnet.ibm.com, axboe@fb.com, hare@suse.de, hch@lst.de, gpiccoli@linux.vnet.ibm.com

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

Well, to handle that more properly, set the initial power state
value to '-1' (i.e., uninitialized) instead of '1' (power 'on'),
and check for it in that callback which may do an direct access
to the field value _if_ a callback function is not defined.

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Fixes: 08024885a2a3 ("ses: Add power_status to SES device slot")
---

v2:
 - remove module parameter.
 - better return values for -1/uninitalized power_status.
   (thanks: Dan Williams <dan.j.williams@intel.com>)

 drivers/misc/enclosure.c | 7 ++++++-
 drivers/scsi/ses.c       | 1 -
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 65fed7146e9b..d3fe3ea902d4 100644
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
@@ -594,6 +594,11 @@ static ssize_t get_component_power_status(struct device *cdev,
 
 	if (edev->cb->get_power_status)
 		edev->cb->get_power_status(edev, ecomp);
+
+	/* If still uninitialized, the callback failed or does not exist. */
+	if (ecomp->power_status == -1)
+		return (edev->cb->get_power_status) ? -EIO : -ENOTTY;
+
 	return snprintf(buf, 40, "%s\n", ecomp->power_status ? "on" : "off");
 }
 
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 50adabbb5808..f1cdf32d7514 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -548,7 +548,6 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 					ecomp = &edev->component[components++];
 
 				if (!IS_ERR(ecomp)) {
-					ses_get_power_status(edev, ecomp);
 					if (addl_desc_ptr)
 						ses_process_descriptor(
 							ecomp,
-- 
1.8.3.1
