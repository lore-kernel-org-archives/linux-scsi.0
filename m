From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace ioctl for sysfs take 2
Date: Wed, 8 Sep 2004 11:11:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF59D5DAF5.BDA4196D-ON88256F09.0062890C-88256F09.0063EF14@us.ibm.com>
References: <20040908073843.7dbcddb6.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:25279 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S269277AbUIHSNU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2004 14:13:20 -0400
In-Reply-To: <20040908073843.7dbcddb6.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: dougg@torque.net, hch@lst.de, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, michaelc@cs.wisc.edu, mikenc@us.ibm.com, sferris@acm.org, surekhap@cisco.com, willy@debian.org

>Sorry to be dense here, but what is an "initiator port" in this context?
>Is it a physical connector or something else?  A logical connector?
>(whatever that means)

The context is ISCSI; the ISCSI spec rigorously defines the term "SCSI 
initiator port."  But it defines it quite abstractly, which is why we can 
have discussions like this one -- whether in a Linux implementation a SCSI 
initiator port should map to a Linux SCSI host or channel or whatever.

The SCSI initiator port is what in simpler times was a physical connector. 
 In ISCSI it is just the initiator-side endpoint of an ISCSI 
(initator-target) session.  It is more abstract than a physical connector, 
and even more abstract than a TCP port.  A SCSI initiator port is 
identified by an ISCSI initiator device name (= node name) and ISID.  A 
SCSI initiator port belongs to a particular SCSI initiator device. 
Multiple SCSI initiator ports can go to a single SCSI initiator device. An 
ISCSI target reaches a SCSI initiator device via a SCSI initiator port. An 
ISCSI target reaches a SCSI initiator port via TCP ports, but not in any 
simple mapping.

If you're asking how an ISCSI initiator port is _implemented_ in a 
Linux-based initiator, that's what's under discussion.  There's more than 
one way to do it, and different people have done it different ways.

--
Bryan Henderson                          IBM Almaden Research Center
San Jose CA                              Filesystems
