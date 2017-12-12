From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI fixes for 4.15-rc3
Date: Tue, 12 Dec 2017 09:16:16 -0800
Message-ID: <CA+55aFy8hepLBW9Zvfk4MgibG4eHF5qkmon+2Zs6KWLQfFH-fg@mail.gmail.com>
References: <1513095686.3110.9.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513095686.3110.9.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 12, 2017 at 8:21 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> The most important one is the bfa fix because it's easy to oops the
> kernel with this driver, a regression in the new timespec conversion in
> aacraid and a regression in the Fibre Channel ELS handling patch.  The
> other three are a theoretical problem with termination in the
> vendor/host matching code and a use after free in lpfc.

No, this is just complete garbage.

> Johannes Thumshirn (1):
>       scsi: bfa: fix access to bfad_im_port_s

This is utter shite, and doesn't even compile cleanly.

Sure, it's "just" a warning, and the code works. But no, I'm not
pulling crap like this. If you save a pointer in an integer
"hostdata[0]" field, then you damn well do the proper casts or helper
functions or something, you don't just ignore the compiler when it
very reasonably warns about it.

What the hell is going on? Nobody compiled this stuff at all? Or
nobody cares about new build warnings?

That is not acceptable.

                          Linus
