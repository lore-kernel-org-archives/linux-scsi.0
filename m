From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [ANNOUNCE] Adaptec SAS/SATA device driver [25/27]
Date: Thu, 17 Feb 2005 12:37:48 -0500
Message-ID: <4214D66C.5070502@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:46226 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262341AbVBQRhx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 12:37:53 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHbpr31651
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:37:52 -0800
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHbpb21578
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:37:51 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Communicating with the sequencers.  Part 2/2.

+
+/* 
+ * Function:
+ *	asd_hwi_post_init_cseq()
+ *
+ * Description:
+ * 	Clear CSEQ Mode n Interrupt status and Response mailbox.
+ */
+static void
+asd_hwi_post_init_cseq(struct asd_softc *asd)
+{
+	u_int		i;
+
+	for (i = 0; i < 8; i++) {
+		asd_hwi_swb_write_dword(asd, CMnINT(i), 0xFFFFFFFF);	
+		asd_hwi_swb_read_dword(asd, CMnRSPMBX(i));
+	}
+	
+	/* Reset the External Interrupt Control. */
+	asd_hwi_swb_write_byte(asd, CARP2INTCTL, RSTINTCTL); 
+}
+
+/* 
+ * Function:
+ *	asd_hwi_lseq_init_scratch()
+ *
+ * Description:
+ *	Setup and initialize Link sequencers. Initialiaze the mode 
+ *	independent and dependent scratch page to the default settings.
+ */
+static void
+asd_hwi_init_lseq_scratch(struct asd_softc *asd)
+{
+	uint8_t		enabled_phys;
+	u_int		link_num;
+	
+	link_num = 0;
+	enabled_phys = asd->hw_profile.enabled_phys;
+	do {
+		for ( ; link_num < asd->hw_profile.max_phys; link_num++) {
+			if (enabled_phys & (1 << link_num)) {
+				enabled_phys &= ~(1 << link_num);
+				break;
+			} 
+		}
+		
+		/* Initialize LmSEQ Mode Independent Page. */
+		asd_hwi_init_lseq_mip(asd, link_num); 
+
+		/* Initialize LmSEQ Mode Dependent Page. */
+		asd_hwi_init_lseq_mdp(asd, link_num);
+
+	} while (enabled_phys != 0); 
+}
+
+/* 
+ * Function:
+ *	asd_hwi_init_lseq_mip()
+ *
+ * Description:
+ *	Initialize LSEQ Mode Independent Pages 0-3.	 
+ */
+static void
+asd_hwi_init_lseq_mip(struct asd_softc *asd, u_int link_num)
+{
+	u_int	i;
+	
+	/* LSEQ Mode Independent , page 0 setup. */
+	asd_hwi_swb_write_word(asd, LmSEQ_Q_TGTXFR_HEAD(link_num), 0xFFFF);
+	asd_hwi_swb_write_word(asd, LmSEQ_Q_TGTXFR_TAIL(link_num), 0xFFFF);
+	asd_hwi_swb_write_byte(asd, LmSEQ_LINK_NUMBER(link_num),
+			      (uint8_t) link_num);
+
+#if SAS_ENABLE_NOTIFY
+	/*
+	 * TBRV: For Seagate Gen 1.5 drive, we need to issue NOTIFY primitive 
+	 * 	 before we issue the first IO to the drive.
+	 *	 Need to investigate how other drives (such as Hitachi, Maxtor)
+	 *	 behave. This might be set to default case if all other drives
+	 *	 also required NOTIFY primitive to be sent.
+	 */
+	asd_hwi_swb_write_byte(asd, LmSEQ_SCRATCH_FLAGS(link_num), 
+			       SAS_NOTIFY_SPINUP_ENABLED);
+#else
+	asd_hwi_swb_write_byte(asd, LmSEQ_SCRATCH_FLAGS(link_num), 0x0);
+#endif
+
+	asd_hwi_swb_write_dword(asd, LmSEQ_CONNECTION_STATE(link_num), 
+				0x08000000);
+	asd_hwi_swb_write_word(asd, LmSEQ_CONCTL(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_CONSTAT(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_CONNECTION_MODES(link_num), 0x0);
+	asd_hwi_swb_write_word(asd, LmSEQ_REG1_ISR(link_num), 0x0);
+	asd_hwi_swb_write_word(asd, LmSEQ_REG2_ISR(link_num), 0x0);		
+	asd_hwi_swb_write_word(asd, LmSEQ_REG3_ISR(link_num), 0x0);
+	asd_hwi_swb_write_dword(asd, LmSEQ_REG0_ISR(link_num), 0x0);
+	asd_hwi_swb_write_dword(asd, (LmSEQ_REG0_ISR(link_num) + 4), 0x0);
+	
+	/* LSEQ Mode Independent , page 1 setup. */
+	asd_hwi_swb_write_byte(asd, LmSEQ_FRAME_TYPE_MASK(link_num), 0xFF);
+	/* Hashed Destination Address (3 bytes). */	
+	for (i = 0; i < 3; i++)
+		asd_hwi_swb_write_byte(asd, 
+				      (LmSEQ_HASHED_DEST_ADDR_MASK(link_num)+i),
+				       0xFF);
+	/* Reserved field (1 byte). */
+	asd_hwi_swb_write_byte(asd, (LmSCRATCH(link_num) + 0x01A4), 0x0);
+	
+	/* Hashed Source Address (3 bytes). */
+	for (i = 0; i < 3; i++)
+		asd_hwi_swb_write_byte(asd, 
+				      (LmSEQ_HASHED_SRC_ADDR_MASK(link_num)+i),
+				       0xFF);	
+	/* Reserved fields (2 bytes). */
+	asd_hwi_swb_write_word(asd, (LmSCRATCH(link_num) + 0x01A8), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_RETRANSMIT_MASK(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_NUM_FILL_BYTES_MASK(link_num), 0x0);
+	/* Reserved field (4 bytes). */
+	asd_hwi_swb_write_dword(asd, (LmSCRATCH(link_num) + 0x01AC), 0x0);
+	asd_hwi_swb_write_word(asd, LmSEQ_TAG_MASK(link_num), 0x0);
+	asd_hwi_swb_write_word(asd, LmSEQ_TARGET_PORT_XFER_TAG(link_num), 0x0);
+	asd_hwi_swb_write_dword(asd, LmSEQ_DATA_OFFSET(link_num), 0xFFFFFFFF);
+	asd_hwi_swb_write_word(asd, LmSEQ_ISR_SAVE_SINDEX(link_num), 0x0);
+	asd_hwi_swb_write_word(asd, LmSEQ_ISR_SAVE_DINDEX(link_num), 0x0);	
+	
+	/* LSEQ Mode Independent , page 2 setup. */
+	asd_hwi_swb_write_word(asd, LmSEQ_EMPTY_SCB_PTR0(link_num), 0xFFFF);
+	asd_hwi_swb_write_word(asd, LmSEQ_EMPTY_SCB_PTR1(link_num), 0xFFFF);
+	asd_hwi_swb_write_word(asd, LmSEQ_EMPTY_SCB_PTR2(link_num), 0xFFFF);
+	asd_hwi_swb_write_word(asd, LmSEQ_EMPTY_SCB_PTR3(link_num), 0xFFFF);
+	asd_hwi_swb_write_byte(asd, LmSEQ_EMPTY_SCB_OPCD0(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_EMPTY_SCB_OPCD1(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_EMPTY_SCB_OPCD2(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_EMPTY_SCB_OPCD3(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_EMPTY_SCB_HEAD(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_EMPTY_SCB_TAIL(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_EMPTY_BUFS_AVAIL(link_num), 0x0);
+
+	for (i = 0; i < 12; i += 4)
+		asd_hwi_swb_write_dword(asd, (LmSEQ_ATA_SCR_REGS(link_num) + i),
+			       		0x0);	
+	 
+	/* LSEQ Mode Independent , page 3 setup. */
+	asd_hwi_swb_write_dword(asd, LmSEQ_DEV_PRES_TMR_TOUT_CONST(link_num),
+				0x0);
+	/* Reserved fields (4 bytes). */
+	asd_hwi_swb_write_dword(asd, LmSEQ_SATA_INTERLOCK_TIMEOUT(link_num),
+				0x0);
+	/* Initialize STP shutdown timeout to 50 usecs. */
+	asd_hwi_swb_write_dword(asd, LmSEQ_STP_SHUTDOWN_TIMEOUT(link_num),
+				SAS_DEFAULT_STP_SHUTDOWN_TIMER_TIMEOUT);
+	asd_hwi_swb_write_dword(asd, LmSEQ_SRST_ASSERT_TIMEOUT(link_num),
+				SAS_DEFAULT_SRST_ASSERT_TIMEOUT);
+	asd_hwi_swb_write_dword(asd, LmSEQ_RCV_FIS_TIMEOUT(link_num),
+				SAS_DEFAULT_RCV_FIS_TIMEOUT);
+	asd_hwi_swb_write_dword(asd, LmSEQ_ONE_MILLISEC_TIMEOUT(link_num),
+				SAS_DEFAULT_ONE_MILLISEC_TIMEOUT);
+	asd_hwi_swb_write_dword(asd, LmSEQ_TEN_MS_COMINIT_TIMEOUT(link_num),
+				SAS_DEFAULT_COMINIT_TIMEOUT);
+	asd_hwi_swb_write_dword(asd, LmSEQ_SMP_RCV_TIMEOUT(link_num),
+				SAS_DEFAULT_SMP_RCV_TIMEOUT);			
+}
+
+/* 
+ * Function:
+ *	asd_hwi_init_lseq_mdp()
+ *
+ * Description:
+ *	Initialize LSEQ Mode Dependent Pages.	 
+ */
+static void
+asd_hwi_init_lseq_mdp(struct asd_softc *asd, u_int link_num)
+{
+	u_int		i, j;
+	uint32_t	mode_offset;
+	
+	/*
+	 * Mode 0,1,2 and 4/5 have common field on page 0 for the first 
+	 * 14 bytes.
+	 */
+	for (i = 0; i < 3; i++) {
+		mode_offset = i * LSEQ_MODE_SCRATCH_SIZE; 
+		asd_hwi_swb_write_word(asd, (LmSEQ_RET_ADDR(link_num) + 
+				       mode_offset), 0xFFFF);
+		asd_hwi_swb_write_word(asd, (LmSEQ_REG0_MODE(link_num) +
+				       mode_offset), 0x0);
+		asd_hwi_swb_write_word(asd, (LmSEQ_MODE_FLAGS(link_num) +
+				       mode_offset), 0x0);
+		asd_hwi_swb_write_word(asd, (LmSEQ_RET_ADDR_SAVE(link_num) +
+				       mode_offset), 0x0);
+		asd_hwi_swb_write_word(asd, (LmSEQ_RET_ADDR_SAVE2(link_num) +
+				       mode_offset), 0x0);
+		asd_hwi_swb_write_byte(asd, (LmSEQ_OPCODE_TO_CSEQ(link_num) +
+				       mode_offset), 0x0);
+		asd_hwi_swb_write_word(asd, (LmSEQ_DATA_TO_CSEQ(link_num) +
+				       mode_offset), 0x0);
+	}
+	/*
+	 *  Mode 5 page 0 overlaps the same scratch page with Mode 0 page 3.
+	 */
+	asd_hwi_swb_write_word(asd, (LmSEQ_RET_ADDR(link_num) +
+			       LSEQ_MODE5_PAGE0_OFFSET), 0xFFFF);
+	asd_hwi_swb_write_word(asd, (LmSEQ_REG0_MODE(link_num) + 
+			       LSEQ_MODE5_PAGE0_OFFSET), 0x0);
+	asd_hwi_swb_write_word(asd, (LmSEQ_MODE_FLAGS(link_num) + 
+			       LSEQ_MODE5_PAGE0_OFFSET), 0x0);
+	asd_hwi_swb_write_word(asd, (LmSEQ_RET_ADDR_SAVE(link_num) + 
+			       LSEQ_MODE5_PAGE0_OFFSET), 0x0);
+	asd_hwi_swb_write_word(asd, (LmSEQ_RET_ADDR_SAVE2(link_num) + 
+			       LSEQ_MODE5_PAGE0_OFFSET), 0x0);
+	asd_hwi_swb_write_byte(asd, (LmSEQ_OPCODE_TO_CSEQ(link_num) + 
+			       LSEQ_MODE5_PAGE0_OFFSET), 0x0);
+	asd_hwi_swb_write_word(asd, (LmSEQ_DATA_TO_CSEQ(link_num) + 
+			       LSEQ_MODE5_PAGE0_OFFSET), 0x0);
+	
+	/* LSEQ Mode Dependent 0, page 0 setup. */
+	asd_hwi_swb_write_word(asd, LmSEQ_FIRST_INV_DDB_SITE(link_num),
+			       ASD_MAX_DDBS);
+	asd_hwi_swb_write_word(asd, LmSEQ_EMPTY_TRANS_CTX(link_num), 0x0);
+	asd_hwi_swb_write_word(asd, LmSEQ_RESP_LEN(link_num), 0x0);
+	asd_hwi_swb_write_word(asd, LmSEQ_FIRST_INV_SCB_SITE(link_num), 
+			       ASD_MAX_SCB_SITES);
+	asd_hwi_swb_write_dword(asd, LmSEQ_INTEN_SAVE(link_num), 
+				(uint32_t) LmM0INTEN_MASK);
+	asd_hwi_swb_write_byte(asd, LmSEQ_LNK_RST_FRM_LEN(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_LNK_RST_PROTOCOL(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_RESP_STATUS(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_LAST_LOADED_SGE(link_num), 0x0);
+	asd_hwi_swb_write_word(asd, LmSEQ_SAVE_SCBPTR(link_num), 0x0);
+		
+	/* LSEQ Mode Dependent 1, page 0 setup. */
+	asd_hwi_swb_write_word(asd, LmSEQ_Q_XMIT_HEAD(link_num), 0xFFFF);
+	asd_hwi_swb_write_word(asd, LmSEQ_M1_EMPTY_TRANS_CTX(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_XMIT_REQUEST_TYPE(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_M1_RESP_STATUS(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_M1_LAST_LOADED_SGE(link_num), 0x0);
+	asd_hwi_swb_write_word(asd, LmSEQ_M1_SAVE_SCBPTR(link_num), 0x0);
+	
+	/* LSEQ Mode Dependent 2, page 0 setup */
+	asd_hwi_swb_write_word(asd, LmSEQ_PORT_COUNTER(link_num), 0x0);
+	asd_hwi_swb_write_word(asd, LmSEQ_PM_TABLE_PTR(link_num), 0x0);
+	asd_hwi_swb_write_word(asd, LmSEQ_SATA_INTERLOCK_TMR_SAVE(link_num),
+			       0x0);		
+	
+	/* LSEQ Mode Dependent 4 and 5, page 0 setup. */		
+	asd_hwi_swb_write_byte(asd, LmSEQ_SAVED_OOB_STATUS(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_SAVED_OOB_MODE(link_num), 0x0);
+	asd_hwi_swb_write_word(asd, LmSEQ_Q_LINK_HEAD(link_num), 0xFFFF);
+	asd_hwi_swb_write_byte(asd, LmSEQ_LNK_RST_ERR(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_SAVED_OOB_SIGNALS(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_SAS_RESET_MODE(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_LINK_RESET_RETRY_CNT(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_NUM_LINK_RESET_RETRIES(link_num), 
+				0x0);
+	asd_hwi_swb_write_word(asd, LmSEQ_OOB_INT_ENABLES(link_num), 0x0);
+	/* 
+	 * Set the desired interval between transmissions of the NOTIFY
+	 * (ENABLE SPINUP) primitive to 500 msecs.
+	 */ 
+	asd_hwi_swb_write_word(asd, LmSEQ_NOTIFY_TIMER_TIMEOUT(link_num),
+			      (SAS_NOTIFY_TIMER_TIMEOUT_CONST - 1));
+	/* No delay for the first NOTIFY to be sent to the attached target. */
+	asd_hwi_swb_write_word(asd, LmSEQ_NOTIFY_TIMER_DOWN_CNT(link_num),
+			       SAS_DEFAULT_NOTIFY_TIMER_DOWN_CNT);
+	
+	/* LSEQ Mode Dependent 0 and 1, page 1 setup. */
+	for (i = 0; i < 2; i++)	{
+		/* Start from Page 1 of Mode 0 and 1. */
+		mode_offset = LSEQ_PAGE_SIZE + (i*LSEQ_MODE_SCRATCH_SIZE);
+		/* All the fields of page 1 can be intialized to 0. */
+		for (j = 0; j < LSEQ_PAGE_SIZE; j += 4)
+			asd_hwi_swb_write_dword(asd, 
+					       (LmSCRATCH(link_num) +
+						mode_offset + j), 0x0);	  
+	}
+
+	/* LSEQ Mode Dependent 2, page 1 setup. */
+	asd_hwi_swb_write_dword(asd, LmSEQ_INVALID_DWORD_CNT(link_num), 0x0);
+	asd_hwi_swb_write_dword(asd, LmSEQ_DISPARITY_ERROR_CNT(link_num), 0x0);
+	asd_hwi_swb_write_dword(asd, LmSEQ_LOSS_OF_SYNC_CNT(link_num), 0x0);
+			
+	/* LSEQ Mode Dependent 4 and 5, page 1 shall be ignored. */
+	
+	/* LSEQ Mode Dependent 0, page 2 setup. */
+	asd_hwi_swb_write_dword(asd, LmSEQ_SMP_RCV_TIMER_TERM_TS(link_num),
+				0x0);
+	asd_hwi_swb_write_dword(asd, LmSEQ_M0_LAST_LOADED_SGE(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_SDB_TAG(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_SDB_MASK(link_num), 0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_DEVICE_BITS(link_num), 0x0);
+	asd_hwi_swb_write_word(asd, LmSEQ_SDB_DDB(link_num), 0x0);
+	
+	/* LSEQ Mode Dependent 1, page 2 setup. */
+	asd_hwi_swb_write_dword(asd, LmSEQ_TX_ID_ADDR_FRAME(link_num), 0x0);
+	asd_hwi_swb_write_dword(asd, LmSEQ_OPEN_TIMER_TERM_TS(link_num), 0x0);
+	asd_hwi_swb_write_dword(asd, LmSEQ_SRST_AS_TIMER_TERM_TS(link_num),
+				0x0);
+	asd_hwi_swb_write_dword(asd, LmSEQ_M1P2_LAST_LOADED_SGE(link_num), 0x0);
+
+	/* LSEQ Mode Dependent 2, page 2 setup. */
+	asd_hwi_swb_write_dword(asd, LmSEQ_STP_SHUTDOWN_TIMER_TERM_TS(link_num),
+				0x0);
+	asd_hwi_swb_write_dword(asd, LmSEQ_CLOSE_TIMER_TERM_TS(link_num), 0x0);	
+	asd_hwi_swb_write_dword(asd, LmSEQ_BREAK_TIMER_TERM_TS(link_num), 0x0);
+	asd_hwi_swb_write_dword(asd, LmSEQ_DWS_RESET_TIMER_TERM_TS(link_num),
+				0x0);
+	asd_hwi_swb_write_dword(asd,
+				LmSEQ_SATA_INTERLOCK_TIMER_TERM_TS(link_num),
+				0x0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_DOWN_TIMER_DOWN_CNT(link_num), 0x0);
+
+	/* LSEQ Mode Dependent 4 and 5, page 2 setup. */
+	asd_hwi_swb_write_dword(asd, LmSEQ_COMINIT_TIMER_TERM_TS(link_num),
+				0x0);
+	asd_hwi_swb_write_dword(asd, LmSEQ_RCV_ID_TIMER_TERM_TS(link_num),
+				0x0);
+	asd_hwi_swb_write_dword(asd, LmSEQ_RCV_FIS_TIMER_TERM_TS(link_num),
+				0x0);
+	asd_hwi_swb_write_dword(asd, LmSEQ_DEV_PRES_TIMER_TERM_TS(link_num),
+				0x0);
+}
+
+/* 
+ * Function:
+ *	asd_hwi_init_lseq_cio()
+ *
+ * Description:
+ *	Initialize LmSEQ CIO Registers.	 
+ */
+static void
+asd_hwi_init_lseq_cio(struct asd_softc *asd, u_int link_num)
+{
+	struct asd_phy	*phy;
+	uint32_t	 reqmbx_val;
+	u_int		 i;
+	
+	/* Enabled ARP2HALTC (ARP2 Halted from Halt Code Write). */
+	asd_hwi_swb_write_dword(asd, LmARP2INTEN(link_num), EN_ARP2HALTC);
+ 
+	asd_hwi_swb_write_byte(asd, LmSCRATCHPAGE(link_num), 0x0);
+	
+	/* Initialize Mode 0,1, and 2 SCRATCHPAGE to 0. */
+	for (i = 0; i < 3; i++)
+		asd_hwi_swb_write_byte(asd, LmMnSCRATCHPAGE(link_num, i), 0x0);
+
+	/* Initialize Mode 5 SCRATCHPAGE to 0. */
+	asd_hwi_swb_write_byte(asd, LmMnSCRATCHPAGE(link_num, 5), 0x0);
+	
+	asd_hwi_swb_write_dword(asd, LmRSPMBX(link_num), 0x0);
+	/* 
+	 * Initialize Mode 0,1,2 and 5 Interrupt Enable and 
+	 * Interrupt registers. 
+	 */
+	asd_hwi_swb_write_dword(asd, LmMnINTEN(link_num, 0), LmM0INTEN_MASK);
+	asd_hwi_swb_write_dword(asd, LmMnINT(link_num, 0), LmM0INTMASK);
+	/* Mode 1 */
+	asd_hwi_swb_write_dword(asd, LmMnINTEN(link_num, 1), LmM1INTEN_MASK);
+	asd_hwi_swb_write_dword(asd, LmMnINT(link_num, 1), LmM1INTMASK);
+	/* Mode 2 */
+	asd_hwi_swb_write_dword(asd, LmMnINTEN(link_num, 2), LmM2INTEN_MASK);
+	asd_hwi_swb_write_dword(asd, LmMnINT(link_num, 2), LmM2INTMASK);
+	/* Mode 5 */
+	asd_hwi_swb_write_dword(asd, LmMnINTEN(link_num, 5), LmM5INTEN_MASK);
+	asd_hwi_swb_write_dword(asd, LmMnINT(link_num, 5), LmM5INTMASK);	
+			
+	/* Enabled HW Timer status. */
+	asd_hwi_swb_write_byte(asd, LmHWTSTATEN(link_num), LmHWTSTATEN_MASK);
+	
+	/* Enabled Primitive Status 0 and 1. */
+	asd_hwi_swb_write_dword(asd, LmPRMSTAT0EN(link_num), 
+				LmPRMSTAT0EN_MASK);
+	asd_hwi_swb_write_dword(asd, LmPRMSTAT1EN(link_num),
+				LmPRMSTAT1EN_MASK);
+				
+	/* Enabled Frame Error. */ 
+	asd_hwi_swb_write_dword(asd, LmFRMERREN(link_num), LmFRMERREN_MASK);
+	/* Initialize SATA Hold level to 0x28. */
+	asd_hwi_swb_write_byte(asd, LmMnHOLDLVL(link_num, 0), 
+			       LmMnHOLD_INIT_VALUE);
+	
+	/* Initialize Mode 0 Transfer Level to 512. */
+	asd_hwi_swb_write_byte(asd,  LmMnXFRLVL(link_num, 0), LmMnXFRLVL_512);
+	/* Initialize Mode 1 Transfer Level to 256. */
+	asd_hwi_swb_write_byte(asd, LmMnXFRLVL(link_num, 1), LmMnXFRLVL_256);
+	
+	/* Initialize Program Count to 0. */
+	asd_hwi_swb_write_word(asd, LmPRGMCNT(link_num), 
+			      (LSEQ_IDLE_LOOP_ENTRY / 4));
+
+	/* Enabled Blind SG Move. */
+	asd_hwi_swb_write_dword(asd, LmMODECTL(link_num), LmBLIND48);
+	
+	reqmbx_val = asd_hwi_swb_read_dword(asd, LmREQMBX(link_num));
+	
+	/* Clear Primitive Status 0 and 1. */
+	asd_hwi_swb_write_dword(asd, LmPRMSTAT0(link_num), LmPRMSTAT0CLR_MASK);
+	asd_hwi_swb_write_dword(asd, LmPRMSTAT1(link_num), LmPRMSTAT1CLR_MASK);	
+	
+	/* Clear HW Timer status. */
+	asd_hwi_swb_write_byte(asd, LmHWTSTAT(link_num), LmHWTSTAT_MASK);
+	
+	/* Clear DMA Errors for Mode 0 and 1. */ 
+	asd_hwi_swb_write_byte(asd, LmMnDMAERRS(link_num, 0), 0xFF);
+	asd_hwi_swb_write_byte(asd, LmMnDMAERRS(link_num, 1), 0xFF);
+	
+	/* Clear SG DMA Errors for Mode 0 and 1. */ 
+	asd_hwi_swb_write_byte(asd, LmMnSGDMAERRS(link_num, 0), 0xFF);
+	asd_hwi_swb_write_byte(asd, LmMnSGDMAERRS(link_num, 1), 0xFF);
+	
+	/* Clear Mode 0 Buffer Parity Error. */		       
+	asd_hwi_swb_write_byte(asd, LmMnBUFSTAT(link_num, 0), LmMnBUFPERR);
+	
+	/* Clear Mode 0 Frame Error register. */
+	asd_hwi_swb_write_dword(asd, LmMnFRMERR(link_num, 0), LmMnFRMERR_INIT);
+			       	
+	/* Reset LSEQ Interrupt Controller. */
+	asd_hwi_swb_write_byte(asd, LmARP2INTCTL(link_num), RSTINTCTL);
+	
+	/*
+	 * Chip Rev. A1 can only payload up to 512 bytes in the DATA
+         * frame. Chip Rev. B0 can have up to 1024 bytes.
+	 * The value is in dwords.
+	 */
+	if (asd->hw_profile.rev_id == AIC9410_DEV_REV_B0) {
+		/* Set the Transmit Size to 1024 bytes, 0 = 256 Dwords. */
+		asd_hwi_swb_write_byte(asd, LmMnXMTSIZE(link_num, 1), 0x0);
+	} else {
+		/* Set the Transmit Size to 512 bytes. */
+		asd_hwi_swb_write_byte(asd, LmMnXMTSIZE(link_num, 1), 0x80);
+	}
+		
+	/* Enable SATA Port Multiplier. */
+	asd_hwi_swb_write_byte(asd, LmMnSATAFS(link_num, 1), 0x80);
+
+	/* Set the Phy SAS for the LmSEQ WWN. */
+	phy = asd->phy_list[link_num];
+	for (i = 0; i < SAS_ADDR_LEN; i++) 
+		asd_hwi_swb_write_byte(asd, (LmWWN(link_num) + i),
+				       phy->sas_addr[i]);
+
+	/* Set the Bus Inactivity Time Limit Timer to 100 ms. */
+	asd_hwi_swb_write_word(asd, LmBITL_TIMER(link_num), 0x01);
+
+	/* Initialize Interrupt Vector[0-10] address in Mode 3. */
+	asd_hwi_swb_write_word(asd, LmM3INTVEC0(link_num), 
+			      ((ASD_SET_INT_VEC(asd, LSEQ_INT_VEC0)) / 4));
+	asd_hwi_swb_write_word(asd, LmM3INTVEC1(link_num), 
+			      ((ASD_SET_INT_VEC(asd, LSEQ_INT_VEC1)) / 4));
+	asd_hwi_swb_write_word(asd, LmM3INTVEC2(link_num), 
+			      ((ASD_SET_INT_VEC(asd, LSEQ_INT_VEC2)) / 4));
+	asd_hwi_swb_write_word(asd, LmM3INTVEC3(link_num), 
+			      ((ASD_SET_INT_VEC(asd, LSEQ_INT_VEC3)) / 4));
+	asd_hwi_swb_write_word(asd, LmM3INTVEC4(link_num), 
+			      ((ASD_SET_INT_VEC(asd, LSEQ_INT_VEC4)) / 4));
+	asd_hwi_swb_write_word(asd, LmM3INTVEC5(link_num), 
+			      ((ASD_SET_INT_VEC(asd, LSEQ_INT_VEC5)) / 4));
+	asd_hwi_swb_write_word(asd, LmM3INTVEC6(link_num), 
+			      ((ASD_SET_INT_VEC(asd, LSEQ_INT_VEC6)) / 4));
+	asd_hwi_swb_write_word(asd, LmM3INTVEC7(link_num), 
+			      ((ASD_SET_INT_VEC(asd, LSEQ_INT_VEC7)) / 4));
+	asd_hwi_swb_write_word(asd, LmM3INTVEC8(link_num), 
+			      ((ASD_SET_INT_VEC(asd, LSEQ_INT_VEC8)) / 4));
+	asd_hwi_swb_write_word(asd, LmM3INTVEC9(link_num), 
+			      ((ASD_SET_INT_VEC(asd, LSEQ_INT_VEC9)) / 4));
+	asd_hwi_swb_write_word(asd, LmM3INTVEC10(link_num), 
+			      ((ASD_SET_INT_VEC(asd, LSEQ_INT_VEC10)) / 4));
+
+	/* 
+	 * Program the Link LED control, applicable only for 
+	 * Chip Rev. B or later.
+	 */
+	if (asd->hw_profile.rev_id == AIC9410_DEV_REV_B0) {
+		asd_hwi_swb_write_dword(asd, LmCONTROL(link_num),
+					(LEDTIMER | LEDMODE_TXRX | 
+					 LEDTIMERS_100ms));
+	}
+
+	/* Set the Align Rate for SAS and STP mode. */
+	asd_hwi_swb_write_byte(asd, LmM1SASALIGN(link_num), SAS_ALIGN_DEFAULT);
+	asd_hwi_swb_write_byte(asd, LmM1STPALIGN(link_num), STP_ALIGN_DEFAULT);
+}
+
+/* 
+ * Function:
+ *	asd_hwi_start_cseq()
+ *
+ * Description:
+ *	Start the Central Sequencer.	 
+ */
+int
+asd_hwi_start_cseq(struct asd_softc *asd)
+{
+	/* Reset the ARP2 instruction to location zero. */
+	asd_hwi_swb_write_word(asd, (uint32_t) CPRGMCNT, 
+			      (CSEQ_IDLE_LOOP_ENTRY / 4));
+
+	/* Unpause the CSEQ  */
+	return (asd_hwi_unpause_cseq(asd));
+}
+
+/* 
+ * Function:
+ *	asd_hwi_start_lseq()
+ *
+ * Description:
+ *	Start the Link Sequencer (LmSEQ).	 
+ */
+int
+asd_hwi_start_lseq(struct asd_softc  *asd, uint8_t  link_num)
+{
+	/* Reset the ARP2 instruction to location zero. */
+	asd_hwi_swb_write_word(asd, (uint32_t) LmPRGMCNT(link_num), 
+			      (LSEQ_IDLE_LOOP_ENTRY / 4));
+
+	/* Unpause the LmSEQ  */
+	return (asd_hwi_unpause_lseq(asd, (1U << link_num)));
+}
+
+/* 
+ * Function:
+ *	asd_swap_with_next_hscb()
+ *
+ * Description:
+ *	Swap the hscb pointed to by scb with the next
+ *	hscb the central sequencer is expecting to process.
+ */
+static inline void
+asd_swap_with_next_hscb(struct asd_softc *asd, struct scb *scb)
+{
+	union hardware_scb 	*q_hscb;
+	struct map_node 	*q_hscb_map;
+	uint64_t 		 saved_hscb_busaddr;
+
+	/*
+	 * Our queuing method is a bit tricky.  The card
+	 * knows in advance which HSCB (by address) to download,
+	 * and we can't disappoint it.  To achieve this, the next
+	 * HSCB to download is saved off in asd->next_queued_hscb.
+	 * When we are called to queue "an arbitrary scb",
+	 * we copy the contents of the incoming HSCB to the one
+	 * the sequencer knows about, swap HSCB pointers and
+	 * finally assign the SCB to the tag indexed location
+	 * in the scb_array.  This makes sure that we can still
+	 * locate the correct SCB by SCB_TAG.
+	 */
+	q_hscb = asd->next_queued_hscb;
+	q_hscb_map = asd->next_queued_hscb_map;
+	memcpy(q_hscb, scb->hscb, sizeof(*scb->hscb));
+	q_hscb->header.next_hscb_busaddr = scb->hscb_busaddr;
+
+	/* Now swap HSCB pointers. */
+	asd->next_queued_hscb = scb->hscb;
+	asd->next_queued_hscb_map = scb->hscb_map;
+	scb->hscb = q_hscb;
+	scb->hscb_map = q_hscb_map;
+	saved_hscb_busaddr = asd->next_queued_hscb_busaddr;
+	asd->next_queued_hscb_busaddr = scb->hscb_busaddr;
+	scb->hscb_busaddr = saved_hscb_busaddr;
+
+	/* Now define the mapping from tag to SCB in the scbindex */
+	asd->scbindex[SCB_GET_INDEX(scb)] = scb;
+}
+
+/* 
+ * Function:
+ *	asd_hwi_post_scb()
+ *
+ * Description:
+ *	Post the SCB to the central sequencer.	 
+ */
+void
+asd_hwi_post_scb(struct asd_softc *asd, struct scb *scb)
+{
+	ASD_LOCK_ASSERT(asd);
+
+	asd_swap_with_next_hscb(asd, scb);
+
+	/*
+	 * Keep a history of SCBs we've downloaded in the qinfifo.
+	 */
+	asd->qinfifo[ASD_QIN_WRAP(asd)] = SCB_GET_INDEX(scb);
+	asd->qinfifonext++;
+
+	if (scb->hscb->header.opcode != SCB_EMPTY_BUFFER) {
+		list_add_tail(&scb->hwi_links, &asd->pending_scbs);
+		scb->flags |= SCB_PENDING;
+	}
+
+	/* Tell the adapter about the newly queued SCB */
+	asd_write_dword(asd, SCBPRO, asd->qinfifonext);				
+}
+
+/* 
+ * Function:
+ *	asd_hwi_free_edb()
+ *
+ * Description:
+ *	Release an edb for eventual requeuing to the central sequencer.
+ */
+void
+asd_hwi_free_edb(struct asd_softc *asd, struct scb *scb, int edb_index)
+{
+	struct asd_empty_hscb 	*escb;
+	struct empty_buf_elem	*ebe;
+	u_int 		 	 i;
+
+	escb = &scb->hscb->empty_scb;
+	ebe = &escb->buf_elem[edb_index];
+	if (ELEM_BUFFER_VALID_FIELD(ebe) == ELEM_BUFFER_VALID) {
+		ebe->elem_valid_ds = ELEM_BUFFER_INVALID;
+		escb->num_valid_elems--;
+		if (escb->num_valid_elems != 0)
+			return;
+
+		/*
+		 * Now that all buffers have been used,
+		 * we can recycle the empty scb by reinitializing
+		 * it and requeuing it to the sequencer.
+		 */
+		escb->num_valid_elems = ASD_MAX_EDBS_PER_SCB;
+		ebe = &escb->buf_elem[0];
+		for (i = 0; i < ASD_MAX_EDBS_PER_SCB; i++, ebe++)
+			ebe->elem_valid_ds = ELEM_BUFFER_VALID;
+
+		asd_log(ASD_DBG_RUNTIME, 
+			"Requeuing escb %d.\n", SCB_GET_INDEX(scb));
+		
+		asd_hwi_post_scb(asd, scb);
+	}
+}
+
+/*
+ * Function:
+ *	asd_hwi_init_internal_ddb()
+ * 
+ * Description:
+ *	Initialize DDB site 0 and 1 which are used internally by the sequencer.
+ */
+void
+asd_hwi_init_internal_ddb(struct asd_softc *asd)
+{
+	int	i;
+
+	/* Setup the hardware DDB 0 location. */
+	asd_hwi_set_ddbptr(asd, 0);
+
+	for (i = 0; i < 10; i = i+2) {
+		asd_hwi_set_ddbsite_word(asd, 
+					(offsetof(struct asd_int_ddb, res1)+i),
+					 0x0);
+	}
+
+	asd_hwi_set_ddbsite_word(asd,
+				 offsetof(struct asd_int_ddb, shared_mem_lock),
+				 0x0);
+
+	for (i = 0; i < 34; i = i+2) {
+		asd_hwi_set_ddbsite_word(asd, 
+					(offsetof(struct asd_int_ddb, res2)+i),
+					 0x0);
+	}
+
+	asd_hwi_set_ddbsite_byte(asd,
+				 offsetof(struct asd_int_ddb, conn_not_active),
+				 0xFF);
+	asd_hwi_set_ddbsite_byte(asd,
+				 offsetof(struct asd_int_ddb, phy_is_up),
+				 0x0);
+	
+	for (i = 0; i < 8; i = i+4) {
+		asd_hwi_set_ddbsite_dword(asd,
+					 (offsetof(struct asd_int_ddb, 
+						   port_map_by_ports) + i),
+					  0x0);
+		asd_hwi_set_ddbsite_dword(asd,
+					 (offsetof(struct asd_int_ddb, 
+						   port_map_by_links) + i),
+					  0x0);
+	}
+
+	/* Setup the hardware DDB 1 location. */
+	asd_hwi_set_ddbptr(asd, 1);
+
+	for (i = 0; i < sizeof(struct asd_ddb); i += 4)
+		asd_hwi_set_ddbsite_dword(asd, i, 0x0);
+}
+
+/*
+ * Function:
+ *	asd_hwi_build_ddb_site()
+ *
+ * Description:
+ * 	Initialiaze and setup the hardware DDB site based on target
+ *	DDB profile.
+ */	 	  
+void
+asd_hwi_build_ddb_site(struct asd_softc *asd, struct asd_target *target)
+{
+	u_int	i;
+	
+	/* Setup the hardware DDB location. */	
+	asd_hwi_set_ddbptr(asd, target->ddb_profile.conn_handle);
+
+	asd_hwi_set_ddbsite_byte(asd, offsetof(struct asd_ddb, addr_fr_port),
+				 (INITIATOR_PORT_MODE | OPEN_ADDR_FRAME));
+	
+	/* TDOD: Set connection rate */
+	asd_hwi_set_ddbsite_byte(asd, offsetof(struct asd_ddb, conn_rate), 
+				 target->ddb_profile.conn_rate);
+
+	/* Could this field be set to 0xFFFF after first time initialization. */
+	asd_hwi_set_ddbsite_word(asd, offsetof(struct asd_ddb, init_conn_tag),
+				 0xFFFF);
+
+	for (i = 0; i < SAS_ADDR_LEN; i++) {
+		asd_hwi_set_ddbsite_byte(asd, offsetof(struct asd_ddb,
+						       dest_sas_addr[i]),
+					 target->ddb_profile.sas_addr[i]);
+	}
+
+	asd_hwi_set_ddbsite_word(asd, offsetof(struct asd_ddb, send_q_head), 
+				 0xFFFF);
+	asd_hwi_set_ddbsite_byte(asd, offsetof(struct asd_ddb, sqsuspended),
+				 0x0);
+	/* 
+	 * This needs to be changed once we support Port Multipier as
+	 * Port Multipier has seperate DDB.
+	 */
+	asd_hwi_set_ddbsite_byte(asd, offsetof(struct asd_ddb, ddb_type),
+				 TARGET_PORT_DDB);
+	asd_hwi_set_ddbsite_word(asd, offsetof(struct asd_ddb, res1),
+				 0x0);
+	asd_hwi_set_ddbsite_word(asd, offsetof(struct asd_ddb, awt_default),
+				 0x0);
+	asd_hwi_set_ddbsite_byte(asd, offsetof(struct asd_ddb, comp_features),
+				 0x0);
+	asd_hwi_set_ddbsite_byte(asd, offsetof(struct asd_ddb, pathway_blk_cnt),
+				 0x0);
+	asd_hwi_set_ddbsite_word(asd, offsetof(struct asd_ddb, arb_wait_time),
+				 0x0);
+	asd_hwi_set_ddbsite_dword(asd, offsetof(struct asd_ddb, 
+						more_comp_features),
+				  0x0);
+	asd_hwi_set_ddbsite_byte(asd, offsetof(struct asd_ddb, conn_mask),
+				 target->src_port->conn_mask);
+
+	asd_hwi_set_ddbsite_byte(asd, offsetof(struct asd_ddb, open_affl),
+				 target->ddb_profile.open_affl);
+	
+	asd_hwi_set_ddbsite_byte(asd, offsetof(struct asd_ddb, res2), 0x0);
+	
+	asd_hwi_set_ddbsite_byte(asd, offsetof(struct asd_ddb, stp_close),
+				 CLOSE_STP_NO_TX);
+	
+	asd_hwi_set_ddbsite_word(asd, offsetof(struct asd_ddb, exec_q_tail),
+				 0xFFFF);
+	asd_hwi_set_ddbsite_word(asd, offsetof(struct asd_ddb, send_q_tail),
+				 0xFFFF);
+
+	asd_hwi_set_ddbsite_word(asd, offsetof(struct asd_ddb, sister_ddb),
+				 target->ddb_profile.sister_ddb);
+
+	asd_hwi_set_ddbsite_word(asd, offsetof(struct asd_ddb, ata_cmd_scb_ptr),
+				 0xFFFF);
+	asd_hwi_set_ddbsite_dword(asd, offsetof(struct asd_ddb, sata_tag_mask),
+				  0x0);
+	asd_hwi_set_ddbsite_word(asd, offsetof(struct asd_ddb, active_task_cnt),
+				 0x0);
+	asd_hwi_set_ddbsite_dword(asd, offsetof(struct asd_ddb, sata_sactive),
+				  0x0);
+	asd_hwi_set_ddbsite_byte(asd, offsetof(struct asd_ddb, no_of_sata_tags),
+				 0x0);
+	/*
+	 * Need to update this field based on the info from Host register FIS
+	 * after OOB.
+	 */     
+	asd_hwi_set_ddbsite_byte(asd, offsetof(struct asd_ddb, sata_stat),
+				 0x50);
+	asd_hwi_set_ddbsite_byte(asd, offsetof(struct asd_ddb, 
+					       sata_ending_stat),
+				 0x0);
+	asd_hwi_set_ddbsite_byte(asd, offsetof(struct asd_ddb, itnl_reason),
+				 0x0);
+	asd_hwi_set_ddbsite_word(asd, offsetof(struct asd_ddb, 
+					       ncq_data_scb_ptr),
+				 0xFFFF);
+	/*
+	 * We ensure that we don't program zero value as ITNL timeout value.
+	 * As zero value is treated by the firmware as infinite value.
+       	 */
+	asd_hwi_set_ddbsite_word(asd, offsetof(struct asd_ddb, itnl_const),
+				((target->ddb_profile.itnl_const != 0) ?
+				  target->ddb_profile.itnl_const : 1));
+	asd_hwi_set_ddbsite_dword(asd, offsetof(struct asd_ddb, itnl_timestamp),
+				  0x0);
+}
+
+void
+asd_hwi_update_sata(struct asd_softc *asd, struct asd_target *target)
+{
+	/* Setup the hardware DDB location. */	
+	asd_hwi_set_ddbptr(asd, target->ddb_profile.conn_handle);
+
+	asd_hwi_set_ddbsite_byte(asd, offsetof(struct asd_ddb, sata_stat),
+		target->ddb_profile.sata_status);
+}
+
+void
+asd_hwi_update_conn_mask(struct asd_softc *asd, struct asd_target *target)
+{
+	/* Setup the hardware DDB location. */	
+	asd_hwi_set_ddbptr(asd, target->ddb_profile.conn_handle);
+
+	asd_hwi_set_ddbsite_byte(asd, offsetof(struct asd_ddb, conn_mask),
+				 target->src_port->conn_mask);
+}
+
+
+/********************* REGISTERS DUMP STATE routines **************************/
+
+#ifdef ASD_DEBUG
+
+void
+asd_hwi_dump_seq_state(struct asd_softc *asd, uint8_t lseq_mask)
+{
+	uint8_t	lseqs_to_dump;
+	u_int	lseq_id;
+
+	/* Dump out CSEQ Registers state. */
+	asd_hwi_dump_cseq_state(asd);
+
+	if (lseq_mask == 0x0)
+		return;
+
+	lseq_id = 0;
+	lseqs_to_dump = lseq_mask;
+
+	while (lseqs_to_dump != 0) { 
+		for ( ; lseq_id < asd->hw_profile.max_phys; lseq_id++) {
+			if (lseqs_to_dump & (1 << lseq_id)) {
+				lseqs_to_dump &= ~(1 << lseq_id);
+				break;
+			} 
+		}
+		/* Dump out specific LSEQ Registers state. */
+		asd_hwi_dump_lseq_state(asd, lseq_id);
+	}
+}
+	
+static void
+asd_hwi_dump_cseq_state(struct asd_softc *asd)
+{
+	asd_print("\nCSEQ DUMP STATE\n");
+	asd_print("===============\n");
+
+	asd_print("\nIOP REGISTERS\n");
+	asd_print("*************\n");
+
+	asd_print("   %20s[0x%x]:0x%08x\n", "ARP2CTL", ARP2CTL,
+		  asd_hwi_swb_read_dword(asd, CARP2CTL));
+
+	asd_print("   %20s[0x%x]:0x%08x\n", "ARP2INT", ARP2INT,
+		  asd_hwi_swb_read_dword(asd, CARP2INT));
+
+	asd_print("   %20s[0x%x]:0x%08x\n", "ARP2INTEN", ARP2INTEN,
+		  asd_hwi_swb_read_dword(asd, CARP2INTEN));
+
+	asd_print("\nSCRATCH MEMORY\n");
+	asd_print("**************\n");
+
+	asd_print("\nPage 2 - Mode 8\n");
+	asd_print("---------------\n");
+
+	asd_print("   %20s[0x%x]:0x%08x", "Q_NEW_POINTER", 0x240,
+		  asd_hwi_swb_read_dword(asd, CSEQ_Q_NEW_POINTER+4));
+	asd_print("%08x\n", asd_hwi_swb_read_dword(asd, CSEQ_Q_NEW_POINTER));
+
+	asd_print("   %20s[0x%x]:0x%08x", "Q_DONE_BASE", 0x248,
+		  asd_hwi_swb_read_dword(asd, CSEQ_Q_DONE_BASE+4));
+	asd_print("%08x\n", asd_hwi_swb_read_dword(asd, CSEQ_Q_DONE_BASE));
+
+	asd_print("   %20s[0x%x]:0x%08x\n", "Q_DONE_POINTER", 0x250,
+		  asd_hwi_swb_read_dword(asd, CSEQ_Q_DONE_POINTER));
+
+	asd_print("   %20s[0x%x]:0x%08x\n", "Q_DONE_PASS", 0x254,
+		  asd_hwi_swb_read_dword(asd, CSEQ_Q_DONE_PASS));
+
+	asd_print("\nMode Independent Page 4\n");
+	asd_print("-----------------------\n");
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "Q_EXE_HEAD", 0x280,
+		  asd_hwi_swb_read_word(asd, CSEQ_Q_EXE_HEAD));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "Q_EXE_TAIL", 0x282,
+		  asd_hwi_swb_read_word(asd, CSEQ_Q_EXE_TAIL));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "Q_DONE_HEAD", 0x284,
+		  asd_hwi_swb_read_word(asd, CSEQ_Q_DONE_HEAD));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "Q_DONE_TAIL", 0x286,
+		  asd_hwi_swb_read_word(asd, CSEQ_Q_DONE_TAIL));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "Q_SEND_HEAD", 0x288,
+		  asd_hwi_swb_read_word(asd, CSEQ_Q_SEND_HEAD));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "Q_SEND_TAIL", 0x28A,
+		  asd_hwi_swb_read_word(asd, CSEQ_Q_SEND_TAIL));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "Q_DMA2CHIM_HEAD", 0x28C,
+		  asd_hwi_swb_read_word(asd, CSEQ_Q_DMA2CHIM_HEAD));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "Q_DMA2CHIM_TAIL", 0x28E,
+		  asd_hwi_swb_read_word(asd, CSEQ_Q_DMA2CHIM_TAIL));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "Q_COPY_HEAD", 0x290,
+		  asd_hwi_swb_read_word(asd, CSEQ_Q_COPY_HEAD));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "Q_COPY_TAIL", 0x292,
+		  asd_hwi_swb_read_word(asd, CSEQ_Q_COPY_TAIL));
+
+	asd_print("   %20s[0x%x]:0x%02x\n", "LINK_CTL_Q_MAP", 0x29C,
+		  asd_hwi_swb_read_byte(asd, CSEQ_LINK_CTL_Q_MAP));
+
+	asd_print("   %20s[0x%x]:0x%02x\n", "SCRATCH_FLAGS", 0x29F,
+		  asd_hwi_swb_read_byte(asd, CSEQ_SCRATCH_FLAGS));
+
+	asd_print("\nMode Independent Page 5\n");
+	asd_print("-----------------------\n");
+
+	asd_print("   %20s[0x%x]:0x%02x\n", "FREE_SCB_MASK", 0x2B5,
+		  asd_hwi_swb_read_byte(asd, CSEQ_FREE_SCB_MASK));
+
+	asd_print("   %24s[0x%x]:0x%04x\n", "BUILTIN_FREE_SCB_HEAD", 0x2B6,
+		  asd_hwi_swb_read_word(asd, CSEQ_BUILTIN_FREE_SCB_HEAD));
+
+	asd_print("   %24s[0x%x]:0x%04x\n", "BUILTIN_FREE_SCB_TAIL", 0x2B8,
+		  asd_hwi_swb_read_word(asd, CSEQ_BUILTIN_FREE_SCB_TAIL));
+
+	asd_print("\nMode Independent Page 7\n");
+	asd_print("-----------------------\n");
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "Q_EMPTY_HEAD", 0x2F0,
+		  asd_hwi_swb_read_word(asd, CSEQ_Q_EMPTY_HEAD));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "Q_EMPTY_TAIL", 0x2F2,
+		  asd_hwi_swb_read_word(asd, CSEQ_Q_EMPTY_TAIL));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "NEED_EMPTY_SCB", 0x2F4,
+		  asd_hwi_swb_read_word(asd, CSEQ_NEED_EMPTY_SCB));
+
+	asd_print("   %20s[0x%x]:0x%02x\n", "EMPTY_REQ_HEAD", 0x2F6,
+		  asd_hwi_swb_read_byte(asd, CSEQ_EMPTY_REQ_HEAD));
+
+	asd_print("   %20s[0x%x]:0x%02x\n", "EMPTY_REQ_TAIL", 0x2F7,
+		  asd_hwi_swb_read_byte(asd, CSEQ_EMPTY_REQ_TAIL));
+
+	asd_print("   %20s[0x%x]:0x%02x\n", "EMPTY_SCB_OFFSET", 0x2F8,
+		  asd_hwi_swb_read_byte(asd, CSEQ_EMPTY_SCB_OFFSET));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "PRIMITIVE_DATA", 0x2FA,
+		  asd_hwi_swb_read_word(asd, CSEQ_PRIMITIVE_DATA));
+
+	asd_print("   %20s[0x%x]:0x%08x\n", "TIMEOUT_CONST", 0x2FC,
+		  asd_hwi_swb_read_dword(asd, CSEQ_TIMEOUT_CONSTANT));
+
+	asd_print("\nPage 0 - Mode 8\n");
+	asd_print("---------------\n");
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "RET_ADDR", 0x200,
+		  asd_hwi_swb_read_word(asd, CSEQ_RET_ADDR));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "RET_SCBPTR", 0x202,
+		  asd_hwi_swb_read_word(asd, CSEQ_RET_SCBPTR));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "SAVE_SCBPTR", 0x204,
+		  asd_hwi_swb_read_word(asd, CSEQ_SAVE_SCBPTR));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "EMPTY_TC", 0x206,
+		  asd_hwi_swb_read_word(asd, CSEQ_EMPTY_TRANS_CTX));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "RESP_LEN", 0x208,
+		  asd_hwi_swb_read_word(asd, CSEQ_RESP_LEN));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "TMF_SCBPTR", 0x20A,
+		  asd_hwi_swb_read_word(asd, CSEQ_TMF_SCBPTR));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "GLOBAL_PREV_SCB", 0x20C,
+		  asd_hwi_swb_read_word(asd, CSEQ_GLOBAL_PREV_SCB));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "GLOBAL_HEAD", 0x20E,
+		  asd_hwi_swb_read_word(asd, CSEQ_GLOBAL_HEAD));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "TMF_OPCODE", 0x210,
+		  asd_hwi_swb_read_word(asd, CSEQ_TMF_OPCODE));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "CLEAR_LU_HEAD", 0x212,
+		  asd_hwi_swb_read_word(asd, CSEQ_CLEAR_LU_HEAD));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "FIRST_INV_SCB_SITE", 0x21C,
+		  asd_hwi_swb_read_word(asd, CSEQ_FIRST_INV_SCB_SITE));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "FIRST_INV_DDB_SITE", 0x21E,
+		  asd_hwi_swb_read_word(asd, CSEQ_FIRST_INV_DDB_SITE));
+
+	asd_print("\nCIO REGISTERS\n");
+	asd_print("*************\n");
+
+	asd_print("   %20s[0x%x]:0x%02x\n", "ARP2_MODEPTR", MODEPTR,
+		  asd_hwi_swb_read_byte(asd, CMODEPTR));
+
+	asd_print("   %20s[0x%x]:0x%02x\n", "ARP2_ALTMODE", ALTMODE,
+		  asd_hwi_swb_read_byte(asd, CALTMODE));
+
+	asd_print("   %20s[0x%x]:0x%02x\n", "ARP2_FLAG", FLAG,
+		  asd_hwi_swb_read_byte(asd, CFLAG));
+
+	asd_print("   %20s[0x%x]:0x%02x\n", "ARP2_INTCTL", ARP2INTCTL,
+		  asd_hwi_swb_read_byte(asd, CARP2INTCTL));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "ARP2_PRGMCNT", PRGMCNT,
+		  asd_hwi_swb_read_word(asd, CPRGMCNT));
+
+	asd_print("   %20s[0x%x]:0x%02x\n", "ARP2_HALTCODE", ARP2HALTCODE,
+		  asd_hwi_swb_read_byte(asd, CARP2HALTCODE));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "ARP2_CURRADDR", CURRADDR,
+		  asd_hwi_swb_read_word(asd, CCURRADDR));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "ARP2_LASTADDR", LASTADDR,
+		  asd_hwi_swb_read_word(asd, CLASTADDR));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "ARP2_NXTLADDR", NXTLADDR,
+		  asd_hwi_swb_read_word(asd, CNXTLADDR));
+
+	asd_print("   %20s[0x%x]:0x%08x\n", "CLINKCON", 0x28,
+		  asd_hwi_swb_read_dword(asd, CLINKCON));
+		  	
+	asd_print("   %20s[0x%x]:0x%02x\n", "CCONMSK", 0x60,
+		  asd_hwi_swb_read_byte(asd, CCONMSK));
+	
+	asd_print("   %20s[0x%x]:0x%02x\n", "CCONEXIST", 0x61,
+		  asd_hwi_swb_read_byte(asd, CCONEXIST));
+	
+	asd_print("   %20s[0x%x]:0x%04x\n", "CCONMODE", 0x62,
+		  asd_hwi_swb_read_word(asd, CCONMODE));
+}
+
+static void
+asd_hwi_dump_lseq_state(struct asd_softc *asd, u_int lseq_id)
+{
+	uint32_t lseq_cio_addr;
+	uint32_t mode_offset;
+	uint16_t saved_reg16;
+	uint16_t sm_idx;
+	int	 idx;
+	int	 mode;
+
+	asd_print("\nLSEQ %d DUMP STATE\n", lseq_id);
+	asd_print("=================\n");
+
+	asd_print("\nIOP REGISTERS\n");
+	asd_print("*************\n");
+
+	asd_print("   %20s[0x%x]:0x%08x\n", "ARP2CTL", ARP2CTL,
+		  asd_hwi_swb_read_dword(asd, LmARP2CTL(lseq_id)));
+
+	asd_print("   %20s[0x%x]:0x%08x\n", "ARP2INT", ARP2INT,
+		  asd_hwi_swb_read_dword(asd, LmARP2INT(lseq_id)));
+
+	asd_print("   %20s[0x%x]:0x%08x\n", "ARP2INTEN", ARP2INTEN,
+		  asd_hwi_swb_read_dword(asd, LmARP2INTEN(lseq_id)));
+
+	asd_print("\nSCRATCH MEMORY\n");
+	asd_print("**************\n");
+
+	asd_print("\nMode Independent\n");
+	asd_print("----------------\n");
+
+	asd_print("   %20s[0x%x]:0x%02x\n", "SCRATCH_FLAGS", 0x187,
+		  asd_hwi_swb_read_byte(asd, LmSEQ_SCRATCH_FLAGS(lseq_id)));
+
+	asd_print("   %20s[0x%x]:0x%08x\n", "CONNECTION_STATE", 0x188,
+		  asd_hwi_swb_read_dword(asd, LmSEQ_CONNECTION_STATE(lseq_id)));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "CONCTL", 0x18C,
+		  asd_hwi_swb_read_word(asd, LmSEQ_CONCTL(lseq_id)));
+
+	asd_print("   %20s[0x%x]:0x%02x\n", "CONSTAT", 0x18E,
+		  asd_hwi_swb_read_byte(asd, LmSEQ_CONSTAT(lseq_id)));
+
+	for (mode = 0; mode < 3; mode++) {
+		asd_print("\nCommon Page 0 - Mode %d\n", mode);
+		asd_print("-----------------------\n");
+
+		/* Adjust the mode page. */
+		mode_offset = mode * LSEQ_MODE_SCRATCH_SIZE;
+		
+		asd_print("   %20s[0x%x]:0x%04x\n", "RET_ADDR", 0x0,
+			  asd_hwi_swb_read_word(asd, (LmSEQ_RET_ADDR(lseq_id) +
+						mode_offset)));
+
+		asd_print("   %20s[0x%x]:0x%04x\n", "RET_ADDR_SAVE", 0x6,
+			  asd_hwi_swb_read_word(asd,
+				  	       (LmSEQ_RET_ADDR_SAVE(lseq_id) +
+						mode_offset)));
+
+		asd_print("   %20s[0x%x]:0x%04x\n", "RET_ADDR_SAVE2", 0x8,
+			  asd_hwi_swb_read_word(asd,
+				  	       (LmSEQ_RET_ADDR_SAVE2(lseq_id) +
+						mode_offset)));
+
+		asd_print("   %20s[0x%x]:0x%04x\n", "MODE_FLAGS", 0x4,
+			  asd_hwi_swb_read_word(asd,
+				  	       (LmSEQ_MODE_FLAGS(lseq_id) +
+						mode_offset)));
+
+		asd_print("   %20s[0x%x]:0x%04x\n", "REG0_MODE", 0x2,
+			  asd_hwi_swb_read_word(asd,
+				  	       (LmSEQ_REG0_MODE(lseq_id) +
+						mode_offset)));
+
+		asd_print("   %20s[0x%x]:0x%04x\n", "DATA_TO_CSEQ", 0xC,
+			  asd_hwi_swb_read_word(asd,
+				  	       (LmSEQ_DATA_TO_CSEQ(lseq_id) +
+						mode_offset)));
+
+		asd_print("   %20s[0x%x]:0x%02x\n", "OPCODE_TO_CSEQ", 0xB,
+			  asd_hwi_swb_read_byte(asd,
+				  	       (LmSEQ_OPCODE_TO_CSEQ(lseq_id) +
+						mode_offset)));
+	}
+
+	asd_print("\nPage 0 - Mode 5\n");
+	asd_print("----------------\n");
+
+	mode_offset = LSEQ_MODE5_PAGE0_OFFSET;
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "RET_ADDR", 0x0,
+		  asd_hwi_swb_read_word(asd, (LmSEQ_RET_ADDR(lseq_id) +
+				  	mode_offset)));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "RET_ADDR_SAVE", 0x6,
+		  asd_hwi_swb_read_word(asd, (LmSEQ_RET_ADDR_SAVE(lseq_id) +
+					mode_offset)));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "RET_ADDR_SAVE2", 0x8,
+		  asd_hwi_swb_read_word(asd, (LmSEQ_RET_ADDR_SAVE2(lseq_id) +
+					mode_offset)));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "MODE_FLAGS", 0x4,
+		  asd_hwi_swb_read_word(asd, (LmSEQ_MODE_FLAGS(lseq_id) +
+					mode_offset)));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "REG0_MODE", 0x2,
+		  asd_hwi_swb_read_word(asd, (LmSEQ_REG0_MODE(lseq_id) +
+					mode_offset)));
+
+	asd_print("   %20s[0x%x]:0x%04x\n", "DATA_TO_CSEQ", 0xC,
+		  asd_hwi_swb_read_word(asd, (LmSEQ_DATA_TO_CSEQ(lseq_id) +
+					mode_offset)));
+
+	asd_print("   %20s[0x%x]:0x%02x\n", "OPCODE_TO_CSEQ", 0xB,
+		  asd_hwi_swb_read_byte(asd, (LmSEQ_OPCODE_TO_CSEQ(lseq_id) +
+					mode_offset)));
+
+	asd_print("   %20s[0x%x]:0x%02x\n", "SAVED_OOB_STATUS", 0x6E,
+		  asd_hwi_swb_read_byte(asd, LmSEQ_SAVED_OOB_STATUS(lseq_id)));
+
+	asd_print("   %20s[0x%x]:0x%02x\n", "SAVED_OOB_MODE", 0x6F,
+		  asd_hwi_swb_read_byte(asd, LmSEQ_SAVED_OOB_MODE(lseq_id)));
+
+	asd_print("   %20s[0x%x]:0x%02x\n", "SAVED_OOB_SIGNALS", 0x73,
+		  asd_hwi_swb_read_byte(asd, LmSEQ_SAVED_OOB_SIGNALS(lseq_id)));
+
+	asd_print("\nPage 1 - Mode 2\n");
+	asd_print("----------------\n");
+
+	asd_print("   %20s[0x%x]:0x%08x\n", "INVALID_DWORD_COUNT", 0x120,
+		  asd_hwi_swb_read_dword(asd,LmSEQ_INVALID_DWORD_CNT(lseq_id)));
+
+	asd_print("   %20s[0x%x]:0x%08x\n", "DISPARITY_ERROR_COUNT", 0x124,
+		  asd_hwi_swb_read_dword(asd,
+			  		 LmSEQ_DISPARITY_ERROR_CNT(lseq_id)));
+
+	asd_print("   %20s[0x%x]:0x%08x\n", "LOSS_OF_SYNC_COUNT", 0x128,
+		  asd_hwi_swb_read_dword(asd,
+			  		 LmSEQ_LOSS_OF_SYNC_CNT(lseq_id)));
+
+	asd_print("\nCIO REGISTERS\n");
+	asd_print("*************\n");
+
+	for (mode = 0; mode < 2; mode++) {
+		asd_print("\nMode %d\n", mode);
+		asd_print("------\n");
+
+		idx = 0;
+		lseq_cio_addr = LmSEQ_PHY_BASE(mode, lseq_id);
+		
+		while (LSEQmCIOREGS[idx].width != 0) {
+			/* 
+			 * Check if we are in the right mode to dump the
+			 * contents of the registers.
+			 */
+			if ((LSEQmCIOREGS[idx].mode & (1 << mode)) != 0) {
+				switch(LSEQmCIOREGS[idx].width) {
+               			case 8:
+					asd_print("%20s[0x%x]: 0x%02x\n",
+						  LSEQmCIOREGS[idx].name,
+						  LSEQmCIOREGS[idx].offset,
+						 (asd_hwi_swb_read_byte(asd,
+						 (lseq_cio_addr +
+						  LSEQmCIOREGS[idx].offset))));
+ 
+                  			break;
+				case 16:
+					asd_print("%20s[0x%x]: 0x%04x\n",
+						  LSEQmCIOREGS[idx].name,
+						  LSEQmCIOREGS[idx].offset,
+						 (asd_hwi_swb_read_word(asd,
+						 (lseq_cio_addr +
+						  LSEQmCIOREGS[idx].offset))));
+ 
+                  			break;
+				case 32:
+					asd_print("%20s[0x%x]: 0x%08x\n",
+						  LSEQmCIOREGS[idx].name,
+						  LSEQmCIOREGS[idx].offset,
+						 (asd_hwi_swb_read_dword(asd,
+						 (lseq_cio_addr +
+						  LSEQmCIOREGS[idx].offset))));
+					break;
+				}
+			}
+			idx++;
+		}
+	}
+
+	asd_print("\nCIO REGISTERS\n");
+	asd_print("*************\n");
+
+	asd_print("\nMode 5\n");
+	asd_print("------\n");
+
+	lseq_cio_addr = LmSEQ_PHY_BASE(5, lseq_id);
+	idx = 0;
+
+	while (LSEQmOOBREGS[idx].width != 0) {
+		switch(LSEQmOOBREGS[idx].width) {
+               	case 8:
+			asd_print("%20s[0x%x]: 0x%02x\n",
+				  LSEQmOOBREGS[idx].name,
+				  LSEQmOOBREGS[idx].offset,
+				 (asd_hwi_swb_read_byte(
+						asd, (lseq_cio_addr +
+						LSEQmOOBREGS[idx].offset))));
+                  	break;
+		case 16:
+			asd_print("%20s[0x%x]: 0x%04x\n",
+				  LSEQmOOBREGS[idx].name,
+				  LSEQmOOBREGS[idx].offset,
+				 (asd_hwi_swb_read_word(
+						asd, (lseq_cio_addr +
+						LSEQmOOBREGS[idx].offset))));
+                  	break;
+		case 32:
+			asd_print("%20s[0x%x]: 0x%08x\n",
+				  LSEQmOOBREGS[idx].name,
+				  LSEQmOOBREGS[idx].offset,
+				 (asd_hwi_swb_read_dword(
+						asd, (lseq_cio_addr +
+						LSEQmOOBREGS[idx].offset))));
+			break;
+		}
+		idx++;
+	}
+
+	asd_print("\nLSEQ %d STATE MACHINES.\n", lseq_id);
+	asd_print("**********************\n");
+
+	saved_reg16 = asd_hwi_swb_read_word(asd, LmSMDBGCTL(lseq_id));
+
+	for (sm_idx = 0; sm_idx < 32; sm_idx++) {
+		asd_hwi_swb_write_word(asd, LmSMDBGCTL(lseq_id), sm_idx);
+
+		asd_print("   %20s[0x%x]:0x%08x\n", "SMSTATE", sm_idx,
+			  asd_hwi_swb_read_dword(asd, LmSMSTATE(lseq_id)));
+
+		asd_print("   %20s[0x%x]:0x%08x\n", "SMSTATEBRK", sm_idx,
+			  asd_hwi_swb_read_dword(asd, LmSMSTATEBRK(lseq_id)));
+	}
+
+	asd_hwi_swb_write_word(asd, LmSMDBGCTL(lseq_id), saved_reg16);
+}
+
+void
+asd_hwi_dump_ddb_site(struct asd_softc *asd, u_int site_no)
+{
+	if (site_no >= ASD_MAX_DDBS)
+		return;
+
+	/* Setup the hardware DDB site. */
+	asd_hwi_set_ddbptr(asd, site_no);
+
+	asd_print("\nDDB: 0x%x\n", site_no);
+	asd_print("---------\n\n");
+
+	asd_print("SendQ Target Head: 0x%04x.\n",
+		  asd_hwi_get_ddbsite_word(
+			  asd, offsetof(struct asd_ddb, send_q_head))); 
+	asd_print("SendQ Suspended: 0x%02x.\n",
+		  asd_hwi_get_ddbsite_byte(
+			  asd, offsetof(struct asd_ddb, sqsuspended)));
+	asd_print("DDB Type: 0x%02x.\n",
+		  asd_hwi_get_ddbsite_byte(
+			  asd, offsetof(struct asd_ddb, ddb_type)));
+	asd_print("AWT Default: 0x%04x.\n",
+		  asd_hwi_get_ddbsite_word(
+			  asd, offsetof(struct asd_ddb, awt_default)));
+	asd_print("Pathway Blocked Count: 0x%02x.\n",
+		  asd_hwi_get_ddbsite_byte(
+			  asd, offsetof(struct asd_ddb, pathway_blk_cnt)));
+	asd_print("Conn Mask: 0x%02x.\n",
+		  asd_hwi_get_ddbsite_byte(
+			  asd, offsetof(struct asd_ddb, conn_mask)));
+	asd_print("Open Reject Status: 0x%02x.\n",
+		  asd_hwi_get_ddbsite_byte(
+			  asd, offsetof(struct asd_ddb, stp_close)));
+	asd_print("ExecQ Target Tail: 0x%04x.\n",
+		  asd_hwi_get_ddbsite_word(
+			  asd, offsetof(struct asd_ddb, exec_q_tail)));
+	asd_print("SendQ Target Tail: 0x%04x.\n",
+		  asd_hwi_get_ddbsite_word(
+			  asd, offsetof(struct asd_ddb, send_q_tail)));
+	asd_print("Active Task Count: 0x%04x.\n",
+		  asd_hwi_get_ddbsite_word(
+			  asd, offsetof(struct asd_ddb, active_task_cnt)));
+	asd_print("ITNL Reason: 0x%02x.\n",
+		  asd_hwi_get_ddbsite_byte(
+			  asd, offsetof(struct asd_ddb, itnl_reason)));
+	asd_print("INTL Timeout Const: 0x%04x.\n",
+		  asd_hwi_get_ddbsite_word(
+			  asd, offsetof(struct asd_ddb, itnl_const)));
+}
+
+
+/*
+ * Template to hold setting breakpoint for ARP2 codes.
+ */
+void
+asd_hwi_set_breakpoint(struct asd_softc *asd, int phy_id)
+{
+	/*
+ 	 * Steps in setting a breakpoint for LSEQ or CSEQ.
+ 	 */
+	asd_hwi_pause_lseq(asd, 0x1);
+
+	asd_print("INTVEC10 = 0x%x. \n", LSEQ_INT_VEC10B0);
+
+	asd_hwi_swb_write_dword(asd, LmARP2BREAKADR01(phy_id), 
+				(LSEQ_INT_VEC10B0 / 4));
+
+	asd_hwi_swb_write_dword(asd, LmARP2INT(phy_id), 0xF);
+
+	asd_print("LmARP2INT after clear = 0x%x .\n",
+			asd_hwi_swb_read_dword(asd, LmARP2INT(phy_id)));
+ 
+	asd_hwi_swb_write_dword(asd, LmARP2CTL(phy_id), 
+		asd_hwi_swb_read_dword(asd, LmARP2CTL(phy_id)) | BREAKEN0);
+	
+	asd_hwi_swb_write_dword(asd, LmARP2INTEN(phy_id), 0x1);
+
+	asd_hwi_unpause_lseq(asd, 0x1);
+}
+
+#endif /* ASD_DEBUG */

