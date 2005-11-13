From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 5/10] convert st to use scsi_execute_async
Date: Sun, 13 Nov 2005 12:07:54 -0500
Message-ID: <437772EA.7080100@redhat.com>
References: <1131444404.23111.66.camel@max> <Pine.LNX.4.63.0511121859070.10335@kai.makisara.local> <43763E94.40406@cs.wisc.edu> <43764861.6030408@cs.wisc.edu> <Pine.LNX.4.63.0511130938570.15153@kai.makisara.local>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090404050702040007060307"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:9092 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S964941AbVKMRDR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2005 12:03:17 -0500
In-Reply-To: <Pine.LNX.4.63.0511130938570.15153@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org, Douglas Gilbert <dougg@torque.net>

This is a multi-part message in MIME format.
--------------090404050702040007060307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Kai Makisara wrote:
> On Sat, 12 Nov 2005, Mike Christie wrote:

I noticed that these patches still have the same bug that the 2.4 kernel 
st driver has, namely the holding of the st's SCSI request struct until 
write_behind_check is called.  This behavior is responsible for at least 
two bugs with tape systems under 2.4 that we've fixed.  The first bug is 
that if you perform a write to a tape device that involves an async 
write behind request, then attempt to access the device via the sg 
mechanism without performing any intervening read or ioctl commands on 
the st device, the sg access will hang.  This only happens on SCSI 
controllers that set the cmd_per_lun value == 1 (eg. mptscsih).  In 
order to replicate this problem you need one application writing to the 
tape device, then pausing, then something as simple as attempting to do 
an INQUIRY to the tape while the writer is paused causes the hang.  This 
happens at least with NetBackup, possibly with others as well.  The 
second bug is related to multiple tape usage on the same system.  It 
only happens on x86_64, not i686, but with multiple tapes in use the 
system eventually attempts to dma map a null pointer resulting in a 
BUG().  I didn't root cause the dma mapping issue, but I did verify that 
once the initial bug was fixed, the dma mapping bug went away as well 
(either because whatever race window existed was reduced to so small 
that we no longer hit it or the problem was in fact fixed).  The patch 
we used to solve the problem is attached.  As a side note, holding on to 
a command without any upper bound on when it will be released is simply 
a *bad* idea.  Get the information you need from the command and free it.


-- 
Doug Ledford <dledford@redhat.com>
http://people.redhat.com/dledford


--------------090404050702040007060307
Content-Type: text/x-patch;
 name="st-tape.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="st-tape.patch"

--- drivers/scsi-orig/st.c      2005-09-14 17:44:16.000000000 -0400
+++ drivers/scsi/st.c   2005-09-15 17:36:52.000000000 -0400
@@ -353,7 +353,14 @@
        (STp->buffer)->last_SRpnt = SCpnt->sc_request;
        DEB( STp->write_pending = 0; )

-       complete(SCpnt->request.waiting);
+       if ((STp->buffer)->writing) {
+               /* This is a write-behind request, we need to release the
+                * scsi request struct */
+               (STp->buffer)->syscall_result = st_chk_result(STp, SCpnt->sc_request);
+               SCpnt->sc_request->sr_request.waiting = NULL;
+               scsi_release_request(SCpnt->sc_request);
+       }
+       complete(&(STp->wait));
 }


@@ -423,10 +430,6 @@
         ) /* end DEB */

        wait_for_completion(&(STp->wait));
-       (STp->buffer)->last_SRpnt->sr_request.waiting = NULL;
-
-       (STp->buffer)->syscall_result = st_chk_result(STp, (STp->buffer)->last_SRpnt);
-       scsi_release_request((STp->buffer)->last_SRpnt);

        STbuffer->buffer_bytes -= STbuffer->writing;
        STps = &(STp->ps[STp->partition]);


--------------090404050702040007060307--
