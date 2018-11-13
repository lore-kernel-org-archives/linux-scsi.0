From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: libsas: Remove pcidev reference
Date: Tue, 13 Nov 2018 13:38:24 +0000
Message-ID: <b63b6d3c-3b18-fcfa-1869-78b1f7637fd1@huawei.com>
References: <1542043689-214071-1-git-send-email-john.garry@huawei.com>
 <584e7b4fcd6f95fe0c581f6f9472852685c754d1.camel@perches.com>
 <310504a2-f33c-183b-d00a-fa067b273dfd@huawei.com>
 <3b62b0ad-53ba-37c2-817c-591d94eed838@huawei.com>
 <31d224e8c4b9bcebc3657c17fa50302f7da90e64.camel@perches.com>
 <dd39734e-4113-f9fd-6890-a83e80093c7e@huawei.com>
 <3470156e35390d1810a6a5e4a554a77493c0d44f.camel@perches.com>
 <39f56211-cf15-8ca5-a48f-3e4cc347cdb0@huawei.com>
 <dda6fafd2096845ef503921703652f511d4f0daa.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <dda6fafd2096845ef503921703652f511d4f0daa.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-scsi@vger.kernel.org

On 12/11/2018 19:52, Joe Perches wrote:
> On Mon, 2018-11-12 at 19:31 +0000, John Garry wrote:
>> On 12/11/2018 18:58, Joe Perches wrote:
>>>>> +#define pr_fmt(fmt) "sas: " fmt
>>>>>
>>>>> Some other subsystem may try to include this header, and gets its
>>>>> message prefix overwritten. Just a consequence for doing something bad,
>>>>> right?
>>> Right.
>>>
>>> And as this file is internal to drivers/scsi/libsas
>>> that seems very unlikely to occur.
>>>
>>> It also might useful to use the common debugging
>>> mechanisms and convert SAS_DPRINTK to pr_debug
>>> which would use the same #define pr_fmt.
>>>
>>

We have almost 100 references to SAS_DPRINTK. So when we replace with 
pr_debug, we will frequently have to realign the indentation. I'm 
beginning to think it's not worth the churn to remove SAS_DPRINTK.

However, with regards to using pr_debug(), there are loops to jump 
through to ensure any output at all:
- ensure DEBUG is defined or DYNAMIC DEBUG enabled
- ensure current loglevel is high enough

Having said that, there are actually lots of logs in libsas where debug 
level is too low (at pr_debug), and these could be upgraded.

So I think I will just go through the code and revise these levels.

>> OK, I will try to put this all together as a marginally wider scope tidy-up.
>
> Thanks.
>
> Another thing that could be done is to change
> the #define pr_fmt(fmt) to KBUILD_MODNAME as
> that would prefix "libsas" instead of just "sas".
>

I think "sas" makes more sense, as this is the technology, as opposed to 
"libsas", which is just the software framework name.

> I think that would be better but I didn't do that
> as it should be in a separate patch.
>

Cheers,
John
