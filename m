From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/6] ZAC host-aware device support
Date: Sun, 02 Aug 2015 09:11:10 -0700
Message-ID: <1438531870.2182.23.camel@HansenPartnership.com>
References: <1438347728-106434-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45860 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448AbbHBQLN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Aug 2015 12:11:13 -0400
In-Reply-To: <1438347728-106434-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2015-07-31 at 15:02 +0200, Hannes Reinecke wrote:
> Hi all,
> 
> here is a patchset for adding ZAC host-aware device support to libata.
> Main bits are translations for ZBC IN and ZBC OUT; others are the
> required plumbing like generating the correct VPD pages.
> James, do you require a separate patch for adding ZBC IN and ZBC OUT
> or is it okay to have it queued here?

This really belongs in the ZBC patch set, doesn't it? Why isn't it
there.  You can't avoid the dependency.  If it goes with the ZAC patch
set, then the ZBC one depends on ZAC.  If it goes properly with ZBC then
you need an additional patch adding the ATA translations after the ZBC
one.  On the whole, I'd prefer the latter so we always have the required
consumers of the API.

In fact, if I read the dependencies correctly, you need the ZBC patches
first, don't you ... otherwise there's nothing to drive host aware ZAC?

James

James

> As usual, reviews and comments are welcome.
> 
> Hannes Reinecke (6):
>   libata: Do not retry commands with valid autosense
>   libata-scsi: use ata_scsi_set_sense when generating ATA sense
>   libata: implement ZBC IN translation
>   libata: Implement ZBC OUT translation
>   libata: support device-managed ZAC devices
>   libata: support host-aware ZAC devices
> 
>  drivers/ata/libata-core.c     |  50 +++++++
>  drivers/ata/libata-eh.c       |   4 +
>  drivers/ata/libata-scsi.c     | 299 +++++++++++++++++++++++++++++++++++-------
>  include/linux/ata.h           |  17 +++
>  include/linux/libata.h        |   7 +
>  include/scsi/scsi_proto.h     |   9 ++
>  include/trace/events/libata.h |   2 +
>  7 files changed, 344 insertions(+), 44 deletions(-)
> 



