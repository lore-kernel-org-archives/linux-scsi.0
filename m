From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] merge scsiiom.c into tmscsim.c
Date: Sat, 9 Oct 2004 14:29:47 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041009122946.GA19272@lst.de>
References: <20041003134714.GA1623@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:8338 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266749AbUJIM3v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2004 08:29:51 -0400
Content-Disposition: inline
In-Reply-To: <20041003134714.GA1623@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: g.liakhovetski@gmx.de, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

On Sun, Oct 03, 2004 at 03:47:14PM +0200, Christoph Hellwig wrote:
> might be a good time to get rid of that clumsy include .c file into
> another one thing.  (Also please bk rm scsiiom.c afterwards)

And here's a patch ontop that restores's Al's sparse fixes done in
scsiiom.c (the old patch still applies and works without this one,
but without it you get a few more sparse warnings):


--- linux/drivers/scsi/tmscsim.c~	2004-10-09 14:29:45.772931256 +0200
+++ linux/drivers/scsi/tmscsim.c	2004-10-09 14:30:45.486905632 +0200
@@ -1624,7 +1624,7 @@
      }
     DC390_write8 (ScsiCmd, EN_SEL_RESEL);
     pSRB = pDCB->pActiveSRB;
-    pACB->pActiveDCB = 0;
+    pACB->pActiveDCB = NULL;
     pSRB->ScsiPhase = SCSI_NOP0;
     if( pSRB->SRBState & SRB_UNEXPECT_RESEL )
 	pSRB->SRBState = 0;
@@ -1641,7 +1641,7 @@
 	    dc390_Free_insert (pACB, pSRB);
 	    pSRB = psrb;
 	}
-	pDCB->pGoingSRB = 0;
+	pDCB->pGoingSRB = NULL;
     }
     else
     {
@@ -1655,7 +1655,7 @@
 	{
 disc1:
 	    dc390_freetag (pDCB, pSRB);
-	    pDCB->pActiveSRB = 0;
+	    pDCB->pActiveSRB = NULL;
 	    pSRB->SRBState = SRB_FREE;
 	    dc390_SRBdone( pACB, pDCB, pSRB);
 	}
@@ -1967,7 +1967,7 @@
 	pACB->ACBFlag |= RESET_DETECT;
 
 	dc390_ResetDevParam( pACB );
-	dc390_DoingSRB_Done( pACB, 0 );
+	dc390_DoingSRB_Done( pACB, NULL);
 	//dc390_RecoverSRB( pACB );
 	pACB->pActiveDCB = NULL;
 	pACB->ACBFlag = 0;
