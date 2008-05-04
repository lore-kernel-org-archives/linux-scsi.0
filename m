From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: SCSI target subsystem
Date: Sun, 04 May 2008 19:23:06 +0400
Message-ID: <481DD4DA.9080404@vlnb.net>
References: <200805021638.42972.bart.vanassche@gmail.com>	 <20080502153306.GB7376@infradead.org>	 <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com>	 <20080502155525.GA16353@infradead.org>	 <e2e108260805020906w7f5e92bev46b8d0f96aa7b4d6@mail.gmail.com> <1209745084.3121.39.camel@localhost.localdomain> <481B5AB8.5030108@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:35709 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751654AbYEDPWq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2008 11:22:46 -0400
In-Reply-To: <481B5AB8.5030108@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

Vladislav Bolkhovitin wrote:
> James Bottomley wrote:
>> On Fri, 2008-05-02 at 18:06 +0200, Bart Van Assche wrote:
>>> James Bottomley clearly expressed in that thread that he doesn't want
>>> to maintain two SCSI target frameworks. So what I propose is that SCST
>>> is included in the mainline and afterwards that it is evaluated
>>> whether or not it is desirable to keep other target code in the
>>> mainline kernel.
>> That's hardly sufficient.  STGT is already in use.  Their either has to
>> be a migration path or, the preferred option, take the pieces of SCST
>> that are actual improvements and embed them in STGT.
> 
> Actually, between SCSI initiator and target subsystems there is almost 
> *nothing* in common. This claim, at first glance, looks pretty wrong, 
> because both serve SCSI, so they must have a lot common. But look deeper 
> and you quickly find out that the majority of functionality as well as 
> data they use are dedicated for each subsystem, not shared.
> 
> Just look at SCST/qla2x00t/(changes done in the initiator qla2xxx driver 
> to support target mode, patch attached): 90% of changes is adding 
> callbacks for external target add-on, the rest is support for older, 
> than 2.6.17, kernels and sysfs magic. Note, no data are common between 
> initiator and target parts in the meaning that they both use them.

Perhaps, I should elaborate more on this to eliminate possible 
misunderstanding. Of course, both main initiator driver and target 
add-on driver directly use the same hardware, so they share all internal 
hardware-related data, e.g. hardware_lock, but this doesn't matter for 
our topic, because this sharing is on the different level. All such data 
are hardware specific, hence different hardware have different sets of 
such data, hence it is impractical to find something common in them to 
expose as a common interface, which all initiator drivers should expose 
to its target add-ons: the interface would be more complicated than 
direct implementation in each particular case.

> Then look at SCST (http://scst.sf.net). It implements complete 
> pass-through SCSI support and look how it interacts with initiator SCSI 
> subsystem. It calls only 2 functions: FIFO version of 
> scsi_execute_async() (original scsi_execute_async() provides 
> unacceptable LIFO commands order) and scsi_reset_provider() for task 
> management. And there is only one common variable: struct scsi_device. 
> That's all! In other storage modes (FILEIO/BLOCKIO) there is nothing 
> common with SCSI initiator subsystem at all.
> 
> Finally, try to find out in SCST any duplicated functionality.
> 
> Now, let's look how SCSI target/initiator integration currently done in 
> the kernel. For me it looks pretty artificial. For example, if I make a 
> general purpose kernel, for which 1% of users would run target mode, I 
> would have to enable as module "SCSI target support" as well as SCSI 
> target support for transport attributes. Now 99% of users of my kernel, 
> who don't need SCSI target, but need SCSI initiator drivers, would have 
> to have scsi_tgt loaded, because transport attribute drivers would 
> depend on it:
> 
> # lsmod
> Module                  Size  Used by
> qla2xxx               130844  0
> firmware_class          8064  1 qla2xxx
> scsi_transport_fc      40900  1 qla2xxx
> scsi_tgt               12196  1 scsi_transport_fc
> brd                     6924  0
> xfs                   511280  1
> dm_mirror              24368  0
> dm_mod                 51148  1 dm_mirror
> uhci_hcd               21400  0
> sg                     31784  0
> e1000                 114536  0
> pcspkr                  3328  0
> 
> No target functionality needed, but target mode subsystem is needed. Is 
> it a good design?
> 
> I wrote all above to support my at first glance shocking conclusion that 
> SCSI target subsystem is completely new subsystem of the kernel and it 
> should live on its own with its own maintainer! This is the same as with 
> the current interaction between SCSI and block subsystems in the kernel: 
> SCSI uses block's functionality, but that doesn't mean that block and 
> SCSI are the same subsystem.
> 
> Thus, how IMHO initiator and target drivers should be written:
> 
>   - All initiator drivers should live in the SCSI initiator subsystem 
> (aka current SCSI subsystem) only, the same as today.
> 
>   - All target drivers should live in the SCSI target subsystem only and 
> be either add-ons to initiator drivers, like, e.g., qla2x00t, or be a 
> complete driver, like, e.g., iSCSI-SCST.
> 
> Vlad
> 

