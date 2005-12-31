From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a
	new	version of iscsi target?
Date: Sat, 31 Dec 2005 09:33:42 -0600
Message-ID: <1136043222.3538.5.camel@mulgrave>
References: <43987F75.2000301@vlnb.net> <4398850D.8070102@cs.wisc.edu>
	 <1134071290.3259.31.camel@mulgrave>
	 <20051227085340L.fujita.tomonori@lab.ntt.co.jp>
	 <1135787528.3854.10.camel@mulgrave>  <43B5FAA1.9000800@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:59363 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964991AbVLaPed (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 Dec 2005 10:34:33 -0500
In-Reply-To: <43B5FAA1.9000800@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, vst@vlnb.net, johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt-devel@lists.berlios.de, WRWHITEHEAD@novell.com, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, hch@infradead.org

On Fri, 2005-12-30 at 21:27 -0600, Mike Christie wrote:
> > Yes, that looks fine ... it runs in user space, which was really all I
> > was looking for.
> > 
> > There is another half to this, which is that I'd like the tap to come
> > via a SCSI API.  This isn't strictly necessary for iSCSI but it would
> > allow us to integrate a generic target approach that could work for all
> > SCSI HBA's as well as just iSCSI.
> > 
> 
> The code we currently have is designed to work with software iscsi 
> targets or software AoE and HW cards like qlogic or emulex's FC cards. 
> There are a lot of places we could use scsi-ml or block layer structs 
> like the request or scsi_cmnd.
> 
> To support HW like qlogic or emulex's FC target mode, are you thinking 
> you might want us to add on to the scsi-ml's scsi_host_template or add a 
> scsi_target_template? If we add on to the scsi_host_template and if that 
> one PCI device would be in initiator and target mode at the same time 
> would we have one scsi_host for that resource and just add our target 
> related fields to the scsi_host? Is this what you mean?

I'm thinking one device would do both intiator and target (although not
at the same time, but probably via some sort of internal role change
mechanism---Although that would be up to the driver writer; it could
certainly be set up to be initiator or target only) we probably need one
or two additional callbacks for sending incoming commands upwards and a
control channel for specifying what we do next (since for write
commands, we need command first, then userspace processing and setup
then body into allocated buffer).  The idea is that at the end of the
project we have a well defined target infrastructure for any SCSI device
(with an iSCSI reference implementation).

James


