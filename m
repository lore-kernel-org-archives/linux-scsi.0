From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] final SCSI pieces for 2.6.27
Date: Sun, 27 Jul 2008 18:39:36 -0400
Message-ID: <1217198376.3503.35.camel@localhost.localdomain>
References: <1217170150.3503.10.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0807271004440.3486@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38602 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751527AbYG0Wk3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Jul 2008 18:40:29 -0400
In-Reply-To: <alpine.LFD.1.10.0807271004440.3486@nehalem.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Sun, 2008-07-27 at 10:12 -0700, Linus Torvalds wrote:
> 
> On Sun, 27 Jul 2008, James Bottomley wrote:
> > 
> > and the diffstat:
> > 
> >  drivers/md/dm-mpath.c                       |   13 
> >  drivers/scsi/3w-9xxx.c                      |   40 +
> ...
> 
> Hmm. This diffstat does not match what I get at all. You seem to have 
> added a lot of changes to drivers/message/fusion/* at a minimum, and the 
> diffstat must have been an earlier version.
> 
> It seems to be that last "SCSI] replace __FUNCTION__ with __func__" thing 
> that is where all the changes are, even though you did list it:
> 
> 	Harvey Harrison (1):
> 	      replace __FUNCTION__ with __func__
> 
> you seem to later then have changed it.

Sorry .. that was my fault ... I've been trying to make the __FUNCTION__
replacement the last change in the series (so I could verify it was
complete) so I held it in a private branch before cherry picking it on
to the end ... and, of course, I took the diffstat before I did that.

This is the corrected diffstat with that patch included.

James

 drivers/md/dm-mpath.c                       |   13 
 drivers/message/fusion/mptbase.c            |   24 
 drivers/message/fusion/mptctl.c             |    4 
 drivers/message/fusion/mptfc.c              |    8 
 drivers/message/fusion/mptlan.c             |   26 
 drivers/message/fusion/mptsas.c             |   54 -
 drivers/message/fusion/mptscsih.c           |    4 
 drivers/scsi/3w-9xxx.c                      |   40 +
 drivers/scsi/3w-9xxx.h                      |    9 
 drivers/scsi/Kconfig                        |    1 
 drivers/scsi/Makefile                       |    2 
 drivers/scsi/advansys.c                     |    2 
 drivers/scsi/aha152x.c                      |   12 
 drivers/scsi/aic94xx/aic94xx.h              |    4 
 drivers/scsi/aic94xx/aic94xx_hwi.c          |    2 
 drivers/scsi/aic94xx/aic94xx_scb.c          |   46 -
 drivers/scsi/aic94xx/aic94xx_task.c         |    2 
 drivers/scsi/aic94xx/aic94xx_tmf.c          |   18 
 drivers/scsi/arm/fas216.c                   |    4 
 drivers/scsi/ch.c                           |    1 
 drivers/scsi/device_handler/Kconfig         |    8 
 drivers/scsi/device_handler/Makefile        |    1 
 drivers/scsi/device_handler/scsi_dh.c       |  446 ++++++++++++++-
 drivers/scsi/device_handler/scsi_dh_alua.c  |  802 ++++++++++++++++++++++++++++
 drivers/scsi/device_handler/scsi_dh_emc.c   |  644 ++++++++++++++--------
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  348 +++++++++---
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  262 ++++-----
 drivers/scsi/ibmvscsi/ibmvfc.c              |  204 ++++++-
 drivers/scsi/ibmvscsi/ibmvfc.h              |   44 +
 drivers/scsi/ibmvscsi/ibmvstgt.c            |    2 
 drivers/scsi/imm.c                          |    2 
 drivers/scsi/ipr.h                          |    6 
 drivers/scsi/libsas/sas_ata.c               |   16 
 drivers/scsi/libsas/sas_expander.c          |   12 
 drivers/scsi/libsas/sas_port.c              |    4 
 drivers/scsi/libsas/sas_scsi_host.c         |   30 -
 drivers/scsi/libsrp.c                       |    2 
 drivers/scsi/lpfc/lpfc_init.c               |    4 
 drivers/scsi/lpfc/lpfc_scsi.c               |    2 
 drivers/scsi/lpfc/lpfc_sli.c                |    6 
 drivers/scsi/megaraid/mega_common.h         |    2 
 drivers/scsi/megaraid/megaraid_mbox.c       |   16 
 drivers/scsi/megaraid/megaraid_mm.c         |    4 
 drivers/scsi/nsp32.c                        |    4 
 drivers/scsi/nsp32_debug.c                  |    2 
 drivers/scsi/pcmcia/nsp_cs.c                |    4 
 drivers/scsi/pcmcia/nsp_debug.c             |    2 
 drivers/scsi/ppa.c                          |    2 
 drivers/scsi/qla1280.c                      |   12 
 drivers/scsi/qla2xxx/qla_attr.c             |  118 ++--
 drivers/scsi/qla2xxx/qla_dbg.c              |    2 
 drivers/scsi/qla2xxx/qla_def.h              |   12 
 drivers/scsi/qla2xxx/qla_gbl.h              |    5 
 drivers/scsi/qla2xxx/qla_gs.c               |    6 
 drivers/scsi/qla2xxx/qla_init.c             |  133 ++--
 drivers/scsi/qla2xxx/qla_iocb.c             |   14 
 drivers/scsi/qla2xxx/qla_isr.c              |    4 
 drivers/scsi/qla2xxx/qla_mbx.c              |    9 
 drivers/scsi/qla2xxx/qla_mid.c              |   16 
 drivers/scsi/qla2xxx/qla_os.c               |   94 ++-
 drivers/scsi/qla2xxx/qla_sup.c              |   48 +
 drivers/scsi/qla2xxx/qla_version.h          |    2 
 drivers/scsi/qla4xxx/ql4_os.c               |    4 
 drivers/scsi/scsi.c                         |   55 +
 drivers/scsi/scsi_debug.c                   |   12 
 drivers/scsi/scsi_devinfo.c                 |    6 
 drivers/scsi/scsi_error.c                   |   34 -
 drivers/scsi/scsi_lib.c                     |   55 +
 drivers/scsi/scsi_netlink.c                 |    8 
 drivers/scsi/scsi_priv.h                    |    1 
 drivers/scsi/scsi_proc.c                    |    4 
 drivers/scsi/scsi_scan.c                    |   13 
 drivers/scsi/scsi_sysfs.c                   |    4 
 drivers/scsi/scsi_tgt_priv.h                |    2 
 drivers/scsi/scsi_transport_fc.c            |   12 
 drivers/scsi/scsi_transport_sas.c           |    4 
 drivers/scsi/sd.c                           |  291 +++++++---
 drivers/scsi/sd.h                           |   54 +
 drivers/scsi/sd_dif.c                       |  538 ++++++++++++++++++
 drivers/scsi/st.c                           |   11 
 drivers/scsi/stex.c                         |    2 
 drivers/scsi/sym53c8xx_2/sym_hipd.c         |    2 
 drivers/scsi/tmscsim.c                      |    8 
 drivers/scsi/wd7000.c                       |    8 
 drivers/scsi/zalon.c                        |    8 
 include/scsi/scsi.h                         |    3 
 include/scsi/scsi_cmnd.h                    |   86 +++
 include/scsi/scsi_device.h                  |   17 
 include/scsi/scsi_dh.h                      |   11 
 include/scsi/scsi_eh.h                      |    2 
 include/scsi/scsi_host.h                    |   86 ++-
 91 files changed, 3945 insertions(+), 1028 deletions(-)


