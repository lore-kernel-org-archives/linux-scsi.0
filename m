From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: Transport Attributes -- attempt#4
Date: Tue, 24 Feb 2004 23:08:47 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040225070847.GA504005@sgi.com>
References: <20040120215645.GG15871@localhost> <1077581832.1833.21.camel@mulgrave> <20040224055828.GA503530@sgi.com> <1077634979.1827.7.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:65376 "EHLO rj.sgi.com")
	by vger.kernel.org with ESMTP id S262644AbUBYHIy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2004 02:08:54 -0500
Content-Disposition: inline
In-Reply-To: <1077634979.1827.7.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Martin Hicks <mort@wildopensource.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Feb 24, 2004 at 09:02:56AM -0600, James Bottomley wrote:
> On Mon, 2004-02-23 at 23:58, Jeremy Higdon wrote:
> > James, was scsi/scsi_transport.h supposed to be patched also?
> > There is a new "size" member of the scsi_transport_template
> > structure, but no patch to the data structure itself.  Did you
> > replace attributes with size?
> 
> Well, not really.  The patch I provided is a sketch only of what I want
> done.  It compiles and works on the 53c700 which is where I tested it.
> 
> Really, I just want transport and core separated and transport
> attributes to be fixed (so there's some way of defining a transport
> private API for updating them).
> 
> Even with just offset and period as the transport attributes for SPI,
> that gives enough to move domain validation out of all the drivers into
> the SPI transport layer.

Okay, that's fine.

What I meant to say is that I get a compile error at the following
line in scsi_scan.c:

	sdev = kmalloc(sizeof(*sdev) + shost->transportt->size, GFP_ATOMIC);

In Martin's version of scsi_transport.h, there is no "size" member of
struct scsi_transport_template.

So I figured you must have left it out of your patch.  I also saw this
in your patch, which makes it look as though default_attr_values (mistakenly
called "attributes" by me above) was replaced by size:

 struct scsi_transport_template spi_transport_template = {
        .attrs = spi_transport_attrs,
        .class = &spi_transport_class,
-       .setup = &spi_alloc_transport_attrs,
-       .cleanup = &spi_destroy_transport_attrs,
-       .default_attr_values = &spi_transport_attr_defaults,
+       .setup = &spi_setup_transport_attrs,
+       .cleanup = NULL,
+       .size = sizeof(struct spi_transport_attrs) - sizeof(unsigned long),
 };

thanks

jeremy
