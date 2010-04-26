From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 3rd_time] scsi: fix operator precedence warning
Date: Mon, 26 Apr 2010 09:56:12 -0700
Message-ID: <adaaasqm9ub.fsf@roland-alpha.cisco.com>
References: <1271945825.2889.138.camel@mulgrave.site>
	<20100422110214.e7c62688.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-4.cisco.com ([171.68.10.86]:31561 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab0DZQ4Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Apr 2010 12:56:16 -0400
In-Reply-To: <20100422110214.e7c62688.randy.dunlap@oracle.com> (Randy Dunlap's
	message of "Thu, 22 Apr 2010 11:02:14 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, David C Somayajulu <david.somayajulu@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

 > -		*tcp_source_port_num = (uint16_t) mbox_sts[6] >> 16;
 > +		*tcp_source_port_num = (uint16_t) (mbox_sts[6] >> 16);

I wonder why we need that cast at all?  The fact that
tcp_source_port_num is a uint16_t* should cause the value to get
truncated properly anyway.

But I agree that this patch is a minimal fix for a real bug.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
