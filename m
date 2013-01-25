From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 02/13] sg_io: reorganize list of allowed commands
Date: Fri, 25 Jan 2013 09:13:05 -0800
Message-ID: <20130125171305.GD3081@htj.dyndns.org>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
 <1359039649-17734-3-git-send-email-pbonzini@redhat.com>
 <20130124224203.GA2373@mtj.dyndns.org>
 <20130124224921.GB2373@mtj.dyndns.org>
 <20130124225845.GD2373@mtj.dyndns.org>
 <51025802.5020900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51025802.5020900@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Hello, Paolo.

On Fri, Jan 25, 2013 at 11:01:38AM +0100, Paolo Bonzini wrote:
> First, because the table is based on
> http://www.t10.org/lists/op-num.txt. Entries in that file look like this:
> 
> OP  DTLPWROMAEBKVF  Description
> --  --------------  ----------------------------------------------------
> 00  MMMMMMMMMMMMMM  TEST UNIT READY
> 01   M              REWIND
> 01  Z V ZZZZ        REZERO UNIT
> 
> which explains a bit the formatting.

Ah, okay, if it's something already established, please go ahead.

> Second, because many symbolic constants do not exist in
> include/scsi/scsi.h or include/linux/uapi/cdrom.h, and I don't think it
> would make sense to add them for a one-off use, especially for obsolete
> commands or device types.

It's kinda nice to be able to search for the constants for usages in
kernel.  It's not complete but does help from time to time.

> > If it's because of horizontal real estate, we can abbreviate
> > sgio_bitmap_set(), no?
> 
> No, it's not that.  In fact using the symbolic constants would save a
> few characters (for the 0xNN and the comment start).  I really prefer to
> keep the opcode visible so that you can easily match the code to op-num.txt.

How many constants need to be added?  I guess this ties to the other
thread on why it's desirable to add all listed commands.  If you're
just gonna add several, there's no point in not using the constants,
right?  Most are already there.  If you want opcodes visible, you can
make them the comments, right?

> > Also, wouldn't it be better to have ALL
> > instead of -1?  Also, the custom formatting is nice but can we at
> > least not use //?
> 
> ALL instead of -1 is a good idea, or I can just spell it out if it's
> okay for you.

Yeah, both sound fine to me.

> // is nicer in my opinion (for this case where we're throwing away all
> the rules anyway) because it avoids the misaligned */ but I can change
> it of course.

Let's please not do //.

> >> On the similar line of thoughts, wouldn't it be better to have the
> >> table organized by the device type first?  It would be much easier to
> >> comprehend which commands are allowed for each device type that way
> >> and FWIW it would be more cacheline friendly.  e.g. something like,
> 
> It is actually more cacheline friendly like this.  The vast majority of
> commands will be READ and WRITE, which are 0x?8 and 0x?A.  So in
> practice one cacheline will be shared by all device types, maybe two if
> you use READ/WRITE(12) for some devices and READ/WRITE(16) for others.

The cacheline thing was me being confused about how the tables are
used.  The tables are per-device after initialized so it should be
fine.

> >> #define M(opcode)	(1 << opcode)
> >>
> >> #define COMMON	\
> >> 	M(READ_6) | M(WRITE_6) | ....
> >>
> >> static const whatever_type blk_cmd_filter_disk = {
> >> 	COMMON				|
> >> 	M(CMD_SPECIFIC_TO_THIS_TYPE0)	|
> >> 	M(CMD_SPECIFIC_TO_THIS_TYPE2)	|
> >> 	...
> >> };
> > 
> > Oops, there are way more bits than in the longest integer, so you
> > can't statically initialize them in pretty way (maybe it's possible
> > but I can't think of anything pretty).  We can still initialize the
> > table once during boot and throw away the init code, I guess.
> 
> Yeah, that's what happens because GCC will inline
> blk_set_cmd_filter_defaults into its sole caller which is __init.
> There's no difference from before this patch, but I can add an explicit
> __init to blk_set_cmd_filter_defaults too.

Maybe I'm misreading the code but we're still initializing table per
queue, right?  Can't we just have per-type tables which are populated
during boot (or on-demand)?

Thanks.

-- 
tejun
