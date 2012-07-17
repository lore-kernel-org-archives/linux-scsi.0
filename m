From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] sd: do not set changed flag on all unit attention conditions
Date: Tue, 17 Jul 2012 10:54:54 +0200
Message-ID: <5005285E.8060706@redhat.com>
References: <1342454772-9018-1-git-send-email-pbonzini@redhat.com>   <1342455503.3176.42.camel@dabdike.int.hansenpartnership.com>   <50044D56.6000400@redhat.com>  <1342511100.3039.9.camel@dabdike.int.hansenpartnership.com>  <50052390.7030908@redhat.com> <1342514444.3039.23.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1342514444.3039.23.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 17/07/2012 10:40, James Bottomley ha scritto:
>> > 
>> > It's not specific to virtio-scsi, in fact I expect that virtio-scsi will
>> > be almost always used with non-removable disks.
>> > 
>> > However, QEMU's SCSI target is not used just for virtio-scsi (for
>> > example it can be used for USB storage), and it lets you mark a disk as
>> > removable---why? because there exists real hardware that presents itself
>> > as an SBC removable disk.  The only thing that is specific to
>> > virtualization, is support for online resizing (which generates a unit
>> > attention condition CAPACITY DATA HAS CHANGED).
> So what's the problem?  If you're doing pass through of a physical disk,
> we pick up removable from its inquiry string ... a physical removable
> device doesn't get resized.  If you have a virtual disk you want to
> resize, you don't set the removable flag in the inquiry data.

In practice people will do what you said, and it's not a problem.

However, there's nothing that prevents you from running qemu with a
removable SCSI disk, and then resizing it.  I would like this to work,
because SBC allows it and there's no reason why it shouldn't.

Paolo
