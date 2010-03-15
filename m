From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] dpt_i20: several use after free issues
Date: Mon, 15 Mar 2010 13:45:26 -0700
Message-ID: <20100315134526.0b2e3637.akpm@linux-foundation.org>
References: <20100315082656.GJ18181@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100315082656.GJ18181@bicker>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Yang Hongyang <yanghy@cn.fujitsu.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Alan Cox <alan@linux.intel.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 15 Mar 2010 11:26:56 +0300
Dan Carpenter <error27@gmail.com> wrote:

> adpt_i2o_delete_hba() calls kfree() so we have to save "pHba->next"
> before calling it.  Also inside adpt_i2o_delete_hba() itself, there
> was another use after free bug which I fixed by moving the kfree() 
> down a line.

erk.  This code should be crashing most gruesomely.  I wonder why it
doesn't.
