From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2.6] cciss typo fix
Date: Fri, 07 Jan 2005 18:19:28 -0500
Message-ID: <1105139968.4151.26.camel@mulgrave>
References: <20050107230103.GB26037@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:48611 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261713AbVAGXTz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jan 2005 18:19:55 -0500
In-Reply-To: <20050107230103.GB26037@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mike.miller@hp.com
Cc: Andrew Morton <akpm@osdl.org>, Jens Axboe <axboe@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-01-07 at 17:01 -0600, mike.miller@hp.com wrote:
> -		*total_size = be32_to_cpu(*((__be32 *) &buf->total_size[0]))+1;
> -		*block_size = be32_to_cpu(*((__be32 *) &buf->block_size[0]));
> +		*total_size = be32_to_cpu(*((__u32 *) &buf->total_size[0]))+1;
> +		*block_size = be32_to_cpu(*((__u32 *) &buf->block_size[0]));

I don't think that's a typo.  It was introduced by this patch:

ChangeSet 1.1988.24.79 2004/10/06 07:55:02 viro@www.linux.org.uk
  [PATCH] cciss endianness and iomem annotations
 
The idea being that BE and LE numbers should be annotated differently,
so the __be32 annotations look correct to me.  I think sparse will warn
if you make this change.

James


