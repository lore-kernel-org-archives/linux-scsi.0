From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] 2.6 aacraid: Add sysfs files for aacraid adapter
	information (re-diff)
Date: Mon, 23 May 2005 11:36:48 -0700
Message-ID: <1116873408.22284.26.camel@markh1.pdx.osdl.net>
References: <1116362098.5838.2.camel@markh1.pdx.osdl.net>
	 <20050522165443.GA31638@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:50833 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261933AbVEWSg7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2005 14:36:59 -0400
In-Reply-To: <20050522165443.GA31638@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Sun, 2005-05-22 at 17:54 +0100, Christoph Hellwig wrote:
> On Tue, May 17, 2005 at 01:34:57PM -0700, Mark Haverkamp wrote:
[...]
> > +static ssize_t aac_show_host_version(struct class_device *class_dev,
> > +		char *buf)
> > +{
> > +	int len;
> > +
> > +	len = snprintf(buf, PAGE_SIZE, "Adaptec Raid Controller: %s %s\n",
> > +		  AAC_DRIVER_VERSION,
> > +		  AAC_DRIVER_BUILD_DATE);
> > +	return len;
> > +}
> 
> the "Adaptec Raid Controller:" doesn't belong in here.  The driver build
> data and version neither, use MODULE_VERSION instead.

Using MODULE_VERSION in the snprinf doesn't seem to work:

drivers/scsi/aacraid/linit.c: In function `aac_show_host_version':
drivers/scsi/aacraid/linit.c:541: error: `MODULE_VERSION' undeclared (first use in this function)

> 
> > +
> > +static ssize_t aac_show_model(struct class_device *class_dev,
> > +		char *buf)
> > +{
> > +	struct aac_dev *dev = (struct aac_dev*)class_to_shost(class_dev)->hostdata;
> 
> No need to cast.

It looks like the cast is needed.  If I remove it I get a compile
warning.

drivers/scsi/aacraid/linit.c: In function `aac_show_model':
drivers/scsi/aacraid/linit.c:548: warning: initialization from incompatible pointer type


-- 
Mark Haverkamp <markh@osdl.org>

