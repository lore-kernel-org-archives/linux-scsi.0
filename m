From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCHv2 5/5] scsi: move scsi/sg.h to uapi/linux/sg.h
Date: Fri, 30 Jan 2015 12:28:36 -0500
Message-ID: <54CBBF44.5060308@interlog.com>
References: <1422579397-18696-1-git-send-email-agrover@redhat.com> <1422579397-18696-6-git-send-email-agrover@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:44860 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825AbbA3R2s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2015 12:28:48 -0500
In-Reply-To: <1422579397-18696-6-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, hch@lst.de

On 15-01-29 07:56 PM, Andy Grover wrote:
> This will enable user programs to have access to the most current
> definitions.

The above description is a bit too generic.


At the moment many user space programs in Linux access the SG_IO
ioctl related declarations with:
    #include <scsi/sg.h>

I suspect that file is maintained by the glib folks (because it
does not match the kernel file but is logically equivalent). Now
if this change encourages those glib folks to break the above
include (same applies to '#include <scsi/sg.h>') then that is
a serious regression.

So is this delayed regression likely to happen?? Do we need to
speak to the glib folks?

What is the appropriate include for a user space program to fetch
sg.h in its new (proposed) location?


For example my utilities currently use:
    #include <linux/bsg.h>
to fetch the bsg header but need some autotools magic to not break
in the absence of that header (e.g. prior to around lk 2.6.30).

Finally isn't the semi-flat nature of the uapi/linux directory
asking for trouble? IOW why isn't there a uapi/linux/scsi
directory?

   # cd /usr/src/linux-3.19/include/uapi/linux/
   # ls | wc
     440     440    4350
   # ls -p | grep "/" | wc
      24      24     204

The last command is counting directories (and really should
be simpler than that).


Doug Gilbert




