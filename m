From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 11/14] irq: add support for allocating (and affinitizing)
 sets of IRQs
Date: Tue, 30 Oct 2018 09:08:40 -0600
Message-ID: <20181030150840.GC18906@localhost.localdomain>
References: <20181029163738.10172-1-axboe@kernel.dk>
 <20181029163738.10172-12-axboe@kernel.dk>
 <20181030142601.GA18906@localhost.localdomain>
 <c11c95ae-5e10-38bd-d2c2-e2407634f52a@kernel.dk>
 <20181030144527.GB18906@localhost.localdomain>
 <46dbcbcd-799f-9970-a68f-de7e96b1a6bb@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <46dbcbcd-799f-9970-a68f-de7e96b1a6bb@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 30, 2018 at 08:53:37AM -0600, Jens Axboe wrote:
> The sum of the set can't exceed the nvecs passed in, the nvecs passed in
> should be the less than or equal to nvecs. Granted this isn't enforced,
> and perhaps that should be the case.

That should at least initially be true for a proper functioning
driver. It's not enforced as you mentioned, but that's only related to
the issue I'm referring to.

The problem is pci_alloc_irq_vectors_affinity() takes a range, min_vecs
and max_vecs, but a range of allowable vector allocations doesn't make
sense when using sets.
