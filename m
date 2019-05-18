From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [GIT PULL] final round of SCSI updates for the 5.1+ merge window
Date: Sat, 18 May 2019 03:21:04 -0400
Message-ID: <yq1bm009qjj.fsf@oracle.com>
References: <1558104285.3050.8.camel@HansenPartnership.com>
        <CAHk-=wiAdmRv-Piq6LKvgLDgQC+AV-RYK2O-RC09SRRGq3v1cw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wiAdmRv-Piq6LKvgLDgQC+AV-RYK2O-RC09SRRGq3v1cw@mail.gmail.com>
        (Linus Torvalds's message of "Fri, 17 May 2019 14:20:14 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Linus,

> No. That code is insane. It looks very fishy indeed to me, and I'm not
> pulling it this late in the game.

Yeah, my mess. Sorry.

A couple of people poked me about this issue last week. I merged the
patch without much scrutiny since several people had commented and
tested when it was originally posted a few months back. In looking over
the changes again, however, I agree with your assertion that it is
fishy.

> Just revert the oneliner SCSI change that caused the regression.

My patch wasn't exclusively trying to address the regression wrt. drives
that temporarily come up read-only. Device or fabric events can also
trigger revalidate and there's a whole can of worms in that department
thanks to the intersection between device characteristics changing and
the partition table potentially being updated. This was my feeble
attempt at fixing several long-standing issues in the read-only device
handling which we occasionally hit.

I'll drop the offending patch and revert Jeremy's change for now. And
then revisit the gorge of eternal peril that is revalidate...

-- 
Martin K. Petersen	Oracle Linux Engineering
