From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH 4/5] aic7xxx: teach aicasm to not emit unused debug code/data
Date: Sat, 26 Apr 2008 02:42:45 +0200
Message-ID: <200804260242.45192.vda.linux@googlemail.com>
References: <200804250432.16943.vda.linux@googlemail.com> <200804250441.43480.vda.linux@googlemail.com> <4811D635.4020904@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:26342 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741AbYDZAnx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Apr 2008 20:43:53 -0400
Received: by fg-out-1718.google.com with SMTP id l27so3809277fgb.17
        for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2008 17:43:51 -0700 (PDT)
In-Reply-To: <4811D635.4020904@suse.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

Hi Hannes,

On Friday 25 April 2008 15:01, Hannes Reinecke wrote:
> > Add "dont_generate_debug_code" syntax handling to aicasm_gram.y
> > 
> > aic79xx.reg, aic7xxx.reg: add dont_generate_debug_code keyword
> > for registers which are never referenced by the driver.
> > 
> > aicasm.c, aicasm_symbol.[ch]: don't emit code for those regs;
> > also add "const" keyword to generated code in few places.
> > 
> > Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
>
> No.
> Adding a symbol to each and every register definition
> which has to be hand-crafted anyway is not the correct way.
>
> I would prefer this: Add a 'count' variable to each symbol
> which gets increased every time the symbol is referenced.
> And then modify the register definition to include counts
> for symbols which are referenced from the source code only
> and not from the sequencer code.

To be honest, I don't understand how your patch achieves it.
I am not familiar enough with the way aicasm machinery works.

Do you have time/will to explain it to me?

> This will give us an automatic usage count for the symbols
> with only minimal hand-crafting.

I tested your patches atop my patches 1,2,3 versus my patches
1...5, and versus original scsi-misc-2.6-2008_04_15.
They build successfully, although they result in bigger code:

   text    data     bss     dec     hex filename
Original:
 262976   47922    1188  312086   4c316 scsi-misc-2.6-2008_04_15.org-DEBUG/drivers/scsi/aic7xxx/built-in.o
Your patches:
 233623    2346    1188  237157   39e65 scsi-misc-2.6-2008_04_15.ph5-DEBUG/drivers/scsi/aic7xxx/built-in.o
My patches:
 211224    2346    1188  214758   346e6 scsi-misc-2.6-2008_04_15.p5-DEBUG/drivers/scsi/aic7xxx/built-in.o

As compared to my patches there are more than 20 kb
of unused code. My patches can be improved too.
"make namespacecheck" shows unused functions' names.

Here are they. Those with '+' are linked in aic7xxx/built-in.o
only with your patches, the rest are linked with mine too.
There are a few with '-' (reversed situation).

Ideally, they all should be eliminated.

--- TODO.lst	Sat Apr 26 02:32:09 2008
+++ TODO_h.lst	Sat Apr 26 02:31:36 2008
@@ -1,122 +1,299 @@
   drivers/scsi/aic7xxx/aic79xx_core.o
     ahd_inq
     ahd_inw
     ahd_outq
     ahd_outw
   drivers/scsi/aic7xxx/aic79xx_osm.o
     ahd_insb
   drivers/scsi/aic7xxx/aic79xx_reg_print.o
+    ahd_abrtbitptr_print
+    ahd_abrtbyteptr_print
+    ahd_accum_print
     ahd_accum_save_print
     ahd_allocfifo_scbptr_print
+    ahd_allones_print
+    ahd_allzeros_print
+    ahd_annexcol_print
+    ahd_annexdat_print
     ahd_arg_1_print
     ahd_arg_2_print
+    ahd_attrptr_print
+    ahd_brdctl_print
+    ahd_brddat_print
+    ahd_ccscbaddr_print
+    ahd_ccscbram_print
+    ahd_ccsgaddr_print
+    ahd_ccsgram_print
+    ahd_cdblimit_print
+    ahd_clrint_print
+    ahd_clrlqiint0_print
+    ahd_clrlqiint1_print
+    ahd_clrlqoint0_print
+    ahd_clrlqoint1_print
+    ahd_clrseqintsrc_print
+    ahd_clrseqintstat_print
+    ahd_clrsint0_print
+    ahd_clrsint1_print
+    ahd_clrsint2_print
+    ahd_clrsint3_print
+    ahd_cmdlenptr_print
+    ahd_cmdptr_print
     ahd_cmds_pending_print
     ahd_cmdsize_table_print
     ahd_complete_dma_scb_head_print
     ahd_complete_dma_scb_tail_print
     ahd_complete_on_qfreeze_head_print
     ahd_complete_scb_dmainprog_head_print
     ahd_complete_scb_head_print
-    ahd_data_count_odd_print
+    ahd_curaddr_print
+    ahd_currscb_print
+    ahd_dchspltstat0_print
+    ahd_dchspltstat1_print
+    ahd_df0pcistat_print
+    ahd_dfdat_print
+    ahd_dff_thrsh_print
+    ahd_dindex_print
+    ahd_dindir_print
     ahd_dmaparams_print
+    ahd_dscommand0_print
+    ahd_dspdatactl_print
+    ahd_dspselect_print
+    ahd_error_print
+    ahd_flagptr_print
+    ahd_flags_print
+    ahd_gsfifo_print
+    ahd_haddr_print
+    ahd_hcnt_print
+    ahd_hcntrl_print
+    ahd_hescb_qoff_print
+    ahd_hnscb_qoff_print
     ahd_initiator_tag_print
     ahd_int_coalescing_cmdcount_print
     ahd_int_coalescing_maxcmds_print
     ahd_int_coalescing_mincmds_print
     ahd_int_coalescing_timer_print
+    ahd_intvec1_addr_print
+    ahd_intvec2_addr_print
+    ahd_iownid_print
     ahd_kernel_tqinpos_print
     ahd_last_msg_print
+    ahd_lastscb_print
     ahd_local_hs_mailbox_print
     ahd_longjmp_addr_print
+    ahd_lqctl1_print
+    ahd_lqctl2_print
+    ahd_lqimode0_print
+    ahd_lqimode1_print
+    ahd_lqin_print
+    ahd_lqistate_print
+    ahd_lqomode0_print
+    ahd_lqomode1_print
+    ahd_lqoscsctl_print
+    ahd_lqostate_print
+    ahd_lunlen_print
+    ahd_lunptr_print
+    ahd_maxcmd_print
+    ahd_maxcmdcnt_print
+    ahd_mode_ptr_print
     ahd_msg_out_print
+    ahd_multargid_print
+    ahd_negconopts_print
+    ahd_negoaddr_print
+    ahd_negoffset_print
+    ahd_negperiod_print
+    ahd_negppropts_print
     ahd_next_queued_scb_addr_print
+    ahd_nextscb_print
+    ahd_none_print
+    ahd_optionmode_print
+    ahd_os_space_cnt_print
+    ahd_pcixctl_print
+    ahd_prgmcnt_print
+    ahd_qnextptr_print
+    ahd_qoff_ctlsta_print
     ahd_qoutfifo_entry_valid_tag_print
     ahd_qoutfifo_next_addr_print
     ahd_reg0_print
-    ahd_reg1_print
     ahd_reg_isr_print
     ahd_saved_lun_print
     ahd_saved_scsiid_print
+    ahd_sblkctl_print
     ahd_scb_base_print
     ahd_scb_busaddr_print
     ahd_scb_cdb_len_print
     ahd_scb_datacnt_print
     ahd_scb_dataptr_print
     ahd_scb_disconnected_lists_print
     ahd_scb_lun_print
     ahd_scb_next2_print
     ahd_scb_next_print
     ahd_scb_residual_datacnt_print
     ahd_scb_residual_sgptr_print
     ahd_scb_scsi_status_print
     ahd_scb_sense_busaddr_print
     ahd_scb_sgptr_print
-    ahd_scb_spare_print
     ahd_scb_tag_print
-    ahd_scb_target_data_dir_print
-    ahd_scb_target_itag_print
-    ahd_scb_target_phases_print
     ahd_scb_task_attribute_print
     ahd_scb_task_management_print
+    ahd_scbautoptr_print
+    ahd_scbhaddr_print
+    ahd_scbhcnt_print
+    ahd_scbptr_print
+    ahd_scschkn_print
+    ahd_scsidat_print
     ahd_scsiseq_template_print
+    ahd_scsisigo_print
+    ahd_sdscb_qoff_print
+    ahd_seeadr_print
+    ahd_seectl_print
+    ahd_seedat_print
+    ahd_seestat_print
+    ahd_seqintcode_print
+    ahd_seqram_print
+    ahd_sescb_qoff_print
+    ahd_sg_cache_pre_print
+    ahd_sghaddr_print
+    ahd_sghcnt_print
+    ahd_sgspltstat0_print
+    ahd_sgspltstat1_print
+    ahd_shaddr_print
     ahd_shared_data_addr_print
+    ahd_shcnt_print
+    ahd_simode3_print
+    ahd_sindex_print
+    ahd_sindir_print
+    ahd_snscb_qoff_print
     ahd_sram_base_print
+    ahd_stack_print
+    ahd_swtimer_print
+    ahd_sxfrctl0_print
+    ahd_sxfrctl1_print
+    ahd_targidin_print
+    ahd_targpcistat_print
+    ahd_townid_print
     ahd_tqinpos_print
     ahd_waiting_scb_tails_print
     ahd_waiting_tid_head_print
     ahd_waiting_tid_tail_print
+    ahd_wrtbiasctl_print
   drivers/scsi/aic7xxx/aic7xxx_core.o
     ahc_inq
     ahc_outq
   drivers/scsi/aic7xxx/aic7xxx_osm.o
     ahc_insb
   drivers/scsi/aic7xxx/aic7xxx_reg_print.o
+    ahc_accum_print
+    ahc_allones_print
+    ahc_allzeros_print
     ahc_arg_1_print
     ahc_arg_2_print
+    ahc_brdctl_print
+    ahc_busspd_print
+    ahc_bustime_print
     ahc_busy_targets_print
-    ahc_cmdsize_table_tail_print
-    ahc_complete_scbh_print
+    ahc_cchaddr_print
+    ahc_cchcnt_print
+    ahc_ccscbaddr_print
+    ahc_ccscbcnt_print
+    ahc_ccscbctl_print
+    ahc_ccscbptr_print
+    ahc_ccscbram_print
+    ahc_ccsgaddr_print
+    ahc_ccsgctl_print
+    ahc_ccsgram_print
+    ahc_clrint_print
+    ahc_clrsint0_print
+    ahc_clrsint1_print
+    ahc_crccontrol1_print
+    ahc_dfdat_print
+    ahc_dff_thrsh_print
+    ahc_dfwaddr_print
+    ahc_dindex_print
+    ahc_dindir_print
     ahc_disc_dsb_print
     ahc_disconnected_scbh_print
     ahc_dmaparams_print
+    ahc_dscommand0_print
+    ahc_dscommand1_print
+    ahc_dspcistatus_print
+    ahc_flags_print
     ahc_free_scbh_print
     ahc_ha_274_biosctrl_print
     ahc_ha_274_biosglobal_print
+    ahc_haddr_print
+    ahc_hcnt_print
+    ahc_hcntrl_print
+    ahc_hnscb_qoff_print
     ahc_hostconf_print
+    ahc_hs_mailbox_print
     ahc_hscb_addr_print
     ahc_intdef_print
+    ahc_intstat_print
     ahc_kernel_qinpos_print
     ahc_kernel_tqinpos_print
     ahc_last_msg_print
     ahc_msg_out_print
     ahc_mwi_residual_print
     ahc_next_queued_scb_print
+    ahc_none_print
+    ahc_optionmode_print
+    ahc_qinfifo_print
     ahc_qinpos_print
+    ahc_qoff_ctlsta_print
+    ahc_qoutfifo_print
     ahc_qoutpos_print
     ahc_saved_lun_print
     ahc_saved_scsiid_print
     ahc_scb_64_btt_print
-    ahc_scb_64_spare_print
     ahc_scb_base_print
     ahc_scb_cdb_len_print
     ahc_scb_cdb_ptr_print
     ahc_scb_datacnt_print
     ahc_scb_dataptr_print
     ahc_scb_next_print
     ahc_scb_residual_sgptr_print
     ahc_scb_scsi_status_print
     ahc_scb_scsioffset_print
     ahc_scb_scsirate_print
     ahc_scb_sgptr_print
     ahc_scb_target_data_dir_print
     ahc_scb_target_itag_print
     ahc_scb_target_phases_print
+    ahc_scbbaddr_print
+    ahc_scbcnt_print
+    ahc_scbptr_print
     ahc_scsiconf_print
+    ahc_scsidatl_print
+    ahc_scsiid_print
+    ahc_scsiid_ultra2_print
     ahc_scsiseq_template_print
+    ahc_scsisigo_print
+    ahc_sdscb_qoff_print
+    ahc_seectl_2840_print
+    ahc_seectl_print
+    ahc_selid_print
+    ahc_seltimer_print
     ahc_seq_flags2_print
+    ahc_seqaddr0_print
+    ahc_seqaddr1_print
+    ahc_seqram_print
+    ahc_sfunct_print
+    ahc_sg_cache_pre_print
+    ahc_sg_cache_shadow_print
+    ahc_shaddr_print
     ahc_shared_data_addr_print
+    ahc_sindex_print
+    ahc_sindir_print
+    ahc_snscb_qoff_print
+    ahc_spiocap_print
     ahc_sram_base_print
+    ahc_stack_print
+    ahc_status_2840_print
+    ahc_stcnt_print
+    ahc_sxfrctl1_print
     ahc_targ_offset_print
+    ahc_targcrccnt_print
+    ahc_targid_print
     ahc_tqinpos_print
     ahc_ultra_enb_print
     ahc_waiting_scbh_print


--
vda
