From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] final round of SCSI updates for the 5.1+ merge window
Date: Fri, 17 May 2019 14:20:14 -0700
Message-ID: <CAHk-=wiAdmRv-Piq6LKvgLDgQC+AV-RYK2O-RC09SRRGq3v1cw@mail.gmail.com>
References: <1558104285.3050.8.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1558104285.3050.8.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, May 17, 2019 at 7:44 AM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> This is the final round of mostly small fixes in our initial
> submit.  The fix for the read only regressions is the most extensive
> change and also intrudes outside of SCSI because the partition and read
> only handling is mostly in block.

No. That code is insane. It looks very fishy indeed to me, and I'm not
pulling it this late in the game.

If the partition table gets re-read, the old read-only state should go
away - for all ew know, the partition numbers may have changed, for
chrissake! So you can't just say "oh, partition number 1 used to be
read-only, so now we need to keep it read-only". That partition might
be something completely different after the parition table has been
invalidated.

So the new model that code uses looks completely bogus to me, and is
not anything we've ever done before.

Just revert the oneliner SCSI change that caused the regression.

             Linus
