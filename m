From: "HINCHMAN,PAUL (HP-Roseville,ex1)" <paul_hinchman@hp.com>
Subject: RE: Enterprise patch needed - please help
Date: Thu, 30 May 2002 09:33:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <6BD67FFB937FD411A04F00D0B74FE87807C249F1@xrose06.rose.hp.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Andrew Patterson' <andrew@fc.hp.com>, Michael Clark <michael@metaparadigm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "HINCHMAN,PAUL (HP-Roseville,ex1)" <paul_hinchman@hp.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Thank you all for your response.  Actually, the SPARSELUN problem is yet a
different thing which, if I remember right, Kurt Garloff had a hand in
fixing scsi_scan.c.  What I'm really talking about is (I think) in
/usr/src/<linux>/drivers/scsi/hosts.h, where CONFIG_SD_EXTRA_DEVS is 2
(NOTE: the path to this parameter in xconfig/menuconfig is set to 40).
Either way, we've been able to manually change hosts.h and/or change
"maximum number of SCSI disks that can be loaded as modules" (which
supposedly writes to CONFIG_SD_EXTRA_DEVS)in xconfig/menuconfig, and it all
works fine.  The problem comes in when our customers do this, they lose the
support of the distribution vendor, because they/we have to recompile to get
the changes effected.  I like the idea of a loadable module, taking into
account that our root file system is on a scsi disk, so this would truly be
an extra_dev thing.  Also, we'd need help to develope it.  
Once again, thanks to all!
R/
Paul Hinchman  

-----Original Message-----
From: Andrew Patterson [mailto:andrew@fc.hp.com]
Sent: Thursday, May 30, 2002 7:40 AM
To: Michael Clark
Cc: Alan Cox; HINCHMAN,PAUL " "(HP-Roseville,ex1);
'linux-scsi@vger.kernel.org'
Subject: Re: Enterprise patch needed - please help


On Thu, 2002-05-30 at 06:43, Michael Clark wrote:
> 
> On 05/30/02 20:38, Alan Cox wrote:
> 
> >On Thu, 2002-05-30 at 05:46, Michael Clark wrote:
> >  
> >
> >>Also, some devices need a BLIST_SPARSELUN added in scsi_scan.c - even if

> >>the device
> >>reports SCSI-3, the scanning code by defaults stops when it finds a lun 
> >>that doesn't
> >>respond. It is quite common with enterpise storage to have sparse 
> >>between luns.
> >>    
> >>

The following entries in the device_list array of scsi_scan.c should do
the trick for HP arrays.

   {"HP", "A6188A", "*", BLIST_SPARSELUN},      // HP Va7100 Array
   {"HP", "A6189A", "*", BLIST_SPARSELUN},      // HP Va7400 Array
   {"HP", "A6189B", "*", BLIST_SPARSELUN},      // HP Va7410 Array
   {"HP", "OPEN-", "*", BLIST_SPARSELUN},       // HP XP Arrays

Note that you must have a LUN at LUN number 0, to detect sparse LUN's
above LUN number 7.  

Andrew Patterson

    

> >
> >If we use report luns should we even be checking BLIST_SPARSELUN I
> >wonder
> >
> >  
> >
> Oh, is this new or maybe my device doesn't report luns as I've needed
> the sparse lun hint even though device was correctly detected as SCSI-3.
> This is with 2.4.18
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

