From: Poul Petersen <petersp@roguewave.com>
Subject: RE: What's the "right" qla2100 driver?
Date: Wed, 26 May 2004 17:25:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <D486606E7AD20947BDB7E56862E04C3952D2@cvo1.cvo.roguewave.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cvo-ext.roguewave.com ([12.22.36.198]:50538 "EHLO
	cvo1.cvo.roguewave.com") by vger.kernel.org with ESMTP
	id S261439AbUE0AZO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 20:25:14 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Andrew Vasquez' <praka@users.sourceforge.net>, linux-scsi@vger.kernel.org

	OK - The box is now running kernel 2.6.6 and the qla2xxx driver
version 8.00.00b12. I tried making a single raid set and about 17% of the
way into the sync I got the following:

qla2100 0000:00:0e.0: LIP reset occured (f7ef).
qla2100 0000:00:0e.0: LIP occured (f7ef).
qla2100 0000:00:0e.0: Mailbox command timeout occured. Issuing ISP abort.
qla2100 0000:00:0e.0: Performing ISP error recovery - ha= c121c218.
qla2100 0000:00:0e.0: LIP reset occured (f8f7).
qla2100 0000:00:0e.0: LIP occured (f8f7).
qla2100 0000:00:0e.0: LOOP UP detected (1 Gbps).
qla2100 0000:00:0e.0: qla2xxx_eh_abort: cmd already done sp=00000000
qla2100 0000:00:0e.0: qla2xxx_eh_abort: cmd already done sp=00000000
qla2100 0000:00:0e.0: qla2xxx_eh_abort: cmd already done sp=00000000
qla2100 0000:00:0e.0: qla2xxx_eh_abort: cmd already done sp=00000000
qla2100 0000:00:0e.0: qla2xxx_eh_abort scsi(0:0:2:0):
cmd_timeout_in_sec=0x1e.
qla2100 0000:00:0e.0: qla2xxx_eh_abort Exiting: status=Failed
	
	And so on, each disc failing with an error similar to the last two
lines. I changed DEBUG_QLA2100 to "1" in qla_settings.h and then I got a
bunch of these when I loaded the driver:

scsi(1): RLC failed to issue iocb! fcport=[000c/cf5e84ec] rval=0 cs=0 ss=b02

	Followed by a bunch of:

cmd_timeout: Found in ISP

	And after resyncing the raid set for sometime, the failure messages:

qla2xxx_eh_abort: refcount 1
qla2100 0000:00:0e.0: qla2xxx_eh_abort scsi(1:0:3:0):
cmd_timeout_in_sec=0x1e.
SCSI Command @=0xc4eabaa8, Handle=0x00000335
  chan=0x00, target=0x03, lun=0x00, cmd_len=0x0a
 CDB: 0x28 0x00 0x00 0xe6 0xc6 0x3f 0x00 0x01 0x00 0x00
  seg_cnt=32, allowed=20, retries=0, serial_number_at_timeout=0x103982
  request buffer=0xca53365c, request buffer len=0x20000
  tag=90, transfersize=0x200
  serial_number=103982, SP=cb214b38
  data direction=2
  sp flags=0x2
  r_start=0x190678, u_start=0x190678, f_start=0x5a5a5a5a, state=7
 e_start= 0x5a5a5a5a, ext_history=1515870810, fo retry=0, loopid=4, port
path=0
qla2100 0000:00:0e.0: qla2xxx_eh_abort Exiting: status=Failed
qla2xxx_eh_abort: refcount 1
qla2100 0000:00:0e.0: qla2xxx_eh_abort scsi(1:0:6:0):
cmd_timeout_in_sec=0x1e.
SCSI Command @=0xca4f033c, Handle=0x00000339
  chan=0x00, target=0x06, lun=0x00, cmd_len=0x0a
 CDB: 0x28 0x00 0x00 0xe6 0xc7 0xbf 0x00 0x00 0x48 0x00
  seg_cnt=9, allowed=20, retries=0, serial_number_at_timeout=0x103986
  request buffer=0xc82088b4, request buffer len=0x9000
  tag=90, transfersize=0x200
  serial_number=103986, SP=cb214e98
  data direction=2
  sp flags=0x2
  r_start=0x19067a, u_start=0x19067a, f_start=0x5a5a5a5a, state=7
 e_start= 0x5a5a5a5a, ext_history=1515870810, fo retry=0, loopid=7, port
path=0
qla2100 0000:00:0e.0: qla2xxx_eh_abort Exiting: status=Failed
qla2xxx_eh_abort: refcount 1
qla2100 0000:00:0e.0: qla2xxx_eh_abort scsi(1:0:0:0):
cmd_timeout_in_sec=0x1e.
SCSI Command @=0xcbc51c24, Handle=0x0000033b
  chan=0x00, target=0x00, lun=0x00, cmd_len=0x0a
 CDB: 0x28 0x00 0x00 0xe6 0xc7 0xbf 0x00 0x00 0x48 0x00
  seg_cnt=9, allowed=20, retries=0, serial_number_at_timeout=0x103988
  request buffer=0xcf5dd9c0, request buffer len=0x9000
  tag=90, transfersize=0x200
  serial_number=103988, SP=cb214238
  data direction=2
  sp flags=0x2
  r_start=0x19067a, u_start=0x19067a, f_start=0x5a5a5a5a, state=7
 e_start= 0x5a5a5a5a, ext_history=1515870810, fo retry=0, loopid=1, port
path=0

Thoughts? Many thanks,

-poul


> -----Original Message-----
> From: Andrew Vasquez [mailto:praka@users.sourceforge.net]
> Sent: Wednesday, January 21, 2004 9:22 PM
> To: linux-scsi@vger.kernel.org
> Subject: Re: What's the "right" qla2100 driver?
> 
> 
> On Wed, 21 Jan 2004, Poul Petersen wrote:
> 
> > I've got a Qlogic qla2100 card connected via copper to an array of
> > 28 ~18GB disks. I'm trying to create two raid level 5 md devices
> > with 13disk+1spare each. What I'm experiencing is a lot of hangs and
> > strange disk failures that appear to be related to the drivers for
> > the 2100. As there seems to be many different drivers to choose from
> > for the qla2100, I've tried them all and collected my (all bad)
> > experiences, a summary of which I have attached below. 
> > 
> > What I am wondering is if anyone else is using this card with Linux
> > and if so what driver are they using? More importantly, which driver
> > is actively being worked on (if any) so that I might contribute some
> > failure information? 
> > 
> 
> For 2.4, you could try another driver -- 6.06.10 (available at the
> QLogic website).  This driver has support for the 2100 (though it's
> not actually documented).  The makefile will not build the driver
> though, try something similiar to the following:
> 
> 	# make qla2100.o
> 
> For 2.6, why don't we start out with the default qla2xxx driver in
> 2.6.2-rc1.  
> 
> > It's possible that I am experiencing a hardware problem, since these
> > disks and controller are a few years old now, but I doubt it since
> > most of the errors seem inconsistent with bad hardware (all disks
> > failing, etc). If nothing else, if I get feedback saying that
> > someone else is successfully using a certain driver, then I can
> > start playing with hardware using the same driver and maybe get to
> > the bottom of this...
> > 
> 
> From there let's see how far you get with the drivers.  We may need to
> enable some extra debugging for additional information.
> 
> > ---
> > Test #5
> > 2.6.1 with sourceforge qlogic driver 8.00.00.b8 (
> > http://sourceforge.net/projects/linux-qla2xxx/ )
> > ---
> > 
> > # modprobe qla2xxx
> > # mkraid /dev/md0
> > # mkraid /dev/md1
> > # mkfs.ext3 /dev/md0
> > 
> >  	After awhile, the mkfs hung and when I tried to reboot 
> the machine,
> > I got a bunch of errors like the following for all 28 disks:
> > 
> > qla2xxx_eh_abort scsi(1:0:12:0) cmd_timeout_in_sec=0x1e.
> > qla2xxx_eh_abort Exiting: status=Failed
> > 
> 
> Interesting...
> 
> Regards,
> Andrew Vasquez
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
