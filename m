From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: kernel 2.6.26.3 qla2xxx oopsing on Fire 280R
Date: Mon, 8 Sep 2008 19:01:02 -0700
Message-ID: <20080909020102.GE25591@plap4-2.qlogic.org>
References: <20080904093929.GA29006@orion.carnet.hr> <20080908211331.GC22598@plap4-2.qlogic.org> <20080909015321.GA14147@orion.carnet.hr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:26869 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbYIICBE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Sep 2008 22:01:04 -0400
Content-Disposition: inline
In-Reply-To: <20080909015321.GA14147@orion.carnet.hr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Josip Rodin <joy@entuzijast.net>
Cc: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 09 Sep 2008, Josip Rodin wrote:

> On Mon, Sep 08, 2008 at 02:13:31PM -0700, Andrew Vasquez wrote:
> > Since we have know good and bad points, could you possibly git-bisect this
> > to help troubleshoot?  Also, are you seeing similar problems with Linus'
> > latest tree?
> 
> OK, I've bisected it on the Linus tree (all these near-full recompiles take
> time...) and this is the result: 
> 
> % git bisect good
> bed475c4cde5d12f537f445bdd0a5a3bb5684481 is first bad commit
> commit bed475c4cde5d12f537f445bdd0a5a3bb5684481
> Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Date:   Wed Aug 13 21:36:58 2008 -0700
> 
>     [SCSI] qla2xxx: Don't leak SG-DMA mappings while aborting commands.
>     
>     Original code inadvertently cleared an SRB's 'flags' while
>     aborting; causing a follow-on scsi_dma_unmap() to be potentially
>     missed.
>     
>     Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
>     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> :040000 040000 51f314385c1a5fae8af021a73c65904d9777d684 d4c20c01bc7c5bce15f81b90fc42621aa592b295 M      drivers
> 
> % git bisect log
> git-bisect start 'drivers/scsi/qla2xxx'
> # good: [20b8df8e5501bac243e64c0c8c52907735a0041b] Linux 2.6.25
> git-bisect good 20b8df8e5501bac243e64c0c8c52907735a0041b
> # bad: [7686ad5606f08d9dfb33a2087a36c8366366015b] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
> git-bisect bad 7686ad5606f08d9dfb33a2087a36c8366366015b
> # good: [6c2f527cb84cbd7d2d8a668c979e70bf78980ccc] [SCSI] qla2xxx: Convert vport_sem to a mutex
> git-bisect good 6c2f527cb84cbd7d2d8a668c979e70bf78980ccc
> # good: [da57bf8f25faf97308d9f4d0b87e8b69317a2fdf] [SCSI] qla2xxx: Correct vport management of MBA_PORT_UPDATE.
> git-bisect good da57bf8f25faf97308d9f4d0b87e8b69317a2fdf
> # good: [bf6583b5831d3195c45f98ec3016499389cbe18f] [SCSI] qla2xxx: suppress uninitialized-var warning
> git-bisect good bf6583b5831d3195c45f98ec3016499389cbe18f
> # bad: [bed475c4cde5d12f537f445bdd0a5a3bb5684481] [SCSI] qla2xxx: Don't leak SG-DMA mappings while aborting commands.
> git-bisect bad bed475c4cde5d12f537f445bdd0a5a3bb5684481
> # good: [00eabe7c4478f38b42d632763c4878ced5a1f25c] [SCSI] qla2xxx: fix msleep compile error
> git-bisect good 00eabe7c4478f38b42d632763c4878ced5a1f25c
> # good: [a7a28504bfa61dc6caa495f55c52623d10b42b32] [SCSI] qla2xxx: Correct vport-state management issues during ISP-ABORT.
> git-bisect good a7a28504bfa61dc6caa495f55c52623d10b42b32
> 
> Let me know if you still want me to try that other patch...

Yes, please do try the patch.  Could you also enable error-logging via
the ql2xextended_error_logging module parameter:

	# insmod qla2xxx.ko ql2xextended_error_logging=1

And send the kernel messages...  Thanks, AV
