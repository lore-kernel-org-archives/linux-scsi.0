From: "N.C.Krishna Murthy" <krmurthy@cisco.com>
Subject: two SCSI HBAs having same host no in Linux 2.4 kernel
Date: Wed, 17 Mar 2004 19:40:23 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200403171940.23006.krmurthy@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ind-iport-1-sec.cisco.com ([64.104.129.9]:15201 "EHLO
	ind-iport-1.cisco.com") by vger.kernel.org with ESMTP
	id S261460AbUCQOKq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2004 09:10:46 -0500
Received: from krmurthy1-lnx.cisco.com (krmurthy1-lnx.cisco.com [10.77.7.60])
	by india-core-1.cisco.com (8.12.10/8.12.6) with ESMTP id i2HEAQEi027718
	for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2004 06:10:27 -0800 (PST)
Received: from localhost (localhost [[UNIX: localhost]])
	by krmurthy1-lnx.cisco.com (8.11.6/8.11.6) id i2HEANs09722
	for linux-scsi@vger.kernel.org; Wed, 17 Mar 2004 19:40:23 +0530
List-Id: linux-scsi@vger.kernel.org
To: SCSI -DEVELOPERS <linux-scsi@vger.kernel.org>

Hi,
	In 2.4 kernel ,a scsi HBA driver gets it's host no after scsi_register() call 
returns.
The call to scsi_register is made from the driver's 'detect' routine.
scsi_register_host calls the driver's 'detect' routine.

The following is an excerpt from scsi_register_host which does the above job.
-----------------------------------------------------------------------------
if (tpnt->use_new_eh_code) {
                spin_lock_irqsave(&io_request_lock, flags);
                tpnt->present = tpnt->detect(tpnt);
                spin_unlock_irqrestore(&io_request_lock, flags);
        } else
                tpnt->present = tpnt->detect(tpnt);
-----------------------------------------------------------------------------
In case of drivers which do not support new_eh_code, 'detect' is called
without any locks. Is this SMP safe? 

We were testing our iSCSI driver on an SMP machine which had a FC HBA as well.
Both iSCSI driver and FC HBA had the same host no allocated. The behaviour
could not be reproduced consistently though. 

Please let me know in case I am missing something.


Thanx
N.C.Krishna Murthy

