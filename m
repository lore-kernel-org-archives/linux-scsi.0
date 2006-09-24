From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [GIT PATCH] scsi updates for post 2.6.18
Date: Sat, 23 Sep 2006 20:30:51 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0609232023530.4388@g5.osdl.org>
References: <1159065451.3436.10.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:56025 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1752070AbWIXDa5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Sep 2006 23:30:57 -0400
In-Reply-To: <1159065451.3436.10.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>



On Sat, 23 Sep 2006, James Bottomley wrote:
>
> This is the usual grab bag of updates including three new drivers:
> aic94xx, stex and arcmsr.

Ok, we have a networking merge issue:

	drivers/scsi/scsi_transport_fc.c: In function 'fc_host_post_event':
	drivers/scsi/scsi_transport_fc.c:483: error: too few arguments to function 'nlmsg_multicast'
	drivers/scsi/scsi_transport_fc.c: In function 'fc_host_post_vendor_event':
	drivers/scsi/scsi_transport_fc.c:557: error: too few arguments to function 'nlmsg_multicast'
	make[2]: *** [drivers/scsi/scsi_transport_fc.o] Error 1
	make[1]: *** [drivers/scsi] Error 2
	make: *** [drivers] Error 2

because there's a new gfp-flag field to nlmsg_multicast().

I suspect this is the proper solution, somebody double-check and test..

		Linus

---
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 4ab176e..4401341 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -480,7 +480,7 @@ fc_host_post_event(struct Scsi_Host *sho
 	event->event_code = event_code;
 	event->event_data = event_data;
 
-	err = nlmsg_multicast(scsi_nl_sock, skb, 0, SCSI_NL_GRP_FC_EVENTS);
+	err = nlmsg_multicast(scsi_nl_sock, skb, 0, SCSI_NL_GRP_FC_EVENTS, GFP_KERNEL);
 	if (err && (err != -ESRCH))	/* filter no recipient errors */
 		/* nlmsg_multicast already kfree_skb'd */
 		goto send_fail;
@@ -554,7 +554,7 @@ fc_host_post_vendor_event(struct Scsi_Ho
 	event->event_code = FCH_EVT_VENDOR_UNIQUE;
 	memcpy(&event->event_data, data_buf, data_len);
 
-	err = nlmsg_multicast(scsi_nl_sock, skb, 0, SCSI_NL_GRP_FC_EVENTS);
+	err = nlmsg_multicast(scsi_nl_sock, skb, 0, SCSI_NL_GRP_FC_EVENTS, GFP_KERNEL);
 	if (err && (err != -ESRCH))	/* filter no recipient errors */
 		/* nlmsg_multicast already kfree_skb'd */
 		goto send_vendor_fail;
---
