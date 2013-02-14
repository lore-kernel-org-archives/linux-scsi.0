From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH] scsi: Allow 64-bit LUNs during report lun scan
Date: Thu, 14 Feb 2013 22:04:28 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402950D58E9A@G9W0745.americas.hpqcorp.net>
References: <1360767971-947-1-git-send-email-hare@suse.de>
  <511BEF0B.4020302@tributary.com> <1360813101.2502.8.camel@dabdike>
 <511D26B4.6070302@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:19479 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758408Ab3BNWF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2013 17:05:59 -0500
In-Reply-To: <511D26B4.6070302@tributary.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>, James Bottomley <jbottomley@parallels.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Like James notes, LUNs should generally be treated as opaque values.

For example, these are all unique LUNs:
- address method 00b, bus identifier=00_0000b, target or LUN=nnh
- address method 01b, flat space LUN={00b, 0nnh}
- address method 11b, length=01b, extended address method=2h, extended flat space LUN=0000nnh
- address method 11b, length=10b, extended address method=2h, long extended flat space LUN=000000nnh

They are not four different values that provide access the same logical unit with logical unit number nnh.  The storage device might implement a access control /LUN mapping feature that does something like that, but nothing in the LUN value itself officially implies that they are related.

scsilun_to_int() does not appear to be used very much; I see 35 matches in linux-3.7-rc5. Perhaps the callers should be updated to support 64-bit LUNs and decide what to do if they cannot handle larger values.


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Jeremy Linton
> Sent: Thursday, 14 February, 2013 12:02 PM
> To: James Bottomley
> Cc: Hannes Reinecke; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH] scsi: Allow 64-bit LUNs during report lun scan
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 2/13/2013 9:38 PM, James Bottomley wrote:
> > Yes.  The two functions are simple transforms ensuring that we can pack up
> > to two levels of luns into a u32 whatever address method is used.  At the
> > time it was done, no array or other extant system went beyond this.
> >
> > At the end of the day, a LUN is just a handle, so even if we go to 64 bits
> > we're still going to be packing the address method into the logical unit
> > "number".
> 
> 	Ok, I will buy that (probably violates SAM5, 4.7.1, but no big deal), two
> points.
> 
> 	First this requires basically every adapter capable of recieving address
> method!=0 LUNs to set the 64-bit capable flag that is included in this patch.
> Otherwise the "scsi: %s lun%d has a LUN larger than allowed by the host
> adapter\n" path fires even for a small number of luns because the address
> method bit creates a "lun" > max_luns in all cases.
> 
> 
> 
> 	Second, its possible with address method 11b, that none of the devices
> are
> actually visible even with this patch, as a device that chooses to use address
> method=11b and one of the >16 bit addressing methods gets its LSB truncated
> by
> the 32-bit return from scsilun_to_int(). Not that I have see one of those, no
> one needs that many LUNs <chuckle>. So, the flag in this patch is somewhat
> misnamed as it doesn't really support 64-bit luns. To stick to the existing
> method scsilun_to_int needs to be u64.
> 
> 
> 	BTW: Tiny syntax cleanup, scsilun_to_int() should have a return type of
> unsigned.
> 
> 
> 
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (MingW32)
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
> 
> iQEcBAEBAgAGBQJRHSa0AAoJEL5i86xrzcy7K6oH/RBnWrpDJGt+mcvR8of6BM6y
> nwtokc/GCas/RFcn1rxvayicKcqAgYGeE7PRoECvIiDoSNFacNGCvf3XQye4tF2y
> IMfGZhKlndJWKUppv5ELgyzpEbh49U3XK/Vq7O2B6pB46O6Iiqz1PUWK+yZF757B
> O1Q+w49FUSbq3AsPxYh4CeHj7+L+6o6mAILzl8lTgGGRkhQFr15jR1K29AUhMyy
> M
> xCTeWw++N9Iu5ENjIdiBk0E5bQZujKBBrSpuqWnyqPzhGX74AYexkOkEiXGlEBO7
> Vr31C6TBVdpOvVdXlGoR/+ZcUxju1Q9ozmdW0QEzGMvNDbax3sS0/7wSZy9bKb
> 4=
> =j5FP
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
