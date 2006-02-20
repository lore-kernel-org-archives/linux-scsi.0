From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Fw: slab error in cache_free_debugcheck(): cache `sgpool-8':
Date: Mon, 20 Feb 2006 22:51:53 +0100
Message-ID: <43FA39F9.3010806@s5r6.in-berlin.de>
References: <20051017002339.5156d7f4.akpm@osdl.org> <4353754B.1040500@s5r6.in-berlin.de> <4353FDAD.1010204@chello.be> <43F9019C.3010505@s5r6.in-berlin.de> <43FA1C34.40604@chello.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:16305 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932342AbWBTVwr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Feb 2006 16:52:47 -0500
In-Reply-To: <43FA1C34.40604@chello.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "F. Poncin" <cr27587@chello.be>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

F. Poncin wrote:
> Stefan Richter wrote:
>> Finally there is news for Initio SBP-2 bridges.
>> http://marc.theaimsgroup.com/?l=linux-scsi&m=114038995826749
>>
>> Could you try the scsi_mod parameters mentioned there?
>>
>> Alternatively, update to the latest 1394 drivers (soon to be in -mm, 
[...]
> On my side, the problem seems to be "solved" since mid-December / 
> end-December (linus-git).

Curious. My 1394b INIC-2430F bridge had the following history:
  - 2.6.13-rc2 panics
  - 2.6.14 works, but why?
  - 2.6.15 panics
I ought to start testing 2.6.16-rc.

> latest linus-git:
> ieee1394: sbp2: sbp2_firmware_revision = 407
> 
> ieee1394: sbp2: Logged into SBP-2 device
> ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
> Vendor: Initio Model: ST3400832A Rev: 4.07
> Type: Direct-Access ANSI SCSI revision: 00
> SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
> sdc: Write Protect is off
> sdc: Mode Sense: 00 13 00 00
> sdc: got wrong page
> sdc: assuming drive cache: write through
> SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
> sdc: Write Protect is off
> sdc: Mode Sense: 00 13 00 00
> sdc: got wrong page
> sdc: assuming drive cache: write through
> sdc: sdc1
> sd 8:0:0:0: Attached scsi disk sdc

Hmm. I wonder if this is just luck.

> #echo 8192 > /sys/module/scsi_mod/parameters/default_dev_flags
> #modprobe sbp2
> 
> ieee1394: Error parsing configrom for node 0-00:1023
> => device not recognised.
> 
> #echo "Initio:0KLAT80:8192" > 
> /sys/module/scsi_mod/parameters/default_dev_flags
> #modprobe sbp2
> 
> ieee1394: sbp2: Driver forced to serialize I/O (serialize_io=1)
> ieee1394: sbp2: Try serialize_io=0 for better performance
> scsi9 : SBP-2 IEEE-1394
> ieee1394: sbp2: Logged into SBP-2 device
> ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
> Vendor: Initio Model: ST3400832A Rev: 4.07
> Type: Direct-Access ANSI SCSI revision: 00
> SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
> sdc: Write Protect is off
> sdc: Mode Sense: 00 13 00 00
> sdc: assuming drive cache: write through
> SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
> sdc: Write Protect is off
> sdc: Mode Sense: 00 13 00 00
> sdc: assuming drive cache: write through
> sdc: sdc1
> sd 9:0:0:0: Attached scsi disk sdc

Well, apparently the default_dev_flags syntax does what I intended... :-)

Thanks for testing.
-- 
Stefan Richter
-=====-=-==- --=- =-=--
http://arcgraph.de/sr/
