From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: problem: connection teardown is always blocked because host is
 busy doing work on other connections
Date: Fri, 19 Jun 2015 01:16:52 -0500
Message-ID: <5583B3D4.6040001@cs.wisc.edu>
References: <1434676188-2578-1-git-send-email-minh.tran@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46134 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbbFSGRA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2015 02:17:00 -0400
In-Reply-To: <1434676188-2578-1-git-send-email-minh.tran@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Minh Tran <minhduc.tran@avagotech.com>, linux-scsi@vger.kernel.org, sony.john@avagotech.com

On 6/18/15, 8:09 PM, Minh Tran wrote:
> From: Minh Duc Tran <MinhDuc.Tran@avagotech.Com>
>
> This blocking is ok if we use software iscsi or iser where each
> connection has a separate host.  In the case of hw iscsi offload, one
> host could have hundreds of connections and some connections may have
> IOs running which makes host->host_busy is always TRUE.  Another
> problem is the host_lock taken here is disruptive to other
> connections' EH paths.  Wouldn't using target_busy a better choice
> here?
>

Do you talk to John :) I had told him to do that a couple days ago when 
you guys emailed me about this offlist.

However, I think Christoph wants to remove target_busy so you need to 
think of something else. I think you could take the session eh_mutex in 
the libiscsi session and conn teardown functions and rely on refcounting 
and state checks in the eh callouts.
