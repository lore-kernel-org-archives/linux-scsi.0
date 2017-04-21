From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 0/5] Re-order scsi_remove_host and sas_remove_host in
 SAS HBA LLDDs
Date: Fri, 21 Apr 2017 10:39:38 +0200
Message-ID: <20170421083938.GD26346@linux-x5ow.site>
References: <cover.1492760075.git.jthumshirn@suse.de>
 <f101e42e-0aed-b8ce-2f36-cf16d1964f46@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f101e42e-0aed-b8ce-2f36-cf16d1964f46@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Jinpu Wang <jinpu.wang@profitbricks.com>, tj@kernel.org, wangyijing@huawei.com, Heyousong <heyousong@huawei.com>, "chenqilin (C)" <chenqilin2@huawei.com>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 21, 2017 at 09:34:18AM +0100, John Garry wrote:
> Thanks Johannes.
> 
> @wangyijing, can you test this patchset please (specifically 3/5)? I know
> that you have the modified version of libsas which you dabbled with
> upstreaming.
> 
> On 21/04/2017 09:04, Johannes Thumshirn wrote:
> >This series re-orders the calls to scsi_remove_host() and sas_remove_host() in
> >all SAS HBA drivers (apart from mpt3sas which is doing it correctly). This is
> >for two reasons:
> >	1) After the change to recursive removal of sysfs entries, we're
> >	   trying to remove already removed kobjects when doing a
> >	   sas_remove_host() _after_ a scsi_remove_host()
> >	2) the documentation mandates it even (becuase of 1)
> >
> >Unfortunately this does not completely solve issues with recursive sysfs
> >removals in SAS, as libsas has asynchronous behaviour where strong ordering
> >would be needed. But I am working on it and I do know other do as well. So if
> >anyone else (James, Christoph, Bart, I'm looking at you) has an idea, I do
> >have test setups and I'm willing to take input in form of ideas and patches.
> >
> 
> wangyijing already sent an RFC for fixing this issue (mentioned above),
> which was a signifiagnt rewrite of some of libsas.
> I am hoping that he would retry, and that community would support/shepherd
> this activity, or at least say it will be accepted so effort is not wasted.

Do you have a link to the series? No problem if not, I'll probably can find it
in my archives. Anyways, if Wangyijing is re-sending his patches please Cc me
on it.

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
