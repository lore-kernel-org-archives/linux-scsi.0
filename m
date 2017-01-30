From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH] scsi, block: fix duplicate bdi name registration crashes
Date: Mon, 30 Jan 2017 12:57:05 -0800
Message-ID: <CAPcyv4j2zm93jp6j7__xhSTXWKnh2MdEr5BxJ_ycku77xdtrTQ@mail.gmail.com>
References: <148566590827.1627.3631056985359212959.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170130122452.GA9043@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170130122452.GA9043@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Omar Sandoval <osandov@osandov.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 30, 2017 at 4:24 AM, Christoph Hellwig <hch@lst.de> wrote:
> Hi Dan,
>
> this looks mostly fine to me.  A few code comments below, but except
> for this there is another issue with it:  We still have drivers
> that share a single request_queue for multiple gendisks, so I wonder
>
> Also I think you probably want one patch for the block framework,
> and one to switch SCSI over to it.
>
>> +struct disk_devt {
>> +     struct kref kref;
>> +     void (*release)(struct kref *);
>> +};
>> +
>> +static inline void put_disk_devt(struct disk_devt *disk_devt)
>> +{
>> +     if (disk_devt)
>> +             kref_put(&disk_devt->kref, disk_devt->release);
>> +}
>> +
>> +static inline void get_disk_devt(struct disk_devt *disk_devt)
>> +{
>> +     if (disk_devt)
>> +             kref_get(&disk_devt->kref);
>> +}
>
> Given that we have a user-supplied release callack I'd much rather get
> rid of the kref here, use a normal atomic_t and pass the disk_devt
> structure to the release callback then a kref.

I'm missing something... kref is just:

struct kref {
        atomic_t refcount;
};

...so what do we gain by open coding kref_get() and kref_put()?
