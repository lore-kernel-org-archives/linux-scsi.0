From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: sym53c8xx_2 oops in lk 2.5.69-bk14
Date: Wed, 21 May 2003 09:19:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030521091918.A21010@beaverton.ibm.com>
References: <3ECAFCC1.40402@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:21641 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262182AbTEUQKl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2003 12:10:41 -0400
Content-Disposition: inline
In-Reply-To: <3ECAFCC1.40402@torque.net>; from dougg@torque.net on Wed, May 21, 2003 at 02:12:49PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Wed, May 21, 2003 at 02:12:49PM +1000, Douglas Gilbert wrote:
> This oops in the sym53c8xx may have been recently
> introduced since I run rescan-scsi-bus.sh reasonably
> often. It locked my system solid, scrolled the useful
> part of the oops off the screen and put nothing in
> the log. Handwritten notes:

The scsi_host_hn_get is not doing a scsi_host_get, so any scsi_host_put
that follows can break things - for example causing the scsi_host to
disappear out from under us. See the scsi_proc.c usage.

Christoph's "give ->proc_info a struct Scsi_Host * parameter" patch got
rid of a lot of them (and is in scsi-miscs-2.5), but not in scsi_proc.c.

Looks like scsi_host_hn_get should always call scsi_host_get, but
scsi_find_host_by_num really has to change to use driver model iterators
(so its locking protection matches scsi_host_get), I assume this is a WIP
for Christoph or Mike but for now you could use a patch like this
(untested, on top of scsi-misc-2.5 or Christoph's changes):

===== drivers/scsi/hosts.c 1.65 vs edited =====
--- 1.65/drivers/scsi/hosts.c	Thu May 15 06:08:47 2003
+++ edited/drivers/scsi/hosts.c	Fri May 23 10:24:10 2003
@@ -534,8 +534,12 @@
  **/
 struct Scsi_Host *scsi_host_hn_get(unsigned short host_no)
 {
-	/* XXX Inc ref count */
-	return scsi_find_host_by_num(host_no);
+	struct Scsi_Host *shost;
+
+	shost = scsi_find_host_by_num(host_no);
+	if (shost)
+		scsi_host_get(shost);
+	return shost;
 }
 
 /**

-- Patrick Mansfield
