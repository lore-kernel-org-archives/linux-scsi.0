From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Full hostlock pushdown available
Date: Sun, 31 Oct 2010 14:22:23 +0200
Message-ID: <4CCD5F7F.8020808@panasas.com>
References: <20101028150508.GA2385@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:60482 "HELO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755425Ab0JaMW1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Oct 2010 08:22:27 -0400
In-Reply-To: <20101028150508.GA2385@basil.fritz.box>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: James.Bottomley@suse.de, nab@linux-iscsi.org, linux-scsi@vger.kernel.org

On 10/28/2010 05:05 PM, Andi Kleen wrote:
> 
> Here's the promised attempt to do a full host_lock pushdown. This
> was done using coccinelle and some manual adjustments.
> 

Hi Andi.
Could you please post the final coccinelle script you used.
I've never used coccinelle, it sounds like an interesting tool.
RTFM as we speak.

Thanks
Boaz

> This is just a dumb pushdown of host lock and serial number into
> the driver, no attempt to remove any locks yet.
> 
> Currently lightly tested, but compiles with allmodconfig on 32bit x86.
> 
> I made no attempt to automatically add maintainers to Cc.
> 
> I'm not posting the patches because they are numerous and boring,
> but it's available in git.
> 
> This will likely bitrot quickly so if it's decided to do it this
> way I would prefer if this was merged quickly.
> 
> Issues found:
> - I found a clear deadlock in aha1740, not sure if that driver ever
> worked since host_lock was introduced. Anyways I attempted to work
> around it. But if it's really that unused it may be better to 
> simply drop it.
> - I'm not sure how to compile cciss_scsi, is it even used?
> 
> -Andi
> 
> The following changes since commit 39764981e772adc832d8a96e6540be346a830ca2:
> 
>   Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6 (2010-10-27 20:54:34 +0200)
> 
> are available in the git repository at:
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc-2.6.git hostlock
> 
> Andi Kleen (87):
>       SCSI: Remove hostlock for queuecommand
>       SCSI: ibmmca: hostlock pushdown
>       SCSI: ipr: hostlock pushdown
>       SCSI: ultrastor: hostlock pushdown
>       SCSI: aha1740: hostlock pushdown
>       SCSI: ia64 simscsi: hostlock pushdown
>       SCSI: sun3_NCR5380: pushdown of hostlock
>       SCSI: staging/hv/storvsc_drv: pushdown of hostlock
>       SCSI: s390/zfcp_scsi: hostlock pushdown
>       SCSI: libiscsi: hostlock pushdown
>       SCSI: libiscsi: remove hostlock drop
>       SCSI: NCR5380: hostlock pushdown
>       SCSI: libsas: hostlock pushdown
>       SCSI: stex: hostlock pushdown
>       SCSI: wd33c93: hostlock pushdown
>       SCSI: aha152x: hostlock pushdown
>       SCSI: microtek: hostlock pushdown
>       SCSI: scsiglue: hostlock pushdown
>       SCSI: uas: hostlock pushdown
>       SCSI: i2o_scsi: hostlock pushdown
>       SCSI: mptspi: hostlock pushdown
>       SCSI: mptsas: hostlock pushdown
>       SCSI: mptfc: hostlock pushdown
>       SCSI: sbp2: hostlock pushdown
>       SCSI: ib_srp: hostlock pushdown
>       SCSI: mesh: hostlock pushdown
>       SCSI: fd_mcs: hostlock pushdown
>       SCSI: fnic_main: hostlock pushdown
>       SCSI: gdth: hostlock pushdown
>       SCSI: ppa: hostlock pushdown
>       SCSI: qlogicpti: hostlock pushdown
>       SCSI: 3w-sas: hostlock pushdown
>       SCSI: 3w-9xxx: hostlock pushdown
>       SCSI: fcoe: hostlock pushdown
>       SCSI: ips: hostlock pushdown
>       SCSI: sym_glue: hostlock pushdown
>       SCSI: ql4_os: hostlock pushdown
>       SCSI: mpt2sas_scsih: hostlock pushdown
>       SCSI: fdomain: hostlock pushdown
>       SCSI: initio: hostlock pushdown
>       SCSI: in2000: hostlock pushdown
>       SCSI: nsp32: hostlock pushdown
>       SCSI: megaraid_sas: hostlock pushdown
>       SCSI: megaraid_mbox: hostlock pushdown
>       SCSI: BusLogic: hostlock pushdown
>       SCSI: dpt_i2o: hostlock pushdown
>       SCSI: 3w-xxxx: hostlock pushdown
>       SCSI: atp870u: hostlock pushdown
>       SCSI: qlogicfas: hostlock pushdown
>       SCSI: qla1280: hostlock pushdown
>       SCSI: dc395x: hostlock pushdown
>       SCSI: linit: hostlock pushdown
>       SCSI: ibmvfc: hostlock pushdown
>       SCSI: ibmvscsi: hostlock pushdown
>       SCSI: lpfc_scsi: hostlock pushdown
>       SCSI: ps3rom: hostlock pushdown
>       SCSI: pmcraid: hostlock pushdown
>       SCSI: eata: hostlock pushdown
>       SCSI: tmscsim: hostlock pushdown
>       SCSI: imm: hostlock pushdown
>       SCSI: wd7000: hostlock pushdown
>       SCSI: sym53c416: hostlock pushdown
>       SCSI: aic7xxx_old: hostlock pushdown
>       SCSI: megaraid: hostlock pushdown
>       SCSI: aha1542: hostlock pushdown
>       SCSI: eata_pio: hostlock pushdown
>       SCSI: esp_scsi: hostlock pushdown
>       SCSI: a100u2w: hostlock pushdown
>       SCSI: hpsa: hostlock pushdown
>       SCSI: NCR53c406a: hostlock pushdown
>       SCSI: mac53c94: hostlock pushdown
>       SCSI: vmw_pvscsi: hostlock pushdown
>       SCSI: 53c700: hostlock pushdown
>       SCSI: u14-34f: hostlock pushdown
>       SCSI: ncr53c8xx: hostlock pushdown
>       SCSI: advansys: hostlock pushdown
>       SCSI: hptiop: hostlock pushdown
>       SCSI: arcmsr_hba: hostlock pushdown
>       SCSI: aic79xx_osm: hostlock pushdown
>       SCSI: aic7xxx_osm: hostlock pushdown
>       SCSI: arm: hostlock pushdown
>       SCSI: qla_os: hostlock pushdown
>       SCSI: nsp_cs: hostlock pushdown
>       SCSI: sym53c500_cs: hostlock pushdown
>       SCSI: bfad_im: hostlock pushdown
>       SCSI: cciss_scsi: hostlock pushdown
>       SCSI: aha1740: Avoid instant deadlock
> 
>  arch/ia64/hp/sim/simscsi.c            |    7 +++++++
>  drivers/block/cciss_scsi.c            |    6 ++++++
>  drivers/firewire/sbp2.c               |    5 +++++
>  drivers/infiniband/ulp/srp/ib_srp.c   |    6 ++++++
>  drivers/message/fusion/mptfc.c        |    6 ++++++
>  drivers/message/fusion/mptsas.c       |    8 +++++++-
>  drivers/message/fusion/mptspi.c       |    5 +++++
>  drivers/message/i2o/i2o_scsi.c        |    5 +++++
>  drivers/s390/scsi/zfcp_scsi.c         |    8 ++++++++
>  drivers/scsi/3w-9xxx.c                |    4 ++++
>  drivers/scsi/3w-sas.c                 |    4 ++++
>  drivers/scsi/3w-xxxx.c                |    4 ++++
>  drivers/scsi/53c700.c                 |    6 ++++++
>  drivers/scsi/BusLogic.c               |    5 +++++
>  drivers/scsi/NCR5380.c                |    6 ++++++
>  drivers/scsi/NCR53c406a.c             |    4 ++++
>  drivers/scsi/a100u2w.c                |    9 ++++++++-
>  drivers/scsi/aacraid/linit.c          |   10 ++++++++--
>  drivers/scsi/advansys.c               |    4 ++++
>  drivers/scsi/aha152x.c                |   10 +++++++++-
>  drivers/scsi/aha1542.c                |   12 ++++++++++--
>  drivers/scsi/aha1740.c                |   11 +++++++++++
>  drivers/scsi/aic7xxx/aic79xx_osm.c    |    4 ++++
>  drivers/scsi/aic7xxx/aic7xxx_osm.c    |    4 ++++
>  drivers/scsi/aic7xxx_old.c            |    5 +++++
>  drivers/scsi/arcmsr/arcmsr_hba.c      |   18 +++++++++++++++---
>  drivers/scsi/arm/acornscsi.c          |    6 ++++++
>  drivers/scsi/arm/fas216.c             |    8 ++++++++
>  drivers/scsi/atp870u.c                |    8 ++++++++
>  drivers/scsi/bfa/bfad_im.c            |   11 ++++++++++-
>  drivers/scsi/dc395x.c                 |    6 ++++++
>  drivers/scsi/dpt_i2o.c                |    9 +++++++++
>  drivers/scsi/eata.c                   |    7 +++++++
>  drivers/scsi/eata_pio.c               |    5 +++++
>  drivers/scsi/esp_scsi.c               |    8 +++++++-
>  drivers/scsi/fd_mcs.c                 |    4 ++++
>  drivers/scsi/fdomain.c                |    4 ++++
>  drivers/scsi/fnic/fnic_scsi.c         |    9 ++++++++-
>  drivers/scsi/gdth.c                   |    4 ++++
>  drivers/scsi/hpsa.c                   |    7 +++++++
>  drivers/scsi/hptiop.c                 |    6 ++++++
>  drivers/scsi/ibmmca.c                 |   12 ++++++++++++
>  drivers/scsi/ibmvscsi/ibmvfc.c        |   12 ++++++++++--
>  drivers/scsi/ibmvscsi/ibmvscsi.c      |    9 ++++++++-
>  drivers/scsi/imm.c                    |    4 ++++
>  drivers/scsi/in2000.c                 |    4 ++++
>  drivers/scsi/initio.c                 |    8 +++++++-
>  drivers/scsi/ipr.c                    |   17 ++++++++++++++---
>  drivers/scsi/ips.c                    |   18 ++++++++++++++++--
>  drivers/scsi/libfc/fc_fcp.c           |    5 +++++
>  drivers/scsi/libiscsi.c               |   10 ++++++----
>  drivers/scsi/libsas/sas_scsi_host.c   |    7 +++++--
>  drivers/scsi/lpfc/lpfc_scsi.c         |    6 ++++++
>  drivers/scsi/mac53c94.c               |    4 ++++
>  drivers/scsi/megaraid.c               |    4 ++++
>  drivers/scsi/megaraid/megaraid_mbox.c |    5 +++++
>  drivers/scsi/megaraid/megaraid_sas.c  |   14 ++++++++++++--
>  drivers/scsi/mesh.c                   |    4 ++++
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c  |   17 +++++++++++++++--
>  drivers/scsi/ncr53c8xx.c              |    4 ++++
>  drivers/scsi/nsp32.c                  |    8 ++++++++
>  drivers/scsi/pcmcia/nsp_cs.c          |    6 ++++++
>  drivers/scsi/pcmcia/sym53c500_cs.c    |    4 ++++
>  drivers/scsi/pmcraid.c                |   11 ++++++++++-
>  drivers/scsi/ppa.c                    |    4 ++++
>  drivers/scsi/ps3rom.c                 |    4 ++++
>  drivers/scsi/qla1280.c                |    4 ++++
>  drivers/scsi/qla2xxx/qla_os.c         |    7 +++++++
>  drivers/scsi/qla4xxx/ql4_os.c         |    7 +++++++
>  drivers/scsi/qlogicfas408.c           |    4 ++++
>  drivers/scsi/qlogicpti.c              |    5 +++++
>  drivers/scsi/scsi.c                   |   15 +++------------
>  drivers/scsi/stex.c                   |   20 ++++++++++++++++++--
>  drivers/scsi/sun3_NCR5380.c           |    8 ++++++++
>  drivers/scsi/sym53c416.c              |    4 ++++
>  drivers/scsi/sym53c8xx_2/sym_glue.c   |   12 ++++++++++--
>  drivers/scsi/tmscsim.c                |    5 +++++
>  drivers/scsi/u14-34f.c                |    7 +++++++
>  drivers/scsi/ultrastor.c              |    7 +++++++
>  drivers/scsi/vmw_pvscsi.c             |    5 +++++
>  drivers/scsi/wd33c93.c                |    6 +++++-
>  drivers/scsi/wd7000.c                 |    4 ++++
>  drivers/staging/hv/storvsc_drv.c      |    8 ++++++++
>  drivers/usb/image/microtek.c          |    4 ++++
>  drivers/usb/storage/scsiglue.c        |    6 ++++++
>  drivers/usb/storage/uas.c             |    9 ++++++++-
>  include/scsi/scsi_host.h              |    1 +
>  87 files changed, 576 insertions(+), 51 deletions(-)
> 

