From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: proc_name in sysfs
Date: Thu, 7 Apr 2005 17:00:31 -0700
Message-ID: <20050408000031.GA8300@us.ibm.com>
References: <4253CA94.8000500@bull.net> <20050406183614.GA25370@us.ibm.com> <4254877B.4020607@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42654 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262620AbVDHAAe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2005 20:00:34 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j3800Xbo029921
	for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2005 20:00:33 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j3800Xil115774
	for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2005 20:00:33 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j3800XOA012246
	for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2005 19:00:33 -0500
Content-Disposition: inline
In-Reply-To: <4254877B.4020607@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Frederic TEMPORELLI <frederic.temporelli@bull.net>, linux-scsi@vger.kernel.org

On Thu, Apr 07, 2005 at 11:06:03AM +1000, Douglas Gilbert wrote:
> Patrick Mansfield wrote:
> >On Wed, Apr 06, 2005 at 01:40:04PM +0200, Frederic TEMPORELLI wrote:
> >
> >
> >>2/ now, how can we get the adapter module name from sysfs ?
> >
> >
> >Why do you need it?


> Patrick,
> lsscsi currently uses proc_name so it needs to be
> changed to use the above logic (if LLDs are going
> to stop populating proc_name).

Oops, I didn't notice, I had assumed it was using the sysfs layout.

Yes, seems like it should use the sysfs driver info, proc_name is
rather useless in sysfs context.

> It has been suggested that I extend lsscsi to show
> transport info (as seen from the HBA) found in the
> various *_transport directories in sysfs.

As an option that sounds nice.

> Also I have been thinking about ways to list less
> tha all scsi devices. For example: "lsscsi 1:0:3:0"
> to look at one device and "lsscsi 1:-" for all scsi
> devices hanging off host1. I'm not sure whether
> "lsscsi /dev/sda" is a good idea. Any suggestions?

Sounds good, but maybe not (directly) for /dev. udevinfo can supply that,
it has a /dev to /sys mapping:

[elm3b79 patman]$ udevinfo -q path -n /udev/mydisk-sdag
/block/sdm

-- Patrick Mansfield
