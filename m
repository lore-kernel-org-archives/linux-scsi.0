From: Christoph Hellwig <hch@infradead.org>
Subject: Re: correct deregistration from scsi_transport_fc
Date: Mon, 5 Sep 2005 13:34:03 +0100
Message-ID: <20050905123403.GC15791@infradead.org>
References: <OFAAE017F2.A67F0DDA-ONC125706C.00546128-C125706C.0054C0AC@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:48319 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751202AbVIEMeF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Sep 2005 08:34:05 -0400
Content-Disposition: inline
In-Reply-To: <OFAAE017F2.A67F0DDA-ONC125706C.00546128-C125706C.0054C0AC@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <AHERRMAN@de.ibm.com>
Cc: James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org

On Mon, Aug 29, 2005 at 05:27:47PM +0200, Andreas Herrmann wrote:
>   > It works by accident, but I will veto any updates you're going to send
>   > for this broken behaviour.
> 
> So scsi_add_device will soon be mentioned in
> Documentation/feature-removal-schedule.txt?

No, the will still be available for transport where they make sense,
aka non-SAM things like RAID adapters.

> What is the rationale of proscribing usage of scsi_add_device() when
> scsi_transport_fc is used?

We do actually use it inernally in the sysfs scan attribute.  We don't
want the driver to do their own LUN scanning, though - that's the job
of the generic scsi code.

>   > That's intentional.  See the discussion during development of the FC
>   > transport class.  I don't like that behaviour but it's a compromise we
>   > agreed on.
> 
> Where is the function to remove the scsi target representation of
> an rport? You did not agree on having memory leaks in the kernel, did
> you?

fc_remove_host will remove it when the host is gone.

