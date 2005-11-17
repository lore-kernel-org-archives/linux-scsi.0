From: Douglas Gilbert <dougg@torque.net>
Subject: Re: cdrecord and newer Linux kernels
Date: Thu, 17 Nov 2005 13:10:39 +1000
Message-ID: <437BF4AF.9080801@torque.net>
References: <20051111000913.GU4682@einval.com> <20051116033903.07B1234031@koto.vergenet.net> <20051116123047.GA4092@einval.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:3799 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1161095AbVKQDJj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Nov 2005 22:09:39 -0500
In-Reply-To: <20051116123047.GA4092@einval.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve McIntyre <steve@einval.com>
Cc: Horms <horms@verge.net.au>, debian-kernel@lists.debian.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

Steve McIntyre wrote:
> On Wed, Nov 16, 2005 at 12:39:03PM +0900, Horms wrote:
> 
>>In article <20051111000913.GU4682@einval.com> you wrote:
>>
>>>That does make it rather difficult to have any safe CD/DVD writing
>>>software - do you think it's a good idea to have end users run apps as
>>>root to burn CDs? I've read too much of the cdrecord source to be
>>>happy running that as root! :-) My thought is that it might be better
>>>to allow specific commands on specific drives, and let the local admin
>>>configure that for themselves...
>>>
>>
>>The whole problem is that some IOCTLS are not safe. And there is no
>>definitive list of IOCTLs, so safe ones are added as they are known. And
>>the others are disabled.  If you have discovered ioctls which are indeed
>>safe, then they should be added to the whitelist.
>>
>>As for allowing root to have a mechanism to allow users to access
>>arbitary (unsafe) ioctls, that sounds like a can of worms to me.
>>I have CCed the SCSI maintainers for comment.
>>
>>For their reference, your original post and patch, allong with
>>the rest of this thread is at:
>>
>>http://lists.debian.org/debian-kernel/2005/11/msg00748.html
> 
> 
> Again, I understand why the checks were added to the kernel. Adding
> access controls to limit the damage that could be caused by non-root
> users is entirely a good plan!
> 
> The reason I'm looking into this is that there are some commands that
> may be dangerous on some devices but on others harmless / useful /
> required (even); several years of writing SCSI-based storage
> management software has show me that. :-) Allowing a mechanism for an
> admin to override the in-kernel policy on a per-device, per-command
> basis could allow us to safely allow non-root CD/DVD burning, I hope.

Wouldn't per-user, per_device override be sufficient?
So if the user has CAP_SYS_RAWIO or owns the device
node (and has write permission) then they can do as
they please. The only reason for adding per-command
IMO would be if a command could cause collateral damage
to other devices sharing the same transport.


A user needs read permissions on a device node
to open it and call an ioctl. If a user can format
media via such an ioctl, then at least write
permissions should be required on the format operation.

I find the "root only" policy (CAP_SYS_RAWIO)
for "unknown" opcodes in the block SG_IO ioctl
a little overbearing. Take CD/DVD burners: most
distribution GUIs give that user ownership and read
write permissions on that device node. This is to
facilitate that GUI user burning CD/DVDs with tools
like cdrecord or k3b. It will only take one vendor
specific command or a new SCSI command from the emerging
MMC-5 draft (for HD and Blue ray DVDs) to break the
current scheme. OTOH disk devices typically have
root ownership with no permissions granted to the
GUI user (which seems reasonable).

In larger environments, when there are multiple
different GUI users, then it makes sense to give
only one user (or root) ownership and write
permissions to a specific CD/DVD drive.

The SCSI cdb opcode decoding used by linux is also
pretty crude as it takes no account of the peripheral
device type (e.g. whether the device is a disk or a
DVD drive). The current filtering is heavily skewed
towards the Multi-Media Command (MMC) set used by
CD and DVDs. Since the SCSI Block command (SBC) set
used by disks overlaps with the MMC set in many opcodes,
this filtering scheme is not as tight as some may think.
The st driver (which assumes the streaming command (SSC)
set) overcomes this command set overlap, and potential
interference with its state machines, by requiring that
all block layer SG_IO ioctl access needs CAP_SYS_RAWIO.

Sending non-SCSI command sets, or tunnelling them (e.g.
ATA via the SCSI ATA PASSTHROUGH commands) to the SG_IO
ioctl, creates more filtering headaches.

The sg driver has been playing this filtering game
for some time. It only permits read-only access to
mostly well known SCSI Primary Commands (SPC) with
a few exceptions (e.g. READ CAPACITY). The only time
the sg driver requires root permissions (CAP_SYS_RAWIO)
is an action that may cause collateral damage. The
prime example of that is a bus reset. There is a finer
tuned SCSI task management function to reset a logical
unit and I'm sure the author of cdrecord would like
access to that reset for a user who owns the device.
[Linux is still fuzzy in the differentiation between
a target reset (which would potentially reset all
logical units within that target) and a logical unit
reset.]

For further information about the SG_IO ioctl see:
http://www.torque.net/sg/sg_io.html
with per-command permissions shown in table 3.

My favourite is the START_STOP_UNIT command which is defined
both for MMC (e.g. DVD drive) and SBC (e.g. a disk).
The block layer SG_IO ioctl allows this command
to be sent with only read permissions ( open(,O_RDONLY) ).
Now while the stop variant of that command is relatively
harmless on a DVD drive (e.g. it will delay the next
data access), it is not a good idea to send it to
a mounted SCSI disk (not the way the sd driver would
currently react).

Executive summary: command filtering is very hard to
do correctly thus it is best avoided.

Doug Gilbert

