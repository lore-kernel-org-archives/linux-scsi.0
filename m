From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] 2.6.0 aic7xxx and aic79xx stale pci_device list entry
Date: Fri, 30 Jan 2004 08:03:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1787668112.1075475036@aslan.scsiguy.com>
References: <1073076654.2048.19.camel@opiate>	 <1073120514.4429.0.camel@laptop.fenrus.com>	
 <1282412704.1073168696@aslan.scsiguy.com>	 <20040104100448.GA2416@devserv.devel.redhat.com>	
 <2228980000.1075440305@aslan.btc.adaptec.com> <1075473710.4272.2.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aslan.scsiguy.com ([63.229.232.106]:46088 "EHLO
	aslan.scsiguy.com") by vger.kernel.org with ESMTP id S261406AbUA3PD5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2004 10:03:57 -0500
In-Reply-To: <1075473710.4272.2.camel@laptop.fenrus.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com
Cc: Eric Kerin <eric@bootseg.com>, linux-scsi@vger.kernel.org

>> Well, if you look at the Adaptec drivers, they already attach to all
>> possible IDs for the chips that are supported.  They do this by registering
>> a very generic PCI ID table and filtering all requests through their
>> own tables.  
> 
> May I ask why this is done?

Because creating a specific table for Linux would duplicate the more generic
probing mechanism that already exists for this purpose in the driver core
which is shared amongst all supported OSes.  Code duplication equals bugs in
my opinion.  This also allows the driver to attach generically to any
chip that it can support.  The Linux probe mechanisms does not allow
this without user intervention (and I wasn't even aware this was possible
until you told me).  I would probably need a 500+ entry table to be able
to attach to all of the possible IDs that an OEM could decide to use when
they put Adaptec Silicon on their MB.

> It sounds not the right thing that needs all
> kinds of special cases in the OS userland...

I don't know why the userland would care.  Just because a driver's
PCI probe routine is called does not mean that it must accept the
device.  I have never encountered any problems with the approach after
three years of using it.

--
Justin

