From: Douglas Gilbert <dgilbert@interlog.com>
Subject: scsi_check_sense() interfering with pass-through SCSI calls
Date: Tue, 27 Mar 2012 17:13:10 -0400
Message-ID: <4F722D66.8070702@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:56812 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab2C0VNU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Mar 2012 17:13:20 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp.infotech.no (Postfix) with ESMTP id 9AAD9204170
	for <linux-scsi@vger.kernel.org>; Tue, 27 Mar 2012 23:13:16 +0200 (CEST)
Received: from smtp.infotech.no ([127.0.0.1])
	by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MsFzD5HWVuQI for <linux-scsi@vger.kernel.org>;
	Tue, 27 Mar 2012 23:13:15 +0200 (CEST)
Received: from [192.168.48.66] (host-208-72-125-5.dyn.295.ca [208.72.125.5])
	by smtp.infotech.no (Postfix) with ESMTPA id 4D714204119
	for <linux-scsi@vger.kernel.org>; Tue, 27 Mar 2012 23:13:15 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have been sent an example of sg_verify giving strange results
in BYTCHK mode. A bus analyzer is showing a properly formed
sense buffer with a sense_key of MISCOMPARE. In lk 3.3.0
scsi_check_sense() is detecting this case and setting
DID_TARGET_ERROR. For a pass-through call originating from
the sg or bsg driver that is unwelcome interference.

Since users of a SCSI command pass-through should be
checking the SCSI status and sense buffer, then commands
issued by the bsg and sg driver (probably st as well)
should not be calling scsi_check_sense() IMO.

Doug Gilbert

