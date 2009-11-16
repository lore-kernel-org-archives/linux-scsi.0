From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 4/9] osduld: Use device->release instead of internal
 kref
Date: Mon, 16 Nov 2009 13:52:22 -0600
Message-ID: <1258401142.2517.226.camel@mulgrave.site>
References: <4B019BEC.3080909@panasas.com>
	 <1258397115-32682-1-git-send-email-bharrosh@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbZKPTwX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Nov 2009 14:52:23 -0500
In-Reply-To: <1258397115-32682-1-git-send-email-bharrosh@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

On Mon, 2009-11-16 at 20:45 +0200, Boaz Harrosh wrote:
> +	dev_set_drvdata(&oud->class_dev, oud);

This is incredibly minor, but since the device is now embedded in oud,
you can simply cast out to get the containing structure:

oud = container_of(dev, struct osd_uld_device, class_dev);

It's not worth redoing the patch set over, but it is worth remembering
for the future.

James


