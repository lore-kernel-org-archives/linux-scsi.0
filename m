From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: How to resurrect offlined SCSI devices?
Date: Wed, 26 May 2004 11:02:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040526180253.GB1561@us.ibm.com>
References: <8D43EFD7CCBDB24980134BE078C227E704E37B0A@xcm.emulex.com> <1085590517.2116.439.camel@mulgrave> <20040526171514.GA1332@us.ibm.com> <1085593035.2116.539.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:23255 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S265760AbUEZSDJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 14:03:09 -0400
Content-Disposition: inline
In-Reply-To: <1085593035.2116.539.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Infante, Jon" <Jon.Infante@Emulex.Com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> Not necessarily roll our own, just plug into the hotplug
> infrastructure.  But generate events, definitely.

Yes we do not need to roll our own, Mike C's mail pointed out that these
interfaces are exported.

We should be able to add a call to kobject_hotplug in
scsi_device_set_state for certain / all state transitions depending on
how many events one would want to go to users space. Unexpected state
transitions would seem like a good starting point to not generate to
much user space traffic (i.e running -> offline, offline -> running).

This also assumes that if one expects user space reaction to these
events occurring on a root device they have already prepared there needed
tools in a ramdisk environment.

-andmike
--
Michael Anderson
andmike@us.ibm.com

