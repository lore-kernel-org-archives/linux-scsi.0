From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] proper replacements for ->proc_info
Date: Wed, 23 Apr 2003 21:39:36 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030423213936.B19094@lst.de>
References: <20030423212157.A18850@lst.de> <1051126145.1970.7.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:15886 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S263591AbTDWT1b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Apr 2003 15:27:31 -0400
Content-Disposition: inline
In-Reply-To: <1051126145.1970.7.camel@mulgrave>; from James.Bottomley@SteelEye.com on Wed, Apr 23, 2003 at 03:29:01PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Apr 23, 2003 at 03:29:01PM -0400, James Bottomley wrote:
> On Wed, 2003-04-23 at 15:21, Christoph Hellwig wrote:
> > Two new host template methods:
> > 
> >      int (* show_info)(struct Scsi_Host *, struct seq_file *);
> >      int (* store_info)(struct Scsi_Host *, const char *, size_t);
> 
> 
> Well, this does look good, but by extension we could use something like
> this as a generic way to ship information to and from sysfs as well.
> 
> How about adding a "char *property" qualifier?  If it's null you just
> dump the whole lot (for /proc) but if it has a value, it's that specific
> property from sysfs.

For store_info?  I don't think that's a good idea - most users of
store_info should really be converted to sysfs insead, but this
would break all kinds of existing apps.  So we should add it but not
rip out the procfs support.  Mixing up procfs and sysfs code isn't
a good idea anyway - this will lead to overloaded APIs again.

