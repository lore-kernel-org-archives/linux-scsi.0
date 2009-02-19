From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] [SCSI] libiscsi: fix iscsi pool error path
Date: Thu, 19 Feb 2009 11:26:19 -0600
Message-ID: <499D963B.7050106@cs.wisc.edu>
References: <200902182035.23939.jdelvare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60594 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbZBSR03 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2009 12:26:29 -0500
In-Reply-To: <200902182035.23939.jdelvare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-scsi@vger.kernel.org

Jean Delvare wrote:
> Memory freeing in iscsi_pool_free() looks wrong to me. Either q->pool
> can be NULL and this should be tested before dereferencing it, or it
> can't be NULL and it shouldn't be tested at all. As far as I can see,
> the only case where q->pool is NULL is on early error in
> iscsi_pool_init(). One possible way to fix the bug is thus to not
> call iscsi_pool_free() in this case (nothing needs to be freed anyway)
> and then we can get rid of the q->pool check.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Acked-by: Mike Christie <michaelc@cs.wisc.edu>


James,

If you are scooping up late fixes for 2.6.29-rc, then please take this 
if it qualifies. It is not a regression, but a simple bug fix that can 
be hit in situations where there is small amounts of memory (for some 
reason common in virtual machine setups a lot).
