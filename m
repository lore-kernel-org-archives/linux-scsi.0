From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] 3ware 9000 driver update for 2.6.7-rc2-mm2
Date: Wed, 02 Jun 2004 18:53:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40BE5A70.80500@pobox.com>
References: <HYPD6V00.Q4O@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:45500 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265155AbUFBWxu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jun 2004 18:53:50 -0400
In-Reply-To: <HYPD6V00.Q4O@hadar.amcc.com>
List-Id: linux-scsi@vger.kernel.org
To: Adam Radford <aradford@amcc.com>
Cc: akpm@osdl.org, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org

Adam Radford wrote:
> Andrew, James, 
> 
> This patch updates the 3w-9xxx driver in 2.6.7-rc2-mm1 to v2.26.02.000 to cleanup several things pointed out by Chris Hellwig / Jeff Garzik.


Looks good, one major and one minor grumble remain:

Minor:  Your schedule_timeout() usage is incorrect without also 
set_current_state() and a loop in certain situations.  However, the fix 
is quite easy:  just use the new msleep() function.  In your code, it 
should be a straight replacement from the mdelay() calls.


Major:  code still wastes time caring about queue depth when it need 
not.  Don't emulate this feature, export the feature as the hardware 
does -- using a controller-wide queue count, not per-device.  This would 
involve deleting the queue depth code and setting ->use_sg to 253, IIRC.

	Jeff


