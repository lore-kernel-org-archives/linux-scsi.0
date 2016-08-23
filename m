From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Oops when completing request on the wrong queue
Date: Tue, 23 Aug 2016 15:14:23 -0600
Message-ID: <164a4c63-065b-b766-36f3-bcef4aa46a38@kernel.dk>
References: <87a8gltgks.fsf@linux.vnet.ibm.com>
 <871t1kq455.fsf@linux.vnet.ibm.com>
 <bb6f8757-4c3d-8f49-8aff-aa0fdb8bae89@kernel.dk>
 <8fc9ae38-9488-ef52-f620-08499edebffa@kernel.dk>
 <87shu0hfye.fsf@linux.vnet.ibm.com> <87a8g39pg4.fsf@linux.vnet.ibm.com>
 <43693064-dd37-92ce-7753-2a8edb43eab5@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <43693064-dd37-92ce-7753-2a8edb43eab5@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org, Brian King <brking@linux.vnet.ibm.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/23/2016 03:11 PM, Jens Axboe wrote:
> On 08/23/2016 02:54 PM, Gabriel Krisman Bertazi wrote:
>> Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com> writes:
>>
>>>> Can you share what you ran to online/offline CPUs? I can't reproduce
>>>> this here.
>>>
>>> I was using the ppc64_cpu tool, which shouldn't do nothing more than
>>> write to sysfs.  but I just reproduced it with the script below.
>>>
>>> Note that this is ppc64le.  I don't have a x86 in hand to attempt to
>>> reproduce right now, but I'll look for one and see how it goes.
>>
>> Hi,
>>
>> Any luck on reproducing it?  We were initially reproducing with a
>> proprietary stress test, but I gave a try to a generated fio jobfile
>> associated with the SMT script I shared earlier and I could reproduce
>> the crash consistently in less than 10 minutes of execution.  this was
>> still ppc64le, though.  I couldn't get my hands on nvme on x86 yet.
>
> Nope, I have not been able to reproduce it. How long does the CPU
> offline/online actions take on ppc64? It's pretty slow on x86, which may
> hide the issue. I took out the various printk's associated with bringing
> a CPU off/online, as well as IRQ breaking parts, but didn't help in
> reproducing it.
>
>> The job file I used, as well as the smt.sh script, in case you want to
>> give it a try:
>>
>> jobfile: http://krisman.be/k/nvmejob.fio
>> smt.sh:  http://krisman.be/k/smt.sh
>>
>> Still, the trigger seems to be consistently a heavy load of IO
>> associated with CPU addition/removal.
>
> My workload looks similar to yours, in that it's high depth and with a
> lot of jobs to keep most CPUs loaded. My bash script is different than
> yours, I'll try that and see if it helps here.

Actually, I take that back. You're not using O_DIRECT, hence all your
jobs are running at QD=1, not the 256 specified. That looks odd, but
I'll try, maybe it'll hit something different.


-- 
Jens Axboe
