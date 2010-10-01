From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] sd: improve logic and efficiecy of media-change detection
Date: Fri, 1 Oct 2010 16:26:39 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1010011622590.1813-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1009071142100.1848-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:45152 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751414Ab0JAU0k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2010 16:26:40 -0400
In-Reply-To: <Pine.LNX.4.44L0.1009071142100.1848-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

I'm still awaiting some feedback on this patch submission:

	http://marc.info/?l=linux-scsi&m=128387424521838&w=2

> This patch (as1415) improves the formerly incomprehensible logic in
> sd_media_changed() (the current code refers to "changed" as a state,
> whereas in fact it is a relation between two states).  It also adds a
> big comment so that everyone can understand what is really going on.
> 
> The patch also improves efficiency by not reporting a media change
> when no medium was ever present.  If no medium was present the last
> time we checked and there's still no medium, it's not necessary to
> tell the caller that a change occurred.  Doing so merely causes the
> caller to attempt to revalidate a non-existent disk, which is a waste
> of time.

While not critically important, it does fix a bug: It gets rid of 
excess I/O (attempts to probe a drive with no medium currently 
generate two TEST UNIT READY commands, but only one is needed).

Alan Stern

