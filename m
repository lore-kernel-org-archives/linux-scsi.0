From: Sayali Lokhande <sayalil@codeaurora.org>
Subject: Re: [PATCH V5 2/2] scsi: ufs: Add configfs support for ufs
 provisioning
Date: Mon, 30 Jul 2018 13:16:00 +0530
Message-ID: <8e6af8ed-1ec0-f10e-69b2-08281b638a4b@codeaurora.org>
References: <1530858040-13971-1-git-send-email-sayalil@codeaurora.org>
 <1530858040-13971-3-git-send-email-sayalil@codeaurora.org>
 <CAE=gft5U1-Jo-GvTF7sNAV3Q565AmuUrHpmBdxUL+UwkKxesqA@mail.gmail.com>
 <0dce9e9c-4f93-9857-72ee-f65ff195c41a@codeaurora.org>
 <CAE=gft6_=SQjgv7_kHXKJKa8_45NKKFwwE7UaXsijPpMd35LOg@mail.gmail.com>
 <4cb931e199599314829f5ff750797c88fc123f1f.camel@wdc.com>
 <CAE=gft6zm2mw3rnNuktDe0NWs-NM1CFQw1BUeGhaBi3eoEDXBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAE=gft6zm2mw3rnNuktDe0NWs-NM1CFQw1BUeGhaBi3eoEDXBg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>, Bart.VanAssche@wdc.com
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, linux-kernel@vger.kernel.org, asutoshd@codeaurora.org, riteshh@codeaurora.org, cang@codeaurora.org, martin.petersen@oracle.com, subhashj@codeaurora.org, linux-scsi@vger.kernel.org, vivek.gautam@codeaurora.org, Rajendra Nayak <rnayak@codeaurora.org>, jejb@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

Hi Evan,


On 7/18/2018 1:53 AM, Evan Green wrote:
> On Mon, Jul 16, 2018 at 5:04 PM Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
>> On Mon, 2018-07-16 at 16:46 -0700, Evan Green wrote:
>>> I see Bart has chimed in on the next series with a suggestion to break
>>> out each field into individual files within configfs. Bart, what are
>>> your feelings about converting to a binary attribute? I remember when
>>> I did my sysfs equivalent of this patch, somebody chimed in indicating
>>> a "commit" file might be needed so that the new configuration could be
>>> written in one fell swoop. One advantage of the binary attribute is
>>> that it writes the configuration atomically.
>> Hello Evan,
>>
>> I may be missing some UFS background information. But since a configfs interface
>> is being added I think the same rule applies as to all Linux kernel user space
>> interfaces, namely that it should be backwards compatible. Additionally, if
>> anyone ever will want to use this interface from a shell script, I think that
>> it will be much easier to write multiple ASCII attributes than a single binary
>> attribute.
>>
> Hi Bart,
> I'm unsure about the compatibility aspect for binary attributes that
> essentially represent direct windows into hardware. I suppose this
> comes down to who this interface is most useful to. Hypothetically
> lets say a future revision of UFS adds fields to the configuration
> descriptor, but is otherwise backwards compatible. If this interface
> is primarily for OEMs initializing their devices in the factory, then
> I'd argue they'd want the most direct window to the configuration
> descriptor. These folks probably just have a configuration they want
> to plunk into the hardware, and would prefer being able to write all
> fields over having some sort of compatibility restriction. If, on the
> other hand, this is used by long-running scripts that stick around for
> years without modification, then yes, it seems like it would be more
> important to stay compatible, and have smarts in the kernel to make
> writes of old descriptors work in new devices.
>
> At least for myself, I fall into the category of someone who just
> needs to plunk a configuration descriptor in once, and would prefer
> not to have to submit kernel changes if the descriptor evolves
> slightly. It also seemed a little odd that this patch now spends a
> bunch of energy converting ASCII into bytes, just to write it without
> modification into the hardware, and convert back again to ASCII for
> reads.
>
> We plan to use a script for provisioning, and could easily handle
> ASCII or rawbytes:
>
> # Some bytes, ready to go with the interface today...
> some_bytes="00 01 02 03"
>
> # Same bytes, now in binary format
> bytes_fmt=$(echo " $some_bytes" | sed 's/ /\\x/g')
> /usr/bin/printf "$bytes_fmt" > /configfs/ufs_provision
>
> I'm not dead set on binary, since as above I could do it either way,
> but it seemed worth at least talking through. Let me know what you
> think.
> -Evan

I am using ASCII format for reading/writing to config desc as it will be 
more readable for users and easier/comfortable to compare any value to 
default spec value(if required).
So I don't really see any harm in using current ASCII format for 
provisioning purpose.
-Sayali
