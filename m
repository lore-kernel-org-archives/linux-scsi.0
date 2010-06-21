From: Avi Kivity <avi@redhat.com>
Subject: Re: [Lsf10-pc] Current MM topics for LSF10/MM Summit 8-9 August in
 Boston
Date: Mon, 21 Jun 2010 17:31:41 +0300
Message-ID: <4C1F77CD.40509@redhat.com>
References: <1276721459.2847.399.camel@mulgrave.site> <20100621120526.GA31679@laptop> <20100621131608.GW5787@random.random> <20100621132238.GK4689@redhat.com> <20100621140939.GY5787@random.random> <20100621141855.GN4689@redhat.com> <20100621142952.GZ5787@random.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100621142952.GZ5787@random.random>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, lsf10-pc@lists.linuxfoundation.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/21/2010 05:29 PM, Andrea Arcangeli wrote:
> On Mon, Jun 21, 2010 at 05:18:56PM +0300, Gleb Natapov wrote:
>    
>> Avi did the fix. We discussed using MADV_DONTFORK for that, but calling
>> madvise() from kernel deemed to be messy.
>>      
> Agree that calling madvise looks messy. It's possible to set
> VM_DONTCOPY under mmap_sem write mode and it'll work as well.
>    

But we aren't guaranteed to get our own vma, yes?

> But surely we can as well keep this quicker fix until the fork vs gup
> race is fixed, and back it out later.
>    

Right.

Note kvm shouldn't be calling do_mmap() in any case.  I let that in 
because it was simple and because we had a userspace interface relying 
on that, but that's no longer the case, so I'll make that page kernel owned.

-- 
error compiling committee.c: too many arguments to function

