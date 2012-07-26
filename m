From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] virtio-scsi: fix parsing of hotplug/hot-unplug LUN
 number
Date: Thu, 26 Jul 2012 11:58:43 +0200
Message-ID: <501114D3.8090402@redhat.com>
References: <1342454751-8950-1-git-send-email-pbonzini@redhat.com>    <1342454751-8950-2-git-send-email-pbonzini@redhat.com>   <1343292731.3115.17.camel@dabdike> <50110820.4040403@redhat.com>  <1343294472.3115.22.camel@dabdike> <50110D8C.8060802@redhat.com> <1343295687.3115.27.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343295687.3115.27.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 26/07/2012 11:41, James Bottomley ha scritto:
> On Thu, 2012-07-26 at 11:27 +0200, Paolo Bonzini wrote:
>> Il 26/07/2012 11:21, James Bottomley ha scritto:
>>>>> Because scsilun_to_int does not do the AND, so it would have exactly the
>>>>> same bug I'm fixing.
>>> It's not a bug ... it's the encoding.  All the other devices use this
>>> too.  Ideally we should have switched to 64 bit lun numbers for the
>>> encoding to be exact, but nothing so far has gone over 32 bits.  If we
>>> don't encode the Address method as part of the lun number, we don't get
>>> the reverse transform right and the addressing often fails.
>>
>> But virtio-scsi gets it right even if you use method=0 and method=1
>> interchangeably.
> 
> I don't actually understand this statement.  LUNS < 256 may be encoded
> either way (they should be encoded with address method=0 but they don't
> have to be) if you address the array with the wrong method, it doesn't
> have to give you your lun.

But virtio-scsi does, LUN "16384" and LUN 0 are the same.

If somebody wanted to add support for >16383 LUNs, we would do it with
the 4-byte encoding that is in SAM, but I don't see that happening.

> It's nothing to do with buggy hardware ...

Hardware that knows about format=1 LUNs, and yet treats LUN 0
differently depending on the encoding sounds buggy.

Of course some hardware may not know anything about format=1, so it is
wrong to pass format=1 unconditionally, but virtio-scsi does.

Paolo
