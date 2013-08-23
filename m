From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 0/9] target: Add support for EXTENDED_COPY (VAAI) offload
 emulation
Date: Fri, 23 Aug 2013 13:04:23 +0200
Message-ID: <521741B7.9020904@interlog.com>
References: <1377224821-23422-1-git-send-email-nab@daterainc.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377224821-23422-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, Zach Brown <zab@redhat.com>, Kent Overstreet <kmo@daterainc.com>, Theodore Tso <tytso@mit.edu>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 13-08-23 04:26 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@daterainc.com>
>
> Hi folks!
>
> This series adds support to target-core for generic EXTENDED_COPY offload
> emulation as defined by SPC-4 using virtual (IBLOCK, FILEIO, RAMDISK)
> backends.
>
> EXTENDED_COPY is a VMWare ESX VAAI primative that is used to perform copy
> offload, that allows a target to perform local READ + WRITE I/O requests
> for bulk data transfers (cloning a virtual machine for example), instead
> of requiring these I/Os to actually be sent to/from the requesting SCSI
> initiator port.

Recently I have been looking at EXTENDED COPY since
T10 has been working on it. The SCSI opcodes associated
with it (0x83 and 0x84) have been renamed THIRD PARTY
COPY OUT and IN, and each have several service actions.
The Extended copy found in SPC-2 and SPC-3 is now
termed as "LID1" (for List Identifier length of 1 byte)
while the new stuff is termed "LID4" in SPC-4. The
"LID4" variants are "ROD" token based. A ROD
(Representation Of Data) token is 512 bytes long.

sg_xcopy (written by Hannes Reinecke and found in the
sg3_utils package) only supports LID1 but that covers
most of the existing hardware including kit that
supports VMWare ESX VAAI.

As defined by T10 both EXTENDED COPY (LID1) and (LID4)
do copies between disks, tapes and memory (all
combinations (e.g. disk->tape) (but maybe not memory
to memory).

There is a stripped down version of EXTENDED COPY(LID4)
that was called XCOPY LITE at one stage that only does
disk to disk copies (based on a ROD token). That is
the basis of Microsoft's Offload Data Transfer (ODX).
It uses commands defined in SBC-3 (e.g. POPULATE TOKEN
and WRITE USING TOKEN).


Confused? I certainly was. Feel free to correct and
clarify the above.

Doug Gilbert
