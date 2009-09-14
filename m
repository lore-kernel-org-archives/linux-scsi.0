From: Marc Giger <gigerstyle@gmx.ch>
Subject: Re: MD/RAID time out writing superblock
Date: Mon, 14 Sep 2009 07:30:22 +0200
Message-ID: <20090914073022.7250c80d@rigi.itserve.ch>
References: <004e01ca25e4$c11a54e0$434efea0$@ca>
	<9cfb6af689a7010df166fdebb1ef516b.squirrel@neil.brown.name>
	<4A948A82.4080901@redhat.com>
	<b585ed9f13649050bbc984869d081315.squirrel@neil.brown.name>
	<4A94905F.7050705@redhat.com>
	<005101ca25f4$09006830$1b013890$@ca>
	<4A94A0E6.4020401@redhat.com>
	<005401ca25ff$9ac91cc0$d05b5640$@ca>
	<4A950FA6.4020408@redhat.com>
	<92cb16daad8278b0aa98125b9e1d057a@localhost>
	<4A95573A.6090404@redhat.com>
	<1571f45804875514762f60c0097171e6@localhost>
	<d086b110526f8bac2f562850dfc70b03@localhost>
	<4A970154.2020507@redhat.com>
	<4A9B8583.9050601@kernel.org>
	<4A9BC033.9000909@pobox.com>
	<4A9C60A1.50303@rtr.ca>
	<640f6103c45b6cba6f84f887bde227e4@localhost>
	<4A9D1E7D.1050104@rtr.ca>
	<4A9D2204.1000608@kernel.org>
	<4A9D25F3.2030207@redhat.com>
	<419cca21f9440d50bf6c95716ffc5402@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44462 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752144AbZINFaX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Sep 2009 01:30:23 -0400
In-Reply-To: <419cca21f9440d50bf6c95716ffc5402@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrei Tanas <andrei@tanas.ca>
Cc: Ric Wheeler <rwheeler@redhat.com>, Tejun Heo <tj@kernel.org>, Mark Lord <liml@rtr.ca>, Mark Lord <mlord@pobox.com>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>

Hi,

I have similar problem with my two Sun T2000 machines.
During last week I got two times a degraded array. Everytime another
disk is kicked of the array. On the other T2000 machine the same happend
multiple times in the past too. The interesting part is, it is always the
same sector involved on every disk as in the original report. After a manual resync of the disks it
seems to work for some time until it is failing again. smart doesn't show
any errors on the disks.

[871180.857895] sd 0:0:0:0: [sda] Result: hostbyte=0x01 driverbyte=0x00                                                                                          
[871180.857929] end_request: I/O error, dev sda, sector 143363852                                                                                                
[871180.857950] md: super_written gets error=-5, uptodate=0                                                                                                      
[871180.857968] raid1: Disk failure on sda2, disabling device.                                                                                                   
[871180.857976]         Operation continuing on 1 devices                                                                                                        
[871180.863652] RAID1 conf printout:                                                                                                                             
[871180.863678]  --- wd:1 rd:2                                                                                                                                   
[871180.863694]  disk 0, wo:1, o:0, dev:sda2                                                                                                                     
[871180.863710]  disk 1, wo:0, o:1, dev:sdb2                                                                                                                     
[871180.873021] RAID1 conf printout:                                                                                                                             
[871180.873041]  --- wd:1 rd:2                                                                                                                                   
[871180.873053]  disk 1, wo:0, o:1, dev:sdb2                                                                                                                     
[925797.120488] md: data-check of RAID array md0                                                                                                                 
[925797.120516] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.                                                                                               
[925797.120531] md: using maximum available idle IO bandwidth (but not more than 30000 KB/sec) for data-check.                                                   
[925797.120573] md: using 256k window, over a total of 71585536 blocks.                                                                                          
[925797.121308] md: md0: data-check done.                                                                                                                        
[925797.137397] RAID1 conf printout:                                                                                                                             
[925797.137419]  --- wd:1 rd:2                                                                                                                                   
[925797.137433]  disk 1, wo:0, o:1, dev:sdb2                                                                                                                     
[1036034.437130] md: unbind<sda2>                                                                                                                                
[1036034.437168] md: export_rdev(sda2)
[1036044.572402] md: bind<sda2>
[1036044.574923] RAID1 conf printout:
[1036044.574945]  --- wd:1 rd:2
[1036044.574960]  disk 0, wo:1, o:1, dev:sda2
[1036044.574976]  disk 1, wo:0, o:1, dev:sdb2
[1036044.575157] md: recovery of RAID array md0
[1036044.575171] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[1036044.575186] md: using maximum available idle IO bandwidth (but not more than 30000 KB/sec) for recovery.
[1036044.575227] md: using 256k window, over a total of 71585536 blocks.
[1038465.450853] md: md0: recovery done.
[1038465.549707] RAID1 conf printout:
[1038465.549728]  --- wd:2 rd:2
[1038465.549743]  disk 0, wo:0, o:1, dev:sda2
[1038465.549759]  disk 1, wo:0, o:1, dev:sdb2
[1192672.830876] sd 0:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
[1192672.830910] end_request: I/O error, dev sdb, sector 143363852
[1192672.830932] md: super_written gets error=-5, uptodate=0
[1192672.830951] raid1: Disk failure on sdb2, disabling device.
[1192672.830958]        Operation continuing on 1 devices
[1192672.836943] RAID1 conf printout:
[1192672.836964]  --- wd:1 rd:2
[1192672.836976]  disk 0, wo:0, o:1, dev:sda2
[1192672.836990]  disk 1, wo:1, o:0, dev:sdb2
[1192672.846157] RAID1 conf printout:
[1192672.846177]  --- wd:1 rd:2
[1192672.846189]  disk 0, wo:0, o:1, dev:sda2


The used disks are:

Device: FUJITSU  MAY2073RCSUN72G  Version: 0401
Device type: disk                              
Transport protocol: SAS                        
Local Time is: Mon Sep 14 07:24:28 2009 CEST   
Device supports SMART and is Enabled           
Temperature Warning Disabled or Not Supported  
SMART Health Status: OK                        

Current Drive Temperature:     34 C
Drive Trip Temperature:        65 C
Manufactured in week 38 of year 2006
Recommended maximum start stop count:  10000 times
Current start stop count:      56 times           
Elements in grown defect list: 0

Device: FUJITSU  MAY2073RCSUN72G  Version: 0401
Device type: disk
Transport protocol: SAS
Local Time is: Mon Sep 14 07:25:49 2009 CEST
Device supports SMART and is Enabled
Temperature Warning Disabled or Not Supported
SMART Health Status: OK

Current Drive Temperature:     33 C
Drive Trip Temperature:        65 C
Manufactured in week 38 of year 2006
Recommended maximum start stop count:  10000 times
Current start stop count:      56 times
Elements in grown defect list: 0


Controller:
0000:07:00.0 SCSI storage controller: LSI Logic / Symbios Logic
SAS1064ET PCI-Express Fusion-MPT SAS (rev 02)

Thanks

Marc



On Tue, 01 Sep 2009 10:18:06 -0400
Andrei Tanas <andrei@tanas.ca> wrote:

> On Tue, 01 Sep 2009 09:47:31 -0400, Ric Wheeler <rwheeler@redhat.com>
> wrote:
> >>>> Mine errored out again with exactly the same symptoms, this time after
> >>>> only
> >>>> few days and with the "tunable" set to 2 sec. I got a warranty
> >>>> replacement
> >>>> but haven't shipped this one yet. Let me know if you want it.
> >>> ..
> >>>
> >>> Not me.  But perhaps Tejun ?
> >>
> >> I think you're much more qualified than me on the subject. :-)
> >>
> >> Anyone else?  Ric, are you interested with playing the drive?
> > 
> > No thanks....
> > 
> > I would suggest that Andrei install the new drive and watch it for a few
> > days to 
> > make sure that it does not fail in the same way. If it does, you might
> want
> > to look at the power supply/cables/etc?
> 
> The drive is the second member of RAID1 array, as far as I understand, both
> drives should be experiencing very similar access patterns, and they are
> the same model with the same firmware, and manufactured on the same day,
> but only one of them showed these symptoms, so there must be something
> "special" about it.
> By now I think that MD made the right "decision" failing the drive and
> removing it from the array, so I guess let's leave it at that.
> 
> Andrei.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

