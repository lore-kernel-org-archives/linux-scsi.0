From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: How to resurrect offlined SCSI devices?
Date: 26 May 2004 11:55:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085590517.2116.439.camel@mulgrave>
References: <8D43EFD7CCBDB24980134BE078C227E704E37B0A@xcm.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:20708 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265708AbUEZQzX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 12:55:23 -0400
In-Reply-To: <8D43EFD7CCBDB24980134BE078C227E704E37B0A@xcm.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Infante, Jon" <Jon.Infante@Emulex.Com>
Cc: Martin Peschke3 <MPESCHKE@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-05-26 at 11:17, Infante, Jon wrote:
> Wouldn't it be acceptable for the lldd to call  scsi_scan_host() at this
> point to force a scsi mid layer rescan of the devices attached to the hba?
> In a fibre channel environment a device can disappear for a long period of
> time, then come back. The driver knows exactly when it comes back and should
> be able to tell the scsi layer.

Well, only if the LLD previously did a remove of the device, which I
don't think it will have done.

I'd really like to see all fibre events (like loop up/down, device
add/remove) handled inside the FC transport class.  From there, it
probably still make sense to use hotplug as the mechanism for importing
user policy.

James


