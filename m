From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [Y2038] [PATCH 3/7] scsi: bfa: improve bfa_ioc_send_enable/disable
 data
Date: Mon, 13 Nov 2017 15:55:13 +0100
Message-ID: <CAK8P3a37rEZq0PdpmvNF2wsAWNO=R+pod4Mq+WF1p2bo1UGUGA@mail.gmail.com>
References: <20171110153715.1929456-1-arnd@arndb.de> <20171110153715.1929456-4-arnd@arndb.de>
 <1510582114.18523.3.camel@codethink.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1510582114.18523.3.camel@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, linux-scsi <linux-scsi@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 13, 2017 at 3:08 PM, Ben Hutchings
<ben.hutchings@codethink.co.uk> wrote:
> On Fri, 2017-11-10 at 16:37 +0100, Arnd Bergmann wrote:

>>
>>       bfi_h2i_set(enable_req.mh, BFI_MC_IOC, BFI_IOC_H2I_ENABLE_REQ,
>>                   bfa_ioc_portid(ioc));
>>       enable_req.clscode = cpu_to_be16(ioc->clscode);
>> -     do_gettimeofday(&tv);
>> -     enable_req.tv_sec = be32_to_cpu(tv.tv_sec);
>> +     /* unsigned 32-bit time_t overflow in y2106 */
>> +     enable_req.tv_sec = be32_to_cpu(ktime_get_real_seconds());
>
> The byte order conversion should also logically be cpu_to_be32(), not
> be32_to_cpu().
>

Right, I had not noticed that. I just tried fixing this, looking at what
sparse thinks of the file as a whole. I found it basically hopeless
to fix the endianess warnings in this driver, it seems completely
random here whether they are used correctly, in the opposite
direction as expected, or just flip data in place as in

attr->part[i].part_off = be32_to_cpu(f->part[i].part_off);

I'd rather not touch that part. IIRC I had at some point spent
a day trying to clean up the "warning: symbol
 'bfa_flash_sem_get' was not declared. Should it be static?"
sparse warnings for some driver, before giving up for
similar reasons.

       Arnd
