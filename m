From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [ANNOUNCE] Adaptec SAS/SATA device driver [17/27]
Date: Thu, 17 Feb 2005 17:03:18 -0500
Message-ID: <421514A6.3030908@pobox.com>
References: <4214D645.60709@adaptec.com> <m14qgadhdg.fsf@muc.de> <421509BC.3090708@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:17362 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261206AbVBQWDg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 17:03:36 -0500
In-Reply-To: <421509BC.3090708@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Andi Kleen <ak@muc.de>, linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> Yes, that's true.  The driver was written to compile for 2.4 as well
> as for 2.6.


Typically what you want to do is target 2.6, and isolate/emulate missing 
functionality in 2.4.x in a compatibility file.  This compatibility 
file/lib would not exist in 2.6 kernel, but you can give it to vendors 
or distros to ship.  An example of this, called "kcompat", can be found 
at http://sourceforge.net/projects/gkernel/

Another approach, which I took with libata, is to design the code such 
that there are minimal differences between 2.4 and 2.6.  Granted, 
though, with the upcoming NCQ and transport class changes, those 
differences increase.

Either way, cross-OS and cross-kernel-version compatibility stuff needs 
to be carefully examined, and as much excised as possible.  After many 
years, we have found that such portions of code often hide bugs.

We _do_ recognize that it's a bit painful for hardware vendors trying to 
support various Linux versions, but if you plan for it up front, the 
pain can be minimized.  I support libata on both 2.4 and 2.6 
concurrently, for example.

Remember, we have all these "weird" requirements because all source code 
merged into the Linux kernel lives on for many years after the 
hardware's end-of-life.  We need to ensure that source code is 
maintain-able even if the hardware vendor abandons a Linux driver.

	Jeff


