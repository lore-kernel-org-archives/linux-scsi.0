From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] st.c for GET_IDLUN 2.6.6-rc2
Date: Mon, 26 Apr 2004 19:12:55 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0404261858140.24847@kai.makisara.local>
References: <408B798B.50005@torque.net> <Pine.LNX.4.58.0404251153530.17534@kai.makisara.local>
 <408C5C72.4020301@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:19709 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S263032AbUDZQNI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Apr 2004 12:13:08 -0400
In-Reply-To: <408C5C72.4020301@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: osst@riede.org, linux-scsi@vger.kernel.org

On Mon, 26 Apr 2004, Douglas Gilbert wrote:

> Kai Makisara wrote:
....
> > 2. Reversing the order of calls in st so that scsi_ioctl is called first 
> > and if it returns -ENOTTY, then scsi_cmd_ioctl is called. This would 
> > require changing scsi_ioctl to return -ENOTTY for commands not being 
> > handled but would be othewise a logical solution: first try SCSI specific 
> > implementation of the ioctl, if it does not exist, then try the block 
> > layer version (Linux block layer, not Unix block layer ;-).
> 
> This solution looks cleaner.
> 
I looked at the necessary changes a little more carefully and I think
your solution is better from the practical point of view. The problem in  
my solution is to make sure that scsi_ioctl() returns -ENOTTY in case it 
does not implement the ioctl. This is easy except for the default case:

                if (sdev->host->hostt->ioctl)
                        return sdev->host->hostt->ioctl(sdev, cmd, arg);

where any kind of code can be found ;-) It is safer to leave this as the
last resort.

-- 
Kai
