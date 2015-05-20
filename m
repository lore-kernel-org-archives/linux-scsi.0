From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scsi: debug: fix type mismatch warning for
 sg_pcopy_from_buffer
Date: Wed, 20 May 2015 12:53:29 -0700
Message-ID: <20150520125329.d63f66765a552efa69a45038@linux-foundation.org>
References: <6309932.EjHf7uUo1X@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6309932.EjHf7uUo1X@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Gordon <david.s.gordon@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jbottomley@odin.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 19 May 2015 23:22:39 +0200 Arnd Bergmann <arnd@arndb.de> wrote:

> The recent change to mark the input argument of sg_pcopy_from_buffer
> had the unfortunate side-effect to cause a new warning in the
> scsi_debug code:
> 
> drivers/scsi/scsi_debug.c: In function 'do_device_access':
> drivers/scsi/scsi_debug.c:2376:8: warning: assignment from incompatible pointer type [-Wincompatible-pointer-types]
>    func = sg_pcopy_from_buffer;
> 
> This patch attempts to avoid that warning without adding
> evil type casts, but unfortunately makes the do_device_access
> function a lot uglier in the process.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 5250326459 ("lib/scatterlist: mark input buffer parameters as 'const'")
> ---
> 
> I can't decide if this is actually a good idea, or if we should rather drop
> the sg_pcopy_from_buffer() patch. Maybe someone else sees a better solution.

Could make do_device_access() call sg_copy_buffer() directly.

But yes, dropping the sg_pcopy_from/to_buffer changes is reasonable. 
sg_copy_buffer() is bidirectional and that won't be changing, so
putting constified wrapeprs around it is kinda fake.
