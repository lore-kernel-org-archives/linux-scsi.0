From: James.Smart@Emulex.Com
Subject: RE: One question about SCSI device hotplug
Date: Tue, 1 Mar 2005 11:35:28 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C12EC5E@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from emulex.emulex.com ([138.239.112.1]:44423 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261966AbVCAQjq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 11:39:46 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx, forrest.zhao@intel.com
Cc: linux-scsi@vger.kernel.org, ramesh.caushik@intel.com

> On Tue, Mar 01, 2005 at 05:06:55PM +0800, Zhao, Forrest wrote:
> > If I surprisingly hot-remove a SCSI disk from HBA manually 
> > without executing "echo "scsi remove-single-device
> >  <h> <b> <t <l>" > /proc/scsi/scsi", can the "hotplug"
> > event be notified to SCSI mid-layer or user space?
> > 
> > I briefly browse some code of LLDD, it seems that LLDD never
> > report "hotplug" event to upper-level layer. Am I right?
> 
> I don't think it *can* ... the SCSI protocols don't tell the 
> host "hey,
> this device has disappeared".

All depends on what transport it is... In FC, we can detect when
a target is removed. In the most recent FC transport code (not
all integrated yet), it will indeed automagically invoke
scsi_remove_device() for all luns on the target.

-- james s
