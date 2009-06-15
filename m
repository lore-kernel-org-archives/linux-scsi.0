From: Mike Christie <michaelc@cs.wisc.edu>
Subject: =?windows-1252?Q?Re=3A_-git_tree_build_failure_=232=3A?=
 =?windows-1252?Q?_drivers/net/cnic=2Ec=3A2520=3A_error=3A_implicit?=
 =?windows-1252?Q?_declaration_of_function_=91=5F=5Fsymbol=5Fget=92?=
Date: Sun, 14 Jun 2009 20:27:40 -0500
Message-ID: <4A35A38C.1050606@cs.wisc.edu>
References: <20090612184343.GA11900@elte.hu> <4A32A1E4.8080708@oracle.com>	 <20090613062933.GA14034@elte.hu>	 <alpine.LFD.2.01.0906131309560.3237@localhost.localdomain>	 <1244925747.5323.57.camel@mulgrave.site>  <1244940182.12000.5.camel@HP1> <1244943216.5323.86.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52432 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbZFOB2k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Jun 2009 21:28:40 -0400
In-Reply-To: <1244943216.5323.86.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Michael Chan <mchan@broadcom.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Sat, 2009-06-13 at 17:43 -0700, Michael Chan wrote:
>> On Sat, 2009-06-13 at 13:42 -0700, James Bottomley wrote:
>>> On Sat, 2009-06-13 at 13:11 -0700, Linus Torvalds wrote:
>>>>
>>>> That makes no sense. 
>>>>
>>>> Look at the first #include in the file - it already includes 
>>>> <linux/module.h>.
>>>>
>>>> Why do we need to do it twice?
>>> We don't ... it's the wrong fix.  The actual problem is that
>>> __symbol_get() is only defined for the modular case.  What it looks to
>>> be doing is a reflection call on bnx2_cnic_probe().  I'm not sure why
>>> it's doing this ... other than perhaps cnic wants to avoid an explicit
>>> bnx2 dependency?  I actually think it's incorrect, since the netdev code
>>> before it just checked bnx2 is present, so I see no harm in an explicit
>>> call, so this should fix it.
>>>
>>> If it had a good reason for the reflective call, then symbol_get()
>>> without the __ should be used.
>>>
>>> Michael Chan, could you confirm?
>>>
>> Thanks James and Ingo.  We don't want to have a symbol dependency on
>> bnx2 because this driver eventually will support the 10G bnx2x driver as
>> well.  So we want the driver to support either or both NIC drivers
>> without both drivers loaded.  Please use the patch below.
> 
> Um, but that's not going to work very well.  When you have your 10G
> driver, they'll both have to export the symbol name bnx2_cnic_probe
> which the kernel isn't going to like.  You can differentiate the symbols
> and add a multiple symbol lookup in init_bnx2_cnic(), but that's getting
> ugly.
> 
> What about doing something more standard, like bus matching?  That's how
> the SCSI upper layer drivers work:  we export a virtual SCSI bus and
> they bind to it if a supporting device appears.  You could do something
> similar exporting a virtual cnic bus from your network drivers and get
> the cnic driver to bind to it.
> 

Something like bus matching would be nice. I think this is going to be a 
bigger problem in the future with everyone putting as many functions on 
a card as possible. We already have the cxgb3 net driver with a iwarp 
(iw_cxgb3) and iscsi (cxgb3i) driver, so maybe something in the net or 
driver model code would be best?

Today, you can't have two pci_drivers attaching to the same device can you?
