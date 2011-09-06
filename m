From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [RFC] pci: Rework config space blocking services
Date: Tue, 06 Sep 2011 10:27:45 +0200
Message-ID: <4E65D981.7070201@siemens.com>
References: <20110829150552.GA6851@redhat.com> <4E5BB358.3060705@siemens.com> <4E5BDEAB.5000405@siemens.com> <20110829191858.GA9415@redhat.com> <4E608A51.70509@siemens.com> <20110906055810.GA13286@redhat.com> <4E65C935.9000803@siemens.com> <20110906080410.GD13286@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20110906080410.GD13286@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2011-09-06 10:04, Michael S. Tsirkin wrote:
> On Tue, Sep 06, 2011 at 09:18:13AM +0200, Jan Kiszka wrote:
>>>> @@ -401,36 +403,58 @@ int pci_vpd_truncate(struct pci_dev *dev, size_t size)
>>>>  EXPORT_SYMBOL(pci_vpd_truncate);
>>>>
>>>>  /**
>>>> - * pci_block_user_cfg_access - Block userspace PCI config reads/writes
>>>> + * pci_block_cfg_access - Block PCI config reads/writes
>>>
>>> This comment seems confusing. We don't in fact block all config
>>> reads writes. Instead we block userspace accesses and
>>> concurrent block requests.
>>
>> I'm open for a better suggestion that summarize the more verbose (and
>> hopefully clearer) explanation below.
> 
> I think the problem is, it doesn't block config access
> and we call it pci_block_cfg_access.
> 
> Thinking about it, doesn't this behave somewhat like a lock?
> How about
> 
> pci_user_cfg_access_trylock
> pci_user_cfg_access_lock
> pci_user_cfg_access_unlock
> 
> And then:
>  * pci_user_cfg_access_lock - Lock userspace PCI config access

Except that the "userspace" here is still only half of the truth and I
prefer to drop it, the naming locks good to me.

>  *
>  * When locked, any userspace reads or writes to config space
>  * and concurrent lock requests will sleep, and trylock requests
>  * will fail, until pci_user_cfg_access_unlock is called.
> 
> I had a brief thought of using an rwsem internally, but
> this would make trylock fail if userspace does config read,
> changing semantics.

Also, I bet we would make lockdep unhappy when calling
down_write_trylock from IRQ context.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
