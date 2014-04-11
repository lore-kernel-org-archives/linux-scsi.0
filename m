From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: aic94xx: maybe uninitialized variable in asd_process_ctrl_a_user
Date: Fri, 11 Apr 2014 10:19:09 +0200
Message-ID: <1397204349.22353.11.camel@x220>
References: <CADU+-uBr9UctHt1crnYAjYm5uNYmva2KDh5BZyZtkRG9_Xm-ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADU+-uBr9UctHt1crnYAjYm5uNYmva2KDh5BZyZtkRG9_Xm-ag@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Filipe Brandenburger <filbranden@google.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michel Lespinasse <walken@google.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-04-10 at 22:13 -0700, Filipe Brandenburger wrote:
> While building a recent kernel with -Werror I found this warning:
> 
> drivers/scsi/aic94xx/aic94xx_sds.c: In function 'asd_read_flash':
> drivers/scsi/aic94xx/aic94xx_sds.c:597:21: error: 'offs' may be used
> uninitialized in this function [-Werror=maybe-uninitialized]
> drivers/scsi/aic94xx/aic94xx_sds.c:985:6: note: 'offs' was declared here

This warning is actually rather old.

> This looks like a valid complaint from the compiler, since in
> asd_process_ctrl_a_user if the call to asd_find_flash_de fails (and
> returns -ENOENT) then offs will not be set, but that will not prevent
> the variable to be later passed to the call to asd_read_flash_seg
> later in that same function.
> 
> Would you please have a look at it? Let me know if there's a more
> appropriate way to report these issues (e.g. bug tracker.)

I tried a few times to fix this warning.

In the end I just asked Fedora to disable aic94xx in their kernel builds
(which they did for Rawhide, their development branch). See
https://lists.fedoraproject.org/pipermail/kernel/2014-January/004759.html for all the boring details.


Paul Bolle
