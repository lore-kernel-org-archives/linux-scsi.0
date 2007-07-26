From: "Freels, James D." <freelsjd@ornl.gov>
Subject: Re: [Bug 8366] aic79xx and aic7xxx driver issues
Date: Thu, 26 Jul 2007 17:37:28 -0400
Message-ID: <1185485848.14419.71.camel@fea.ornl.gov>
References: <20070725010525.614621080E4@picon.linux-foundation.org>
 <1185329683.3488.46.camel@localhost.localdomain>
 <1185461780.14419.17.camel@fea.ornl.gov>
 <1185462341.3501.62.camel@localhost.localdomain>
 <1185480022.14419.58.camel@fea.ornl.gov>
 <1185482804.3501.87.camel@localhost.localdomain>
 <1185484390.3501.93.camel@localhost.localdomain>
 <1185484597.14419.65.camel@fea.ornl.gov>
 <1185485358.3501.94.camel@localhost.localdomain>
Reply-To: freelsjd@ornl.gov
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emroute4.ornl.gov ([160.91.86.27]:58961 "EHLO emroute4.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756563AbXGZVhd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 17:37:33 -0400
Received: from emroute4.ornl.gov ([127.0.0.1])
 by emroute4.ornl.gov (PMDF V6.3-x11 #31501)
 with ESMTP id <0JLT00IEH2QK0S@emroute4.ornl.gov> for
 linux-scsi@vger.kernel.org; Thu, 26 Jul 2007 17:37:33 -0400 (EDT)
In-reply-to: <1185485358.3501.94.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

Here is what I get when I apply the patch against the vanilla 2.6.22.1
source:

fea8:/usr/src/linux-2.6.22.1# patch -p1 <../new_aic_patch
patching file drivers/scsi/aic7xxx/aic79xx_osm.c
Hunk #1 FAILED at 2284.
Hunk #2 FAILED at 2368.
Hunk #3 FAILED at 2450.
Hunk #4 FAILED at 2490.
Hunk #5 FAILED at 2526.
Hunk #6 FAILED at 2570.
Hunk #7 FAILED at 2606.
Hunk #8 FAILED at 2650.
8 out of 8 hunks FAILED -- saving rejects to file
drivers/scsi/aic7xxx/aic79xx_osm.c.rej
patching file drivers/scsi/aic7xxx/aic7xxx_osm.c
Hunk #1 FAILED at 2317.
Hunk #2 FAILED at 2386.
2 out of 2 hunks FAILED -- saving rejects to file
drivers/scsi/aic7xxx/aic7xxx_osm.c.rej
fea8:/usr/src/linux-2.6.22.1# 

Here are the contents is the last reject file (probably similar for
all):

drivers/scsi/aic7xxx/aic7xxx_osm.c.rej

*************** static void ahc_linux_set_period(struct scsi_target
*starget, int period)
*** 2317,2324 ****
  
         if (period < 9)
                 period = 9;     /* 12.5ns is our minimum */
-        if (period == 9)
-                ppr_options |= MSG_EXT_PPR_DT_REQ;
  
         ahc_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
                             starget->channel + 'A', ROLE_INITIATOR);
--- 2317,2329 ----
  
         if (period < 9)
                 period = 9;     /* 12.5ns is our minimum */
+        if (period == 9) {
+                if (spi_max_width(starget))
+                        ppr_options |= MSG_EXT_PPR_DT_REQ;
+                else
+                        /* need wide for DT and need DT for 12.5 ns */
+                        period = 10;
+        }
  
         ahc_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
                             starget->channel + 'A', ROLE_INITIATOR);
*************** static void ahc_linux_set_dt(struct scsi_target
*starget, int dt)
*** 2381,2387 ****
         unsigned long flags;
         struct ahc_syncrate *syncrate;
  
-        if (dt) {
                 ppr_options |= MSG_EXT_PPR_DT_REQ;
                 if (!width)
                         ahc_linux_set_width(starget, 1);
--- 2386,2392 ----
         unsigned long flags;
         struct ahc_syncrate *syncrate;
  
+        if (dt && spi_max_width(starget)) {
                 ppr_options |= MSG_EXT_PPR_DT_REQ;
                 if (!width)
                         ahc_linux_set_width(starget, 1);



On Thu, 2007-07-26 at 17:29 -0400, James Bottomley wrote:
> On Thu, 2007-07-26 at 17:16 -0400, Freels, James D. wrote:
> > James, I would be glad to try the fix.  I can grab the changes below,
> > but can you give me the patch command ?  I know how to patch the
> > normal kernel sources.  Is this a patch for 2.6.22.1 ?
> 
> It was created against current git, but there should be little
> difference in the aic driver between that and 2.6.22.1, so it should
> apply there as well.
> 
> > cd /usr/src/linux-2.6.22.1
> > 
> > patch -p1 <../your_new_patch
> > 
> > where your_new_patch is in /usr/src  
> 
> Yes, that should do it.
> 
> James
> 
> 
James D. Freels, Ph.D.
Senior Research Staff, HFIR Cold Source, ORNL
http://sunsite.utk.edu/wuot/mt/podcast/051807HIFER.mp3
