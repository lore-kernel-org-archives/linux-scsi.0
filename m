From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: Plextor PowerRec for users
Date: Sun, 12 Feb 2006 20:36:15 +0100
Message-ID: <m3oe1c5pzk.fsf@merlin.emma.line.org>
References: <200602121718.15200.T.Maguin@web.de>
	<20060212165327.GG12822@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.21]:905 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1750884AbWBLTgT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Feb 2006 14:36:19 -0500
In-Reply-To: <20060212165327.GG12822@parisc-linux.org> (Matthew Wilcox's
	message of "Sun, 12 Feb 2006 09:53:27 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Thomas Maguin <T.Maguin@web.de>, linux-scsi@vger.kernel.org

Matthew Wilcox <matthew@wil.cx> writes:

> On Sun, Feb 12, 2006 at 05:18:04PM +0100, Thomas Maguin wrote:
>> Blame on me, a typo in the addresses. Changes should be this:
>> (patch is on the way)
>> 
>> /usr/src/linux/include/scsi/scsi.h
>> +#define PLEXTOR_MODE ?? ?? ?? ?? ?? ?? ?? ?? ??0xe9
>> +#define PLEXTOR_PREC_SPEEDS ?? 0xeB
>> +#define PLEXTOR_MODE2 ?? ?? ?? ?? ?? ?? ?? ??0xeD
>> 
>> /usr/src/linux/block/scsi/scsi_ioctl.c
>> +safe_for_read(PLEXTOR_MODE)
>> +safe_for_read(PLEXTOR_PREC_SPEEDS)
>> +safe_for_read(PLEXTOR_MODE2)
>
> The trouble is that these are vendor-specific commands.  So they're safe
> *for plextor devices*, but they may well be unsafe for other vendors.
> Given the LG CD-ROM snafu [1], I'd expect people to err on the side
> of caution.  Sorry.

The LG disaster is unrelated, they overloaded a *standard* command for
their own purposes. Outright stupid, but that's LG's problem, not
Linux's.

This is about vendor-specified opcodes being whitelisted. I, too,
consider this dangerous, unless someone desires to implement two tables
in the kernel:

Table 1 maps drive/model/firmware pairs to a command set table (table 2)
-- this is for compression, as many drive/model/firmware patterns can
share the same command whitelist

Table 2 implements the actual whitelists.

And if someone is going this way, perhaps the kernel should only have
the mechanism and receive the tables at boot-time from a user space
process (hotplug or whatever) so it doesn't need to keep a gazillion of
tables in core for drives the user will never have.

-- 
Matthias Andree
