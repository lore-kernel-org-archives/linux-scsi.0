From: torvalds@transmeta.com (Linus Torvalds)
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Thu, 16 Jan 2003 21:41:18 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <b078tu$1pm$1@penguin.transmeta.com>
References: <10426732153816@kroah.com> <20030116114323.C29001@one-eyed-alien.net> <20030116195306.GA32697@kroah.com> <b073ja$12i$1@penguin.transmeta.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by neon-gw.transmeta.com (8.9.3/8.9.3) id NAA26912
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2003 13:41:40 -0800
Received: from palladium.transmeta.com (palladium.transmeta.com [10.1.1.46])
	by deepthought.transmeta.com (8.11.6/8.11.6) with ESMTP id h0GLfa305248
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2003 13:41:36 -0800 (PST)
Received: (from mail@localhost)
	by palladium.transmeta.com (8.9.3/8.9.3) id NAA04858
	for linux-scsi@vger.kernel.org; Thu, 16 Jan 2003 13:41:36 -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In article <b073ja$12i$1@penguin.transmeta.com>,
Linus Torvalds <torvalds@transmeta.com> wrote:
>
>When the USB storage device is unplugged, the device should be
>unregistered.  It should be _gone_.  It isn't sleeping, it's dead.  It's
>an ex-device. 

As a follow-up on my rant: if people want reliable static naming over
removal/reinsertion of a device, we actually already have exactly that,
in user space. Using the hotplug agents.

There's a mostly unrelated problem we have from a kernel perspective
which is a device that is actually in use when the disconnect happens -
say as a part of a sleep sequence (which will cause a forced disconnect/
reconnect event).

That's a generic hotplug issue, and still should not be a reason for
trying to (on a driver level) keep track of devices that are gone.  It
should really be up to upper layers to be able to re-associate things
properly, since doing it on a driver level simply isn't even possible in
the generic case. 

			Linus


