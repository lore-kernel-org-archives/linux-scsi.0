From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: INQUIRY always only untagged
Date: Mon, 6 Sep 2004 10:50:02 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0409061042240.6252@poirot.grange>
References: <Pine.LNX.4.60.0409040033310.5266@poirot.grange>
 <20040904140102.A15247@infradead.org> <Pine.LNX.4.60.0409050022570.3092@poirot.grange>
 <20040904233835.A18659@infradead.org> <Pine.LNX.4.60.0409051654460.3039@poirot.grange>
 <1094398979.10977.9.camel@mulgrave>  <20040905173134.A31521@infradead.org>
 <1094422949.10977.15.camel@mulgrave>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1406886627-1094460602=:6252"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:21135 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S266837AbUIFIus (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2004 04:50:48 -0400
In-Reply-To: <1094422949.10977.15.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-1406886627-1094460602=:6252
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

On Mon, 5 Sep 2004, James Bottomley wrote:

> On Sun, 2004-09-05 at 12:31, Christoph Hellwig wrote:
>> Umm yes.  But lets get the driver no oops first and then move forward.
>> There's still a lot of work to do on the driver.
>
> Well, OK.  I agree to putting a palliative fix in, since what I
> suggested will probably take more thought, but I don't think this one is
> actually it.  Mixing tagged and untagged commands is illegal under the
> SCSI spec.  Simply untagging the INQUIRY command may work to fix this
> particular bug, but I bet it will introduce others when a scsi utility
> sends an INQUIRY down to an in-use device.

I've seen this done, at least, in one more driver - 53c700.c. In its 
queuecommand it checks not to mix tagged and untagged commands, but allows 
both. That is, it checks, if there are currently (tagged) commands on the 
queue and if the new one is untagged, and if so, returns DEVICE_BUSY. So, 
it would accept an untagged command to a device, supporting tags, but 
currently having the queue empty. I am doing the same check in the latest 
version of my patch. Is it still bad?

> I think perhaps the correct palliative fix is simply to list this device
> (whatever it is, it's not listed in the bug report) as BLIST_NOTQ, then
> the problem won't arise (and of course, tmscsim would have actually to
> use the mid-layer black list rather than its own much shorter internal
> list).

I don't know what device the original reporter had, but the one I have 
here, which exibits the same behaviour, is a Seagate disk (see attached 
patch). So, if you still think, this device should not be allowed any tags 
(which is a pity, I would then again have no device with tags supported 
for tests here:-(), then, please, apply the attached patch. A patch to use 
the blacklist will follow shortly.

Thanks
Guennadi
---
Guennadi Liakhovetski

---1463811839-1406886627-1094460602=:6252
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="devinfo-seagate.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.60.0409061050020.6252@poirot.grange>
Content-Description: 
Content-Disposition: attachment; filename="devinfo-seagate.patch"

U2lnbmVkLW9mZi1ieTogR3Vlbm5hZGkgTGlha2hvdmV0c2tpIDxnLmxpYWto
b3ZldHNraUBnbXguZGU+DQoNCmRpZmYgLXUgYS9kcml2ZXJzL3Njc2kvc2Nz
aV9kZXZpbmZvLmMgYi9kcml2ZXJzL3Njc2kvc2NzaV9kZXZpbmZvLmMNCi0t
LSBhL2RyaXZlcnMvc2NzaS9zY3NpX2RldmluZm8uYwlNb24gU2VwICA2IDEw
OjM3OjA4IDIwMDQNCisrKyBiL2RyaXZlcnMvc2NzaS9zY3NpX2RldmluZm8u
YwlNb24gU2VwICA2IDEwOjM2OjMwIDIwMDQNCkBAIC0xODEsNiArMTgxLDcg
QEANCiAJeyJSRUdBTCIsICJDREMtNFgiLCBOVUxMLCBCTElTVF9NQVg1TFVO
IHwgQkxJU1RfU0lOR0xFTFVOfSwNCiAJeyJTYW5EaXNrIiwgIkltYWdlTWF0
ZSBDRi1TRDEiLCBOVUxMLCBCTElTVF9GT1JDRUxVTn0sDQogCXsiU0VBR0FU
RSIsICJTVDMzOTBOIiwgIjk1NDYiLCBCTElTVF9OT1RRfSwNCisJeyJTRUFH
QVRFIiwgIlNUMzQ1NTVOIiwgIjA5MzAiLCBCTElTVF9OT1RRfSwJLyogQ2hv
a2VzIG9uIHRhZ2dlZCBJTlFVSVJZICovDQogCXsiU0dJIiwgIlJBSUQzIiwg
IioiLCBCTElTVF9TUEFSU0VMVU59LA0KIAl7IlNHSSIsICJSQUlENSIsICIq
IiwgQkxJU1RfU1BBUlNFTFVOfSwNCiAJeyJTR0kiLCAiVFA5MTAwIiwgIioi
LCBCTElTVF9SRVBPUlRMVU4yfSwNCg==

---1463811839-1406886627-1094460602=:6252--
