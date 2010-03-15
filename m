From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [patch] dpt_i20: several use after free issues
Date: Mon, 15 Mar 2010 17:48:11 -0500
Message-ID: <1268693291.2853.60.camel@mulgrave.site>
References: <20100315082656.GJ18181@bicker>
	 <20100315134526.0b2e3637.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100315134526.0b2e3637.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Carpenter <error27@gmail.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Yang Hongyang <yanghy@cn.fujitsu.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Alan Cox <alan@linux.intel.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2010-03-15 at 13:45 -0700, Andrew Morton wrote:
> On Mon, 15 Mar 2010 11:26:56 +0300
> Dan Carpenter <error27@gmail.com> wrote:
> 
> > adpt_i2o_delete_hba() calls kfree() so we have to save "pHba->next"
> > before calling it.  Also inside adpt_i2o_delete_hba() itself, there
> > was another use after free bug which I fixed by moving the kfree() 
> > down a line.
> 
> erk.  This code should be crashing most gruesomely.  I wonder why it
> doesn't.

I'm tempted to say because we have no users, but actually, for this
driver, I know we do.  So I think it works because most people don't
have poisoning turned on in a running system and there's no sleep
between the free and the use, so no opportunity to reuse the area on the
percpu hot list even in an smp system.

I'll add it to -rc fixes ... when I get the current misc tree broken
apart.

James
