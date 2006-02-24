From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 0/2] Block I/O while SG reset operation in progress
Date: Fri, 24 Feb 2006 11:52:02 -0500
Message-ID: <43FF39B2.3090302@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50891 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932378AbWBXQwW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Feb 2006 11:52:22 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k1OGqCrf026310
	for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2006 08:52:15 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

As promised in a previous thread:
http://marc.theaimsgroup.com/?l=linux-scsi&m=113321277408600&w=2

The midlayer today allows for calls to the eh handlers via sg to occur
while i/o continues to be sent to the drive run abated.

This patch ensures that i/o is stopped while an eh handler is being
processed. It adds a new flag, set by the async reset callers, which
augments the host-in-reset checks and stops i/o.  The async reset
callers are already synchronized to hold off until the error thread is
no longer running.

There are 2 parts to this patch:
  - the patch to the midlayer to stop i/o while resetting
  - a patch to the lpfc driver which removes the barrier the driver
    had implemented in the past.

-- james s


