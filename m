From: ygardi@codeaurora.org
Subject: Re: [PATCH v2 17/17] scsi: ufs-qcom: fix compilation warnings
Date: Tue, 27 Oct 2015 10:10:48 -0000
Message-ID: <723997f5afca9a1683db57b8ecb3cf44.squirrel@www.codeaurora.org>
References: <1445874072-25909-1-git-send-email-ygardi@codeaurora.org>
    <1445874072-25909-18-git-send-email-ygardi@codeaurora.org>
    <562EA19E.2070007@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <562EA19E.2070007@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, robherring2@gmail.com, james.bottomley@hansenpartnership.com, pebolle@tiscali.nl, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

> On 10/26/2015 08:41 AM, Yaniv Gardi wrote:
>> Tnis patch fixes the following compilation warnings:
>> ...ufs-qcom.c:1201:40:
>> 	warning: incorrect type in argument 1 (different address spaces)
>> ...ufs-qcom.c:1201:40:
>> 	expected void const *ptr
>> ...ufs-qcom.c:1201:40:
>> 	got void [noderef] <asn:2>*dev_ref_clk_ctrl_mmio
>> ...ufs-qcom.c:1207:53:
>> 	warning: incorrect type in argument 1 (different address spaces)
>> ...ufs-qcom.c:1207:53:
>> 	expected void const *ptr
>> ...ufs-qcom.c:1207:53:
>> 	got void [noderef] <asn:2>*dev_ref_clk_ctrl_mmio
>>
>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>
>> ---
>
> What version of sparse do you use? You shouldn't need to do this.
>

i just updated my sparse to the newest -
so i'm using sparse 0.4.4
and the command i use is:
make ARCH=arm C=1  CF="-Wsparse-all"
and i still get all the warnings.
with my patch, the are no warnings.


>>  drivers/scsi/ufs/ufs-qcom.c | 9 +++++----
>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
>> index 72b0ef7..b57f88a 100644
>> --- a/drivers/scsi/ufs/ufs-qcom.c
>> +++ b/drivers/scsi/ufs/ufs-qcom.c
>> @@ -1226,11 +1226,12 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>>  		if (res) {
>>  			host->dev_ref_clk_ctrl_mmio =
>>  					devm_ioremap_resource(dev, res);
>> -			if (IS_ERR(host->dev_ref_clk_ctrl_mmio)) {
>> -				dev_warn(dev,
>> -					"%s: could not map dev_ref_clk_ctrl_mmio, err %ld\n",
>> +			if (IS_ERR((__force void const *)
>> +				   host->dev_ref_clk_ctrl_mmio)) {
>> +				dev_warn(dev, "%s: could not map dev_ref_clk_ctrl_mmio, err %ld\n",
>>  					__func__,
>> -					PTR_ERR(host->dev_ref_clk_ctrl_mmio));
>> +					PTR_ERR((__force void const *)
>> +						 host->dev_ref_clk_ctrl_mmio));
>>  				host->dev_ref_clk_ctrl_mmio = NULL;
>>  			}
>>  			host->dev_ref_clk_en_mask = BIT(5);
>
>
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> a Linux Foundation Collaborative Project
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
