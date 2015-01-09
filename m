From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/2] target: Don't arbitrary limit I/O size to
 fabric_max_sectors
Date: Fri, 09 Jan 2015 14:10:35 -0800
Message-ID: <1420841435.29673.19.camel@haakon3.risingtidesystems.com>
References: <1420590258-21122-1-git-send-email-nab@daterainc.com>
	 <1420647107.12144.8.camel@haakon3.risingtidesystems.com>
	 <yq1zj9t2v9t.fsf@sermon.lab.mkp.net>
	 <1420757368.2842.33.camel@haakon3.risingtidesystems.com>
	 <yq17fwv1y7z.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39123 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbbAIWKs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2015 17:10:48 -0500
In-Reply-To: <yq17fwv1y7z.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>

On Fri, 2015-01-09 at 15:43 -0500, Martin K. Petersen wrote:
> >>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:
> 
> nab> The concern is when older hardware drivers are reporting say
> nab> queue_max_hw_sectors=128 with initiators are not actively honoring
> nab> block limits EVPD MAXIMUM TRANSFER LENGTH, that would result in
> nab> I/Os over 64K generating exception status.
> 
> Given that you're already splitting I/Os in IBLOCK I think it would
> probably be better to pick a size you're comfortable with. 4 or 8 megs
> sound reasonable to be
> 

I'm now thinking to go just ahead and drop the hw_max_sectors check in
sbc_parse_cdb() as well, and leave hw_max_sectors as a purely
informational attribute representing the granularity each backend driver
and/or subsystem is splitting I/Os upon.

Which would mean there is no longer a maximum I/O size enforced by the
target.  This used to be the case in < v3.5 code, before Roland added
fabric_max_sectors to enforce the global 4 MB maximum that people
recently have been starting to run up against with initiators not
honoring block limits VPD.

That said, I don't recall there being any issues with the earlier code
not enforcing a maximum I/O size, so in order to avoid the same problem
in the future it probably makes the sense to go ahead process any
arbitrary sized I/O.

Re-spinning a -v2 with this in mind.

--nab






