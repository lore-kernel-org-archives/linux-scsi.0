From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: target_alloc is noisy on failure
Date: Sun, 18 Dec 2005 13:48:12 -0600
Message-ID: <1134935293.3517.17.camel@mulgrave>
References: <20051218192925.GM2361@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:59046 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965255AbVLRTsT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Dec 2005 14:48:19 -0500
In-Reply-To: <20051218192925.GM2361@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Sun, 2005-12-18 at 12:29 -0700, Matthew Wilcox wrote:
> However, returning an error from target_alloc is noisy:
> 
>         int error = shost->hostt->target_alloc(starget);
> 
> 	if(error) {
> 		dev_printk(KERN_ERR, dev,
> 			"target allocation failed, error %d\n", error);
> 
> so I don't really want to do this.  Any thoughts on defining some
> 'quiet' return values from target_alloc?

Well, obviously, for consistency it should be the same quiet return as
for slave_alloc (i.e. -ENXIO).

James


