From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] [SCSI]stex: fix id mapping issue
Date: Sat, 31 Mar 2007 10:26:44 +0100
Message-ID: <20070331092644.GA25989@infradead.org>
References: <NONAMEBZNuIkdg0MZMt000005d3@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51130 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbXCaJ1B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Mar 2007 05:27:01 -0400
Content-Disposition: inline
In-Reply-To: <NONAMEBZNuIkdg0MZMt000005d3@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "james.Bottomley" <james.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>

On Fri, Mar 30, 2007 at 03:21:33PM -0700, Ed Lin wrote:
> +	if (hba->cardtype == st_shasta) {
>  		req->lun = lun;
>  		req->target = id;
> +	} else if (hba->cardtype == st_yosemite){
> +		req->lun = id * ST_MAX_LUN_PER_TARGET + lun;
> +		req->target = 0;
> +	} else {
> +		/* st_vsc and st_vsc1 */
> +		req->lun = 0;
> +		req->target = id * ST_MAX_LUN_PER_TARGET + lun;

I don't get why you can't export id as targer and lun as lun for
the !st_shasta types.  Could you explain in detail what the problem
with that approach would be?

