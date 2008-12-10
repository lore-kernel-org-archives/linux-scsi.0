From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][RFC 6/23]: SCST SGV cache
Date: Wed, 10 Dec 2008 21:39:10 +0300
Message-ID: <49400CCE.9000105@vlnb.net>
References: <494009D7.4020602@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:50293 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbYLJSkW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 13:40:22 -0500
In-Reply-To: <494009D7.4020602@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

This patch contains SCST SGV cache. SGV cache is a memory management 
subsystem in SCST. One can call it a "memory pool", but Linux kernel 
already have mempool interface, which serves different purposes. SGV 
cache provides to SCST core, target drivers and backend dev handlers 
facilities to allocate and build SG vectors for data buffers. The main 
feature of it is that it doesn't free to the system each vector, which 
is not used anymore, but keeps it for a while to let it be reused by the 
next consecutive command to reduce command processing latency and, 
hence, improve performance. The freed SG vectors are kept by SGV cache 
either for some predefined time, or until the system needs more memory 
and asks to free some using the set_shrinker() interface. Also the SGV 
cache allows to:

  - Cluster pages together to minimize number of SG entries in the 
vector and improve the performance of handling the SG vector.

  - Set custom page allocator function. For instance, the scst_user 
device handler uses this facility to eliminate unneeded 
mapping/unmapping of user space pages and avoid unneeded IOCTL calls for 
buffers allocations. In fileio_tgt application it leads to ~30% less CPU 
load and considerable performance increase.

  - Prevent each initiator or all initiators altogether to allocate too 
much memory and effectively DoS the target. Consider 10 initiators, 
which can have access to 10 devices each. Any of then can queue up to 64 
commands, each can transfer up to 1MB of data. So, all of them in a peak 
can allocate up to 10*10*64 = ~6.5GB of memory for data buffers. This 
amount must be limited somehow and SGV cache performs this function. 
This feature was implemented after people reported about such DoS'es, 
when there are many fast initiators and a slow target.

 From implementation POV SGV cache is a simple extension of kmem cache. 
Each SGV cache, called pool, (struct sgv_pool) has SGV_POOL_ELEMENTS (11 
currently) of kmem caches. Each of those kmem caches keeps SGV pool 
objects (struct sgv_pool_obj) corresponding to SG vectors with size of 
order X pages. For instance, request to allocate 4 pages will be served 
from kmem cache[2] (order 2). If then request to allocate 11KB comes, 
the same SG vector with 4 pages will be reused (see below).

When a request to allocate new SG vector comes, sgv_pool_alloc() via 
sgv_pool_cached_get() checks if there is already cached vector with that 
order. If yes, then that vector will be reused and its length, if 
necessary, will be modified to match the requested size. In the above 
example request for 11KB, 4 pages vector will be reused and modified 
using trans_tbl to contain 3 pages and the last entry will be modified 
to contain the requested length - 2*PAGE_SIZE. If there is no cached 
object, then a new sgv_pool_obj will be allocated from the corresponding 
kmem cache, chosen by order of number of requested pages. Then that 
vector will be filled by pages and returned.

Freed sgv_pool_obj objects are freed to the system either by apit_pool 
work or in sgv_pool_cached_shrinker() called by system, when it's asking 
for memory.

P.S. Solaris COMSTAR also has similar facility.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  drivers/scst/scst_mem.c | 1336 ++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/scst/scst_mem.h |  149 +++++
  include/scst/scst_sgv.h |   60 ++
  3 files changed, 1545 insertions(+)

The patch is too big to be submitted inline. You can find it in 
http://scst.sourceforge.net/patches/scst_sgv.diff



