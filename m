From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 11/14] irq: add support for allocating (and affinitizing)
 sets of IRQs
Date: Tue, 30 Oct 2018 11:43:10 -0600
Message-ID: <f6a14948-bc3c-f32d-690f-9f1e4379140f@kernel.dk>
References: <20181029163738.10172-1-axboe@kernel.dk>
 <20181029163738.10172-12-axboe@kernel.dk>
 <20181030142601.GA18906@localhost.localdomain>
 <c11c95ae-5e10-38bd-d2c2-e2407634f52a@kernel.dk>
 <20181030144527.GB18906@localhost.localdomain>
 <46dbcbcd-799f-9970-a68f-de7e96b1a6bb@kernel.dk>
 <20181030150840.GC18906@localhost.localdomain>
 <d049e764-b9d1-f06f-40d3-39517f3f65a2@kernel.dk>
 <20181030160242.GD18906@localhost.localdomain>
 <27c1017a-9560-80cb-038d-f64727a162c3@kernel.dk>
 <alpine.DEB.2.21.1810301824570.5984@nanos.tec.linutronix.de>
 <a692fbb3-59ca-0ddb-7abd-67ffc7bfcc1f@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a692fbb3-59ca-0ddb-7abd-67ffc7bfcc1f@kernel.dk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Keith Busch <keith.busch@intel.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/30/18 11:34 AM, Jens Axboe wrote:
> On 10/30/18 11:25 AM, Thomas Gleixner wrote:
>> Jens,
>>
>> On Tue, 30 Oct 2018, Jens Axboe wrote:
>>> On 10/30/18 10:02 AM, Keith Busch wrote:
>>>> pci_alloc_irq_vectors_affinity() starts at the provided max_vecs. If
>>>> that doesn't work, it will iterate down to min_vecs without returning to
>>>> the caller. The caller doesn't have a chance to adjust its sets between
>>>> iterations when you provide a range.
>>>>
>>>> The 'masks' overrun problem happens if the caller provides min_vecs
>>>> as a smaller value than the sum of the set (plus any reserved).
>>>>
>>>> If it's up to the caller to ensure that doesn't happen, then min and
>>>> max must both be the same value, and that value must also be the same as
>>>> the set sum + reserved vectors. The range just becomes redundant since
>>>> it is already bounded by the set.
>>>>
>>>> Using the nvme example, it would need something like this to prevent the
>>>> 'masks' overrun:
>>>
>>> OK, now I hear what you are saying. And you are right, the callers needs
>>> to provide minvec == maxvec for sets, and then have a loop around that
>>> to adjust as needed.
>>
>> But then we should enforce it in the core code, right?
> 
> Yes, I was going to ask you if you want a followup patch for that, or
> an updated version of the original?

Here's an incremental, I'm going to fold this into the original unless
I hear otherwise.


diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index af24ed50a245..e6c6e10b9ceb 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1036,6 +1036,13 @@ static int __pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec,
 	if (maxvec < minvec)
 		return -ERANGE;
 
+	/*
+	 * If the caller is passing in sets, we can't support a range of
+	 * vectors. The caller needs to handle that.
+	 */
+	if (affd->nr_sets && minvec != maxvec)
+		return -EINVAL;
+
 	if (WARN_ON_ONCE(dev->msi_enabled))
 		return -EINVAL;
 
@@ -1087,6 +1094,13 @@ static int __pci_enable_msix_range(struct pci_dev *dev,
 	if (maxvec < minvec)
 		return -ERANGE;
 
+	/*
+	 * If the caller is passing in sets, we can't support a range of
+	 * supported vectors. The caller needs to handle that.
+	 */
+	if (affd->nr_sets && minvec != maxvec)
+		return -EINVAL;
+
 	if (WARN_ON_ONCE(dev->msix_enabled))
 		return -EINVAL;
 

-- 
Jens Axboe
