From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] scsi, mptsas : drop scsi_host lock when calling
	mptsas_qcmd
Date: Fri, 17 Sep 2010 09:16:56 +0200
Message-ID: <20100917071656.GA2644@gargoyle.ger.corp.intel.com>
References: <1284666254.7280.54.camel@schen9-DESK> <1284670136.13344.93.camel@haakon2.linux-iscsi.org> <20100916212530.GA22051@gargoyle.ger.corp.intel.com> <4C929368.4040903@cisco.com> <1284675416.26423.47.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:20519 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab0IQHOq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2010 03:14:46 -0400
Content-Disposition: inline
In-Reply-To: <1284675416.26423.47.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Joe Eykholt <jeykholt@cisco.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Tim Chen <tim.c.chen@linux.intel.com>, Eric Moore <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org, vasu.dev@intel.com, willy@linux.intel.com

> Not really ... look at the code path (in scsi.c:scsi_dispatch_cmd()).
> We take the lock, then get the serial number (that would likley have to
> be replaced with an atomic), check the state, call trace, call

An atomic unfortunately usually doesn't scale much better than a spinlock.
I suspect serials would need to be made optional, e.g. 
computing them lazily if really needed.

-andi
