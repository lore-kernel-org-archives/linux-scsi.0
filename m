From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: CONFIG_SCSI_G_NCR5380_MEM dead?
Date: Wed, 21 Jul 2010 08:19:43 -0700
Message-ID: <1279725583.20250.29.camel@mulgrave.site>
References: <86pqyhhtut.fsf@peer.zerties.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <86pqyhhtut.fsf@peer.zerties.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, vamos-dev@i4.informatik.uni-erlangen.de
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-07-21 at 15:01 +0200, Christian Dietrich wrote:
> Hi all!
>        
>         As part of the VAMOS[0] research project at the University of
> Erlangen we are looking at multiple integrity errors in linux'
> configuration system.
> 
>         I've been running a check on the drivers/scsi sourcetree for
> config Items not defined in Kconfig and found such a case. Sourcecode
> blocks depending on these Items are not reachable from a vanilla
> kernel -- dead code. I've seen such dead blocks made on purpose
> e.g. while integrating new features into the kernel but generally
> they're just useless.
> 
> I encountered, that the CONFIG_SCSI_G_NCR5380_MEM symbol in
> drivers/scsi/g_NCR5380.c isn't defined anywhere. So this codeblocks
> seems to be unreachable. But there is a define in g_NCR5380_mmio.c for
> SCSI_G_NCR5380_MEM with an include of g_NCR5380.c. So i think this is a
> typo-bug and it should be a CONFIG_ define. The code wasn't changed since
> linux is in git, so probably no one has used the mmio module, cause
> there can't be a difference to the normal pio module. If you think this
> ifdefs should be removed, i can send a patch.

Actually, I'd rather not remove any code like this.  We have no
documentation for the board, so that code represents the only knowledge
we have about how to program it. Although, in theory, git will remember,
in practice no-one will know where to look for it if they want to try
resurrecting the MMIO code.

James
