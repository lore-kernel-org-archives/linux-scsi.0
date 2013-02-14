From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH] scsi: Allow 64-bit LUNs during report lun scan
Date: Thu, 14 Feb 2013 03:38:22 +0000
Message-ID: <1360813101.2502.8.camel@dabdike>
References: <1360767971-947-1-git-send-email-hare@suse.de>
	 <511BEF0B.4020302@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0.parallels.com ([199.115.104.20]:49075 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab3BNDtP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2013 22:49:15 -0500
In-Reply-To: <511BEF0B.4020302@tributary.com>
Content-Language: en-US
Content-ID: <0930F48B3033DE4199EDFB07F473DEE0@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2013-02-13 at 13:52 -0600, Jeremy Linton wrote:
> On 2/13/2013 9:06 AM, Hannes Reinecke wrote:
> > So add a new flag 'support_64bit_luns' to the scsi host and modify report
> > lun scan to not check for max_luns during scanning if that flag is set.
> > This will get rid of the
> 
> 	Along these lines, I don't think the scsilun_to_int() and int_to_scsilun()
> routines are correct for > 2^14  luns. SAM  4.6 defines bits 6,7 of byte zero
> in the LU representation format as the address method. Which when set to 00b
> limits it to 256 luns but the overflow into the bus ID probably works for some
> devices.
> 
> 	Those routines should probably select/detect an alternative address method
> for luns > 256.
> 
> 	Or am I missing something?

Yes.  The two functions are simple transforms ensuring that we can pack
up to two levels of luns into a u32 whatever address method is used.  At
the time it was done, no array or other extant system went beyond this.

At the end of the day, a LUN is just a handle, so even if we go to 64
bits we're still going to be packing the address method into the logical
unit "number".

James


James

