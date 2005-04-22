From: Yum Rayan <yum.rayan@gmail.com>
Subject: RE: Kernel OOPS with aacraid driver
Date: Fri, 22 Apr 2005 00:08:53 -0700
Message-ID: <df35dfeb050422000856c882d6@mail.gmail.com>
Reply-To: Yum Rayan <yum.rayan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.204]:15181 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261994AbVDVHIx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2005 03:08:53 -0400
Received: by wproxy.gmail.com with SMTP id 68so823386wri
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2005 00:08:53 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Klaus.Steinberger@physik.uni-muenchen.de, linux-scsi@vger.kernel.org
Cc: rddunlap@osdl.org

> > BTW, this says that this is the second oops:  "[#2]".
> > What was the first one?
> Apr 21 10:53:27 www adaptec-smbe: aiomgrd startup succeeded
> Apr 21 10:53:27 www kernel: Unable to handle kernel NULL 
> pointer dereference 
> at virtual address 00000034

Seems to me like someone is issuing IOCTL's against devices that do
not exist. Does this patch against linux-2.6.12-rc3 make sense and
applicable to you?

Seems like aac_cfg_open() will return success even if it fails? This
patch fixes it to actually return error.

Regards,
Rayan

diff -Nupr -X dontdiff linux-2.6.12-rc3.a/drivers/scsi/aacraid/linit.c
linux-2.6.12-rc3.b/drivers/scsi/aacraid/linit.c
--- linux-2.6.12-rc3.a/drivers/scsi/aacraid/linit.c	2005-04-21
23:56:31.000000000 -0700
+++ linux-2.6.12-rc3.b/drivers/scsi/aacraid/linit.c	2005-04-21
23:57:26.000000000 -0700
@@ -450,7 +450,7 @@ static int aac_cfg_open(struct inode *in
 		}
 	}
 
-	return 0;
+	return err;
 }
 
 /**
