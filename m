From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH] isci: filter broadcast change notifications during
 SMP phy resets
Date: Mon, 27 Jun 2011 09:27:06 -0700
Message-ID: <BANLkTi=aSXVQ+vjOn0okojabnHaL0NbiCg@mail.gmail.com>
References: <20110624194109.26706.58553.stgit@localhost6.localdomain6>
	<4E0894EC.2010509@suse.de>
	<4E08A8FD.5080305@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46972 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab1F0Q1I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2011 12:27:08 -0400
Received: by iyb12 with SMTP id 12so4198637iyb.19
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2011 09:27:08 -0700 (PDT)
In-Reply-To: <4E08A8FD.5080305@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, dmilburn@redhat.com, jack_wang@usish.com, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, yuxiangl@marvell.com, hch@lst.de

On Mon, Jun 27, 2011 at 8:59 AM, Douglas Gilbert <dgilbert@interlog.com> wrote:
> On 11-06-27 10:34 AM, Hannes Reinecke wrote:
>>
>> On 06/24/2011 09:48 PM, Dan Williams wrote:
>>>
>>> From: Jeff Skirvin<jeffrey.d.skirvin@intel.com>
>>>
>>> When resetting a sata device in the domain we have seen occasions where
>>> libsas prematurely marks a device gone in the time it takes for the
>>> device to re-establish the link. This plays badly with software raid
>>> arrays. Other libsas drivers have non-uniform delays in their reset
>>> handlers to try to cover this condition, but not sufficient to close the
>>> hole. Given that a sata device can take many seconds to recover we
>>> filter bcns and poll for the device reattach state before notifying
>>> libsas that the port needs the domain to be rediscovered. Once this has
>>> been proven out at the lldd level we can think about uplevelling this
>>> feature to a common implementation in libsas.
>>>
>> That's the second time something like this have come up now.
>> Wouldn't it makes sense to implement something like the dev_loss_tmo
>> mechanism
>> with have for FC? That should cover this situation nicely ...
>
> "NOTE 112 - An STP initiator port should retry connection
> requests for at least the time indicated by the STP
> SMP I_T NEXUS LOSS TIME field in the SMP REPORT GENERAL
> response for the STP target port to which it is trying to
> establish a connection." [spl2r01.pdf 9.4.3.18 page 612]
>
> The recommended value for that field is 2000 (i.e. 2 seconds).
> So 2 seconds is not enough in some circumstances?

I believe we have seen longer, but the other concern is that the
scsi_eh kthread has no coupling with the libsas discovery thread (host
workqueue).  So, for example, the 2 second wait that mvsas performs in
mvs_debug_I_T_nexus_reset() (that I assume is for this purpose) does
not preclude bcns from being processed during that time.

--
Dan
