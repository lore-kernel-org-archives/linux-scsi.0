From: Yum Rayan <yum.rayan@gmail.com>
Subject: Re: [2.6 patch] drivers/scsi/sg.c: several against 2.6.12-rc1
Date: Mon, 28 Mar 2005 20:46:14 -0800
Message-ID: <df35dfeb05032820467ee1ad4c@mail.gmail.com>
References: <4247D2DA.5010009@torque.net>
Reply-To: Yum Rayan <yum.rayan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.200]:54286 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262177AbVC2EqP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2005 23:46:15 -0500
Received: by wproxy.gmail.com with SMTP id 68so501095wri
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2005 20:46:14 -0800 (PST)
In-Reply-To: <4247D2DA.5010009@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, bunk@stusta.de, James.Bottomley@steeleye.com, rddunlap@osdl.org

In the diff

>+	if (old_hdr)
>+		kfree(old_hdr);
>+	return retval;

The check for NULL is not needed.

Thanks,
Rayan


On Mon, 28 Mar 2005 19:48:10 +1000, Douglas Gilbert <dougg@torque.net> wrote:
> The attachment combines the most recent patch from
> Yum Rayan <yum.rayan@gmail.com> (to reduce sg stack
> usage), Adrian Bunk <bunk@stusta.de> (to fix check
> after use) and me (fix elapsed time calculation
> (duration) on ia64 machines).
> 
> I have modified the patch from Yum Rayan so kmalloc()
> in sg_read() is only called for the (rare) code paths
> that need them.
> 
> Changelog:
>   - reduce stack usage in sg_ioctl() and sg_read()
>   - fix check after use in sg_mmap()
>   - hold duration internally in milliseconds and
>     check current time later than held time
> 
> Signed-off-by: Douglas Gilbert <dougg@torque.net>
> 
> 
>
