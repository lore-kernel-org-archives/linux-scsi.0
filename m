From: christophe varoqui <christophe.varoqui@free.fr>
Subject: [ANNOUNCE] multipath-tools-0.3.4
Date: Mon, 25 Oct 2004 00:14:48 +0200
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Message-ID: <1098656088.9350.88.camel@zezette>
References: <1096071849.4466.31.camel@zezette>
	 <1097054573.4163b96d1262c@imp5-q.free.fr>
	 <1097495416.416a73787e0ae@imp1-q.free.fr> <1098021787.5433.8.camel@zezette>
	 <1098269169.417641f18a234@imp1-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-devel-admin@lists.sourceforge.net>
In-Reply-To: <1098269169.417641f18a234@imp1-q.free.fr>
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

here goes multipath-tools-0.3.4

Many structural change, consequences of the Suse review.
Highlights are :

	* glibc compilation, uses system libraries where possible
	* multipath & multipathd now use the same path checkers.
	  Consequence being multipath now need sg loaded
	* checkers now can return more than UP or DOWN and they take
	  2 more arguments :
		* msg : to let the checker pass log mesg to the core
		* context : a persistent data store the checkers can
		  use at discretion
	* multipath pgpolicies rework : I broke the group_by_serial
	  LUN balancing. This is volontary : I'd like someone affected
	  to come up with a callout binary to do the balancing based on
	  the priority framework.

Full ChangeLog for the release :

	* [multipathd] exec multipath precisely : pass in the path
	  or the devmap to update. No more full reconfiguration, and
	  really use the reinstate feature of multipath.
	* [multipathd] check all paths, not only failed ones. Path
	  checker now trigger on state change (formerly triggred on
	  state == UP condition)
	* [multipathd] incremental updatepaths() instead of scrap /
	  refresh all logic.
	* [multipathd] path checkers now take *msg and *context
	  params. consensus w/ lmb at suse. tur.c modified as example
	* [multipath] assemble maps in PG vector descending order to
	  fit the layered policies design
	* [multipath] stop playing with strings in pgpolicies, as it
	  uses more memory and looses info for no gain
	* [multipath] remove lk2.4 scsi ioctl scsi_type remnant
	* [multipath] layered pgpolicies : (see pgpolicies.c)
		* group_by_status
		* group_by_serial | multibus | failover | group_by_prio
		* sort_pg_by_summed_prio
	  thus remove duplicated failedpath logic in pgpolicies
	* [checkers] framework for arbitrate checkers return values
	* [multipathd] scrap yet another reinvented wheel in the 
	  name of the LOG macro :  learn the existance of setloglevel
	  and LOG_UPTO macro
	* glibc make with "make BUILD=glibc", asked by lmb at suse

As usual, doc and download at :
http://christophe.varoqui.free.fr/

regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>



-------------------------------------------------------
This SF.net email is sponsored by: IT Product Guide on ITManagersJournal
Use IT products in your business? Tell us what you think of them. Give us
Your Opinions, Get Free ThinkGeek Gift Certificates! Click to find out more
http://productguide.itmanagersjournal.com/guidepromo.tmpl
