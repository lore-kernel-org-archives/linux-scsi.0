From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] add scsi_driver.h
Date: Thu, 26 Jun 2003 09:16:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030626071616.GA27218@lst.de>
References: <20030624064941.GB26582@lst.de> <1056601098.1846.47.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:55742 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265438AbTFZHCN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2003 03:02:13 -0400
Content-Disposition: inline
In-Reply-To: <1056601098.1846.47.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Jun 25, 2003 at 11:18:16PM -0500, James Bottomley wrote:
> On Tue, 2003-06-24 at 01:49, Christoph Hellwig wrote:
> > include/scsi/scsi_driver.h contains ?verything related to upper
> > level drivers.  Unlike the other header moves there's no compatiblity
> > this time as it's easy to fix up the few users.
> 
> This patch actually doesn't seem to contain scsi/scsi_driver.h

Looks like I forgot to check it in.  Here it is:


#ifndef _SCSI_SCSI_DRIVER_H
#define _SCSI_SCSI_DRIVER_H

#include <linux/device.h>

struct module;


struct scsi_driver {
	struct module		*owner;
	struct device_driver	gendrv;

	int (*init_command)(struct scsi_cmnd *);
	void (*rescan)(struct device *);
};
#define to_scsi_driver(drv) \
	container_of((drv), struct scsi_driver, gendrv)

extern int scsi_register_driver(struct device_driver *);
#define scsi_unregister_driver(drv) \
	driver_unregister(drv);

extern int scsi_register_interface(struct class_interface *);
#define scsi_unregister_interface(intf) \
	class_interface_unregister(intf)

#endif /* _SCSI_SCSI_DRIVER_H */
