From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: Debug out from SCSI layers
Date: Thu, 3 Feb 2005 17:31:33 -0800
Message-ID: <OFC54C78A0.930EAD99-ON88256F9E.000764F3-88256F9E.00086B35@us.ibm.com>
References: <A8B003DDA3332A479C0ECCA641F47E6503BE7087@tayexc13.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60641 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263304AbVBDBdG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2005 20:33:06 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id j141X5ZW012864
	for <linux-scsi@vger.kernel.org>; Thu, 3 Feb 2005 20:33:05 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j141X5oH125128
	for <linux-scsi@vger.kernel.org>; Thu, 3 Feb 2005 20:33:05 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j141X5vV002886
	for <linux-scsi@vger.kernel.org>; Thu, 3 Feb 2005 20:33:05 -0500
In-Reply-To: <A8B003DDA3332A479C0ECCA641F47E6503BE7087@tayexc13.americas.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dupuis, Chad" <chad.dupuis@hp.com>
Cc: linux-scsi@vger.kernel.org

>Is there a way to make the SCSI layers (midlayer, sd, etc.) print out
>some debug output to /var/log/messages

Note that no kernel code puts stuff in /var/log/messages.  The SCSI log 
messages are ordinary kernel messages, and most people have a user space 
process or two running that suck recent kernel messages out of the kernel 
message buffer and write them into /var/log/messages.  They typically 
control this behavior with /etc/syslog.conf.

It's good to remember this because of a couple of things.  First of all, a 
lot of syslog.confs say to ignore "debug" level messages or put them some 
place besides /var/log/messages.  Second, if the kernel generates the 
messages faster than the syslog daemon can move them to /var/log/messages, 
you'll miss some.  Third, the filesystem I/O this process does to write to 
the log file might interfere with whatever you're trying to investigate.

A log_buf_len= kernel boot parameter is useful for making the kernel 
message buffer big enough to avoid overruns.

Two sometimes simpler ways to gather your SCSI debug messages are: have 
the kernel display them on the console, by issuing a 'dmesg -n8' command 
(this isn't useful if your console is in graphics mode), and simply 
display or move to a file the contents of the kernel message buffer, with 
'dmesg'.

