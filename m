From: Christoph Hellwig <hch@infradead.org>
Subject: [mulix@mulix.org: Re: [PATCH] scsi.h uses "u8" which isn't defined.]
Date: Sun, 17 Aug 2003 14:15:11 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030817141511.A11542@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:7955 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S270066AbTHQNPN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Aug 2003 09:15:13 -0400
Received: from hch by phoenix.infradead.org with local (Exim 4.10)
	id 19oNNH-00030P-00
	for linux-scsi@vger.kernel.org; Sun, 17 Aug 2003 14:15:11 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

patch looks fine to me.

----- Forwarded message from Muli Ben-Yehuda <mulix@mulix.org> -----

Date:	Sun, 17 Aug 2003 15:55:33 +0300
From:	Muli Ben-Yehuda <mulix@mulix.org>
Subject: Re: [PATCH] scsi.h uses "u8" which isn't defined.
To:	Dominik Strasser <Dominik.Strasser@t-online.de>
Cc:	linux-kernel@vger.kernel.org

On Sun, Aug 17, 2003 at 02:42:20PM +0200, Dominik Strasser wrote:
> scsi.h uses "u8" which doesn't seem to be defined.
> Better use u_char.
> 
> --- linux/include/scsi/scsi.h   2003-08-17 14:36:02.000000000 +0200
> +++ /tmp/scsi.h 2003-08-17 14:39:42.000000000 +0200
> @@ -226,7 +226,7 @@
>   * ScsiLun: 8 byte LUN.
>   */
>  typedef struct scsi_lun {
> -       u_char scsi_lun[8];
> +       u8 scsi_lun[8];
>  } ScsiLun;

IMO, it's more correct to include <linux/types.h> in scsi.h, which
will bring in u8 and make scsi.h compilable on its own (provided
__KERNEL__ is defined, as it should be). 

Index: include/scsi/scsi.h
===================================================================
RCS file: /home/cvs/linux-2.5/include/scsi/scsi.h,v
retrieving revision 1.10
diff -u -r1.10 scsi.h
--- include/scsi/scsi.h	13 May 2003 06:20:05 -0000	1.10
+++ include/scsi/scsi.h	17 Aug 2003 11:23:01 -0000
@@ -14,6 +14,8 @@
 
 */
 
+#include <linux/types.h> 
+
 /*
  * SCSI command lengths
  */



-- 
Muli Ben-Yehuda
http://www.mulix.org




----- End forwarded message -----
