From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [PATCH 2/2  scsi-rc-fixes-2.6] FC Remote Port patch
Date: Wed, 09 Feb 2005 00:15:43 -0800
Message-ID: <4209C6AF.4050303@us.ibm.com>
References: <0B1E13B586976742A7599D71A6AC733C12EB47@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from e33.co.us.ibm.com ([32.97.110.131]:19673 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S261800AbVBIIPv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Feb 2005 03:15:51 -0500
Received: from westrelay03.boulder.ibm.com (westrelay03.boulder.ibm.com [9.17.195.12])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j198FnCO570708
	for <linux-scsi@vger.kernel.org>; Wed, 9 Feb 2005 03:15:50 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay03.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j198Fn1L347194
	for <linux-scsi@vger.kernel.org>; Wed, 9 Feb 2005 01:15:49 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j198Fnbo014315
	for <linux-scsi@vger.kernel.org>; Wed, 9 Feb 2005 01:15:49 -0700
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12EB47@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org


+static void
+fc_rport_terminate(struct fc_rport  *rport)
+{
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct device *dev = &rport->dev;
+	unsigned long flags;
+
+	if (rport->starget) {
+		scsi_forget_target(rport->starget);
+		__scsi_remove_target(rport->starget);
+	}
+
+	transport_remove_device(dev);
+	device_del(dev);
+	transport_destroy_device(dev);
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_del(&rport->peers);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	put_device(&shost->shost_gendev);
+
+	kfree(rport);
  }

Do you want to free the memory in the struct device's release
function like the scsi_device's release function? If userspace
has a sysfs file open and is reading or writing to it at the
same time you free the memory here, will fun things happen?

