From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] 4/6: scsi_allow_ghost_devices
Date: Mon, 19 Apr 2004 08:06:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082376382.4635.65.camel@compaq.xsintricity.com>
References: <20040418185950.GG4868@tpkurt.garloff.de>
	 <20040418202022.B3393@infradead.org>
	 <1082360042.4691.3.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58034 "EHLO mx2.redhat.com")
	by vger.kernel.org with ESMTP id S264376AbUDSMID (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Apr 2004 08:08:03 -0400
In-Reply-To: <1082360042.4691.3.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan Van de Ven <arjanv@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>

On Mon, 2004-04-19 at 03:34, Arjan van de Ven wrote:
> > I'm very unhappy with that.  Could you explain why EMC needs this?
> > And even if we have to work around it I'd rather use the blacklist mechanism
> > for this.
> 
> they allow the admin to config the box without a lun 0....
> I 100% agree it's blacklist material.

Actually, the original reason for the patch was the fact that some
external boxes use LUN 0 as a control device that you send commands to
in order to init logical volumes.  Without access to the control device
(which previously was always shown as offline), you couldn't set the box
up with any linux tools, you would have to set up the logical volumes
under Windows then boot into linux to see them.  Since the LUN 0 device
wasn't really offline, but instead was reported as a disk device with no
attached physical device, this patch was created to allow the linux
kernel to send commands to the control device.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


