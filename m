From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Where is max_scsi_adapter_scatter_gather_elements found in the
 Linux source code?
Date: Wed, 22 Sep 2004 14:44:00 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41510310.4040500@torque.net>
References: <16236EEEF4D4264DA31C2E35E3607CFE08EA23@coex02.trans.corp>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:32164 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S267864AbUIVEpF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 00:45:05 -0400
In-Reply-To: <16236EEEF4D4264DA31C2E35E3607CFE08EA23@coex02.trans.corp>
List-Id: linux-scsi@vger.kernel.org
To: Nate Iverson <niverson@pillardata.com>
Cc: linux-scsi@vger.kernel.org

Nate Iverson wrote:
>>I'm resending this becuase I missed the http links are treated as SPAM thing.
>>
>>In en.tldp.org/HOWTO/SCSI-Generic-HOWTO/dio.html it says 
>>
>>Notes
>>
>>[1]	Unfortunately that setup time is large enough in some 
 >> versions of the lk 2.4 series to adversely impact direct IO
 >> performance. Also memory malloc()-ed in the user space
 >> tends to be made up of discontinuous pages seen from the
 >> SCSI adapter. This requires the sg driver to build heavily
 >> splintered scatter gather lists which is less than desirable.
 >> This limits the maximum transfer size to
 >> [(max_scsi_adapter_scatter_gather_elements - 1) * PAGE_SIZE].
 >> [This is a _different_ scatter gather mechanism to that which
 >> the user sees in the sg interface based on iovec.]
>>
>>
>>I have grepped through the Linux source code, but I can't find 
 >> max_scsi_adapter_scatter_gather_elements. The max data transfer
 >> appears to be ~1MB on my kernel. I'm using Redhat 9 with a
 >> custom kernel I built.(4.20-8_SPARSE_16). I would like to double
 >> the max tranfer size so my target device can be forced to do
 >> iterations on large read and write command. I'm assuming changing
 >> PAGE_SIZE would cause problems for other modules.

Natham,
The name inside the SCSI mid-level is "sg_tablesize" and it is
set by the low level driver (e.g. aic7xxx). The maximum value
is 256 (or 255?) and may have been trimmed down to 128 in lk 2.6 .
I was trying to use a more descriptive name, sorry for the
confusion.

In lk 2.4 you can see this value with:
# cd /proc/scsi/sg
# cat host_hdr hosts

In lk 2.6 you can see this value with:
# cat /sys/class/scsi_host/host<host_num>/sg_tablesize

PAGE_SIZE cannot practically be changed (it's 4 KB for i386
architecture) although there is "big" page support in lk 2.6
(but it won't help here). I have since been told that the scatter
gather setup time per element (in a typical low level driver) does
not take much time, but if the kernel has to build and tear down
a large scatter gather list per IO, that will slow throughput.
To get larger amounts of data per IO through
quickly I would suggest that you use mmap-ed IO since the sg
driver's per fd reserve buffer is built from 32 KB elements (and
you can change that [in sg.h]) giving a maximum transfer size
of around 8MB. mmap-ed IO in sg is also the fastest in my tests.

Doug Gilbert

