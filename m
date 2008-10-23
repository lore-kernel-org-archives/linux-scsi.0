From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Possible bug in SCSI Kconfig
Date: Thu, 23 Oct 2008 19:30:33 +0200
Message-ID: <4900B4B9.4050103@s5r6.in-berlin.de>
References: <b637ec0b0810220929r2c889423ma92bef0ec7f9b3b0@mail.gmail.com>	 <1224702340.6851.20.camel@localhost.localdomain>	 <b637ec0b0810221225q589ed071i75f559d6fa76d96b@mail.gmail.com> <1224704659.6851.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:42174 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbYJWRaw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Oct 2008 13:30:52 -0400
In-Reply-To: <1224704659.6851.28.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Fabio Comolli <fabio.comolli@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, sam@ravnborg.org, linux-scsi <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>

James Bottomley wrote:
> On Wed, 2008-10-22 at 21:25 +0200, Fabio Comolli wrote:
>> But in my case I have SCSI enabled only because it's SELECTed by ATA
>> (it's just a laptop) and I don't have any hba's and never will. So no
>> async scan.
> 
> Presumably you have a laptop hard disk.  That's currently SCSI if you
> use ATA ... although when ATA moves out of SCSI it will no longer be, so
> you could regard this as a temporary condition.

What USB storage?  And more.

>> Maybe this module should be enabled if async scan is.
> 
> But that's the point: async scan is always "enabled" it just might not
> be the default, that's what the CONFIG_SCSI_SCAN_ASYNC controls: the
> default value (but you can always turn it on with the kernel boot or
> SCSI module option).  Async scan is also functional for /drivers/ata and
> other hot plug type busses, so it still makes sense for them as well.
...
> Well, we do use CONFIG_MODULES to try to discern whether the user wants
> modules or not.  However, if you enable modules, we'd need some
> telepathic configurator to tell us if you plan to use SCSI HBA modules
> or not, so the safest course is always to enable it.  The real point is
> that you have to be a real power user to answer N correctly to this, so
> it's better not to confuse the remaining 97% with the option because
> they could easily get wrong ...

Is it remotely possible that SCSI_WAIT_SCAN could depend on or be 
selected by transports which actually cooperate with scsi_wait_scan?

Also remember:
   - Writing "Depending your initrd, this module may be necessary for
     the system to boot up." and "If unsure, say M." in the Kconfig help
     text is always an option.
   - I haven't built an initrd since ages, but I presume that initrd
     build scripts will complain if an expected module is missing.
   - scsi_wait_scan is a special method to wait for devices during boot
     which only works with some hardware types.  More general methods are
     available and have been in use far longer than scsi_wait_scan
     exists.  Nobody fundamentally needs scsi_wait_scan, it is only a
     convenient tool for some users who choose to use it.
     Special features are traditionally per default off in Kconfig and
     are supposed to be actively enabled.

The sentence "this module may be necessary for the system to boot up" is 
actually applicable to a myriad of options which have a prompt and 
default to off.  The only difference is that most of these options are 
easier to explain.  And that's what it boils down to:  You omitted the 
prompt because you felt it was too hard to explain.

> the 3% who're sure they don't want it can simply delete it.

Yeah, or remove the line from .config, or... change scsi/Kconfig to get 
a prompt.
-- 
Stefan Richter
-=====-==--- =-=- =-===
http://arcgraph.de/sr/
