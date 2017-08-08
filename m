From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH v2 00/13] mpt3sas driver NVMe support:
Date: Tue, 8 Aug 2017 00:04:49 -0400
Message-ID: <20170808040449.GE842@localhost.localdomain>
References: <1500038560-11231-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <e679a449-90c3-d2e1-2b31-1387cf414e09@suse.de>
 <20170805135353.GA7526@infradead.org>
 <1501944129.3649.9.camel@HansenPartnership.com>
 <0ada8680ebfeb026662d858ec2b38ef4@mail.gmail.com>
 <1502115492.2841.20.camel@HansenPartnership.com>
 <da1e0ded0c7d4bab1cfa0850488c8fb7@mail.gmail.com>
 <1502120725.2841.28.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:64808 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751914AbdHHD6I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Aug 2017 23:58:08 -0400
Content-Disposition: inline
In-Reply-To: <1502120725.2841.28.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-scsi@vger.kernel.org, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, martin.petersen@oracle.com

On Mon, Aug 07, 2017 at 08:45:25AM -0700, James Bottomley wrote:
> On Mon, 2017-08-07 at 20:01 +0530, Kashyap Desai wrote:
> > 
> > We have to attempt this use case and see how it behaves. I have not
> > tried this, so not sure if things are really bad or just some tuning
> > may be helpful. I will revert back to you on this.
> > 
> > I understood request as -  We need some udev rules to be working well
> > for *same* NVME drives if it is behind <mpt3sas> or native <nvme>.
> > Example - If user has OS installed on NVME drive which is behind
> > <mpt3sas> driver as SCSI disk should be able to boot if he/she hooked
> > same NVME drive which is detected by native <nvme> driver (and vice
> > versa.)
> 
> It's not just the udev rules, it's the tools as well; possibly things
> like that nvme-cli toolkit Intel is doing.

It looks like they can make existing nvme tooling work with little
effort if they have the driver implement NVME_IOCTL_ADMIN_COMMAND, and
then have their driver build the MPI NVMe Encapsulated Request from that.
