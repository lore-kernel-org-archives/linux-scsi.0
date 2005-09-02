From: christophe varoqui <christophe.varoqui@free.fr>
Subject: [ANNOUNCE] multipath-tools-0.4.5
Date: Fri, 02 Sep 2005 23:16:05 +0200
Message-ID: <1125695765.6217.10.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-hotplug-devel@lists.sourceforge.net" <linux-hotplug-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

here goes multipath-tools-0.4.5

This release was long due.
Full of new shiny features.

Worth noting :

    * multipathd keeps Device Mapper path status in sync with path
      checker status : proactive fail_path and reinstate_path
    * proactive path group re-enable, as soon as one path goes up
    * multipathd is now fully event driven :
          o NetLink? uevents for kernels/distro that enables the feature
          o Hotplug
          o Unix socket messages
    * a Command Line Interface to drive and inspect the daemon
    * remove the multipath(8) cache file logic in favour of a
      multipathd<->multipath unix socket request/reply design
    * split multipath(8) listing option into
          o short-list (-l) : don't fetch wwid, path checker status,
            priorities ... fast
          o detailed-list (-ll) : refetch all info
    * the daemon asynchronous logger is now solid and avoid sending
      critical messages
    * daemon CLI command to reload the config file
    * path checking interval gets longer when the path is reliably up,
      resets to short as soon as a problem occur
    * daemon implements 3 path group failback methods :
          o manual
          o immediate : failback as soon as an (enabled && !active) PG
            gets the highest priority
          o defered : failback to the highest priority 
            (enabled && !active) PG n seconds after the last PG priority
            order change
    * remove over-complicated and thread-confusing daemon initial
      clone() w/ private namespace
    * prioritizers official prefix is now mpath_prio_
    * multipath(8) displays PG priorities when available
    * new hp_sw checker. It's a tri-state UP/DOWN/GHOST
    * new directio checker. Useful with DASD devices. May suplant
      readsector0 in the long run ?
    * stricter default blacklist regexps
    * new '-f' multipath(8) flag to selectively suppress a multipath
      map, and its device-mapped partitions
    * alua prioritizer update, should work on x86
    * support for >2TB multipaths
    * claimed device detection : no more warning/error messages with
      paths pinned by mounted FS
    * option to use priorities as weights in the round-robin scheduler :
      for people who can't wait for a qlen-based scheduler

As usual, doc and download at :
http://christophe.varoqui.free.fr/

Archive mirror at ftp://sources.redhat.com/pub/dm/multipath-tools/

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>


