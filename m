From: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCHSET #upstream] libata: separate out SFF and BMDMA
Date: Fri, 07 May 2010 17:59:41 +0400
Message-ID: <4BE41CCD.8000005@ru.mvista.com>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:53378 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab0EGOAc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 May 2010 10:00:32 -0400
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Hello.

Tejun Heo wrote:

> This is the first take of separate-out-SFF-and-BMDMA patchset.
>
> Historically, ATA meant SFF (or TASKFILE interface) plus BMDMA and
> that holds true for many modern SATA controllers.  This was reflected
> in libata implementation and libata core layer and SFF/BMDMA support
> used to be all tangled in one piece.
>
> For SFF/BMDMA drivers, this assumption is fine but for drivers which
> have native interfaces (e.g. ahci, sata_sil24), this meant that those
> drivers had to emulate SFF/BMDMA to ceratin not-so-well defined level
> libata core layer expects.  A lot of this vague dependency on
> SFF/BMDMA was removed during recent SFF/BMDMA separation but there
> still are SFF/BMDMA specific assumptions in libata core layer.
>
> Another issue which surpassed with the addition of all the legacy,
> platform and somewhat peculiar PATA drivers is that now there are
> enough drivers which use SFF interface but use its own DMA interface
> or don't support DMA at all.  This, in similar fashion, led those
> drivers to fake certain level of BMDMA functionality to please the
> libata SFF/BMDMA layer.  This led to the following interesting
> solutions in low level drivers.
>
> 1. For BMDMA drivers which don't use traditional BMDMA register,
>    ata_bmdma_mode_filter() incorrectly inhibits DMA modes.  Those
>    drivers either have to inherit from ata_sff_port_ops or clear
>    ->mode_filter explicitly.
>
> 2. non-BMDMA drivers call into BMDMA PRD table allocation.  It doesn't
>    actually allocate PRD table if bmdma_addr is not initialized but is
>    still confusing.
>
> 3. For BMDMA drivers which don't use traditional BMDMA register, some
>    methods might not be invoked as expected (e.g. bmdma_stop from
>    ata_sff_post_internal_cmd()).
>
> 4. SFF drivers w/ custom DMA interface implement noop BMDMA ops
>    worrying libata core might call into one of them.
>
> This patchset further separates SFF/BMDMA support from the rest of the
> libata and separate out BMDMA from SFF.  This patchset contains the
> following 22 patches.
>
>  0001-pata_sch-use-ata_pci_sff_init_one.patch
>  0002-sata_inic162x-inic162x-is-not-dependent-on-CONFIG_A.patch
>  0003-sata_mv-remove-unnecessary-initialization.patch
>  0004-libata-sff-clear-IRQ-from-ata_sff_error_handler-o.patch
>  0005-libata-sff-kill-unused-prototype-and-make-ata_dev_s.patch
>  0006-libata-kill-ATA_FLAG_DISABLED.patch
>  0007-sata_inic162x-kill-PORT_PRD_ADDR-initialization.patch
>  0008-libata-sff-reorder-SFF-BMDMA-functions.patch
>  0009-pata_cmd640-bf54x-icside-fix-inheritance.patch
>  0010-libata-sff-clean-up-BMDMA-initialization.patch
>  0011-libata-sff-introduce-ata_sff_init-exit-and-ata_sf.patch
>  0012-libata-sff-ap-last_-ctl-are-SFF-specific.patch
>  0013-libata-sff-port_task-is-SFF-specific.patch
>  0014-libata-sff-separate-out-BMDMA-EHs.patch
>  0015-libata-sff-ata_sff_-dumb_-qc_prep-are-BMDMA-specifi.patch
>  0016-libata-sff-prd-is-BMDMA-specific.patch
>  0017-libata-sff-separate-out-BMDMA-qc_issue.patch
>  0018-libata-sff-ata_sff_irq_clear-is-BMDMA-specific.patch
>  0019-libata-sff-separate-out-BMDMA-irq-handler.patch
>  0020-libata-sff-separate-out-BMDMA-init.patch
>  0021-sata_qstor-kill-dummy-BMDMA-ops.patch
>  0022-libata-sff-make-BMDMA-optional.patch
>
> 0001-0010 make things aligned for the future changes.
>
>  0004 changes the default SFF error handler behavior such that
>  unnecessary register accesses are removed.  I'm fairly sure this
>  change is safe (tested on various SFF/BMDMA controllers) but we'll
>  need to look out for problem reports.
>
>  0006 kills ATA_FLAG_DISABLED (finally).  This patch touches SCSI SAS
>  drivers.
>
>  0010 cleans up BMDMA initialization and bmdma_addr condition checks.
>
> 0011-0013 further separate out SFF assumptions from libata core layer.
>
> 0014-0021 separate out BMDMA from SFF.
>
> 0022 makes BMDMA optional and reorganizes Kconfig options according to
> the groups of drivers they belong to.
>
> This patchset is on top of
>
>   linus#master (2515ddc6db8eb49a79f0fe5e67ff09ac7c81eab4)
> + [1] libata-sff-fix-ata_sff_post_internal_cmd
> + [2] libata-initialize-port_task-when-!CONFIG_ATA_SFF
> + [3] libata-eh-fix-slave-link-EH-action-mask-handling
> + [4] libata-transfer-EHI-control-flags-to-slave-ehc_i
>
> and makes the followings changes.

   Tejun, what was the fate of this patchset? Looks like it ended up 
ignored...

MBR, Sergei

