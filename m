From: "Stefan Bader" <Stefan.Bader@de.ibm.com>
Subject: [Q] 2.4.x: how to handle driver aborts in sd/sr
Date: Wed, 8 May 2002 13:35:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF789CF225.896237A6-ONC1256BB1.004E87CD@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d12relay01.de.ibm.com (d12relay01.de.ibm.com [9.165.215.22])
	by d12lmsgate-3.de.ibm.com (8.12.3/8.12.3) with ESMTP id g48BZs7Z015456
	for <linux-scsi@vger.kernel.org>; Wed, 8 May 2002 13:35:55 +0200
Received: from d12ml008.de.ibm.com (d12ml008_cs0 [9.165.223.52])
	by d12relay01.de.ibm.com (8.11.1m3/NCO/VER6.1) with ESMTP id g48BZs359106
	for <linux-scsi@vger.kernel.org>; Wed, 8 May 2002 13:35:54 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I've got some sort of error handling design question which I need some 
advice whether
this might be done the way I think.
In some error situations our low-level driver has to abort all currently 
active commands.
The device may work if the requests are retried. This works for disk for 
now by triggering
the mid-layer retry mechanism. This is ok for disks but a big problem for 
tapes which need
to handle this situation with more effort.
Now for that, the low-level driver can (and probably should) return 
DID_ABORT and let the
upper layer handle the situation. But then the sd driver would fail the 
request(s) because it
takes a result != 0 (aside from MEDIUM_ERROR) as 'no successful sectors' 
(which wouldn't
hurt) and there is no special catch for the condition in 
scsi_io_completion() from scsi_lib.c.
The desired action for the the abort case for disks would be just to 
requeue the whole request
(as it is done in the case of DID_RESET). 
The only two highlevel drivers that seem to use scsi_io-completion seem to 
be sd.c and sr.c
and in the reset case the request would just requeued as well. So, would 
there be a problem
in adding this to scsi_lib.c?

/Stefan Bader

--- scsi_lib.c  2002/04/17 15:58:05     1.14
+++ scsi_lib.c  2002/05/08 10:52:28
@@ -742,6 +742,12 @@
                        break;
                }
        }                       /* driver byte != 0 */
+       if (host_byte(result) == DID_ABORT) {
+               /*
+                * Command was aborted for recovery reasons. Try again.
+                */
+               scsi_queue_next_request(q, SCpnt);
+       }
        if (host_byte(result) == DID_RESET) {
                /*
                 * Third party bus reset or reset for error


Linux for eServer development
Stefan.Bader@de.ibm.com
----------------------------------------------------------------------------------
  When all other means of communication fail, try words.
