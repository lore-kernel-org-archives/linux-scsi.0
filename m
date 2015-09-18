From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH 01/17] Add ida and idr helper routines.
Date: Fri, 18 Sep 2015 08:42:26 -0700
Message-ID: <55FC30E2.8020000@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
 <915ec9ff5e9cc1fae0b36bf7d4c4cb115439e15d.1442263512.git.lduncan@suse.com>
 <20150915182755.GA31484@htj.duckdns.org>
 <1442342322.2177.13.camel@HansenPartnership.com>
 <20150915184157.GA495@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150915184157.GA495@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 09/15/2015 11:41 AM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Sep 15, 2015 at 11:38:42AM -0700, James Bottomley wrote:
>> For most of the SCSI stuff, yes.  I'm less sure about the sd numbers.
>> They go up very high and get hammered a lot during system bring up and
>> hot plug.  I think having their own lock rather than wrapping everything
>> around simple_ida_lock makes more sense here just because the system is
>> heavily contended on getting indexes at bring up.
>>
>> To continue the thought, why not move simple_ida_lock into struct ida so
>> we don't have to worry about the contention and can sue ida_simple_...
>> everywhere?
> 
> We sure can do that if necessary but I'm rather doubtful that even
> with sd number hammering this is likely to be a problem.  Let's
> convert the users to the simple interface and make the lock per-ida if
> we actually see contention on the lock.
> 
> Thanks.
> 

To be clear: you would like a patch series that converts the users of
the ida_* routines in my patches to instead use the ida_simple_*
routines, correct? And of course the ida_* helper routines I was adding
in idr.h would not be needed.

If this is correct, I will supply a version 2 patch series that
addresses this issue as well as the two patch-naming issues that were
raised.
-- 
Lee Duncan
