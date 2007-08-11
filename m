From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: [patch 0/4] Updated AN patches, now without gendisk
Date: Sat, 11 Aug 2007 16:00:53 +0200
Message-ID: <3ae72650708110700x7ddf3d57ue9a8875761425f52@mail.gmail.com>
References: <20070808120739.c3097d19.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070808120739.c3097d19.kristen.c.accardi@intel.com>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, James.Bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, David Zeuthen <david@fubar.dk>
List-Id: linux-scsi@vger.kernel.org

On 8/8/07, Kristen Carlson Accardi <kristen.c.accardi@intel.com> wrote:
> Here is an updated set of patches that implement Asynchronous Notification
> support for ATAPI devices.  In this version I no longer export the AN
> capability through genhd, and the uevent is sent by the scsi_device
> instead of gendisk.  I added a generic SCSI device event mechanism so
> that it can be expanded in the future with other types of events.  Please
> let me know what you think.

Does that mean:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8ce7ad7b2d11fae2c3d285a6a0caea9322c0b8fc

will go away?

Then we will need to come up with an idea to propagate that to the
blockdev, it gets a bit nasty for userspace to find out which
blockdevice it should update. It's certainly possible, but just not as
easy as it is now, because userspace just doesn't really care in most
cases what kind of bus device a block device is coming from.

And it would also be nice to plug exactly the same kind of media
change notification for devices which only revalidate at open(). That
way we could unify all the removable media handling into a single code
path. We would just check if AN is supported, and wait for events, or
start polling the device if AN isn't supported. It would be great if
we can get the same events in both cases, so we don't need to keep two
completely different ways to implement this.

Thanks,
Kay
