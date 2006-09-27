From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: SCSI tape block size
Date: Wed, 27 Sep 2006 23:32:25 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0609272246320.7350@poirot.grange>
References: <200609241605.32327.johna@onevista.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55983 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1030754AbWI0Vc1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Sep 2006 17:32:27 -0400
Received: from lyakh (helo=localhost)
	by poirot.grange with local-esmtp (Exim 3.36 #1 (Debian))
	id 1GSh0z-0003iq-00
	for <linux-scsi@vger.kernel.org>; Wed, 27 Sep 2006 23:32:25 +0200
In-Reply-To: <200609241605.32327.johna@onevista.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all

I've got a problem report and a patch from John Adams, he says tmscsim 
driver under 2.6.17 and on doesn't allow him to read tapes with blocksize 
of 1MB. He fixes this with the below patch.

On Sun, 24 Sep 2006, John Adams wrote:

> --- drivers/scsi/tmscsim.c.bak	2006-09-24 12:55:08.000000000 -0400
> +++ drivers/scsi/tmscsim.c	2006-09-24 12:55:56.000000000 -0400
> @@ -2300,7 +2300,8 @@
>  	.this_id		= 7,
>  	.sg_tablesize		= SG_ALL,
>  	.cmd_per_lun		= 1,
> -	.use_clustering		= DISABLE_CLUSTERING,
> +	.use_clustering		= ENABLE_CLUSTERING,
> +	.max_sectors            = 2048,
>  };
>  
>  /***********************************************************************

It looks like

1) use_clustering doesn't directly affect maximum block size, so, he 
doesn't really need it, although, it might make sense for tmscsim to 
improve performance.

2) max_sectors is indeed what he needs, but it looks strange that now it 
has to be set by the low-level driver... For block devices you can set it 
at run time with /sys/block/sda/queue/max_sectors_kb, right? But what 
about tapes?

Sorry, didn't find too much documentation about it.

Thanks
Guennadi
---
Guennadi Liakhovetski
