From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Serial Attached SCSI Driver Interface (SDI)
Date: Mon, 15 Nov 2004 13:49:49 -0500
Message-ID: <4198FA4D.3000206@pobox.com>
References: <60807403EABEB443939A5A7AA8A7458B5C0F3D@otce2k01.adaptec.com> <4198EF00.2010305@pobox.com> <4198F579.9080606@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:3014 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261655AbUKOSuI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 13:50:08 -0500
In-Reply-To: <4198F579.9080606@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Eric.Moore@lsil.com

Luben Tuikov wrote:
> I don't want to speculate on whether it will or not be an ioctl
> mechanism.  But most importantly, by architecture design, SAS
> really _needs_ a control management infrastructure of its components
> and _maybe_ a representation somewhere in the OS.  Since it really
> represents a "storage network" and in certain instances a complicated
> one at that.
> 
> That control management infrastructure would be shared by (used by
> both) the OS and the kernel (for the appropriate functionaly 
> needed/provided).


Please don't misunderstand.  I certainly agree that a management 
infrastructure is needed, and yes, having a common one is preferred to 
having a different one in each driver.

I however disagree that this commonality can be factored out by 
committee (specification) that has no knowledge of Linux.  The motto of 
Linux is, "do what you must, and no more."  If you look at the history 
of Linux, _any_ time an API has been imposed upon Linux, inherent API 
disconnects appear almost immediately.

I would much rather see a sysfs interface (transport class like James is 
proposing) that specifies "knobs" (controls) needed under Linux... 
controls that are presumably not redundant to a pre-existing Linux 
knobs.  If you need 2.4.x compatibility, a driver can easily interface 
with a common 2.4.x "libfs" filesystem module.

This applies whether we are talking about RAID management or storage 
network management or SATA/SAS phy management.  Create a _Linux_ 
management interface that is common across vendors and drivers.

T10, SNIA, and all the other storage industry committees have a _zero_ 
percent track record for doing OS software APIs correctly.

Commonality: good.  API imposed upon Linux by non-Linux committee:  bad.

You can't write a Linux API without knowing Linux-related issues.

	Jeff


