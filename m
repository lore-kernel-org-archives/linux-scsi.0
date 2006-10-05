From: malahal@us.ibm.com
Subject: Re: AIC94XX discovery timeout problem details...
Date: Wed, 4 Oct 2006 17:21:16 -0700
Message-ID: <20061005002116.GA16678@us.ibm.com>
References: <20060915072030.GA25595@us.ibm.com> <20060918073506.74938.qmail@web31807.mail.mud.yahoo.com> <20060919205902.GA4326@us.ibm.com> <1158701551.4170.50.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53165 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751255AbWJEAVU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2006 20:21:20 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k950LJJg028780
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 20:21:19 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k950LJBw253010
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 20:21:19 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k950LIZC004242
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 20:21:18 -0400
Content-Disposition: inline
In-Reply-To: <1158701551.4170.50.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

James, Jack Hammer from Adaptec gave us SAS analyser output.  All SMP
commands work fine, but SSP commands are sent on a PHY that is up and
updated (in the DDB0). In response, the expander tries to open
connection on a different PHY that is up but not yet updated in DDB0.
The HBA sends OPEN_REJECT(retry) and the Vitesse expander retries the
same path forever!

Thanks, Malahal.

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> However, SAS specs require us to open connections for SMP and receive
> the responses through the connection we opened.  The target is
> specifically prohibited from responding outside of this protocol
> boundary.  The theory behind this is that the Host controls port
> formation ... until we open multiple connections between the source and
> target ports, the actual connection remains narrow.  All of this should
> support the current discovery model.
> 
> I suppose the only way to confirm what's going on would be with a SAS
> analyser.  Does the host send multiple OPEN's even before the
> PORTE_BYTES_DMAED is responded to?
> 
> James
> 
