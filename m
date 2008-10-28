From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCHSET #upstream] libata: separate out SFF and BMDMA
Date: Tue, 28 Oct 2008 00:20:39 -0400
Message-ID: <49069317.3000600@garzik.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:38718 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbYJ1EU7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2008 00:20:59 -0400
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
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
> 
>  drivers/ata/Kconfig                 |  360 +++----
>  drivers/ata/Makefile                |   47 
>  drivers/ata/ata_piix.c              |    4 
>  drivers/ata/libata-core.c           |  172 ---
>  drivers/ata/libata-eh.c             |   11 
>  drivers/ata/libata-scsi.c           |    3 
>  drivers/ata/libata-sff.c            | 1757 ++++++++++++++++++++----------------
>  drivers/ata/libata.h                |   37 
>  drivers/ata/pata_acpi.c             |   10 
>  drivers/ata/pata_ali.c              |    7 
>  drivers/ata/pata_amd.c              |    2 
>  drivers/ata/pata_artop.c            |    2 
>  drivers/ata/pata_atiixp.c           |    4 
>  drivers/ata/pata_bf54x.c            |   20 
>  drivers/ata/pata_cmd640.c           |   10 
>  drivers/ata/pata_cmd64x.c           |    2 
>  drivers/ata/pata_cs5520.c           |    4 
>  drivers/ata/pata_cs5530.c           |    6 
>  drivers/ata/pata_cs5535.c           |    2 
>  drivers/ata/pata_cs5536.c           |    2 
>  drivers/ata/pata_cypress.c          |    2 
>  drivers/ata/pata_efar.c             |    2 
>  drivers/ata/pata_hpt366.c           |    4 
>  drivers/ata/pata_hpt37x.c           |    6 
>  drivers/ata/pata_hpt3x2n.c          |    4 
>  drivers/ata/pata_hpt3x3.c           |    2 
>  drivers/ata/pata_icside.c           |    7 
>  drivers/ata/pata_it8213.c           |    2 
>  drivers/ata/pata_it821x.c           |    8 
>  drivers/ata/pata_jmicron.c          |    2 
>  drivers/ata/pata_marvell.c          |    2 
>  drivers/ata/pata_mpc52xx.c          |    1 
>  drivers/ata/pata_netcell.c          |    2 
>  drivers/ata/pata_ninja32.c          |    2 
>  drivers/ata/pata_ns87415.c          |    4 
>  drivers/ata/pata_oldpiix.c          |    4 
>  drivers/ata/pata_optidma.c          |    2 
>  drivers/ata/pata_pdc2027x.c         |    6 
>  drivers/ata/pata_pdc202xx_old.c     |    4 
>  drivers/ata/pata_platform.c         |    1 
>  drivers/ata/pata_radisys.c          |    4 
>  drivers/ata/pata_sc1200.c           |    6 
>  drivers/ata/pata_scc.c              |   15 
>  drivers/ata/pata_sch.c              |   12 
>  drivers/ata/pata_serverworks.c      |    8 
>  drivers/ata/pata_sil680.c           |    4 
>  drivers/ata/pata_sis.c              |    2 
>  drivers/ata/pata_sl82c105.c         |    2 
>  drivers/ata/pata_triflex.c          |    2 
>  drivers/ata/pata_via.c              |    2 
>  drivers/ata/pdc_adma.c              |   74 -
>  drivers/ata/sata_inic162x.c         |   25 
>  drivers/ata/sata_mv.c               |   15 
>  drivers/ata/sata_nv.c               |  264 ++---
>  drivers/ata/sata_promise.c          |   30 
>  drivers/ata/sata_qstor.c            |  102 --
>  drivers/ata/sata_sil.c              |    7 
>  drivers/ata/sata_sil24.c            |    9 
>  drivers/ata/sata_sis.c              |    4 
>  drivers/ata/sata_svw.c              |    4 
>  drivers/ata/sata_sx4.c              |    9 
>  drivers/ata/sata_uli.c              |    6 
>  drivers/ata/sata_via.c              |    6 
>  drivers/ata/sata_vsc.c              |   12 
>  drivers/scsi/ipr.c                  |    7 
>  drivers/scsi/libsas/sas_scsi_host.c |    2 
>  include/linux/ata.h                 |    2 
>  include/linux/libata.h              |   91 +
>  68 files changed, 1653 insertions(+), 1602 deletions(-)

ACK patchset


