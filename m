From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] allow the HBA to reserve target and device private
	areas
Date: Wed, 25 May 2005 07:17:17 -0500
Message-ID: <1117023437.5071.2.camel@mulgrave>
References: <1116971851.5897.52.camel@mulgrave>
	 <20050525071353.GA13141@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:46311 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262308AbVEYMRa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 08:17:30 -0400
In-Reply-To: <20050525071353.GA13141@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-05-25 at 08:13 +0100, Christoph Hellwig wrote:
> Do we really need separate functions for this?  It would be so much nicer
> to just have target_priv_size and device_priv_size members in the
> foo_function_template.  Yes, it would mean having this in all different
> transport templates, but in general having this as compile-time initializer
> seems a lot nicer.

Well, they're not functions, they're inlines.  You at least have to have
an accessor function because the reserved area occurs after the
transport attributes and is aligned on the pointer size.

However, my first implementation was per transport class.  You don't
actually need the x_private_offset at all because you know the size of
the transport attributes.  I didn't like it because of all the
duplication, but I'm willing to go back to it if there's strong feeling
either way.

James


