From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: Regression - SATA disks behind USB ones on v4.8-rc1, breaking
 boot. [Re: Who reordered my disks (probably v4.8-rc1 problem)]
Date: Sun, 14 Aug 2016 11:41:52 +0000
Message-ID: <CAGnHSEn8fGEQuknE1xwF71a7HMFQazeWw9+Miwoz6avTa6igYA@mail.gmail.com>
References: <20160813190340.GA29989@amd> <20160814092044.GA20392@amd>
 <CAGnHSEmtgGO5QjfamnN0VPOO2w-4GrZQvPnbkBVdtWBPTnLieA@mail.gmail.com>
 <20160814100102.GA31847@amd> <CAGnHSEm-Gww1-bmqZMz6guFDnByUuCFiCLhdrK_LETBH3qcb1Q@mail.gmail.com>
 <CAGnHSEnXo8VRm5Y6S6axpe-hG6an8ceujLajbZmxbGGDnCGh2w@mail.gmail.com> <20160814111034.GA10616@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160814111034.GA10616@amd>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-scsi@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, james harvey <jamespharvey20@gmail.com>, regressions@leemhuis.info, hdegoede@redhat.com, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>
List-Id: linux-scsi@vger.kernel.org

On 14 August 2016 at 11:10, Pavel Machek <pavel@ucw.cz> wrote:
>
> It is the case in v4.6. We had change hda->sda for SATA drives long
> time ago, it was stable since that.

Not for me. It has been like forever (even if it wasn't the fact) that
the disk order is not consistent among boots. Only that would
logically make sense anyway. How do you think we can sanely make sure
that the SCSI disk driver starts enumerating "SCSI disks" from
usb-storage/uas only when all of those from libata probed? Wait for 1
second? 1 minute? or 1 hour? It's an irrational thing to do no matter
how long or how short it is.

>
> I'd rather not mess with initrd, and initrd was not required in the
> past.

Well, that's your choice, use PARTUUID then.

>
> kernel-parameters.txt only mentions UUID= in connection with
> resume. Is the documentation correct?

That's `PARTUUID=`. See what PARTUUID is referring to in the linked
comment below. (Note that when we say UUID instead of PARTUUID, we are
usually referring to the filesystem UUID.)

...

resume= [SWSUSP]
Specify the partition device for software suspend
Format:
{/dev/<dev> | PARTUUID=<uuid> | <int>:<int> | <hex>}

...

root= [KNL] Root filesystem
See name_to_dev_t comment in init/do_mounts.c.

...

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/init/do_mounts.c?h=v4.8-rc1#n182
