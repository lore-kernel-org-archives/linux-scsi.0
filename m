From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Handling erroneous READ CAPACITY response in sd.c
Date: Mon, 25 Oct 2004 16:08:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <417D5D4D.5000400@adaptec.com>
References: <Pine.LNX.4.44L0.0410201130460.638-100000@ida.rowland.org> <417BA172.40203@ping-viini.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070309040106010607030303"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:19896 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261152AbUJYUJD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2004 16:09:03 -0400
In-Reply-To: <417BA172.40203@ping-viini.org>
List-Id: linux-scsi@vger.kernel.org
To: Eero Volotinen <eero@ping-viini.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Adriaan Penning <a.penning@luon.net>, Darsen Lu <darsen@micro.ee.nthu.edu.tw>, SCSI development list <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070309040106010607030303
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Eero Volotinen wrote:
> Alan Stern wrote:
> 
>> People:
>>
>> We would like to test a method for determining automatically when the 
>> capacity value returned by a drive is too high.  If this works it 
>> means that the unusual_devs.h entries for your devices can be removed, 
>> and we'll never be troubled by similarly broken devices again.
>>
>> Please try applying the patches below.  The first one removes the 
>> existing
>> unusual_devs entries and the second one includes the code we want to 
>> test.  Test results are written to the system log, and you don't need 
>> to turn on
>> the usb-storage verbose debugging.  In your replies, include the dmesg 
>> output showing what happens when you plug in or turn on your drives.
> 
> 
> Does not work on my machine. It detects disk and then it hangs.
> 
> usb 1-4: new high speed USB device using address 3
> Initializing USB Mass Storage driver...
> usb 1-4: control timeout on ep0in
> usb 1-4: string descriptor 0 read error: -71
> usb 1-4: string descriptor 0 read error: -71
> usb 1-4: string descriptor 0 read error: -71
> usb 1-4: string descriptor 0 read error: -71
> scsi0 : SCSI emulation for USB Mass Storage devices
> usbcore: registered new driver usb-storage
> USB Mass Storage support registered.
> usb 1-4: string descriptor 0 read error: -71
> usb-storage: device found at 3
> usb 1-4: string descriptor 0 read error: -71

Alan, is this error message something to be concerned with?

> usb-storage: waiting for device to settle before scanning
> inserting floppy driver for 2.6.10-rc1alan
> floppy0: no floppy controllers found
>   Vendor: HDS72808  Model: 0PLAT20           Rev: PF2O
>   Type:   Direct-Access                      ANSI SCSI revision: 00
> sd_read_true_cap: sda: spec behavior

Ok, the above line tells that the device _does_ support
the PMI bit, and testing with the PMI bit on returned
values as _intended_ by the spec.

> sd_read_format_cap: sda: no media or unformatted media

Alan, let's weed out _only_ Descriptor Type 0 (reserved).
All others seem to be reporting _some_ capacity...
(see attached patch, I've also removed the macro defs)

The attached patch ignore the "No Media Present",
and trusts the "The reported value is for the maximum
capacity of a media that the Logical Unit is capable
of reading." -- MMC4r00, table 422.

> SCSI device sda: 160836481 512-byte hdwr sectors (82348 MB)
> sda: assuming drive cache: write through
>  sda:SCSI error : <0 0 0 0> return code = 0x70000
> end_request: I/O error, dev sda, sector 160836480
> Buffer I/O error on device sda, logical block 160836480
> SCSI error : <0 0 0 0> return code = 0x70000
> end_request: I/O error, dev sda, sector 160836480
> Buffer I/O error on device sda, logical block 160836480
>  sda1
> Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
> usb-storage: device scan complete
> SCSI error : <0 0 0 0> return code = 0x70000
> end_request: I/O error, dev sda, sector 0
> Buffer I/O error on device sda, logical block 0
> SCSI error : <0 0 0 0> return code = 0x70000
> end_request: I/O error, dev sda, sector 1
> Buffer I/O error on device sda, logical block 1
> SCSI error : <0 0 0 0> return code = 0x70000
> end_request: I/O error, dev sda, sector 2
> Buffer I/O error on device sda, logical block 2
> SCSI error : <0 0 0 0> return code = 0x70000
> end_request: I/O error, dev sda, sector 3
> Buffer I/O error on device sda, logical block 3
> SCSI error : <0 0 0 0> return code = 0x70000
> end_request: I/O error, dev sda, sector 4
> Buffer I/O error on device sda, logical block 4
> SCSI error : <0 0 0 0> return code = 0x70000
> end_request: I/O error, dev sda, sector 5
> Buffer I/O error on device sda, logical block 5
> SCSI error : <0 0 0 0> return code = 0x70000
> end_request: I/O error, dev sda, sector 6
> Buffer I/O error on device sda, logical block 6
> usb 1-4: USB disconnect, address 3
> SCSI error : <0 0 0 0> return code = 0x70000
> end_request: I/O error, dev sda, sector 7
> Buffer I/O error on device sda, logical block 7
> SCSI error : <0 0 0 0> return code = 0x70000
> end_request: I/O error, dev sda, sector 8
> Buffer I/O error on device sda, logical block 8

Ok, so reading the last sector and the first 9 sectors
fails.

Either the device got disrupted earlier, or reading
the "last" LBA confused it.

>  target0:0:0: Illegal state transition <NULL>->cancel
> Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1713

How did we get here...?

Eero, can you try the attached patch?  I wonder if we
can take the maximum capacity media which could be supported?
(This is "patch 2", you still have to apply "patch 1" which
removes the broken devices from unusual devs.)

Thanks,
	Luben


--------------070309040106010607030303
Content-Type: application/octet-stream;
 name="cap.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="cap.patch"

PT09PT0gZHJpdmVycy9zY3NpL3NkLmMgMS4xNjEgdnMgZWRpdGVkID09PT09Ci0tLSAxLjE2
MS9kcml2ZXJzL3Njc2kvc2QuYwkyMDA0LTEwLTE1IDEwOjQ2OjA3IC0wNDowMAorKysgZWRp
dGVkL2RyaXZlcnMvc2NzaS9zZC5jCTIwMDQtMTAtMjUgMTM6Mjg6MjMgLTA0OjAwCkBAIC05
ODcsNiArOTg3LDE1MiBAQAogCX0KIH0KIAorLyogc2RfcmVhZF90cnVlX2NhcDogU29tZSBk
ZXZpY2Ugc2VydmVycyBpbmNvcnJlY3RseSByZXR1cm4gdGhlCisgKiBjYXBhY2l0eSBhcyBv
cHBvc2VkIHRvIHRoZSBMQkEgb2YgdGhlIGxhc3QgbG9naWNhbCBibG9jayBvZiB0aGUKKyAq
IGJsb2NrIGRldmljZS4KKyAqCisgKiBXZSB0cnkgdG8gZml4IHRoaXMgYXMgZm9sbG93czog
TGV0IHggPSBSZXR1cm5lZCBMQkEgZnJvbSB0aGUgbGFzdAorICogUkVBRCBDQVBBQ0lUWSBj
b21tYW5kIGlzc3VlZCAocmVzdWx0IGluICJidWZmZXIiKS4gIFJlaXNzdWUgdGhlCisgKiBS
RUFEIENBUEFDSVRZIGNvbW1hbmQgYXMgZm9sbG93czogc2V0IHRoZSBwYXJ0aWFsIG1lZGl1
bSBpbmRpY2F0b3IKKyAqIChQTUkpIGJpdCB0byBvbmU7IHNldCB0aGUgTEJBIHRvIHggLSAx
LiBGaXJlIG9mZiB0aGF0IFJFQUQgQ0FQQUNJVFkKKyAqIGNvbW1hbmQuCisgKgorICogSWYg
d2UgZ2V0IHN1Y2Nlc3MsCisgKiAgICAgICBJZiBSZXR1cm5lZCBMQkEgPiB4IC0gMSwgdGhl
biBjYXBhY2l0eSBpcyB4KzEsIHNwZWMgYmVoYXZpb3IuCisgKiAgICAgICBFbHNlIFJldHVy
bmVkIExCQSA8PSB4IC0gMSwgdGhlbiBjYXBhY2l0eSBpcyB4LCBicm9rZW4gZGV2aWNlIHNl
cnZlci4KKyAqIEVsc2UgZXJyb3IsIG5vdGhpbmcgY2FuIGJlIGFzc3VtZWQsIGNhcGFjaXR5
IGlzIHgrMS4KKyAqLworc3RhdGljIHZvaWQgc2RfcmVhZF90cnVlX2NhcChzdHJ1Y3Qgc2Nz
aV9kaXNrICpzZCwgY2hhciAqZGlza25hbWUsCisJCQkgICAgIHN0cnVjdCBzY3NpX3JlcXVl
c3QgKlNScG50LCB1bnNpZ25lZCBjaGFyICpidWZmZXIsCisJCQkgICAgIGludCBsb25ncmMp
Cit7CisJdW5zaWduZWQgY2hhciBjbWRbMTZdOworCXVuc2lnbmVkIGNoYXIgYnVmWzEyXTsK
KworCS8qIHNhdmUgdGhlIG9sZCBidWZmZXIgY29udGVudHMgaGVyZSAqLworCW1lbWNweShi
dWYsIGJ1ZmZlciwgMTIpOworCisJaWYgKGxvbmdyYykgeworCQl1NjQgKmxiYSA9ICh1NjQg
KikgKGNtZCsyKTsKKwkJdTY0IHJsYmE7CisKKwkJbWVtc2V0KCh2b2lkICopIGNtZCwgMCwg
MTYpOworCQljbWRbMF0gPSBTRVJWSUNFX0FDVElPTl9JTjsKKwkJY21kWzFdID0gU0FJX1JF
QURfQ0FQQUNJVFlfMTY7CisJCWNtZFsxM10gPSAxMjsKKworCQlybGJhID0gYmU2NF90b19j
cHUoKih1NjQgKilidWZmZXIpOworCQlybGJhIC09IDE7CisJCSpsYmEgPSBjcHVfdG9fYmU2
NChybGJhKTsKKwkJLyogdHVybiBvbiB0aGUgUE1JIGJpdCAqLworCQljbWRbMTRdIHw9IDE7
CisJCW1lbXNldCgodm9pZCAqKSBidWZmZXIsIDAsIDEyKTsKKwl9IGVsc2UgeworCQl1MzIg
KmxiYSA9ICh1MzIgKikgKGNtZCsyKTsKKwkJdTMyIHJsYmE7CisKKwkJY21kWzBdID0gUkVB
RF9DQVBBQ0lUWTsKKwkJbWVtc2V0KCh2b2lkICopICZjbWRbMV0sIDAsIDkpOworCQkKKwkJ
cmxiYSA9IGJlMzJfdG9fY3B1KCoodTMyICopYnVmZmVyKTsKKwkJcmxiYSAtPSAxOworCQkq
bGJhID0gY3B1X3RvX2JlMzIocmxiYSk7CisJCS8qIHR1cm4gb24gdGhlIFBNSSBiaXQgKi8K
KwkJY21kWzhdIHw9IDE7CisJCW1lbXNldCgodm9pZCAqKSBidWZmZXIsIDAsIDgpOworCX0K
KworCVNScG50LT5zcl9jbWRfbGVuID0gMDsKKwlTUnBudC0+c3Jfc2Vuc2VfYnVmZmVyWzBd
ID0gMDsKKwlTUnBudC0+c3Jfc2Vuc2VfYnVmZmVyWzJdID0gMDsKKwlTUnBudC0+c3JfZGF0
YV9kaXJlY3Rpb24gPSBETUFfRlJPTV9ERVZJQ0U7CisJCisJc2NzaV93YWl0X3JlcShTUnBu
dCwgKHZvaWQgKikgY21kLCAodm9pZCAqKSBidWZmZXIsCisJCSAgICAgIGxvbmdyYyA/IDEy
IDogOCwgU0RfVElNRU9VVCwgU0RfTUFYX1JFVFJJRVMpOworCisJaWYgKFNScG50LT5zcl9y
ZXN1bHQpIHsKKwkJLyogTm90aGluZyBjYW4gYmUgYXNzdW1lZC4gKi8KKwkJcHJpbnRrKEtF
Uk5fTk9USUNFICIlczogJXM6IFBNSSBub3Qgc3VwcG9ydGVkXG4iLAorCQkgICAgICAgX19G
VU5DVElPTl9fLCBkaXNrbmFtZSk7CisJCW1lbWNweShidWZmZXIsIGJ1ZiwgMTIpOworCQly
ZXR1cm47CisJfQorCisJaWYgKGxvbmdyYykgeworCQl1NjQgcmxiYSA9IGJlNjRfdG9fY3B1
KCoodTY0ICopYnVmZmVyKTsKKwkJdTY0IHggICAgPSBiZTY0X3RvX2NwdSgqKHU2NCAqKWJ1
Zik7CisJCWlmIChybGJhID4geCAtIDEpIHsKKwkJCWdvdG8gb3V0X3NwZWM7CisJCX0KKwl9
IGVsc2UgeworCQl1MzIgcmxiYSA9IGJlMzJfdG9fY3B1KCoodTMyICopYnVmZmVyKTsKKwkJ
dTMyIHggICAgPSBiZTMyX3RvX2NwdSgqKHUzMiAqKWJ1Zik7CisJCWlmIChybGJhID4geCAt
IDEpIHsKKwkJCWdvdG8gb3V0X3NwZWM7CisJCX0KKwl9CisJcHJpbnRrKEtFUk5fTk9USUNF
ICIlczogJXM6IGJyb2tlbiBkZXZpY2Ugc2VydmVyXG4iLCBfX0ZVTkNUSU9OX18sCisJICAg
ICAgIGRpc2tuYW1lKTsKKwlyZXR1cm47CisKKyBvdXRfc3BlYzoKKwkvKiBDYXBhY2l0eSBp
cyB4KzEsIHNwZWMgYmVoYXZpb3IuICovCisJcHJpbnRrKEtFUk5fTk9USUNFICIlczogJXM6
IHNwZWMgYmVoYXZpb3JcbiIsIF9fRlVOQ1RJT05fXywgZGlza25hbWUpOworCW1lbWNweShi
dWZmZXIsIGJ1ZiwgMTIpOworfSAvKiBlbmQgc2RfcmVhZF90cnVlX2NhcCgpICovCisKKwor
LyogVHJ5IHRvIHVzZSB0aGUgUkVBRCBGT1JNQVQgQ0FQQUNJVElFUyBjb21tYW5kIHRvIGNo
ZWNrIHdoZXRoZXIgdGhlCisgKiBSRUFEIENBUEFDSVRZIHJlc3VsdCBpcyBjb3JyZWN0Lgor
ICovCitzdGF0aWMgdm9pZCBzZF9yZWFkX2Zvcm1hdF9jYXAoc3RydWN0IHNjc2lfZGlzayAq
c2QsIGNoYXIgKmRpc2tuYW1lLAorCQkgICAgICAgc3RydWN0IHNjc2lfcmVxdWVzdCAqU1Jw
bnQsIHVuc2lnbmVkIGNoYXIgKmJ1ZmZlcikKK3sKKwl1bnNpZ25lZCBjaGFyIGNtZFsxMl07
CisJdW5zaWduZWQgY2hhciBidWZbMTJdOworCXUzMiBybGJhOworCXUzMiB4OworCisJLyog
c2F2ZSB0aGUgb2xkIGJ1ZmZlciBjb250ZW50cyBoZXJlICovCisJbWVtY3B5KGJ1ZiwgYnVm
ZmVyLCAxMik7CisKKwlybGJhID0gYmUzMl90b19jcHUoKih1MzIgKilidWZmZXIpOworCisJ
Y21kWzBdID0gMHgyMzsgICAgICAgICAgLyogUkVBRF9GT1JNQVRfQ0FQQUNJVElFUyAqLwor
CW1lbXNldCgmY21kWzFdLCAwLCAxMSk7CisJY21kWzhdID0gMTI7CisJbWVtc2V0KGJ1ZmZl
ciwgMCwgMTIpOworCisJU1JwbnQtPnNyX2NtZF9sZW4gPSAwOworCVNScG50LT5zcl9zZW5z
ZV9idWZmZXJbMF0gPSAwOworCVNScG50LT5zcl9zZW5zZV9idWZmZXJbMl0gPSAwOworCVNS
cG50LT5zcl9kYXRhX2RpcmVjdGlvbiA9IERNQV9GUk9NX0RFVklDRTsKKworCXNjc2lfd2Fp
dF9yZXEoU1JwbnQsICh2b2lkICopIGNtZCwgKHZvaWQgKikgYnVmZmVyLAorCQkgICAgICAx
MiwgU0RfVElNRU9VVCwgU0RfTUFYX1JFVFJJRVMpOworCisJaWYgKFNScG50LT5zcl9yZXN1
bHQpIHsKKwkJLyogTm90aGluZyBjYW4gYmUgYXNzdW1lZC4gKi8KKwkJcHJpbnRrKEtFUk5f
Tk9USUNFICIlczogJXM6IFJFQUQgRk9STUFUIENBUEFDSVRJRVMgIgorCQkgICAgICAgIm5v
dCBzdXBwb3J0ZWRcbiIsIF9fRlVOQ1RJT05fXywgZGlza25hbWUpOworCQlnb3RvIGRvbmU7
CisJfQorCisJeCA9IGJlMzJfdG9fY3B1KCoodTMyICopKGJ1ZmZlciArIDQpKTsKKwlwcmlu
dGsoS0VSTl9OT1RJQ0UgIiVzOiAlczogJXUgdnMuICV1XG4iLAorCSAgICAgICBfX0ZVTkNU
SU9OX18sIGRpc2tuYW1lLCBybGJhLCB4KTsKKwlpZiAoMCA8IHggJiYgeCA8PSBybGJhKSB7
CisJCXUzMiAqbGJhID0gKHUzMiAqKSBidWY7CisJCQorCQlwcmludGsoS0VSTl9OT1RJQ0Ug
IiVzOiAlczogdXNpbmcgbG93ZXIgY2FwYWNpdHlcbiIsCisJCSAgICAgICBfX0ZVTkNUSU9O
X18sIGRpc2tuYW1lKTsKKwkJeCAtPSAxOworCQkqbGJhID0gY3B1X3RvX2JlMzIoeCk7CisJ
fQorIGRvbmU6CisgCW1lbWNweShidWZmZXIsIGJ1ZiwgMTIpOworfQorCiAvKgogICogcmVh
ZCBkaXNrIGNhcGFjaXR5CiAgKi8KQEAgLTEwNzAsNyArMTIxNiwxNCBAQAogCQkKIAkJc2Rr
cC0+Y2FwYWNpdHkgPSAxICsgKHNlY3Rvcl90KSAweGZmZmZmZmZmOwkJCiAJCWdvdG8gZ290
X2RhdGE7Ci0JfQkKKwl9CisKKwkvKiBDaGVjayBpZiB0aGUgZGV2aWNlIHJlcG9ydGVkIENB
UEFDSVRZIGFzIG9wcG9zZWQgdG8KKwkgKiB0aGUgbWF4dW11bSBMQkEgKGFzIHBlciB0aGUg
U0JDIHNwZWMpLgorCSAqLworCXNkX3JlYWRfdHJ1ZV9jYXAoc2RrcCwgZGlza25hbWUsIFNS
cG50LCBidWZmZXIsIGxvbmdyYyk7CisgCWlmICghbG9uZ3JjKQorIAkJc2RfcmVhZF9mb3Jt
YXRfY2FwKHNka3AsIGRpc2tuYW1lLCBTUnBudCwgYnVmZmVyKTsKIAkKIAlpZiAoIWxvbmdy
YykgewogCQlzZWN0b3Jfc2l6ZSA9IChidWZmZXJbNF0gPDwgMjQpIHwKQEAgLTEwNzgsMTIg
KzEyMzEsMTQgQEAKIAkJaWYgKGJ1ZmZlclswXSA9PSAweGZmICYmIGJ1ZmZlclsxXSA9PSAw
eGZmICYmCiAJCSAgICBidWZmZXJbMl0gPT0gMHhmZiAmJiBidWZmZXJbM10gPT0gMHhmZikg
ewogCQkJaWYoc2l6ZW9mKHNka3AtPmNhcGFjaXR5KSA+IDQpIHsKLQkJCQlwcmludGsoS0VS
Tl9OT1RJQ0UgIiVzIDogdmVyeSBiaWcgZGV2aWNlLiB0cnkgdG8gdXNlIgotCQkJCSAgICAg
ICAiIFJFQUQgQ0FQQUNJVFkoMTYpLlxuIiwgZGlza25hbWUpOworCQkJCXByaW50ayhLRVJO
X05PVElDRSAiJXMgOiB2ZXJ5IGJpZyBkZXZpY2UuICIKKwkJCQkgICAgICAgInRyeSB0byB1
c2UgUkVBRCBDQVBBQ0lUWSgxNikuXG4iLAorCQkJCSAgICAgICBkaXNrbmFtZSk7CiAJCQkJ
bG9uZ3JjID0gMTsKIAkJCQlnb3RvIHJlcGVhdDsKIAkJCX0gZWxzZSB7Ci0JCQkJcHJpbnRr
KEtFUk5fRVJSICIlczogdG9vIGJpZyBmb3Iga2VybmVsLiAgQXNzdW1pbmcgbWF4aW11bSAy
VGJcbiIsIGRpc2tuYW1lKTsKKwkJCQlwcmludGsoS0VSTl9FUlIgIiVzOiB0b28gYmlnIGZv
ciBrZXJuZWwuICIKKwkJCQkgICAgICAgIkFzc3VtaW5nIG1heGltdW0gMlRiXG4iLCBkaXNr
bmFtZSk7CiAJCQl9CiAJCX0KIAkJc2RrcC0+Y2FwYWNpdHkgPSAxICsgKCgoc2VjdG9yX3Qp
YnVmZmVyWzBdIDw8IDI0KSB8CkBAIC0xMTAyLDcgKzEyNTcsNyBAQAogCQkJCiAJCXNlY3Rv
cl9zaXplID0gKGJ1ZmZlcls4XSA8PCAyNCkgfAogCQkJKGJ1ZmZlcls5XSA8PCAxNikgfCAo
YnVmZmVyWzEwXSA8PCA4KSB8IGJ1ZmZlclsxMV07Ci0JfQkKKwl9CiAKIGdvdF9kYXRhOgog
CWlmIChzZWN0b3Jfc2l6ZSA9PSAwKSB7Cg==
--------------070309040106010607030303--

