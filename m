From: "John Stoffel" <john@stoffel.org>
Subject: Re: 2.6.24-rc5: tape drive not responding
Date: Mon, 17 Dec 2007 18:47:43 -0500
Message-ID: <18279.2719.394892.692343@stoffel.org>
References: <18277.52079.718004.969358@stoffel.org>
	<20071217112551H.fujita.tomonori@lab.ntt.co.jp>
	<20071217031510.c3d500fd.akpm@linux-foundation.org>
	<18278.55130.471797.398922@stoffel.org>
	<18278.58314.892734.490418@stoffel.org>
	<20071217134344.3f024461.akpm@linux-foundation.org>
	<1197928348.3204.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S936949AbXLQXsq@vger.kernel.org>
In-Reply-To: <1197928348.3204.14.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, John Stoffel <john@stoffel.org>, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@SteelEye.com> writes:

James> On Mon, 2007-12-17 at 13:43 -0800, Andrew Morton wrote:
>> On Mon, 17 Dec 2007 16:02:02 -0500
>> "John Stoffel" <john@stoffel.org> wrote:
>> 
>> > 
>> > Just to confirm, the propsed patch to st.c fixes the issue with
>> > 2.6.24-rc5 as well at 2.6.24-rc5-mm1 with access to my DLT tape
>> > drives.
>> 
>> err, what patch to st.c?

James> That's this one:

James> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=acdd0b1c371b2fbb4b6110a51ba69cb0af9e6f45

>> So it seems that 2.6.24 (and presumably 2.6.23?) need

James> Not 2.6.23 .. the scatterlist changes causing the st problems
James> are local to 2.6.24.

Correct, I ran 2.6.23 for 47+ days of uptime without any problems.  I
jumped to 2.6.24-rc5-mm1 to do my best to help out with finding
problems.  Happy to have found one.  :]

>> 1: Alan's "initio: fix conflict when loading driver" (currently stocuk
>> in git-scsi-misc)

James> Yes, I'm moving this into scsi-rc-fixes

I have nothing to do with this issue.

>> 2: Boaz's "initio: initio_build_scb() fix" (my name for it)

James> And applying this ... although I'd still appreciate confirmation from
James> someone that the initio driver works after this.

Sorry, I don't have of this hardware at all.

>> 3: The mystery st.c fix.
>> 
>> yes?

James> James

Here's the simple one liner patch for the st.c problem:

--- orig/drivers/scsi/st.c     2007-12-16 20:08:45.000000000
-0500
+++ patched/drivers/scsi/st.c   2007-12-17 13:55:30.000000000 -0500
@@ -3611,6 +3611,7 @@
 
        tb->dma = need_dma;
        tb->buffer_size = got;
+	sg_init_table(tb->sg, max_sg);
 
        return tb;
 }


Hopefully it's not whitespace damaged.

John
