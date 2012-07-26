From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] virtio-scsi: fix parsing of hotplug/hot-unplug LUN
 number
Date: Thu, 26 Jul 2012 12:43:56 +0200
Message-ID: <50111F6C.7010502@redhat.com>
References: <1342454751-8950-1-git-send-email-pbonzini@redhat.com>    <1342454751-8950-2-git-send-email-pbonzini@redhat.com>   <1343292731.3115.17.camel@dabdike> <50110820.4040403@redhat.com>  <1343294472.3115.22.camel@dabdike> <50111936.8090508@acm.org> <1343298798.3115.31.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343298798.3115.31.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 26/07/2012 12:33, James Bottomley ha scritto:
>> > Has it already been considered to modify scsilun_to_int() such that LUN
>> > numbers start at zero even for addressing method 1 ? This is what e.g.
>> > the function scst_unpack_lun() already does. See also
>> > http://scst.svn.sourceforge.net/viewvc/scst/trunk/scst/src/scst_lib.c?revision=HEAD&view=markup.
> Yes, as I said before, the problem is that the actual numbers are
> 
> 1. not 1:1: there are several possible encodings of luns 0-255
> 2. hierarchical, so once you go beyond a single level you can't properly
> use a numeric representation either.
> 
> the mid layer just uses the lun number as an encoding of the actual SAM
> lun.  The key for us is that int_to_scsilun has to go back the other
> way.

I still disagree, but I will modify QEMU so that this patch is not
necessary.  Later I can switch to int_to_scsilun.

Paolo
