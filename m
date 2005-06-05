From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: [dm-devel] Re: [PATCH RFC 0/4] use scatter lists for all block
	pc requests and simplify hw handlers
Date: Sun, 05 Jun 2005 11:41:46 +0200
Message-ID: <1117964506.15294.130.camel@zezette>
References: <1117847972.23638.62.camel@mina>
	 <1117901234.5005.9.camel@mulgrave>  <1117955727.4961.8.camel@mina>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp14.wanadoo.fr ([193.252.23.69]:14996 "EHLO
	smtp14.wanadoo.fr") by vger.kernel.org with ESMTP id S261296AbVFEJhx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Jun 2005 05:37:53 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf1403.wanadoo.fr (SMTP Server) with ESMTP id 7B7E170000B5
	for <linux-scsi@vger.kernel.org>; Sun,  5 Jun 2005 11:37:52 +0200 (CEST)
In-Reply-To: <1117955727.4961.8.camel@mina>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

While the focus is in this area, I'd like to mention multipath tools
userland checkers will need to insert SG request on queue head (Ed
Gaggin will explain this at OLS). I guess the API is lacking there, and
would like to know if this feature is on your TODOs ...

Regards,


> inlined below is a patch built over yours + my patch set (I put all my
> patches here http://www.cs.wisc.edu/~michaelc/block/use-sg/v3/) that
> converts scsi_scan.c and removes its scsi_request usage. I cheated and
> added a new function that is basically your scsi_wait_req but it uses
> the block layer's blk_execute_rq function instead of blk_insert_request.
> Also to send block pc commands at scan time without the special bit set
> I had to modify the scsi_prep_fn. This is just a RFC/test-patch so oh
> well. There is the larger problem of handling queue limits to handle.
> 
> > 
> > There's some loss of functionality to this: retries are no longer
> > controllable (except by setting REQ_FASTFAIL) and the wait_req API needs
> > to be altered, but it looks very nice.
> 

-- 
christophe varoqui <christophe.varoqui@free.fr>


