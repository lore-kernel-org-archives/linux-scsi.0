From: Luben Tuikov <luben@splentec.com>
Subject: Re: [RFC]: 64 bit LUN/Tags, dummy device in host_queue, host_lock <->
 LLDD reentrancy
Date: Mon, 26 Aug 2002 16:48:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D6A9439.F713A042@splentec.com>
References: <OF80DCCDBC.5B147AD9-ONC1256C21.002BB3EE@de.ibm.com> <20020826101748.B6694@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g7QKmsH08312
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2002 16:48:54 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Patrick Mansfield wrote:
>
> If we are to add an 8 byte LUN:
> 
> We still need to allow a smaller lun for all of the current open source
> adapter drivers (AFAIK all open source drivers except the qlogic drivers
> use a one byte lun, and the qlogic uses a two byte lun) - either a field
> in Scsi_Device and/or Scsi_Cmnd, or a functional interface to get the
> equivalent four byte value (and then it can be assigned to a one or two
> byte value as is done today) in addition to any new 8 byte lun field.

For transition purposes, yes.

But, ideally, the LUN should be a function of the LLDD, since
it is the _LLDD_ which knows (then maybe not) about the transport
used (FCP, SPI, etc).

The kernel shouldn't care if the transport uses 5 bits (SPI) or
64 bits (iSCSI) for LUN identification, it should use the SAM-3
definition of 64 bits.

> The Scsi_Host::max_lun usage would have to remain for the old four byte

Certainly one can limit the scan, but we no more can enumerate it so
simply as it was done before.

There may be only 6 LU, with addresses scattered in the 64 bit space,
only to tell us that the transport is iSCSI and the target is
actually 4 daisy-chained SANs. (or something like that, you guys get the idea)

LUNs should be picked up from the REPORT LUNS report data, in order to
discover all the LUNs currently available, just because of the large
but sparse LUN space.

-- 
Luben
