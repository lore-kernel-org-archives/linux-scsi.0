From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 3/3] zfcp: Don't report device as LUN 0 to SCSI stack
Date: Mon, 18 Jun 2007 15:56:14 +0200
Message-ID: <20070618135614.GD3580@osiris.boeblingen.de.ibm.com>
References: <200705291529.54785.swen@vnet.ibm.com> <1182113412.19498.7.camel@mulgrave.il.steeleye.com> <467646A0.3070105@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:56821 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760884AbXFRN4S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jun 2007 09:56:18 -0400
Content-Disposition: inline
In-Reply-To: <467646A0.3070105@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Swen Schillig <swen@vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schmichr@de.ibm.com

On Mon, Jun 18, 2007 at 10:47:28AM +0200, Hannes Reinecke wrote:
> James Bottomley wrote:
> > On Tue, 2007-05-29 at 15:29 +0200, Swen Schillig wrote: 
> >> From: Christof Schmitt <schmichr@de.ibm.com>
> >>
> >> zfcp reported units to the SCSI stack starting
> >> with number 0. LUN 0 reported to the SCSI stack is usually 
> >> not the FCP LUN 0. When scanning for devices, 
> >> the SCSI stack tried to issue a REPORT LUN command to LUN 0. 
> >> The current design for zfcp does not want the SCSI stack to scan
> >> for devices, since they are configured explicitly via sysfs.
> >> This patch changes the numbering to always start with LUN 1 and therefore
> >> prevent the SCSI stack sending REPORT LUN command.
> > 
> > As a general principle, this does sound to be wrong (at least shifting
> > the LUNs).  Wouldn't something like the existing blacklist preventing
> > the REPORT LUN command from being sent be more appropriate?
> > 
> IMO the zfcp driver should export the FCP LUNs and not building their
> own internal SCSI LUN to FCP LUN mapping table.
> That would avoid this issue, too. And would make the zfcp driver more in
> line with everyone else ...

One of my current disks has an FCP LUN of 0x401040ba00000000... That's just
the limit that scsilun_to_int() (four bytes that is) still works with.
Just wondering if there are patches around that make the SCSI stack work
with eight byte LUNs?
Otherwise this looks like replacing a broken approach with a different but
at least incomplete approach. The above LUN would be translated to a SCSI
stack internal LUN of 1085947920. Hmm...
