From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/6] scsi: hisi_sas: workaround STP link SoC bug
Date: Mon, 10 Apr 2017 15:16:47 +0200
Message-ID: <20170410131647.GS1978@linux-x5ow.site>
References: <1491830521-21437-1-git-send-email-john.garry@huawei.com>
 <1491830521-21437-2-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1491830521-21437-2-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiaofei Tan <tanxiaofei@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 10, 2017 at 09:21:56PM +0800, John Garry wrote:
> From: Xiaofei Tan <tanxiaofei@huawei.com>
> 
> After resetting the controller, the process of scanning SATA disks
> attached to an expander may fail occasionally. The issue is that
> the controller can't close the STP link created by target if the
> max link time is 0.
> 
> To workaround this issue, we reject STP link after resetting the
> controller, and change the corresponding PHY to accept STP link
> only after receiving data.
> 
> We do this check in cq interrupt handler. In order not to reduce
> efficiency, we use an variable to control whether we should check
> and change PHY to accept STP link.
> 
> The function phys_reject_stp_links_v2_hw() should be called after
> resetting the controller.
> 
> The solution of another SoC bug "SATA IO timeout", that also uses
> the same register to control STP link, is not effective before
> the PHY accepts STP link.
> 
> Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
