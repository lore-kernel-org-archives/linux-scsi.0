From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: Fusion-MPT much faster as module
Date: Mon, 21 Mar 2005 16:46:44 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C01AEAC93@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Received: from mail0.lsil.com ([147.145.40.20]:20717 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262195AbVCUXrE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2005 18:47:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Holger Kiehl <Holger.Kiehl@dwd.de>, augustus@linuxhardware.org
Cc: linux-scsi@vger.kernel.org

Sorry for delay in responding.
We at LSI Logic are looking into these reports
of poor performance coming from the U320.
I will report later.

Eric Moore
LSI Logic


On Monday, March 21, 2005 4:27 PM, Andrew Morton wrote:
> 
> 
> Holger Kiehl <Holger.Kiehl@dwd.de> wrote:
> >
> > Hello
> > 
> > On a four CPU Opteron compiling the Fusion-MPT as module 
> gives much better
> > performance when compiling it in, here some bonnie++ results:
> > 
> > Version  1.03       ------Sequential Output------ 
> --Sequential Input- --Random-
> >                      -Per Chr- --Block-- -Rewrite- -Per 
> Chr- --Block-- --Seeks--
> > Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
> K/sec %CP  /sec %CP
> > compiled in  15872M 38366 71  65602  22 18348   4 53276 84  
> 57947   7 905.4   2
> > module       15872M 51246 96 204914  70 57236  14 59779 96 
> 264171  33 923.0   2
> > 
> > This happens with 2.6.10, 2.6.11 and 2.6.11-bk2. Controller is a
> > Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI.
> > 
> > Why is there such a large difference?
> > 
> 
> Holger, this problem remains unresolved, does it not?  Have 
> you done any
> more experimentation?
> 
> I must say that something funny seems to be happening here.  
> I have two
> MPT-based Dell machines, neither of which is using a modular driver:
> 
> 
> akpm:/usr/src/25> 0 hdparm -t /dev/sda
> 
> /dev/sda:
>  Timing buffered disk reads:  64 MB in  5.00 seconds = 12.80 MB/sec
> 
> That's a bit disappointing.  Running 2.6.9-rc2-mm2(!) with a
> 
>  SCSI storage controller: LSI Logic / Symbios Logic 53c1030 (rev 07)
> 
> controller on disks which shudl hit 50MB/sec.
> 
> 
> 
> 
> And
> 
> bix:/home/akpm# hdparm -t /dev/sda
> 
> /dev/sda:
>  Timing buffered disk reads:  114 MB in  3.03 seconds =  37.57 MB/sec
> 
> with 2.6.11-rc4-mm1 using
> 
> Fusion MPT SCSI Host driver 3.01.16
> scsi0 : ioc0: LSI53C1030, FwRev=01030600h, Ports=1, MaxQ=222, IRQ=25
> scsi1 : ioc1: LSI53C1030, FwRev=01030600h, Ports=1, MaxQ=222, IRQ=26
> Vendor: SEAGATE   Model: ST3146807LW       Rev: DS09
> Type:   Direct-Access                      ANSI SCSI revision: 03
> 
> Better, but again I'd expect >50MB/sec.
> 
