From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH V2 resend] libata:fix kernel panic when hotplug
Date: Mon, 20 Jun 2016 18:46:55 -0700
Message-ID: <CAPcyv4hnzAoiPQNHD_6C74exQrDQGaGG-fRw8XAAkj80bv5nqg@mail.gmail.com>
References: <1466052340-25520-1-git-send-email-dingxiang@huawei.com>
	<20160616202045.GF3262@mtj.duckdns.org>
	<yq160t35oas.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq160t35oas.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, DingXiang <dingxiang@huawei.com>, jejb@linux.vnet.ibm.com, Wei Fang <fangwei1@huawei.com>, miaoxie@huawei.com, wangyijing@huawei.com, zhangaihua1@huawei.com, zhaohongjiang@huawei.com, houtao1@huawei.com, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 20, 2016 at 6:22 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Tejun" == Tejun Heo <tj@kernel.org> writes:
>
>>> In fact,we don't need libata to deal with hotplug in sas environment.
>>> So we can't run ata hotplug task when ata port is sas host.
>
> Tejun> Martin, can you please confirm whether the above is true.  If so,
> Tejun> I'll route the patch through libata w/ stable cc'd.
>
> Not exactly a libsas expert. James? Dan?

While it is true that libsas itself handles adding / removing devices
we have historically avoided this conflict because
ATA_PFLAG_SCSI_HOTPLUG is never set for libsas ata_ports.  So the bug
/ behavior change is that  ATA_PFLAG_SCSI_HOTPLUG gets set in the
first place.  Ignoring it is a band-aid / not the real fix afaics.
