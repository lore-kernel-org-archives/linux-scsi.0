From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] scsi: eata: drop VLA in reorder()
Date: Mon, 12 Mar 2018 11:45:53 -0700
Message-ID: <CA+55aFww=otC4Wv40enadF+9NAyWG4Hotzjvv2EKb+_wGFui-w@mail.gmail.com>
References: <1520802418-17284-1-git-send-email-s.mesoraca16@gmail.com> <20180312030834.GC8631@eros>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180312030834.GC8631@eros>
Sender: linux-kernel-owner@vger.kernel.org
To: "Tobin C. Harding" <tobin@apporbit.com>, Arthur Marsh <arthur.marsh@internode.on.net>
Cc: Salvatore Mesoraca <s.mesoraca16@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dario Ballabio <ballabio_dario@emc.com>, Kees Cook <keescook@chromium.org>, kernelnewbies@kernelnewbies.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Mar 11, 2018 at 8:08 PM, Tobin C. Harding <tobin@apporbit.com> wrote:
>
> I think we are going to see a recurring theme here.  MAX_MAILBOXES==64
> so this patch adds 1536 bytes to the stack on a 64 bit machine or 768
> bytes on a 32 bit machine.

Yeah, that's a bit excessive. It probably works, but one or two of
those allocations will make the kernel stack really tight, so in
general I really would suggest using kmalloc() instead, or figuring
out some way to simply shrink the data structures.

That said, I wonder if the solution to this particular driver is
"delete it". Because the hardware is truly ancient and nobody sane
would use it any more.

The last patch that seemed to come from an actual _user_ finding a
problem was in 2008 (commit 20c09df7eb9c: "[SCSI] eata: fix the data
buffer accessors conversion regression"). And even then it apparently
took a year for people to have noticed the breakage.

But because the person who reported that problem is still around, I'll
just add him to the cc, just in case.

Arthur Marsh, you have the dubious honor and distinction of being the
only person to have apparently used that driver in the last ten years.
Do you still have hardware using that? Because maybe it's really time
to retire that driver.

                   Linus
