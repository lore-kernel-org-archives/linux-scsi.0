From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [RFC]: scsi_error: interruptible scsi_block_when_processing_errors()
Date: Wed, 23 Oct 2013 12:02:18 -0400
Message-ID: <5267F30A.1080800@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:58799 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab3JWQC3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Oct 2013 12:02:29 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp.infotech.no (Postfix) with ESMTP id C5547204238
	for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2013 18:02:26 +0200 (CEST)
Received: from smtp.infotech.no ([127.0.0.1])
	by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FWsRzGm9T2u2 for <linux-scsi@vger.kernel.org>;
	Wed, 23 Oct 2013 18:02:25 +0200 (CEST)
Received: from [192.168.48.66] (host-192.252-171-124.dyn.295.ca [192.252.171.124])
	by smtp.infotech.no (Postfix) with ESMTPA id B59E720411D
	for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2013 18:02:24 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

The existing scsi_block_when_processing_errors() function
in scsi_error.c does a non-interruptible wait on the
host_wait work queue. That call is made from many places
in the scsi subsystem ULDs (e.g. the sg driver).

In many cases (e.g. sg_open()) there is a direct path
back to the user space. So why hang open(sg_device) calls
(that don't use O_NONBLOCK) in an non-interruptible call
for what might be a long time.

Apart from signal indications, such a non-interruptible
version of scsi_block_when_processing_errors() could return
useful (possibly negated) errno_s, for example indicating
the device in question had been detached or timed out
(possibly because the HBA was being reset).

Thoughts?

Doug Gilbert

