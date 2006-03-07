From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [RFC] first cut at infrastructure for handling differentdevicetypes in the sas class
Date: Mon, 6 Mar 2006 18:09:45 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F34BB4E@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:22679 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932579AbWCGBJs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Mar 2006 20:09:48 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Monday, March 06, 2006 9:39 AM, James Bottomley wrote:

> 
> Well, it's not ... the nexus loss timeout parameters weren't 
> available.
> The intent is to embed the rphys into more representative structures
> that can have different parameters (an expander has parameters than an
> end device doesn't and vice versa).  Eventually, when the whole lot is
> converted, the ability to alloc a plain rphy will be revoked and
> everything will be done via the real device type.
> 

Christoph mentioned in other email about adding sas_end_device, 
sas_expander, and sas_sata_device, which is fine.   I'm interested 
in the changes you forsee, as we need to make plans for that in mptsas. 
As long as these changes are not breaking the driver....


> The aic94xx needs a full tree representation for this, so I'm planning
> to add this to the sas transport class.  We really need to work out a
> way for mptsas to display the tree too.  Having different 
> topology views
> for the same physical SAS topology show up when you change 
> HBA is a bit
> undesirable.
> 

Agreed.  We need to display same tree.   

> Yes, I know.  However, I need expander devices that contain the
> necessary information to be able to perform discovery in the sas
> transport class, so they'll appear eventually in the same way 
> that this
> patch adds end devices ... as objects with embedded rphys.
> 

Ok, define discovery.  I hope that doesn't mean the transport layer is
sending SMP passthru commands to the driver?  Recall, concerns from our 
architect over the performance hit?  They recommend to me that we
providing the topology data via config pages. 


