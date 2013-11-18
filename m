From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi: Add "missing" sysfs attribute to scsi_device
 structure
Date: Mon, 18 Nov 2013 12:59:18 -0500
Message-ID: <1384797558.3839.19.camel@localhost.localdomain>
References: <1384794656-9449-1-git-send-email-emilne@redhat.com>
	 <1384796756.5985.3.camel@dabdike.int.hansenpartnership.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab3KRR7U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Nov 2013 12:59:20 -0500
In-Reply-To: <1384796756.5985.3.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2013-11-18 at 09:45 -0800, James Bottomley wrote:
> On Mon, 2013-11-18 at 12:10 -0500, Ewan D. Milne wrote:
> > From: "Ewan D. Milne" <emilne@redhat.com>
> > 
> > This change adds a "missing" sysfs attribute to scsi_device
> > which is set when a previously scanned device no longer appears
> > in the REPORT LUNS inventory.
> 
> A sysfs parameter with time and external input dependent semantics
> really doesn't look like a good idea.  What is it you're trying to
> achieve that you can't achieve from userspace by watching for the
> events?
> 
> James
> 
> 

Ideally, one would like to remove SCSI LUNs that are no longer being
presented by the device.  The information about which LUNs are no
longer there could, I suppose, be obtained from userspace by sending
a REPORT LUNS command, but that is somewhat redundant because the
kernel will issue one anyway when it is instructed to scan the target
for new LUNs.  This patch just makes the information visible.

Yes, the information is only valid at a point in time, but that is
true of REPORT LUNS any time it is used.  If the LUN inventory changes
again, there will be a new event generated that can be processed.

A udev event handler tell the kernel to scan for new LUNs, and then
potentially tell the kernel to delete scsi_devices that are now missing.

-Ewan


