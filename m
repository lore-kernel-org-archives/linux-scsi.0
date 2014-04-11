From: Sam Creasey <sammy@sammy.net>
Subject: Re: [PATCH v2 00/12] scsi/NCR5380: fix debugging macros and #include structure
Date: Fri, 11 Apr 2014 10:39:01 -0400
Message-ID: <20140411143900.GG21346@anhedonia>
References: <20140319123516.542623278@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140319123516.542623278@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Acked-by: Sam Creasey <sammy@sammy.net>

On Wed, Mar 19, 2014 at 11:35:16PM +1100, Finn Thain wrote:
> 
> This patch series addresses several issues with NCR5380 drivers:
> 
> 1. The complex network of #include directives.
> 
> 2. Three inconsistent implementations of the core driver all attempting
>    to share the same macro definitions in NCR5380.h.
> 
> 3. Broken debugging code.
> 
> In the past these issues have led to compiler warnings and ugly hacks to
> fix build failures.
> 
> This patch series fixes the debugging code by reducing the divergence
> between the various core driver implementations.
> 
> The final two patches in the series further reduce divergence by refactoring
> sun3_scsi.c and sun3_scsi_vme.c so that they follow the same structure as
> the other NCR5380 drivers.
> 
> By the end of this patch series over 800 net lines of code have been
> removed. This is mostly duplicated code that's easily eliminated once the
> debugging code is made consistent (and some dead code is removed).
> 
> Better uniformity and less duplication should assist future work such as
> modernization and trivial clean-up.
> 
> To make code review easier I've tried to keep these patches succinct and
> free of extraneous changes. Though I did run checkpatch.pl, I've ignored
> whitespace issues in existing code. I will send separate patches for
> whitespace clean-up of NCR5380 drivers.
> 
> All NCR5380 drivers have been compile-tested with this patch series:
>   arm/cumana_1.c
>   arm/oak.c
>   atari_scsi.c
>   dmx3191d.c
>   dtc.c
>   g_NCR5380.c
>   g_NCR5380_mmio.c
>   mac_scsi.c
>   pas16.c
>   sun3_scsi.c
>   sun3_scsi_vme.c
>   t128.c
> 
> I've successfully regression tested this patch series using mac_scsi on a 
> PowerBook 180. The debugging macros are now usable again.
