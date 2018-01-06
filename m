From: Laurence Oberman <loberman@redhat.com>
Subject: Re: HP ProLiant DL360p Gen8 hangs with Linux 4.13+.
Date: Sat, 06 Jan 2018 15:45:02 -0500
Message-ID: <1515271502.7741.1.camel@redhat.com>
References: <CACKvgLEtPRpAS58kn-Skjn65-ZkDK17_cE+OzJodxQ=XvtQPGg@mail.gmail.com>
         <1515169935.3254.2.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:46824 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752708AbeAFUpE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Jan 2018 15:45:04 -0500
Received: by mail-qt0-f179.google.com with SMTP id r39so9589380qtr.13
        for <linux-scsi@vger.kernel.org>; Sat, 06 Jan 2018 12:45:04 -0800 (PST)
In-Reply-To: <1515169935.3254.2.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "don.brace@microsemi.com" <don.brace@microsemi.com>, "vlee@freedesktop.org" <vlee@freedesktop.org>

On Fri, 2018-01-05 at 16:32 +0000, Bart Van Assche wrote:
> On Thu, 2018-01-04 at 14:32 -0800, Vinson Lee wrote:
> > HP ProLiant DL360p Gen8 with Smart Array P420i boots to the login
> > prompt and hangs with Linux 4.13 or later. I cannot log in on
> > console
> > or SSH into the machine. Linux 4.12 and older boot fine.
> > 
> > I see these messages on the console.
> > 
> > [  242.843206] INFO: task scsi_eh_2:465 blocked for more than 120
> > seconds.
> > [  242.877835]       Not tainted 4.15.0-041500rc6-generic
> > #201712312330
> 
> It seems like something got stuck in the block layer. The traditional
> way to
> debug this is to analyze the information that is available under
> /sys/kernel/debug/block. However, since login is not possible we
> can't use
> that approach. Would it be possible for you to check whether this has
> been
> resolved in kernel v4.15-rc6, and if not, bisect this?
> 
> Thanks,
> 
> Bart.

One of the ways to debug this given its an HP DL380 is follow this.

1. Boot the working kernel
2, ensure kdump is activated and running on boot.
3. add these to the /etc/sysctl.conf file

   kernel.panic_on_io_nmi = 1
   kernel.panic_on_unrecovered_nmi = 1
   kernel.unknown_nmi_panic = 1

4, Once hung after boot, go to the ILO page under admin/diagnostics and
press the Virtual NMI button to generate a vmcore

When you have a vmcore, I will give you a place to upload it to so I
can look at it
