From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH RFC 1/3] add fc transport events
Date: 12 Jun 2004 23:41:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087088793.1730.19.camel@mulgrave>
References: <40B597F5.2030501@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:12947 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264984AbUFMDlV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jun 2004 23:41:21 -0400
In-Reply-To: <40B597F5.2030501@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-05-27 at 03:25, Mike Christie wrote:
> 01-add-host-transport-classdev.patch - adds the transport class_device to
> the scsi_host structure.

I've been thinking about this quite a bit, and I like the general idea,
I just have a quibble with the implementation.

The main problem is the adding of a kobject to complement your host
transport class (and the device transport class).  I don't think we need
to do this since, like the transport classes fall into either host or
device objects, so the events are similarly divided; thus, we should be
able to trigger the hotplug events through the host or device kobject
(that come with the embedded struct device) rather than adding another
kobject for the purpose.

What would be the disadvantage of doing what you propose this way
instead of using a separate kobject?

James



