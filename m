From: christophe varoqui <christophe.varoqui@free.fr>
Subject: [ANNOUNCE] multipath-tools-0.4.4
Date: Mon, 25 Apr 2005 00:26:58 +0200
Message-ID: <1114381619.10011.29.camel@zezette>
References: <1096071849.4466.31.camel@zezette>
	<1097054573.4163b96d1262c@imp5-q.free.fr>
	<1097495416.416a73787e0ae@imp1-q.free.fr>
	<1098021787.5433.8.camel@zezette>
	<1098269169.417641f18a234@imp1-q.free.fr>
	<1098656088.9350.88.camel@zezette>
	<1098785191.417e21a7a7c28@imp1-q.free.fr>
	<1099328918.5525.10.camel@zezette> <1100214617.10251.92.camel@zezette>
	<1101394541.5820.71.camel@zezette> <1102261392.29843.2.camel@zezette>
	<1111242459.10694.128.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1111242459.10694.128.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-hotplug-devel@lists.sourceforge.net" <linux-hotplug-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

here goes multipath-tools-0.4.4

This release seems sane enough to enter enterprise distros, thanks to
all reviewers for their hard work.

Worth noting :

	* 2 new path prioritizers : pp_alua and pp_emc
	* devmap_name can now filter by target_type (-t flag).
	  For example, no output if not "multipath" type.
	* the daemon sets /proc/self/oom_adj to -17, hence is=20
	  protected from the oom killer. Watch out for leaks.
	* libdevmapper 1.01.01 or newer is now recquired
	* blacklist synthax is now regex based. Update your config
	  files. The packaged templates are up to date.
	* you can now set wwid in the blacklist
	* multipathd gained a "-v" flag to tune verbosity
	* daemon logging is now staged and asynchronous to avoid
	  syslogd possible hangs
	* droped local klibc, libsysfs and libdevmapper
	* multipath caches path info. Cache expire in 5sec.
	* "multipath -l" accepts a devname or dev_t filter


Full ChangeLog for the release :

        * [path_prio] clarify pp_alua licensing. Stefan Bader, IBM.
        * [devmap_name] add a target_type filter (suggested by Hannes)
          and set DM task device by major:minor rather than parsing
          the full map list.
        * [libmultipath] propagate an error on getprio callout
          failures, so that multipath can mark the map as immutable.
          Reported by Lars Marowsky-Br=C3=A9, Suse.
        * [libmultipath] move push_callout() from dict.c to config.c
          Use it in store_hwe() to get in multipathd's ramfs the
          callout defined in hwtable.c when no config file is used.
          Reported by Lars Marowsky-Br=C3=A9, Suse.
        * [checkers] zero sense buffers before use in EMC checker.
          Lars Marowsky-Br=C3=A9, Suse.
        * [all] pre-release bugfixing effort from Alasdair, Hannes,
          Lars, Benjamin Marzinski
        * [multipathd] set oom_adj to -17 when kernel permits.
          Immune to OOM killer ? agk says : watch out for mem
          leaks :/
        * [multipathd] safety nets from udevd : exit early if
          not root, chdir to / to avoid pining a mount.
        * [multipathd] multipathd could loose events coming from
          sighup or DM waitev. Add a pending_event counter to
          track that.
        * [path_prio] add pp_emc from Lars M Bree, Suse.
        * [path_prio] add pp_alua from Stefan Bader, IBM.
        * [libmultipath] add config.c:load_config(), which sucks
          a big chunk of code out of multipath/main.c.
        * [libmultipath] don't allocate memory in :
                * devmapper.c:dm_get_map()
                * devmapper.c:dm_get_status()
        * [libmultipath] devinfo() a la carte fetching
        * [libmultipath] merge keepalived memory audit framework
          (Thanks again, M. Cassen). Already found and fixed a
          couple of leaks.
        * [libmultipath] flatten/optimize dm_map_present() and
          dm_mapname(). Inspired by Alasdair Kergon, RedHat.
        * [kpartx] dm_map_name() free before use bugfix. Kiyoshi
          Ueda, NEC
        * [kpartx] add hotplug mode. To enable name the binary
          "kpartx.dev". Kiyoshi Ueda, NEC
        * [multipathd] don't loose events in event waiter thread.
          Suggested and prototyped by Edward Goggin, EMC
        * [libmultipath] add return values to vector manipulation
          fonctions. Mem alloc return code audit.
        * [libmultipath] Use "config->udev_dir + path->dev" as
          a path devnode to open instead of mknod'ing for each
          one. Fix some DoS issues regarding usage of /tmp in
          libmultipath/discovery.c:opennode(). Kill unlinknode()
        * [multipathd] merged the redhat init script and stop
          installing one on "make install"
        * [libmultipath] fold safe_sprintf.h into util.h
        * [libmultipath] move blacklist to a real regex matcher
          Example config files updated : check yours !!
        * [multipath] fix path group compare logic to not stop
          comparing at first path in each PG.
        * [multipathd] check if pidfile is a dead remnent of a
          crashed daemon. If so, overwrite it. Suggested by
          Alasdair Kergon, RedHat. Code heavily based on work
          by Andrew Tridgell, Samba Fame.
        * [build] dropped libdevmapper/ and libsysfs/ from the
          package. klibc build is now broken until distributors
          provide klibc compiled static libraries in their
          respective packages.
        * [libmultipath] dm_task_no_open_count() before each DM
          ioctl. Not doing that is reported to cause deadlocks
          in kernel-space. Reported by Edward Goggin, EMC, fix
          suggested by Alasdair Kergon, RedHat
          Note minimal libdevmapper version bumped up to 1.01.
        * [multipath] switched to condlog(). "make DEBUG=3DN" is
          deprecated. Debug is spat with "-v3" or more.
        * [multipathd] "multipathd -vN" cmdline arg to control
          daemon verbosity. 0 < N < 4. "make LOGLEVEL=3DN" is
          deprecated.
        * [libmultipath] provide a common condlog() primitive to
          switch lib messages to syslog or stdout depending on
          who uses the lib (daemon or tool).
        * [kpartx] give kpartx a private, slim copy of devmap.[ch]
        * [multipath] allow wwid in blacklist{} config section.
          Kiyoshi Ueda, NEC.
        * [multipathd] set mode value before use (S_IRWXU). Fixes
          RedHat Bugzilla Bug 150665.
        * [all] add ->fd to "struct path *". remove fd from all
          checker context declaration. remove lots of duplicate
          logic. Now a fd is opened only once for path. It should
          also bring a bit safety in contended memory scenarii
        * [libcheckers] remove redundant sg_include.h
        * [libmultipath] merge multipath:dict.[ch] with
          multipathd:dict.[ch] into libmultipath/. move config.h
          there too, add some helper functions to alloc/free
          "struct config *" in a new config.c. Start using a
          config in the daemon.
        * [libmultipath] move dm_geteventnr(), dm_get_maps() and
          dm_switchgroup() in devmapper.[ch]
        * [libmultipath] move path discovery logic in
          libmultipath. merge devinfo.[ch] and sysfs_devinfo.[ch]
          into discovery.[ch]
        * [libmultipath] move config.h in libmultipath. Move
          find_[mp|hw]e in a new config.c. Move "struct hwtable"
          declaration in config.h. Move propsel.[ch] in the
          lib too.
        * [multipathd] use libmultipath:dm_type() instead of
          duplacate and bogus devmap discovery code.
        * [multipathd] asynchronous & non-blocking logger
          thread. Implementation split into a generic log
          lib and a pthread wrapper for locking and events.
          An ipc wrapper could be easily created by
          interested parties.
        * [multipath] add "multipath -l -v2 [devname|devt]"
          support in complement to [mapname|wwid]
        * [kpartx] suppress loop.h private copy. Should fix
          the reported build problems
        * [multipath] do sysfs_get_mnt_path() only one time
          and store in a global var.
        * [multipath] further path discovery optimzation
        * [multipath] purge superfluous includes in main.c
        * [libmultipath] introduce a cache file. expiry set
          to 5 secondes to covert the hotplug event storms.
        * [multipath] split get_pathvec_sysfs(). Introduce
          get_refwwid() and filter_pathvec()


As usual, doc and download at :
http://christophe.varoqui.free.fr/

Archive mirror at ftp://sources.redhat.com/pub/dm/multipath-tools/

regards,
--=20
christophe varoqui <christophe.varoqui@free.fr>
