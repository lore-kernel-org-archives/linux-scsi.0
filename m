From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] virtio-scsi: fix parsing of hotplug/hot-unplug LUN
 number
Date: Thu, 26 Jul 2012 11:27:40 +0200
Message-ID: <50110D8C.8060802@redhat.com>
References: <1342454751-8950-1-git-send-email-pbonzini@redhat.com>   <1342454751-8950-2-git-send-email-pbonzini@redhat.com>  <1343292731.3115.17.camel@dabdike> <50110820.4040403@redhat.com> <1343294472.3115.22.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343294472.3115.22.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 26/07/2012 11:21, James Bottomley ha scritto:
>> > Because scsilun_to_int does not do the AND, so it would have exactly the
>> > same bug I'm fixing.
> It's not a bug ... it's the encoding.  All the other devices use this
> too.  Ideally we should have switched to 64 bit lun numbers for the
> encoding to be exact, but nothing so far has gone over 32 bits.  If we
> don't encode the Address method as part of the lun number, we don't get
> the reverse transform right and the addressing often fails.

But virtio-scsi gets it right even if you use method=0 and method=1
interchangeably.

ibmvscsi (see function lun_from_dev) does something similar to
virtio-scsi, except here I need both directions.

> That does mean that arrays that use address method=1 in REPORT LUNS have
> their lun numbers start at 16384.

That is ugly.  I can see how it may be needed on buggy hardware, but
here we know it's not.

Paolo
