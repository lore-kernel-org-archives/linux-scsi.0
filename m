From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] m68k link error and NCR5380_exit()
Date: Mon, 7 Mar 2005 06:37:19 +0000
Message-ID: <20050307063719.GA12478@infradead.org>
References: <Pine.LNX.4.61.0502121539440.20941@loopy.telegraphics.com.au> <20050212075645.GA30669@pants.nu> <Pine.LNX.4.61.0502122135230.21876@loopy.telegraphics.com.au> <20050213040948.GA10198@orchestra.cs.caltech.edu> <Pine.LNX.4.61.0502131618470.25204@loopy.telegraphics.com.au> <20050213063225.GA17415@orchestra.cs.caltech.edu> <Pine.LNX.4.61.0502131736300.25553@loopy.telegraphics.com.au> <20050213075506.GA18622@orchestra.cs.caltech.edu> <Pine.LNX.4.61.0502212233290.15372@loopy.telegraphics.com.au> <Pine.LNX.4.61.0503071612290.27126@loopy.telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:4012 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261653AbVCGGh3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2005 01:37:29 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0503071612290.27126@loopy.telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: James.Bottomley@SteelEye.com, linux scsi <linux-scsi@vger.kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Noah Misch <noah@cs.caltech.edu>, linux m68k <linux-m68k@vger.kernel.org>

>  	.detect				= macscsi_detect,
> -	.release			= macscsi_release,
> +	.release			= __exit_p(macscsi_release),

Please get rid of your ->detect/->release useage instead.  Allocate
the host struct directly with scsi_host_alloc and add it when setup using
scsi_add_host/scsi_scan_host in your init routine and call scsi_remove_host/
scsi_host_put in the module exit routine.  see qla1280.c for an example
that does this for the 2.6 case and to ease your porting also has the 2.4
code ifdefed so you have the direct comparism.
