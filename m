From: Dan Merillat <harik.attar@gmail.com>
Subject: Re: Megaraid lockup on 2.6.[7-8]
Date: Mon, 9 Aug 2004 15:33:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <c0c0679004080915331801dc0d@mail.gmail.com>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC937@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.194]:59678 "EHLO mproxy.gmail.com")
	by vger.kernel.org with ESMTP id S267325AbUHIWdY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2004 18:33:24 -0400
Received: by mproxy.gmail.com with SMTP id 73so119566rnk
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2004 15:33:23 -0700 (PDT)
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC937@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <atulm@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 9 Aug 2004 10:11:42 -0400 , Mukker, Atul <atulm@lsil.com> wrote:
> Dan,
>
> I speculate your drives are good. BTW, what raid level they are in? Also,
> have you considered your drives enclosure as a possible source of errors. I
> would highly recommended trying another box and see if it changes anything.
> I can suggest FW trace collection, but let's wait a bit for that.

Raid 5.  I've used AMI/LSI cards for quite a while (4 years?) and
normally if there's
any SCSI/drive problem, the internal alarm sounds and the array goes
into degraded
or offline mode.  In this case, a full consistancy check/rebuild of
the drives succeeds,
but running in linux for 4-5 minutes errors out.

I would try a different enclosure, but I don't have one available.
(SCA drives in hotswap enclosures).


> The latest 2.20 series of drivers
> (ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.20.2.0/) should
> support your card. This driver does have more extensive error reporting
> capabilities.

Actually, they don't.  They work once you include the PCI ID in the
table, though.
Since you said they 'should work' I went ahead and dug around and patched them.

Here's the PCI ID for this card, you may want to add the rest of the
megaraid series
IDs to the driver:

0000:01:02.0 Class 0104: 101e:1960 (rev 02)
        Subsystem: 101e:0475
        Flags: bus master, medium devsel, latency 64, IRQ 27
        Memory at fc1f0000 (32-bit, prefetchable) [size=febf8000]
        Expansion ROM at 00008000 [disabled]
        Capabilities: <available only to root>

So far, so good.  When I stress-tested it I had a device-mapper related lockup,
but no scsi/Megaraid problems.   I'll report back in a few days if I
get any further errors.

--Dan
