From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1 23/25] hpsa: fix multiple issues in path_info_show
Date: Fri, 30 Oct 2015 09:18:20 +0100
Message-ID: <563327CC.5040400@suse.de>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220650.5323.11242.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbbJ3ISX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 04:18:23 -0400
In-Reply-To: <20151028220650.5323.11242.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 10/28/2015 11:06 PM, Don Brace wrote:
> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>=20
> path_info_show() seems to be broken in multiple ways.
>=20
> First, there's
>=20
>   817 return snprintf(buf, output_len+1, "%s%s%s%s%s%s%s%s",
>   818       path[0], path[1], path[2], path[3],
>   819       path[4], path[5], path[6], path[7]);
>=20
> so hopefully output_len contains the combined length of the eight
> strings. Otherwise, snprintf will stop copying to the output
> buffer, but still end up reporting that combined length - which
> in turn would result in user-space getting a bunch of useless nul
> bytes (thankfully the upper sysfs layer seems to clear the output
> buffer before passing it to the various ->show routines). But we have
>=20
>   767      output_len =3D snprintf(path[i],
>   768                       PATH_STRING_LEN, "[%d:%d:%d:%d] %20.20s "=
,
>   769                       h->scsi_host->host_no,
>   770                       hdev->bus, hdev->target, hdev->lun,
>   771                       scsi_device_type(hdev->devtype));
>=20
> so output_len at best contains the length of the last string printed.
>=20
> Inside the loop, we then otherwise add to output_len. By magic,
> we still have PATH_STRING_LEN available every time... This
> wouldn't really be a problem if the bean-counting has been done
> properly and each line actually does fit in 50 bytes, and maybe
> it does, but I don't immediately see why. Suppose we end up
> taking this branch:
>=20
>   802                  output_len +=3D snprintf(path[i] + output_len,
>   803                          PATH_STRING_LEN,
>   804                          "BOX: %hhu BAY: %hhu %s\n",
>   805                          box, bay, active);
>=20
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
>=20
> We can fix all of that and get rid of the 400 byte stack buffer by
> simply writing directly to the given output buffer, which the upper
> layer guarantees is at least PAGE_SIZE. s[c]nprintf doesn't care wher=
e
> it is writing to, so this doesn't make the spin lock hold time any
> longer. Using scnprintf ensures that output_len always represents the
> number of bytes actually written to the buffer, so we'll report the
> proper amount to the upper layer.
>=20
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |   38 +++++++++++++++++---------------------
>  1 file changed, 17 insertions(+), 21 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
