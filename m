From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [stable] [patch 29/29] bug in gdth.c crashing machine
Date: Sun, 11 Mar 2007 11:03:47 -0500
Message-ID: <1173629027.3420.7.camel@mulgrave.il.steeleye.com>
References: <200703061046.l26AksTi020093@shell0.pdx.osdl.net>
	 <1173288505.3771.33.camel@mulgrave.il.steeleye.com>
	 <20070307174021.GA25066@kroah.com>
	 <20070307111616.16e5e641.akpm@linux-foundation.org>
	 <1173315014.3771.51.camel@mulgrave.il.steeleye.com>
	 <20070309183654.GB7977@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-NsJ36WCpSCzM8oNikAQa"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:53692 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933798AbXCKQFV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Mar 2007 12:05:21 -0400
In-Reply-To: <20070309183654.GB7977@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, rdunlap@xenotime.net, Achim_Leubner@adaptec.com, joerg@dorchain.net, stable@kernel.org, linux-scsi@vger.kernel.org


--=-NsJ36WCpSCzM8oNikAQa
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2007-03-09 at 10:36 -0800, Greg KH wrote:
> On Wed, Mar 07, 2007 at 07:50:14PM -0500, James Bottomley wrote:
> > On Wed, 2007-03-07 at 11:16 -0800, Andrew Morton wrote:
> > > Achim did reply:  http://lkml.org/lkml/2007/2/23/138
> > 
> > Ah ... OK; sorry, I'm parochial ... if it didn't appear on linux-scsi,
> > you can usually assume I haven't seen it.
> > 
> > > So we don't know what the patch does, but it should be merged into
> > > -stable
> > > (and mainline, heaven forfend)
> > 
> > Well ... I would, except what this patch does is to initialise the
> > command sg_ranz field (for both 64 bit and 32 bit commands).  If you
> > look in the code just below the patch application at the 
> > 
> > if (scp->use_sg) {
> > ...
> > } else if (scp->request_bufflen) {
> > ...
> > }
> > 
> > You'll find a line setting these parameters in each of the cases of the
> > if statement.  So the bug appears to be that there's a missing else
> > clause to this if, which would initialise the zero transfer commands.
> > Is that a correct analysis?
> 
> Well, as no one has really responded to this thread about what the patch
> really does, and it's not in even James's tree yet, I've dropped it from
> -stable.
> 
> If James does send it to Linus, I'll be glad to reconsider it at that
> time.

I found the correct explanation.  It was actually given by the bug
reporter a while ago.  I've got the following in scsi-rc-fixes-2.6,
which should be upstream track.

James



--=-NsJ36WCpSCzM8oNikAQa
Content-Description: 
Content-Type: application/mbox
Content-Disposition: attachment; filename=0001-SCSI-gdth-fix-oops-in-gdth_copy_cmd.patch
Content-Transfer-Encoding: 7bit

>From bb9ba31ca3b88fd396e38950d1caedf2f83521c6 Mon Sep 17 00:00:00 2001
From: Joerg Dorchain <joerg@dorchain.net>
Date: Tue, 6 Mar 2007 02:46:54 -0800
Subject: [SCSI] gdth: fix oops in gdth_copy_cmd()

Recent alterations to the gdth_fill_raw_cmd() path no longer set the
sg_ranz field for zero transfer commands. However, this field is used
lower down in the function to initialise ha->cmd_len to the size of
the firmware packet.  If this uninitialised field contains a bogus
value, ha->cmd_len can become much larger than the actual firmware
packet and end up oopsing in gdth_copy_cmd() as it tries to copy this
huge packet to the device (usually because it runs into an unallocated
page).

The fix is to initialise the sg_ranz field to zero at the start of
gdth_fill_raw_cmd().

Signed-off-by: Joerg Dorchain <joerg@dorchain.net>
Acked-by: "Leubner, Achim" <Achim_Leubner@adaptec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
---
 drivers/scsi/gdth.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 8c81cec..60446b8 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -3091,6 +3091,7 @@ static int gdth_fill_raw_cmd(int hanum,Scsi_Cmnd *scp,unchar b)
             cmdp->u.raw64.direction  = 
                 gdth_direction_tab[scp->cmnd[0]]==DOU ? GDTH_DATA_OUT:GDTH_DATA_IN;
             memcpy(cmdp->u.raw64.cmd,scp->cmnd,16);
+            cmdp->u.raw64.sg_ranz    = 0;
         } else {
             cmdp->u.raw.reserved   = 0;
             cmdp->u.raw.mdisc_time = 0;
@@ -3107,6 +3108,7 @@ static int gdth_fill_raw_cmd(int hanum,Scsi_Cmnd *scp,unchar b)
             cmdp->u.raw.direction  = 
                 gdth_direction_tab[scp->cmnd[0]]==DOU ? GDTH_DATA_OUT:GDTH_DATA_IN;
             memcpy(cmdp->u.raw.cmd,scp->cmnd,12);
+            cmdp->u.raw.sg_ranz    = 0;
         }
 
         if (scp->use_sg) {
-- 
1.5.0.2


--=-NsJ36WCpSCzM8oNikAQa--

