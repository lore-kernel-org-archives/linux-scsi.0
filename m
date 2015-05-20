From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: debug: fix type mismatch warning for sg_pcopy_from_buffer
Date: Wed, 20 May 2015 22:31:45 +0200
Message-ID: <2386515.9NuRN4zp72@wuerfel>
References: <6309932.EjHf7uUo1X@wuerfel> <20150520125329.d63f66765a552efa69a45038@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150520125329.d63f66765a552efa69a45038@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Gordon <david.s.gordon@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jbottomley@odin.com
List-Id: linux-scsi@vger.kernel.org

On Wednesday 20 May 2015 12:53:29 Andrew Morton wrote:
> On Tue, 19 May 2015 23:22:39 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
> > 
> > I can't decide if this is actually a good idea, or if we should rather drop
> > the sg_pcopy_from_buffer() patch. Maybe someone else sees a better solution.
> 
> Could make do_device_access() call sg_copy_buffer() directly.
> 
> But yes, dropping the sg_pcopy_from/to_buffer changes is reasonable. 
> sg_copy_buffer() is bidirectional and that won't be changing, so
> putting constified wrapeprs around it is kinda fake.

Ok. The part I only saw now is that do_device_access() is the only user
of sg_pcopy_from_buffer(), so if that passes a non-const argument,
there is dropping the patch will be teh best solution.

	Arnd
