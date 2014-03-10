From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/5] ses: Use vpd information from scsi_device
Date: Mon, 10 Mar 2014 21:44:30 +0100
Message-ID: <531E242E.60806@suse.de>
References: <1394461725-76203-1-git-send-email-hare@suse.de>	 <1394461725-76203-6-git-send-email-hare@suse.de> <1394475625.2565.42.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38650 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbaCJSlb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Mar 2014 14:41:31 -0400
In-Reply-To: <1394475625.2565.42.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>, "hch@infradead.org" <hch@infradead.org>

On 03/10/2014 07:20 PM, James Bottomley wrote:
> On Mon, 2014-03-10 at 15:28 +0100, Hannes Reinecke wrote:
>> The scsi_device now has VPD page83 information attached, so
>> there is no need to query it again.
>
> This is a bit new for a v8 patch, have you actually tested it?  I'm
> asking because it looks to me like the vpd attach is done just before
> the configure whereas the bindings are usually done in add.  I suspec=
t
> this will work for ses because it's a device model binding rather tha=
n a
> transport class binding and the former occurs later, but knowing it
> actually all works would be useful.
>
Yes, correct. But the device_add() call is done in
scsi_sysfs_add_sdev(), which is done at the end of scsi_add_lun().
So that will be okay.

But nevertheless I'll be cross-checking.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
