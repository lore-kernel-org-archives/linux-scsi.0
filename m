From: Dave Gordon <david.s.gordon@intel.com>
Subject: Re: [PATCH] scsi: debug: fix type mismatch warning for sg_pcopy_from_buffer
Date: Thu, 21 May 2015 12:09:58 +0100
Message-ID: <555DBD06.7060601@intel.com>
References: <6309932.EjHf7uUo1X@wuerfel> <20150520125329.d63f66765a552efa69a45038@linux-foundation.org> <2386515.9NuRN4zp72@wuerfel>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020303070507080508090300"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2386515.9NuRN4zp72@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jbottomley@odin.com
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020303070507080508090300
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 20/05/15 21:31, Arnd Bergmann wrote:
> On Wednesday 20 May 2015 12:53:29 Andrew Morton wrote:
>> On Tue, 19 May 2015 23:22:39 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
>>>
>>> I can't decide if this is actually a good idea, or if we should rather drop
>>> the sg_pcopy_from_buffer() patch. Maybe someone else sees a better solution.
>>
>> Could make do_device_access() call sg_copy_buffer() directly.
>>
>> But yes, dropping the sg_pcopy_from/to_buffer changes is reasonable. 
>> sg_copy_buffer() is bidirectional and that won't be changing, so
>> putting constified wrapeprs around it is kinda fake.
> 
> Ok. The part I only saw now is that do_device_access() is the only user
> of sg_pcopy_from_buffer(), so if that passes a non-const argument,
> there is dropping the patch will be teh best solution.
> 
> 	Arnd

do_device_access() may the only user of sg_pcopy_from_buffer() in the
-mm tree at the moment, but the const-patch was created because we were
using the sg_pcopy_{to,from}_buffer functions in new code in the i915
driver (published to the intel-gfx mailing list, but not yet folded into
the upstream versions). So quite soon it won't be the only user :)

The various sg_[p]copy_* wrappers all just supply trailing parameters
for the convenience of those who don't need (and don't want to deal
with) the full capabilities of the underlying sg_copy_buffer(). In
particular, we want the wrappers for the benefit of users that *don't*
use this flag-specifies-direction style (which I think is actually quite
rare and not really conducive to robust checking). The
separate-source-and-destination style seems much more common (cf. memcpy()).
And scsi_debug.c itself has functions fill_from_dev_buffer() and
fetch_to_dev_buffer() that call the separate sg_copy_{to,from}_buffer()
wrappers.

But since do_device_access() has the same parameter style as
sg_copy_buffer() (i.e. pointer parameters that may be either source or
destination, plus a flag to specify direction of transfer, as opposed to
one (const *) parameter for the input and a separate one for the
(non-const) destination), I think it quite reasonable that
do_device_access() should call sg_copy_buffer() directly rather than
going through one or other wrapper. In fact it simplifies the code
further; we can lose four lines and get rid of the function pointer
entirely, just by passing 'do_write' down to sg_copy_buffer(). See
attached patch :)

.Dave.


--------------020303070507080508090300
Content-Type: text/x-patch;
 name="0001-scsi-resolve-sg-buffer-const-ness-issue.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-scsi-resolve-sg-buffer-const-ness-issue.patch"

>From b304c5a99ea260eac1cf98ced5f3c79c793ad4fd Mon Sep 17 00:00:00 2001
From: Dave Gordon <david.s.gordon@intel.com>
Date: Thu, 21 May 2015 12:06:27 +0100
Subject: [PATCH] scsi: resolve sg buffer const-ness issue

do_device_access() takes a separate parameter to indicate the direction
of data transfer, which it used to use to select the appropriate function
out of sg_pcopy_{to,from}_buffer(). However these two functions now have
different const-ness in their signatures, leading to compiler warnings.

So this patch makes it bypass these wrappers and call the underlying
function sg_copy_buffer() directly; this has the same calling style as
do_device_access() i.e. a separate direction-of-transfer parameter and
no pointers-to-const, so skipping the wrappers not only eliminates the
warning, it also make the code simpler :)

Signed-off-by: Dave Gordon <david.s.gordon@intel.com>
---
 drivers/scsi/scsi_debug.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1f8e2dc..30268bb 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2363,17 +2363,13 @@ do_device_access(struct scsi_cmnd *scmd, u64 lba, u32 num, bool do_write)
 	u64 block, rest = 0;
 	struct scsi_data_buffer *sdb;
 	enum dma_data_direction dir;
-	size_t (*func)(struct scatterlist *, unsigned int, void *, size_t,
-		       off_t);
 
 	if (do_write) {
 		sdb = scsi_out(scmd);
 		dir = DMA_TO_DEVICE;
-		func = sg_pcopy_to_buffer;
 	} else {
 		sdb = scsi_in(scmd);
 		dir = DMA_FROM_DEVICE;
-		func = sg_pcopy_from_buffer;
 	}
 
 	if (!sdb->length)
@@ -2385,16 +2381,16 @@ do_device_access(struct scsi_cmnd *scmd, u64 lba, u32 num, bool do_write)
 	if (block + num > sdebug_store_sectors)
 		rest = block + num - sdebug_store_sectors;
 
-	ret = func(sdb->table.sgl, sdb->table.nents,
+	ret = sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
 		   fake_storep + (block * scsi_debug_sector_size),
-		   (num - rest) * scsi_debug_sector_size, 0);
+		   (num - rest) * scsi_debug_sector_size, 0, do_write);
 	if (ret != (num - rest) * scsi_debug_sector_size)
 		return ret;
 
 	if (rest) {
-		ret += func(sdb->table.sgl, sdb->table.nents,
+		ret += sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
 			    fake_storep, rest * scsi_debug_sector_size,
-			    (num - rest) * scsi_debug_sector_size);
+			    (num - rest) * scsi_debug_sector_size, do_write);
 	}
 
 	return ret;
-- 
1.7.9.5


--------------020303070507080508090300--
