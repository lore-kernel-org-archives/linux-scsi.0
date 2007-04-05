From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] stex: fix id mapping issue(v3)
Date: Thu, 5 Apr 2007 08:42:15 +0100
Message-ID: <20070405074215.GA25196@infradead.org>
References: <NONAMEB8v5DkoQ4qcm500000733@nonameb.ptu.promise.com> <1175735159.3693.55.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:41708 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946048AbXDEHm3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Apr 2007 03:42:29 -0400
Content-Disposition: inline
In-Reply-To: <1175735159.3693.55.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Ed Lin <ed.lin@promise.com>, linux-scsi <linux-scsi@vger.kernel.org>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>

On Wed, Apr 04, 2007 at 08:05:59PM -0500, James Bottomley wrote:
> Erm, there's a simple way out of this:  That's the BLIST_FORCELUN
> option.  This is why most of the RAID devices have entries in
> scsi_devinfo.c like:
> 
>         {"ADAPTEC", "AACRAID", NULL, BLIST_FORCELUN},
> 
> Which overrides the CONFIG_SCSI_MULTI_LUN setting for the particular
> device.  We can easily add an entry for stex as well.

IMHO we should kill CONFIG_SCSI_MULTI_LUN and add blacklist enries for
devices that don't handle scanning for luns > 1 instead.  I think the
RH/Fedora kernel has started collecting these blacklist entries for
a long time already.
