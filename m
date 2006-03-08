From: akpm@osdl.org
Subject: [patch 20/28] drivers/scsi/FlashPoint.c: don't use parenthesis with "return"
Date: Wed, 08 Mar 2006 00:14:37 -0800
Message-ID: <200603080816.k288GQbt002216@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:39084 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932498AbWCHIQb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 03:16:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, adobriyan@gmail.com


From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/FlashPoint.c |  130 ++++++++++++++++++------------------
 1 files changed, 65 insertions(+), 65 deletions(-)

diff -puN drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-dont-use-parenthesis-with-return drivers/scsi/FlashPoint.c
--- 25/drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-dont-use-parenthesis-with-return	Mon Feb  6 14:50:24 2006
+++ 25-akpm/drivers/scsi/FlashPoint.c	Mon Feb  6 14:50:24 2006
@@ -945,16 +945,16 @@ static int FlashPoint_ProbeHostAdapter(s
 	ioport = pCardInfo->si_baseaddr;
 
 	if (RD_HARPOON(ioport + hp_vendor_id_0) != ORION_VEND_0)
-		return ((int)FAILURE);
+		return (int)FAILURE;
 
 	if ((RD_HARPOON(ioport + hp_vendor_id_1) != ORION_VEND_1))
-		return ((int)FAILURE);
+		return (int)FAILURE;
 
 	if ((RD_HARPOON(ioport + hp_device_id_0) != ORION_DEV_0))
-		return ((int)FAILURE);
+		return (int)FAILURE;
 
 	if ((RD_HARPOON(ioport + hp_device_id_1) != ORION_DEV_1))
-		return ((int)FAILURE);
+		return (int)FAILURE;
 
 	if (RD_HARPOON(ioport + hp_rev_num) != 0x0f) {
 
@@ -964,7 +964,7 @@ static int FlashPoint_ProbeHostAdapter(s
 	device. */
 
 		if (RD_HARPOON(ioport + hp_sub_device_id_0) & 0x0f)
-			return ((int)FAILURE);
+			return (int)FAILURE;
 	}
 
 	if (first_time) {
@@ -986,7 +986,7 @@ static int FlashPoint_ProbeHostAdapter(s
 				pCurrNvRam->niBaseAddr = ioport;
 				FPT_RNVRamData(pCurrNvRam);
 			} else
-				return ((int)FAILURE);
+				return (int)FAILURE;
 		}
 	} else
 		pCurrNvRam = NULL;
@@ -1194,7 +1194,7 @@ static int FlashPoint_ProbeHostAdapter(s
 
 	pCardInfo->si_present = 0x01;
 
-	return (0);
+	return 0;
 }
 
 /*---------------------------------------------------------------------
@@ -1220,7 +1220,7 @@ static unsigned long FlashPoint_Hardware
 
 		if (thisCard == MAX_CARDS) {
 
-			return (FAILURE);
+			return FAILURE;
 		}
 
 		if (FPT_BL_Card[thisCard].ioPort == ioport) {
@@ -1388,7 +1388,7 @@ static unsigned long FlashPoint_Hardware
 		   (unsigned char)(RD_HARPOON((ioport + hp_semaphore)) |
 				   SCCB_MGR_PRESENT));
 
-	return ((unsigned long)CurrCard);
+	return (unsigned long)CurrCard;
 }
 
 static void FlashPoint_ReleaseHostAdapter(unsigned long pCurrCard)
@@ -1460,7 +1460,7 @@ static void FPT_RNVRamData(struct nvram_
 static unsigned char FPT_RdStack(unsigned long portBase, unsigned char index)
 {
 	WR_HARPOON(portBase + hp_stack_addr, index);
-	return (RD_HARPOON(portBase + hp_stack_data));
+	return RD_HARPOON(portBase + hp_stack_data);
 }
 
 static void FPT_WrStack(unsigned long portBase, unsigned char index,
@@ -1473,14 +1473,14 @@ static void FPT_WrStack(unsigned long po
 static unsigned char FPT_ChkIfChipInitialized(unsigned long ioPort)
 {
 	if ((RD_HARPOON(ioPort + hp_arb_id) & 0x0f) != FPT_RdStack(ioPort, 4))
-		return (0);
+		return 0;
 	if ((RD_HARPOON(ioPort + hp_clkctrl_0) & CLKCTRL_DEFAULT)
 	    != CLKCTRL_DEFAULT)
-		return (0);
+		return 0;
 	if ((RD_HARPOON(ioPort + hp_seltimeout) == TO_250ms) ||
 	    (RD_HARPOON(ioPort + hp_seltimeout) == TO_290ms))
-		return (1);
-	return (0);
+		return 1;
+	return 0;
 
 }
 
@@ -1642,14 +1642,14 @@ static int FlashPoint_AbortCCB(unsigned 
 			callback = p_Sccb->SccbCallback;
 			callback(p_Sccb);
 
-			return (0);
+			return 0;
 		}
 
 		else {
 			if (((struct sccb_card *)pCurrCard)->currentSCCB ==
 			    p_Sccb) {
 				p_Sccb->SccbStatus = SCCB_ABORT;
-				return (0);
+				return 0;
 
 			}
 
@@ -1691,7 +1691,7 @@ static int FlashPoint_AbortCCB(unsigned 
 						}
 					}
 					MENABLE_INT(ioport);
-					return (0);
+					return 0;
 				} else {
 					currTar_Info =
 					    &FPT_sccbMgrTbl[thisCard][p_Sccb->
@@ -1702,13 +1702,13 @@ static int FlashPoint_AbortCCB(unsigned 
 						      LunDiscQ_Idx[p_Sccb->Lun]]
 					    == p_Sccb) {
 						p_Sccb->SccbStatus = SCCB_ABORT;
-						return (0);
+						return 0;
 					}
 				}
 			}
 		}
 	}
-	return (-1);
+	return -1;
 }
 
 /*---------------------------------------------------------------------
@@ -1726,12 +1726,12 @@ static unsigned char FlashPoint_Interrup
 	ioport = ((struct sccb_card *)pCurrCard)->ioPort;
 
 	if (RD_HARPOON(ioport + hp_int_status) & INT_ASSERTED) {
-		return (1);
+		return 1;
 	}
 
 	else
 
-		return (0);
+		return 0;
 }
 
 /*---------------------------------------------------------------------
@@ -1783,7 +1783,7 @@ static int FlashPoint_HandleInterrupt(un
 			if (result) {
 
 				MENABLE_INT(ioport);
-				return (result);
+				return result;
 			}
 		}
 
@@ -1997,7 +1997,7 @@ static int FlashPoint_HandleInterrupt(un
 
 	MENABLE_INT(ioport);
 
-	return (0);
+	return 0;
 }
 
 /*---------------------------------------------------------------------
@@ -2092,7 +2092,7 @@ static unsigned char FPT_SccbMgr_bad_isr
 
 		FPT_scini(p_card, pCurrCard->ourId, 0);
 
-		return (0xFF);
+		return 0xFF;
 	}
 
 	else if (p_int & FIFO) {
@@ -2150,7 +2150,7 @@ static unsigned char FPT_SccbMgr_bad_isr
 		WRW_HARPOON((p_port + hp_intstat), SCAM_SEL);
 	}
 
-	return (0x00);
+	return 0x00;
 }
 
 /*---------------------------------------------------------------------
@@ -2295,12 +2295,12 @@ static unsigned char FPT_sfm(unsigned lo
 			}
 			if (TimeOutLoop > 20000) {
 				WRW_HARPOON((port + hp_intstat), PARITY);
-				return (message);
+				return message;
 			}
 			if ((RD_HARPOON(port + hp_scsisig) & S_SCSI_PHZ) !=
 			    S_MSGI_PH) {
 				WRW_HARPOON((port + hp_intstat), PARITY);
-				return (message);
+				return message;
 			}
 			WR_HARPOON(port + hp_portctrl_0, SCSI_PORT);
 
@@ -2315,7 +2315,7 @@ static unsigned char FPT_sfm(unsigned lo
 	WR_HARPOON(port + hp_xferstat, 0);
 	WR_HARPOON(port + hp_fiforead, 0);
 	WR_HARPOON(port + hp_fifowrite, 0);
-	return (message);
+	return message;
 }
 
 /*---------------------------------------------------------------------
@@ -3219,14 +3219,14 @@ static unsigned char FPT_sisyncn(unsigne
 				   (AUTO_IMMED + CMD_ONLY_STRT));
 		}
 
-		return (1);
+		return 1;
 	}
 
 	else {
 
 		currTar_Info->TarStatus |= (unsigned char)SYNC_SUPPORTED;
 		currTar_Info->TarEEValue &= ~EE_SYNC_MASK;
-		return (0);
+		return 0;
 	}
 }
 
@@ -3431,7 +3431,7 @@ static unsigned char FPT_siwidn(unsigned
 					    ~(unsigned char)TAR_WIDE_MASK) |
 					   (unsigned char)WIDE_ENABLED);
 
-		return (1);
+		return 1;
 	}
 
 	else {
@@ -3441,7 +3441,7 @@ static unsigned char FPT_siwidn(unsigned
 					   WIDE_NEGOCIATED);
 
 		currTar_Info->TarEEValue &= ~EE_WIDE_SCSI;
-		return (0);
+		return 0;
 	}
 }
 
@@ -5155,11 +5155,11 @@ static unsigned char FPT_busMstrTimeOut(
 	RD_HARPOON(p_port + hp_int_status);	/*Clear command complete */
 
 	if (RD_HARPOON(p_port + hp_ext_status) & BM_CMD_BUSY) {
-		return (1);
+		return 1;
 	}
 
 	else {
-		return (0);
+		return 0;
 	}
 }
 
@@ -5721,10 +5721,10 @@ static int FPT_scarb(unsigned long p_por
 		}
 
 		if (RD_HARPOON(p_port + hp_scsisig) & SCSI_SEL)
-			return (0);
+			return 0;
 
 		if (RD_HARPOON(p_port + hp_scsidata_0) != 00)
-			return (0);
+			return 0;
 
 		WR_HARPOON(p_port + hp_scsisig,
 			   (RD_HARPOON(p_port + hp_scsisig) | SCSI_BSY));
@@ -5734,7 +5734,7 @@ static int FPT_scarb(unsigned long p_por
 			WR_HARPOON(p_port + hp_scsisig,
 				   (RD_HARPOON(p_port + hp_scsisig) &
 				    ~SCSI_BSY));
-			return (0);
+			return 0;
 		}
 
 		WR_HARPOON(p_port + hp_scsisig,
@@ -5745,7 +5745,7 @@ static int FPT_scarb(unsigned long p_por
 			WR_HARPOON(p_port + hp_scsisig,
 				   (RD_HARPOON(p_port + hp_scsisig) &
 				    ~(SCSI_BSY | SCSI_SEL)));
-			return (0);
+			return 0;
 		}
 	}
 
@@ -5764,7 +5764,7 @@ static int FPT_scarb(unsigned long p_por
 
 	FPT_Wait(p_port, TO_250ms);
 
-	return (1);
+	return 1;
 }
 
 /*---------------------------------------------------------------------
@@ -5956,7 +5956,7 @@ static unsigned char FPT_scxferc(unsigne
 
 	FPT_scwirod(p_port, BIT(6));	/*Wait for DB6 to be released. */
 
-	return (ret_data);
+	return ret_data;
 }
 
 /*---------------------------------------------------------------------
@@ -5994,22 +5994,22 @@ static unsigned char FPT_scsendi(unsigne
 			}
 
 			if ((ret_data & 0x1C) == 0x10)
-				return (0x00);	/*End of isolation stage, we won! */
+				return 0x00;	/*End of isolation stage, we won! */
 
 			if (ret_data & 0x1C)
-				return (0xFF);
+				return 0xFF;
 
 			if ((defer) && (!(ret_data & 0x1F)))
-				return (0x01);	/*End of isolation stage, we lost. */
+				return 0x01;	/*End of isolation stage, we lost. */
 
 		}		/*bit loop */
 
 	}			/*byte loop */
 
 	if (defer)
-		return (0x01);	/*We lost */
+		return 0x01;	/*We lost */
 	else
-		return (0);	/*We WON! Yeeessss! */
+		return 0;	/*We WON! Yeeessss! */
 }
 
 /*---------------------------------------------------------------------
@@ -6034,7 +6034,7 @@ static unsigned char FPT_sciso(unsigned 
 			ret_data = FPT_scxferc(p_port, 0);
 
 			if (ret_data & 0xFC)
-				return (0xFF);
+				return 0xFF;
 
 			else {
 
@@ -6056,9 +6056,9 @@ static unsigned char FPT_sciso(unsigned 
 				}
 */
 				if (byte_cnt)
-					return (0x00);
+					return 0x00;
 				else
-					return (0xFF);
+					return 0xFF;
 			}
 
 		}		/*bit loop */
@@ -6067,7 +6067,7 @@ static unsigned char FPT_sciso(unsigned 
 
 	}			/*byte loop */
 
-	return (0);
+	return 0;
 }
 
 /*---------------------------------------------------------------------
@@ -6142,10 +6142,10 @@ static unsigned char FPT_scvalq(unsigned
 	}
 
 	if (p_quintet & 0x18)
-		return (0);
+		return 0;
 
 	else
-		return (1);
+		return 1;
 }
 
 /*---------------------------------------------------------------------
@@ -6209,7 +6209,7 @@ static unsigned char FPT_scsell(unsigned
 			   (RD_HARPOON(p_port + hp_page_ctrl) &
 			    ~G_INT_DISABLE));
 
-		return (0);	/*No legacy device */
+		return 0;	/*No legacy device */
 	}
 
 	else {
@@ -6228,7 +6228,7 @@ static unsigned char FPT_scsell(unsigned
 			   (RD_HARPOON(p_port + hp_page_ctrl) &
 			    ~G_INT_DISABLE));
 
-		return (1);	/*Found one of them oldies! */
+		return 1;	/*Found one of them oldies! */
 	}
 }
 
@@ -6342,7 +6342,7 @@ static unsigned char FPT_scmachid(unsign
 
 		if (match) {
 			FPT_scamInfo[i].state = ID_ASSIGNED;
-			return (i);
+			return i;
 		}
 
 	}
@@ -6372,7 +6372,7 @@ static unsigned char FPT_scmachid(unsign
 			if (FPT_BL_Card[p_card].pNvRamInfo == NULL)
 				FPT_BL_Card[p_card].globalFlags |=
 				    F_UPDATE_EEPROM;
-			return (match);
+			return match;
 
 		}
 
@@ -6387,7 +6387,7 @@ static unsigned char FPT_scmachid(unsign
 	}
 
 	if (p_id_string[0] & BIT(7)) {
-		return (CLR_PRIORITY);
+		return CLR_PRIORITY;
 	}
 
 	if (p_id_string[0] & BIT(5))
@@ -6416,7 +6416,7 @@ static unsigned char FPT_scmachid(unsign
 			if (FPT_BL_Card[p_card].pNvRamInfo == NULL)
 				FPT_BL_Card[p_card].globalFlags |=
 				    F_UPDATE_EEPROM;
-			return (match);
+			return match;
 
 		}
 
@@ -6430,7 +6430,7 @@ static unsigned char FPT_scmachid(unsign
 		}
 	}
 
-	return (NO_ID_AVAIL);
+	return NO_ID_AVAIL;
 }
 
 /*---------------------------------------------------------------------
@@ -7181,7 +7181,7 @@ static unsigned char FPT_queueFindSccb(s
 
 			currTar_Info->TarSelQ_Cnt--;
 
-			return (1);
+			return 1;
 		}
 
 		else {
@@ -7189,7 +7189,7 @@ static unsigned char FPT_queueFindSccb(s
 		}
 	}
 
-	return (0);
+	return 0;
 
 }
 
@@ -7416,14 +7416,14 @@ static unsigned short FPT_utilEERead(uns
 		ee_data2 = FPT_utilEEReadOrg(p_port, ee_addr);
 
 		if (ee_data1 == ee_data2)
-			return (ee_data1);
+			return ee_data1;
 
 		ee_data1 = ee_data2;
 		i++;
 
 	} while (i < 4);
 
-	return (ee_data1);
+	return ee_data1;
 }
 
 /*---------------------------------------------------------------------
@@ -7471,7 +7471,7 @@ static unsigned short FPT_utilEEReadOrg(
 	WR_HARPOON(p_port + hp_ee_ctrl, (ee_value | SEE_MS));	/*Turn off CS */
 	WR_HARPOON(p_port + hp_ee_ctrl, ee_value);	/*Turn off Master Select */
 
-	return (ee_data);
+	return ee_data;
 }
 
 /*---------------------------------------------------------------------
@@ -7559,7 +7559,7 @@ static unsigned short FPT_CalcCrc16(unsi
 			ch >>= 1;
 		}
 	}
-	return (crc);
+	return crc;
 }
 
 static unsigned char FPT_CalcLrc(unsigned char buffer[])
@@ -7569,7 +7569,7 @@ static unsigned char FPT_CalcLrc(unsigne
 	lrc = 0;
 	for (i = 0; i < ID_STRING_LENGTH; i++)
 		lrc ^= buffer[i];
-	return (lrc);
+	return lrc;
 }
 
 /*
_
