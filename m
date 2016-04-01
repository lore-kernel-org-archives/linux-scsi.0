From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [dm-devel] [RFC PATCH 4/4] dm mpath: eliminate use of spinlock in
 IO fast-paths
Date: Fri, 01 Apr 2016 11:02:59 +0200
Message-ID: <82025074d2b46ef8c599b1fc502d235d@suse.de>
References: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
 <1459454666-76428-5-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40513 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbcDAJDB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2016 05:03:01 -0400
In-Reply-To: <1459454666-76428-5-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, sagig@dev.mellanox.co.il, linux-block@vger.kernel.org, jmoyer@redhat.com, j-nomura@ce.jp.nec.com

On 2016-03-31 22:04, Mike Snitzer wrote:
> The primary motivation of this commit is to improve the scalability of
> DM multipath on large NUMA systems where m->lock spinlock contention 
> has
> been proven to be a serious bottleneck on really fast storage.
> 
> The ability to atomically read a pointer, using lockless_dereference(),
> is leveraged in this commit.  But all pointer writes are still 
> protected
> by the m->lock spinlock (which is fine since these all now occur in the
> slow-path).
> 
> The following functions no longer require the m->lock spinlock in their
> fast-path: multipath_busy(), __multipath_map(), and do_end_io()
> 
> And choose_pgpath() is modified to _not_ update m->current_pgpath 
> unless
> it also switches the path-group.  This is done to avoid needing to take
> the m->lock everytime __multipath_map() calls choose_pgpath().
> But m->current_pgpath will be reset if it is failed via fail_path().
> 
> Suggested-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
