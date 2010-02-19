From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Fri, 19 Feb 2010 08:26:45 -0600
Message-ID: <1266589605.2822.2.camel@mulgrave.site>
References: <3e7aae31002170437i52ba4ba1w10c1ff224d9b37ef@mail.gmail.com>
	 <1266418952.2787.5.camel@mulgrave.site>
	 <3e7aae31002180046i771f2e1encfcda864f564c87e@mail.gmail.com>
	 <1266508049.4355.37.camel@mulgrave.site>
	 <3e7aae31002190443w44418778u6180c74d51a0f783@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab0BSO0w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2010 09:26:52 -0500
In-Reply-To: <3e7aae31002190443w44418778u6180c74d51a0f783@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ramya Desai <ramya.desai@gmail.com>
Cc: USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>

On Fri, 2010-02-19 at 18:13 +0530, Ramya Desai wrote:
> > In that case, it looks like the helpers in protocol.c do use chaining
> > correctly (as long as the driver isn't doing direct dma), but there's a
> > clamp on the sg table size in scsiglue.c:
> >
> > .sg_tablesize = SG_ALL
> >
> > That would have to be changed to SCSI_MAX_SG_CHAIN_SEGMENTS to enable
> > chaining.
> 
> Even after changing .sg_tablesize  to SCSI_MAX_SG_CHAIN_SEGMENTS, I am
> getting the same results (maximum 512KB of data transfer buffers in
> scsi_command).
> Is there any thing, that I am missing. Do I need to send any logs to
> analyze the problem?

Before we get into that, what architecture is this?  There are a few,
like arm that don't have architecture support for chaining, so they can
never go over 128 segments.

James


