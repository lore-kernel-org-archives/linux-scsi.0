From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [MINI SUMMIT] SCSI core performance
Date: Tue, 17 Jul 2012 19:39:50 -0700
Message-ID: <1342579190.18004.597.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: KS-2012-discuss <ksummit-2012-discuss@lists.linux-foundation.org>
Cc: Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <mail@hannes-reinecke.de>, Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi KS-PCs,

I'd like to propose a SCSI performance mini-summit to see how interested
folks are in helping address the long-term issues that SCSI core is
currently facing wrt to multi-lun per host and heavy small block random
I/O workloads.

I know this would probably be better suited for LSF (for the record it
was proposed this year) but now that we've acknowledge there is a
problem with SCSI LLDs vs. raw block drivers vs. other SCSI subsystems,
it would be useful to get the storage folks into a single room at some
point during KS/LPC to figure out what is actually going on with SCSI
core.

As mentioned in the recent tcm_vhost thread, there are a number of cases
where drivers/target/ code can demonstrate this limitation pretty
vividly now.

This includes the following scenarios using raw block flash export with
target_core_mod + target_core_iblock export and the same small block
(4k) mixed random I/O workload with fio:

*) tcm_loop local SCSI LLD performance is an order of magnitude slower 
   than the same local raw block flash backend.
*) tcm_qla2xxx performs better using MSFT Server hosts than Linux v3.x
   based hosts using 2x socket Nehalem hardware w/ PCI-e Gen2 HBAs
*) ib_srpt performs better using MSFT Server host than RHEL 6.x .32 
   based hosts using 2x socket Romley hardware w/ PCI-e Gen3 HCAs
*) Raw block IBLOCK export into KVM guest v3.5-rc w/ virtio-scsi is 
   behind in performance vs. raw local block flash.  (cmwq on the host 
   is helping here, but still need to with MSFT SCSI mini-port)

Also, with 1M IOPs into a single VM guest now being done by other non
Linux based hypervisors, the virtualization bit for high performance KVM
SCSI based storage is quickly coming on..

So all of that said, I'd like to at least have a discussion with the key
SCSI + block folks who will be present in San Diego on path forward to
address these without having to wait until LSF-2013 + hope for a topic
slot to materialize then.

Thank you for your consideration,

--nab
