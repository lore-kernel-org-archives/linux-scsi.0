From: Olaf Hering <olh@suse.de>
Subject: Re: Fw: SCSI device not spinning up on rw
Date: Tue, 11 Jul 2006 08:20:49 +0200
Message-ID: <20060711062049.GA12266@suse.de>
References: <20060603182302.7136831f.akpm@osdl.org> <44825D9F.9070305@torque.net> <44835AA2.1070809@us.ibm.com> <4484723E.7060906@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:60847 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S965210AbWGKGUz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 02:20:55 -0400
Content-Disposition: inline
In-Reply-To: <4484723E.7060906@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: dougg@torque.net, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Ruben Faelens <parasietje@gmail.com>

 On Mon, Jun 05, Brian King wrote:

> Brian King wrote:
> > Douglas Gilbert wrote:
> >>> I have a SCSI disk, which I want to spin down when the system is not in
> >>> use. I do this by using sdparm, scsi-spin or sg-utils. These tools all
> >>> spin down the SCSI drive by using an IOCTL.
> >>>
> >>> Problem is that the kernel doesn't spin the drive back up. When a
> >>> process requests data from the disk (a simple ls), the kernel responds
> >>> with an I/O error. After some of these errors, reiserfs marks the drive
> >>> read-only.
> > 
> > Setting sdev->allow_restart in struct scsi_device will cause sense
> > key/code/qual of 02/04/02 (not ready, initialization command required)
> > to wake up the scsi error handler and will force scsi core to issue
> > a start unit command to the disk. I added this a while back to handle
> > ipr raid arrays which need a start unit command each time the adapter
> > gets reset. It would be easy enough for sd to use this, either
> > all the time, or only when directed to, or we could add a sysfs attribute
> > to the disk to enable/disable this behavior.
> 
> Please try the attached patch. It adds a sysfs device attribute "allow_restart".
> If you set it to 1, then scsi core will issue a start unit when it sees 02/04/02
> sense data. The attribute is in the same place as the FUA and cache_type
> attributes (eg. /sys/block/sdc/device/scsi_disk:1:1:9:0/allow_restart). 

Is it safe to have this attribute be 1 per default, and let the user
disable it for problematic drives? The IO errors bother me alot...
