From: christophe.varoqui@free.fr
Subject: [ANNOUNCE] multipath-tools-0.3.0
Date: Wed,  6 Oct 2004 11:22:53 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1097054573.4163b96d1262c@imp5-q.free.fr>
References: <1096071849.4466.31.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1096071849.4466.31.camel@zezette>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

here goes multipath-tools-0.3.0

Faster release cycle.
Big things for some people out there.
Upgrade will need you to manualy remove your /etc/udev/rules.d/multipath.rules
and kill your devmap_name rule in udev.rules (we use a separate rules.d file
now)

In short :


* easy multipath-aware initrds on Debian SID
	* fully fonctionnal with direct-attached SCSI disks (single-path)

Full ChangeLog for the release :

        * first cut at making scripts to create multipath-aware initrds
	  those scripts are tested on Debian SID, and must be copied into
	  /etc/mkinitrd/scripts. it works here.
	* [multipath] verify presence of the /sys/block/... node before
	  reading sysfs attributes. Avoids libsysfs and scsi_id stderr
	  garbage
	* [multipath] move down the stderr close (Ake Sandgren at umu.se)
	* [multipath] don't care about 0-sized mp (Ake Sandgren at umu.se)
	* [multipath] bump mp size field to ulong (Ake Sandgren at umu.se)
	* [multipath] replace quiet/verbose flags by a verbosity one.
	  introduce a new verbosity level : 1 == print only devmap names
	  thus we can feed kpartx with that output
	* [multipath] update man page to reflect the hotplug.d -> dev.d
	  transition and replace the obsolete group_by_tur policy by the
	  forgotten group_by_prio
	* [multipath] provide a /etc/udev/rules.d/multipath.rules for
	  multipath devices naming. Cleaner than the previously suggested
	  rule addition in the main udev.rules
	* [multipath] move out of hotplug.d to dev.d : kill synchronisation
	  problems between device node creation and multipath execution.
	  Incidentally the unfriendly $DEVPATH param become a friendly
	  $DEVNAME (simply /dev/sdb)
	* [multipath] rework the iopolicies name-to-id & id-to-name
	  translations. kills the last compilation warning here too
	* [kpartx] kill last compilation warnings
	* bump klibc to 0.181
	* add the debian/ packaging dir (make deb)
	* prototype __clone & __clone2 (kills compilation warning)

As usual, doc and download at :
http://christophe.varoqui.free.fr/

regards,
--
christophe varoqui <christophe.varoqui@free.fr>
