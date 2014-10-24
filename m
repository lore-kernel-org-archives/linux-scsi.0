From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Concurrent SG_SCSI_RESET ioctls
Date: Fri, 24 Oct 2014 18:29:33 +0200
Message-ID: <544A7E6D.5070908@interlog.com>
References: <94D0CD8314A33A4D9D801C0FE68B402958CE9B54@G4W3202.americas.hpqcorp.net> <20141011161110.GA16812@infradead.org> <94D0CD8314A33A4D9D801C0FE68B402958CEB20A@G4W3202.americas.hpqcorp.net> <20141014111354.GA3022@infradead.org> <543D5272.5080102@interlog.com> <20141024145131.GA2940@infradead.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:36081 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390AbaJXQaA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Oct 2014 12:30:00 -0400
In-Reply-To: <20141024145131.GA2940@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "James Bottomley (jbottomley@parallels.com)" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Don Brace (PMC)" <Don.Brace@pmcs.com>, "Scales, Webb" <webb.scales@hp.com>

On 14-10-24 04:51 PM, Christoph Hellwig wrote:
> On Tue, Oct 14, 2014 at 12:42:26PM -0400, Douglas Gilbert wrote:
>> I don't mind if you change it. However I plan to release
>> sg3_utils-1.40 in the next 2 or 3 weeks, so that would
>> be the earliest a revised sg_reset would be available for
>> distros. Improving error reports is something I always
>> like to do (so ENODEV for the "in progress" case seems a
>> bit strident).
>
> Doug, are you fine with changing the error code to EAGAIN
> similar to what we get elsewhere when a O_NONBLOCK open
> would have to block?  If that's something you can prepare
> sg3_utils for I'd like to send a patch for it for the 3.19 merge
> window.

Yes, that's fine.

Just expanded the sg_reset ioctl erorr processing to this:

     switch (errno) {
     case EBUSY:
         fprintf(stderr, ME "BUSY, may be resetting now\n");
         break;
     case ENODEV:
         fprintf(stderr, ME "'no device' error, may be temporary while "
                 "device is resetting\n");
         break;
     case EAGAIN:
         fprintf(stderr, ME "try again later, may be resetting now\n");
         break;
     case EIO:
         fprintf(stderr, ME "reset (for value=0x%x) may not be "
                 "available\n", k);
         break;
     case EPERM:
     case EACCES:
         fprintf(stderr, ME "reset requires CAP_SYS_ADMIN (root) "
                 "permission\n");
         break;
     case EINVAL:
         fprintf(stderr, ME "SG_SCSI_RESET not supported (for "
                 "value=0x%x)\n", k);
     default:
         perror(ME "SG_SCSI_RESET failed");
         break;
     }

The ENODEV, EAGAIN and EPERM entries are new. In the sg_reset
implementation currently in the field they will drop down to
the default case and do a perror().

With the ioctl(SG_IO), it is sufficient to give a user permissions
on the device node (e.g. 'chmod 666 /dev/sg2; sg_turs /dev/sg2')
to pass through a command. However with ioctl(SG_SCSI_RESET),
another check is done by the ioctl and if it fails then it yields
EACCES .


Doug Gilbert


