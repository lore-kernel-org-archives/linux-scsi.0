From: christophe varoqui <christophe.varoqui@free.fr>
Subject: [ANNOUNCE] multipath-tools-0.3.8
Date: Thu, 25 Nov 2004 15:55:41 +0100
Message-ID: <1101394541.5820.71.camel@zezette>
References: <1096071849.4466.31.camel@zezette>
	 <1097054573.4163b96d1262c@imp5-q.free.fr>
	 <1097495416.416a73787e0ae@imp1-q.free.fr> <1098021787.5433.8.camel@zezette>
	 <1098269169.417641f18a234@imp1-q.free.fr>
	 <1098656088.9350.88.camel@zezette>
	 <1098785191.417e21a7a7c28@imp1-q.free.fr>
	 <1099328918.5525.10.camel@zezette>  <1100214617.10251.92.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-devel-admin@lists.sourceforge.net>
In-Reply-To: <1100214617.10251.92.camel@zezette>
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-hotplug-devel@lists.sourceforge.net" <linux-hotplug-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

here goes multipath-tools-0.3.8

This is just getting too big a ChangeLog.
This release was lighly tested, expect some glitches. Let's call that a
developer release.

Warning, there are config file synthax changes :
* in the callouts declarations (item 1)
* new keyword : prio_callout in the device block

The path_priority example is getting usable.

A new "-F" command line flag, to flush all multipath maps.

You will need 2.6.10-rc*-udm for this release : the map synthax is
updated but still not the logic to avoid map reloads.

Full ChangeLog for the release :

	* [priority] teach multipath to read callout keywords
	  formatted as /sbin/scsi_id -g -u -s /block/%n
	  Apply one substitutions out of :
		* %n : blockdev basename (ie sdb)
		* %d : blockdev major:minor string (ie 8:16)
	  update sample config files
	* [priority] fix find_controler(). Now works, verified
	  on IBM T200 at OSDL (thanks again, Dave). Add to the
	  main build process
	* [multipath] add a controler specific "prio_callout"
	  keyword. Noticed by Ake
	* [multipath] normalize the debug ouput
	* [multipath] add select_getuid(). De-spaghetti
	  devinfo() thanks to that helper.
	* [libmultipath] add VECTOR_LAST_SLOT macro.
	  multipath/dict.h now use it heavily.
	* [multipath] policies selectors speedup and cleanup
	  (pgpolicy, features, hwhandler, selector)
	* [multipath] new "flush" command flag
	* [libmultipath] add dm_type() and dm_flush_maps()
	* [multipath] move dm_get_map() to libmultipath
	* [multipath] rename iopolicy to pgpolicy everywhere.
	  Dual terminology was getting confusing.
	* [multipath] assemble_map() to always set next_pg to 1
	  for now.
	* [multipath] update config file to show new keywords.
	  Add an IBM array tested at OSDL.
	* [multipath] fork select_iopolicy() from setup_map()
	* [multipath] introduce select_features() and 
	  select_hwhandler(). Should merge select_* one day ...
	* [multipath] add features and hardware_handler keywords
	  and use them in the map setup
	* [build] make clean really clean. Noticed by Dave Olien,
	  OSDL
	* [multipath] group_by_serial bugfix
	* [multipath] dm_addmap() return value fix. Now multipath
	  really creates the maps
	* [multipath] try dm_log_init_verbose() instead of dup()
	  + close() to silence libdevmapper (Ake at umu)
	* [libcheckers] remove checkpath() wrapper, obsoleted by
	  the "fd in context" changes
	* [multipathd] let pathcheckers allocate their context.
	  No more over or unneeded allocation.  Suggested by Lars,
	  Suse
	* [multipathd] store the pathcheckers fd in their context.
	  No more open / close on each check. Suggested by Lars,
	  Suse

As usual, doc and download at :
http://christophe.varoqui.free.fr/

regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>




-------------------------------------------------------
SF email is sponsored by - The IT Product Guide
Read honest & candid reviews on hundreds of IT Products from real users.
Discover which products truly live up to the hype. Start reading now. 
http://productguide.itmanagersjournal.com/
