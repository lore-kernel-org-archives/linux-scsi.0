From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [PATCH 2.4 1/2] Fix cpqfc::cpqfcTSPutLinkQue()
Date: Mon, 2 Jan 2006 12:56:07 +0100
Message-ID: <200601021256.07979@bilbo.math.uni-mannheim.de>
References: <200601021244.40636@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:42143 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1751020AbWABMGx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jan 2006 07:06:53 -0500
Received: from mp-pc92.informatik.uni-mannheim.de ([::ffff:134.155.64.118]) (auth=eike-kernel@sf-tec.de)
	by mail.sf-mail.de (Qsmtpd 0.9) with (DHE-RSA-AES256-SHA encrypted) ESMTPSA
	for <linux-scsi@vger.kernel.org>; Mon, 02 Jan 2006 13:06:51 +0100
In-Reply-To: <200601021244.40636@bilbo.math.uni-mannheim.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>

The cpqfcTSPutLinkQue() takes a void* as third argument. Depending on the 
second argument either a pointer to a struct or to a single integer is passed. 
In any case 48 DWORDs (192 bytes) of memory are copied. The integer is always 
located on the stack but nevertheless noone should access memory he doesn't 
own. The struct copied has a size of only 38 DWORDs, so the copied memory here 
is also something that does not belong there.

This patch changes the type of the third argument to be TachFCHDR_GCMND* and 
introduces a new, fourth argument of type integer. Now only the really needed 
memory is copied. The remaining bytes of the destination buffer are left 
on their previous (random) values, but they are ignored anyway. If not, this 
would have lead to problems when random values from the stack had been copied 
there.

From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

diff -aupr a/drivers/scsi/cpqfcTScontrol.c b/drivers/scsi/cpqfcTScontrol.c
--- a/drivers/scsi/cpqfcTScontrol.c	2005-12-27 16:53:18.000000000 +0100
+++ b/drivers/scsi/cpqfcTScontrol.c	2005-12-27 17:30:30.000000000 +0100
@@ -645,8 +645,8 @@ int CpqTsProcessIMQEntry(void *host)
 	u16 i, RPCset, DPCset;
 	u32 x_ID;
 	u32 ulBuff, dwStatus;
-	TachFCHDR_GCMND *fchs;
 	u32 ulFibreFrame[2048 / 4];	// max number of DWORDS in incoming Fibre Frame
+	TachFCHDR_GCMND *fchs = (TachFCHDR_GCMND *) ulFibreFrame;	// cast to examine IB frame
 	u8 ucInboundMessageType;	// Inbound CM, dword 3 "type" field
 
 	ENTER("ProcessIMQEntry");
@@ -743,11 +743,11 @@ int CpqTsProcessIMQEntry(void *host)
 							if (!(Exchanges->fcExchange[x_ID].status & DEVICE_REMOVED)) {
 								// presumes device is still there: send ABTS.
 
-								cpqfcTSPutLinkQue(cpqfcHBAdata, BLS_ABTS, &x_ID);
+								cpqfcTSPutLinkQue(cpqfcHBAdata, BLS_ABTS, NULL, x_ID);
 							}
 						} else	// Abort all other errors
 						{
-							cpqfcTSPutLinkQue(cpqfcHBAdata, BLS_ABTS, &x_ID);
+							cpqfcTSPutLinkQue(cpqfcHBAdata, BLS_ABTS, NULL, x_ID);
 						}
 
 						// if the HPE bit is set, we have to CLose the LOOP
@@ -864,7 +864,6 @@ int CpqTsProcessIMQEntry(void *host)
 			// (i.e., Worker)
 
 			if (ucInboundMessageType == 1) {
-				fchs = (TachFCHDR_GCMND *) ulFibreFrame;	// cast to examine IB frame
 				// don't fill up our Q with garbage - only accept FCP-CMND  
 				// or XRDY frames
 				if ((fchs->d_id & 0xFF000000) == 0x06000000)	// CMND
@@ -900,7 +899,7 @@ int CpqTsProcessIMQEntry(void *host)
 							Exchanges->fcExchange[x_ID].status |= SFQ_FRAME;
 
 							// presumes device is still there: send ABTS.
-							cpqfcTSPutLinkQue(cpqfcHBAdata, BLS_ABTS, &x_ID);
+							cpqfcTSPutLinkQue(cpqfcHBAdata, BLS_ABTS, NULL, x_ID);
 							break;	// done
 						}
 					}
@@ -910,7 +909,7 @@ int CpqTsProcessIMQEntry(void *host)
 
 			else if (ucInboundMessageType == 3) {
 				// FC Link Service frames (e.g. PLOGI, ACC) come in here.  
-				cpqfcTSPutLinkQue(cpqfcHBAdata, SFQ_UNKNOWN, ulFibreFrame);
+				cpqfcTSPutLinkQue(cpqfcHBAdata, SFQ_UNKNOWN, fchs, 0);
 
 			}
 
@@ -1278,7 +1277,7 @@ int CpqTsProcessIMQEntry(void *host)
 //        printk("skipping LINKACTIVE post\n");
 
 					} else
-						cpqfcTSPutLinkQue(cpqfcHBAdata, LINKACTIVE, ulFibreFrame);
+						cpqfcTSPutLinkQue(cpqfcHBAdata, LINKACTIVE, fchs, 0);
 				}
 
 
diff -aupr a/drivers/scsi/cpqfcTSinit.c b/drivers/scsi/cpqfcTSinit.c
--- a/drivers/scsi/cpqfcTSinit.c	2005-12-27 16:53:18.000000000 +0100
+++ b/drivers/scsi/cpqfcTSinit.c	2005-12-27 17:19:46.000000000 +0100
@@ -1295,7 +1295,7 @@ int cpqfcTS_eh_abort(Scsi_Cmnd * Cmnd)
 			// upper layers, we can't make future reference to any of it's 
 			// fields (e.g the Nexus).
 
-			cpqfcTSPutLinkQue(cpqfcHBAdata, BLS_ABTS, &i);
+			cpqfcTSPutLinkQue(cpqfcHBAdata, BLS_ABTS, NULL, i);
 
 			break;
 		}
diff -aupr a/drivers/scsi/cpqfcTSstructs.h b/drivers/scsi/cpqfcTSstructs.h
--- a/drivers/scsi/cpqfcTSstructs.h	2005-12-27 16:53:18.000000000 +0100
+++ b/drivers/scsi/cpqfcTSstructs.h	2005-12-27 17:18:58.000000000 +0100
@@ -955,7 +955,7 @@ PFC_LOGGEDIN_PORT fcFindLoggedInPort(PTA
 				     __u8 wwn[8],	// search linked list for WWN, or...
 				     PFC_LOGGEDIN_PORT * pLastLoggedInPort);
 
-void cpqfcTSPutLinkQue(CPQFCHBA * cpqfcHBAdata, int Type, void *QueContent);
+void cpqfcTSPutLinkQue(CPQFCHBA * dev, int Type, TachFCHDR_GCMND *fchs, u32 errcode);
 
 void fcPutScsiQue(CPQFCHBA * cpqfcHBAdata, int Type, void *QueContent);
 
diff -aupr a/drivers/scsi/cpqfcTSworker.c b/drivers/scsi/cpqfcTSworker.c
--- a/drivers/scsi/cpqfcTSworker.c	2005-12-27 16:53:18.000000000 +0100
+++ b/drivers/scsi/cpqfcTSworker.c	2005-12-27 17:14:31.000000000 +0100
@@ -700,7 +700,7 @@ void cpqfcTS_WorkTask(struct Scsi_Host *
 // This circular Q works like Tachyon's que - the producer points to the next
 // (unused) entry.  Called by Interrupt handler, WorkerThread, Timer
 // sputlinkq
-void cpqfcTSPutLinkQue(CPQFCHBA * dev, int Type, void *QueContent)
+void cpqfcTSPutLinkQue(CPQFCHBA * dev, int Type, TachFCHDR_GCMND *fchs, u32 errcode)
 {
 	PTACHYON fcChip = &dev->fcChip;
 //	FC_EXCHANGES *Exchanges = fcChip->Exchanges;
@@ -766,7 +766,11 @@ void cpqfcTSPutLinkQue(CPQFCHBA * dev, i
 		}
 		// OK, add the Q'd item...
 		fcLQ->Qitem[fcLQ->producer].Type = Type;
-		memcpy(fcLQ->Qitem[fcLQ->producer].ulBuff, QueContent, sizeof(fcLQ->Qitem[fcLQ->producer].ulBuff));
+		if (!fchs) {
+			fcLQ->Qitem[fcLQ->producer].ulBuff[0] = errcode;
+		} else {
+			memcpy(fcLQ->Qitem[fcLQ->producer].ulBuff, fchs, sizeof(fchs));
+		}
 		fcLQ->producer = ndx;	// increment Que producer
 		// set semaphore to wake up Kernel (worker) thread
 		up(dev->fcQueReady);
@@ -996,7 +1000,7 @@ void cpqfcTSTerminateExchange(CPQFCHBA *
 			if (ScsiNexus == NULL)	// our HBA changed - term. all
 			{
 				Exchanges->fcExchange[x_ID].status = TerminateStatus;
-				cpqfcTSPutLinkQue(dev, BLS_ABTS, &x_ID);
+				cpqfcTSPutLinkQue(dev, BLS_ABTS, NULL, x_ID);
 			} else {
 				// If a device, according to WWN, has been removed, it's
 				// port_id may be used by another working device, so we
@@ -1006,7 +1010,7 @@ void cpqfcTSTerminateExchange(CPQFCHBA *
 					if ((Exchanges->fcExchange[x_ID].Cmnd->target == ScsiNexus->target)
 					    && (Exchanges->fcExchange[x_ID].Cmnd->channel == ScsiNexus->channel)) {
 						Exchanges->fcExchange[x_ID].status = TerminateStatus;
-						cpqfcTSPutLinkQue(dev, BLS_ABTS, &x_ID);	// timed-out
+						cpqfcTSPutLinkQue(dev, BLS_ABTS, NULL, x_ID);	// timed-out
 					}
 				}
 				// (in case we ever need it...)
@@ -1061,7 +1065,7 @@ static void ProcessELS_Request(CPQFCHBA 
 						SetLoginFields(pLoggedInPort, fchs, 1, 0);
 						// send 'ACC' reply 
 						cpqfcTSPutLinkQue(dev, ELS_PLOGI_ACC,	// (PDISC same as PLOGI ACC)
-								  fchs);
+								  fchs, 0);
 						// OK to resume I/O...
 					} else {
 						printk("Not expecting PDISC (pdisc=0)\n");
@@ -1106,7 +1110,7 @@ static void ProcessELS_Request(CPQFCHBA 
 				port_id = fchs->s_id & 0xFFFFFF;
 			}
 			fchs->reserved = ls_reject_code;	// borrow this (unused) field
-			cpqfcTSPutLinkQue(dev, ELS_RJT, fchs);
+			cpqfcTSPutLinkQue(dev, ELS_RJT, fchs, 0);
 		}
 		break;
 
@@ -1147,7 +1151,7 @@ static void ProcessELS_Request(CPQFCHBA 
 				SetLoginFields(pLoggedInPort, fchs, 0, 0);
 				// send 'ACC' reply 
 				cpqfcTSPutLinkQue(dev, ELS_PLOGI_ACC,	// (PDISC same as PLOGI ACC)
-						  fchs);
+						  fchs, 0);
 			}
 		}
 		else		// Payload unacceptable
@@ -1165,7 +1169,7 @@ static void ProcessELS_Request(CPQFCHBA 
 			fchs->reserved = ls_reject_code;	// borrow this (unused) field
 
 			// send 'RJT' reply 
-			cpqfcTSPutLinkQue(dev, ELS_RJT, fchs);
+			cpqfcTSPutLinkQue(dev, ELS_RJT, fchs, 0);
 		}
 		// terminate any exchanges with this device...
 		if (pLoggedInPort) {
@@ -1195,7 +1199,7 @@ static void ProcessELS_Request(CPQFCHBA 
 						// yes, we expected the PRLI ACC  (not PDISC; not Originator)
 						SetLoginFields(pLoggedInPort, fchs, 0, 0);
 						// Q an ACCept Reply
-						cpqfcTSPutLinkQue(dev, ELS_PRLI_ACC, fchs);
+						cpqfcTSPutLinkQue(dev, ELS_PRLI_ACC, fchs, 0);
 						NeedReject = 0;
 					} else {
 						// huh?
@@ -1215,7 +1219,7 @@ static void ProcessELS_Request(CPQFCHBA 
 				// Q a ReJecT Reply with reason code
 				fchs->reserved = ls_reject_code;
 				cpqfcTSPutLinkQue(dev, ELS_RJT,	// Q Type
-						  fchs);
+						  fchs, 0);
 			}
 		}
 		break;
@@ -1241,7 +1245,7 @@ static void ProcessELS_Request(CPQFCHBA 
 			{
 				// Q an ACC reply 
 				cpqfcTSPutLinkQue(dev, ELS_LOGO_ACC,	// Q Type
-						  fchs);	// device to respond to
+						  fchs, 0);	// device to respond to
 				// set login struct fields (LOGO_counter increment)
 				SetLoginFields(pLoggedInPort, fchs, 0, 0);
 				// are we an Initiator?
@@ -1256,7 +1260,7 @@ static void ProcessELS_Request(CPQFCHBA 
 					} else if (pLoggedInPort->LOGO_counter <= 3) {
 						// try (another) login (PLOGI request)
 						cpqfcTSPutLinkQue(dev, ELS_PLOGI,	// Q Type
-								  fchs);
+								  fchs, 0);
 						// Terminate I/O with "retry" potential
 						cpqfcTSTerminateExchange(dev, &pLoggedInPort->ScsiNexus, PORTID_CHANGED);
 					} else {
@@ -1275,7 +1279,7 @@ static void ProcessELS_Request(CPQFCHBA 
 				// Q a ReJecT Reply with reason code
 				fchs->reserved = ls_reject_code;
 				cpqfcTSPutLinkQue(dev, ELS_RJT,	// Q Type
-						  fchs);
+						  fchs, 0);
 			}
 		}
 		break;
@@ -1304,13 +1308,13 @@ static void ProcessELS_Request(CPQFCHBA 
 				fchs->reserved = LS_RJT_REASON(UNABLE_TO_PERFORM, 0);
 
 				cpqfcTSPutLinkQue(dev, ELS_RJT,	// Q Type
-						  fchs);
+						  fchs, 0);
 
 				break;
 			} else	// Accept the command
 			{
 				cpqfcTSPutLinkQue(dev, ELS_ACC,	// Q Type
-						  fchs);
+						  fchs, 0);
 			}
 
 			// Check the "address format" to determine action.
@@ -1327,7 +1331,7 @@ static void ProcessELS_Request(CPQFCHBA 
 					// For example, "port_id" 0x201300 
 					// OK, let's try a Name Service Request (Query)
 					fchs->s_id = 0xFFFFFC;	// Name Server Address
-					cpqfcTSPutLinkQue(dev, FCS_NSR, fchs);
+					cpqfcTSPutLinkQue(dev, FCS_NSR, fchs, 0);
 					break;
 				default:	// huh? new value on version change?
 					break;
@@ -1339,7 +1343,7 @@ static void ProcessELS_Request(CPQFCHBA 
 		// don't support this request (yet)
 		// set reject reason code 
 		fchs->reserved = LS_RJT_REASON(UNABLE_TO_PERFORM, REQUEST_NOT_SUPPORTED);
-		cpqfcTSPutLinkQue(dev, ELS_RJT,	fchs);	// Q Type
+		cpqfcTSPutLinkQue(dev, ELS_RJT,	fchs, 0);	// Q Type
 		break;
 	}
 }
@@ -1420,12 +1424,12 @@ static void ProcessELS_Reply(CPQFCHBA * 
 			if (fchs->s_id == 0xFFFFFC) {
 				// PLOGI ACC was a Fabric response... issue SCR
 				fchs->s_id = 0xFFFFFD;	// address for SCR
-				cpqfcTSPutLinkQue(dev, ELS_SCR, fchs);
+				cpqfcTSPutLinkQue(dev, ELS_SCR, fchs, 0);
 			}
 			else {
 				// Now we need a PRLI to enable FCP-SCSI operation
 				// set flags and Q up a ELS_PRLI
-				cpqfcTSPutLinkQue(dev, ELS_PRLI, fchs);
+				cpqfcTSPutLinkQue(dev, ELS_PRLI, fchs, 0);
 			}
 		} else {
 			// login payload unacceptable - reason in ls_reject_code
@@ -1476,7 +1480,7 @@ static void ProcessELS_Reply(CPQFCHBA * 
 								fchs->reserved = i;	// copy ExchangeID
 //						                printk(" *Q x_ID %Xh after PDISC* ",i);
 
-								cpqfcTSPutLinkQue(dev, EXCHANGE_QUEUED, fchs);
+								cpqfcTSPutLinkQue(dev, EXCHANGE_QUEUED, fchs, 0);
 							}
 						}
 						// Complete commands Q'd while we were waiting for Login
@@ -1499,7 +1503,7 @@ static void ProcessELS_Reply(CPQFCHBA * 
 				// terminate any I/O to this port, and Q a PLOGI
 				if (pLoggedInPort)	// FC device previously known?
 				{
-					cpqfcTSPutLinkQue(dev, ELS_LOGO, fchs);	// Qtype has port_id to send to 
+					cpqfcTSPutLinkQue(dev, ELS_LOGO, fchs, 0);	// Qtype has port_id to send to 
 					// There are a variety of error scenarios which can result
 					// in PDISC failure, so as a catchall, add the check for
 					// duplicate port_id.
@@ -1512,7 +1516,7 @@ static void ProcessELS_Reply(CPQFCHBA * 
 
 					cpqfcTSTerminateExchange(dev, &pLoggedInPort->ScsiNexus, PORTID_CHANGED);
 				}
-				cpqfcTSPutLinkQue(dev, ELS_PLOGI, fchs);
+				cpqfcTSPutLinkQue(dev, ELS_PLOGI, fchs, 0);
 			}
 		} else {
 			// login payload unacceptable - reason in ls_reject_code
@@ -1542,7 +1546,7 @@ static void ProcessELS_Reply(CPQFCHBA * 
 				SetLoginFields(pLoggedInPort, fchs, 0, 1);
 				// OK, let's send a REPORT_LUNS command to determine
 				// whether VSA or PDA FCP-LUN addressing is used.
-				cpqfcTSPutLinkQue(dev, SCSI_REPORT_LUNS, fchs);
+				cpqfcTSPutLinkQue(dev, SCSI_REPORT_LUNS, fchs, 0);
 				// It's possible that a device we were talking to changed 
 				// port_id, and has logged back in.  This function ensures
 				// that I/O will resume.
@@ -1568,7 +1572,7 @@ static void ProcessELS_Reply(CPQFCHBA * 
 
 		// now send out a PLOGI to the well known port_id 0xFFFFFC
 		fchs->s_id = 0xFFFFFC;
-		cpqfcTSPutLinkQue(dev, ELS_PLOGI, fchs);
+		cpqfcTSPutLinkQue(dev, ELS_PLOGI, fchs, 0);
 		break;
 
 
@@ -1580,7 +1584,7 @@ static void ProcessELS_Reply(CPQFCHBA * 
 		// now we can issue Name Service Request to find any
 		// Fabric-connected devices we might want to login to.
 		fchs->s_id = 0xFFFFFC;	// Name Server Address
-		cpqfcTSPutLinkQue(dev, FCS_NSR, fchs);
+		cpqfcTSPutLinkQue(dev, FCS_NSR, fchs, 0);
 		break;
 
 	default:
@@ -1731,7 +1735,7 @@ static void AnalyzeIncomingFrame(CPQFCHB
 					memcpy(fcChip->LILPmap, &fchs->pl[1], 32 * 4);	// 32 DWORDs
 					fcChip->Options.LILPin = 1;	// our LILPmap is valid!
 					// now post to make Port Discovery happen...
-					cpqfcTSPutLinkQue(dev, LINKACTIVE, fchs);
+					cpqfcTSPutLinkQue(dev, LINKACTIVE, fchs, 0);
 				}
 			}
 		}
@@ -1773,7 +1777,7 @@ static void AnalyzeIncomingFrame(CPQFCHB
 							fchs->ox_rx_id = Exchanges->fcExchange[ExchangeID].fchs.ox_rx_id;
 
 							cpqfcTSPutLinkQue(dev, BLS_ABTS_ACC,	// Q Type 
-									  fchs);	// void QueContent
+									  fchs, 0);	// void QueContent
 							AbortAccept = 1;
 							printk("ACCepting ABTS for x_ID %8.8Xh, SEST pair %8.8Xh\n", fchs->ox_rx_id, Exchanges->fcExchange[ExchangeID].fchs.ox_rx_id);
 							break;	// ABTS can affect only ONE exchange -exit loop
@@ -2169,7 +2173,7 @@ static void ScsiReportLunsDone(Scsi_Cmnd
 				// context is "reply to source".
 
 				fchs->s_id = fchs->d_id;	// (temporarily re-use the struct)
-				cpqfcTSPutLinkQue(dev, SCSI_REPORT_LUNS, fchs);
+				cpqfcTSPutLinkQue(dev, SCSI_REPORT_LUNS, fchs, 0);
 			}
 		} else		// probably, the device doesn't support Report Luns
 			pLoggedInPort->ScsiNexus.VolumeSetAddressing = 0;
@@ -2538,7 +2542,7 @@ void cpqfcTSheartbeat(unsigned long ptr)
 
 						// We expect the WorkerThread to change the xchng type to
 						// abort and set appropriate timeout.
-						cpqfcTSPutLinkQue(dev, BLS_ABTS, &i);	// timed-out
+						cpqfcTSPutLinkQue(dev, BLS_ABTS, NULL, i);	// timed-out
 					}
 				}
 			} else	// time not expired...
