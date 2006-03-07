From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [RFC] first cut at infrastructure for handling
	differentdevicetypes in the sas class
Date: Tue, 07 Mar 2006 09:58:52 -0600
Message-ID: <1141747132.3239.18.camel@mulgrave.il.steeleye.com>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F34BB4E@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:63208 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750801AbWCGP7F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Mar 2006 10:59:05 -0500
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F34BB4E@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2006-03-06 at 18:09 -0700, Moore, Eric wrote:
> Christoph mentioned in other email about adding sas_end_device, 
> sas_expander, and sas_sata_device, which is fine.   I'm interested 
> in the changes you forsee, as we need to make plans for that in mptsas. 
> As long as these changes are not breaking the driver....

It's basically just adding extra parameters.  You can see roughly what
they all are in the aic94xx tree (struct expander_device)

> Ok, define discovery.  I hope that doesn't mean the transport layer is
> sending SMP passthru commands to the driver?  Recall, concerns from our 
> architect over the performance hit?  They recommend to me that we
> providing the topology data via config pages. 

Discovery is the process of enumerating connected devices.  The
transport layer will have to issue SMPs to do it, since that's the only
defined way.  However, I don't envisage making discovery mandatory; it's
going to be in the adjunct class or library, so mptsas can just make the
topology appear based on the SMP discovery done by the firmware.

Christoph's working on the needs of mptsas, but it looks like most of
the necessary information can be obtained from the firmware pages
(except really the stuff we get from SMP_REPORT_MANUFACTURER_INFO,
which, I think, even mptsas can stand).

Out of this also will come the user visible SMP tap, which certain OEMs
have already requested to interrogate expanders .. this, I think, is
unavoidable.

James


