From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: Transport Attributes -- attempt#3
Date: Thu, 15 Jan 2004 13:52:16 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF2D4C46F4.BCE421EB-ONC1256E1C.0045A5CA-C1256E1C.00472906@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:5800 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S266771AbUAOMwp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2004 07:52:45 -0500
List-Id: linux-scsi@vger.kernel.org
To: Martin Hicks <mort@wildopensource.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

Hi,

+     if (sdev->transport_classdev.class) {
+           attrs = sdev->host->transportt->attrs;
+           for (i = 0; attrs[i]; i++) {
+                 error = class_device_create_file
(&sdev->transport_classdev,
+                                         attrs[i]);
+                 if (error)
+                       scsi_remove_device(sdev);
+           }
+     }

Isn't there a break needed in the error case to quit
the loop after scsi_remove_device(sdev) in order to
avoid trouble with sdev in subsequent iterations?
I am not very familiar with the 2.6 SCSI code. But,
is scsi_remove_device(sdev) an appropriate answer
to the failed registration of sysfs attributes?


Martin Peschke

IBM Deutschland Entwicklung GmbH
Linux for eServer Development
Phone: +49-(0)7031-16-2349


Martin Hicks <mort@wildopensource.com>@vger.kernel.org on 14/01/2004
19:12:41

Sent by:    linux-scsi-owner@vger.kernel.org


To:    Christoph Hellwig <hch@infradead.org>
cc:    linux-scsi@vger.kernel.org
Subject:    Transport Attributes -- attempt#3




Hi,

Here is round#3 of the patch.  I think I've addressed all of the points
that were brought up by Christoph last time.

Once again, three patches:  core, qla1280 and qla2xxx.  The core patch
expects to be applied on top of the patch that I sent recently to
linux-scsi:

http://marc.theaimsgroup.com/?l=linux-scsi&m=107366419027588&w=2

thanks
mh

--
Martin Hicks                Wild Open Source Inc.
mort@wildopensource.com     613-266-2296







