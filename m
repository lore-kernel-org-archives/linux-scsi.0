From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH v2 00/13] mpt3sas driver NVMe support:
Date: Tue, 8 Aug 2017 12:33:40 +0530
Message-ID: <CAK=zhgp6y6bWYBWJSg-8A6x_PYRgq1S83OZcGVghh3LKov7UfQ@mail.gmail.com>
References: <1500038560-11231-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <e679a449-90c3-d2e1-2b31-1387cf414e09@suse.de> <20170805135353.GA7526@infradead.org>
 <1501944129.3649.9.camel@HansenPartnership.com> <0ada8680ebfeb026662d858ec2b38ef4@mail.gmail.com>
 <1502115492.2841.20.camel@HansenPartnership.com> <da1e0ded0c7d4bab1cfa0850488c8fb7@mail.gmail.com>
 <1502120725.2841.28.camel@HansenPartnership.com> <20170808040449.GE842@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170808040449.GE842@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 8, 2017 at 9:34 AM, Keith Busch <keith.busch@intel.com> wrote:
> On Mon, Aug 07, 2017 at 08:45:25AM -0700, James Bottomley wrote:
>> On Mon, 2017-08-07 at 20:01 +0530, Kashyap Desai wrote:
>> >
>> > We have to attempt this use case and see how it behaves. I have not
>> > tried this, so not sure if things are really bad or just some tuning
>> > may be helpful. I will revert back to you on this.
>> >
>> > I understood request as -  We need some udev rules to be working well
>> > for *same* NVME drives if it is behind <mpt3sas> or native <nvme>.
>> > Example - If user has OS installed on NVME drive which is behind
>> > <mpt3sas> driver as SCSI disk should be able to boot if he/she hooked
>> > same NVME drive which is detected by native <nvme> driver (and vice
>> > versa.)
>>
>> It's not just the udev rules, it's the tools as well; possibly things
>> like that nvme-cli toolkit Intel is doing.
>
> It looks like they can make existing nvme tooling work with little
> effort if they have the driver implement NVME_IOCTL_ADMIN_COMMAND, and

Precisely, I was thinking on the same line and you clarified. I will
spend sometime on this and get back to you.

> then have their driver build the MPI NVMe Encapsulated Request from that.

Hi Everyone,

Thanks for the discussion and feedback.  We have noted this (i.e. will
Encapsulate NVME_IOCTL_ADMIN_CMD received from nvme cli in to MPI NVMe
Encapsulated Request message and will issue this request to firmware)
as our next to-do item and I will post possible options (this may need
some discussion with our FW group, so need time to get back with all
the details).

We will be posting next version of patch set i.e. v3, which will a
accommodate below changes suggested by Hannes and Martin over v2 patch
set.

1. In the MPI header files, we have reformatted headers to have type
and variable on one line as suggested by Hannes,
2. As suggested by Martin, started using blk_queue_virt_boundary() API
for NVMe drives and simplified the PRP formation.
3. Removed 'TODO' comments

Thanks,
Sreekanth
