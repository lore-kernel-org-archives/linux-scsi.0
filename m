From: Andrew Patterson <andrew@fc.hp.com>
Subject: Re: Enterprise patch needed - please help
Date: 30 May 2002 08:40:16 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1022769616.2955.23.camel@lvadp.fc.hp.com>
References: <6BD67FFB937FD411A04F00D0B74FE87807C249F0@xrose06.rose.hp.com>	<1022719300.4
	 124.312.camel@irongate.swansea.linux.org.uk>
	<3CF5AEA4.4050404@metaparadigm.com>
	<1022762307.4123.364.camel@irongate.swansea.linux.org.uk>
	<3CF61E66.1050600@metaparadigm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3CF61E66.1050600@metaparadigm.com>
List-Id: linux-scsi@vger.kernel.org
To: Michael Clark <michael@metaparadigm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "HINCHMAN,PAUL  (HP-Roseville,ex1)" <paul_hinchman@hp.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

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


