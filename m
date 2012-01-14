From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 2/3] block: fail SCSI passthrough ioctls on partition devices
Date: Sat, 14 Jan 2012 15:43:01 -0800
Message-ID: <CA+55aFxuEzfAOL=pH1m7KQxdO1yzz=nGb2fU80AbysFd3J4Dvg@mail.gmail.com>
References: <1326380489-9044-1-git-send-email-pbonzini@redhat.com> <1326380489-9044-3-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60945 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab2ANXnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Jan 2012 18:43:23 -0500
In-Reply-To: <1326380489-9044-3-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Petr Matousek <pmatouse@redhat.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>, stable@vger.kernel.org

On Thu, Jan 12, 2012 at 7:01 AM, Paolo Bonzini <pbonzini@redhat.com> wr=
ote:
> + =A0 =A0 =A0 case CDROM_GET_CAPABILITY:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Keep this until we remove the printk=
 below. =A0udev sends it
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* and we do not want to spam dmesg a=
bout it. =A0 CD-ROMs do
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* not have partitions, so we get her=
e only for disks.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOIOCTLCMD;

Looks like CDROMMULTISESSION is another of these.

I get two of these:

   mount: sending ioctl 5310 to a partition!

with Fedora 14 whenever a USB stick is inserted (I changed your patch
to also print the name of the program). Let's see if anything else
pops up.

Anyway, with the changes to print out warnings and still allow it for
root, this all looked safe and nice, so they are in my tree now. I
only noticed after applying them that you hadn't marked them with 'cc:
stable@kernel.org', so we should probably point Greg at them. They are
commits

  577ebb374c78 block: add and use scsi_blk_cmd_ioctl
  0bfc96cb7722 block: fail SCSI passthrough ioctls on partition devices
  ec8013beddd7 dm: do not forward ioctls from logical volumes to the
underlying device

in my tree now.

                      Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
