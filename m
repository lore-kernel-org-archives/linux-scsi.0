From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH -next] osd_uld: fix printk format warning
Date: Thu, 30 Apr 2009 13:30:07 +0300
Message-ID: <49F97DAF.2050605@panasas.com>
References: <20090429092631.a76e79c5.randy.dunlap@oracle.com> <20090429185128.GN8633@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:50618 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbZD3KaT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2009 06:30:19 -0400
Received: by qw-out-2122.google.com with SMTP id 5so1471724qwd.37
        for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2009 03:30:19 -0700 (PDT)
In-Reply-To: <20090429185128.GN8633@ZenIV.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-scsi@vger.kernel.org

On 04/29/2009 09:51 PM, Al Viro wrote:
> On Wed, Apr 29, 2009 at 09:26:31AM -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fix printk format warnings in osd_uld:
>>
>> drivers/scsi/osd/osd_uld.c:191: warning:format '%s' expects type 'char *', but argument 2 has type 'struct path'
>>
>> Also fix a small typo.
> 
> Applied, will fold on reorder.  Thanks for catching that one and apologies
> for missing the original posting (I am subscribed to linux-scsi, but...)
> 
> Incidentally, what the hell is going with ->i_cdev in there?  Boaz?

Thanks for asking. The thing is that this function is called from within
the kernel by exofs. Now I have found that if user-mode as never opened
an handle on my char-device, then inode->i_cdev is NULL even though it is
registered and found. My mount utility for exofs does an open/close on the
char-device before calling the Kernel mounter, but this is just a script
and can be missed by users. (I guess I need to submit an mount.exofs. where
should it be submitted?)

Alternatively we perhaps need a udev rule that, one - loads osd.ko when
OSD_TYPE devices are discovered by scsi (like sd), and two - do the above
open/close. I was meaning to ask someone about these things.

Much obliged
Boaz
