From: James.Smart@Emulex.Com
Subject: RE: libata, SCSI and storage drivers
Date: Fri, 27 May 2005 10:26:11 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2062C27@xbl3.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:4291 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S261762AbVE0O0g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 10:26:36 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, dougg@torque.net, jgarzik@pobox.com
Cc: axboe@suse.de, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Also, I should note that plain ATA (no SAT) is valid in this
configuration as well.

-- james s

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Smart, James
> Sent: Friday, May 27, 2005 8:43 AM
> To: dougg@torque.net; jgarzik@pobox.com
> Cc: axboe@suse.de; James.Bottomley@SteelEye.com;
> linux-scsi@vger.kernel.org; linux-ide@vger.kernel.org
> Subject: RE: libata, SCSI and storage drivers
> 
> 
> FYI -  There is currently a standards proposal in T11 for the
> following scenario:
> 
>   c) FC HBA  <--------> FC fabric/loop <------>  SATA disk
> 
> In this case, the SAT layer could be in the FC HBA firmware or
> in the FC driver (or whatever linux transport exists).  A demo for
> this scenario was shown recently at SNW.
> 
> Also - I expect to see more and more implementations with the
> SAS Expander tightly integrated to the SAS HBA/phys.
> 
> -- james s
> 
> 
> > Jeff,
> > Yes, the SAS HBAs that I'm aware of can connect to
> > SATA I/II disks "directly" on their phys.
> > 
> > So here are two scenarios for connecting SATA disks:
> > 
> > a)
> >   SAS HBA < -------------------------> SATA disk
> > 
> > b)
> >   SAS HBA <------>SAS_expander<------> SATA disk
> > 
> > In a) the interconnect is SATA. Still it is hard
> > to believe that the SAS HBA LLD would belong to
> > anything other than the SCSI subsystem (since
> > SAS HBAs come with 4 or 8 phys, others of which could
> > be in scenario b) and/or connected to SAS disks).
> > Hence the initiator_ports/phys/target_ports on and
> > seen by that SAS HBA should (also) have SAS transport
> > classes.
> > 
> > When a SAS HBA phy is not connected to anything is it
> > a member of a SAS transport class or a ATA transport
> > class (or both)?
> > 
> > In scenario b) the left interconnect is SAS and the
> > right interconnect is SATA. The SAS_expander contains
> > the STP<->SATA bridging function (and, for sake of
> > argument, no SCSI-ATA Translation (SAT) layer).
> > Would scenario b) also have a ATA transport
> > class? I'll assume it does. To be discovered it also
> > needs a SAS transport class. Larger enclosures are
> > likely to be amplifications of scenario b). The presence
> > of the SATA disk in scenario b) will be discovered via
> > the SAS SMP (i.e. talking to the SAS_expander) or via
> > the SES protocol (i.e. a SCSI Enclosure Services target
> > running near the SAS_expander). Either way if there are
> > a lot of SATA disks then they are likely to be held
> > in their initialization sequence to stop them spinning
> > up all at once. SAS transport intervention may be
> > required (staggered timers are another possibility).
> > 
> > Now I may be wrong but I think that one of the SAS HBAs
> > that I have read about that looks (externally) like
> > scenario a) but is actually scenario b). In other words
> > the SAS_expander is silicon on the HBA and it is not
> > controlled via the PCI bus, but rather by SMP.
> > 
> > This suggests to me we would need an ordered sequence of
> > transport classes. I really wonder about trying to model
> > this level of complexity in sysfs, plus the nightmare of
> > keeping state data of (topologically) distant nodes up
> > to date. At some point one needs to supply a management
> > pass through and hand the problem over to the user
> > space. The question is, at what point.
> > 
> > 
> > There are already FCP enclosures filled with SATA disks
> > on the market so this problem in not unique to SAS.
> > However they have (I presume) a SAT layer in their
> > FC enclosures so the OS thinks it is taking to SCSI
> > disks.
> > 
> > Doug Gilbert
> > 
> > 
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe 
> > linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
