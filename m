From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Allow 64-bit LUNs during report lun scan
Date: Fri, 15 Feb 2013 08:15:54 +0100
Message-ID: <511DE0AA.4050204@suse.de>
References: <1360767971-947-1-git-send-email-hare@suse.de>  <511BEF0B.4020302@tributary.com> <1360813101.2502.8.camel@dabdike> <511D26B4.6070302@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab3BOHP4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2013 02:15:56 -0500
In-Reply-To: <511D26B4.6070302@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/14/2013 07:02 PM, Jeremy Linton wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 2/13/2013 9:38 PM, James Bottomley wrote:
>> Yes.  The two functions are simple transforms ensuring that we can p=
ack up
>> to two levels of luns into a u32 whatever address method is used.  A=
t the
>> time it was done, no array or other extant system went beyond this.
>>
>> At the end of the day, a LUN is just a handle, so even if we go to 6=
4 bits
>> we're still going to be packing the address method into the logical =
unit
>> "number".
>
> 	Ok, I will buy that (probably violates SAM5, 4.7.1, but no big deal)=
, two
> points.
>
> 	First this requires basically every adapter capable of recieving add=
ress
> method!=3D0 LUNs to set the 64-bit capable flag that is included in t=
his patch.
> Otherwise the "scsi: %s lun%d has a LUN larger than allowed by the ho=
st
> adapter\n" path fires even for a small number of luns because the add=
ress
> method bit creates a "lun" > max_luns in all cases.
>
Hehe. As we're down to nitpicking:
The 'support_64bit_luns' is a _hardware_ flag.
Some HBA hardware (SPI, and most RAID HBAs) simply do not have the=20
facilities to _send_ 64bit LUNs; SPI HBAs in most cases simply=20
reserve a byte for the LUN.

So irrespective of what response they'll be getting via REPORT_LUNS=20
they lack the possibility of addressing all of them.
And for those we need the 'max_luns' setting.

>
>
> 	Second, its possible with address method 11b, that none of the devic=
es are
> actually visible even with this patch, as a device that chooses to us=
e address
> method=3D11b and one of the >16 bit addressing methods gets its LSB t=
runcated by
> the 32-bit return from scsilun_to_int(). Not that I have see one of t=
hose, no
> one needs that many LUNs <chuckle>. So, the flag in this patch is som=
ewhat
> misnamed as it doesn't really support 64-bit luns. To stick to the ex=
isting
> method scsilun_to_int needs to be u64.
>
Correct. This I'll be addressing with a later patch, moving 'lun' to=20
full 64bit.

>
> 	BTW: Tiny syntax cleanup, scsilun_to_int() should have a return type=
 of
> unsigned.
>
Will be cleaned up with the next round of patches.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
