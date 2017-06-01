From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v3 13/23] scsi: hisi_sas: add phy up/down/bcast and
 channel ISR
Date: Thu, 1 Jun 2017 11:10:27 +0100
Message-ID: <0a1e06ff-eae4-5ec4-5b9d-c6e29d50b5f1@huawei.com>
References: <1496241195-217678-1-git-send-email-john.garry@huawei.com>
 <1496241195-217678-14-git-send-email-john.garry@huawei.com>
 <20170601054106.GA4743@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170601054106.GA4743@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 01/06/2017 06:41, Christoph Hellwig wrote:
>> > +static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
>> > +{
>> > +	struct device *dev = hisi_hba->dev;
>> > +	struct pci_dev *pdev = hisi_hba->pci_dev;
>> > +	int vectors, i, irq, rc;
>> > +	int max_msi = HISI_SAS_MSI_COUNT_V3_HW;
>> > +	int msi_vectors[HISI_SAS_MSI_COUNT_V3_HW];
>> > +
>> > +	if (pdev->msi_enabled)
>> > +		pci_disable_msi(pdev);
> How could MSIs be enabled at init time?  Even if so you should use
> pci_free_irq_vectors.

Right, I don't think it could, so this can be removed.

>
>> > +	for (i = 0; i < vectors; i++)
>> > +		msi_vectors[i] = pdev->irq + i;
> You should not need this array, just use pci_irq_vectors().
>

That should be ok.

> .
>

Thanks,
John
