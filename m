From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Odd Behavior in the enclosure module around the 2 fault bits
Date: Thu, 01 Oct 2015 14:00:01 -0700
Message-ID: <1443733201.6886.27.camel@HansenPartnership.com>
References: <BN1PR04MB07626753646D0AB2BBD9FF9CB4E0@BN1PR04MB076.namprd04.prod.outlook.com>
	 <BN1PR04MB076C498417786FF22C034A1CB4D0@BN1PR04MB076.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45839 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753537AbbJAVAS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2015 17:00:18 -0400
In-Reply-To: <BN1PR04MB076C498417786FF22C034A1CB4D0@BN1PR04MB076.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ryan Attard <rattard@cleversafe.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2015-09-30 at 15:17 +0000, Ryan Attard wrote:
> My coworkers and I were setting some enclosure states on our storage
> devices, and then reading the states back using sysfs, and came across
> the 'fault' field being set to 2. When we investigated into the ses.c
> file, we found this  wonderful comment:
> 
> /* For device slot and array device slot elements, byte 3 bit 6
>  * is "fault sensed" while byte 3 bit 5 is "fault reqstd". As this
>  * code stands these bits are shifted 4 positions right so in
>  * sysfs they will appear as bits 2 and 1 respectively. Strange. */

This comment is thanks to Doug Gilbert:

commit 2a350cab9daf9a46322d83b091bb05cf54ccf6ab
Author: Douglas Gilbert <dgilbert@interlog.com>
Date:   Thu Jun 9 00:27:07 2011 -0400

    [SCSI] ses: requesting a fault indication


> static void ses_get_fault(struct enclosure_device *edev,
> 			  struct enclosure_component *ecomp)
> {
> 	unsigned char *desc;
> 
> 
> 	desc = ses_get_page2_descriptor(edev, ecomp);
> 	if (desc)
> 		ecomp->fault = (desc[3] & 0x60) >> 4;
> }
> 
> I was hoping there might be an explanation (purely for curiosity's
> sake) why it was not shifted 5 positions? Or why it wasn't exported as
> 2 fields in sysfs, each representing 1 bit in the SES page? 

If I remember correctly, the desire was to keep the nybble values.
Because it's not an on off field, it didn't seem to matter much whether
the fields were 0 2 4 6 or 0 1 2 3

James


