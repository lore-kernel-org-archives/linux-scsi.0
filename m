From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 4/6: scsi_allow_ghost_devices
Date: Tue, 20 Apr 2004 10:34:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040420103416.A8602@beaverton.ibm.com>
References: <20040418185950.GG4868@tpkurt.garloff.de> <20040418202022.B3393@infradead.org> <1082360042.4691.3.camel@laptop.fenrus.com> <1082376382.4635.65.camel@compaq.xsintricity.com> <20040419131410.A10772@infradead.org> <20040419133426.GV18329@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:57475 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263475AbUDTRfD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2004 13:35:03 -0400
Content-Disposition: inline
In-Reply-To: <20040419133426.GV18329@parcelfarce.linux.theplanet.co.uk>; from willy@debian.org on Mon, Apr 19, 2004 at 02:34:26PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Christoph Hellwig <hch@infradead.org>, Doug Ledford <dledford@redhat.com>, Arjan Van de Ven <arjanv@redhat.com>, Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>

Here's EMC's post in the archives describing the original problem:

http://marc.theaimsgroup.com/?t=99790431900006&r=1&w=2

A better method is to not mark it offline, and have sd_probe not attach
based on the PQ fields, like Mike Anderson and (I thought) Doug Ledford
had proposed:

http://marc.theaimsgroup.com/?l=linux-scsi&m=99837483305810&w=2

Above patch should be modified to check the scsi_device inquiry data
rather than store the PQ separately. This method also means we don't have
offlined devices showing up under sd.

-- Patrick Mansfield
