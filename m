From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: allow persistent reservations without CAP_SYS_RAWIO
Date: Tue, 12 Jun 2012 20:39:21 +0200
Message-ID: <4FD78CD9.6080807@redhat.com>
References: <1339517312-18134-1-git-send-email-pbonzini@redhat.com>   <1339518069.3050.8.camel@dabdike.int.hansenpartnership.com>   <4FD76D57.5020709@redhat.com> <4FD77438.6090202@redhat.com>  <1339521657.3050.13.camel@dabdike.int.hansenpartnership.com>  <4FD77B94.1030207@redhat.com> <1339524176.3050.18.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1339524176.3050.18.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 12/06/2012 20:02, James Bottomley ha scritto:
>> > Thanks for taking the time to explain---I knew about this, but I thought
>> > it could (perhaps should) be disabled on the SAN.  Anybody could already
>> > use reservation by transport ID if they had root access on the local
>> > machine, no?
> No ... it's required for multipath to work correctly and multipath is a
> usual enterprise feature.
> 
> The only way around this is either to trust your users or not to give
> out root ... and most data centres choose the latter.  It causes real
> pain from NPIV and SR-IOV ...

I can imagine...  my impression was that it would only affect whatever
LUNs the zoning allowed access to (NPIV is pretty much required to use
persistent reservations on guests, or guests will all share the same WWN).

Would it be acceptable to restrict access to PR OUT with ALL_TG_PT set,
and allow it freely without the flag?

Paolo
