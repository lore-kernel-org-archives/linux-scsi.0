From: "Martin Weiss" <mweiss@novell.com>
Subject: Data corruption with i2o with XEN kernel using PAE or 64bit
Date: Thu, 15 Nov 2007 02:27:28 -0700
Message-ID: <473C1F10.2254.001C.1@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sinclair.provo.novell.com ([137.65.248.137]:31734 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbXKOJ24 convert rfc822-to-8bit (ORCPT
	<smtp;groupwise-linux-scsi@vger.kernel.org:1:1>);
	Thu, 15 Nov 2007 04:28:56 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

not sure if this list is the right way to look for help - but lets give it a try ;-).

I am running openSuSE with Kernel  2.6.22.12-0.1-xen #1 SMP 2007/11/06 23:05:18 UTC x86_64 x86_64 x86_64 GNU/Linux.
The RAID Controller I am using is Adaptec 2400A with four 400GB HDDs as RAID5.

In the past I was running standard 32bit kernels without any problems..
Now I moved on to 64bit and I have two problems:

1. If I have more then 3999MB in the system - no partitions can be read. A workaround was to set mem=3999M as boot parameter. But now I have 8 GB memory and I want to use it.
If I compile the i2o_block without 64bit support - I can also read the partitions without the workaround. --> It would be much better to have a real fix for this..

2. I have large size files on the device >11 GB (XEN domUs). When I do a md5sum on that files (while the domU is not started) - I get different results for each try (the file stays the same) !
This is really critical because it looks as if there is a data corruption problem on 64bit systems with the i2o_core or i2o_block.

After some more testing - even with SLES 10 SP1 - I found out, that the second problem exists with all XEN kernels except the standard 32Bit kernel without PAE !
If I do not use a kernel with XEN support - I do not have the problem !

So it seems there is a bug when using XEN together with i2o.

Now I have the question - how can I get this problem fixed ?

Thanks in advance,
Martin

