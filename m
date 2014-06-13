From: Venkatesh Srinivas <venkateshs@google.com>
Subject: Re: virtio-scsi issues duplicate tags when async_abort is enabled
Date: Fri, 13 Jun 2014 12:15:10 -0700
Message-ID: <CAHdzE-8kNKgKXyHUwO+HSMnvoHzb-pKW6PLWWLKohk2d+=gqyQ@mail.gmail.com>
References: <CAHdzE-8k6A6kVB7DnOc6_XKg6DANLRFmP9+f4oXE1vPoLhOK=g@mail.gmail.com>
	<20140613185221.GA11872@infradead.org>
	<1402686574.2224.61.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1402686574.2224.61.camel@dabdike.int.hansenpartnership.com>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 13, 2014 at 12:09 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2014-06-13 at 11:52 -0700, Christoph Hellwig wrote:
>> On Fri, Jun 13, 2014 at 10:58:22AM -0700, Venkatesh Srinivas wrote:
>> > CC-ing stable as 3.14 and 3.15 are affected; a conservative fix is to
>> > enable no_async_abort until the problem is better-understood.
>>
>> No patch attached.  Nevermind this is not a consdervative fix, but a
>> band aid.  The proper fix is to figure out what's actually going on
>> here.
>>
>> >From your trace above it very much looks like a double completion of
>> some sort.
>>
>> I've looked at the virtio-scsi code a bit, and one odd thing it does
>> that comes in handy here is that it doesn't really use a traditional
>> tag, but rather the address of the scsi command.
>
> What kernel version?  This is the exact signature of the original USB
> REQUEST_SENSE problem.

Mix of kernels, all 3.14-based. Debian 3.14-0.bpo, Gentoo's 3.14,
upstream from git as of a few days ago.

Distribution 3.13 and earlier kernels (Debian's 3.2.0-4, Debian
3.13-0.bpo.1, Gentoo 3.13.6) do not hit this issue with the same
workload.

-- vs;
