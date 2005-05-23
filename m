From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 2.6 aacraid: Add sysfs files for aacraid adapter information (re-diff)
Date: Mon, 23 May 2005 19:46:10 +0100
Message-ID: <20050523184610.GA19285@infradead.org>
References: <1116362098.5838.2.camel@markh1.pdx.osdl.net> <20050522165443.GA31638@infradead.org> <1116873408.22284.26.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:28803 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261936AbVEWSqP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2005 14:46:15 -0400
Content-Disposition: inline
In-Reply-To: <1116873408.22284.26.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Mon, May 23, 2005 at 11:36:48AM -0700, Mark Haverkamp wrote:
> > the "Adaptec Raid Controller:" doesn't belong in here.  The driver build
> > data and version neither, use MODULE_VERSION instead.
> 
> Using MODULE_VERSION in the snprinf doesn't seem to work:
> 
> drivers/scsi/aacraid/linit.c: In function `aac_show_host_version':
> drivers/scsi/aacraid/linit.c:541: error: `MODULE_VERSION' undeclared (first use in this function)

sorry, MODULE_VERSION is a macro similar to MODULE_LICENSE or MODULE_AUTHOR.
You say MODULE_VERSION("something"); outside any function and you can find
the version out using modinfo and sysfs (not sure the latter is implemented
yet, but there were patches floating around)

> > > +
> > > +static ssize_t aac_show_model(struct class_device *class_dev,
> > > +		char *buf)
> > > +{
> > > +	struct aac_dev *dev = (struct aac_dev*)class_to_shost(class_dev)->hostdata;
> > 
> > No need to cast.
> 
> It looks like the cast is needed.  If I remove it I get a compile
> warning.
> 
> drivers/scsi/aacraid/linit.c: In function `aac_show_model':
> drivers/scsi/aacraid/linit.c:548: warning: initialization from incompatible pointer type

Sorry, you're right.  hostdata is an unsigned long.
