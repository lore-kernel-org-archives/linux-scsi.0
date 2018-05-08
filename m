From: Oliver Neukum <oneukum@suse.com>
Subject: Re: [usb-storage] [PATCH] usb: storage: Fix a possible data race in
 uas_queuecommand_lck
Date: Tue, 08 May 2018 10:27:50 +0200
Message-ID: <1525768070.24345.8.camel@suse.com>
References: <20180508074743.13622-1-baijiaju1990@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180508074743.13622-1-baijiaju1990@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@gmail.com>, stern@rowland.harvard.edu, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Am Dienstag, den 08.05.2018, 15:47 +0800 schrieb Jia-Ju Bai:
> The write operations to "cmnd->result" and "cmnd->scsi_done" 
> are protected by the lock on line 642-643, but the write operations 
> to these data on line 634-635 are not protected by the lock.
> Thus, there may exist a data race for "cmnd->result" 
> and "cmnd->scsi_done".

No,

the write operations need no lock. The low level driver at this point
owns the command. We cannot race with abort() for a command within
queuecommand(). We take the lock where we take it to protect
dev->resetting.

I don't see why the scope of the lock would need to be enlarged.

	Regards
		Oliver

> To fix this data race, the write operations on line 634-635 
> should be also protected by the lock.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Nacked-by: Oliver Neukum <oneukum@suse.com>
