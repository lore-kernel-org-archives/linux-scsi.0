From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: 2.5.20-dj2 : "Duplicate initializer" in drivers/scsi/aic7xxx/aic7xxx_linux.c
Date: Tue, 4 Jun 2002 17:30:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020604173030.A18317@eng2.beaverton.ibm.com>
References: <3CFD25B7.2090108@fuse.net> <20020604225201.X4751@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020604225201.X4751@suse.de>; from davej@suse.de on Tue, Jun 04, 2002 at 10:52:01PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@suse.de>, Nathan <wfilardo@fuse.net>, linux-kernel@vger.kernel.org
Cc: gibbs@scsiguy.com, linux-scsi@vger.kernel.org

On Tue, Jun 04, 2002 at 10:52:01PM +0200, Dave Jones wrote:
> On Tue, Jun 04, 2002 at 04:40:23PM -0400, Nathan wrote:
>  > gcc -D__KERNEL__ -I/home/wes/src/kernel/linux-2.5.20/include -Wall 
>  > -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common 
>  > -fomit-frame-pointer -pipe -mpreferred-stack-boundary=2 -march=i686 
>  > -malign-functions=4     -DKBUILD_BASENAME=aic7xxx_linux  -c -o 
>  > aic7xxx_linux.o aic7xxx_linux.c
>  > aic7xxx_linux.c:2829: unknown field `abort' specified in initializer
>  > aic7xxx_linux.c:2829: unknown field `reset' specified in initializer
>  > 
>  > Erhm, what's that mean? ^_^  And more importantly, how does one fix that?
> 
> It means the scsi driver has no error handling. Either a, add
> appropriate error handling routines, or b, enable the option in
> the scsi menu labelled "Use SCSI drivers with broken error handling [DANGEROUS]"
> 
> This is the fallout of a patch from Christoph Hellwig to make it more
> obvious which drivers are still in need of attention.  This patch is
> missing from Linus' tree, so things compile fine there. As there's been
> little to no progress at fixing these, I'll push the same patch to Linus
> in the next round, so things will break there too.
> 
>     Dave.

The aic driver already uses the new error handler, it just references the
removed fields when initializing them to NULL.

-- Patrick Mansfield
