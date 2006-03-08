From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Wed, 08 Mar 2006 09:15:25 -0600
Message-ID: <1141830925.3194.10.camel@mulgrave.il.steeleye.com>
References: <8C064C48AB104B428CBA524C342357CA34CFCB@aime2k05.adaptec.com>
	 <1141445373.5397.23.camel@mulgrave.il.steeleye.com>
	 <20060306193555.GA2316@us.ibm.com>
	 <1141674628.3167.31.camel@mulgrave.il.steeleye.com>
	 <1141692292.8649.75.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:27296 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750716AbWCHPPe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Mar 2006 10:15:34 -0500
In-Reply-To: <1141692292.8649.75.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: Mike Anderson <andmike@us.ibm.com>, "Tarte, Robert" <Robert_Tarte@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2006-03-06 at 16:44 -0800, Alexis Bruemmer wrote:
> Well the problems I have seen when testing your tree, as well as the
> original aic94xx/sas_class tree, is that the aic94xx driver enables phys
> before the upper level sas layer has discover all phys and ports.
> (again please see the boot dump I posted on Friday). 

Actually, this code is a much more complex way of doing what I just did
with the work queues.  The only difference is this:

> +	wait_for_completion(&asd_ha->sas_ha.discover_phy);
> +
>  	ASD_DPRINTK("enabled phys\n");

Which shows that the current scsi_flush_work() is in the wrong place.
If you move it out of sas_init.c and into aic94xx_init.c at this place,
I think you'll find everything now works for you.

James


