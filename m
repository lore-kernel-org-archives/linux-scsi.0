From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] wd719x: pass GFP_ATOMIC instead of GFP_KERNEL
Date: Wed, 29 May 2019 14:11:46 -0700 (PDT)
Message-ID: <alpine.DEB.2.21.1905291410300.242480@chino.kir.corp.google.com>
References: <20190529013540.GA20273@hari-Inspiron-1545> <20190529062316.GA3997@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190529062316.GA3997@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Hariprasad Kelam <hariprasad.kelam@gmail.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 28 May 2019, Christoph Hellwig wrote:

> > wd719x_chip_init is getting called in interrupt disabled
> > mode(spin_lock_irqsave) , so we need to GFP_ATOMIC instead
> > of GFP_KERNEL.
> > 
> > Issue identified by coccicheck
> 
> I don't think request_firmware is any more happy being called under
> a spinlock.  The right fix is to not hold a spinlock over the board
> initialization.
> 

Right, and not even wd719x_chip_init() is always called in this context 
otherwise wd719x_board_found() would also need the same change.
