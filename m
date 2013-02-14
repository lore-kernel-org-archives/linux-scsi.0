From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] scsi: Allow 64-bit LUNs during report lun scan
Date: Thu, 14 Feb 2013 12:02:28 -0600
Message-ID: <511D26B4.6070302@tributary.com>
References: <1360767971-947-1-git-send-email-hare@suse.de>  <511BEF0B.4020302@tributary.com> <1360813101.2502.8.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.58]:30166 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758313Ab3BNSCb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2013 13:02:31 -0500
In-Reply-To: <1360813101.2502.8.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/13/2013 9:38 PM, James Bottomley wrote:
> Yes.  The two functions are simple transforms ensuring that we can pack up
> to two levels of luns into a u32 whatever address method is used.  At the
> time it was done, no array or other extant system went beyond this.
> 
> At the end of the day, a LUN is just a handle, so even if we go to 64 bits
> we're still going to be packing the address method into the logical unit
> "number".

	Ok, I will buy that (probably violates SAM5, 4.7.1, but no big deal), two
points.

	First this requires basically every adapter capable of recieving address
method!=0 LUNs to set the 64-bit capable flag that is included in this patch.
Otherwise the "scsi: %s lun%d has a LUN larger than allowed by the host
adapter\n" path fires even for a small number of luns because the address
method bit creates a "lun" > max_luns in all cases.



	Second, its possible with address method 11b, that none of the devices are
actually visible even with this patch, as a device that chooses to use address
method=11b and one of the >16 bit addressing methods gets its LSB truncated by
the 32-bit return from scsilun_to_int(). Not that I have see one of those, no
one needs that many LUNs <chuckle>. So, the flag in this patch is somewhat
misnamed as it doesn't really support 64-bit luns. To stick to the existing
method scsilun_to_int needs to be u64.


	BTW: Tiny syntax cleanup, scsilun_to_int() should have a return type of
unsigned.




-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRHSa0AAoJEL5i86xrzcy7K6oH/RBnWrpDJGt+mcvR8of6BM6y
nwtokc/GCas/RFcn1rxvayicKcqAgYGeE7PRoECvIiDoSNFacNGCvf3XQye4tF2y
IMfGZhKlndJWKUppv5ELgyzpEbh49U3XK/Vq7O2B6pB46O6Iiqz1PUWK+yZF757B
O1Q+w49FUSbq3AsPxYh4CeHj7+L+6o6mAILzl8lTgGGRkhQFr15jR1K29AUhMyyM
xCTeWw++N9Iu5ENjIdiBk0E5bQZujKBBrSpuqWnyqPzhGX74AYexkOkEiXGlEBO7
Vr31C6TBVdpOvVdXlGoR/+ZcUxju1Q9ozmdW0QEzGMvNDbax3sS0/7wSZy9bKb4=
=j5FP
-----END PGP SIGNATURE-----
