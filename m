From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: scsi device queue depth adjustability patch
Date: Thu, 03 Oct 2002 10:25:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210031425.g93EPiF02579@localhost.localdomain>
References: <dledford@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_10413843040"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA23911
	for <linux-scsi@vger.kernel.org>; Thu, 3 Oct 2002 07:25:48 -0700
Received: from localhost.localdomain (midgard.sc.steeleye.com [172.17.6.40])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id HAA23774
	for <linux-scsi@vger.kernel.org>; Thu, 3 Oct 2002 07:25:47 -0700
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id g93EPiF02579
	for <linux-scsi@vger.kernel.org>; Thu, 3 Oct 2002 10:25:46 -0400
In-Reply-To: Message from Doug Ledford <dledford@redhat.com>
   of "Tue, 01 Oct 2002 20:28:54 EDT." <20021002002854.GF28265@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multipart MIME message.

--==_Exmh_10413843040
Content-Type: text/plain; charset=us-ascii

dledford@redhat.com said:
> What I need, people to test this with the old aic7xxx driver (which
> implements the new code paths, no other drivers do) and people to test
>  with other drivers to make sure it doesn't break them.  If I don't
> hear  complaints then I'll move on to my next change which is far more
> intrusive  on drivers in general. 

After fixing up the 53c700 to use the new adjust queue depths stuff, I can 
confirm it's working fine for me here (well, actually I fixed the generic scsi 
tcq code to use it, but only the 53c700 driver uses this).

James


--==_Exmh_10413843040
Content-Type: text/plain ; name="tmp.diff"; charset=us-ascii
Content-Description: tmp.diff
Content-Disposition: attachment; filename="tmp.diff"

===== scsi.h 1.22 vs edited =====
--- 1.22/drivers/scsi/scsi.h	Thu Aug 15 16:01:28 2002
+++ edited/scsi.h	Thu Aug 15 16:18:53 2002
@@ -882,7 +882,7 @@
 
         if(SDpnt->tagged_supported && !blk_queue_tagged(q)) {
                 blk_queue_init_tags(q, depth);
-                SDpnt->tagged_queue = 1;
+		scsi_adjust_queue_depth(SDpnt, 1, depth);
         }
 }
 
@@ -892,7 +892,7 @@
  **/
 static inline void scsi_deactivate_tcq(Scsi_Device *SDpnt) {
         blk_queue_free_tags(&SDpnt->request_queue);
-        SDpnt->tagged_queue = 0;
+	scsi_adjust_queue_depth(SDpnt, 0, 2);
 }
 #define MSG_SIMPLE_TAG	0x20
 #define MSG_HEAD_TAG	0x21

--==_Exmh_10413843040--


