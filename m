From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: virtio-scsi: Fix address translation failure of
 HighMem pages used by sg list
Date: Wed, 25 Jul 2012 15:36:22 +0200
Message-ID: <500FF656.6000203@redhat.com>
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com> <500FB1DE.1000100@redhat.com> <500FBAE8.2050107@panasas.com> <500FBF37.50603@redhat.com> <500FE7D2.7070101@panasas.com> <500FEB63.3000709@redhat.com> <500FF412.3090600@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <500FF412.3090600@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 25/07/2012 15:26, Boaz Harrosh ha scritto:
> On 07/25/2012 03:49 PM, Paolo Bonzini wrote:
> 
>>
>> Except here the destination array has to be given to virtio, which
>> doesn't (yet) understand chaining.  I'm using for_each_sg rather than a
>> simple memcpy exactly because I want to flatten the input scatterlist
>> onto consecutive scatterlist entries, which is what virtio expects (and
>> what I'll change when I get to it).
>>
>> for_each_sg guarantees that I get non-chain scatterlists only, so it is
>> okay to value-assign them to sg[].
> 
> So if the virtio does not understand chaining at all then surly it will
> not understand the 2-bit end marker and will get a wrong page pointer
> with the 1st bit set.

It doesn't understand chaining, but it does use sg_phys(x) so it will
not get a wrong page pointer for the end marker.

> Fine then your code is now a crash because the terminating bit was just
> copied over, which it was not before.

I did test the patch with value-assignment.

> Lets separate the two topics from now on. Send me one mail concerning
> the proper above patch, And a different mail for how to support chaining.

Ok, and I'll change the topic.

Paolo
