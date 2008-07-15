From: "Love, Robert W" <robert.w.love@intel.com>
Subject: Open-FCoE Third Re-Architecture Status
Date: Tue, 15 Jul 2008 15:31:07 -0600
Message-ID: <72D8A09E39A89147BE9CFBB6F0C73C305F1D8E90FA@rrsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1056 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320AbYGOVbK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jul 2008 17:31:10 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>

Hello everybody,

        We're winding down on the Open-FCoE re-architecture and I wanted to
provide another status report to show what we've done over the last month. The
list of major changes is shorter that previous updates. In the last month we've
made a lot of smaller changes that would be overkill to list in a summary.
Overall our project has been reduced to 12,494 lines and we don't expect it to
get much smaller.

        The major changes we've made since the last update are-

1) Better integration with fc_rports
        - fc_rports are now our representation of discovered ports within the
fabric with some private data for our internal accounting
        - Use of the scsi_transport_fc's fc_rport management
        - Rework of name server code to accommodate change
        - Removal of os_tgt and os_lun structures

2) Exchange Manager (EM) improvements
        - Complete use and improvements of new EM API
        - Simplification of reference counting
        - Improved exchange lookup by indexing array of exchange pointers by xid
vs. previous linear search

3) Library-ization
        - Separation of UL blocks (fc_lport, fc_rport, fc_fcp, fc_ns and
fc_exch)
        - No direct calls between UL blocks
        - Better distinguishing between the fc_lport.c (the initiators login/out
to the fabric) and fc_ns.c (interactions with the name server)

4) General Improvements
        - Reduction of various structures' members
        - Intentional bloat of libfc_function_template to expose unnecessary
cross layer calls then removal of most unnecessary calls
        - Improved receive path - now is LLD->LP->EM->ULP
        - No redefinition of existing defines from scsi_transport_fc
        - Code style clean-up (tabbing, spacing and checkpatch.pl)
        - Rename of some structures' members to remove prefixes (i.e fl_* or fs_*)
        - renamed fc_scsi.c to fc_fcp.c and fc_disc.c to fc_ns.c
        - Miscellaneous bug fixes

       Kernel code URL-

git://open-fcoe.org/rearch/open-fcoe-upstream

        We've also put the code on gitweb at-

http://open-fcoe.org/openfc/gitweb/


        Things to keep in mind if viewing the code-

1) The code is stabilizing, but there are some obvious defects that we're aware
of.

2) We're mostly testing against a FC fabric and have only recently started to
look at P2P connections again.

3) For the time being, fcconf is replaced with

echo "ethX" > /sys/module/fcoe/create
echo "ethX" > /sys/module/fcoe/destroy


        We'll merge these changes with our primary development tree on
www.Open-FCoE.org soon. I'll also create a big patch (or whatever is preferable)
and put it out to the linux-scsi list as an RFC when we're a little further
along to get more feedback or possible kernel inclusion.

        As per usual, any comments are welcome.

Thanks,

//Rob, Vasu, Chris, Steve, Yi
Open-FCoE
