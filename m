From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [announce] scsi_id release 0.2
Date: Sun, 7 Dec 2003 11:42:42 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031207114242.A29572@beaverton.ibm.com>
References: <20031205151810.A8891@beaverton.ibm.com> <20031207153802.GA6700@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:19904 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264497AbTLGTnC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Dec 2003 14:43:02 -0500
Content-Disposition: inline
In-Reply-To: <20031207153802.GA6700@suse.de>; from olh@suse.de on Sun, Dec 07, 2003 at 04:38:02PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net

On Sun, Dec 07, 2003 at 04:38:02PM +0100, Olaf Hering wrote:
>  On Fri, Dec 05, Patrick Mansfield wrote:
> 
> > Version 0.2 of scsi_id is available at:
> > 
> > http://www-124.ibm.com/storageio/scsi_id/scsi_id-0.2.tar.gz
> 
> What is $(DEBUG)? It is used by klibc and replaced by true/false.

I use it to compile with -g. 

i.e.:
	
	# make DEBUG=-g 
	cc -DSCSI_ID_VERSION=\"0.2\" -g -Wall   -c -o scsi_id.o scsi_id.c
	cc -DSCSI_ID_VERSION=\"0.2\" -g -Wall   -c -o scsi_serial.o scsi_serial.c
	cc  -o scsi_id  scsi_id.o scsi_serial.o  -lsysfs  

The udev DEBUG value does not get passed down to the extras, so the
scsi_id build under udev should be OK.

Is it breaking your build? If so I'll just remove it.

The scsi_id debug logging via the "-v" or when DEBUG is set is always
enabled - it outputs to syslog LOG_DEBUG when called from udev, or via
stderr when used via the command line. (Though the klibc strerror() only
prints the errno value, making for some odd error messages.)

-- Patrick Mansfield
