From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] [SCSI] sd: set BIO_MAPPED_INTEGRITY bit correctly in
	sd_dif_prepare().
Date: Wed, 7 Mar 2012 08:56:25 -0700
Message-ID: <20120307155624.GC19570@parisc-linux.org>
References: <1331131295-3707-1-git-send-email-santoshprasadnayak@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:59273 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab2CGP41 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Mar 2012 10:56:27 -0500
Content-Disposition: inline
In-Reply-To: <1331131295-3707-1-git-send-email-santoshprasadnayak@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, mkp@mkp.net

On Wed, Mar 07, 2012 at 08:11:35PM +0530, santosh nayak wrote:
> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> Value of BIO_MAPPED_INTEGRITY is 11. Intention was to set the 11th bit.

Also, can we introduce:

#define bio_set_flag(bio, flag)	((bio)->bi_flags |= (1 << (flag)))

Then hunt down and kill all the places that manipulate bi_flags by hand?
We might also need:

#define bio_set_flag_atomic(bio, flag) set_bit(&(bio)->bi_flags, (flag))

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
