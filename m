From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] use mod_timer in scsi_add_timer
Date: Sun, 31 Aug 2003 13:51:58 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1062334317.31351.30.camel@dhcp23.swansea.linux.org.uk>
References: <20030831112830.GA19502@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc1-cwma1-5-cust4.swan.cable.ntl.com ([80.5.120.4]:37817 "EHLO
	dhcp23.swansea.linux.org.uk") by vger.kernel.org with ESMTP
	id S261367AbTHaMwv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Aug 2003 08:52:51 -0400
In-Reply-To: <20030831112830.GA19502@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Sul, 2003-08-31 at 12:28, Christoph Hellwig wrote:
> -
>  	scmd->eh_timeout.data = (unsigned long)scmd;
> -	scmd->eh_timeout.expires = jiffies + timeout;
>  	scmd->eh_timeout.function = (void (*)(unsigned long)) complete;

And your change is racy too. You might now call the timer function with
the data from the old timeout and the function of the new...

You just need the del_timer to be unconditional, the other change isn't
safe.

