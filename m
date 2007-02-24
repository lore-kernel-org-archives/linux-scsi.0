From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: end to end error recovery musings
Date: Fri, 23 Feb 2007 16:03:21 -0800
Message-ID: <45DF80C9.5080606@zytor.com>
References: <45DEF6EF.3020509@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from terminus.zytor.com ([192.83.249.54]:59801 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933224AbXBXADv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Feb 2007 19:03:51 -0500
In-Reply-To: <45DEF6EF.3020509@emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <ric@emc.com>
Cc: Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Neil Brown <neilb@suse.de>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>

Ric Wheeler wrote:
> 
> We still have the following challenges:
> 
>    (1) read-ahead often means that we will  retry every bad sector at 
> least twice from the file system level. The first time, the fs read 
> ahead request triggers a speculative read that includes the bad sector 
> (triggering the error handling mechanisms) right before the real 
> application triggers a read does the same thing.  Not sure what the 
> answer is here since read-ahead is obviously a huge win in the normal case.
> 

Probably the only sane thing to do is to remember the bad sectors and 
avoid attempting reading them; that would mean marking "automatic" 
versus "explicitly requested" requests to determine whether or not to 
filter them against a list of discovered bad blocks.

	-hpa
