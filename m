From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: [bug]
Date: Tue, 02 Mar 2004 00:04:18 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4043C172.1060800@free.fr>
References: <40426118.6000904@free.fr> <1078181191.1804.82.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp5.wanadoo.fr ([193.252.22.26]:28876 "EHLO
	mwinf0504.wanadoo.fr") by vger.kernel.org with ESMTP
	id S261466AbUCAXEV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Mar 2004 18:04:21 -0500
In-Reply-To: <1078181191.1804.82.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

> 
> Unfortunately, without the top of the trace showing what happened and in
> which function, it's fairly difficult to debug what went on.
> 
> Could you attach a serial console and reproduce, so you can get the
> whole trace?
> 
mm, digging this, I traced the bug to an sg_inq in my userspace code :
do_inq(fd, 0, 1, 0x83, buff, 64, 1);

seting the size of the buff to a higher value (#define MX_ALLOC_LEN 255) 
mutes the oops. Dunno what happened, it worked with size = 64 until 
recently.

For completeness, the bug triggered at modprobe qla2200 because my code 
got exec'ed by scsi hotplug events.

regards,
cvaroqui
