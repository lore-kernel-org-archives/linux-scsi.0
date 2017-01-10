From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Advanced Format SAT devices show incorrect physical block size
Date: Tue, 10 Jan 2017 15:29:23 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1701101520510.2462-100000@iolanthe.rowland.org>
References: <CABhjJhMN31Ooq5ewpBft97w2+UpYM8S_hkpgwWm3a0wBhXW14g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49668 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1750720AbdAJU3Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2017 15:29:24 -0500
In-Reply-To: <CABhjJhMN31Ooq5ewpBft97w2+UpYM8S_hkpgwWm3a0wBhXW14g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?Q?Dainius_Masili=C5=ABnas?= <pastas4@gmail.com>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Tom Yan <tom.ty89@gmail.com>

On Tue, 10 Jan 2017, Dainius Masiliūnas wrote:

> Huh, intersting to know. Why would they die on 16 and not on 10? Also,

Probably because they are too old to support READ CAPACITY(16) 
correctly.

> wouldn't the right way to handle it be to use a quirk for broken
> models, then? Since my disk seems to work fine in that regard.

There _is_ a quirk for broken models.  However, we don't know how
complete the set of quirk entries is, so we err on the side of caution.


On Tue, 10 Jan 2017, Pali Rohár wrote:

> On Tuesday 10 January 2017 21:02:09 Alan Stern wrote:
> > Quick summary: READ CAPACITY(10) does not include physical sector
> > size information whereas READ CAPACITY(16) does.  But the kernel
> > uses READ CAPACITY(10) by default for USB drives, because quite a
> > few of them die when given a READ CAPACITY(16) command.
>
> Ah :-( Are there lot of "broken" devices for creating blacklist?

I have no idea how many there are.

> > If you can suggest a way to fix this, we'll be glad to hear it.
>
> Tom Yan wrote that smartctl/hdparm "works" because they use the SCSI ATA
> PASSTHROUGH command. It is not an option for kernel?

No, because many devices do not implement SCSI ATA PASSTHROUGH.  
(Consider devices whose underlying technology does not use ATA or SATA,
for example.)  And some of the ones that don't implement it will die if
you try to send them an ATA PASSTHROUGH command.

You have to understand that consumer USB storage really is very
low quality in many cases.  Vendors aim for low cost rather than high 
reliability or correctness.

Alan Stern

