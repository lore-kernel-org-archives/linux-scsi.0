From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] Workqueue framework and ALUA hardware handler
Date: Thu, 15 Nov 2007 10:13:52 +0100
Message-ID: <473C0DD0.7080702@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:41827 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbXKOJNx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Nov 2007 04:13:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi all,

this patchset adds some more abstraction to the multipath
hardware handlers.
- A generic workqueue framework is added, which allows the
  hardware handler to submit failover commands independent
  from multipath I/O.
- The exsting RDAC hardware handler is converted to use that
  framework
- A new SPC-3 ALUA hardware handler is added, using that
  framework
- A controller abstraction is added to the framework, which
  allows for command throttling based on the used controller.
- The RDAC hardware handler is modified to use the new
  controller framework.

This patchset superseded my previous implementation of the
SPC-3 ALUA handler.
Next plans are to update the table definitions and multipath-tools
to allow for a passing of the controller ID from userland; ALUA
doesn't specify for any controller information, so we have to
do this by hand based on prior knowledge of the storage array.

As per normal, comments etc welcome.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
