From: Daniel Debonzi <debonzi@linux.vnet.ibm.com>
Subject: [Fwd: scsi_host_alloc does not check for used shost->host_no]
Date: Mon, 14 Jul 2008 17:06:15 -0300
Message-ID: <487BB1B7.6040802@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060509060306040305000502"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from igw1.br.ibm.com ([32.104.18.24]:34502 "EHLO igw1.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278AbYGNUGu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2008 16:06:50 -0400
Received: from mailhub1.br.ibm.com (mailhub1 [9.18.232.109])
	by igw1.br.ibm.com (Postfix) with ESMTP id 8FA7832C0C5
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2008 16:39:24 -0300 (BRT)
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.18.232.47])
	by mailhub1.br.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6EK6gWs1909034
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2008 17:06:48 -0300
Received: from d24av02.br.ibm.com (loopback [127.0.0.1])
	by d24av02.br.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6EK6bLc011727
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2008 17:06:37 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------060509060306040305000502
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi James,

Sorry if you are not the right person for that but as far as I got no 
directions from the mailing list and your email is on the MAINTAINER 
file, I am trying to contact you directly.

I apologize for any inconvenience.

Regards
Daniel Debonzi

-------- Original Message --------
Subject: scsi_host_alloc does not check for used shost->host_no
Date: Fri, 11 Jul 2008 10:19:09 -0300
From: Daniel Debonzi <debonzi@linux.vnet.ibm.com>
To: linux-scsi@vger.kernel.org

Hi everyone,

First of all, it is the first time I am sending something to one of the
kernel mail lists. So, if it is not the right place for that, if it is
not the only place for that, or I am doing something wrong, or wherever,
please, just let me know.

After a good time investigating why modprobe/rmmod pata_pdc2027x lots of
times was driven to a kernel panic I found out that the problem was on
scsi host layer (if I can call it like this).

In a brief explanation, every time a scsi host is allocated a shost
structure get an host_no attribute assigned an as far as I can see it
should be unique. The point is that this host_no value comes from a
variable that is incremented every time a scsi host is allocated and in
a first moment, we will not have two shost structs with the same
host_no. But for instance, when this always incremented variable
overflows, it does not work anymore and it can happen to have to
different shost structures with the same host_no.

I made a patch that solves the problem in a very simple way, but I don't
know how acceptable it is. I am sending it in attachment and any
feedback will be welcome.

Thanks
Daniel Debonzi


--------------060509060306040305000502
Content-Type: text/x-diff;
 name="scsi_host_no_verify.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_host_no_verify.diff"

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index c6457bf..2e191f4 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -310,7 +310,7 @@ struct device_type scsi_host_type = {
  **/
 struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 {
-	struct Scsi_Host *shost;
+	struct Scsi_Host *shost, *tmp_shost;
 	gfp_t gfp_mask = GFP_KERNEL;
 	int rval;

@@ -332,7 +332,18 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)

 	mutex_init(&shost->scan_mutex);

+	/* 
+	 * Look if host_no is not been used somewhere else. Is is used to
+	 * happen when scsi_host_next_hn overflows and goes back to 0.
+	 */
+ host_no_already_exists:
 	shost->host_no = scsi_host_next_hn++; /* XXX(hch): still racy */
+        if(!IS_ERR(tmp_shost = scsi_host_lookup(shost->host_no)))
+          {
+            scsi_host_put(tmp_shost);
+            goto host_no_already_exists;
+          }
+
 	shost->dma_channel = 0xff;

 	/* These three are default values which can be overridden */


--------------060509060306040305000502--
