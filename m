From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: start removing queue from tmscsim
Date: Fri, 27 Aug 2004 20:15:46 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0408272013010.1057@poirot.grange>
References: <20040819113637.GB21326@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:5822 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S266839AbUH0SQb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Aug 2004 14:16:31 -0400
In-Reply-To: <20040819113637.GB21326@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Thu, 19 Aug 2004, Christoph Hellwig wrote:

> So actually I have a patch that starts to remove internal queueing from
> tmscsim.  This gets rid of internal queueing for those cases where we
> can just make the midlayer do the the work by returning erros from
> ->queuecommand (and cleans up the tmscsim queuecommand implementation
> singnificantly).
>
> Next step would get rid of the more complicated internal queueing where
> we need to make the scsi layer requeue by returning appropinquate DID_
> values from ->scsidone.

Christoph

Is this going in the right direction?

Index: scsiiom.c
===================================================================
RCS file: /usr/src/cvs/linux-2_6/drivers/scsi/scsiiom.c,v
retrieving revision 1.1.1.5.2.4
diff -u -p -r1.1.1.5.2.4 scsiiom.c
--- scsiiom.c	17 Aug 2004 21:16:53 -0000	1.1.1.5.2.4
+++ scsiiom.c	26 Aug 2004 21:58:37 -0000
@@ -1438,12 +1438,8 @@ dc390_SRBdone( struct dc390_acb* pACB, s
  	    pSRB->SGIndex = 0;
  	    pSRB->TotalXferredLen = 0;
  	    pSRB->SGToBeXferLen = 0;
-
-	    if( dc390_StartSCSI( pACB, pDCB, pSRB ) ) {
-		dc390_Going_to_Waiting ( pDCB, pSRB );
-		dc390_waiting_timer (pACB, HZ/5);
-	    }
-	    return;
+	    SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
+	    goto ckc_e;
  	}
      }
      if( status )

Thanks
Guennadi
---
Guennadi Liakhovetski

