From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/4] stex: fix id mapping issue(v3)
Date: Thu, 05 Apr 2007 08:58:13 -0500
Message-ID: <1175781493.3714.6.camel@mulgrave.il.steeleye.com>
References: <NONAMEB8v5DkoQ4qcm500000733@nonameb.ptu.promise.com>
	 <1175735159.3693.55.camel@mulgrave.il.steeleye.com>
	 <20070405074215.GA25196@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:38247 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766996AbXDEN6W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Apr 2007 09:58:22 -0400
In-Reply-To: <20070405074215.GA25196@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ed Lin <ed.lin@promise.com>, linux-scsi <linux-scsi@vger.kernel.org>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>

On Thu, 2007-04-05 at 08:42 +0100, Christoph Hellwig wrote:
> On Wed, Apr 04, 2007 at 08:05:59PM -0500, James Bottomley wrote:
> > Erm, there's a simple way out of this:  That's the BLIST_FORCELUN
> > option.  This is why most of the RAID devices have entries in
> > scsi_devinfo.c like:
> > 
> >         {"ADAPTEC", "AACRAID", NULL, BLIST_FORCELUN},
> > 
> > Which overrides the CONFIG_SCSI_MULTI_LUN setting for the particular
> > device.  We can easily add an entry for stex as well.
> 
> IMHO we should kill CONFIG_SCSI_MULTI_LUN and add blacklist enries for
> devices that don't handle scanning for luns > 1 instead.  I think the
> RH/Fedora kernel has started collecting these blacklist entries for
> a long time already.

I wouldn't disagree with that.  There have been several schools of
thought on this:  One was that every multi-lun device since SPC should
support REPORT LUNS, so MULTI_LUN should be off by default and we
whitelist non SPC compliant multi-lun devices.  If we also added a host
hook to allow RAID devices to declare themselves, then I think we
capture 99% of the current cases.

Another is just to make it on by default.  I note that both SLES10 and
RHEL5 now define it on, so I can't see much argument in support of a
distro setting it off.

James


