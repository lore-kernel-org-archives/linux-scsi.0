From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] fix sym2 negotiation
Date: Tue, 24 Aug 2004 23:57:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040825065747.GA2275@us.ibm.com>
References: <1093113450.1732.334.camel@mulgrave> <20040824132936.GA25263@suse.de> <20040824203914.GA25755@us.ibm.com> <20040824205126.GA10105@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:8949 "EHLO e31.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S268580AbUHYG7R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Aug 2004 02:59:17 -0400
Content-Disposition: inline
In-Reply-To: <20040824205126.GA10105@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, willy@debian.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Anton Blanchard <anton@samba.org>

Olaf Hering [olh@suse.de] wrote:
>  On Tue, Aug 24, Mike Anderson wrote:
> 
> > I would guess this cdrom is behind a ACARD. We have had issues in
> > the past with negotiation / interaction between the ACARD and the sym. 
> 
> Oh, that would be possible. I will look through our patches and find the
> one that adds an insane delay. Maybe it helps.
> 

Yes increasing scsi_inq_timeout to 27 seconds makes the messages go away
on my system. Prior to increasing the timeout I bk pulled scsi-misc-2.6
and received the same ABORT recovery sequence you did.

Output post increasing the timeout:

x0537p1:~ # modprobe sym53c8xx
sym0: <1010-66> rev 0x1 at pci 0000:58:01.0 irq 137
sym0: No NVRAM, ID 7, Fast-80, LVD, parity checking
sym0: SCSI BUS has been reset.
scsi3 : sym-2.1.18j
sym1: <1010-66> rev 0x1 at pci 0000:58:01.1 irq 138
sym1: No NVRAM, ID 7, Fast-80, LVD, parity checking
sym1: SCSI BUS has been reset.
scsi4 : sym-2.1.18j
  Vendor: IBM       Model: DROM0020311       Rev: 8R22
  Type:   CD-ROM                             ANSI SCSI revision: 02
scsi(4:0:1:0): Beginning Domain Validation
sym1:1: wide asynchronous.
sym1:1: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 14)
scsi(4:0:1:0): Domain Validation skipping write tests
scsi(4:0:1:0): Ending Domain Validation
sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
Attached scsi CD-ROM sr0 at scsi4, channel 0, id 1, lun 0
Attached scsi generic sg5 at scsi4, channel 0, id 1, lun 0,  type 5
program scsi_id is using a deprecated SCSI ioctl, please convert it to
SG_IO
program scsi_id is using a deprecated SCSI ioctl, please convert it to
SG_IO
program hwscan is using a deprecated SCSI ioctl, please convert it to
SG_IO
program hwscan is using a deprecated SCSI ioctl, please convert it to
SG_IO

x0537p1:~ # sg_inq /dev/sg5
standard INQUIRY:
PQual=0  Device_type=5  RMB=1  [ANSI_version=2]  version=0x02
[AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
SCCS=0  ACC=0  ALUA=0  3PC=0  Protect=0
BQue=0  EncServ=0  MultiP=0  MChngr=0  [ACKREQQ=0]  Addr16=0
[RelAdr=0]  WBus16=1  Sync=1  Linked=0  [TranDis=0]  CmdQue=0
Clocking=0x0  QAS=0  IUS=0
length=148 (0x94)   Peripheral device type: cd/dvd
Vendor identification: IBM
Product identification: DROM0020311
Product revision level: 8R22

-andmike
--
Michael Anderson
andmike@us.ibm.com

