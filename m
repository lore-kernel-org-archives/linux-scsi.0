From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH 1/3] scsi: ufs: Allow vendor specific initialization
Date: Tue, 13 Aug 2013 19:42:28 +0530
Message-ID: <520A3ECC.9040007@codeaurora.org>
References: <1376391620-13840-1-git-send-email-sthumma@codeaurora.org> <1376391620-13840-2-git-send-email-sthumma@codeaurora.org> <20130813135352.GE31772@joshc.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20130813135352.GE31772@joshc.qualcomm.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 8/13/2013 7:23 PM, Josh Cartwright wrote:
> On Tue, Aug 13, 2013 at 04:30:18PM +0530, Sujit Reddy Thumma wrote:
> [..]
>> diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
>> index a823cf4..829f7a4 100644
>> --- a/drivers/scsi/ufs/ufshcd-pci.c
>> +++ b/drivers/scsi/ufs/ufshcd-pci.c
>> @@ -191,7 +191,13 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>   		return err;
>>   	}
>>
>> -	err = ufshcd_init(&pdev->dev, &hba, mmio_base, pdev->irq);
>> +	err = ufshcd_alloc_host(&pdev->dev, &hba);
>> +	if (err) {
>> +		dev_err(&pdev->dev, "Allocation failed\n");
>> +		goto out_iounmap
>
> You seem to be missing a semicolon here.
I should have compiled the with pci config enabled :)

>
> Also, which tree were these patches generated against?  They fail to
> apply at least on the last few 3.11-rc's.

I have rebased on top of scsi-misc branch along with few UFS patches 
that aren't merged ([PATCH 0/9] scsi:ufs: query, bkops support and
other fixes + [PATCH V5 0/4] scsi: ufs: Improve UFS error handling
patch series).


-- 
Regards,
Sujit
