From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: QLA2300, Infortrand and LBD?
Date: 21 Jun 2004 09:09:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087826985.1797.14.camel@mulgrave>
References: <BAY22-F23Fi1dJRdjd8000a113d@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:61130 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266237AbUFUOJr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 10:09:47 -0400
In-Reply-To: <BAY22-F23Fi1dJRdjd8000a113d@hotmail.com>
List-Id: linux-scsi@vger.kernel.org
To: "tester7 A." <benew666@hotmail.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, tech@storageone.co.kr

On Sun, 2004-06-20 at 03:43, tester7 A. wrote:
> SCSI device sdc: 3022966784 512-byte hdwr sectors (1547759 MB)
> SCSI device sdc: drive cache: write through
> sdc: sdc1
> Attached scsi disk sdc at scsi3, channel 0, id 0, lun 0

The drive itself replied with that capacity, which is incorrect.  It's
supposed to reply with the largest possible capacity (0xffffffff) and we
use that as a signal to retry with READ_CAPACITY_16.

Could you contact the support line of the array and make sure of two
things:

1) It does actually support single LUNs with a capacity of >2TB (lots of
arrays don't)
2) And if 1) is true, why is it not responding correctly to the READ
CAPACITY(10)? The spec (spc-2 Rev 8, 5.2.11) says "If the number of
logical blocks exceeds the maximum value[...]the device server shall
transfer FFFFFFFFh in the RETURNED LOGICAL BLOCK ADDRESS field"

James


