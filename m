From: Chris Worley <chrisw@lnxi.com>
Subject: SCSI Disk layer performance
Date: 21 Jan 2004 14:31:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074720667.19927.384.camel@localhost.lnxi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 208.177.141.226.ptr.us.xo.net ([208.177.141.226]:43809 "EHLO
	localhost.lnxi.com") by vger.kernel.org with ESMTP id S264163AbUAUVg0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2004 16:36:26 -0500
Received: from localhost (localhost [127.0.0.1])
	by localhost.lnxi.com (8.11.6/8.11.6) with ESMTP id i0LLV8k22563
	for <linux-scsi@vger.kernel.org>; Wed, 21 Jan 2004 14:31:10 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

My FC array seems to be faster than Linux can handle.

Even though I'm using FC-2 cards, Linux seems to put
an artificial limit at FC-1 speeds.  This is true in two cases:

        1) dd to the raw device (actually, the limit is at about
        120MB/s).
        2) dd over the file system, even reading/writing multiple files
        simultaneously (about 90MB/s). 
        
Using sgp_dd, I can easily get >190MB/s, but neither sg_dd or dd do as
well (so, it's not the qla2300 module... it's something above).

Is there any method that might assure more parallel I/O in the SCSI
layer?  Is 2.6 the answer?

I've also seen some differences between 2.4 kernels.  2.4.21 gets
120MB/s via "dd" to the raw device, until the sg module is loaded, then
it drops down to less than 100MB/s, and there are frequent memory
warnings.  2.4.23 and .24 don't get the warnings, but irrespective of
the sg module being loaded, get the slower speed on the raw device.  I'm
guessing that'll translate to even slower speeds on the file system, but
I've yet to test that.

Furthermore, my reads seem to be especially slow.  The SAN maker thinks
that this might be due to the I/O scheduling in the SCSI Disk layer. 
Specifically, it's easy to see from the SAN perspective (using a
statistics utility that shows read and write scsi command lengths) that
reads are broken into small chunks by the SCSI Disk layer.  In watching
read lengths from the SAN, using "sg_dd", you can exactly specify read
length, and no I/O's get broken up into chunks smaller than the bpt*512
(what is requested on the sg_dd command line is what the SAN sees).  In
"dd", you can specify a read block size on the command line, but the SAN
shows that Linux is breaking that up into much smaller chunks.

Is there any way to force Linux to use large chunks?

Thanks,

Chris 
-- 
Chris Worley <chrisw@lnxi.com>
Linux Networx

