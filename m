From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] proper replacements for ->proc_info
Date: Fri, 25 Apr 2003 12:59:18 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030425125918.A5330@lst.de>
References: <20030423212157.A18850@lst.de> <1051126145.1970.7.camel@mulgrave> <20030425122754.A5030@lst.de> <20030425104137.GE10374@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:6158 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S263862AbTDYKrL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2003 06:47:11 -0400
Content-Disposition: inline
In-Reply-To: <20030425104137.GE10374@parcelfarce.linux.theplanet.co.uk>; from viro@parcelfarce.linux.theplanet.co.uk on Fri, Apr 25, 2003 at 11:41:37AM +0100
List-Id: linux-scsi@vger.kernel.org
To: viro@parcelfarce.linux.theplanet.co.uk
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Apr 25, 2003 at 11:41:37AM +0100, viro@parcelfarce.linux.theplanet.co.uk wrote:
> On Fri, Apr 25, 2003 at 12:27:54PM +0200, Christoph Hellwig wrote:
> 
> > +	list_for_each_entry(sdev, &host->my_devices, siblings) {
> > +		seq_printf(s, " %2d:%2d   %4d      %4d\n",
> > +				sdev->id, sdev->lun,
> > +				NCR_700_get_depth(sdev),
> > +				sdev->current_tag);
> 
> And that loop is protected by ...?

The right lock would be sdev->list_lock.
