From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 00/10] sg buffer copy helper functions
Date: Mon, 10 Mar 2008 16:10:36 +0200
Message-ID: <47D5415C.3010904@panasas.com>
References: <1205037877-12843-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1205037877-12843-1-git-send-email-fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tomof-HInyCGIudOg@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Douglas Gilbert <dougg-c4O3jRSCrQ+sTnJN9+BGXg@public.gmane.org>, Geert Uytterhoeven <Geert.Uytterhoeven-osDt5Q4Chk1BDgjK7y7TUQ@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Salyzyn, Mark" <Mark_Salyzyn-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org>, Ed Lin <ed.lin-XjgVRL3kVzRBDgjK7y7TUQ@public.gmane.org>, Adam Radford <linuxraid-6mNVq6Owofk@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Mar 09 2008 at 6:44 +0200, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> This patchset adds new two helper functions to copy data between an SG
> table and liner buffer, and converts severl LLDs to use them.
> 
> The new APIs are used mainly in the code to spoof SCSI commands
> (INQUIRY, READ CAPACITY, MODE SENSE etc), that is, LLDs build a fake
> reposense and copy it to the sg list in scsi_cmnd struct. Several LLDs
> have similar functions for such code. This patchset removes such
> duplication.
> 
> Another reason to do this work is that because we relaxed the default
> alignment requirements (from 511 to 3) post 2.6.24, the above commands
> might come with multiple scatter gather entries but several LLDs make
> the assumption that such commands come with only one sg entries and
> can't handle multiple sg entries. The new APIs can handle multiple sg
> entries so LLDs don't need to care about anything.
> 
> The first patch adds the new APIs to lib/scatterlist.c and the rest
> are for SCSI. I like to push the whole patchset via scsi-misc (since
> it's easier).
> 
> This is against scsi-misc (a6680f71ca27ea78c4c4e577076aecb9ace476f1).
> 
>  arch/ia64/hp/sim/simscsi.c    |   23 ++--------
>  drivers/scsi/3w-9xxx.c        |   21 ++++-----
>  drivers/scsi/3w-xxxx.c        |   12 +----
>  drivers/scsi/aacraid/aachba.c |   49 ++++++++--------------
>  drivers/scsi/ips.c            |   50 ++++-------------------
>  drivers/scsi/ps3rom.c         |   92 ++++------------------------------------
>  drivers/scsi/scsi_debug.c     |   79 ++++++-----------------------------
>  drivers/scsi/stex.c           |   66 ++++-------------------------
>  include/linux/scatterlist.h   |    5 ++
>  include/scsi/scsi_cmnd.h      |   14 ++++++
>  lib/scatterlist.c             |   90 ++++++++++++++++++++++++++++++++++++++++
>  11 files changed, 182 insertions(+), 319 deletions(-)
> 
>

Hi Tomo. Nice cleanup, Cheers.

Have you had a look at drivers/usb/storage/protocol.c usb_stor_access_xfer_buf() ?
It looks like it could also use these, but there they have a twist where they want
to do it in parts. Do you think that the code there could also use the helpers 
presented here somehow? (I know that one of the USB guys was asking about it)

Boaz

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
