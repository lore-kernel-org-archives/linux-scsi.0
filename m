From: Dan Carpenter <error27@gmail.com>
Subject: locking bug in aacraid
Date: Sun, 29 Nov 2009 18:01:43 +0200
Message-ID: <20091129160143.GM10640@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f215.google.com ([209.85.219.215]:55914 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbZK2QBg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2009 11:01:36 -0500
Received: by ewy7 with SMTP id 7so3533501ewy.28
        for <linux-scsi@vger.kernel.org>; Sun, 29 Nov 2009 08:01:41 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: aacraid@adaptec.com

drivers/scsi/aacraid/commsup.c
   518                  } else if (down_interruptible(&fibptr->event_wait)) {
   519                          fibptr->done = 2;
   520                          up(&fibptr->event_wait);
   521                  }

If down_interruptible() returns -EINTR that means we don't need to call
up() as we do on line 520.

regards,
dan carpenter
