From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: [PATCH] megaraid_sas: Enable shared host tag map
Date: Mon, 24 Nov 2014 21:22:49 +0530
Message-ID: <cec16f1d245f8e7b2dbe5ccbd7455cc3@mail.gmail.com>
References: <1416843235-35947-1-git-send-email-hare@suse.de> <20141124153558.GA27364@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og104.obsmtp.com ([64.18.2.161]:44141 "EHLO
	exprod7og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaKXPwy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 10:52:54 -0500
Received: by mail-la0-f50.google.com with SMTP id pv20so7918714lab.9
        for <linux-scsi@vger.kernel.org>; Mon, 24 Nov 2014 07:52:51 -0800 (PST)
In-Reply-To: <20141124153558.GA27364@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Sumit Saxena <sumit.saxena@avagotech.com>, linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@lst.de]
> Sent: Monday, November 24, 2014 9:06 PM
> To: Hannes Reinecke
> Cc: James Bottomley; Sumit Saxena; Kashyap Desai; Christoph Hellwig;
linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH] megaraid_sas: Enable shared host tag map
>
> On Mon, Nov 24, 2014 at 04:33:55PM +0100, Hannes Reinecke wrote:
> > The megaraid SAS driver uses a shared host tag map internally, so we
> > should be telling the block layer about it.
>
> But it doesn't make use of request->tag yet.  This would only be useful
if you
> got rid of the internal tag allocator.

I have patch for code changes in this particular area and that is
currently under internal test cycle.

Next patch series will start using shared blk tag for internal MPT frame
allocation. It will get-rid-off  MPT frame pool link list completely and
also does lots of refactor w.r.t MFI/MPT frame corruption issue. Using
shared blk tag gave good performance improvement as driver completely
removed mpt frame spin lock used in megasas_get_cmd_fusion/
megasas_return_cmd_fusion.

~ Kashyap
