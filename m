From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Mount by WWN (FC, using qlogic 2200)
Date: Wed, 4 Feb 2004 12:15:15 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040204121514.A9609@beaverton.ibm.com>
References: <OF21001894.F77A2C4A-ONC1256E30.006C8B35-C1256E30.006E2DB9@de.ibm.com> <1075925194.2029.102.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:36515 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S266334AbUBDUPx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Feb 2004 15:15:53 -0500
Content-Disposition: inline
In-Reply-To: <1075925194.2029.102.camel@mulgrave>; from James.Bottomley@steeleye.com on Wed, Feb 04, 2004 at 03:06:33PM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Martin Peschke3 <MPESCHKE@de.ibm.com>, "Robert J. Adams (jason)" <radams@siscom.net>, EXT / DEVOTEAM VAROQUI Christophe <ext.devoteam.varoqui@sncf.fr>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, linux-hotplug-devel@lists.sourceforge.net

On Wed, Feb 04, 2004 at 03:06:33PM -0500, James Bottomley wrote:
> On Wed, 2004-02-04 at 14:58, Martin Peschke3 wrote:
> > As there might be several paths to a device identified by a WWPN
> > in the form of 2 or more host bus adapters connecting to that WWPN,
> > don't you want to mount an FCP device by
> > <adapter identifier> + <WWPN> + <FCP_LUN> ?
> 
> Actually, I think the question was about WWN, i.e. the EVPD page 0x83
> World Wide Name, which uniquely identifies the device independent of
> transport.
> 
> The answer is that someone needs to think about doing it using udev.

[added hotplug list to the cc]

scsi_id is included with the udev source now, and can be used to solve
most of the problem.

We still need something that tells udev what to do with multiple matches -
for multi-pathed sd's showing up multiple times, we don't want to drop the
other sd's, and that is what will happen right now with udev.

-- Patrick Mansfield
