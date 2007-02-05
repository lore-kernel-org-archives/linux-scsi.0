From: "Cameron, Steve" <Steve.Cameron@hp.com>
Subject: SG_IO weirdness
Date: Mon, 5 Feb 2007 17:59:51 -0000
Message-ID: <558F4D473FD7FE419B019232BF2D37B40B22F2@G3W0634.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas02.cce.hp.com ([161.114.21.105]:52277 "EHLO
	ccerelbas02.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbXBESUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Feb 2007 13:20:38 -0500
Received: from G3W0060.americas.hpqcorp.net (g3w0060.americas.hpqcorp.net [16.232.1.19])
	by ccerelbas02.cce.hp.com (Postfix) with ESMTP id 6B524343AB
	for <linux-scsi@vger.kernel.org>; Mon,  5 Feb 2007 11:59:52 -0600 (CST)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I noticed that when I do two SG_IO ioctls to a target
device (say, tape drive, disk drive, whatever) in which
the first request is well formed (e.g. an inquiry) and the 
second one has a malformed CDB, such that it gets check condition 
with sense key == 5 (ILLEGAL REQUEST), the data buffer returned for 
the second malformed SG_IO request is filled out with the same 
data as was returned for the first successful command (e.g. the 
same inquiry data again.)  I'm using separate data buffers for
the two commands, and memsetting them to zero before calling
ioctl().  I don't think this data is coming from the device,
as it happens with every device I've tried.

Is that normal?  Seems like for a malformed request, the 
data buffer should not be transferred at all, much less
transferred with contents of a prior request's data buffer.

Kernel is 2.6.18 from kernel.org.

The two requests were done from the same process, I haven't
tried two separate processes to see if one process could
by this method access another process's data.  I did try
using two devices, so the first well formed command went 
to one device, and the 2nd, malformed command went to another
device.  In that case, I didn't get the same buffer back again,
but garbage. (some recognizeable strings, "en_US" was in there...)

Is this a problem, or is this a matter of "just don't do that."?

Thanks,

-- steve
