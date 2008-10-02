From: <Kevin_Marks@Dell.com>
Subject: RE: Alternative TRIM proposal
Date: Thu, 2 Oct 2008 17:39:17 -0500
Message-ID: <1345AC4A6B8AB74BB5211396D84C746D014E20F9@ausx3mpc109.aus.amer.dell.com>
References: <200810021732.m92HW7qL015836@coles02.co.lsil.com> <OF93179061.8BBD23CF-ON862574D6.006C600D-862574D6.006E8EBB@seagate.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausxipps301.us.dell.com ([143.166.148.223]:26742 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbYJBWkb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 18:40:31 -0400
Content-class: urn:content-classes:message
In-Reply-To: <OF93179061.8BBD23CF-ON862574D6.006C600D-862574D6.006E8EBB@seagate.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerry.Houlder@seagate.com, matthew@wil.cx
Cc: dougg@torque.net, Frederick.Knight@netapp.com, linux-scsi@vger.kernel.org, owner-t10@t10.orgt10@t10.org

Gerry,

The intent of the Trim and Fred can correct me if I'm incorrect, is not
the same as the ATA TRIM command (and hence why it is being changed back
to Punch). It is for thin provisioned LUNs and not really applicable to
HDD's. In the ATA TRIM, I believe there is always enough physical
sectors to map to reported LBA's, in a thin provisioned model, this is
not the case. The Punch command would allow one to shrink the physical
blocks used by a given LUN when they are not need and allocate them to a
different LUN.

I do agree that anything to do with protection information is pointless
and why they would be included regardless of whether a descriptor based
or non-descriptor based command format was choose. 

I also, with little time spent thinking about, could not find a reason
that this command would fail, except sending it to a LUN that was not
thin provisioned or one provide a LBA range that was above the reported
capacity.


Kevin


-----Original Message-----
From: owner-t10@t10.org [mailto:owner-t10@t10.org] On Behalf Of
Gerry.Houlder@seagate.com
Sent: Thursday, October 02, 2008 3:08 PM
To: matthew@wil.cx
Cc: dougg@torque.net; Knight, Frederick; linux-scsi@vger.kernel.org;
owner-t10@t10.org; t10@t10.org
Subject: Re: Alternative TRIM proposal

* From the T10 Reflector (t10@t10.org), posted by:
* Gerry.Houlder@seagate.com
*
I will not be able to attend the call tomorrow, so I will offer my
opinions
on the T10 reflector.

(a) I don't see any point to doing a 12 byte TRIM command. The 16 byte
command is more future proof and any SCSI system (except maybe ATAPI)
that
can do 10 and 12 byte commands can also do 16 byte commands.

(b) Likewise I don't see any point to a 32 byte TRIM command. The extra
fields in the CDB are for checking Protection Information fields
attached
to user data; since the trim command won't transfer any user data these
fields add no value.

(c) You mention things like "checking protection information data before
trimming" or doing a verify operation before trimming? This is a
pointless
waste of time for a bunch of blocks that you wish to delete. All you
really
care about is that only good blocks are reused in the future, when new
information is written. Let the storage device's scrubbing or wear
leveling
algorithms take care of that.

(d) I'm not sure why you don't like the T13 approach, where multiple
extents can be trimmed in one command instead of having to send a
separate
command for each extent to be trimmed. If you tell me that when a person
goes to the GUI file manager and marks 10 files for deletion, some of
which
might be fragmented into several extends, the operating system will only
trim one extent at a time (waiting for each to be trimmed before doing
the
next) rather than combining multiple extents into one interface command
then perhaps there is no advantage to being able to do multiple extents.
The advantage of multiple extents in one command is using less interface
bus bandwidth. The only disadvantage is error recovery; if the command
fails or is aborted for other reasons it is messier because the host has
to
figure out which (if any) of the extents were done and which have to be
retried. I hope you will expound on your reason(s) for liking the one
extent at a time approach.



 

             Matthew Wilcox

             <matthew@wil.cx>

             Sent by:
To 
             owner-t10@t10.org         "Knight, Frederick"

             No Phone Info             <Frederick.Knight@netapp.com>

             Available
cc 
                                       t10@t10.org,

                                       linux-scsi@vger.kernel.org,

             10/02/2008 10:24          dougg@torque.net

             AM
Subject 
                                       Alternative TRIM proposal

 

 

 

 

 

 





* From the T10 Reflector (t10@t10.org), posted by:
* Matthew Wilcox <matthew@wil.cx>
*

There's a meeting tomorrow to discuss the T10 TRIM command.  The current
proposal can be seen at http://t10.org/ftp/t10/document.08/08-149r2.pdf
A related document (discussing READ after TRIM) can be found at
http://t10.org/ftp/t10/document.08/08-347r1.pdf

I'm not keen on the 'pass a list of blocks to be trimmed' model.  I
would
prefer TRIM to be a real command like READ or WRITE.  To that end, here
are my notes on creating such commands, followed by an actual proposal.
I would welcome feedback on this, and it'd be most useful if such
feedback
occurred within the next 24 hours so I can refine the proposal before
the meeting.

Notes
=====

SBC-3 specifies 6, 10, 12, 16 and 32 byte commands for each of READ and
WRITE as well as 10, 12, 16 and 32 byte commands for VERIFY.  While it
is tempting to only define a 32-byte TRIM command, that would prevent
older controllers from supporting TRIM, as well as being wasteful in the
on-wire encoding.  All drivers in Linux support at least 12-byte
commands,
so I think we can avoid defining 6 and 10 byte variants of TRIM in order
to conserve the number of operation codes required for this proposal.

The 12-byte commands allow 32 bits for LBA and 32 bits for transfer
length
(remember these are specified in sectors (normally 512 bytes), so
support
drives up to 2TB in size).  The 16-byte commands expand the LBA size
to 64-bit, supporting drive sizes over 9000 Exabytes (8192 exbibytes,
I suppose).  The 32-byte commands add support for application tags.

The commands also include various fields which may or may not make sense
for TRIM.  Here's a list:

WRPROTECT       | The application may want the device to check
protection
RDPROTECT       | information before allowing the TRIM to succeed.  This
is
VRPROTECT       | the same case as VERIFY with BYTCHK=0.  See table 67
in
                | SAM 3 r14.

DPO             | Disable Page Out is not relevant to TRIM since the
blocks
                | are being discarded.  Checking application tags may
require
                | the blocks to be accessed, but they can always be
discarded
                | immediately.  Recommend this bit be reserved.

FUA             | I don't see a reason to force unit access, recommend
these
FUA_NV          | bits be reserved.

BYTCHK          | There might be a case to be made for allowing the
device
                | to discard only if the data is still what it used to
be,
                | but this would add additional complexity and I don't
know
                | if it's worth it.  Reserve this bit.

GROUP NUMBER    | I can see it being useful to account TRIMs to
different
                | groups and produce statistics about them, so recommend
that
                | GROUP NUMBER be specified as it is for other commands.

CONTROL         | All commands shall contain the CONTROL byte as
specified
by
                | SAM 4.


Proposal
========

Define three new commands, TRIM (12), TRIM (16) and TRIM (32):

TRIM (12)
byte 0          OPERATION CODE (to be assigned)
byte 1          bits 7-5: VRPROTECT, bits 4-0: Reserved
byte 2-5        LOGICAL BLOCK ADDRESS
byte 6-9        TRANSFER LENGTH
byte 10         bits 7-5: Reserved, bits 4-0: GROUP NUMBER
byte 11         CONTROL

TRIM (16)
byte 0          OPERATION CODE (to be assigned)
byte 1          bits 7-5: VRPROTECT, bits 4-0: Reserved
byte 2-9        LOGICAL BLOCK ADDRESS
byte 10-13      TRANSFER LENGTH
byte 14         bits 7-5: Reserved, bits 4-0: GROUP NUMBER
byte 15         CONTROL

TRIM (32)
byte 0          OPERATION CODE (7Fh)
byte 1          CONTROL
byte 2-5        Reserved
byte 6          bits 7-5: Reserved, bits 4-0: GROUP NUMBER
byte 7          ADDITIONAL CDB LENGTH (18h)
byte 8-9        SERVICE ACTION (to be assigned)
byte 10         bits 7-5: VRPROTECT, bits 4-0: Reserved
byte 11         Reserved
byte 12-19      LOGICAL BLOCK ADDRESS
byte 20-23      EXPECTED INITIAL LOGICAL BLOCK REFERENCE TAG
byte 24-25      EXPECTED LOGICAL BLOCK APPLICATION TAG
byte 26-27      LOGICAL BLOCK APPLICATION TAG MASK
byte 28-31      TRANSFER LENGTH


--
Matthew Wilcox                          Intel Open Source Technology
Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

*
* For T10 Reflector information, send a message with
* 'info t10' (no quotes) in the message body to majordomo@t10.org


*
* For T10 Reflector information, send a message with
* 'info t10' (no quotes) in the message body to majordomo@t10.org
