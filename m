From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v1 06/17] scsi :ufs: verify hba controller hce reg value
Date: Thu, 22 Oct 2015 00:53:38 +0900
Message-ID: <CAC5umygqzg1vBhnF8cB3Z3ncVSTH7VWF7n2mQ2gZAubiORoM7g@mail.gmail.com>
References: <1442155977-7686-1-git-send-email-ygardi@codeaurora.org>
	<1442155977-7686-7-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:34005 "EHLO
	mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbbJUPxj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 11:53:39 -0400
In-Reply-To: <1442155977-7686-7-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>

2015-09-13 23:52 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> Sometimes due to hw issues it takes some time to the
> host controller register to update. In order to verify the register
> has updated, a polling is done until its value is set.
>
> In addition the functions ufshcd_hba_stop() and
> ufshcd_wait_for_register() was updated with an additional input
> parameter, indicating the timeout between reads will
> be done by sleeping or spinning the cpu.
>
> Signed-off-by: Raviv Shvili <rshvili@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufshcd.c | 54 ++++++++++++++++++++++++++++-------------------
>  drivers/scsi/ufs/ufshcd.h | 12 +++--------
>  2 files changed, 35 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 6171da8..e5a876c 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -267,11 +267,12 @@ static inline void ufshcd_disable_irq(struct ufs_hba *hba)
>   * @val - wait condition
>   * @interval_us - polling interval in microsecs
>   * @timeout_ms - timeout in millisecs
> - *
> + * @can_sleep - perform sleep or just spin
>   * Returns -ETIMEDOUT on error, zero on success
>   */

We usually put a blank line between @argument description and
return value description.
