From: Ingo Flaschberger <if@xip.at>
Subject: Re: Compaq Fiber Channel Array RM4000 / 2.6.16 kernel patch
Date: Thu, 30 Mar 2006 16:20:25 +0200 (CEST)
Message-ID: <Pine.GSO.4.64.0603301523130.6412@filebunker.xip.at>
References: <1143653396.3248.34.camel@mulgrave.il.steeleye.com>
 <Pine.GSO.4.64.0603291949370.4009@filebunker.xip.at>
 <1143656547.3248.36.camel@mulgrave.il.steeleye.com>
 <Pine.GSO.4.64.0603292025500.4009@filebunker.xip.at>
 <1143657838.3248.39.camel@mulgrave.il.steeleye.com>
 <Pine.GSO.4.64.0603292052430.4009@filebunker.xip.at>
 <1143659029.3248.42.camel@mulgrave.il.steeleye.com>
 <Pine.GSO.4.64.0603292125370.4009@filebunker.xip.at>
 <1143666681.3248.48.camel@mulgrave.il.steeleye.com>
 <Pine.GSO.4.64.0603301252100.595@filebunker.xip.at> <20060330125816.GG13590@parisc-linux.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-559023410-758783491-1143728425=:6412"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.xip.at ([193.239.188.99]:13223 "EHLO chile.gbit.at")
	by vger.kernel.org with ESMTP id S932225AbWC3OU1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Mar 2006 09:20:27 -0500
In-Reply-To: <20060330125816.GG13590@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---559023410-758783491-1143728425=:6412
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

Hello Matthew,

> On Thu, Mar 30, 2006 at 12:53:10PM +0200, Ingo Flaschberger wrote:
>>   *  out_of_space hacks, D. Gilbert (dpg) 990608
>> + *
>> + *  Added Compaq RA4x00 Fiber Channel Array support, 29.03.2006
>> + *	crossip communications gmbh - Ingo Flaschberger <if@xip.at>
>> + *
>>   */
>
> I think you can drop the changelog entry here -- it's not been updated
> in many years.  Plus, it's not really accurate.

OK.

>>  	{"CNSi", "G8324", NULL, BLIST_SPARSELUN},	/* Chaparral G8324 RAID */
>> +	{"COMPAQ", "ARRAY CONTROLLER", "2.60", BLIST_SPARSELUN | BLIST_LARGELUN |
>> +		BLIST_MAX_512K}, /* Compaq RA4x00 */
>> +	{"COMPAQ", "LOGICAL VOLUME", "2.60", BLIST_MAX_512K}, /* Compaq RA4x00 */
>>  	{"COMPAQ", "LOGICAL VOLUME", NULL, BLIST_FORCELUN},
>
> I wonder if you should just be adding BLIST_MAX_512K to the current
> entry for LOGICAL VOLUME instead?

The "LOGICAL VOLUME" was there before and I think I will break the SCSI 
Version.

>>   * 		or a LUN is seen that cannot have a device attached to it.
>> + *
>> + * Modification history:
>> + * 	- Added Compaq RA4x00 Fiber Channel Array support, 29.03.2006
>> + *		crossip communications gmbh - Ingo Flaschberger <if@xip.at>
>> + *
>>   */
>
> Definitely don't start a changelog.  That's what SCMs are for.

OK.

>> @@ -715,6 +721,14 @@
>>  	if (*bflags & BLIST_SELECT_NO_ATN)
>>  		sdev->select_no_atn = 1;
>>
>> +        /*
>> +        * Maximum 512K cdb transfer length
>> +        * broken RA4x00 Compaq Disk Array
>> +        */
>> +        if (*bflags & BLIST_MAX_512K) {
>> +                sdev->max_512k = 1;
>> +        }
>> +
>
> Indent with tabs, not spaces.  Also, sdev->max_512k is a bit ...
> specific.  How about adding an unsigned short to struct scsi_device
> (right above queue_depth, so it fits in the padding) called something
> like max_xfer_len?  Then you can do something like:
>
> 	sdev->max_xfer_len = 0xffff;
> 	if (*bflags & BLIST_MAX_512K)
> 		sdev->max_xfer_len = 0x200;

Ups.. standard problem..(
sdev->max_xfer_len is a good idea.

> and later:
>
>> @@ -344,8 +346,14 @@
>>  		SCpnt->cmnd[14] = SCpnt->cmnd[15] = 0;
>>  	} else if ((this_count > 0xff) || (block > 0x1fffff) ||
>>  		   SCpnt->device->use_10_for_rw) {
>> -		if (this_count > 0xffff)
>> -			this_count = 0xffff;
>> +		if (SCpnt->device->max_512k) {
>> +			if (this_count > 0x200) {
>> +				this_count = 0x200;
>> +			}
>> +		} else {
>> +			if (this_count > 0xffff)
>> +				this_count = 0xffff;
>> +		}
>>
>>  		SCpnt->cmnd[0] += READ_10 - READ_6;
>>  		SCpnt->cmnd[1] |= blk_fua_rq(rq) ? 0x8 : 0;
>
> simplifies to:
>
> 	if (this_count > SCpnt->device->max_xfer_len)
> 		this_count = SCpnt->device->max_xfer_len;
>
>> @@ -1089,9 +1103,12 @@
>>  	 * support more than 8 LUNs.
>>  	 */
>>  	if ((bflags & BLIST_NOREPORTLUN) ||
>> -	     starget->scsi_level < SCSI_2 ||
>> -	    (starget->scsi_level < SCSI_3 &&
>> -	     (!(bflags & BLIST_REPORTLUN2) || shost->max_lun <= 8)) )
>> +            ((starget->scsi_level < SCSI_2) &&
>> +            (starget->scsi_level != SCSI_UNKNOWN)) ||
>> +            (starget->scsi_level < SCSI_3 &&
>> +            ((!(bflags & BLIST_REPORTLUN2) &&
>> +	    (starget->scsi_level != SCSI_UNKNOWN)) ||
>> +	    shost->max_lun <= 8)) )
>>  		return 1;
>
> That conditional makes my brain hurt.  Can we split it up?
>
> 	if ((bflags & BLIST_NOREPORTLUN)
> 		return 1;
> 	if ((starget->scsi_level < SCSI_2) &&
> 			(starget->scsi_level != SCSI_UNKNOWN))
> 		return 1;
> 	if ((starget->scsi_level < SCSI_3) &&
> 	    ((!(bflags & BLIST_REPORTLUN2) &&
> 	      (starget->scsi_level != SCSI_UNKNOWN) ||
> 	      shost->max_lun <= 8)))
> 	      	return 1;

Shure.

> I'm not sure that's what you meant to do, even.  How about more simply:
>
> 	/*
> 	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
> 	 * Also allow SCSI-2 and unknown devices if BLIST_REPORTLUN2 is set
> 	 * and host adapter supports more than 8 LUNs.
> 	 */
> 	if ((bflags & BLIST_NOREPORTLUN)
> 		return 1;
> 	if ((starget->scsi_level < SCSI_2) &&
> 			(starget->scsi_level != SCSI_UNKNOWN))
> 		return 1;
> 	if ((starget->scsi_level < SCSI_3) &&
> 			(!(bflags & BLIST_REPORTLUN2) || shost->max_lun <= 8))
> 		return 1;
>
>

Attached,, new patch version 3....


bye,
 	Ingo
---559023410-758783491-1143728425=:6412
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=RA4x00_linux_2.6.16_ver3.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.GSO.4.64.0603301620250.6412@filebunker.xip.at>
Content-Description: 
Content-Disposition: attachment; filename=RA4x00_linux_2.6.16_ver3.patch

ZGlmZiAtciAtdSBsaW51eC0yLjYuMTZfb3JnL0RvY3VtZW50YXRpb24vc2Nz
aS9SQTR4MDAudHh0IGxpbnV4LTIuNi4xNi9Eb2N1bWVudGF0aW9uL3Njc2kv
UkE0eDAwLnR4dA0KLS0tIGxpbnV4LTIuNi4xNl9vcmcvRG9jdW1lbnRhdGlv
bi9zY3NpL1JBNHgwMC50eHQJMjAwNi0wMy0zMCAwMDoxOTozMi4wMDAwMDAw
MDAgKzAyMDANCisrKyBsaW51eC0yLjYuMTYvRG9jdW1lbnRhdGlvbi9zY3Np
L1JBNHgwMC50eHQJMjAwNi0wMy0yOSAyMDozNToxNy4wMDAwMDAwMDAgKzAy
MDANCkBAIC0wLDAgKzEsMjAgQEANCitDb21wYXEgUkE0eDAwIEZpYmVyIENo
YW5uZWwgQXJyYXkgc3VwcG9ydAlpZkB4aXAuYXQgMjkuMDMuMjAwNg0KKwkJ
CQkJCWNyb3NzaXAgY29tbXVuaWNhdGlvbnMgZ21iaA0KKw0KK0luIDIuNC54
IGxpbnV4IGtlcm5lbHMgdGhlIGNwcWZjIGRyaXZlciBzdXBwb3J0ZWQgdGhl
IENvbXBhcSBSQTR4MDAgRmliZXIgDQorQ2hhbm5lbCBBcnJheS4gTGltaXRh
dGlvbiBpbiAyLjQueCBrZXJuZWxzIHdhcyB0aGF0IHRoZSBSQTR4MDAgb25s
eSB3b3JrZWQgd2l0aA0KK2EgY3BxZmMgc3VwcG9ydGVkIGZpYmVyIGNoYW5u
ZWwgYWRhcHRlciAoVGFjaHlvbiBjaGlwc2V0KS4NCisNCitJbiAyLjYueCBs
aW51eCBrZXJuZWxzIHRoZSBzdXBwb3J0IGZvciB0aGUgY3BxZmMgaGFzIGJl
ZW4gZHJvcHBlZCBiZWNhdXNlIG9mDQordmVyeSBhd2Z1bCBjb2RlIGFuZCBy
ZXN1bHRpbmcgcG9ydGluZyBwcm9ibGVtcyBmcm9tIDIuNC54IHRvIDIuNi54
Lg0KKw0KK1N1cHBvcnQgZm9yIHRoZSBSQTR4MDAgaXMgbm93IGRpcmVjdGx5
IGluIHRoZSBsaW51eCBrZXJuZWwgYnV0IG5lZWQgc29tZQ0KK3NwZWNpYWwg
Y29uZmlndXJhdGlvbjoNCisqKSBVc2UgYSBhbHJlYWR5IHN1cHBvcnRlZCBm
aWJlciBjaGFubmVsIGNhcmRzDQorKikgVXBkYXRlIHRoZSBSQTR4MDAgdG8g
ZmlybXdhcmUgdmVyc2lvbiAyLjYwDQorKikgTG9hZCB0aGUgc2NzaV9tb2Qg
bW9kdWxlcyB3aXRoIG9wdGlvbjogbWF4X2x1bnM9NDI5NDk2NzI5NQ0KKw0K
Kw0KK01vcmUgaW5mb3JtYXRpb24gYWJvdXQgdGhlIFJBNHgwMCBjb3VsZCBi
ZSBmb3VuZDoNCitodHRwOi8vaHAuY29tDQoraHR0cDovL3JhNHgwMC54aXAu
YXQNCmRpZmYgLXIgLXUgbGludXgtMi42LjE2X29yZy9kcml2ZXJzL3Njc2kv
c2NzaS5jIGxpbnV4LTIuNi4xNi9kcml2ZXJzL3Njc2kvc2NzaS5jDQotLS0g
bGludXgtMi42LjE2X29yZy9kcml2ZXJzL3Njc2kvc2NzaS5jCTIwMDYtMDMt
MjAgMDY6NTM6MjkuMDAwMDAwMDAwICswMTAwDQorKysgbGludXgtMi42LjE2
L2RyaXZlcnMvc2NzaS9zY3NpLmMJMjAwNi0wMy0zMCAxNzoyOToyNi4wMDAw
MDAwMDAgKzAyMDANCkBAIC01NjcsNyArNTY3LDcgQEANCiAJLyogDQogCSAq
IElmIFNDU0ktMiBvciBsb3dlciwgc3RvcmUgdGhlIExVTiB2YWx1ZSBpbiBj
bW5kLg0KIAkgKi8NCi0JaWYgKGNtZC0+ZGV2aWNlLT5zY3NpX2xldmVsIDw9
IFNDU0lfMikgew0KKwlpZiAoKGNtZC0+ZGV2aWNlLT5zY3NpX2xldmVsIDw9
IFNDU0lfMikgJiYgKGNtZC0+ZGV2aWNlLT5zY3NpX2xldmVsICE9IFNDU0lf
VU5LTk9XTikpIHsNCiAJCWNtZC0+Y21uZFsxXSA9IChjbWQtPmNtbmRbMV0g
JiAweDFmKSB8DQogCQkJICAgICAgIChjbWQtPmRldmljZS0+bHVuIDw8IDUg
JiAweGUwKTsNCiAJfQ0KZGlmZiAtciAtdSBsaW51eC0yLjYuMTZfb3JnL2Ry
aXZlcnMvc2NzaS9zY3NpX2RldmluZm8uYyBsaW51eC0yLjYuMTYvZHJpdmVy
cy9zY3NpL3Njc2lfZGV2aW5mby5jDQotLS0gbGludXgtMi42LjE2X29yZy9k
cml2ZXJzL3Njc2kvc2NzaV9kZXZpbmZvLmMJMjAwNi0wMy0yMCAwNjo1Mzoy
OS4wMDAwMDAwMDAgKzAxMDANCisrKyBsaW51eC0yLjYuMTYvZHJpdmVycy9z
Y3NpL3Njc2lfZGV2aW5mby5jCTIwMDYtMDMtMzAgMTQ6MzM6NTQuMDAwMDAw
MDAwICswMjAwDQpAQCAtMTMyLDYgKzEzMiw5IEBADQogCXsiQ01EIiwgIkNS
QS03MjgwIiwgTlVMTCwgQkxJU1RfU1BBUlNFTFVOfSwJLyogQ01EIFJBSUQg
Q29udHJvbGxlciAqLw0KIAl7IkNOU0kiLCAiRzczMjQiLCBOVUxMLCBCTElT
VF9TUEFSU0VMVU59LAkvKiBDaGFwYXJyYWwgRzczMjQgUkFJRCAqLw0KIAl7
IkNOU2kiLCAiRzgzMjQiLCBOVUxMLCBCTElTVF9TUEFSU0VMVU59LAkvKiBD
aGFwYXJyYWwgRzgzMjQgUkFJRCAqLw0KKwl7IkNPTVBBUSIsICJBUlJBWSBD
T05UUk9MTEVSIiwgIjIuNjAiLCBCTElTVF9TUEFSU0VMVU4gfCBCTElTVF9M
QVJHRUxVTiB8DQorCQlCTElTVF9NQVhfNTEyS30sIC8qIENvbXBhcSBSQTR4
MDAgKi8NCisJeyJDT01QQVEiLCAiTE9HSUNBTCBWT0xVTUUiLCAiMi42MCIs
IEJMSVNUX01BWF81MTJLfSwgLyogQ29tcGFxIFJBNHgwMCAqLw0KIAl7IkNP
TVBBUSIsICJMT0dJQ0FMIFZPTFVNRSIsIE5VTEwsIEJMSVNUX0ZPUkNFTFVO
fSwNCiAJeyJDT01QQVEiLCAiQ1IzNTAwIiwgTlVMTCwgQkxJU1RfRk9SQ0VM
VU59LA0KIAl7IkNPTVBBUSIsICJNU0ExMDAwIiwgTlVMTCwgQkxJU1RfU1BB
UlNFTFVOIHwgQkxJU1RfTk9TVEFSVE9OQUREfSwNCmRpZmYgLXIgLXUgbGlu
dXgtMi42LjE2X29yZy9kcml2ZXJzL3Njc2kvc2NzaV9zY2FuLmMgbGludXgt
Mi42LjE2L2RyaXZlcnMvc2NzaS9zY3NpX3NjYW4uYw0KLS0tIGxpbnV4LTIu
Ni4xNl9vcmcvZHJpdmVycy9zY3NpL3Njc2lfc2Nhbi5jCTIwMDYtMDMtMjAg
MDY6NTM6MjkuMDAwMDAwMDAwICswMTAwDQorKysgbGludXgtMi42LjE2L2Ry
aXZlcnMvc2NzaS9zY3NpX3NjYW4uYwkyMDA2LTAzLTMwIDE4OjA4OjU5LjAw
MDAwMDAwMCArMDIwMA0KQEAgLTY0Nyw2ICs2NDcsNyBAQA0KIAljYXNlIFRZ
UEVfTUVESVVNX0NIQU5HRVI6DQogCWNhc2UgVFlQRV9FTkNMT1NVUkU6DQog
CWNhc2UgVFlQRV9DT01NOg0KKwljYXNlIFRZUEVfUkFJRDoNCiAJY2FzZSBU
WVBFX1JCQzoNCiAJCXNkZXYtPndyaXRlYWJsZSA9IDE7DQogCQlicmVhazsN
CkBAIC03MTYsNiArNzE3LDE1IEBADQogCQlzZGV2LT5zZWxlY3Rfbm9fYXRu
ID0gMTsNCiANCiAJLyoNCisJKiBNYXhpbXVtIDUxMksgY2RiIHRyYW5zZmVy
IGxlbmd0aA0KKwkqIGJyb2tlbiBSQTR4MDAgQ29tcGFxIERpc2sgQXJyYXkN
CisJKi8NCisJc2Rldi0+bWF4X3hmZXJfbGVuID0gMHhmZmZmOw0KKwlpZiAo
KmJmbGFncyAmIEJMSVNUX01BWF81MTJLKSB7DQorCQlzZGV2LT5tYXhfeGZl
cl9sZW4gPSAweDIwMDsNCisJfQ0KKw0KKwkvKg0KIAkgKiBTb21lIGRldmlj
ZXMgbWF5IG5vdCB3YW50IHRvIGhhdmUgYSBzdGFydCBjb21tYW5kIGF1dG9t
YXRpY2FsbHkNCiAJICogaXNzdWVkIHdoZW4gYSBkZXZpY2UgaXMgYWRkZWQu
DQogCSAqLw0KQEAgLTEwODgsMTAgKzEwOTgsMTUgQEANCiAJICogQWxzbyBh
bGxvdyBTQ1NJLTIgaWYgQkxJU1RfUkVQT1JUTFVOMiBpcyBzZXQgYW5kIGhv
c3QgYWRhcHRlciBkb2VzDQogCSAqIHN1cHBvcnQgbW9yZSB0aGFuIDggTFVO
cy4NCiAJICovDQotCWlmICgoYmZsYWdzICYgQkxJU1RfTk9SRVBPUlRMVU4p
IHx8IA0KLQkgICAgIHN0YXJnZXQtPnNjc2lfbGV2ZWwgPCBTQ1NJXzIgfHwN
Ci0JICAgIChzdGFyZ2V0LT5zY3NpX2xldmVsIDwgU0NTSV8zICYmIA0KLQkg
ICAgICghKGJmbGFncyAmIEJMSVNUX1JFUE9SVExVTjIpIHx8IHNob3N0LT5t
YXhfbHVuIDw9IDgpKSApDQorCWlmIChiZmxhZ3MgJiBCTElTVF9OT1JFUE9S
VExVTikNCisJCXJldHVybiAxOw0KKwlpZiAoKHN0YXJnZXQtPnNjc2lfbGV2
ZWwgPCBTQ1NJXzIpICYmDQorCQkJKHN0YXJnZXQtPnNjc2lfbGV2ZWwgIT0g
U0NTSV9VTktOT1dOKSkNCisJCXJldHVybiAxOw0KKwlpZiAoc3RhcmdldC0+
c2NzaV9sZXZlbCA8IFNDU0lfMyAmJg0KKwkJCSgoIShiZmxhZ3MgJiBCTElT
VF9SRVBPUlRMVU4yKSAmJg0KKwkJCShzdGFyZ2V0LT5zY3NpX2xldmVsICE9
IFNDU0lfVU5LTk9XTikpIHx8DQorCQkJc2hvc3QtPm1heF9sdW4gPD0gOCkp
DQogCQlyZXR1cm4gMTsNCiAJaWYgKGJmbGFncyAmIEJMSVNUX05PTFVOKQ0K
IAkJcmV0dXJuIDA7DQpkaWZmIC1yIC11IGxpbnV4LTIuNi4xNl9vcmcvZHJp
dmVycy9zY3NpL3NkLmMgbGludXgtMi42LjE2L2RyaXZlcnMvc2NzaS9zZC5j
DQotLS0gbGludXgtMi42LjE2X29yZy9kcml2ZXJzL3Njc2kvc2QuYwkyMDA2
LTAzLTIwIDA2OjUzOjI5LjAwMDAwMDAwMCArMDEwMA0KKysrIGxpbnV4LTIu
Ni4xNi9kcml2ZXJzL3Njc2kvc2QuYwkyMDA2LTAzLTMwIDE4OjEwOjEyLjAw
MDAwMDAwMCArMDIwMA0KQEAgLTIyLDYgKzIyLDggQEANCiAgKgkgLSBCYWRh
cmkgUHVsYXZhcnR5IDxwYmFkYXJpQHVzLmlibS5jb20+LCBNYXR0aGV3IFdp
bGNveCANCiAgKgkgICA8d2lsbHlAZGViaWFuLm9yZz4sIEt1cnQgR2FybG9m
ZiA8Z2FybG9mZkBzdXNlLmRlPjogDQogICoJICAgU3VwcG9ydCAzMmsvMU0g
ZGlza3MuDQorICoJIC0gQWRkZWQgQ29tcGFxIFJBNHgwMCBGaWJlciBDaGFu
bmVsIEFycmF5IHN1cHBvcnQsIDI5LjAzLjIwMDYNCisgKgkgICBjcm9zc2lw
IGNvbW11bmljYXRpb25zIGdtYmggLSBJbmdvIEZsYXNjaGJlcmdlciA8aWZA
eGlwLmF0Pg0KICAqDQogICoJTG9nZ2luZyBwb2xpY3kgKG5lZWRzIENPTkZJ
R19TQ1NJX0xPR0dJTkcgZGVmaW5lZCk6DQogICoJIC0gc2V0dGluZyB1cCB0
cmFuc2ZlcjogU0NTSV9MT0dfSExRVUVVRSBsZXZlbHMgMSBhbmQgMg0KQEAg
LTM0NCw4ICszNDYsOCBAQA0KIAkJU0NwbnQtPmNtbmRbMTRdID0gU0NwbnQt
PmNtbmRbMTVdID0gMDsNCiAJfSBlbHNlIGlmICgodGhpc19jb3VudCA+IDB4
ZmYpIHx8IChibG9jayA+IDB4MWZmZmZmKSB8fA0KIAkJICAgU0NwbnQtPmRl
dmljZS0+dXNlXzEwX2Zvcl9ydykgew0KLQkJaWYgKHRoaXNfY291bnQgPiAw
eGZmZmYpDQotCQkJdGhpc19jb3VudCA9IDB4ZmZmZjsNCisJCWlmICh0aGlz
X2NvdW50ID4gU0NwbnQtPmRldmljZS0+bWF4X3hmZXJfbGVuKQ0KKwkJCXRo
aXNfY291bnQgPSBTQ3BudC0+ZGV2aWNlLT5tYXhfeGZlcl9sZW47DQogDQog
CQlTQ3BudC0+Y21uZFswXSArPSBSRUFEXzEwIC0gUkVBRF82Ow0KIAkJU0Nw
bnQtPmNtbmRbMV0gfD0gYmxrX2Z1YV9ycShycSkgPyAweDggOiAwOw0KZGlm
ZiAtciAtdSBsaW51eC0yLjYuMTZfb3JnL2luY2x1ZGUvc2NzaS9zY3NpX2Rl
dmljZS5oIGxpbnV4LTIuNi4xNi9pbmNsdWRlL3Njc2kvc2NzaV9kZXZpY2Uu
aA0KLS0tIGxpbnV4LTIuNi4xNl9vcmcvaW5jbHVkZS9zY3NpL3Njc2lfZGV2
aWNlLmgJMjAwNi0wMy0yMCAwNjo1MzoyOS4wMDAwMDAwMDAgKzAxMDANCisr
KyBsaW51eC0yLjYuMTYvaW5jbHVkZS9zY3NpL3Njc2lfZGV2aWNlLmgJMjAw
Ni0wMy0zMCAxNzo1Mjo0NC4wMDAwMDAwMDAgKzAyMDANCkBAIC04OSw2ICs4
OSw3IEBADQogCQkJCSAqIHNjc2lfZGV2aW5mby5baGNdLiBGb3Igbm93IHVz
ZWQgb25seSB0bw0KIAkJCQkgKiBwYXNzIHNldHRpbmdzIGZyb20gc2xhdmVf
YWxsb2MgdG8gc2NzaQ0KIAkJCQkgKiBjb3JlLiAqLw0KKwl1bnNpZ25lZCBz
aG9ydCBtYXhfeGZlcl9sZW47CS8qIE1heGltdW0geGZlciBsZW5ndGggaW4g
b25lIGNkYiAqLw0KIAl1bnNpZ25lZCB3cml0ZWFibGU6MTsNCiAJdW5zaWdu
ZWQgcmVtb3ZhYmxlOjE7DQogCXVuc2lnbmVkIGNoYW5nZWQ6MTsJLyogRGF0
YSBpbnZhbGlkIGR1ZSB0byBtZWRpYSBjaGFuZ2UgKi8NCmRpZmYgLXIgLXUg
bGludXgtMi42LjE2X29yZy9pbmNsdWRlL3Njc2kvc2NzaV9kZXZpbmZvLmgg
bGludXgtMi42LjE2L2luY2x1ZGUvc2NzaS9zY3NpX2RldmluZm8uaA0KLS0t
IGxpbnV4LTIuNi4xNl9vcmcvaW5jbHVkZS9zY3NpL3Njc2lfZGV2aW5mby5o
CTIwMDYtMDMtMjAgMDY6NTM6MjkuMDAwMDAwMDAwICswMTAwDQorKysgbGlu
dXgtMi42LjE2L2luY2x1ZGUvc2NzaS9zY3NpX2RldmluZm8uaAkyMDA2LTAz
LTMwIDE4OjExOjIwLjAwMDAwMDAwMCArMDIwMA0KQEAgLTI4LDQgKzI4LDUg
QEANCiAjZGVmaW5lIEJMSVNUX05PX1VMRF9BVFRBQ0gJMHgxMDAwMDAgLyog
ZGV2aWNlIGlzIGFjdHVhbGx5IGZvciBSQUlEIGNvbmZpZyAqLw0KICNkZWZp
bmUgQkxJU1RfU0VMRUNUX05PX0FUTgkweDIwMDAwMCAvKiBzZWxlY3Qgd2l0
aG91dCBBVE4gKi8NCiAjZGVmaW5lIEJMSVNUX1JFVFJZX0hXRVJST1IJMHg0
MDAwMDAgLyogcmV0cnkgSEFSRFdBUkVfRVJST1IgKi8NCisjZGVmaW5lIEJM
SVNUX01BWF81MTJLCQkweDEwMDAwMDAgLyogbWF4aW11bSA1MTJLIGNkYiB0
cmFuc2ZlciBsZW5ndGggKi8NCiAjZW5kaWYNCg==

---559023410-758783491-1143728425=:6412--
