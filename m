From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 13/25] scsi: hisi_sas: add path from phyup irq to SAS framework
Date: Fri, 16 Oct 2015 15:36:38 +0200
Message-ID: <6858991.h0xpYFqkjM@wuerfel>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com> <3757591.KXgD8p0a1E@wuerfel> <5620FBD3.2020902@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:64495 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122AbbJPNgs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Oct 2015 09:36:48 -0400
In-Reply-To: <5620FBD3.2020902@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de

On Friday 16 October 2015 14:29:55 John Garry wrote:
> 
> It could be considered.
> 
> A potential issue I see is with hisi_sas_control_phy() for 
> PHY_FUNC_HARD_RESET: this allocates a hisi_sas_wq struct and processes 
> the reset in the queue work. When we re-enable the phy for the reset, 
> the phyup irq will want to use the same hisi_sas_wq struct which may be 
> in use.
> 
> hisi_sas_control_phy() is added in 23/35.

I'd have to review more closely, but I think that's fine, as this
is how most work queues are used: you can queue the same function
multiple times, and it's guaranteed to run at least once after
the last queue, so if you queue it while it's already running,
it will be called again, otherwise it won't.

	Arnd
