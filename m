From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI fixes for 4.18-rc3
Date: Fri, 6 Jul 2018 19:31:31 -0700
Message-ID: <CA+55aFy-o3fRtkQnJU=0zv7CPUtgfKiwhfQi_05K25Y_-mx+_w@mail.gmail.com>
References: <1530913134.3135.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530913134.3135.2.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 6, 2018 at 2:38 PM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> This is two minor bug fixes (aacraid, target) and a fix for a potential
> exploit in the way sg handles teardown.

Gahh. Is this where the IB people got their insane model from, using
read/write as ioclt replacements?

We have that ib_safe_file_access() hack for IB for this exact reason.

Who actually does direct read/write to /dev/sg? Could we perhaps just
add a config option to disable it entirely? If you want to send a SCSI
command, why don't you just use SG_IO? That's the only thing that
actually works on most devices (ie anything that isn't /dev/sg, and
nobody sane uses /dev/sg any more).

              Linus
