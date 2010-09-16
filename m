From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/8] Drop host_lock around LLD SHT->queuecommand()
	caller
Date: Thu, 16 Sep 2010 15:39:23 -0700
Message-ID: <1284676763.13344.108.camel@haakon2.linux-iscsi.org>
References: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.104]:48469 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755129Ab0IPWnc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2010 18:43:32 -0400
In-Reply-To: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>

On Thu, 2010-09-16 at 15:35 -0700, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Greetings all,
> 
> This series contains the first round of a whole-sale conversion for droping
> struct Scsi_Host->host_lock around struct Scsi_Host->queuecommand() within
> scsi_dispatch_cmd().  So with this first patch the only part of scsi_dispatch_cmd()
> that is protected by host_lock is scsi_cmd_get_serial)_.
> 
> The patches #2 -> #8 converts libiscsi, libsas, lpfc, qla4xxx, qla2xxx,
> TCM_Loop, and libfc code to drop their own SHT->queuecommand() internal
> host_lock unlock() + lock() optimization that certain high performance libs
> and LLDs have adopted over the years.  The changes involved here are really
> quite straight forward, but please note that none of this code has been tested
> with actual hardware yet, and is intended for generating comments for the relivent
> SCSI LLD driver maintainers and other interested folks.
> 
> There are probably still be more LLDs which use this optimization, so please
> let me know if there is another piece of SHT->queuecommand() caller code that
> does this legacy optimization and needs to be updated.  I will be sure to
> CC the right driver maintainers and CC linux-scsi as I come across any more
> conversions.
> 
> Many thanks to Vasu Dev and Tim Chen for their work in this area!!

Also just FYI, I have pushed these changes into a branch here:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=shortlog;h=refs/heads/drop-host_lock

Note that this tree is currently at .36-rc3, but will be jumping to -rc4
shortly.

Thanks!

--nab

> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> 
> Nicholas Bellinger (8):
>   scsi: Drop struct Scsi_Host->host_lock around SHT->queuecommand()
>   libiscsi: Remove host_lock unlock() + lock() from
>     iscsi_queuecommand()
>   libsas: Remove host_lock unlock() + lock() from sas_queuecommand()
>   lpfc: Remove host_lock unlock() + lock() from lpfc_queuecommand()
>   qla4xxx: Remove host_lock unlock() + lock() from
>     qla4xxx_queuecommand()
>   qla2xxx: Remove host_lock unlock() + lock() from
>     qla2xxx_queuecommand()
>   tcm_loop: Remove host_lock unlock() + lock() from
>     tcm_loop_queuecommand()
>   libfc: Remove host_lock unlock() + lock() from fc_queuecommand()
> 
>  drivers/scsi/libfc/fc_fcp.c                    |    5 +----
>  drivers/scsi/libiscsi.c                        |    4 ----
>  drivers/scsi/libsas/sas_scsi_host.c            |    5 -----
>  drivers/scsi/lpfc/lpfc_scsi.c                  |    2 --
>  drivers/scsi/qla2xxx/qla_os.c                  |    7 ++-----
>  drivers/scsi/qla4xxx/ql4_os.c                  |    8 +-------
>  drivers/scsi/scsi.c                            |    3 ++-
>  drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |    7 -------
>  8 files changed, 6 insertions(+), 35 deletions(-)
> 

