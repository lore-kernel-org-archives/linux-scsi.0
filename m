From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi_host sysfs updates scsi-misc-2.5 [0/2]
Date: 12 May 2003 16:50:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1052776222.3600.9.camel@mulgrave>
References: <20030509063321.GA3259@beaverton.ibm.com>
	<1052711864.1768.7.camel@mulgrave>
	<20030512063833.GA4133@beaverton.ibm.com>
	<1052761851.2093.55.camel@mulgrave> <1052762365.2148.59.camel@mulgrave>
	<20030512184140.GB3226@beaverton.ibm.com>
	<1052770234.1769.75.camel@mulgrave>
	<20030512203507.GC3226@beaverton.ibm.com>
	<1052772136.1769.103.camel@mulgrave>
	<20030512214902.GD3226@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:56068 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261860AbTELVhp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2003 17:37:45 -0400
In-Reply-To: <20030512214902.GD3226@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, mochel@osdl.org

On Mon, 2003-05-12 at 16:49, Mike Anderson wrote:
> I am seeing size-512 with my modified version of scsi_debug. I modified
> slab.c to store last user for this size and it indicates it was
> scsi_free_shost. I am looking at this now.

I found it: you have a use after free in the sysfs code:

scsi_host_put does put_device followed by class_device_put, but the
put_device will free the shost containing the class_device in it's
release, so the class_device_put touches a freed object.

The solution is just to reverse the order of the puts.

James


