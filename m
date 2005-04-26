From: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Subject: Re: [ANNOUNCE] iscsi-initiator-core 1.6.2.0-rc1 for 2.6.12-rc1
Date: Mon, 25 Apr 2005 17:00:45 -0700
Message-ID: <1114473645.5157.19.camel@haakon>
References: <1112385701.3008.18.camel@haakon>
	 <1114310956.4805.9.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp817.mail.sc5.yahoo.com ([66.163.170.3]:40324 "HELO
	smtp817.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S261228AbVDZAKG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2005 20:10:06 -0400
In-Reply-To: <1114310956.4805.9.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: iscsi-initiator-core-announce@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, iscsi-initiator-core-devel <iscsi-initiator-core-devel@iscsi-initiator-core.org>, Christoph Hellwig <hch@lst.de>, Mike Christie <mikenc@us.ibm.com>

On Sat, 2005-04-23 at 21:49 -0500, James Bottomley wrote:
> OK, I assessed this for inclusion.
> 
> The feedback I had based on my last review was
> 
> 1) Use the iscsi transport class.

Ok, this is something that I will work on against 2.6.12-rc3 tonight.
My primary concern is the parameters that are currently defined as
session wide when they are specific to only an connection context:

1) HeaderDigest & DataDigest
2) IP/Port
3) IFMarker, OFMarker, OFMarkInt and IFMarkInt.

My primary concern is that this will cause breakage between the current
linux-iscsi implementation and what correct parameter contexts that are
defined by RFC 3720.  These are used in the correct contexts in
drivers/scsi/iscsi_initiator_core/iscsi_initiator_sysfs.c, and I will
look into seeing how the correct map to what scsi_transport_iscsi.c
currently provides without breaking linux-iscsi, and without causing too
much changes within iscsi-initiator-core.

Aside from the parameter bits, is there anything else that can go into
scsi_transport_iscsi.c that can be shared?  What about
scsi_internal_device_block() and scsi_internal_device_unblock()?  Is
there anything else?

> 2) get rid of MC/S in favour of dm-multipath.

Is it acceptable to disable MC/S in the short term?  I am concerned that
removing something as basic as MC/S will cause other issues that can
potentially cause stability problems.  I have no issues with removing
this feature but would prefer it be done after this stable release.

> 3) Don't try to subvert the SCSI error handler
> 
> Point 3) is much better, but still present in this:
> 
> +	/*
> +	 * This is completion of a given struct scsi_cmnd after an
> +	 * iSCSI exception occured.  Based upon iSCSI exceptions and/or
> +	 * passed action parameter, struct scsi_cmnd->eh_timeout may have
> +	 * been stopped, and needs to be rstarted before completion to
> +	 * the SCSI stack.
> +	 */
> +	if (!(timer_pending(&sc->eh_timeout))) {
> +		sc->eh_timeout.data = (unsigned long) sc;
> +		sc->eh_timeout.expires = (jiffies + sc->timeout_per_command);
> +		sc->eh_timeout.function = scsi_timeout_function;
> +		add_timer(&sc->eh_timeout);
> 

Ok, I think I may have missed this one when I was removing the
eh_timeout bits.  I need to double check that there is no possibility of
the timer being expired at this point.

> However the other two still have not been addressed, so this patch is
> not suitable for inclusion.
> 

I will keep working towards your requests, thanks again your
consideration!


-- 
Nicholas A. Bellinger <nick@pyxtechnologies.com>

