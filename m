From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi: Fix sg memory leak building 2 scatter-gather lists
Date: Wed, 22 Mar 2006 18:32:17 -0500
Message-ID: <4421DE81.3090805@torque.net>
References: <200603221703.59337.lgeek@frontiernet.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060200070500090006010804"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:58014 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S932569AbWCVXcd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Mar 2006 18:32:33 -0500
In-Reply-To: <200603221703.59337.lgeek@frontiernet.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Holty <lgeek@frontiernet.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------060200070500090006010804
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Bryan Holty wrote:
> Hello,
>     There is a memory leak in sg that is hit in the case when direct_io is in 
> use and the length of the data is longer than we can fit into a single 
> scatter-gather list.  Two scatter-gather lists are allocated for each io that 
> meets the criteria, and only 1 ever gets released.
> 
>     The following fix releases the scatter-gather list created by the 
> attempted sg_build_direct when abandoning the effort in favor of 
> sg_build_indirect.  sg_build_indirect creates a new scatter-gather list.

Wow, sg leak fixes are coming thick and fast.
I agree there is a leak there but I'm not sure about
the placement of sg_remove_scat().

Bryan, what do you think about the variant attached to
this post? It is untested.

Doug Gilbert

> Signed-off-by: Bryan Holty <lgeek@frontiernet.net>
> 
> --- a/drivers/scsi/sg.c	2006-03-03 13:17:23.000000000 -0600
> +++ b/drivers/scsi/sg.c	2006-03-22 16:32:17.536091840 -0600
> @@ -1648,6 +1648,7 @@
>  		res = sg_build_direct(srp, sfp, dxfer_len);
>  		if (res <= 0)	/* -ve -> error, 0 -> done, 1 -> try indirect */
>  			return res;
> +		sg_remove_scat(req_schp);
>  	}
>  	if ((!sg_res_in_use(sfp)) && (dxfer_len <= rsv_schp->bufflen))
>  		sg_link_reserve(sfp, srp, dxfer_len);


--------------060200070500090006010804
Content-Type: text/x-patch;
 name="sg2616dio_lk.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg2616dio_lk.diff"

--- linux/drivers/scsi/sg.c	2006-03-20 10:08:49.000000000 -0500
+++ linux/drivers/scsi/sg.c2616dio_lk	2006-03-22 18:26:23.000000000 -0500
@@ -1834,8 +1834,10 @@
 	res = st_map_user_pages(schp->buffer, mx_sc_elems,
 				(unsigned long)hp->dxferp, dxfer_len, 
 				(SG_DXFER_TO_DEV == hp->dxfer_direction) ? 1 : 0);
-	if (res <= 0)
+	if (res <= 0) {
+		sg_remove_scat(schp);
 		return 1;
+	}
 	schp->k_use_sg = res;
 	schp->dio_in_use = 1;
 	hp->info |= SG_INFO_DIRECT_IO;

--------------060200070500090006010804--
