From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: Allow 64-bit LUNs during report lun scan
Date: Wed, 13 Feb 2013 21:21:31 +0100
Message-ID: <511BF5CB.2030202@acm.org>
References: <1360767971-947-1-git-send-email-hare@suse.de> <511BEF0B.4020302@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:44727 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3BMUVe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2013 15:21:34 -0500
In-Reply-To: <511BEF0B.4020302@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>

On 02/13/13 20:52, Jeremy Linton wrote:
> On 2/13/2013 9:06 AM, Hannes Reinecke wrote:
>> So add a new flag 'support_64bit_luns' to the scsi host and modify report
>> lun scan to not check for max_luns during scanning if that flag is set.
>> This will get rid of the
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

I think the LUN-to-int translation should depend on the LUN addressing 
method supported by the target. SAM-5 defines the following LUN 
addressing methods:
a) peripheral device addressing method;
b) flat space addressing method;
c) logical unit addressing method,
d) extended logical unit addressing method;
e) long extended logical unit addressing method.

scsilun_to_int() does the translation correctly for some of these 
addressing methods but not for all of them.

Bart.

