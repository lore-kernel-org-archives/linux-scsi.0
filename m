From: "Collins, Kevin" <kCollins@nesbittengineering.com>
Subject: RE: Megaraid problems.
Date: Fri, 13 Jan 2006 13:25:34 -0500
Message-ID: <H000007300186d25.1137176733.concorde.nesbitt.local@MHS>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.nesbittengineering.com ([64.191.130.42]:37511 "EHLO
	concorde.nesbitt.local") by vger.kernel.org with ESMTP
	id S1422801AbWAMSZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2006 13:25:41 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Seokmann.Ju@lsil.com

On Friday, January 13, 2006 11:56 AM, Seokmann Ju wrote:

> Hi,
> > Besides the external storage (powered by megaraid, the 
> PERC4 and the 
> > PV220s) the machine has two internal SATA drives.
> > These internal drives house the OS, the web server and the 
> mail queue.  
> > The only I/O running through megaraid at the time of the 
> failures has 
> > been the creation of the tar files.
> If it is happening during disk I/O, I would like to 
> investigate further.
> It would be greatly helpful if you could provide some detail 
> steps to get the issue including how to create that big size file.

This server is an RSYNC hub for my company's three offices.  Every night an on-site backup cache in each office pushes the day's data to this machine.  After that process is complete, this machine creates a tarball of the combined sum of the three office's data to keep for short term storage.  The machine also rotates these tarballs for a week, so I end up with 7 90+ GB tarballs.

The uncompressed data contains everything from Word documents to AutoCAD drawings to a backup of my e-mail data store and Jpeg pictures from a company party.  You name it, I probably have it. ;-)  The uncompressed data is floating around 140GB.

To create my tarball I simply run "tar -zcvf /daily/backup1/archive.tar.gz ." from inside   of a perl script of my own creation.  Nothing special about it.

> And also, I'll check with F/W team to see if any updated 
> version of it and will get back to you if so.

Thanks.

Kevin

> 
> > -----Original Message-----
> > From: Collins, Kevin [mailto:kCollins@nesbittengineering.com]
> > Sent: Friday, January 13, 2006 11:00 AM
> > To: linux-scsi@vger.kernel.org; Ju, Seokmann
> > Subject: RE: Megaraid problems.
> > 
> > On Friday, January 13, 2006 9:39 AM, Seokmann Ju wrote:
> > 
> > > Hi,
> > Hey, glad to get a response!  :-)
> > 
> > > Thank you for posting details regarding megaraid.
> > > From the log, the messaage are OK except for following.
> > > ---
> > > >  1 Time(s): [5535381.561000] megaraid: reseting the host...
> > > >  1 Time(s): [5535386.566000] megaraid mbox: Wait for 2
> > commands to
> > > > complete:175
> > > > 
> > > > [... The above line repeat every 5 seconds, counting down
> > to 0 ...]
> > > > 
> > > >  1 Time(s): [5535556.736000] megaraid mbox: Wait for 2
> > commands to
> > > > complete:5
> > > >  2 Time(s): [5535562.611000] scsi2 (0:0): rejecting I/O
> > to offline
> > > > device
> > > ---
> > > > a). Knows about the problem and is working on it.
> > > > 
> > > > - and, more importantly -
> > > It seems like that, for some reason, controller couldn't return 
> > > commands (2 commands for this case) within given timeout period.
> > > And because of it, driver decided to reset the controller and as 
> > > part of reset, it triggers the F/W to make the device offline.
> > 
> > And I'm assuming that this is why my data isn't damamged or 
> otherwise 
> > corrupted - which is a good thing! ;-)
> > 
> > > > b). Can lead me to a fix.
> > > Can you clarify what is F/W version on the controller?
> > Firmware on the controller (from /proc/scci/scsi):  351S 
> > =================================================================
> > Host: scsi2 Channel: 00 Id: 06 Lun: 00
> >   Vendor: DELL     Model: PV22XS           Rev: E.18
> >   Type:   Processor                        ANSI SCSI revision: 03
> > Host: scsi2 Channel: 01 Id: 00 Lun: 00
> >   Vendor: MegaRAID Model: LD 0 RAID5  858G Rev: 351S
> >   Type:   Direct-Access                    ANSI SCSI revision: 02
> > Host: scsi2 Channel: 01 Id: 01 Lun: 00
> >   Vendor: MegaRAID Model: LD 1 RAID5  858G Rev: 351S
> >   Type:   Direct-Access                    ANSI SCSI revision: 02
> > =================================================================
> > 
> > I have seen reports on Dells mailing list that elude to the 
> fact the 
> > the E18 and 351S firmwares are supposed to help this situation, but 
> > not in my case.  My system shipped with these firmwares in place.  
> > Dell, to my knowledge, does not offer any newer versions of either 
> > firmware.
> > 
> > > Besides disk I/O, are there other operations involved like,
> > tape R/W?
> > No tape R/W, but...
> > 
> > > How about application? Any application that is communicating with 
> > > MegaRAID through IOCTL at that time?
> > As for other tasks, the machine also serves as a web server 
> (Apache, 
> > MySQL and PHP) and e-mail relay (Postfix).  The mail relay 
> does more 
> > work than the web server, but even that is light.
> > 
> > Besides the external storage (powered by megaraid, the 
> PERC4 and the 
> > PV220s) the machine has two internal SATA drives.
> > These internal drives house the OS, the web server and the 
> mail queue.  
> > The only I/O running through megaraid at the time of the 
> failures has 
> > been the creation of the tar files.
> > 
> > > 
> > > Thank you,
> > 
> > You're welcome.  I hope I have helped with the information and not 
> > hindered.  ;-)
> > 
> > Kevin
> > 
> > > 
> > > 
> > > > -----Original Message-----
> > > > From: linux-scsi-owner@vger.kernel.org 
> > > > [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of
> > > Collins, Kevin
> > > > Sent: Friday, January 13, 2006 9:05 AM
> > > > To: linux-scsi@vger.kernel.org
> > > > Subject: Megaraid problems.
> > > > 
> > > > Hi list,
> > > > 
> > > > I have a Dell PowerEdge 850 with their PERC4sc RAID card
> > driving a
> > > > Dell PowerVault 220s external drive enclosure running
> > Ubuntu 5.10.  
> > > > This machine and all the parts that make it up are less
> > > than 2 months
> > > > old.  In that time, I have had both logical drives supplied
> > > by PV220s
> > > > taken offline by the megaraid driver twice.  The only
> > cure for this
> > > > has been a reboot of the machine.  Luckily, with the
> > > exception of the
> > > > process that was running at the time of the problem,
> > > nothing else was
> > > > damaged or hurt; no loss of data has been experienced (yet).
> > > > 
> > > > Both times the failure has occurred, it happened while 
> creating a 
> > > > gzipped tarball of some backup data.  The final tarball
> > created is
> > > > averaging about 92+ GB in size and the machine is under
> > > heavy disk I/O
> > > > for more than 7 hours.  I have been able to grab this
> > > information from
> > > > the syslog after the failure (gathered with LogWatch):
> > > > 
> > > >  1 Time(s): [5535381.561000] megaraid abort: 
> > > > 55592075:43[255:128], fw owner
> > > >  1 Time(s): [5535381.561000] megaraid abort: 
> > > > 55592077:62[255:128], fw owner
> > > >  1 Time(s): [5535381.561000] megaraid abort: 
> > > > 55592078[255:128], driver owner
> > > >  1 Time(s): [5535381.561000] megaraid mbox: Wait for 2
> > commands to
> > > > complete:180
> > > >  1 Time(s): [5535381.561000] megaraid: 2 outstanding
> > commands. Max
> > > > wait 180 sec
> > > >  1 Time(s): [5535381.561000] megaraid: aborting-55592075
> > > > cmd=28 <c=1 t=0 l=0>
> > > >  1 Time(s): [5535381.561000] megaraid: aborting-55592077
> > > > cmd=28 <c=1 t=0 l=0>
> > > >  1 Time(s): [5535381.561000] megaraid: aborting-55592078
> > > > cmd=28 <c=1 t=0 l=0>
> > > >  1 Time(s): [5535381.561000] megaraid: reseting the host...
> > > >  1 Time(s): [5535386.566000] megaraid mbox: Wait for 2
> > commands to
> > > > complete:175
> > > > 
> > > > [... The above line repeat every 5 seconds, counting down
> > to 0 ...]
> > > > 
> > > >  1 Time(s): [5535556.736000] megaraid mbox: Wait for 2
> > commands to
> > > > complete:5
> > > >  2 Time(s): [5535562.611000] scsi2 (0:0): rejecting I/O
> > to offline
> > > > device
> > > > 
> > > > The only difference in the two instances is the number of
> > > "commands" 
> > > > that are waiting to complete.  This snippet above is from
> > the first
> > > > instance, the second instance had 10 commands waiting.
> > > > 
> > > > The machine is running the default Ubuntu kernel, which 
> is their 
> > > > patched version of 2.6.12.  In addition, both the
> > megaraid_mbox and
> > > > megaraid_mm modules are loaded.  Here is an output of
> > 'modinfo' for
> > > > both of those modules:
> > > > 
> > > > ==============================================================
> > > > ==========================
> > > > megaraid_mbox
> > > > --------------------------------------------------------------
> > > > --------------------------
> > > > filename:       
> > > > /lib/modules/2.6.12-10-386/kernel/drivers/scsi/megaraid/megara
> > > > id_mbox.ko
> > > > author:         LSI Logic Corporation
> > > > description:    LSI Logic MegaRAID Mailbox Driver
> > > > license:        GPL
> > > > version:        2.20.4.5
> > > > vermagic:       2.6.12-10-386 386 gcc-3.4
> > > > depends:        megaraid_mm,scsi_mod
> > > > alias:          
> pci:v00001028d0000000Esv00001028sd00000123bc*sc*i*
> > > > alias:          
> pci:v00001000d00001960sv00001028sd00000520bc*sc*i*
> > > > alias:          
> pci:v00001000d00001960sv00001028sd00000518bc*sc*i*
> > > > alias:          
> pci:v00001000d00000407sv00001028sd00000531bc*sc*i*
> > > > alias:          
> pci:v00001028d0000000Fsv00001028sd0000014Abc*sc*i*
> > > > alias:          
> pci:v00001028d00000013sv00001028sd0000016Cbc*sc*i*
> > > > alias:          
> pci:v00001028d00000013sv00001028sd0000016Dbc*sc*i*
> > > > alias:          
> pci:v00001028d00000013sv00001028sd0000016Ebc*sc*i*
> > > > alias:          
> pci:v00001028d00000013sv00001028sd0000016Fbc*sc*i*
> > > > alias:          
> pci:v00001028d00000013sv00001028sd00000170bc*sc*i*
> > > > alias:          
> pci:v00001000d00000408sv00001028sd00000002bc*sc*i*
> > > > alias:          
> pci:v00001000d00000408sv00001028sd00000001bc*sc*i*
> > > > alias:          
> pci:v0000101Ed00001960sv00001028sd00000471bc*sc*i*
> > > > alias:          
> pci:v0000101Ed00001960sv00001028sd00000493bc*sc*i*
> > > > alias:          
> pci:v0000101Ed00001960sv00001028sd00000475bc*sc*i*
> > > > alias:          
> pci:v0000101Ed00001960sv0000101Esd00000475bc*sc*i*
> > > > alias:          
> pci:v0000101Ed00001960sv0000101Esd00000493bc*sc*i*
> > > > alias:          
> pci:v00001000d00001960sv00001000sd0000A520bc*sc*i*
> > > > alias:          
> pci:v00001000d00001960sv00001000sd00000520bc*sc*i*
> > > > alias:          
> pci:v00001000d00001960sv00001000sd00000518bc*sc*i*
> > > > alias:          
> pci:v00001000d00000407sv00001000sd00000530bc*sc*i*
> > > > alias:          
> pci:v00001000d00000407sv00001000sd00000532bc*sc*i*
> > > > alias:          
> pci:v00001000d00000407sv00001000sd00000531bc*sc*i*
> > > > alias:          
> pci:v00001000d00000408sv00001000sd00000001bc*sc*i*
> > > > alias:          
> pci:v00001000d00000408sv00001000sd00000002bc*sc*i*
> > > > alias:          
> pci:v00001000d00001960sv00001000sd00000522bc*sc*i*
> > > > alias:          
> pci:v00001000d00001960sv00001000sd00004523bc*sc*i*
> > > > alias:          
> pci:v00001000d00001960sv00001000sd00000523bc*sc*i*
> > > > alias:          
> pci:v00001000d00000409sv00001000sd00003004bc*sc*i*
> > > > alias:          
> pci:v00001000d00000409sv00001000sd00003008bc*sc*i*
> > > > alias:          
> pci:v00001000d00000407sv00008086sd00000532bc*sc*i*
> > > > alias:          
> pci:v00001000d00001960sv00008086sd00000523bc*sc*i*
> > > > alias:          
> pci:v00001000d00000408sv00008086sd00000002bc*sc*i*
> > > > alias:          
> pci:v00001000d00000407sv00008086sd00000530bc*sc*i*
> > > > alias:          
> pci:v00001000d00000409sv00008086sd00003008bc*sc*i*
> > > > alias:          
> pci:v00001000d00000408sv00008086sd00003431bc*sc*i*
> > > > alias:          
> pci:v00001000d00000408sv00008086sd00003499bc*sc*i*
> > > > alias:          
> pci:v00001000d00001960sv00008086sd00000520bc*sc*i*
> > > > alias:          
> pci:v00001000d00000408sv00001734sd00001065bc*sc*i*
> > > > alias:          
> pci:v00001000d00000408sv00001025sd0000004Dbc*sc*i*
> > > > alias:          
> pci:v00001000d00000408sv00001033sd00008287bc*sc*i*
> > > > srcversion:     042A4371A952248BEF860F4
> > > > parm:           debug_level:Debug level for driver 
> > (default=0) (int)
> > > > parm:           fast_load:Faster loading of the driver, skips 
> > > > physical devices! (default=0) (int)
> > > > parm:           cmd_per_lun:Maximum number of commands per 
> > > > logical unit (default=64) (int)
> > > > parm:           max_sectors:Maximum number of sectors per IO 
> > > > command (default=128) (int)
> > > > parm:           busy_wait:Max wait for mailbox in 
> > > > microseconds if busy (default=10) (int)
> > > > parm:           unconf_disks:Set to expose unconfigured disks 
> > > > to kernel (default=0) (int)
> > > > 
> > > > --------------------------------------------------------------
> > > > --------------------------
> > > > megaraid_mm:
> > > > --------------------------------------------------------------
> > > > --------------------------
> > > > filename:       
> > > > 
> > > 
> > 
> /lib/modules/2.6.12-10-386/kernel/drivers/scsi/megaraid/megaraid_mm.ko
> > > > author:         LSI Logic Corporation
> > > > description:    LSI Logic Management Module
> > > > license:        GPL
> > > > version:        2.20.2.5
> > > > vermagic:       2.6.12-10-386 386 gcc-3.4
> > > > depends:
> > > > srcversion:     D2DA33EA7F3FEA9EBE4A603
> > > > parm:           dlevel:Debug level (default=0) (int)
> > > > ==============================================================
> > > > ==========================
> > > > 
> > > > I have contacted Dell - via their linux-poweredge mailing
> > > list - and
> > > > have discovered that I am not the only one experiencing these 
> > > > problems.  What bothers me is that while this problem,
> > > apparently, has
> > > > been around a while and no fix has yet been discovered 
> by Dell or 
> > > > anyone else.
> > > > 
> > > > My research also leads me to believe that this is not just
> > > an Ubuntu
> > > > thing either.  I have reports that this happens under
> > > Redhat, Debian
> > > > and SuSE.  It also appears as though the problem started
> > happening
> > > > around kernel version 2.6.9.
> > > > 
> > > > So, I'm hoping that someone here:
> > > > 
> > > > a). Knows about the problem and is working on it.
> > > > 
> > > > - and, more importantly -
> > > > 
> > > > b). Can lead me to a fix.
> > > > 
> > > > My machine is in production and I do not have any
> > > additional hardware
> > > > to test with, but I can do limited testing with it as
> > long as it is
> > > > completely functional by 8:00 pm eastern time.  I'm using it as 
> > > > offsite backup machine and that's when my backup processes
> > > kick in.  
> > > > If more information is needed, let me know how to get it,
> > and I'll
> > > > supply it.
> > > > 
> > > > I need to get this solved ASAP.
> > > > 
> > > > Thanks in advance,
> > > > 
> > > > --
> > > > Kevin L. Collins, MCSE
> > > > Systems Manager
> > > > Nesbitt Engineering, Inc. 
> > > > -
> > > > To unsubscribe from this list: send the line "unsubscribe
> > > linux-scsi" 
> > > > in the body of a message to majordomo@vger.kernel.org More
> > > majordomo
> > > > info at  http://vger.kernel.org/majordomo-info.html
> > > > 
> > > 
> > > 
> > 
> 
> 
