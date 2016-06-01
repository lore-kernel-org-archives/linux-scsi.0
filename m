From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 1/2] scsi: fix race between simultaneous decrements of ->host_failed
Date: Tue, 31 May 2016 20:30:33 -0700
Message-ID: <CAPcyv4geu54Pdub4Cr-NOu34PvwuGwDUZFPP3K3tOb923c20-g@mail.gmail.com>
References: <1464683898-9877-1-git-send-email-fangwei1@huawei.com>
	<CAPcyv4jtwg9J7WDzf2y5Uq-p8vthG+F6Zo+NLT=qYQcA9qqtCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4jtwg9J7WDzf2y5Uq-p8vthG+F6Zo+NLT=qYQcA9qqtCQ@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, May 31, 2016 at 8:21 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, May 31, 2016 at 1:38 AM, Wei Fang <fangwei1@huawei.com> wrote:
>> sas_ata_strategy_handler() adds the works of the ata error handler
>> to system_unbound_wq. This workqueue asynchronously runs work items,
>> so the ata error handler will be performed concurrently on different
>> CPUs. In this case, ->host_failed will be decreased simultaneously in
>> scsi_eh_finish_cmd() on different CPUs, and become abnormal.
>>
>> It will lead to permanently inequal between ->host_failed and
>>  ->host_busy, and scsi error handler thread won't become running.
>> IO errors after that won't be handled forever.
>>
>> Use atomic type for ->host_failed to fix this race.
>>
>> This fixes the problem introduced in
>> commit 50824d6c5657 ("[SCSI] libsas: async ata-eh").
>>
>> Reviewed-by: Christoph Hellwig <hch@infradead.org>
>> Signed-off-by: Wei Fang <fangwei1@huawei.com>
>
> Acked-by: Dan Williams <dan.j.williams@intel.com>

Should also tag this for -stable.
