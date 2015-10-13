From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 12/25] scsi: hisi_sas: add v1 HW initialisation code
Date: Tue, 13 Oct 2015 14:47:19 +0200
Message-ID: <6185166.M64gFmBG3u@wuerfel>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com> <147982224.OvBbMyp8ci@wuerfel> <561CFCAA.8030003@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <561CFCAA.8030003@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On Tuesday 13 October 2015 13:44:26 John Garry wrote:
> Hello,
> 
> Just to be clear, are you saying that you would prefer hisi_sas_probe() 
> and struct hisi_sas_driver to be relocated to hisi_sas_v1_hw.c?

Correct.

> I wanted to keep hisi_sas_v1_hw.c containing only code which accesses HW.
> 
> I could consoldate the calls of hw_init_v1_hw(), interrupt_init_v1_hw(), 
> interrupt_openall_v1_hw(), and phys_init_v1_hw() to a single function hw 
> init function call. Then most of the code in the probe function will not 
> be specific to v1.

This is more about correct layering of the code. Generally we want the
more specific modules on top to call into the more general code in
the bottom of the stack. Shared code should know as little as possible
about the specific implementations it is shared with.

	Arnd
