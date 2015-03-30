From: Andy Grover <agrover@redhat.com>
Subject: Re: [RFC 00/22] target: se_node_acl LUN list RCU conversion
Date: Mon, 30 Mar 2015 12:16:04 -0700
Message-ID: <5519A0F4.4020102@redhat.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com> <20150330120823.GA20193@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbbC3TQo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Mar 2015 15:16:44 -0400
In-Reply-To: <20150330120823.GA20193@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

On 03/30/2015 05:08 AM, Christoph Hellwig wrote:
> Fortunately there is the old patch from Andy to make the se_dev_entry
> dynamically allocated, which comes in useful here.  With that we might
> only change the rdonly flag on a live dev entry, or assign an ACL when
> it previously was NULL, something that RCU can handle nicely.
>
> I've pushed a git tree to
>
> 	git://git.infradead.org/users/hch/scsi.git target-rcu-hch
>
> Gitweb:
>
> 	http://git.infradead.org/users/hch/scsi.git/shortlog/refs/heads/target-rcu-hch
>
> that implements this scheme.  Note that I dropped the percpu refcount
> changes - the reference is only taken in the SCSI3-PR slow path, and the
> percpu refcount API is extremly cumbersome.

I dug my patches up and rebased on top of target-pending/for-next. 
Pushed here:

git://git.kernel.org/pub/scm/linux/kernel/git/grover/linux.git 
mar30-dynalloc-deve

https://git.kernel.org/cgit/linux/kernel/git/grover/linux.git/log/?h=mar30-dynalloc-deve

if this is helpful for your efforts.

Regards -- Andy
