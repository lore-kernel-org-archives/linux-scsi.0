From: christophe varoqui <christophe.varoqui@free.fr>
Subject: [ANNOUNCE] multipath-tools-0.2.6
Date: Sat, 17 Jul 2004 17:45:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1090079158.4535.3.camel@zezette>
References: <1084519750.40a47546dd0e6@imp1-q.free.fr>
	 <1086256342.40bef4d61b3e9@imp3-q.free.fr>
	 <1086619426.40c47f220de01@imp5-q.free.fr>
	 <1087209011.40cd7e338ca44@imp5-q.free.fr>
	 <1088441934.40e04e4ebe7e8@imp1-q.free.fr>
	 <1089213139.40ec12d3a447b@imp2-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.wanadoo.fr ([193.252.22.30]:63680 "EHLO
	mwinf0109.wanadoo.fr") by vger.kernel.org with ESMTP
	id S266185AbUGQPqA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Jul 2004 11:46:00 -0400
In-Reply-To: <1089213139.40ec12d3a447b@imp2-q.free.fr>
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Hello,
here goes multipath-tools-0.2.6
It's a really big feature update.
I hope I'll get feedback on the new features :

1) system-disk-on-SAN corner case treated with private namespace and
ramfs for callback programs. Next release I'll move the mknod to the
ramfs too by binding the ramfs to /tmp so scsi_id's mknod will have the
safety net too. See prepare_namespace() in main.c for review.

2) multipath config tool now get path id from callback proggys.
/bin/scsi_id by default. The tools now rely heavily on callbacks, so I'd
like to have insights about how to treat the out-of-memory case with
regard to these execv(). I'm also pondering ripping off the
get_evpd_wiid() fallback : does someone care ?

Finally note you *need* to update your config file. Not because I want
you to ackowledge to huge work put into reformatting and commenting, but
simply because the synthax has changed.

Changelog for this release :
        * [multipathd] implement the system-disk-on-SAN safety net
        * [multipathd] add exit_daemon() wrapper function
        * [multipathd] mlockall() all daemon threads
        * [multipath] fix a bug in the mp_iopolicy_handler that kept
          the iopolicy per LUN override from working
        * [multipath] display the tur bit value in print_path
          as requested by SUN
        * try to open /$udev/reverse/$major:$minor before falling back
          to mknod
        * add "udev_dir" to the defaults block in the config file
        * merge "daemon" & "device_maps" config blocks into a new
          "defaults" block
        * [multipath] properly comment the config file
        * [multipath] generalize the dbg() macro usage
          Makefile now has a DEBUG flag
        * [multipath] move to callout based WWID fetching. Default to
          scsi_id callout. I merged execute_program from udev for that
          (so credit goes to GregKH)
        * [multipath] get rid of "devnodes in /dev" assumption
          ie move to "maj:min" device mapper target synthax

Downloads and docs at http://christophe.varoqui.free.fr

regards,
cvaroqui

