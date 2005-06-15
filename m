From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Wed, 15 Jun 2005 18:03:52 -0500
Message-ID: <1118876632.5045.90.camel@mulgrave>
References: <Pine.LNX.4.44L0.0506151706030.6561-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:64429 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261630AbVFOXD7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 19:03:59 -0400
In-Reply-To: <Pine.LNX.4.44L0.0506151706030.6561-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2005-06-15 at 17:11 -0400, Alan Stern wrote:
> This means that scsi_target_reap can be called and the __targets list 
> changed essentially at any time (subject only to the host_lock).  Hence it 
> is impossible for scsi_forget_host to iterate through the list of targets 
> belonging to the host: While it is working to remove one target, the next 
> target on the list (stored in the tmp variable) might be removed by 
> another thread.

It's no better nor worse than we already have.  As has been said many
times before, we need a proper host state model.

> In fact there doesn't seem to be any safe way to remove all the targets
> from a host.  And what's to prevent scsi_target_reap being called twice
> for the same target?

The usage, if you look at the code ... it's alloc/reap or inc
reap_ref/reap

James


