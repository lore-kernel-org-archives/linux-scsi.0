From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 0/9] target: Add support for EXTENDED_COPY (VAAI) offload
 emulation
Date: Fri, 23 Aug 2013 15:13:10 +0200
Message-ID: <52175FE6.4040309@interlog.com>
References: <1377224821-23422-1-git-send-email-nab@daterainc.com> <521741B7.9020904@interlog.com> <yq17gfc60yd.fsf@sermon.lab.mkp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq17gfc60yd.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, Zach Brown <zab@redhat.com>, Kent Overstreet <kmo@daterainc.com>, Theodore Tso <tytso@mit.edu>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 13-08-23 02:33 PM, Martin K. Petersen wrote:
>>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:
>
> Doug> The SCSI opcodes associated with it (0x83 and 0x84) have been
> Doug> renamed THIRD PARTY COPY OUT and IN, and
>
> Where did you see that? My SPC still has EXTENDED COPY.

SCSI _opcodes_ == SCSI operation codes. In other words the
name associated with all service actions (commands) that have
as their first byte 0x83 and 0x84 .

spc4r36h.pdf Annex F.3.1 and changed in spc4r34. Yes, well
hidden but IMO useful. So now we can use the term "Third party
copy" to cover:
   - EXTENDED COPY(LID1) and associated commands
     also found in SPC-2 and SPC-3 (with the "LID1" suffix)
   - EXTENDED COPY(LID4) and associated commands
   - the XCOPY LITE commands: POPULATE TOKEN and WRITE USING TOKEN

> Doug> Confused? I certainly was.
>
> Yeah, this is UNMAP all over again, just 100 times worse :(

Well what EXTENDED COPY (offload copy) is trying to do
ain't simple but obviously there could be a substantial
performance pay-off.

There is a "Third-party copy implementation and usage" Annex
(D) in spc4r36h.pdf . It could do with some more explanatory
text.

> Anyway. Excited to see nab posting the patches! My copy offload code
> from the spring has been getting stale both in the T10 and the kernel
> sense. But at least we know what I'll be working on next week :)

BTW I have ported the sg_xcopy "LID1" xcopy logic into
my ddpt utility. That gives two advantages:
   - can cope with ibs!=obs
   - runs on OSes other than Linux

Doug Gilbert
