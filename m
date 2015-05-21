From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: debug: fix type mismatch warning for sg_pcopy_from_buffer
Date: Thu, 21 May 2015 13:28:55 +0200
Message-ID: <10573000.xg2bp6EQuX@wuerfel>
References: <6309932.EjHf7uUo1X@wuerfel> <2386515.9NuRN4zp72@wuerfel> <555DBD06.7060601@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <555DBD06.7060601@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Gordon <david.s.gordon@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jbottomley@odin.com
List-Id: linux-scsi@vger.kernel.org

On Thursday 21 May 2015 12:09:58 Dave Gordon wrote:
> From b304c5a99ea260eac1cf98ced5f3c79c793ad4fd Mon Sep 17 00:00:00 2001
> From: Dave Gordon <david.s.gordon@intel.com>
> Date: Thu, 21 May 2015 12:06:27 +0100
> Subject: [PATCH] scsi: resolve sg buffer const-ness issue
> 
> do_device_access() takes a separate parameter to indicate the direction
> of data transfer, which it used to use to select the appropriate function
> out of sg_pcopy_{to,from}_buffer(). However these two functions now have
> different const-ness in their signatures, leading to compiler warnings.
> 
> So this patch makes it bypass these wrappers and call the underlying
> function sg_copy_buffer() directly; this has the same calling style as
> do_device_access() i.e. a separate direction-of-transfer parameter and
> no pointers-to-const, so skipping the wrappers not only eliminates the
> warning, it also make the code simpler 
> 
> Signed-off-by: Dave Gordon <david.s.gordon@intel.com>
> ---

Acked-by: Arnd Bergmann <arnd@arndb.de>
