From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH] Fix leak in
 drivers/target/iscsi/iscsi_target_parameters.c::iscsi_copy_param_list()
Date: Mon, 1 Aug 2011 00:33:45 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1108010032410.28695@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1108010017030.28695@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10615 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1GaWdr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Jul 2011 18:33:47 -0400
In-Reply-To: <alpine.LNX.2.00.1108010017030.28695@swampdragon.chaosbits.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andy Grover <agrover@redhat.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 1 Aug 2011, Jesper Juhl wrote:

> We leak memory if the allocations for 'new_param->name' or 'new_param->value' fail.
> We also do a lot of variable assignments that are completely pointless
> if the allocations fail.
> So, let's move the allocations before the assignments and also make
> sure that we free whatever was allocated to one if the allocation for
> another fails.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---

Forgot to mention that I changed the kzalloc's to kmalloc since we 
overwrite all the allocaed memory anyway, so asking for zeroed memory is 
just pointless extra work..

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

