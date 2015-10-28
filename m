From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH] scsi: hpsa: fix multiple issues in path_info_show
Date: Wed, 28 Oct 2015 15:33:09 -0500
Message-ID: <56313105.3050805@pmcs.com>
References: <1445984203-3288-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36337 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbbJ1UdN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Oct 2015 16:33:13 -0400
In-Reply-To: <1445984203-3288-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Joe Handzik <joseph.t.handzik@hp.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Kevin Barnett <kevin.barnett@pmcs.com>, Scott Teel <scott.teel@pmcs.com>, Tomas Henzl <thenzl@redhat.com>, iss_storagedev@hp.com, storagedev@pmcs.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 10/27/2015 05:16 PM, Rasmus Villemoes wrote:
> I'm not familiar with this code, but path_info_show() (added in
> 8270b86243658 "hpsa: add sysfs entry path_info to show box and
> bay information") seems to be broken in multiple ways.
>
> First, there's
>
>    817 return snprintf(buf, output_len+1, "%s%s%s%s%s%s%s%s",
>    818         path[0], path[1], path[2], path[3],
>    819         path[4], path[5], path[6], path[7]);
>
> so hopefully output_len contains the combined length of the eight
> strings. Otherwise, snprintf will stop copying to the output
> buffer, but still end up reporting that combined length - which
> in turn would result in user-space getting a bunch of useless nul
> bytes (thankfully the upper sysfs layer seems to clear the output
> buffer before passing it to the various ->show routines). But we have
>
>    767         output_len = snprintf(path[i],
>    768                         PATH_STRING_LEN, "[%d:%d:%d:%d] %20.20s ",
>    769                         h->scsi_host->host_no,
>    770                         hdev->bus, hdev->target, hdev->lun,
>    771                         scsi_device_type(hdev->devtype));
>
> so output_len at best contains the length of the last string printed.
>
> Inside the loop, we then otherwise add to output_len. By magic,
> we still have PATH_STRING_LEN available every time... This
> wouldn't really be a problem if the bean-counting has been done
> properly and each line actually does fit in 50 bytes, and maybe
> it does, but I don't immediately see why. Suppose we end up
> taking this branch:
>
>    802                         output_len += snprintf(path[i] + output_len,
>    803                                 PATH_STRING_LEN,
>    804                                 "BOX: %hhu BAY: %hhu %s\n",
>    805                                 box, bay, active);
>
> An optimistic estimate says this uses strlen("BOX: 1 BAY: 2
> Active\n") which is 21. Now add the 20 bytes guaranteed by the
> %20.20s and then some for the rest of that format string, and
> we're easily over 50 bytes. I don't think we can get over 100
> bytes even being pessimistic, so this just means we'll scribble
> into the next path[i+1] and maybe get that overwritten later,
> leading to some garbled output (in fact, since we'd overwrite the
> previous string's 0-terminator, we could end up with one very
> long string and then print various suffixes of that, leading to
> much more than 400 bytes of output). Except of course when we're
> filling path[7], where overrunning it means writing random stuff
> to the kernel stack, which is usually a lot of fun.
>
> We can fix all of that and get rid of the 400 byte stack buffer by
> simply writing directly to the given output buffer, which the upper
> layer guarantees is at least PAGE_SIZE. s[c]nprintf doesn't care where
> it is writing to, so this doesn't make the spin lock hold time any
> longer. Using scnprintf ensures that output_len always represents the
> number of bytes actually written to the buffer, so we'll report the
> proper amount to the upper layer.
>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>
Thanks, I added this to my current patch set. This patch will be up
with you as the author soon.
