From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] wd719x: pass GFP_ATOMIC instead of GFP_KERNEL
Date: Tue, 28 May 2019 23:23:16 -0700
Message-ID: <20190529062316.GA3997@infradead.org>
References: <20190529013540.GA20273@hari-Inspiron-1545>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190529013540.GA20273@hari-Inspiron-1545>
Sender: linux-kernel-owner@vger.kernel.org
To: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 29, 2019 at 07:05:40AM +0530, Hariprasad Kelam wrote:
> wd719x_chip_init is getting called in interrupt disabled
> mode(spin_lock_irqsave) , so we need to GFP_ATOMIC instead
> of GFP_KERNEL.
> 
> Issue identified by coccicheck

I don't think request_firmware is any more happy being called under
a spinlock.  The right fix is to not hold a spinlock over the board
initialization.
