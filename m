From: Joe Carnuccio <joe.carnuccio@qlogic.com>
Subject: RE: [PATCH 10/15] qla2xxx: Perform an implicit login to the
	Management Server.
Date: Tue, 7 Apr 2009 08:24:01 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA846518F15EB@AVEXMB1.qlogic.org>
References: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
 <1239082431-19496-11-git-send-email-andrew.vasquez@qlogic.com>
 <20090407150255.GA29910@mars.virtualiron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:23114 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761342AbZDGPYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 11:24:18 -0400
In-Reply-To: <20090407150255.GA29910@mars.virtualiron.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Konrad Rzeszutek' <konrad@virtualiron.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, David Wagner <david.wagner@qlogic.com>

The implied login works as follows:
if the port is not already logged in, then log it in, else leave as is;

so, if the port is not already logged in, the implied login logs it in;
if the port was already logged in, the implied login sees this and leaves it alone;

there are conditions that cause the management_server_logged_in flag to be turned off...
but the management server is not necessarily logged out (it stays logged in)...
so doing an implicit login minimizes the work done between the HBA and the fabric switch.
 

> -----Original Message-----
> From: Konrad Rzeszutek [mailto:konrad@virtualiron.com] 
> Sent: Tuesday, April 07, 2009 8:03 AM
> To: Andrew Vasquez
> Cc: James Bottomley; Giridhar Malavali; Linux SCSI Mailing 
> List; Joe Carnuccio
> Subject: Re: [PATCH 10/15] qla2xxx: Perform an implicit login 
> to the Management Server.
> 
> On Mon, Apr 06, 2009 at 10:33:46PM -0700, Andrew Vasquez wrote:
> > From: Joe Carnuccio <joe.carnuccio@qlogic.com>
> > 
> > Set the conditional plogi option bit whenever logging in the fabric 
> > management server (if it is already logged in, it does not need an 
> > explicit login; an implicit login suffices).
> 
> How does one find out if it already has logged in? Obviously 
> this routine is used during the initialization for the 
> driver, which implies that the firmware has done the job of 
> logging already, right? Wouldn't the 
> management_server_logged_in flag be set somewhere by the 
> login code, say by the asynchronous updates?
