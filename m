From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] Unify sysfs filenames for firmware version
Date: Tue, 20 Nov 2007 15:53:34 -0500
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01FEAD01@otce2k301.adaptec.com>
References: <20071120133824.GD31112@earth.li> <47430CCE.50701@emulex.com> <20071120171454.GH31112@earth.li> <AE4F746F2AECFC4DA4AADD66A1DFEF01FEAC9B@otce2k301.adaptec.com> <20071120200212.GI31112@earth.li>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:55460 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756599AbXKTUxg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Nov 2007 15:53:36 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20071120200212.GI31112@earth.li>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan McDowell <noodles@earth.li>
Cc: James Smart <James.Smart@Emulex.Com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Matt_Domsch@dell.com

Jonathan McDowell [mailto:noodles@earth.li] sez:
> On Tue, Nov 20, 2007 at 12:49:49PM -0500, Salyzyn, Mark wrote:
> > The aacraid cards, which uses hba_monitor_version, 
> > hba_kernel_version and hba_bios_version for each piece
> > does not fit into the single 'firmware revision' common ideal
> While I've used the aacraid cards in the past I think I agree
> with you that no 1 of those 3 pieces of information represents
> the firmware. Perhaps it could export a triplet though?

A single can be used in 99% of all cases, OEM or users can muck
it up. I would 'vote' for hba_kernel_version == fw_version.

Maybe add a companion standard for hba_bios_version == bios_version
and hba_monitor_version == exec_version (executive_version) if other
cards can supply such info ...

> Management stuff always seems to be tied to a single card. It's one of
> the things that puts me off hardware RAID.

There are 113 cards this driver works for in concert. Maybe my tail
feathers are showing ;->

> Do the management folks actually have some ideas about what sort of
> interface they'd like in sysfs?

Simple answer:
	No

Detailed answer (I digress):

They love ioctls as a commonality across all operating
systems and a pass-through to proprietary firmware
portals: binary, bidirectional, atomic and freely
formatted migrating structures that do not herd the
cats into just one specification. These are all
eventually presented as documented stable objects
exported by a sizeable C++ StorLib(tm) library that
provides the consistent interface that the OEMs and
Adaptec use to the higher level install, event, GUI
and CLI applications. Driver is only involved as a
transport.

Sincerely -- Mark Salyzyn
