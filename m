From: christophe varoqui <christophe.varoqui@free.fr>
Subject: [ANNOUNCE] multipath-tools-0.4.3
Date: Sat, 19 Mar 2005 15:27:39 +0100
Message-ID: <1111242459.10694.128.camel@zezette>
References: <1096071849.4466.31.camel@zezette>
	<1097054573.4163b96d1262c@imp5-q.free.fr>
	<1097495416.416a73787e0ae@imp1-q.free.fr>
	<1098021787.5433.8.camel@zezette>
	<1098269169.417641f18a234@imp1-q.free.fr>
	<1098656088.9350.88.camel@zezette>
	<1098785191.417e21a7a7c28@imp1-q.free.fr>
	<1099328918.5525.10.camel@zezette> <1100214617.10251.92.camel@zezette>
	<1101394541.5820.71.camel@zezette> <1102261392.29843.2.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
In-Reply-To: <1102261392.29843.2.camel@zezette>
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

here goes multipath-tools-0.4.3

This is a bugfix and features release.

Things noticable from users' perspective :

      * dropped klibc from the package : now an external dependency.
        Those interested in building the tools with klcc will want to
        download klibc from http://www.kernel.org/pub/linux/libs/klibc/
        or the nearest mirror.
      * optimization work in the multipath tool : shorter code paths and
        less memory utilisation
      * new "multipath -v2 -l $devmap" synthax to limit the scope of the
        list
      * new rr_min_io keyword in the config file
      * allow longer devmaps (256 to 1024 chars)
      * "multipath -F" will no longer flush maps with partitions
        attached

Full ChangeLog for the release :

        * [libmultipath] rename find_[mp|hw] to find_[mp|hw]e and
          introduce a real find_mp().
        * [priority] provison for recursive compilation of prio
          subdirs, in preparation of merging more signicant
          prioritizers. Stephan Bader, IBM
        * [libmultipath] add a netapp controler to the hwtable
        * [libmultipath] blacklist() not to discard sda[0-9]*
          when sda is blacklisted
        * [multipath] add a rr_min_io keyword in config file.
          Suggested by Igor Feoktistov, NetApp
        * [multipath] stop trying to avoid running in parallel
        * [multipath] bump up params size to 1024
        * [multipathd] put prio callouts in to ramfs. Stephan
          Bader, IBM
        * [multipath] simplify multibus pgpolicy : no need to
          copy mp->paths into mp->pg->paths then free source :
          just copy the ptr and set source to NULL.
        * [multipath] sort PG by descending prio value in
          group_by_prio. Stephan Bader, IBM
        * [multipath] fix a bug in group_by_prio that lead to
          creation of multiple PG for a single prio value
        * [multipath] don't store multipaths in a vector anymore :
          free the "struct multipath" after usage.
        * [multipath] multiple optimizations in the exec plan
        * [multipath] allow "multipath -l -v2 [mapname|wwid]"
        * [build] rip off klibc and move to klcc, at last.
          Good job hpa. multipath-tools now depend on klibc
          > 1.0 to build with BUILD=klibc flag.
        * [multipath] never reload a map if no path is up in the
          computed new map
        * [multipath] don't flush maps with open count != 0
        * [libmultipath] add "int *dm_get_opencount(char *map)"
          to devmapper.c
        * [multipath] plug leaks and optimize devinfo.c. From
          Edward Goggin, EMC
        * [multipath] fix the multipath.dev hotplug script to not
          do kpartx stuff in the same run as multipath stuff.
        * [multipath] fix the multipath.dev hotplug script to not
          do kpartx stuff in the same run as multipath stuff.
          Igor Feoktistov, NetApp, noted the devmap symlink was
          not yet present for kpartx to use.
        * [devmap_name] accept major:minor synthax
        * [libmultipath] add "char *dm_mapname(int maj, int min)",
          needed to fail paths from checker thread
        * [libmultipath] move dm_reinstate() in the lib, and add
          dm_fail_path()
        * [multipathd] mark failed path as failed upon DM
          event. This should fix the design bug noticed by
          Ramesh Caushik, Intel, where the daemon didn't run
          multipath when a path went down and up in between 2
          checks.
        * [libmultipath] allow NULL as a pathvec in disassemble_map
          as is passed only for memory optimization
        * [libmultipath] add structs.c to store alloc_*() and
          free_*()
        * [libmultipath] move dmparser.[ch] to the lib.
          remove devinfo.[ch] dependency.
        * [build] fix compilation glitch with BUILD=klibc,
          flags to force use of local libs, remove the link
          dependency in klibc, try to guess kernel sources
          and build dirs. Stefan Bader, IBM
        * [libmultipath] find_hw matching logic to take str
          lengths in account. Noticed by Ramesh Caushik, Intel
        * [multipath] select_action matching logic to take str
          length in account.
        * [multipath] lookup mp alias name earlier (in coalesce)
          Edward Goggin, EMC, noticed we tried to use it before
          it was set up.

As usual, doc and download at :
http://christophe.varoqui.free.fr/

regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
