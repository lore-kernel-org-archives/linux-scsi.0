From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] [SCSI] sd: set BIO_MAPPED_INTEGRITY bit correctly in
	sd_dif_prepare().
Date: Wed, 7 Mar 2012 08:44:36 -0700
Message-ID: <20120307154436.GB19570@parisc-linux.org>
References: <1331131295-3707-1-git-send-email-santoshprasadnayak@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1331131295-3707-1-git-send-email-santoshprasadnayak@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 07, 2012 at 08:11:35PM +0530, santosh nayak wrote:
> -		bio->bi_flags |= BIO_MAPPED_INTEGRITY;
> +		set_bit(BIO_MAPPED_INTEGRITY, &bio->bi_flags);

This uses an atomic operation; you should rather use __set_bit instead.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
