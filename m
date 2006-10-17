From: "Qi, Yanling" <Yanling.Qi@lsi.com>
Subject: sg_remove and pending write request
Date: Tue, 17 Oct 2006 12:45:12 -0600
Message-ID: <0F08E10B769EAF4EA2C43A573B8CC87F60B323@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:36592 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751376AbWJQSpZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Oct 2006 14:45:25 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id k9HIifD2004963
	for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2006 11:44:41 -0700 (PDT)
Received: from namail.ad.lsil.com (namail.co.lsil.com [172.21.36.18])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id k9HIjGx9021809
	for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2006 11:45:28 -0700
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi All,

We are running a test case of SAS cable pull/push on a SAS RAID system.
After the SAS cable is pulled from a SAS RAID, scsi devices are deleted.
And then when the cable is pushed back, the scsi device with the same
H:C:T:L sometime will be assigned to a diffent sgX.

Reading through the sg.c, it seems that if the sg device has a pending
write request, the sg slot (sg_dev_arr[k] = NULL) will not be freed
during sg_remove time. Can someone confirm this?

If this is the case, what the user space process do to prevent this from
happening?

I see that the sg.c sends SIGPOLL to the user space process
(kill_fasync(&sfp->async_qp, SIGPOLL,POLL_HUP);), what this signal will
be translated to the user space return-code from read/write call?

Thanks,

Yanling
