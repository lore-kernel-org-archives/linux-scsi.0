From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 1/3] scsi_dh_alua: Do not modify the interval value for
 retries
Date: Fri, 28 Apr 2017 21:49:09 +0200
Message-ID: <1493408949.4507.14.camel@suse.com>
References: <20170428130626.32162-1-mwilck@suse.com>
         <20170428130626.32162-2-mwilck@suse.com>
         <1493404499.2767.13.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:42942 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965295AbdD1TtY (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Fri, 28 Apr 2017 15:49:24 -0400
In-Reply-To: <1493404499.2767.13.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2017-04-28 at 18:35 +0000, Bart Van Assche wrote:
> On Fri, 2017-04-28 at 15:06 +0200, Martin Wilck wrote:
> > @@ -886,7 +883,7 @@ static bool alua_rtpg_queue(struct
> > alua_port_group *pg,
> >  		force = true;
> >  	}
> >  	if (pg->rtpg_sdev == NULL) {
> > -		pg->interval = 0;
> > +		pg->interval = 2;
> >  		pg->flags |= ALUA_PG_RUN_RTPG;
> >  		kref_get(&pg->kref);
> >  		pg->rtpg_sdev = sdev;
> 
> Hello Hannes and Martin,
> 
> Why is .interval initialized in alua_rtpg_queue() instead of in
> alua_alloc_pg()? I think initializing it in alua_alloc_pg() would
> make more clear that .interval is constant.

Thinking about it - since "interval" has now become a global constant,
we might as well declare it as a constant rather than carrying in
around in the alua_port_group struct.

It's kind of funny how this evolved from a geometric series via
an arithmetic series (bc97f4bb) and a per port-group variable with just
two values (03197b61) to a global constant ... an example of kernel
code gradually getting simpler over time :-)

However: 03197b61 ("scsi_dh_alua: Use workqueue for RTPG") has removed
the progression sort of silently. It was still present in Hannes's
first version of the patch (http://marc.info/?l=linux-scsi&m=1391160640
32031&w=2) but seems to have been dropped in later versions: 

@@ -546,23 +593,26 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 
        switch (pg->state) {
        case TPGS_STATE_TRANSITIONING:
-               if (time_before(jiffies, expiry)) {
+               if (time_before(jiffies, pg->expiry)) {
                        /* State transition, retry */
-                       interval += 2000;
-                       msleep(interval);
-                       goto retry;
+                       pg->interval = 2;
+                       err = SCSI_DH_RETRY;
+               } else {
+                       /* Transitioning time exceeded, set port to standby */
+                       err = SCSI_DH_IO;
+                       pg->state = TPGS_STATE_STANDBY;
+                       pg->expiry = 0;

Can someone confirm that using a constant value here is sufficient?

Martin

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
