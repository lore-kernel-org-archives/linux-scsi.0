From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SCSI disk speed inconsistency
Date: Wed, 05 Oct 2005 08:00:15 +1000
Message-ID: <4342FB6F.4070100@torque.net>
References: <4340F4AB.3070107@cdac.in>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:7091 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S964988AbVJDV71 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2005 17:59:27 -0400
In-Reply-To: <4340F4AB.3070107@cdac.in>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karthik Sarangan <karthiks@cdac.in>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Karthik Sarangan wrote:
> I get a read speed of 69MBps from my SCSI disk and a write speed of
> 49MBps from the same.
> An IOMeter benchmark on the net says that 68MBps is the sustained speed
> for a write.
> 
> Could someone tell me how to increase my IO speed?
> 
> I have a Linux Kernel 2.6 in a RedHat Enterprise Linux WS 4 and I used
> the foll.
> Read : sg_dd if=/dev/sdb  of=/dev/null bs=262144 count=1024 dio=1
> Write: sg_dd if=/dev/zero of=/dev/sdb  bs=262144 count=1024 dio=1

Karthik,
For accurate timing with "sd" devices use "odir=1" rather
than "dio=1". "dio=1" only applies to sg devices so it has
no effect in your above example. [Perhaps I should add a
warning about this in sg_dd.]

Also with sg_dd you should use "bs=512" and read about the
"bpt=<n>" option in the man page. Also look at the "blk_sgio=0|1"
and the "time=1" option.


Doug Gilbert
