From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [PATCH] [v2] aha152x cmnd->device oops
Date: Tue, 28 Oct 2003 14:50:28 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F9EF2B4.9030708@us.ibm.com>
References: <20031027155713.GA28140@lst.de>	<20031027160101.76d5291b.rddunlap@osdl.org>	<20031028090600.GA7370@lst.de> <20031028124536.3ce82c23.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:60664 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S261775AbTJ1Wux
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 17:50:53 -0500
In-Reply-To: <20031028124536.3ce82c23.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: Christoph Hellwig <hch@lst.de>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, fischer@norbit.de

Hi Randy,

>  			if(!(DONE_SC->SCp.Status & not_issued)) {
> -				Scsi_Cmnd *cmnd = kmalloc(sizeof(Scsi_Cmnd), GFP_ATOMIC);
> +				Scsi_Cmnd *cmnd = scsi_get_command(DONE_SC->device, GFP_ATOMIC);

Do you need to add a scsi_put_command to balance this get when the 
command completes?

> +					cmnd->device          = ptr->device;

Don't even need this now. scsi_get_command will set the device for you.

Mike

