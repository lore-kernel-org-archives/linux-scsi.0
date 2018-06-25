From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: [PATCH 0/5]stop normal completion path entering a timeout req
Date: Mon, 25 Jun 2018 09:29:19 +0800
Message-ID: <8438fb8b-564b-1208-7c88-8061552e1dcb@oracle.com>
References: <1529500964-28429-1-git-send-email-jianchao.w.wang@oracle.com>
 <20180620181601.GA24145@localhost.localdomain>
 <e87f5946-bb21-942e-2dcc-b24cee1ad23c@oracle.com>
 <20180621081900.GA5183@lst.de>
 <a68ad043-26a1-d3d8-2009-504ba4230e0f@oracle.com>
 <20180622151043.GA13470@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180622151043.GA13470@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <keith.busch@intel.com>, axboe@kernel.dk, martin.petersen@oracle.com, josef@toxicpanda.com, ulf.hansson@linaro.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Christoph

Sorry for delayed response.

On 06/22/2018 11:10 PM, Christoph Hellwig wrote:
> On Thu, Jun 21, 2018 at 04:22:22PM +0800, jianchao.wang wrote:
>>> Trace, please.  With the latest kernel.  I'm not saying that there
>>> is nothing to fix, but the mode of never completing once timeout
>>> requests as currently done is SCSI is clearly broken.
>>>
>>
>> I didn't find the existing method to simulate this.
>> So I modified the scsi-debug as following patch as install it as following:
>> modprobe scsi-debug delay=-1 ndelay=-1
>> Both 4.17-rc1 and 4.18-rc1 with this patch set could survive from the test.
> 
> What tree is this against?  I can't apply it to either current Linus'
> tree or 4.17 for that matter.

Ｉ made the patch against 4.18.rc1.

> Also I'm not sure this blk_abort_request call is representative
> of the real world.  Drivers do drain their queues before calling
> it in general, e.g. take a look at ata_eh_set_pending for the
> probably most common user.
> 

This blk_abort_request here is to force request timed out and simulate the
scenario where timeout path and io completion path could occur concurrently.
It is hard for me to trigger this scenario in real world, so I made  this patch
which may looks bad. What I want is to trigger the io completion and timeout path
concurrently.


Thanks
Jianchao
