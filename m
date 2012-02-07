From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
Date: Tue, 07 Feb 2012 12:26:07 +0100
Message-ID: <4F310A4F.6060602@redhat.com>
References: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com> <4F30F4EE.4080607@redhat.com> <20120207111041.GA6674@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609Ab2BGL0Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2012 06:26:16 -0500
In-Reply-To: <20120207111041.GA6674@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Christian Hoff <christian.hoff@de.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, kvm@vger.kernel.org

On 02/07/2012 12:10 PM, Michael S. Tsirkin wrote:
>>> Also, lun[1] = sc->device->id means that only 255 SCSI target IDs will be
>>> >  >supported. Think about bigger usage scenarios, such as FCP networks with
>>> >  >several hundred HBAs in the net. If you want to have the target ID<->HBA
>>> >  >mapping the same as on the guest as on the host, then 255 virtual target
>>> >  >IDs could be a limit.
>> >
>> >  I think you would hit other scalability limitations well before
>> >  that.  I plan to give each target its own MSI-X interrupt, but there
>> >  is no infinite supplies of those either.
> virtio-pci generally lets guests share MSI-X vectors between queues,
> why not allow this here?

Yes, of course.  However, with dozens of queues, many of them will share 
the same vector and all of them will be examined when you get the 
interrupt.  Even if you find the right balance between sharing (because 
you have to) and separating (because of scalability), I wouldn't be 
surprised if more than 255 targets do not work too well.

Anyway multiqueue is not even in this patchset, so there's more work to 
do before we can worry. :)

Paolo
