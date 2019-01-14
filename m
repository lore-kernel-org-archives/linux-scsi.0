From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: isci: initialize shost fully before calling
 scsi_add_host()
Date: Mon, 14 Jan 2019 12:10:23 +0000
Message-ID: <0ffaf166-c7e5-b135-fdc5-bcac24148e62@huawei.com>
References: <20190108205043.3122-1-logang@deltatee.com>
 <20190109184105.GB22070@lst.de>
 <8d96b40d-fc83-9218-9479-3de423594ddb@huawei.com>
 <yq1lg3qy578.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1lg3qy578.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Logan Gunthorpe <logang@deltatee.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>, chenxiang <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 12/01/2019 02:34, Martin K. Petersen wrote:
>
> John,
>
>> So how about just drop these APIs and let the user set the shost
>> protection parameters directly, like other shost parameters,
>
> The protection interfaces here obviously predate the block layer
> allocation changes that made this particular issue pop up.
>
>> which should make it a bit clearer when these should be set,
>> i.e. before scsi_add_host()?
>
> In general, I am not so keen on the somewhat messy intersection between
> the host parameters and the host template. The static host templates
> made lots of sense in the days of Seagate ST01 and fixed hardware
> capabilities.  But reality is that most modern controllers have to query
> firmware interfaces to figure out what their actual capabilities are.

Hi Martin,

I am not suggested setting the parameters via scsi host template, but 
rather dynamically (as we currently do) but just drop the set helper 
functions, like:

     shost->max_channel = 1;
     shost->max_cmd_len = 16;

     ...

     if (hisi_hba->prot_mask) {
         dev_info(dev, "Registering for DIF/DIX prot_mask=0x%x\n",
              prot_mask);
-        scsi_host_set_prot(hisi_hba->shost, prot_mask);
+        shost->prot_capabilities = prot_mask;
     }

     rc = scsi_add_host(shost, dev);
     if (rc)
         goto err_out_ha;

     rc = sas_register_ha(sha);
     if (rc)
         goto err_out_register_ha;

I find that it is not crystal clear when scsi_host_set_prot() and 
scsi_host_set_guard() should be called, but not so for setting the shost 
parameters directly, which is common.

>
> So in this case I think that accessor functions are actually better
> because they allow us to print a big fat warning when you twiddle
> something you shouldn't post-initialization. So that's something I think
> we could--and should--improve.
>

Sure, this is an alternative, but I would rather make it obvious when 
these parameters should be set so that this would not be required.

Thanks,
John
