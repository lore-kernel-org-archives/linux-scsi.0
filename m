From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: isci: initialize shost fully before calling
 scsi_add_host()
Date: Wed, 16 Jan 2019 14:44:41 +0000
Message-ID: <f393a8f4-aff9-2117-d7a1-26abd72e22b4@huawei.com>
References: <20190108205043.3122-1-logang@deltatee.com>
 <20190109184105.GB22070@lst.de>
 <8d96b40d-fc83-9218-9479-3de423594ddb@huawei.com>
 <yq1lg3qy578.fsf@oracle.com>
 <0ffaf166-c7e5-b135-fdc5-bcac24148e62@huawei.com>
 <yq1sgxts46u.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1sgxts46u.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Logan Gunthorpe <logang@deltatee.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>, chenxiang <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 16/01/2019 02:54, Martin K. Petersen wrote:
>
> Hi John,
>

Hi Martin,

>>> So in this case I think that accessor functions are actually better
>>> because they allow us to print a big fat warning when you twiddle
>>> something you shouldn't post-initialization. So that's something I think
>>> we could--and should--improve.
>>>
>> Sure, this is an alternative, but I would rather make it obvious when
>> these parameters should be set so that this would not be required.
>
> I would like to have a mechanism in place that warns if you twiddle
> things that break assumptions made at host registration time.

Yes, something more robust would be good.

That's not
> a scenario the old registration interface was designed to handle.
>
> I am not sure I agree with your assertion that setting these masks in
> the struct prior to scsi_add_host() makes this ordering requirement much
> more obvious.
It is not like you are passing in a list of parameters and
> then receiving a separately instantiated immutable scsi_host object. You
> are performing an operation on something you already have and own.
>
> That's why I commented that the current intersection between
> compile-time static host template, dynamically discovered
> pre-registration scsi_host parameters, and the registered runtime
> scsi_host struct is somewhat messy.
>
> Btw. I have no attachment to the prot wrappers whatsoever. The reason
> they exist is that the SCSI integrity support was optional. And
> therefore we had stub functions so things could be compiled without any
> of the integrity fields being present in the various SCSI structs.

I never noticed stubs for setting/getting 
Scsi_host.prot_{capabilities,guard_type}

So I
> don't have any problem killing the wrappers except they may actually be
> handy for regressions like this one where you could #error if the driver
> writer violates the ordering requirement.
>

We set many Scsi_host parameters without such safeguarding, and I don't 
know what's special about these protection-related members.

Thanks,
John
