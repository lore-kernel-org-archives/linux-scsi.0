From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: scsi_sysfs_add_sdev(): uevent emission versus attribute creation
Date: Fri, 22 May 2009 14:30:18 +0200
Message-ID: <ac3eb2510905220530i46c2e2e5ve8e621953428a92@mail.gmail.com>
References: <4A169411.1010600@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <4A169411.1010600@s5r6.in-berlin.de>
Sender: linux-hotplug-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux-hotplug@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, May 22, 2009 at 14:01, Stefan Richter <stefanr@s5r6.in-berlin.d=
e> wrote:
> For many years now, the sbp2 driver has been providing a host templat=
e
> attribute which contains the SBP specific target identifier and logic=
al unit
> identifier. =C2=A0Userspace is taking this attribute to create the
> /dev/disk/by-id symlink.
>
> That's obviously racy. =C2=A0The sdev's attribute should already be t=
here when
> the disk's and partitions' symlinks are going to be created.

> How am I going to fix this?

Maybe it can hook into:
  BUS_NOTIFY_ADD_DEVICE
to create the additional attributes?

That logic is in: drivers/base/core.c : 941.

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-hotplug=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
