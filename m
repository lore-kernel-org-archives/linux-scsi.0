From: "Cameron, Steve" <Steve.Cameron@hp.com>
Subject: RE: SG_IO weirdness
Date: Mon, 5 Feb 2007 20:29:42 -0000
Message-ID: <558F4D473FD7FE419B019232BF2D37B40B22F8@G3W0634.americas.hpqcorp.net>
References: <558F4D473FD7FE419B019232BF2D37B40B22F2@G3W0634.americas.hpqcorp.net> <45C782CF.9030207@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas04.cce.hp.com ([161.114.21.107]:51464 "EHLO
	ccerelbas04.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933360AbXBEUaN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Feb 2007 15:30:13 -0500
Received: from G3W0060.americas.hpqcorp.net (g3w0060.americas.hpqcorp.net [16.232.1.19])
	by ccerelbas04.cce.hp.com (Postfix) with ESMTP id 841823452E
	for <linux-scsi@vger.kernel.org>; Mon,  5 Feb 2007 14:30:12 -0600 (CST)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

> Steve,
> Even though the SCSI status is CHECK CONDITION, the data-in
> buffer may still be transferred. One obvious example
> is a READ command when the sense key is RECOVERED ERROR.

Yep, of course.

> The sg driver and I suspect the block layer SG_IO do
> not check the SCSI status to determine whether or not
> to transfer the data-in buffer (or where it would have
> been DMA-ed to if the command worked) back to user space.
> If it was _direct_ IO then the block layer SG_IO and the
> sg driver would have no control over the data-in transfer
> (apart from setting it up).
>
> Both the sg driver and the block layer SG_IO could check
> the resid field which a LLD should set after a DMA
> (especially inbound). However LLDs are not compelled to
> set resid properly.
>
> So a few questions:
> - block layer SG_IO, the sg driver or both?

sg driver.

> - indirect IO (i.e. O_DIRECT not set)?

indirect IO, O_DIRECT was not set.

> - did the offending process have superuser permissions?
Yes.

> - did the resid field indicate a short data-in transfer?

resid == 64, the requested buffer was 1088 bytes.
(If I interpret that right, it means that all but 64 
bytes were transferred, that is, 1024 bytes were 
transferred?  Odd, considering the CDB was nonsense.)

> As long as the SCSI status and sense buffer are conveyed
> back properly _and_ this is only observed when the
> process has superuser permissions, then I wouldn't
> regard it as serious. Others may disagree.

I haven't tried it as non-superuser.  (And couldn't,
unless I chmod'ed /dev/sg* )

-- steve


