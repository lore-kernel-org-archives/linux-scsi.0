From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] proper replacements for ->proc_info
Date: Fri, 25 Apr 2003 17:17:01 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030425171701.B8222@lst.de>
References: <20030423212157.A18850@lst.de> <1051126145.1970.7.camel@mulgrave> <20030425122754.A5030@lst.de> <20030425104137.GE10374@parcelfarce.linux.theplanet.co.uk> <20030425125918.A5330@lst.de> <20030425165252.A7951@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:53775 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S263301AbTDYPEy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2003 11:04:54 -0400
Content-Disposition: inline
In-Reply-To: <20030425165252.A7951@lst.de>; from hch@lst.de on Fri, Apr 25, 2003 at 04:52:52PM +0200
List-Id: linux-scsi@vger.kernel.org
To: viro@parcelfarce.linux.theplanet.co.uk
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Apr 25, 2003 at 04:52:52PM +0200, Christoph Hellwig wrote:
> On Fri, Apr 25, 2003 at 12:59:18PM +0200, Christoph Hellwig wrote:
> > > And that loop is protected by ...?
> > 
> > The right lock would be sdev->list_lock.
> 
> Actually it would probably be host->host_lock, not a per-sdev lock
> of course.  Locking down the my_device traversal is on my TODO
> list but a separate thing, though.

Oh, well.

Digging through all the (ab)users of ->my_devices I start to develop
a really strong favour of just nuking /proc/scsi/<driver>/* stuff
entirely.  There's really not much in there that shouldn't better be
done in sysfs.

