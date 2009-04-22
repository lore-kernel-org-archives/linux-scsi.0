From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] RFC: have dm-mpath use already attached scsi_dh
Date: Wed, 22 Apr 2009 11:16:33 +0200
Message-ID: <49EEE071.9060902@suse.de>
References: <1240374806-6043-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050909080402020708060901"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954AbZDVJQf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Apr 2009 05:16:35 -0400
In-Reply-To: <1240374806-6043-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050909080402020708060901
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi Mike,

michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> If you have a mixed environment of clarriions, where some
> support ALAU and some support PNR, what do you put in
> your multipath.conf? With this patch you do not have to worry about
> it. If those modules are loaded before dm-mpath, then they
> will have attached to the correct devices based on inquiry, alua commands
> and parsing of data buffers (for example in scsi_dh_emc's alua check).
> There is no need for the user to set that info in the multipath.conf.
> And in general since all scsi_dh_modules will attach to the devices
> they work for, we do not need to have users specific this.
> 
No. The problem here is the hardware table from scsi_dh is compiled
in and cannot be changed from userland. The multipath.conf OTOH
is purely user-defined and, what's more, the user might have a valid
reason for modifying it.
(EG EMC Clariion can well be run in PNR mode even though ALUA is
active, or the user might want to try ALUA on any as-of-yet unknown
devices)

So _not_ allowing multipath to override the device handler setting
will just add to the confusion and makes error tracking even more
difficult.

So I would prefer the attached patch, it even save to touch
device handler code at all.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------050909080402020708060901
Content-Type: text/plain;
 name="scsi-dh-reattach-handler"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-dh-reattach-handler"

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 095f77b..46d01d9 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -592,12 +592,25 @@ static struct pgpath *parse_path(struct arg_set *as, struct path_selector *ps,
 	}
 
 	if (m->hw_handler_name) {
-		r = scsi_dh_attach(bdev_get_queue(p->path.dev->bdev),
-				   m->hw_handler_name);
+		struct request_queue *q = bdev_get_queue(p->path.dev->bdev);
+
+		r = scsi_dh_attach(q, m->hw_handler_name);
+		if (r == -EBUSY) {
+			/*
+			 * Already attached to different hw_handler,
+			 * try to reattach with correct one.
+			 */
+			scsi_dh_detach(q);
+			r = scsi_dh_attach(q, m->hw_handler_name);
+		}
 		if (r < 0) {
+			ti->error = "error attaching hardware handler";
 			dm_put_device(ti, p->path.dev);
 			goto bad;
 		}
+	} else {
+		/* Play safe and detach hardware handler */
+		scsi_dh_detach(bdev_get_queue(p->path.dev->bdev));
 	}
 
 	r = ps->type->add_path(ps, &p->path, as->argc, as->argv, &ti->error);

--------------050909080402020708060901--
