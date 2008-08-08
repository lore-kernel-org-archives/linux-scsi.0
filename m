From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 0/3][RFC] libfc and fcoe
Date: Fri, 08 Aug 2008 16:26:22 -0700
Message-ID: <20080808232622.24715.7743.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:65510 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbYHHX0W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2008 19:26:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch-set adds the following code to the SCSI subsystem.

1) FC and FCoE protocol definitions in header files
        - Files are added in include/scsi/fc/
        - New files are: fc_els.h, fc_encaps.h, fc_fc2.h,
          fc_fcp.h, fc_fs.h, fc_gs.h and fc_ns.h

2) libfc - a FC assist library
        - Composed of 5 sub-components: Exchange Manager, Local Port
          Remote Port, Name Server and SCSI-FCP
        - Uses libfc_function_template for cross-layer calls
        - Uses struct fc_lport as primary object shared by all
	  sub-modules
        - Common code defined in include/scsi/libfc/libfc.h

3) fcoe - a FCoE initiator implementation
        - Simple encapsulation and unpacking layer
        - Interacts with netdev
        - Uses /sys/module/fcoe/create and destroy for
          enabling/disabling FCoE connection over a particular Ethernet
          adapter
        - Works on any Ethernet adapter

These patches adds 12,291 lines of code to 4 new directories-

include/scsi/fc/
include/scsi/libfc/
drivers/scsi/libfc/
drivers/scsi/fcoe/

We've created some diagrams to suppliment this RFC. They're posted on
our wiki at http://www.open-fcoe.org/openfc/wiki/index.php/Architecture.

The Open-FCoE team recognizes that this code will continue to evolve and
we are committed to maintaining and improving it. We have a list of TODO
items on our wiki at http://www.open-fcoe.org/openfc/wiki/index.php/TODO
and intend to work through that list.

In addition to our engineering tasks we will be putting this stack under
more testing and as defects are exposed we will fix them. Defects are
tracked on the Open-FCoE.org bugzilla. Currently engineers have been
testing this stack and within their test environments the stack works.
It has seen some validation, but no heavy testing.

We recognize that we have a lot of work to do but we also think that
we've made a lot of progress in the last few months and we would like to
be merged. We're sending this RFC to solicit any comments, but in
particular comments about the code that should prevent a merger.

Thanks,

Open-FCoE
//Rob, Vasu, Chris, Yi, Steve
