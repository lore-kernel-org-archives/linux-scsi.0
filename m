From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [BUGFIX 2/2] gdth: bugfix for the Timer at exit crash
Date: Wed, 13 Feb 2008 18:33:34 +0200
Message-ID: <47B31BDE.2030408@panasas.com>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com>	 <47B1D7A8.8010108@panasas.com>  <47B1DA2A.1060904@panasas.com> <1202917468.3109.5.camel@localhost.localdomain> <47B312B3.3010200@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:59331 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbYBMQfM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2008 11:35:12 -0500
In-Reply-To: <47B312B3.3010200@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: =?UTF-8?B?U3ZlbiBLw7ZobGVy?= <skoehler@upb.de>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, Joerg Dorchain <joerg@dorchain.net>, Jon Chelton <jchelton@ffpglobal.com>, Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>

On Wed, Feb 13 2008 at 17:54 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On Wed, Feb 13 2008 at 17:44 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>> On Tue, 2008-02-12 at 19:40 +0200, Boaz Harrosh wrote:
>>> -	gdth_flush(ha);
>>> -
>> This piece doesn't look right.  gdth_flush() forces the internal cache
>> to disk backing.  If you remove it, you're taking the chance that the
>> machine will be powered off without a writeback which can cause data
>> corruption.
>>
>> James
>>
> Yes. 
> I have more problems reported, with exit, and am just sending one more patch that puts
> this back in. Which was tested.
> 
> So I will resend this one plus one new one.
> 
> Boaz
> 

The gdth driver would do a register_reboot_notifier(&gdth_notifier);
to a gdth_halt() function, which would then redo half of what gdth_exit
does, and wrongly so, and crash.  

Are we guaranteed in todays kernel that modules .exit function be called
on an halt or reboot? If so then there is no need for duplications and
the gdth_halt() should go.

Submitted a patch that replaces the previous one I submitted with a deeper
fix. 
	[PATCH] gdth: bugfix for the at-exit problems

If you ask me this all gdth_flush() is a crackup. sd and scsi-ml are doing 
scsi FLUSH commands when ever is needed. The controller as no business caching
data in memory longer then what is stated in standard. Raid controller or no raid
controller. Virtual or not virtual device. Data on Plate means data on plate.
What if there is a power outage? what the driver can do then?

Boaz
