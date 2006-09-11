From: mmzz@stat.unipd.it (Alberto Cammozzo)
Subject: Re: lp8000 and 2.6.18-rc6
Date: Mon, 11 Sep 2006 08:40:08 +0200
Message-ID: <20060911064008.GA26293@stat.unipd.it>
References: <20060909210856.GC21263@stat.unipd.it> <20060910135631.GD29775@parisc-linux.org> <20060910210444.GC22873@stat.unipd.it> <4504B6AF.3080909@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [147.162.35.208] ([147.162.35.208]:17305 "EHLO
	stavromula.stat.unipd.it") by vger.kernel.org with ESMTP
	id S1751214AbWIKGk3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Sep 2006 02:40:29 -0400
Received: from localhost (argabuthon.stat.unipd.it [147.162.35.209])
	by stavromula.stat.unipd.it (Postfix) with ESMTP id 65D1B1AF5752A
	for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2006 08:40:17 +0200 (CEST)
Received: from stavromula.stat.unipd.it ([147.162.35.208])
	by localhost (argabuthon.stat.unipd.it [147.162.35.209]) (amavisd-new, port 10024)
	with ESMTP id 00705-02 for <linux-scsi@vger.kernel.org>;
	Mon, 11 Sep 2006 08:40:08 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <4504B6AF.3080909@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Sun, Sep 10, 2006 at 09:06:55PM -0400, Douglas Gilbert wrote:
> Alberto Cammozzo wrote:
> > On Sun, Sep 10, 2006 at 07:56:31AM -0600, Matthew Wilcox wrote:
> >> On Sat, Sep 09, 2006 at 11:08:56PM +0200, Alberto Cammozzo wrote:
> >>> It's the first time I use this setup... Am I missing something?
> >>>
> >>> lsmod:
> >>> Module                  Size  Used by
> >>> lpfc                  145600  0 
> >>> scsi_transport_fc      25568  1 lpfc
> >>> iscsi_tcp              19808  1 
> >>> libiscsi               17504  1 iscsi_tcp
> >>> scsi_transport_iscsi    23244  3 iscsi_tcp,libiscsi
> >>> skge                   31312  0 
> >>> [...]
> >> does the [...] include sd_mod (or sd?  i forget what it's called)
> > 
> > 
> > 	Thank you Matthew,
> > 
> > 	I suppose you mean sd, scsi disk support. Yes, it is _statically_ 
> > 	included in kernel.
> > 	Another hint: if I "modprobe sg" (scsi generic), a bunch of new sg disks
> > 	show up in dmesg, including those from lpfc.
> > 	I noticed they are recognised as an undefined "scsi" device and not as 
> > 	"sd" (disks) or "st" (tapes) as other devices present in the same system,
> > 	(see channel 7 in attached log).
> > 
> > st 0:0:5:0: Attached scsi generic sg0 type 1
> > ch 0:0:5:1: Attached scsi generic sg1 type 8
> > sd 1:0:0:0: Attached scsi generic sg2 type 0
> > scsi 1:0:15:0: Attached scsi generic sg3 type 3
> > scsi 1:1:9:0: Attached scsi generic sg4 type 3
> > scsi 1:2:8:0: Attached scsi generic sg5 type 3
> 
> Alberto,
> Peripheral device type 3 is "processor" type. It is
> often used for SAF-TE targets. These are enclosure
> services processors, here is a tool to look at them:
>   http://oss.metaparadigm.com/safte-monitor


	Thank you Douglas,

	here's the output of safte-monitor -p (one-shot)
	It shows the serveraid stuff, but it seems to me 
	that the clariion isn't there, 
		

Found 2 SAF-TE devices
SAF-TE Device IBM 25P3471a S320  2 (1:1:9:0)
no. of fans           = 0
no. of power supplies = 0
no. of device slots   = 3
door lock installed   = 0
no. of temp sensors   = 0
audible alarm         = 0
no. of thermostats    = 128
device slot 0 disk present,no error
device slot 1 disk not present,no error
device slot 2 disk not present,no error
overall temperature is okay

SAF-TE Device IBM 02R0962a S320  1 (1:2:8:0)
no. of fans           = 0
no. of power supplies = 0
no. of device slots   = 6
door lock installed   = 0
no. of temp sensors   = 0
audible alarm         = 0
no. of thermostats    = 128
device slot 0 disk present,no error
device slot 1 disk not present,no error
device slot 2 disk not present,no error
device slot 3 disk not present,no error
device slot 4 disk not present,no error
device slot 5 disk not present,no error
overall temperature is okay



> > scsi 7:0:1:0: Attached scsi generic sg6 type 0
> > scsi 7:0:3:0: Attached scsi generic sg7 type 0
> > sd 8:0:0:0: Attached scsi generic sg8 type 0
> > scsi 7:0:0:0: Attached scsi generic sg9 type 0
> > scsi 7:0:2:0: Attached scsi generic sg10 type 0
> 
> Type 0 is for disks, strange that sd didn't pick up
> those devices on host 7. Could you fetch the sg3_utils
> package, build it and try 'sg_inq /dev/sg6'. The output
> may be interesting.


sg_inq /dev/sg6
standard INQUIRY:
  PQual=1  Device_type=0  RMB=0  [ANSI_version=4]  version=0x04
  [AERC=0]  [TrmTsk=0]  NormACA=1  HiSUP=1  Resp_data_format=2
  SCCS=0  ACC=0  TGPS=0  3PC=0  Protect=0
  BQue=0  EncServ=0  MultiP=1  MChngr=0  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
  Clocking=0x0  QAS=0  IUS=0
    length=96 (0x60)   Peripheral device type: disk
 Vendor identification: DGC     
 Product identification:                 
 Product revision level: 0850
 Product serial number: F20010500078


> 
> Doug Gilbert

	Alberto

[...]

-- 
Alberto Cammozzo
System/Network Manager
Universita` di Padova -IT
