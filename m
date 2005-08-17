From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [PATCH 2.6.13-rc6] fix copying stack memory in cpqfcTScontrol.c::cpqfcTSPutLinkQue()
Date: Wed, 17 Aug 2005 10:57:51 +0200
Message-ID: <200508171057.51992@bilbo.math.uni-mannheim.de>
References: <200508051202.07091@bilbo.math.uni-mannheim.de> <200508161820.57817@bilbo.math.uni-mannheim.de> <200508161909.20196@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:9663 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1750991AbVHQI4R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Aug 2005 04:56:17 -0400
Received: from bilbo.math.uni-mannheim.de ([::ffff:134.155.88.153]) (auth=eike-kernel@sf-tec.de)
	by mail.sf-mail.de (Qsmtpd 0.7pre) with (RC4-MD5 encrypted) ESMTPSA
	for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2005 10:56:06 +0200
In-Reply-To: <200508161909.20196@bilbo.math.uni-mannheim.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

First of all: since the request for a working version of this driver is not
longer there at the moment I'll only send out what I currently have to get it
into list archives. Merging this would be fine to decrease the amount of bugs
in this (and the size of it). I removed everyone but linux-scsi from recipient
list because of this. Removing the stack error is rather simple now, but I 
don't do it for now to make sure noone uses this beast until it's fixed.

cpqfcTSPutLinkQue() sometimes gets a pointer to an integer on the stack as 
third argument. Only this integer is meant to be copied into the next queue 
item, but everytime 160 bytes of stack memory are memcpy()'ed. This patch 
introduced a fourth argument for this error case and changes the third one 
not to be void* anymore. It also shrinks this driver by 50 lines and 1kB.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

diff -aup linux-2.6.13-rc6/drivers/scsi/cpqfcTScontrol.c linux-2.6.13-rc6-eike/drivers/scsi/cpqfcTScontrol.c
--- linux-2.6.13-rc6/drivers/scsi/cpqfcTScontrol.c	2005-08-16 16:42:14.000000000 +0200
+++ linux-2.6.13-rc6-eike/drivers/scsi/cpqfcTScontrol.c	2005-08-17 10:36:38.000000000 +0200
@@ -662,9 +662,9 @@ int CpqTsProcessIMQEntry(void *host)
   USHORT i, RPCset, DPCset;
   ULONG x_ID;
   ULONG ulBuff, dwStatus;
-  TachFCHDR_GCMND* fchs;
 #error This is too much stack
   ULONG ulFibreFrame[2048/4];  // max number of DWORDS in incoming Fibre Frame
+  TachFCHDR_GCMND* fchs = (TachFCHDR_GCMND*) ulFibreFrame;
   UCHAR ucInboundMessageType;  // Inbound CM, dword 3 "type" field
 
   ENTER("ProcessIMQEntry");
@@ -761,12 +761,10 @@ int CpqTsProcessIMQEntry(void *host)
 	      {
 		// presumes device is still there: send ABTS.
 
-                cpqfcTSPutLinkQue( cpqfcHBAdata, BLS_ABTS, &x_ID);
+			cpqfcTSPutLinkQue(cpqfcHBAdata, BLS_ABTS, NULL, x_ID);
 	      }
-	    }
-	    else  // Abort all other errors
-	    {
-              cpqfcTSPutLinkQue( cpqfcHBAdata, BLS_ABTS, &x_ID);
+	    } else { /* Abort all other errors */
+		cpqfcTSPutLinkQue(cpqfcHBAdata, BLS_ABTS, NULL, x_ID);
 	    }
 
             // if the HPE bit is set, we have to CLose the LOOP
@@ -879,7 +877,6 @@ int CpqTsProcessIMQEntry(void *host)
 
       if( ucInboundMessageType == 1 )
       {
-        fchs = (TachFCHDR_GCMND*)ulFibreFrame; // cast to examine IB frame
         // don't fill up our Q with garbage - only accept FCP-CMND
         // or XRDY frames
         if( (fchs->d_id & 0xFF000000) == 0x06000000 ) // CMND
@@ -920,21 +917,16 @@ int CpqTsProcessIMQEntry(void *host)
               Exchanges->fcExchange[ x_ID ].status |= SFQ_FRAME;
 
 	      // presumes device is still there: send ABTS.
-              cpqfcTSPutLinkQue( cpqfcHBAdata, BLS_ABTS, &x_ID);
+		cpqfcTSPutLinkQue(cpqfcHBAdata, BLS_ABTS, NULL, x_ID);
 	      break;  // done
 	    }
 	  }
 	}
 	
-      }
-      else if( ucInboundMessageType == 3)
-      {
+	} else if (ucInboundMessageType == 3) {
         // FC Link Service frames (e.g. PLOGI, ACC) come in here.
-        cpqfcTSPutLinkQue( cpqfcHBAdata, SFQ_UNKNOWN, ulFibreFrame);
-
-      }
-      else if( ucInboundMessageType == 2 ) // "bad FCP"?
-      {
+		cpqfcTSPutLinkQue(cpqfcHBAdata, SFQ_UNKNOWN, fchs, 0);
+	} else if (ucInboundMessageType == 2) { // "bad FCP"?
 #ifdef IMQ_DEBUG
         printk("Bad FCP incoming frame discarded\n");
 #endif
@@ -1290,7 +1282,7 @@ int CpqTsProcessIMQEntry(void *host)
 //	  printk("skipping LINKACTIVE post\n");
 	}
 	else
-          cpqfcTSPutLinkQue(cpqfcHBAdata, LINKACTIVE, ulFibreFrame);
+		cpqfcTSPutLinkQue(cpqfcHBAdata, LINKACTIVE, fchs, 0);
       }
 
       // ******* Set Fabric Login indication ********
diff -aup linux-2.6.13-rc6/drivers/scsi/cpqfcTSinit.c linux-2.6.13-rc6-eike/drivers/scsi/cpqfcTSinit.c
--- linux-2.6.13-rc6/drivers/scsi/cpqfcTSinit.c	2005-08-16 20:24:23.000000000 +0200
+++ linux-2.6.13-rc6-eike/drivers/scsi/cpqfcTSinit.c	2005-08-17 10:15:51.000000000 +0200
@@ -1440,7 +1440,7 @@ int cpqfcTS_eh_abort(Scsi_Cmnd *Cmnd)
       // upper layers, we can't make future reference to any of its
       // fields (e.g the Nexus).
 
-      cpqfcTSPutLinkQue( cpqfcHBAdata, BLS_ABTS, &i);
+	cpqfcTSPutLinkQue(cpqfcHBAdata, BLS_ABTS, NULL, i);
 
       break;
     }
diff -aup linux-2.6.13-rc6/drivers/scsi/cpqfcTSstructs.h linux-2.6.13-rc6-eike/drivers/scsi/cpqfcTSstructs.h
--- linux-2.6.13-rc6/drivers/scsi/cpqfcTSstructs.h	2005-08-16 20:24:23.000000000 +0200
+++ linux-2.6.13-rc6-eike/drivers/scsi/cpqfcTSstructs.h	2005-08-17 10:14:48.000000000 +0200
@@ -999,10 +999,7 @@ PFC_LOGGEDIN_PORT  fcFindLoggedInPort( 
   PFC_LOGGEDIN_PORT *pLastLoggedInPort
 );
 
-void cpqfcTSPutLinkQue( 
-  CPQFCHBA *cpqfcHBAdata, 
-  int Type, 
-  void *QueContent);
+void cpqfcTSPutLinkQue(CPQFCHBA *, int, TachFCHDR_GCMND*, ULONG);
 
 void fcPutScsiQue( 
   CPQFCHBA *cpqfcHBAdata, 
diff -aup linux-2.6.13-rc6/drivers/scsi/cpqfcTSworker.c linux-2.6.13-rc6-eike/drivers/scsi/cpqfcTSworker.c
--- linux-2.6.13-rc6/drivers/scsi/cpqfcTSworker.c	2005-08-16 20:24:23.000000000 +0200
+++ linux-2.6.13-rc6-eike/drivers/scsi/cpqfcTSworker.c	2005-08-17 10:31:51.000000000 +0200
@@ -789,9 +789,9 @@ void cpqfcTS_WorkTask( struct Scsi_Host 
 // This circular Q works like Tachyon's que - the producer points to the next
 // (unused) entry.  Called by Interrupt handler, WorkerThread, Timer
 // sputlinkq
-void cpqfcTSPutLinkQue( CPQFCHBA *cpqfcHBAdata,
-  int Type, 
-  void *QueContent)
+void
+cpqfcTSPutLinkQue(CPQFCHBA *cpqfcHBAdata, int Type,
+		TachFCHDR_GCMND *content, ULONG err)
 {
   PTACHYON fcChip = &cpqfcHBAdata->fcChip;
 //  FC_EXCHANGES *Exchanges = fcChip->Exchanges;
@@ -800,12 +800,8 @@ void cpqfcTSPutLinkQue( CPQFCHBA *cpqfcH
   
   ENTER("cpqfcTSPutLinkQ");
 
-  ndx = fcLQ->producer;
-  
-  ndx += 1;  // test for Que full
-
+  ndx = fcLQ->producer + 1; /* test for Que full */
 
-  
   if( ndx >= FC_LINKQ_DEPTH ) // rollover test
     ndx = 0;
 
@@ -863,11 +859,13 @@ void cpqfcTSPutLinkQue( CPQFCHBA *cpqfcH
     // OK, add the Q'd item...
     
     fcLQ->Qitem[fcLQ->producer].Type = Type;
-   
-    memcpy(
-        fcLQ->Qitem[fcLQ->producer].ulBuff,
-        QueContent, 
-        sizeof(fcLQ->Qitem[fcLQ->producer].ulBuff));
+
+	if (content) {
+		memcpy(fcLQ->Qitem[fcLQ->producer].ulBuff, content,
+			sizeof(fcLQ->Qitem[fcLQ->producer].ulBuff));
+	} else {
+		fcLQ->Qitem[fcLQ->producer].ulBuff[0] = err;
+	}
 
     fcLQ->producer = ndx;  // increment Que producer
 
@@ -1165,10 +1163,8 @@ void cpqfcTSTerminateExchange( 
       if( ScsiNexus == NULL ) // our HBA changed - term. all
       {
 	Exchanges->fcExchange[x_ID].status = TerminateStatus;
-        cpqfcTSPutLinkQue( cpqfcHBAdata, BLS_ABTS, &x_ID ); 
-      }
-      else
-      {
+		cpqfcTSPutLinkQue(cpqfcHBAdata, BLS_ABTS, NULL, x_ID); 
+	} else {
 	// If a device, according to WWN, has been removed, it's
 	// port_id may be used by another working device, so we
 	// have to terminate by SCSI target, NOT port_id.
@@ -1179,7 +1175,7 @@ void cpqfcTSTerminateExchange( 
             (Exchanges->fcExchange[x_ID].Cmnd->device->channel == ScsiNexus->channel)) 
           {
             Exchanges->fcExchange[x_ID].status = TerminateStatus;
-            cpqfcTSPutLinkQue( cpqfcHBAdata, BLS_ABTS, &x_ID ); // timed-out
+		cpqfcTSPutLinkQue(cpqfcHBAdata, BLS_ABTS, NULL, x_ID); /* timed-out */
           }
 	}
 
@@ -1245,7 +1241,7 @@ static void ProcessELS_Request( 
             // send 'ACC' reply 
             cpqfcTSPutLinkQue( cpqfcHBAdata, 
                           ELS_PLOGI_ACC, // (PDISC same as PLOGI ACC)
-                          fchs );
+				fchs, 0);
 
 	    // OK to resume I/O...
 	  }
@@ -1310,7 +1306,7 @@ static void ProcessELS_Request( 
 	port_id = fchs->s_id &0xFFFFFF;
       }
       fchs->reserved = ls_reject_code; // borrow this (unused) field
-      cpqfcTSPutLinkQue( cpqfcHBAdata, ELS_RJT, fchs );
+	cpqfcTSPutLinkQue(cpqfcHBAdata, ELS_RJT, fchs, 0);
     }
    
     break;
@@ -1372,7 +1368,7 @@ static void ProcessELS_Request( 
         // send 'ACC' reply 
         cpqfcTSPutLinkQue( cpqfcHBAdata, 
                       ELS_PLOGI_ACC, // (PDISC same as PLOGI ACC)
-                      fchs );
+			fchs, 0);
       }
     }
     else // Payload unacceptable
@@ -1392,7 +1388,7 @@ static void ProcessELS_Request( 
       fchs->reserved = ls_reject_code; // borrow this (unused) field
 
       // send 'RJT' reply 
-      cpqfcTSPutLinkQue( cpqfcHBAdata, ELS_RJT, fchs );
+	cpqfcTSPutLinkQue(cpqfcHBAdata, ELS_RJT, fchs, 0);
     }
    
     // terminate any exchanges with this device...
@@ -1437,14 +1433,9 @@ static void ProcessELS_Request( 
           SetLoginFields( pLoggedInPort, fchs, FALSE, FALSE);
 
           // Q an ACCept Reply
-	  cpqfcTSPutLinkQue( cpqfcHBAdata,
-                        ELS_PRLI_ACC, 
-                        fchs );   
-	  
-	  NeedReject = FALSE;
-	}
-        else
-        {
+		cpqfcTSPutLinkQue(cpqfcHBAdata, ELS_PRLI_ACC, fchs, 0);
+		NeedReject = FALSE;
+	} else {
           // huh?
           printk(" (unexpected) PRLI REQEST with plogi FALSE\n");
 
@@ -1468,9 +1459,7 @@ static void ProcessELS_Request( 
     {
       // Q a ReJecT Reply with reason code
       fchs->reserved = ls_reject_code;
-      cpqfcTSPutLinkQue( cpqfcHBAdata,
-                    ELS_RJT, // Q Type
-                    fchs );  
+	cpqfcTSPutLinkQue(cpqfcHBAdata, ELS_RJT, fchs, 0);
     }
   }
     break;
@@ -1501,9 +1490,7 @@ static void ProcessELS_Request( 
     if( pLoggedInPort ) // found the device?
     {
       // Q an ACC reply 
-      cpqfcTSPutLinkQue( cpqfcHBAdata,
-                    ELS_LOGO_ACC, // Q Type
-                    fchs );       // device to respond to
+		cpqfcTSPutLinkQue(cpqfcHBAdata, ELS_LOGO_ACC, fchs, 0);
 
       // set login struct fields (LOGO_counter increment)
       SetLoginFields( pLoggedInPort, fchs, FALSE, FALSE);
@@ -1524,11 +1511,8 @@ static void ProcessELS_Request( 
 	else if( pLoggedInPort->LOGO_counter <= 3)
 	{
 	  // try (another) login (PLOGI request)
-	  
-          cpqfcTSPutLinkQue( cpqfcHBAdata,
-                    ELS_PLOGI, // Q Type
-                    fchs );  
-	
+		cpqfcTSPutLinkQue(cpqfcHBAdata, ELS_PLOGI, fchs, 0);
+
 	  // Terminate I/O with "retry" potential
 	  cpqfcTSTerminateExchange( cpqfcHBAdata, 
 			            &pLoggedInPort->ScsiNexus,
@@ -1558,9 +1542,7 @@ static void ProcessELS_Request( 
     {
       // Q a ReJecT Reply with reason code
       fchs->reserved = ls_reject_code;
-      cpqfcTSPutLinkQue( cpqfcHBAdata,
-                    ELS_RJT, // Q Type
-                    fchs );  
+	cpqfcTSPutLinkQue(cpqfcHBAdata, ELS_RJT, fchs, 0);
     }
   }
     break;
@@ -1590,18 +1572,11 @@ static void ProcessELS_Request( 
     {
       // ReJecT the command
       fchs->reserved = LS_RJT_REASON( UNABLE_TO_PERFORM, 0);
-    
-      cpqfcTSPutLinkQue( cpqfcHBAdata,
-                    ELS_RJT, // Q Type
-                    fchs ); 
-      
-      break;
-    }
-    else  // Accept the command
-    {
-       cpqfcTSPutLinkQue( cpqfcHBAdata,
-                    ELS_ACC, // Q Type
-                    fchs ); 
+
+		cpqfcTSPutLinkQue(cpqfcHBAdata, ELS_RJT, fchs, 0);
+		break;
+	} else { /* Accept the command */
+		cpqfcTSPutLinkQue(cpqfcHBAdata, ELS_ACC, fchs, 0);
     }
     
       // Check the "address format" to determine action.
@@ -1622,7 +1597,7 @@ static void ProcessELS_Request( 
         // For example, "port_id" 0x201300 
 	// OK, let's try a Name Service Request (Query)
       fchs->s_id = 0xFFFFFC;  // Name Server Address
-      cpqfcTSPutLinkQue( cpqfcHBAdata, FCS_NSR, fchs);
+	cpqfcTSPutLinkQue(cpqfcHBAdata, FCS_NSR, fchs, 0);
 
       break;
 	
@@ -1641,10 +1616,8 @@ static void ProcessELS_Request( 
     // set reject reason code 
     fchs->reserved = LS_RJT_REASON( UNABLE_TO_PERFORM, 
 		                    REQUEST_NOT_SUPPORTED);
-    
-    cpqfcTSPutLinkQue( cpqfcHBAdata,
-                    ELS_RJT, // Q Type
-                    fchs );     
+
+	cpqfcTSPutLinkQue(cpqfcHBAdata, ELS_RJT, fchs, 0);
     break;  
   }
 }
@@ -1761,14 +1734,11 @@ static void ProcessELS_Reply( 
       {
         // PLOGI ACC was a Fabric response... issue SCR
 	fchs->s_id = 0xFFFFFD;  // address for SCR
-        cpqfcTSPutLinkQue( cpqfcHBAdata, ELS_SCR, fchs);
-      }
-
-      else
-      {
+		cpqfcTSPutLinkQue(cpqfcHBAdata, ELS_SCR, fchs, 0);
+	} else {
       // Now we need a PRLI to enable FCP-SCSI operation
       // set flags and Q up a ELS_PRLI
-        cpqfcTSPutLinkQue( cpqfcHBAdata, ELS_PRLI, fchs);
+		cpqfcTSPutLinkQue(cpqfcHBAdata, ELS_PRLI, fchs, 0);
       }
     }
     else
@@ -1834,7 +1804,7 @@ static void ProcessELS_Reply( 
                 fchs->reserved = i; // copy ExchangeID
 //                printk(" *Q x_ID %Xh after PDISC* ",i);
 
-                cpqfcTSPutLinkQue( cpqfcHBAdata, EXCHANGE_QUEUED, fchs );
+		cpqfcTSPutLinkQue(cpqfcHBAdata, EXCHANGE_QUEUED, fchs, 0);
               }
             }
 
@@ -1869,10 +1839,7 @@ static void ProcessELS_Reply( 
 	// terminate any I/O to this port, and Q a PLOGI
 	if( pLoggedInPort )  // FC device previously known?
 	{
-
-          cpqfcTSPutLinkQue( cpqfcHBAdata,
-                    ELS_LOGO, // Q Type
-                    fchs );   // has port_id to send to 
+		cpqfcTSPutLinkQue(cpqfcHBAdata, ELS_LOGO, fchs, 0);
 
 	  // There are a variety of error scenarios which can result
   	  // in PDISC failure, so as a catchall, add the check for
@@ -1887,7 +1854,7 @@ static void ProcessELS_Reply( 
           cpqfcTSTerminateExchange( cpqfcHBAdata, 
 	    &pLoggedInPort->ScsiNexus, PORTID_CHANGED);
         }
-        cpqfcTSPutLinkQue( cpqfcHBAdata, ELS_PLOGI, fchs );
+	cpqfcTSPutLinkQue(cpqfcHBAdata, ELS_PLOGI, fchs, 0);
       }
     }
     else
@@ -1934,7 +1901,7 @@ static void ProcessELS_Reply( 
         // OK, let's send a REPORT_LUNS command to determine
 	// whether VSA or PDA FCP-LUN addressing is used.
 	
-        cpqfcTSPutLinkQue( cpqfcHBAdata, SCSI_REPORT_LUNS, fchs );
+	cpqfcTSPutLinkQue(cpqfcHBAdata, SCSI_REPORT_LUNS, fchs, 0);
 	
 	// It's possible that a device we were talking to changed 
 	// port_id, and has logged back in.  This function ensures
@@ -1971,8 +1938,7 @@ static void ProcessELS_Reply( 
 
     // now send out a PLOGI to the well known port_id 0xFFFFFC
     fchs->s_id = 0xFFFFFC;
-    cpqfcTSPutLinkQue( cpqfcHBAdata, ELS_PLOGI, fchs);
-  
+	cpqfcTSPutLinkQue(cpqfcHBAdata, ELS_PLOGI, fchs, 0);
    break; 
 
 
@@ -1988,9 +1954,7 @@ static void ProcessELS_Reply( 
    
 	
     fchs->s_id = 0xFFFFFC;  // Name Server Address
-    cpqfcTSPutLinkQue( cpqfcHBAdata, FCS_NSR, fchs);
-    
-
+	cpqfcTSPutLinkQue(cpqfcHBAdata, FCS_NSR, fchs, 0);
     break;
 
     
@@ -2199,7 +2163,7 @@ static void AnalyzeIncomingFrame( 
 	  memcpy( fcChip->LILPmap, &fchs->pl[1], 32*4); // 32 DWORDs
 	  fcChip->Options.LILPin = 1; // our LILPmap is valid!
 	  // now post to make Port Discovery happen...
-          cpqfcTSPutLinkQue( cpqfcHBAdata, LINKACTIVE, fchs);  
+		cpqfcTSPutLinkQue(cpqfcHBAdata, LINKACTIVE, fchs, 0);
 	}
       }
     }
@@ -2252,9 +2216,7 @@ static void AnalyzeIncomingFrame( 
               fchs->ox_rx_id = 
                 Exchanges->fcExchange[ ExchangeID].fchs.ox_rx_id;
                 
-              cpqfcTSPutLinkQue( cpqfcHBAdata,
-                            BLS_ABTS_ACC, // Q Type 
-                            fchs );    // void QueContent
+		cpqfcTSPutLinkQue(cpqfcHBAdata, BLS_ABTS_ACC, fchs, 0);
               AbortAccept = TRUE;
       printk("ACCepting ABTS for x_ID %8.8Xh, SEST pair %8.8Xh\n", 
              fchs->ox_rx_id, Exchanges->fcExchange[ ExchangeID].fchs.ox_rx_id);
@@ -2727,7 +2689,7 @@ static void ScsiReportLunsDone(Scsi_Cmnd
       // context is "reply to source".
       
         fchs->s_id = fchs->d_id; // (temporarily re-use the struct)
-        cpqfcTSPutLinkQue( cpqfcHBAdata, SCSI_REPORT_LUNS, fchs );
+	cpqfcTSPutLinkQue(cpqfcHBAdata, SCSI_REPORT_LUNS, fchs, 0);
       }
     }
     else  // probably, the device doesn't support Report Luns
@@ -3180,7 +3142,7 @@ void cpqfcTSheartbeat( unsigned long ptr
            
             // We expect the WorkerThread to change the xchng type to
             // abort and set appropriate timeout.
-            cpqfcTSPutLinkQue( cpqfcHBAdata, BLS_ABTS, &i ); // timed-out
+		cpqfcTSPutLinkQue(cpqfcHBAdata, BLS_ABTS, NULL, i); /* timed-out */
 	  }
         }
       }
