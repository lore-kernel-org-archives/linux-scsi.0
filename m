From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Aic94xx and Linux kernel 2.6.19
Date: Fri, 10 Nov 2006 15:53:20 -0800
Message-ID: <455510F0.6010000@us.ibm.com>
References: <4D0A3E3121A0504EAEF0FBA7B9576C2608015A07@toroondc914.bell.corp.bce.ca>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:2509 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1946851AbWKJXxW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Nov 2006 18:53:22 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kAANrMnY014054
	for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2006 18:53:22 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kAANrL2h319030
	for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2006 16:53:21 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kAANrLke025029
	for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2006 16:53:21 -0700
In-Reply-To: <4D0A3E3121A0504EAEF0FBA7B9576C2608015A07@toroondc914.bell.corp.bce.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mike.redan@bell.ca
Cc: James.Bottomley@SteelEye.com, alexisb@us.ibm.com, linux-scsi <linux-scsi@vger.kernel.org>

[Hm, linux-scsi ought to be cc'd on this...]

mike.redan@bell.ca wrote:
>> Here they are:
>> Nov 10 02:08:08 192.168.207.10/192.168.207.10 kernel: sd 0:0:0:0: SCSI
>> error: return code = 0x00070000
>> Nov 10 02:08:08 192.168.207.10/192.168.207.10 kernel: end_request: I/O
>> error, dev sda, sector 77429847 
> 
> Yep, I've seen that now too.  It looks to me like we're getting
> DID_ERROR for some reason.  The only reason for that in the libata code
> seems to deal with bad SCSI commands and/or memory allocation problems,
> but I'll keep digging.

These errors are memory allocation problems in libata.  When I plug a
whole lot of SAS and SATA disks into my x260 and run the pounder stress
test, the amount of buffers on my system increases over a period of
about twenty minutes until libata can no longer allocate ata_queued_cmd
structures.  At this point we start seeing the errors above.  Since we
can't allocate new commands, libsas/aic94xx never even get called, which
is why they are silent on the matter.  However, if I kill pounder before
totally running out of memory, the amount of buffers will decrease very
rapidly and the system is ok.

So, a question to you, Mr. Redan: What does /proc/meminfo look like at
crash time?  If you have a huge amount of buffers, then we're seeing the
same thing.

And a question for everyone else: Because the buffers drain out fairly
quickly after pounder dies, does this mean that the controller is being
subjected to too much I/O at once?

--D
