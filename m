From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1 23/25] hpsa: fix multiple issues in path_info_show
Date: Fri, 30 Oct 2015 15:33:47 +0100
Message-ID: <56337FCB.9060802@redhat.com>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220650.5323.11242.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758766AbbJ3Odu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 10:33:50 -0400
In-Reply-To: <20151028220650.5323.11242.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 28.10.2015 23:06, Don Brace wrote:
> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>
> path_info_show() seems to be broken in multiple ways.
>
> First, there's
>
>   817 return snprintf(buf, output_len+1, "%s%s%s%s%s%s%s%s",
>   818       path[0], path[1], path[2], path[3],
>   819       path[4], path[5], path[6], path[7]);
>
> so hopefully output_len contains the combined length of the eight
> strings. Otherwise, snprintf will stop copying to the output
> buffer, but still end up reporting that combined length - which
> in turn would result in user-space getting a bunch of useless nul
> bytes (thankfully the upper sysfs layer seems to clear the output
> buffer before passing it to the various ->show routines). But we have
>
>   767      output_len = snprintf(path[i],
>   768                       PATH_STRING_LEN, "[%d:%d:%d:%d] %20.20s ",
>   769                       h->scsi_host->host_no,
>   770                       hdev->bus, hdev->target, hdev->lun,
>   771                       scsi_device_type(hdev->devtype));
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
>   802                  output_len += snprintf(path[i] + output_len,
>   803                          PATH_STRING_LEN,
>   804                          "BOX: %hhu BAY: %hhu %s\n",
>   805                          box, bay, active);
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
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

