From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Mon, 27 Nov 2006 18:33:49 -0500
Message-ID: <1164670429.3245.17.camel@mulgrave.il.steeleye.com>
References: <456B2416.7000101@panasas.com>  <456B38E9.6060209@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:18134 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1758610AbWK0XeG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Nov 2006 18:34:06 -0500
In-Reply-To: <456B38E9.6060209@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Benny Halevy <bhalevy@panasas.com>

On Mon, 2006-11-27 at 13:13 -0600, Mike Christie wrote:
> I thought they were continguous. I think James has said before that
> they
> can be disjoint. When we converted sg it did not look like sg or st
> supported disjoint. The main non dio path used a buffer from
> get_free_pages so I thought that would always be contiguous. The dio
> path then always set the first sg offset, but the rest it set to zero.

For ordinary mappings, they're contiguous ... there's an edge case where
you go through the deprecated buffer cache you can end up with multiple
sg elements that are 512 bytes in length, but this probably isn't worth
worrying about any more.

James


