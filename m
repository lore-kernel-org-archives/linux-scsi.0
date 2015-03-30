From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 00/22] target: se_node_acl LUN list RCU conversion
Date: Mon, 30 Mar 2015 05:08:23 -0700
Message-ID: <20150330120823.GA20193@infradead.org>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50494 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbbC3MIY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Mar 2015 08:08:24 -0400
Content-Disposition: inline
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Andy Grover <agrover@redhat.com>

I went through this in detail, and the odd patch split that splits
one change up into muliple patches, but then also mixes up other
changes makes it hard to read.

So I started rebasing the tree to understand it moving your various
cleanups to the front of the series.  Of coure while reading through
it the number of cleanups grew, so there are a few more now.

Based on that I don't think this series will work very well, RCU works
when replacing strutures in a lookup data structure, but not when
changing the content of it, so the new locking scheme doesn't work
very well, as the device_list array is static, it's just the content
that changes.

Fortunately there is the old patch from Andy to make the se_dev_entry
dynamically allocated, which comes in useful here.  With that we might
only change the rdonly flag on a live dev entry, or assign an ACL when
it previously was NULL, something that RCU can handle nicely.

I've pushed a git tree to

	git://git.infradead.org/users/hch/scsi.git target-rcu-hch

Gitweb:

	http://git.infradead.org/users/hch/scsi.git/shortlog/refs/heads/target-rcu-hch

that implements this scheme.  Note that I dropped the percpu refcount
changes - the reference is only taken in the SCSI3-PR slow path, and the
percpu refcount API is extremly cumbersome.

This survives I/O testing nicely, but I couldn't find a good test suite
for the control path.
