From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] sysfs: add filter function to groups
Date: Wed, 31 Oct 2007 10:52:35 +0100
Message-ID: <47285063.1040508@s5r6.in-berlin.de>
References: <1193671019.3383.13.camel@localhost.localdomain>	<1193676852.2655.21.camel@lov.site>	<1193677071.3383.56.camel@localhost.localdomain>	<47261F50.3050901@s5r6.in-berlin.de>	<1193768743.3321.91.camel@localhost.localdomain>	<20071031035506.GH14910@kroah.com> <20071031104103.13e07d8f@gondolin.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:52249 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbXJaJwm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 05:52:42 -0400
In-Reply-To: <20071031104103.13e07d8f@gondolin.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@SteelEye.com>, Kay Sievers <kay.sievers@vrfy.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Cornelia Huck wrote:
> Greg KH <greg@kroah.com> wrote:
>> On Tue, Oct 30, 2007 at 01:25:43PM -0500, James Bottomley wrote:
>>> +	for (i = 0, attr = grp->attrs; *attr; i++, attr++)
>>> +		if (grp->is_visible &&
>>> +		    grp->is_visible(kobj, *attr, i))
>>> +			sysfs_hash_and_remove(dir_sd, (*attr)->name);
>> Hm, doesn't this break for the zillions of attribute groups that do not
>> have the is_visible function set?
...
> Would it make more sense then to turn the meaning of the callback
> around?
> 
> for (...) {
> 	if (grp->mask_out && grp->mask_out(kobj, *attr, i))
> 		continue;
> 	error |= sysfs_add_file(...);
> }

		if (!grp->is_visible ||
		    grp->is_visible(kobj, *attr, i))
			add or remove();

-- 
Stefan Richter
-=====-=-=== =-=- =====
http://arcgraph.de/sr/
