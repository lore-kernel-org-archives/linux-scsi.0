From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Mount by WWN (FC, using qlogic 2200)
Date: Thu, 5 Feb 2004 08:38:09 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040205083809.A15221@beaverton.ibm.com>
References: <OFCBD64150.59466282-ON87256E31.0002462C-88256E31.0002E095@us.ibm.com> <1075989386.19275.1895.camel@bianchi.boston.redhat.com> <1075993831.1756.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:26285 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266422AbUBEQiz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2004 11:38:55 -0500
Content-Disposition: inline
In-Reply-To: <1075993831.1756.8.camel@mulgrave>; from James.Bottomley@steeleye.com on Thu, Feb 05, 2004 at 10:10:29AM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Tom Coughlan <coughlan@redhat.com>, Bryan Henderson <hbryan@us.ibm.com>, EXT / DEVOTEAM VAROQUI Christophe <ext.devoteam.varoqui@sncf.fr>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org, Martin Peschke3 <MPESCHKE@de.ibm.com>, "Robert J. Adams (jason)" <radams@siscom.net>

On Thu, Feb 05, 2004 at 10:10:29AM -0500, James Bottomley wrote:
> On Thu, 2004-02-05 at 08:56, Tom Coughlan wrote:

> > We need to check the association field, and use the identifier
> > appropriately, and we need to insist that storage vendors implement it
> > correctly.
> 
> I agree, but I see this as a userspace issue.

Yes, I have this code in scsi_id (scsi_serial.c), AFAIR the same as we
once had in the kernel. The return 1 means we won't use this id:

        /* 
         * ASSOCIATION must be with the device (value 0)
         */
        if ((page_83[1] & 0x30) != 0)
                return 1;

The source code is included with the udev release (under the extras
directory), or at:

http://www-124.ibm.com/storageio/scsi_id/scsi_id-0.3.tar.gz

-- Patrick Mansfield
