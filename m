From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 11/14] irq: add support for allocating (and affinitizing)
 sets of IRQs
Date: Tue, 30 Oct 2018 09:18:05 -0600
Message-ID: <d049e764-b9d1-f06f-40d3-39517f3f65a2@kernel.dk>
References: <20181029163738.10172-1-axboe@kernel.dk>
 <20181029163738.10172-12-axboe@kernel.dk>
 <20181030142601.GA18906@localhost.localdomain>
 <c11c95ae-5e10-38bd-d2c2-e2407634f52a@kernel.dk>
 <20181030144527.GB18906@localhost.localdomain>
 <46dbcbcd-799f-9970-a68f-de7e96b1a6bb@kernel.dk>
 <20181030150840.GC18906@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181030150840.GC18906@localhost.localdomain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On 10/30/18 9:08 AM, Keith Busch wrote:
> On Tue, Oct 30, 2018 at 08:53:37AM -0600, Jens Axboe wrote:
>> The sum of the set can't exceed the nvecs passed in, the nvecs passed in
>> should be the less than or equal to nvecs. Granted this isn't enforced,
>> and perhaps that should be the case.
> 
> That should at least initially be true for a proper functioning
> driver. It's not enforced as you mentioned, but that's only related to
> the issue I'm referring to.
> 
> The problem is pci_alloc_irq_vectors_affinity() takes a range, min_vecs
> and max_vecs, but a range of allowable vector allocations doesn't make
> sense when using sets.

I feel like we're going in circles here, not sure what you feel the
issue is now? The range is fine, whoever uses sets will need to adjust
their sets based on what pci_alloc_irq_vectors_affinity() returns,
if it didn't return the passed in desired max.

-- 
Jens Axboe
