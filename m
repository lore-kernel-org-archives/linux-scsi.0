From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFQ] New driver architecture questions
Date: Wed, 13 May 2009 22:44:31 -0400
Message-ID: <4A0B858F.3080405@garzik.org>
References: <6C678488C5CEE74F813A4D1948FD2DC7A95E6D37@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:59258 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbZENCoe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2009 22:44:34 -0400
In-Reply-To: <6C678488C5CEE74F813A4D1948FD2DC7A95E6D37@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atul.Mukker@lsi.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Mukker, Atul wrote:
> Hello Kernel experts out there!
> 
>  
> 
> We (a division of LSI Corp.) are planning to initiate a new driver design for future generation of LSI RAID controllers. The new class of RAID controllers would be supported under various operating systems in addition to Linux.
> 
> As part of the revamping exercise, we would like to design the driver in such a fashion that much of the driver source code can be made common across drivers offered for various operating systems.
> 
> The obvious benefits being:
> 
> 1.                   Reduction of feature disparity across various operating systems.
> 
> 2.                   Increased customer satisfaction in terms of support consistency across all available operating systems.
> 
> 3.                   More synergy between the driver team members and increased collaboration.
> 
> 4.                   Decreased overheads in terms of maintenance, fixing issues across the board, defect and change requests tracking etc.
> 
> 5.                   More channelized test engineering.

If the design is done right, everybody wins, absolutely.  Intel has done 
this in the past by making their hw-specific modules generic enough to 
be used across multiple operating systems, while not compromising the 
Linux API guarantees.  See drivers/net/e1000e etc.

We hope, though, that design mistakes from the past can be avoided.  In 
the past, when hardware vendors have created a cross-OS _layer_ for 
their drivers, that layer wound up decreasing performance, increasing 
code size, introducing bugs, and decreasing overall portability.

In the past, cross OS driver layers, developed by hardware vendors for 
specific drivers, have

1. Increased feature disparity between Linux drivers for hardware w/ 
similar capabilities.

2. Decreased customer satisfaction in terms of support consistency 
across all Linux drivers.

3. Decreased synergy and collaboration across Linux drivers and Linux 
engineers, due to increased driver differences.

4. Increased overhead in terms of maintenance, support, and fixing 
issues across multiple Linux drivers, due to wider gulf between Linux 
drivers.

5. Decrease total amount of testing and testing breadth, because less 
shared code means more code to test, and less focused testing.


So it is clear from past experience that the /wrong/ design can hurt 
Linux customers, and it is also clear that the /right/ design, e.g. like 
Intel's network drivers, can be made cross-OS without impacting 
performance, portability or bug hunting.

	Jeff



