From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: zero block writes
Date: 14 Oct 2003 16:43:06 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066171386.3037.9.camel@patehci2>
References: <1066160907.3501.9.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:2997 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262036AbTJNWnV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2003 18:43:21 -0400
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id BD3111BB5
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2003 16:43:20 -0600 (MDT)
In-Reply-To: <1066160907.3501.9.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> $
> $ sg_dd of=/dev/sg0 if=/dev/null bs=2k count=1
> 0+0 records in
> 0+0 records out
> $
> ...
> usb-storage:  2a 00 00 00 00 00 00 00 00 00

Kindly offline I'm told I neglected to emphasise, that example of an sg
utils sg_dd if=/dev/null command line differs only subtly from the
perhaps more familiar:

sg_dd of=/dev/sg0 if=/dev/zero bs=2k count=1

Copying from /dev/zero by design writes lots of zeroed bytes.

Copying from /dev/null via sg_dd doesn't neglect to write, in fact it
does write, it just tries to write nothing at a specific address.

Consider, for example:

sg_dd of=/dev/sg0 if=/dev/zero bs=2k seek=259 count=1

That changes the cdb trace so that the starting address passed thru as
cdb bytes[2:3:4:5] become x 00:00:01:03 rather than x 00:00:00:00:

x 2A 00 00 00 01 03 00 00 01 00

Pat LaVarre

P.S. Yes indeed I did stumble into this to-me-surprising fact via the
bonehead newbie error of typing "null" where I meant  "zero".


