From: "K.R. Foley" <kr@cybsft.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Thu, 19 May 2005 20:05:19 -0500
Message-ID: <428D37CF.5070903@cybsft.com>
References: <20050516085832.GA9558@gmail.com>	 <20050517071307.GA4794@in.ibm.com> <20050517002908.005a9ba7.akpm@osdl.org>	 <1116340465.4989.2.camel@mulgrave> <20050517170824.GA3931@in.ibm.com>	 <1116354894.4989.42.camel@mulgrave> <428C030E.8030102@cybsft.com>	 <1116476630.5867.2.camel@mulgrave>  <20050519095143.GA3972@in.ibm.com> <1116546970.5037.137.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01.pair.com ([209.68.5.15]:31760 "HELO relay01.pair.com")
	by vger.kernel.org with SMTP id S261235AbVETBFU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 May 2005 21:05:20 -0400
In-Reply-To: <1116546970.5037.137.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, gregoire.favre@gmail.com, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Thu, 2005-05-19 at 15:21 +0530, Dinakar Guniguntala wrote:
> 
>>This doesn't seem to fix the problem :(
>>I tried both 2.6.12-rc4+patch and 2.6.4-rc4-mm1+patch
> 
> 
> Well ... great, it doesn't work for anyone, sigh.
> 
> OK, could you try this one (also against vanilla 2.6.12-rc4).  Hopefully
> it's a rollup of all the aic7xxx changes plus the necessary supporting
> infrastructure in my scsi-misc tree.
> 
> If it works, trying to get it into a patch set for Linus is going to be
> a right pain ...
> 
> James
> 
<snip>

James,

It does work with the exception that my u160 drive is still identified
as 80MB/s.


May 19 19:36:46 porky kernel: scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI
HBA DRIVER, Rev 6.2.36
May 19 19:36:46 porky kernel:         <Adaptec aic7899 Ultra160 SCSI
adapter>
May 19 19:36:46 porky kernel:         aic7899: Ultra160 Wide Channel A,
SCSI Id=7, 32/253 SCBs
May 19 19:36:46 porky kernel:
May 19 19:36:46 porky kernel:   Vendor: QUANTUM   Model:
ATLAS10K2-TY092L  Rev: DA40
May 19 19:36:46 porky kernel:   Type:   Direct-Access
   ANSI SCSI revision: 03
May 19 19:36:46 porky kernel: scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
May 19 19:36:46 porky kernel:  target0:0:0: Beginning Domain Validation
May 19 19:36:46 porky kernel: WIDTH IS 1
May 19 19:36:46 porky kernel: (scsi0:A:0): 6.600MB/s transfers (16bit)
May 19 19:36:46 porky kernel: (scsi0:A:0): 80.000MB/s transfers
(40.000MHz, offset 127, 16bit)
May 19 19:36:46 porky kernel:  target0:0:0: Ending Domain Validation
May 19 19:36:46 porky kernel: scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI
HBA DRIVER, Rev 6.2.36
May 19 19:36:46 porky kernel:         <Adaptec aic7899 Ultra160 SCSI
adapter>
May 19 19:36:46 porky kernel:         aic7899: Ultra160 Wide Channel B,
SCSI Id=7, 32/253 SCBs
May 19 19:36:46 porky kernel:
May 19 19:36:46 porky kernel:   Vendor: SEAGATE   Model: SX118273LC
   Rev: 6679
May 19 19:36:46 porky kernel:   Type:   Direct-Access
   ANSI SCSI revision: 02
May 19 19:36:46 porky kernel: scsi1:A:0:0: Tagged Queuing enabled.  Depth 32
May 19 19:36:46 porky kernel:  target1:0:0: Beginning Domain Validation
May 19 19:36:46 porky kernel:  target1:0:0: Domain Validation skipping
write tests
May 19 19:36:46 porky kernel: (scsi1:A:0): 20.000MB/s transfers
(20.000MHz, offset 15)
May 19 19:36:46 porky kernel:  target1:0:0: Ending Domain Validation
May 19 19:36:46 porky kernel: SCSI device sda: 17783239 512-byte hdwr
sectors (9105 MB)
May 19 19:36:46 porky kernel: SCSI device sda: drive cache: write back
May 19 19:36:46 porky kernel: SCSI device sda: 17783239 512-byte hdwr
sectors (9105 MB)
May 19 19:36:46 porky kernel: SCSI device sda: drive cache: write back
May 19 19:36:46 porky kernel:  sda: sda1 sda2 sda3
May 19 19:36:46 porky kernel: Attached scsi disk sda at scsi0, channel
0, id 0, lun 0
May 19 19:36:46 porky kernel: SCSI device sdb: 35566480 512-byte hdwr
sectors (18210 MB)
May 19 19:36:46 porky kernel: SCSI device sdb: drive cache: write through
May 19 19:36:46 porky kernel: SCSI device sdb: 35566480 512-byte hdwr
sectors (18210 MB)
May 19 19:36:46 porky kernel: SCSI device sdb: drive cache: write through
May 19 14:36:26 porky rc.sysinit: -e
May 19 19:36:46 porky kernel:  sdb: sdb1
May 19 14:36:28 porky udevsend[1227]: starting udevd daemon
May 19 19:36:46 porky kernel: Attached scsi disk sdb at scsi1, channel
0, id 0, lun 0
May 19 14:36:28 porky scsi.agent[1239]: disk at
/devices/pci0000:00/0000:00:1e.0/0000:04:05.0/host0/target0:0:0/0:0:0:0
May 19 19:36:46 porky kernel: Attached scsi generic sg0 at scsi0,
channel 0, id 0, lun 0,  type 0
May 19 14:36:28 porky scsi.agent[1264]: disk at
/devices/pci0000:00/0000:00:1e.0/0000:04:05.1/host1/target1:0:0/1:0:0:0
May 19 19:36:46 porky kernel: Attached scsi generic sg1 at scsi1,
channel 0, id 0, lun 0,  type 0



-- 
   kr
