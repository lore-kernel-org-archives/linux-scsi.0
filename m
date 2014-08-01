From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1.3 6/18] arcmsr: precise checking adapter ID
Date: Fri, 1 Aug 2014 05:33:52 -0700
Message-ID: <20140801123352.GA30397@infradead.org>
References: <1406882870.10378.55.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1406882870.10378.55.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> -static void arcmsr_define_adapter_type(struct AdapterControlBlock *acb)
> +static bool arcmsr_define_adapter_type(struct AdapterControlBlock *acb)
>  {
>  	struct pci_dev *pdev = acb->pdev;
>  	u16 dev_id;
> +
>  	pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id);
>  	acb->dev_id = dev_id;

This is already available through pdev->device.


>  		acb->adapter_type = ACB_ADAPTER_TYPE_C;

Just store the adapter type in the pci_device_id private data field,
that way you enumerate the type in the same place the ids are added
and you'll never miss adding them to a switch value.
