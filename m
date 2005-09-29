From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SATA suspend/resume (was Re: [PATCH] updated version of Jens' SATA suspend-to-ram patch)
Date: Thu, 29 Sep 2005 09:11:51 +0100
Message-ID: <20050929081151.GA10660@infradead.org>
References: <20050923163334.GA13567@triplehelix.org> <433B79D8.9080305@pobox.com> <20050929073437.GC9669@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:5534 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751125AbVI2IL4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Sep 2005 04:11:56 -0400
Content-Disposition: inline
In-Reply-To: <20050929073437.GC9669@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jgarzik@pobox.com>, Joshua Kwan <joshk@triplehelix.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@suse.de, torvalds@osdl.org, randy_dunlap <rdunlap@xenotime.net>

On Thu, Sep 29, 2005 at 08:34:37AM +0100, Christoph Hellwig wrote:
> is an ULDD operation, not an LLDD one, and this fits the layering model
> much better.  The only complaints here are cosmetics:
> 
>  - generic_scsi_suspend/generic_scsi_resume are misnamed, they should
>    probably be scsi_device_suspend/resume.
>  - while we're at it they could probably move to scsi_sysfs.c to keep
>    them static in one file - they're just a tiny bit of glue anyway.
>  - get rid of all the CONFIG_PM ifdefs - it just clutters thing up far
>    too much.

Actually one important thing is missing, that is a way to avoid spinning
down external disks.  As a start a sysfs-controlable flag should do it,
later we can add transport-specific ways to find out whether a device
is external.
