From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC] 3rd Party Device Drivers need sd.h
Date: Fri, 17 Oct 2003 13:33:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031017133327.A1784@beaverton.ibm.com>
References: <3F904E7F.1070700@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:59607 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263510AbTJQUd5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2003 16:33:57 -0400
Content-Disposition: inline
In-Reply-To: <3F904E7F.1070700@comcast.net>; from david.vanhoose@comcast.net on Fri, Oct 17, 2003 at 04:18:07PM -0400
List-Id: linux-scsi@vger.kernel.org
To: David van Hoose <david.vanhoose@comcast.net>
Cc: linux-scsi@vger.kernel.org

On Fri, Oct 17, 2003 at 04:18:07PM -0400, David van Hoose wrote:
> I have been working on modifying the SATA driver that I got from Promise 
> to work under 2.6.0. However, there is a conflict since it needs sd.h. I 
> looked and sd.h was merged into sd.c. What reasons were there for doing 
> this, and what changes have to be made to 3rd party drivers to 
> accomodate it? Please CC to me as I am not on this list.

The bios_param call now passes a scsi_device and its capacity, rather than
a scsi_disk, it is a cleaner interface. Exporting interfaces or data
structures from sd to host drivers makes little sense.

Just delete the sd.h include, and then updating the bios_param function
should get rid of the scsi_disk or Disk reference.

Does Jeff's SATA/libata driver cover the Promise hardware?

-- Patrick Mansfield
