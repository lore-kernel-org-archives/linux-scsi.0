From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: linux-2.6.0-test11 [BUG] -- scsi_add/remove_device - out of memory
Date: Tue, 13 Jan 2004 08:26:46 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040113162646.GA2550@beaverton.ibm.com>
References: <OF11CFD4DA.B5836830-ONC1256E1A.00322027-C1256E1A.00356646@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:1734 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S264464AbUAMQWI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2004 11:22:08 -0500
Content-Disposition: inline
In-Reply-To: <OF11CFD4DA.B5836830-ONC1256E1A.00322027-C1256E1A.00356646@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <Heiko.Carstens@de.ibm.com>
Cc: Adam Radford <aradford@3WARE.com>, linux-scsi@vger.kernel.org

Heiko Carstens [Heiko.Carstens@de.ibm.com] wrote:
> Hi,
> 
> yes, now that I had some more time to look into it I found a leak.
> Actually the scsi mid layer creates a lot of sysfs attributes but
> doesn't remove a single one if a scsi device or a host gets removed.
> Since e.g. device_del (as it is called by scsi_remove_device) does
> not automatically remove all previously registered sysfs
> attributes, we end up with objects that have a reference count > 0
> and thus will never be released and eat up memory.
> 
> Heiko

Maybe something has changed, but the device_del calls kobject_del which
calls sysfs_remove_dir. sysfs_remove_dir removes all children enteries
created by sysfs_create_file. This should clean up the attributes.

-andmike
--
Michael Anderson
andmike@us.ibm.com

