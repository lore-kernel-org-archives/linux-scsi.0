From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCH 7/8] scsi: Add 'eh_deadline' to limit SCSI EH runtime
Date: Fri, 28 Feb 2014 15:01:33 +0800
Message-ID: <5310344D.8090400@cn.fujitsu.com>
References: <1382518282-107606-1-git-send-email-hare@suse.de> <1382518282-107606-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65012 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbaB1G6H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Feb 2014 01:58:07 -0500
In-Reply-To: <1382518282-107606-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

Hi, Hannes:

On 10/23/2013 04:51 PM, Hannes Reinecke wrote:
> This patchs adds an 'eh_deadline' sysfs attribute to the scsi
> host which limits the overall runtime of the SCSI EH.

As you known, adding to scsi host means such interface has also been
added to the SATA and USB controllers. But to users, I think it is
possible that there are 3 confusing points below:

1) There should not be this sysfs interface for SATA controllers, for
    such interface will not work under SATA's own EH policy;
2) There should not be this sysfs interface for USB controllers,
    because probably they will not consider EH recovery to USB ones;
3) They are not willing to affect SATA/USB controllers(even if their
    sysfs interfaces) while setting global interafce by assigning scsi
    module parameter.

I was thinking how to mask SATA/USB controllers, but havn't a perfect
solution so far, for it seems that it is not clever enough to mask
them in each controller driver. Do you have any idea about above?

Thanks,
Ren
