From: EXT / DEVOTEAM VAROQUI Christophe <ext.devoteam.varoqui@sncf.fr>
Subject: RE: Mount by WWN (FC, using qlogic 2200)
Date: Thu, 5 Feb 2004 10:52:29 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A979D299E02AD31188EA0000834A03D20875830A@S64P17BIA40>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jasmin2.sncf.fr ([171.16.4.19]:49556 "EHLO jasmin2.sncf.fr")
	by vger.kernel.org with ESMTP id S264604AbUBEJxK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2004 04:53:10 -0500
List-Id: linux-scsi@vger.kernel.org
To: 'Patrick Mansfield' <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>
Cc: Martin Peschke3 <MPESCHKE@de.ibm.com>, "Robert J. Adams (jason)" <radams@siscom.net>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, linux-hotplug-devel@lists.sourceforge.net

Note that the current behaviour of the multipath config tool (packaged with
udev) is to map a multipath DM target over a LUN if it has at least one
path. I.e. in a single path environment, you would get a DM target mapped
over every sd behind a FC HBA. Using this tool, one can just parse through
the configured DM to find the WWID to mount.

> On Wed, Feb 04, 2004 at 03:06:33PM -0500, James Bottomley wrote:
> > On Wed, 2004-02-04 at 14:58, Martin Peschke3 wrote:
> > > As there might be several paths to a device identified by a WWPN
> > > in the form of 2 or more host bus adapters connecting to that WWPN,
> > > don't you want to mount an FCP device by
> > > <adapter identifier> + <WWPN> + <FCP_LUN> ?
> > 
> > Actually, I think the question was about WWN, i.e. the EVPD page 0x83
> > World Wide Name, which uniquely identifies the device independent of
> > transport.
> > 
> > The answer is that someone needs to think about doing it using udev.
> 
> [added hotplug list to the cc]
> 
> scsi_id is included with the udev source now, and can be used to solve
> most of the problem.
> 
> We still need something that tells udev what to do with multiple matches -
> for multi-pathed sd's showing up multiple times, we don't want to drop the
> other sd's, and that is what will happen right now with udev.
> 
> -- Patrick Mansfield
