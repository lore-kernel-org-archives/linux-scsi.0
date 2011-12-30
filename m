From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: AIC79xx: Missing case in ahd_handle_scsiint. status = 0
Date: Fri, 30 Dec 2011 15:20:02 -0600
Message-ID: <1325280002.15782.22.camel@dabdike.int.hansenpartnership.com>
References: <alpine.SOC.1.00.1112302133280.19532@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50678 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751744Ab1L3VUG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Dec 2011 16:20:06 -0500
In-Reply-To: <alpine.SOC.1.00.1112302133280.19532@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Fri, 2011-12-30 at 21:41 +0200, Meelis Roos wrote:
> Some time ago I fitted a U320 SCSI controller into Sun Enterprise 3500 
> 64-bit PCI IO board. It had some problems in dmesg and I attached the 
> devices to other SCSI HBA-s since they were slower anyway. Now I 
> resurrected the machine and found the error again. Maybe harmless - the 
> HBA is found nevertheless. But here is the dmesg excerpt convering 
> aic79xx. In /proc/interrupts, it registers as
> 
>  60:         17          0     sun4u-IVEC      aic79xx

It looks harmless.  The problem seems to be that a scsi interrupt got
triggered for no apparent reason: all the SCSI status registers are
zero.  This is supposed to not happen for the aic, hence the dump.
Could it be something architecturally to do with the sparc platform?  As
in an interrupt either tripped spuriously, or was previously pending?

James


> [20652.378133] scsi4: Missing case in ahd_handle_scsiint. status = 0
> [20652.449005] >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> [20652.449019] scsi4: Dumping Card State at program address 0x0 Mode 0x33
> [20652.606312] Card was paused
> [20652.639646] INTSTAT[0x8]:(SCSIINT) SELOID[0x0] 
> [20652.693814] SELID[0x0] HS_MAILBOX[0x0] INTCTL[0x0] 
> [20652.752157] SEQINTSTAT[0x0] SAVED_MODE[0x25] 
> [20652.804249] DFFSTAT[0x33]:(CURRFIFO_NONE|FIFO0FREE|FIFO1FREE) 
> [20652.874057] SCSISIGI[0x0]:(P_DATAOUT) SCSIPHASE[0x0] 
> [20652.934479] SCSIBUS[0x0] LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE) 
> [20653.004286] SCSISEQ0[0x0] SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI) 
> [20653.074091] SEQCTL0[0x0] SEQINTCTL[0x0] SEQ_FLAGS[0x0] 
> [20653.136607] SEQ_FLAGS2[0x0] QFREEZE_COUNT[0x0] 
> [20653.190785] KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] 
> [20653.259546] MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] 
> [20653.314766] SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] 
> [20653.369986] PERRDIAG[0x0] SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO) 
> [20653.451252] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] 
> [20653.512722] LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0] 
> [20653.574208] 
> [20653.574214] SCB Count = 8 CMDS_PENDING = 0 LASTSCB 0xffff CURRSCB 0x0 NEXTSCB 0x0
> [20653.681548] qinstart = 0 qinfifonext = 0
> [20653.681558] QINFIFO:
> [20653.752342] WAITING_TID_QUEUES:
> [20653.791957] Pending list:
> [20653.821106] Total 0
> [20653.848206] Kernel Free SCB list: 7 6 5 4 3 2 1 0 
> [20653.905509] Sequencer Complete DMA-inprog list: 
> [20653.960722] Sequencer Complete list: 
> [20654.004485] Sequencer DMA-Up and Complete list: 
> [20654.059701] Sequencer On QFreeze and Complete list: 
> [20654.119105] 
> [20654.119111] 
> [20654.119117] scsi4: FIFO0 Free, LONGJMP == 0x803b, SCB 0x0
> [20654.219126] SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
> [20654.325383] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
> [20654.419148] SG_CACHE_SHADOW[0x2]:(LAST_SEG) 
> [20654.470199] SG_STATE[0x0] DFFSXFRCTL[0x0] SOFFCNT[0x0] 
> [20654.532712] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0 
> [20654.611910] HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL) 
> [20654.685865] 
> [20654.685871] scsi4: FIFO1 Free, LONGJMP == 0x80ac, SCB 0x0
> [20654.770281] SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
> [20654.876534] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
> [20654.970297] SG_CACHE_SHADOW[0x2]:(LAST_SEG) 
> [20655.021354] SG_STATE[0x0] DFFSXFRCTL[0x0] SOFFCNT[0x0] 
> [20655.083866] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0 
> [20655.163061] HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL) 
> [20655.237004] LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
> [20655.346420] scsi4: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> [20655.422493] scsi4: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> [20655.483962] scsi4: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> [20655.544387] 
> [20655.562088] SIMODE0[0x6c]:(ENOVERRUN|ENIOERR|ENSELDI|ENSELDO) 
> [20655.631887] CCSCBCTL[0x0] 
> [20655.664197] scsi4: REG0 == 0x45d9, SINDEX = 0x0, DINDEX = 0x0
> [20655.732978] scsi4: SCBPTR == 0x1ff, SCB_NEXT == 0xff00, SCB_NEXT2 == 0x0
> [20655.813200] CDB ff 1 0 0 0 0
> [20655.847563] STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> [20655.902764] <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> [20655.982290] scsi4 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
> [20655.982303]         <Adaptec 29320ALP PCIx Ultra320 SCSI adapter>
> [20655.982316]         aic7901: Ultra320 Wide Channel A, SCSI Id=7, PCI 33 or 66MHz, 512 SCBs
> 
> -- 
> Meelis Roos (mroos@linux.ee)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


