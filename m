From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Mon, 19 Jan 2009 10:02:57 -0500
Message-ID: <49749621.9030601@cybernetics.com>
References: <49625A67.3000304@cybernetics.com>	<20090111022525I.fujita.tomonori@lab.ntt.co.jp>	<496E4B93.4000507@cybernetics.com> <20090119155509Y.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:4383 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbZASPC7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jan 2009 10:02:59 -0500
In-Reply-To: <20090119155509Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, greg@kroah.com

FUJITA Tomonori wrote:
>> Besides holding the lock during kref_put(), I also considered two
>> other simple ways to avoid this race:
>> 1) Do idr_remove() from sg_remove().
>> 2) Return NULL in sg_get_dev() if sdp->detached.
>>
>> However, both of these options would have changed the behavior of
>> the /proc/scsi/sg/* functions that show information for devices that
>> are in the process of being detached.  I wanted to fix bugs without
>> changing other behavior, so I chose to call kref_put() under lock in
>> my previous patches.
>>     
>
> How about doing 2) and accessing to /proc/scsi/sg/* with
> sg_index_lock (don't use sg_get_device for it).
>
>   
That's an excellent idea.  If it works, I can forget this whole
atomic_inc_not_zero() business and the pain that goes with it.
> What /proc/scsi/sg/* doing is abnormal from the perspective of the ref
> counting (accessing to something that is going away).
>
> >From the perspective of the ref counting, the best way is calling
> idr_remove in from sg_remove but as you said, it's not nice to change
> the behavior.
>
>   
Exactly.
> If we don't use sg_get_device for /proc/scsi/sg/*, then we use
> sg_get_device for only sg_open So we can do 2) without changing the
> behavior.
>
>   
I will try to implement it this way today.  Thanks for your input.

Tony

