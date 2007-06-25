From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Tue, 26 Jun 2007 00:53:40 +0200
Message-ID: <46804774.6090401@s5r6.in-berlin.de>
References: <668935.63901.qm@web31812.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:53414 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbXFYWxv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jun 2007 18:53:51 -0400
In-Reply-To: <668935.63901.qm@web31812.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Doug Maxey <dwm@enoyolf.org>, James Bottomley <James.Bottomley@SteelEye.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> Indeed it is more accurate to represent LUNs in 64 bit format.
> 
> It is even more accurate to represent them as u8 LUN[8], and possibly
> print them as
>   "0x%016llx"   ((unsigned long long) be64_to_cpu(*(__be64 *)(LUN))).

Might need a little precaution on some architectures.

--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -249,7 +249,7 @@ struct ccs_modesel_head {
  */
 struct scsi_lun {
        __u8 scsi_lun[8];
-};
+} __attribute__((aligned(8)));

 /*
  *  MESSAGE CODES
-- 
Stefan Richter
-=====-=-=== -==- ==-=-
http://arcgraph.de/sr/
