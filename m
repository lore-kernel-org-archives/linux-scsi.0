From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] mptfusion: zero kernel-space source of copy_to_user
Date: Thu, 5 Jun 2014 02:29:46 -0700
Message-ID: <20140605092946.GE727@infradead.org>
References: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
 <1401900589-19672-5-git-send-email-joe.lawrence@stratus.com>
 <20140604125836.7845a92d@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38727 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaFEJ3r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2014 05:29:47 -0400
Content-Disposition: inline
In-Reply-To: <20140604125836.7845a92d@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

On Wed, Jun 04, 2014 at 12:58:36PM -0400, Joe Lawrence wrote:
> Hi Dan,
> 
> kzalloc silenced that smatch warning, but the code looks like:
> 
>   (calculate data_size)
>   ...
>   karg = kmalloc(data_size, GFP_KERNEL);
>   ...
>   if (copy_from_user(karg, uarg, data_size)) {
>   ...
>   if (copy_to_user((char __user *)arg, karg, data_size)) {
> 
> where 'data_size' once calculated, is unchanged.  Since the size
> allocated is the same copied from the user and the same copied back out
> to the user, would this really be considered an info leak?

I think the stastic checker is wrong here.  But the code would still
benefit from switching to memdup_user, which should shut up the checker
in addition to simplifying the code.

