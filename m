From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [SCSI] arcmsr: Support Areca new SATA Raid Adapter
 ARC1214/1224/1264/1284
Date: Thu, 29 Aug 2013 15:01:41 +0300
Message-ID: <20130829120141.GI19256@mwanda>
References: <20130828154848.GA571@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41572 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab3H2MBy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2013 08:01:54 -0400
Content-Disposition: inline
In-Reply-To: <20130828154848.GA571@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ching2048@areca.com.tw
Cc: linux-scsi@vger.kernel.org

One tool for breaking patches up is "git citool" highlight what you want
to add to the patch and then right click and select "stage lines for
commit".

So for example let's go through the changes to
drivers/scsi/arcmsr/arcmsr.h.  These should be broken up into multiple
patches with the easiest whitespace patches first.

The original patch adds 520 lines of code (I'm looking at the plus marks
in git show 17628f3a062b | diffstat).  Out of those 392 line are pure
white space changes such as tabs or indents.  9 lines are adding
parenthesis around macros.  4 lines are changing int32_t to uint32_t.
It's not clear if there was a signedness bug in the original code or if
this is purely cosmetic.  That should be mentioned in the changelog.
The remaining 115 lines are related to the new feature.  So this should
be a series of patches.

[patch 1/4] whitespace (this is the largest patch in the series).
[patch 2/4] add parenthesis
[patch 3/4] change signed to unsigned
[patch 4/4] add feature (this would touch other the other files as well)

The first 3 patches are trivial to review and then the last one is much
smaller and easier to review than when everything was mixed together.

regards,
dan carpenter
