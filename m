From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 9775] HOST_MSG_LOOP invalid SCB ff
Date: Tue, 12 Feb 2008 15:55:48 -0600
Message-ID: <1202853348.3137.145.camel@localhost.localdomain>
References: <20080209025241.9B31B11D107@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43623 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752072AbYBLVzy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2008 16:55:54 -0500
In-Reply-To: <20080209025241.9B31B11D107@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org, john@mib-infotech.co.nz
Cc: linux-scsi@vger.kernel.org

On Fri, 2008-02-08 at 18:52 -0800, bugme-daemon@bugzilla.kernel.org
wrote:
> Ok, I've spent some time trying different combinations of devices.
> 
> Against kernel 2.6.24
> T0 is Quantum DLT8000 ID0
> T1 is Quantum DLT8000 ID1
> MTX     is STK L80  ID 15
> Terminators A, B
> 
> Channel                         A                       B
>                                         T0,T1,MTX,B     Nil                    
>                 Crash
>                                         Nil                     T0,T1,MTX,B    
>                 Parity Error in Data-in Phase
>                                         Nil                     T0,MTX,B       
>                 Ok, Tar test ok, MTX ok
>                                         Nil                     T1,MTX,B       
>                 Ok, Tar test ok, MTX ok 
> -- Both drives work ok          
>                                         T1,MTX,B        Nil                    
>                 Ok   Skipped Tests
>                                         T1,MTX,A        Nil                    
>                 Ok   Skipped Tests
>                                         T0,MTX,B        Nil                    
>                 Crash
>                                         T0,MTX,A        Nil                    
>                 Crash
> -- Not the terminator
> 
> 
> --Test on two channels
>                                         T0,MTX,A        T1,B                   
>         Crash
>                                         T1,B            T0,MTX,A               
>         Parity Error in Data-in Phase                                   
> 
> It really doesn't like three devices, on two busses or one.

Well, I still think you have some type of bus instability, but that said
we need to get rid of the panic.

I'm afraid this is going to be a long process.  For the first attempt,
let's see if this is an unsolicited msgin ... it looks like the driver
handling for those is wrong.  Can you try this patch?

Thanks,

James

---

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 6d2ae64..64e62ce 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -695,15 +695,16 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int intstat)
 			scb_index = ahc_inb(ahc, SCB_TAG);
 			scb = ahc_lookup_scb(ahc, scb_index);
 			if (devinfo.role == ROLE_INITIATOR) {
-				if (scb == NULL)
-					panic("HOST_MSG_LOOP with "
-					      "invalid SCB %x\n", scb_index);
+				if (bus_phase == P_MESGOUT) {
+					if (scb == NULL)
+						panic("HOST_MSG_LOOP with "
+						      "invalid SCB %x\n",
+						      scb_index);
 
-				if (bus_phase == P_MESGOUT)
 					ahc_setup_initiator_msgout(ahc,
 								   &devinfo,
 								   scb);
-				else {
+				} else {
 					ahc->msg_type =
 					    MSG_TYPE_INITIATOR_MSGIN;
 					ahc->msgin_index = 0;


