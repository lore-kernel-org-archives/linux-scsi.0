From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] aic79xx: convert qfrozen to atomic_t
Date: Tue, 7 Feb 2006 11:00:55 +0000
Message-ID: <20060207110055.GA13539@infradead.org>
References: <43E851D2.1060306@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43210 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965005AbWBGLA4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 06:00:56 -0500
Content-Disposition: inline
In-Reply-To: <43E851D2.1060306@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "emmanuel.fuste" <emmanuel.fuste@laposte.net>

On Tue, Feb 07, 2006 at 08:52:50AM +0100, Hannes Reinecke wrote:
> This patch converts platform_data->qfrozen to atomic_t.
> This way we can get rid of ahd_lock / ahd_unlock for the
> accessor functions; it also fixes some deadlocks in the
> recovery code (again).

Is ahd_freeze_simq called recursively at all?  If not it would be much
better to just kill it completely and just rely on the block layer, as
we do in all the other drivers.

