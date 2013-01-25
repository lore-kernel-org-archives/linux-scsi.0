From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 02/13] sg_io: reorganize list of allowed commands
Date: Fri, 25 Jan 2013 11:01:38 +0100
Message-ID: <51025802.5020900@redhat.com>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com> <1359039649-17734-3-git-send-email-pbonzini@redhat.com> <20130124224203.GA2373@mtj.dyndns.org> <20130124224921.GB2373@mtj.dyndns.org> <20130124225845.GD2373@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130124225845.GD2373@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Il 24/01/2013 23:58, Tejun Heo ha scritto:
> 
>> +#define sgio_bitmap_set(cmd, mask, rw) \
>> +	if ((mask) != 0) __set_bit((cmd), filter->rw##_ok)
>> +
>> +#define D (1u << TYPE_DISK)           /* Direct Access Block Device (SBC-3) */
>> +#define T (1u << TYPE_TAPE)           /* Sequential Access Device (SSC-3) */
>> +#define L (1u << TYPE_PRINTER)        /* Printer Device (SSC) */
>> +#define P (1u << TYPE_PROCESSOR)      /* Processor Device (SPC-2) */
>> +#define W (1u << TYPE_WORM)           /* Write Once Block Device (SBC) */
>> +#define R (1u << TYPE_ROM)            /* C/DVD Device (MMC-6) */
>> +#define S (1u << TYPE_SCANNER)        /* Scanner device (obsolete) */
>> +#define O (1u << TYPE_MOD)            /* Optical Memory Block Device (SBC) */
>> +#define M (1u << TYPE_MEDIUM_CHANGER) /* Media Changer Device (SMC-3) */
>> +#define C (1u << TYPE_COMM)           /* Communication devices (obsolete) */
>> +#define A (1u << TYPE_RAID)           /* Storage Array Device (SCC-2) */
>> +#define E (1u << TYPE_ENCLOSURE)      /* SCSI Enclosure Services device (SES-2) */
>> +#define B (1u << TYPE_RBC)            /* Simplified Direct-Access (Reduced Block) device (RBC) */
>> +#define K (1u << 0x0f)                /* Optical Card Reader/Writer device (OCRW) */
>> +#define V (1u << 0x10)                /* Automation/Device Interface device (ADC-2) */
> 
> Can we please add TYPE_* constants for these two too?

Ok.

>> +#define F (1u << TYPE_OSD)            /* Object-based Storage Device (OSD-2) */
>> +
>> +	/* control, universal except possibly RBC, read */
>> +
>> +	sgio_bitmap_set(0x00, -1                             , read);  // TEST UNIT READY
> 
> Hmmm... why are we not using symbolic constants for commands?

First, because the table is based on
http://www.t10.org/lists/op-num.txt. Entries in that file look like this:

OP  DTLPWROMAEBKVF  Description
--  --------------  ----------------------------------------------------
00  MMMMMMMMMMMMMM  TEST UNIT READY
01   M              REWIND
01  Z V ZZZZ        REZERO UNIT

which explains a bit the formatting.

Second, because many symbolic constants do not exist in
include/scsi/scsi.h or include/linux/uapi/cdrom.h, and I don't think it
would make sense to add them for a one-off use, especially for obsolete
commands or device types.

> If it's because of horizontal real estate, we can abbreviate
> sgio_bitmap_set(), no?

No, it's not that.  In fact using the symbolic constants would save a
few characters (for the 0xNN and the comment start).  I really prefer to
keep the opcode visible so that you can easily match the code to op-num.txt.

> Also, wouldn't it be better to have ALL
> instead of -1?  Also, the custom formatting is nice but can we at
> least not use //?

ALL instead of -1 is a good idea, or I can just spell it out if it's
okay for you.

// is nicer in my opinion (for this case where we're throwing away all
the rules anyway) because it avoids the misaligned */ but I can change
it of course.

>>> One other thing is I would much prefer if the table was made static
>>> const first.  As we only allow compile-time defined tables, there's no
>>> point in dynamically initializing these and the above can be static
>>> initializers.
>>
>> On the similar line of thoughts, wouldn't it be better to have the
>> table organized by the device type first?  It would be much easier to
>> comprehend which commands are allowed for each device type that way
>> and FWIW it would be more cacheline friendly.  e.g. something like,

It is actually more cacheline friendly like this.  The vast majority of
commands will be READ and WRITE, which are 0x?8 and 0x?A.  So in
practice one cacheline will be shared by all device types, maybe two if
you use READ/WRITE(12) for some devices and READ/WRITE(16) for others.

>> #define M(opcode)	(1 << opcode)
>>
>> #define COMMON	\
>> 	M(READ_6) | M(WRITE_6) | ....
>>
>> static const whatever_type blk_cmd_filter_disk = {
>> 	COMMON				|
>> 	M(CMD_SPECIFIC_TO_THIS_TYPE0)	|
>> 	M(CMD_SPECIFIC_TO_THIS_TYPE2)	|
>> 	...
>> };
> 
> Oops, there are way more bits than in the longest integer, so you
> can't statically initialize them in pretty way (maybe it's possible
> but I can't think of anything pretty).  We can still initialize the
> table once during boot and throw away the init code, I guess.

Yeah, that's what happens because GCC will inline
blk_set_cmd_filter_defaults into its sole caller which is __init.
There's no difference from before this patch, but I can add an explicit
__init to blk_set_cmd_filter_defaults too.

> Also, I
> still think device -> command organization would be better than
> commmand -> device.

This patch ties to keep the list as similar as possible to the old one,
to ease review.  There is usually a 1:1 matching between "old" and "new"
lines, and this limits the freedom I have in organizing the list.

In the next patches I gradually move towards a more structured
organization, usually something like standard->command (one standard may
correspond to more than one device type, but all of them are described
in the same document).

Paolo
