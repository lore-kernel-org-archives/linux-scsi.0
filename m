From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Thu, 6 Nov 2003 09:45:50 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0598CE6@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
content-class: urn:content-classes:message
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Christoph,

> More comments:
> 
>  - qla_vendor.c is still unused and should be killed
>

Yes, more baggage from old failover code, we should be able to kill it.

>  - your ioctl API gets worse and worse.  You don't expect this huge
>  dungpile of ioctls all marked _BAD to be merged, do you?  
>

No.  We've had this IOWR problem since the inception of 5.x series
driver.  Software (SMS 3.0) has been built on top of the this IOCTL
interface.  We painfully discovered this problem when we began to look
at other non-x86 platforms (ppc64).

>  Also having different ioctl values for different plattforms is not
>  an option for Linux.
> 

The better (right) fix would be to push this interface change onto the
caller of the IOCTLs where they can manage the differences there, and
the driver could once and for all shed itself of this nagging problem.
That is the consensus here.  The _BAD conversion was only done so the
driver would compile.

Regards,
Andrew Vasquez
