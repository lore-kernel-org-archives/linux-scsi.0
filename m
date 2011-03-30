From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 10/10] isci/core: common definitions and utility
 functions
Date: Wed, 30 Mar 2011 10:37:52 -0400
Message-ID: <20110330143752.GA31559@infradead.org>
References: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
 <20110310105511.6485.41512.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54101 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab1C3Ohz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Mar 2011 10:37:55 -0400
Content-Disposition: inline
In-Reply-To: <20110310105511.6485.41512.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

> +/**
> + * SCIC_SWAP_DWORD() -
> + *
> + * Normal byte swap macro
> + */
> +#define SCIC_SWAP_DWORD(x) \
> +	(\
> +		(((x) >> 24) & 0x000000FF) \
> +		| (((x) >>  8) & 0x0000FF00) \
> +		| (((x) <<  8) & 0x00FF0000) \
> +		| (((x) << 24) & 0xFF000000) \
> +	)

Duplicates the kernel byte sewap macros.  Even worse it's doing an
unconditional swap instead of a conditional one if the platform
is big endian.  While we're at it this driver seems to lack any
kind of endiness awareness, but that's probably to be expected
coming from intel.  Isn't the new chipset generation supposed to
support ia64 as well, which is capable of running in big endian
mode?

