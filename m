From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: iscsi_add_session() warning
Date: Tue, 3 Feb 2009 16:22:24 -0800
Message-ID: <20090203162224.7c80d962.akpm@linux-foundation.org>
References: <20090203160900.38506c47.akpm@linux-foundation.org>
	<20090204001238.GG19327@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751117AbZBDAWo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2009 19:22:44 -0500
In-Reply-To: <20090204001238.GG19327@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kyle McMartin <kyle@infradead.org>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On Tue, 3 Feb 2009 19:12:38 -0500
Kyle McMartin <kyle@infradead.org> wrote:

> On Tue, Feb 03, 2009 at 04:09:00PM -0800, Andrew Morton wrote:
> > : 	if (id == ISCSI_MAX_TARGET) {
> > : 		for (id = 0; id < ISCSI_MAX_TARGET; id++) {
> > : 			err = device_for_each_child(&shost->shost_gendev, &id,
> 
> Possibly GCC just can't figure out that id was reinitialized, so it
> thinks that the for loop won't be executed?
> 

Could be.  But that isn't the point...

The point, dear Kyle, is that I misread the code :(

In fact on that codepath the function _will_ return the most recent
return value from device_for_each_child(iscsi_get_next_target_id), and
that value will be non-zero (-EEXIST).  So it looks non-buggy, albeit
rather obscure.

But did we intend to return -EEXIST in the "Too many iscsi targets" case?
