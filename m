From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [PATCH 03/28] libfc: IO errors on link down due to cable unplug
Date: Fri, 30 Jul 2010 13:34:10 -0700
Message-ID: <1280522050.25228.1252.camel@vi2.jf.intel.com>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
	 <20100720221920.17116.59505.stgit@localhost.localdomain>
	 <4C466986.5040801@cs.wisc.edu>
	 <1280266320.31061.2590.camel@vi2.jf.intel.com>
	 <4C4FDCF6.2070105@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:60411 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167Ab0G3UeL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jul 2010 16:34:11 -0400
In-Reply-To: <4C4FDCF6.2070105@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Robert Love <robert.w.love@intel.com>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, devel@open-fcoe.org

On Wed, 2010-07-28 at 02:32 -0500, Mike Christie wrote:
> On 07/27/2010 04:32 PM, Vasu Dev wrote:
> >> This isn't one of those races where you are blocking the rport, but the
> >> IO keeps coming around so the retries are used really quickly right (the
> >> driver looks like it has the fc class and internal state checks to
> >> prevent this but I wanted to make sure).
> >
> 
> I think I am hitting the above problem.
> 
> >
> > This tiny time windows can be further reduced by use of wmb() on rport
> > state change to block and lport getting out of ready since their states
> > are checked w/o lock in queuecommand path.
> 
> I think you need something like this for the lport queue ready check. 
> It looks like the initial failure from __fc_linkdown->fc_fcp_cleanup 
> burned a timeout. Then because it missed the lport ready check, it will 
> use an extra retry just sitting there timing out.
> 
> For the rport state check, I think you are supposed to call the fc 
> chkready function under the host lock. The port state and flags are set 
> under it. I did the attached patch for that.

I tried attached patch w/o this series and that didn't work and I got
same IO errors on link down. However once I included my next patch 4/28
related to IO error fix then attached patch worked w/o having this patch
under discussion, so attached patch works w/o this patch and I agree
rport needs to be checked under lock to get up-to-date correct rport
state checking in fc_queueucommand, so can you submit this patch ?

I'll submit another patch to replace added DID_REQUEUE here as this
series already applied to scsi-misc, I'll replace this by
DID_TRANSPORT_DISRUPTED since added DID_REQUEUE could be returned for
attempted tape IO as you pointed in other response and having
DID_TRANSPORT_DISRUPTED would be more meaningful code as lport is not
ready in this case to complete IOs.

Below is IO error log with attached patch w/o this series just after
ixgbe link goes down :-

[  452.168644] ixgbe: eth3 NIC Link is Down
[  452.180427] sd 5:0:0:2: [sdd] Done:
[  452.180436] sd 5:0:0:3: [sde] Done: RETRY
[  452.180441] sd 5:0:0:3: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK
[  452.180445] sd 5:0:0:3: [sde] CDB: Write(10): 2a 00 00 07 91 80 00 00
80 00
[  452.180464] sd 5:0:0:1: [sdc] Done: RETRY
[  452.180467] sd 5:0:0:1: [sdc] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK
[  452.180469] sd 5:0:0:1: [sdc] CDB: Write(10): 2a 00 00 07 cf 00 00 00
80 00
[  452.181792] RETRY
[  452.181963] sd 5:0:0:2: [sdd] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK
[  452.182241] sd 5:0:0:2: [sdd] CDB: Write(10): 2a 00 00 07 ac 00 00 00
80 00
[  452.183294] sd 5:0:0:2: [sdd] Done:
[  452.183326] sd 5:0:0:0: [sdb] Done: RETRY
[  452.183329] sd 5:0:0:0: [sdb] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK
[  452.183332] sd 5:0:0:0: [sdb] CDB: Write(10): 2a 00 00 07 99 00 00 00
80 00
[  452.184089] RETRY
[  452.184262] sd 5:0:0:2: [sdd] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK
[  452.184514] sd 5:0:0:2: [sdd] CDB: Write(10): 2a 00 00 07 ac 00 00 00
80 00
[  452.185557] sd 5:0:0:2: [sdd] Done: RETRY
[  452.185798] sd 5:0:0:2: [sdd] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK
[  452.186050] sd 5:0:0:2: [sdd] CDB: Write(10): 2a 00 00 07 ac 00 00 00
80 00
[  452.187101] sd 5:0:0:2: [sdd] Done: RETRY
[  452.187373] sd 5:0:0:2: [sdd] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK
[  452.187633] sd 5:0:0:2: [sdd] CDB: Write(10): 2a 00 00 07 ac 00 00 00
80 00
[  452.188691] sd 5:0:0:2: [sdd] Done: RETRY
[  452.188932] sd 5:0:0:2: [sdd] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK[  452.189184] sd 5:0:0:2: [sdd] CDB: Write(10): 2a
00 00 07 ac 00 00 00 80 00
[  452.190499] sd 5:0:0:2: [sdd] Done: SUCCESS
[  452.190748] sd 5:0:0:2: [sdd] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK
[  452.190999] sd 5:0:0:2: [sdd] CDB: Write(10): 2a 00 00 07 ac 00 00 00
80 00
[  452.192033] sd 5:0:0:2: [sdd] Unhandled error code
[  452.192244] sd 5:0:0:2: [sdd] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK
[  452.192495] sd 5:0:0:2: [sdd] CDB: Write(10): 2a 00 00 07 ac 00 00 00
80 00
[  452.193526] end_request: I/O error, dev sdd, sector 502784
[  452.193820] host5: libfc: Link down on port (050b01)
[  452.194006] sd 5:0:0:3: [sde] Done: RETRY
[  452.194262] sd 5:0:0:3: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK
[  452.194507] sd 5:0:0:3: [sde] CDB: Write(10): 2a 00 00 07 91 80 00 00
80 00
[  452.195525] sd 5:0:0:1: [sdc] Done: RETRY
[  452.195790] sd 5:0:0:1: [sdc] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK
[  452.196033] sd 5:0:0:1: [sdc] CDB: Write(10): 2a 00 00 07 cf 00 00 00
80 00
[  452.197076] sd 5:0:0:0: [sdb] Done: RETRY
[  452.197354] sd 5:0:0:0: [sdb] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK
[  452.197620] sd 5:0:0:0: [sdb] CDB: Write(10): 2a 00 00 07 99 00 00 00
80 00
[  459.476688] ixgbe: eth3 NIC Link is Up 10 Gbps, Flow Control: None
[  464.287400] host5: libfc: Link up on port (050b01)
[  466.304340] libfcoe: host5: FIP selected Fibre-Channel Forwarder MAC
00:05:1e:d8:2f:03


	In above log, IO error occurred even before libfc could start acting on
link down at [452.193820] to block rports but once rport blocked your
attached patch helps as I said above.

	Thanks
	Vasu









