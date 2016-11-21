From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] ufs: qcom: Properly clear hba priv on failure
Date: Mon, 21 Nov 2016 10:32:56 -0800
Message-ID: <b6e636aa2b010c0013028c67f47d25a4@codeaurora.org>
References: <1479502542-1136-1-git-send-email-bjorn.andersson@linaro.org>
 <99d75f263b7b973ddbe5031d8500048c@codeaurora.org>
 <20161120061504.GP28340@tuxbot>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20161120061504.GP28340@tuxbot>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Yaniv Gardi <ygardi@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2016-11-19 22:15, Bjorn Andersson wrote:
> On Sat 19 Nov 12:30 PST 2016, Subhash Jadavani wrote:
> 
>> On 2016-11-18 12:55, Bjorn Andersson wrote:
>> >In the case where we fail to acquire the phy the hba priv will be set
>> >already, so during cleanup ufs_qcom_setup_clocks() will dereference the
>> >now free, but still "valid looking" pointer "host".
>> 
>> host (ufs_qcom_host) was allocated with devm_kzalloc() so i am not 
>> sure why
>> it would be freed up before probe() returns failure.
>> 
> 
> Sorry, I missed the fact that the devm_kfree() was dropped, the actual
> problem still remains, although it no longer results in a panic.

Agreed.

> 
> As ufs_qcom_init() returns from not having found the phy it the variant
> data will be a zero-initialized object.  The error path of
> ufshcd_hba_init() will then take us through ufs_qcom_setup_clocks(),
> which will pass the check for a NULL variant data and use the
> uninitialized host object.

Yes, Make sense.

> 
> I can update the commit message to reflect the new state of things.

Your new patch set looks good, will add my ack.

> 
> Regards,
> Bjorn
> 
>> >Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>> >---
>> > drivers/scsi/ufs/ufs-qcom.c | 2 +-
>> > 1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> >diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
>> >index d345434b084f..7bd88ffee47a 100644
>> >--- a/drivers/scsi/ufs/ufs-qcom.c
>> >+++ b/drivers/scsi/ufs/ufs-qcom.c
>> >@@ -1197,7 +1197,7 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>> > 	if (IS_ERR(host->generic_phy)) {
>> > 		err = PTR_ERR(host->generic_phy);
>> > 		dev_err(dev, "%s: PHY get failed %d\n", __func__, err);
>> >-		goto out;
>> >+		goto out_host_free;
>> > 	}
>> >
>> > 	err = ufs_qcom_bus_register(host);
>> 
>> --
>> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
>> a Linux Foundation Collaborative Project
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
