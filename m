From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC]: 64 bit LUN/Tags, dummy device in host_queue, host_lock <->
 LLDD reentrancy
Date: Mon, 26 Aug 2002 09:11:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200208261411.g7QEBGS30369@localhost.localdomain>
References: <ARZEH@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA22719
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2002 07:11:31 -0700
In-Reply-To: Message from "Aron Zeh" <ARZEH@de.ibm.com>
   of "Mon, 26 Aug 2002 10:02:47 +0200." <OF80DCCDBC.5B147AD9-ONC1256C21.002BB3EE@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Aron Zeh <ARZEH@de.ibm.com>
Cc: Luben Tuikov <luben@splentec.com>, linux-scsi <linux-scsi@vger.kernel.org>

ARZEH@de.ibm.com said:
> To me all of the proposed changes look good. The one above I'd be
> interested in particularly. It would help sorting out a lot of woes we
> had with writing a fibre-channel HBA driver. For fibre-channel LUNs
> and port IDs (WWPN) are 64-bit and depending on configuration, high
> values can be (and in our case are) common. 

Actually, I'd like to see us moving towards adopting the capabilities of 
driverfs for this.

PUN is to all intents and purposes now an abstraction in the FC realm.  LUNs 
too, as long as they retain the grouping abstraction with PUNs.  The mid layer 
really doesn't need to know what these are (there are a few pieces of code 
that populate the LUN field for SCSI-1 devices that would need rework).  All 
the mid layer really needs is the Scsi_Device structure that describes an 
individual LUN (and some knowledge of LUN and PUN grouping for reset action 
prediction).  It doesn't need to know or care about the current PUN and LUN 
numbers.

If FC drivers move straight to using driverfs, you can populate the driverfs 
names with whatever is meaningful to you for PUN (WWN, portid etch) and LUN 
and thus avoid this problem (and also the mapping code most have to take these 
to and from the PUN/LUN numbers).  Since driverfs is a tree, the PUN/LUN 
division is done in a directory (and could, theoretically be done on more than 
just a two level split).

James


