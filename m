From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] megaraid: kmemleak: Track page allocation for fusion
Date: Fri, 15 Sep 2017 11:00:07 -0700
Message-ID: <20170915180007.GA24045@infradead.org>
References: <20170915052152.5032-1-shuwang@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170915052152.5032-1-shuwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: shuwang@redhat.com
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chuhu@redhat.com, yizhan@redhat.com, catalin.marinas@arm.com
List-Id: linux-scsi@vger.kernel.org

I think the megaraid fusion code has a deeper problem here.

Instead of playing weird games with get_free_pages and vmalloc
the structure just needs to shrink by moving all the arrays
of MAX_MSIX_QUEUES_FUSION size into a separate allocation for each,
and then we have normall, small kmalloc allocations.
