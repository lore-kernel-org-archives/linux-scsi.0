From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH scsi-misc-2.6 08/13] scsi: move request preps in other places into prep_fn()
Date: Thu, 31 Mar 2005 11:20:40 +0100
Message-ID: <20050331102040.GD13842@infradead.org>
References: <20050331090647.FEDC3964@htj.dyndns.org> <20050331090647.94FFEC1E@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:16355 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261226AbVCaKUm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2005 05:20:42 -0500
Content-Disposition: inline
In-Reply-To: <20050331090647.94FFEC1E@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James.Bottomley@steeleye.com, axboe@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> +/*
> + * Macro to determine the size of SCSI command. This macro takes vendor
> + * unique commands into account. SCSI commands in groups 6 and 7 are
> + * vendor unique and we will depend upon the command length being
> + * supplied correctly in cmd_len.
> + */
> +#define CDB_SIZE(cmd)	(((((cmd)->cmnd[0] >> 5) & 7) < 6) ? \
> +				COMMAND_SIZE((cmd)->cmnd[0]) : (cmd)->cmd_len)

should probably go to scsi.h as it's generally usefull.

