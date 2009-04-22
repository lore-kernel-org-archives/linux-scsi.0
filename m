From: Dan Carpenter <error27@gmail.com>
Subject: double unlock in aac_fib_send()
Date: Wed, 22 Apr 2009 18:38:52 +0300 (EAT)
Message-ID: <alpine.DEB.2.00.0904211811430.27999@bicker>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:30365 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbZDVPj3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 11:39:29 -0400
Received: by wa-out-1112.google.com with SMTP id j5so12714wah.21
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2009 08:39:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aacraid@adaptec.com
Cc: linux-scsi@vger.kernel.org

This is from drivers/scsi/aacraid/commsup.c (2.6.30-rc1)
   518                  } else if (down_interruptible(&fibptr->event_wait)) {
   519                          fibptr->done = 2;
   520                          up(&fibptr->event_wait);
   521                  }

down_interruptible() returns zero if it aquires the lock or -EINTR on 
failure.  Since we failed to aquire the lock there is no need to call up() 
on line 520.

Found by smatch (http://repo.or.cz/w/smatch.git).

regards,
dan carpenter
