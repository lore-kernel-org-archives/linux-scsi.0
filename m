From: j+scsi@howard.fm
Subject: ips.c bounce buffer problems
Date: Mon, 20 Jan 2003 17:20:49 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030120062049.BED63428DA@server2.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI mailing list <linux-scsi@vger.kernel.org>
Cc: "Peter Wong (IBM)" <wpeter@us.ibm.com>, "Sandra Johnson (IBM)" <sandraja@us.ibm.com>, Rob Mueller <robm@fastmail.fm>

Hi all,

I've been trying to improve the performance of the ips.c driver in
2.4.20, along with other general IO improvements. The IBM guys have done
some work on this in the Sourceforge LSE project, but it's all for old
kernels and none of the patches apply cleanly.

For starters, I'd like to turn on highmem_io in ips.h. In doing so I
always get a kernel error dereferencing an invalid pointer when trying to
load the SCSI subsystem. Details:
 - IBM x235 6GB RAM
 - ServeRaid 5i
 - Linux 2.4.20 standard tree and -aa trees tested
 - Config PAE mode to utilise >4GB RAM

Now, ips.h doesn't define highmem_io, and in looking over the archives I
see some attempts to get this included:
  http://www.uwsg.iu.edu/hypermail/linux/kernel/0202.2/0311.html

The ips.c in 2.4.20 includes the VIRT_TO_BUS patches from there, but it
doesn't include:
+ pci_set_dma_mask(dev[i], (u64) 0xffffffff);
+
+ scsi_set_pci_device(sh, dev[i]); 

It also never apparently calls pci_unmap_sg(), even although that was in
the patch sent to LKML.

Adding these two things in doesn't fix the kernel error I mentioned.

Has anyone got highmem_io working with ips.c in 2.4.20? Any pointers to
patches?

Also, Peter Wong (cc'd) reports good results with Jonathan Lahr's
io_request_lock patch:
http://groups.google.com/groups?selm=OFE708D02D.C1935D57-ON85256C1D.006DDF9E%40pok.ibm.com

The version of this at http://www.sf.net/projects/lse does not compile
cleanly under 2.4.20 and the code has changed enough that I can't work
out how to integrate it.

Has anyone got this patch integrated with 2.4.20?

In general, can anyone provide tips on getting good performance from
ServeRaid 5i under Linux 2.4.20?

TIA,
  Jeremy
  http://FastMail.FM
