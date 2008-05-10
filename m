From: Rakesh <raksac@yahoo.com>
Subject: mpt fusion driver patch for getting D2H FIS for Ata passthrough command
Date: Fri, 9 May 2008 17:18:39 -0700 (PDT)
Message-ID: <179013.69010.qm@web30207.mail.mud.yahoo.com>
Reply-To: raksac@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web30207.mail.mud.yahoo.com ([209.191.69.54]:21965 "HELO
	web30207.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754658AbYEJASp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 May 2008 20:18:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

mpt fusion driver patch for getting D2H FIS for Ata passthrough command based off kernel v2.6.23

Thanks,
Rakesh

diff -Naur linux-2.6.23/drivers/message/fusion/mptscsih.c linux-2.6.23-new/drivers/message/fusion/mptscsih.c
--- linux-2.6.23/drivers/message/fusion/mptscsih.c  2007-11-08 15:45:01.000000000 -0800
+++ linux-2.6.23-new/drivers/message/fusion/mptscsih.c  2008-05-09 18:10:37.000000000 -0700
@@ -877,7 +877,38 @@
        case MPI_IOCSTATUS_SUCCESS:         /* 0x0000 */
            sc->result = (DID_OK << 16) | scsi_status;
            if (scsi_state == 0) {
-               ;
+                if (sc->cmnd[0] == ATA_16) {
+                    unsigned char *StatusFIS = mr+0x14;
+                    unsigned char *sb = sc->sense_buffer;
+                    unsigned char *desc = sb + 8;
+
+                    /*
+                    * Sense data is current and format is descriptor.
+                    */
+                    sb[0] = 0x72;
+
+                    desc[0] = 0x09;
+
+                    /* set length of additional sense data */
+                    sb[7] = 14;
+                    desc[1] = 12;
+
+                    /*
+                    * Copy registers into sense buffer.
+                    */
+                    desc[2] = 0x00;
+                    desc[3] = StatusFIS[3];  /* error register */
+                    desc[4] = StatusFIS[13];  /* sectorCountRegister exp */
+                    desc[5] = StatusFIS[12];  /* sectorCountRegister */
+                    desc[6] = StatusFIS[8];  /* LBA Low exp */
+                    desc[7] = StatusFIS[4];  /* LBA Low */
+                    desc[8] = StatusFIS[9];  /* LBA Mid Exp */
+                    desc[9] = StatusFIS[5];  /* LBA Mid */
+                    desc[10] = StatusFIS[10];  /* LBA high Exp */
+                    desc[11] = StatusFIS[6];  /* LBA high */
+                    desc[12] = StatusFIS[7];  /* device */
+                    desc[13] = StatusFIS[2];  /* status */
+                }
            } else if (scsi_state & MPI_SCSI_STATE_AUTOSENSE_VALID) {
                /*
                 * If running against circa 200003dd 909 MPT f/w,



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
