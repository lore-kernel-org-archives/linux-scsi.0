From: christophe.varoqui@free.fr
Subject: Re: [dm-devel] [ANNOUNCE] multipath-tools-0.3.0
Date: Wed,  6 Oct 2004 12:18:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097057920.4163c680eaee0@imp5-q.free.fr>
References: <1096071849.4466.31.camel@zezette> <1097054573.4163b96d1262c@imp5-q.free.fr> <20041006095009.GD1542@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix3-2.free.fr ([213.228.0.169]:50103 "EHLO
	postfix3-2.free.fr") by vger.kernel.org with ESMTP id S269188AbUJFKSl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Oct 2004 06:18:41 -0400
In-Reply-To: <20041006095009.GD1542@marowsky-bree.de>
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Selon Lars Marowsky-Bree <lmb@suse.de>:
> > Upgrade will need you to manualy remove your
> > /etc/udev/rules.d/multipath.rules
> > and kill your devmap_name rule in udev.rules (we use a separate rules.d
> > file now)
>
> Hi Christophe, do you still plan further configuration file changes in
> the immediate future or will the format of the configuration settle down
> now?
>
It all depends on the satisfaction of the testers.

Let's review the current situation with regards to files touched by the package
:

* /etc/multipathd.conf :

optional
you only need to create one if you use multipath aliases or have hardware not
known internaly
its synthax is not yet fully stabilized : for example, I may decide to move from

multipath {
  wwid = 00000acdefg123456ff
  alias = system
}

to

multipath 00000acdefg123456ff {
  alias = system
}

also expect a few keyword additions to cover the new reinstate feature of the
kernel driver.

* /etc/hotplug.d/scsi/multipath

dead and to be removed from 0.3.0 and up

* /etc/dev.d/block/multipath.dev

optional
this is where we call multipath and kpartx when nodes appear in /sys/block
this one should not change too much, but I expect more feedback from testers

* /etc/udev/udev.rules

from 0.3.0 and up, we don't touch it anymore

* /etc/udev/rules.d/multipath

maybe misnamed. I may rename it to device-mapper.
this is where I drop the devmap_name rule to alias dm-* devmaps with the devmap
name as shown by dmsetup

* /etc/mkinitrd/scripts/01_udev
  /etc/mkinitrd/scripts/02_multipath

optional, debian specific, but should be portable to other distribs

these copy udev, multipath tools and config files to initrd when mkinitrd is
launched.
01_udev also creates a script to fire up udevstart from initrd.
udevstart triggers the hotplug chain-reaction that leads to multipaths being
created.

this certainly needs refining, and I expect distrib packagers to show interest
in taking them over. Do you ?



hope it clarify things,
regards,
cvaroqui
