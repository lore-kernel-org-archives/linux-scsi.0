From: "Shi, Alex" <alex.shi@intel.com>
Subject: RE: [Bugme-new] [Bug 11898] New: mke2fs hang on AIC79 device.
Date: Wed, 5 Nov 2008 09:31:24 +0800
Message-ID: <F7C8A4D3A9905B45A80E4C194793FA6501C2FCF5F1@PDSMSX501.ccr.corp.intel.com>
References: <bug-11898-10286@http.bugzilla.kernel.org/>
	 <20081030015346.ef341e4f.akpm@linux-foundation.org>
	 <F7C8A4D3A9905B45A80E4C194793FA6501C05D627D@PDSMSX501.ccr.corp.intel.com>
 <1225375526.3250.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:43306 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602AbYKEBb3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2008 20:31:29 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Shi, Alex" <alex.shi@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Zhang, Yanmin" <yanmin.zhang@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>, "Wu, Fengguang" <fengguang.wu@intel.com>, "Zhu, Yi" <yi.zhu@intel.com>

I did bisect for this bug and find the following commit cause this problem.

commit f0c0a376d0fcd4c5579ecf5e95f88387cba85211
Author: Mike Christie <michaelc@cs.wisc.edu>
Date:   Sun Aug 17 15:24:38 2008 -0500

    [SCSI] Add helper code so transport classes/driver can control queueing (v3)
    
    SCSI-ml manages the queueing limits for the device and host, but
    does not do so at the target level. However something something similar
    can come in userful when a driver is transitioning a transport object to
    the the blocked state, becuase at that time we do not want to queue
    io and we do not want the queuecommand to be called again.
    

Alex 

