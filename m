From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re:
 __elv_add_request OOPS]
Date: Wed, 25 May 2011 11:55:57 -0700
Message-ID: <BANLkTimZi6rPSA-1OX+ZAh3135SMpDcHKg@mail.gmail.com>
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar> <4DDB8BF6.2000304@fusionio.com>
 <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty> <4DDCB1C8.7040708@fusionio.com>
 <alpine.DEB.2.02.1105251416340.3472@ubuntu-natty>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1105251416340.3472@ubuntu-natty>
Sender: linux-kernel-owner@vger.kernel.org
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, akpm@linux-foundation.org, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 25, 2011 at 11:44 AM, Parag Warudkar <parag.lkml@gmail.com> wrote:
>
> Below patch pushes the check down to ioctl functions and hopefully should
> cover more ioctl-on-gone-device cases by returning -ENXIO if an attempt
> was made to submit request to a non-running device.

Can we please not duplicate complicated logic like that?

IOW, just make a helper function for it.

That said, isn't this all *exactly* what scsi_prep_state_check() is
supposed to check for? Why isn't that called, or if called, why isn't
it doing the right thing?

                     Linus
