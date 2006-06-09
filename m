From: James Smart <James.Smart@Emulex.Com>
Subject: Re: fc transport creates second set of targets for devices in an
 "md"
Date: Fri, 09 Jun 2006 15:52:57 -0400
Message-ID: <4489D199.5020609@emulex.com>
References: <448876C8.3090303@sgi.com> <4488864E.2000009@cs.wisc.edu> <4489A34C.8040007@sgi.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:20375 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030443AbWFITx0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jun 2006 15:53:26 -0400
In-Reply-To: <4489A34C.8040007@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jim Nead <jnead@sgi.com>, James Bottomley <James.Bottomley@SteelEye.com>

Michael Reed wrote:
>> Even if the rport is removed and the devices under it are removed, md
>> can still have a reference to the device so the memory does not
>> disappear on it (MD still thinks the device is there but scsi says it is
>> gone basically). Because of this, when you plug in the cable again and a
>> new rport is created sd.c can end up allocating another sdX value.
>>
> 
> So, how about a callback to the driver, md, with the reference so that it
> can release said reference?

Mike C summarized the issue well. Callback - ugh. The real wish-list fix is to
make the midlayer reuse the old structures if the device comes back. Makes my
eyes bug out though to figure out this could be done. This would also solve
the race we saw in sysfs for recreation of the node while it was still outstanding
due to a reference (name collision).

-- james

