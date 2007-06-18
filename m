From: Swen Schillig <swen@vnet.ibm.com>
Subject: Re: [PATCH 3/3] zfcp: Don't report device as LUN 0 to SCSI stack
Date: Mon, 18 Jun 2007 15:04:22 +0200
Message-ID: <200706181504.23140.swen@vnet.ibm.com>
References: <200705291529.54785.swen@vnet.ibm.com> <1182113412.19498.7.camel@mulgrave.il.steeleye.com> <467646A0.3070105@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:49228 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761652AbXFRNAu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jun 2007 09:00:50 -0400
In-Reply-To: <467646A0.3070105@suse.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schmichr@de.ibm.com

On Monday 18 June 2007 10:47, Hannes Reinecke wrote:
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
> 
> Cheers,
> 
> Hannes

Agree, we will provide a new patch covering this issue.
So dump this one, but please don't forget to apply the other patches we sent.

Cheers 
	
Swen
