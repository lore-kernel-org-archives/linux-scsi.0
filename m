From: christophe varoqui <christophe.varoqui@free.fr>
Subject: [ANNOUNCE] multipath-tools-0.3.6
Date: Mon, 01 Nov 2004 18:08:37 +0100
Message-ID: <1099328918.5525.10.camel@zezette>
References: <1096071849.4466.31.camel@zezette>
	 <1097054573.4163b96d1262c@imp5-q.free.fr>
	 <1097495416.416a73787e0ae@imp1-q.free.fr> <1098021787.5433.8.camel@zezette>
	 <1098269169.417641f18a234@imp1-q.free.fr>
	 <1098656088.9350.88.camel@zezette>
	 <1098785191.417e21a7a7c28@imp1-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1098785191.417e21a7a7c28@imp1-q.free.fr>
Sender: linux-raid-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-hotplug-devel@lists.sourceforge.net" <linux-hotplug-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

here goes multipath-tools-0.3.6

Another round of changes and bugfixes. A step further to actually use
the priority framework.

I'm glad to announce Patrick Caulfield agreed to take care of Debian
packaging, thanks again.

Thanks to LTP people too : if only I had noticed before they provide
nice example of clone usage, I would have saved me a lot of headache.
Still, there are bugreports left in this area.

=46ull ChangeLog for the release :

	* Patrick Caulfield took over debian packaging. Showing
	  evident expertise, his first wish is to see debian/
	  disappear. :) So be it.
	* [libmultipath] add a vector_foreach_slot macro. Still
	  needs an iterator but saves 1 line per loop occurence and
	  tame this UPPERCASE MACROS bad taste.
	* [multipathd] don't load sg anymore on multipathd startup
	* [multipathd] change killall for kill `cat $PIDFILE` in
	  init script (Jaime Pe=C3=B1alba & Cesar Solera)
	* [multipathd] the fork fallback was borked (just exiting)
	  noticed by Jaime Pe=C3=B1alba & Cesar Solera
	* [multipathd] try without the FLOATING_STACKS flag. Does
	  it matter anyway ?
	* [multipathd] merge clone_platform.h from LTP and cover
	  the hppa special case.
	* [multipath] since we will be able to create a devmap with
	  paths too small, don't rely anymore on the first path's
	  size blindly : verify the path is up, before assigning its
	  size to the multipath
	* [priority] add a path priority fetcher to balance LU accross
	  controlers based on the controler serial detection. Untested
	  but provides a good example of what can be done with the
	  priority framework.
	* [priority] create subdir and drop a test pp_random
	* [multipath] add dev_t reporting to print_path() to ease
	  devmap decoding by humans
	* [multipath] change default path priority to 1
	* [multipath] add wits to the sort_by_prio policy, so that
	  sort_pathvec_by_prio() is now useless. Remove it.
	* [multipath] invert sort_pg_by_summed_prio sort order :
	  highest prio leftmost
	* [libmultipath] add vector_del_slot
	* revert multipath.rules change : devmap_name still takes
	  "major minor" and not "major:minor" as argument
	* Makefile refinement : you can now enter any tool directory
	  and build from here, deps are solved

As usual, doc and download at :
http://christophe.varoqui.free.fr/

regards,
--=20
christophe varoqui <christophe.varoqui@free.fr>

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
