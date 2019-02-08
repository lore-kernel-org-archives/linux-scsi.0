From: =?UTF-8?Q?Matias_Bj=c3=b8rling?= <mb@lightnvm.io>
Subject: Re: [LSF/MM TOPIC] BPF for Block Devices
Date: Fri, 8 Feb 2019 09:31:20 +0100
Message-ID: <f1f00282-11be-1682-3802-c8bd0e6fec4b@lightnvm.io>
References: <40D2EB06-6BF2-4233-9196-7A26AC43C64E@raithlin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <40D2EB06-6BF2-4233-9196-7A26AC43C64E@raithlin.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Bates <sbates@raithlin.com>, Jens Axboe <axboe@kernel.dk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Logan Gunthorpe <logang@deltatee.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "ast@kernel.org" <ast@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2/7/19 6:12 PM, Stephen  Bates wrote:
> Hi All
> 
>> A BPF track will join the annual LSF/MM Summit this year! Please read the updated description and CFP information below.
> 
> Well if we are adding BPF to LSF/MM I have to submit a request to discuss BPF for block devices please!
> 
> There has been quite a bit of activity around the concept of Computational Storage in the past 12 months. SNIA recently formed a Technical Working Group (TWG) and it is expected that this TWG will be making proposals to standards like NVM Express to add APIs for computation elements that reside on or near block devices.
> 
> While some of these Computational Storage accelerators will provide fixed functions (e.g. a RAID, encryption or compression), others will be more flexible. Some of these flexible accelerators will be capable of running BPF code on them (something that certain Linux drivers for SmartNICs support today [1]). I would like to discuss what such a framework could look like for the storage layer and the file-system layer. I'd like to discuss how devices could advertise this capability (a special type of NVMe namespace or SCSI LUN perhaps?) and how the BPF engine could be programmed and then used against block IO. Ideally I'd like to discuss doing this in a vendor-neutral way and develop ideas I can take back to NVMe and the SNIA TWG to help shape how these standard evolve.
> 
> To provide an example use-case one could consider a BPF capable accelerator being used to perform a filtering function and then using p2pdma to scan data on a number of adjacent NVMe SSDs, filtering said data and then only providing filter-matched LBAs to the host. Many other potential applications apply.
> 
> Also, I am interested in the "The end of the DAX Experiment" topic proposed by Dan and the " Zoned Block Devices" from Matias and Damien.
> 
> Cheers
>   
> Stephen
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/netronome/nfp/bpf/offload.c?h=v5.0-rc5
>   
>      
> 

If we're going down that road, we can also look at the block I/O path 
itself.

Now that Jens' has shown that io_uring can beat SPDK. Let's take it a 
step further, and create an API, such that we can bypass the boilerplate 
checking in kernel block I/O path, and go straight to issuing the I/O in 
the block layer.

For example, we could provide an API that allows applications to 
register a fast path through the kernel — one where checks, such as 
generic_make_request_checks(), already has been validated.

The user-space application registers a BFP program with the kernel, the 
kernel prechecks the possible I/O patterns and then green-lights all 
I/Os that goes through that unit. In that way, the checks only have to 
be done once, instead of every I/O. This approach could work beautifully 
with direct io and raw devices, and with a bit more work, we can do more 
complex use-cases as well.
