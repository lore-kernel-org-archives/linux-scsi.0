From: "Czerkowicz, John" <john.czerkowicz@hp.com>
Subject: RE: RE: [PATCH] 2.4.26 scsi_scan.c Blacklist Entries
Date: Tue, 20 Apr 2004 09:14:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <F65B33CAD23A284EAE6E4AE353BF94DC031A44D2@tayexc13.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zmamail05.zma.compaq.com ([161.114.64.105]:32265 "EHLO
	zmamail05.zma.compaq.com") by vger.kernel.org with ESMTP
	id S262766AbUDTNO0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2004 09:14:26 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>

Hi Kurt,

I agree...  Thank you for the explanation!

Regards,
John 

-----Original Message-----
From: Kurt Garloff [mailto:garloff@suse.de] 
Sent: Monday, April 19, 2004 9:54 AM
To: Czerkowicz, John
Cc: Linux SCSI list
Subject: Re: RE: [PATCH] 2.4.26 scsi_scan.c Blacklist Entries

Hi John,

On Mon, Apr 19, 2004 at 09:25:16AM -0400, Czerkowicz, John wrote:
> These devices have a tape drive at LUN 0 and a loader device at LUN 1.
> Without this patch, only the tape drive at LUN 0 is detected.  After 
> applying this patch, both the drive and loader are detected.

LUN 1 should just be detected without blacklist entry.

Here's how Linux-2.6 scans:
* Send INQUIRY to LUN 0, if it fails we skip this device
* If it's SCSI-3, try REPORT_LUNS, if it succeeds, use results,
  otherwise continue with sequential scanning:
* Limit the number of possible LUNs from shost->max)luns dow to
  - max_scsi_luns (unless BLIST_FORCELUN or BLIST_SPARELUN are set)
  - limit to 5 if BLIST_MAX5LUN is set
  - limit to 8 if device is <= SCSI-2 and BLIST_LARGELUN is not set
* Scan sequentially, stop after the first non-existing device unless
  BLIST_SPARSELUN is set.

As you can see, BLIST_FORCELUN is only used at one place.
This leaves only one conclusion:
Your kernel is misconfigured:
  * You passed max_luns=1 boot/module parameter
  * Your kernel configuration is broken as CONFIG_SCSI_MULTI_LUN is 
    not set

Later 2.4 kernels work in a similar way, except that REPORT_LUNS is not
used. (Well it is used in the SUSE 2.4 kernel, but that's a different
story.)

I see no possibility to use BLIST_FORCELUN in a meaningful way.
If you need it to override max_luns=1 (or unset CONFIG_SCSI_MULTI_LUN)
that setting is the error in the first place, IMVHO.

Regards,
-- 
Kurt Garloff  <garloff@suse.de>                            Cologne, DE 
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)
