From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 04/15] libata: ata_scsi_queuecmd cleanup
Date: Wed, 22 Mar 2006 17:20:24 -0600
Message-ID: <4421DBB8.1030908@us.ibm.com>
References: <200603172304.k2HN4LDp014215@d03av03.boulder.ibm.com> <4420ADB0.10904@pobox.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060203030901080204030501"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4420ADB0.10904@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------060203030901080204030501
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jeff Garzik wrote:
> Brian King wrote:
>> Encapsulate part of ata_scsi_queuecmd so that it can be
>> reused by future SAS patches.
>>
>> +static void __ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *),
> 
> static inline, please

ok.


>>  /**
>>   *	ata_scsi_queuecmd - Issue SCSI cdb to libata-managed device
>>   *	@cmd: SCSI command to be sent
>> @@ -2605,16 +2620,7 @@ int ata_scsi_queuecmd(struct scsi_cmnd *
>>  		goto out_unlock;
>>  	}
>>  
>> -	if (dev->class == ATA_DEV_ATA) {
>> -		ata_xlat_func_t xlat_func = ata_get_xlat_func(dev,
>> -							      cmd->cmnd[0]);
>> -
>> -		if (xlat_func)
>> -			ata_scsi_translate(ap, dev, cmd, done, xlat_func);
>> -		else
>> -			ata_scsi_simulate(ap, dev, cmd, done);
>> -	} else
>> -		ata_scsi_translate(ap, dev, cmd, done, atapi_xlat);
>> +	__ata_scsi_queuecmd(cmd, done, ap, dev);
> 
> might as well kill the out_unlock goto target, and do something like
> 
> 	if (likely(dev))
> 		__ata_scsi_queuecmd()
> 	else
> 		BAD TARGET

ok. How about the following patch?

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------060203030901080204030501
Content-Type: text/x-patch;
 name="libata_scsi_queuecmd.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="libata_scsi_queuecmd.patch"

CkVuY2Fwc3VsYXRlIHBhcnQgb2YgYXRhX3Njc2lfcXVldWVjbWQgc28gdGhhdCBpdCBjYW4g
YmUKcmV1c2VkIGJ5IGZ1dHVyZSBTQVMgcGF0Y2hlcy4KClNpZ25lZC1vZmYtYnk6IEJyaWFu
IEtpbmcgPGJya2luZ0B1cy5pYm0uY29tPgotLS0KCiBsaWJhdGEtZGV2LWJqa2luZzEvZHJp
dmVycy9zY3NpL2xpYmF0YS1zY3NpLmMgfCAgIDMyICsrKysrKysrKysrKysrLS0tLS0tLS0t
LS0tCiAxIGZpbGVzIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDE0IGRlbGV0aW9ucygt
KQoKZGlmZiAtcHVOIGRyaXZlcnMvc2NzaS9saWJhdGEtc2NzaS5jfmxpYmF0YV9zY3NpX3F1
ZXVlY21kIGRyaXZlcnMvc2NzaS9saWJhdGEtc2NzaS5jCi0tLSBsaWJhdGEtZGV2L2RyaXZl
cnMvc2NzaS9saWJhdGEtc2NzaS5jfmxpYmF0YV9zY3NpX3F1ZXVlY21kCTIwMDYtMDMtMjIg
MDg6NTg6NDYuMDAwMDAwMDAwIC0wNjAwCisrKyBsaWJhdGEtZGV2LWJqa2luZzEvZHJpdmVy
cy9zY3NpL2xpYmF0YS1zY3NpLmMJMjAwNi0wMy0yMiAwOTowMDoxNS4wMDAwMDAwMDAgLTA2
MDAKQEAgLTI1ODcsNiArMjU4NywyMSBAQCBzdGF0aWMgaW5saW5lIHZvaWQgYXRhX3Njc2lf
ZHVtcF9jZGIoc3RyCiAjZW5kaWYKIH0KIAorc3RhdGljIGlubGluZSB2b2lkIF9fYXRhX3Nj
c2lfcXVldWVjbWQoc3RydWN0IHNjc2lfY21uZCAqY21kLCB2b2lkICgqZG9uZSkoc3RydWN0
IHNjc2lfY21uZCAqKSwKKwkJCQkgICAgICAgc3RydWN0IGF0YV9wb3J0ICphcCwgc3RydWN0
IGF0YV9kZXZpY2UgKmRldikKK3sKKwlpZiAoZGV2LT5jbGFzcyA9PSBBVEFfREVWX0FUQSkg
eworCQlhdGFfeGxhdF9mdW5jX3QgeGxhdF9mdW5jID0gYXRhX2dldF94bGF0X2Z1bmMoZGV2
LAorCQkJCQkJCSAgICAgIGNtZC0+Y21uZFswXSk7CisKKwkJaWYgKHhsYXRfZnVuYykKKwkJ
CWF0YV9zY3NpX3RyYW5zbGF0ZShhcCwgZGV2LCBjbWQsIGRvbmUsIHhsYXRfZnVuYyk7CisJ
CWVsc2UKKwkJCWF0YV9zY3NpX3NpbXVsYXRlKGFwLCBkZXYsIGNtZCwgZG9uZSk7CisJfSBl
bHNlCisJCWF0YV9zY3NpX3RyYW5zbGF0ZShhcCwgZGV2LCBjbWQsIGRvbmUsIGF0YXBpX3hs
YXQpOworfQorCiAvKioKICAqCWF0YV9zY3NpX3F1ZXVlY21kIC0gSXNzdWUgU0NTSSBjZGIg
dG8gbGliYXRhLW1hbmFnZWQgZGV2aWNlCiAgKglAY21kOiBTQ1NJIGNvbW1hbmQgdG8gYmUg
c2VudApAQCAtMjYyMSwyNCArMjYzNiwxMyBAQCBpbnQgYXRhX3Njc2lfcXVldWVjbWQoc3Ry
dWN0IHNjc2lfY21uZCAqCiAJYXRhX3Njc2lfZHVtcF9jZGIoYXAsIGNtZCk7CiAKIAlkZXYg
PSBhdGFfc2NzaV9maW5kX2RldihhcCwgc2NzaWRldik7Ci0JaWYgKHVubGlrZWx5KCFkZXYp
KSB7CisJaWYgKGxpa2VseShkZXYpKQorCQlfX2F0YV9zY3NpX3F1ZXVlY21kKGNtZCwgZG9u
ZSwgYXAsIGRldik7CisJZWxzZSB7CiAJCWNtZC0+cmVzdWx0ID0gKERJRF9CQURfVEFSR0VU
IDw8IDE2KTsKIAkJZG9uZShjbWQpOwotCQlnb3RvIG91dF91bmxvY2s7CiAJfQogCi0JaWYg
KGRldi0+Y2xhc3MgPT0gQVRBX0RFVl9BVEEpIHsKLQkJYXRhX3hsYXRfZnVuY190IHhsYXRf
ZnVuYyA9IGF0YV9nZXRfeGxhdF9mdW5jKGRldiwKLQkJCQkJCQkgICAgICBjbWQtPmNtbmRb
MF0pOwotCi0JCWlmICh4bGF0X2Z1bmMpCi0JCQlhdGFfc2NzaV90cmFuc2xhdGUoYXAsIGRl
diwgY21kLCBkb25lLCB4bGF0X2Z1bmMpOwotCQllbHNlCi0JCQlhdGFfc2NzaV9zaW11bGF0
ZShhcCwgZGV2LCBjbWQsIGRvbmUpOwotCX0gZWxzZQotCQlhdGFfc2NzaV90cmFuc2xhdGUo
YXAsIGRldiwgY21kLCBkb25lLCBhdGFwaV94bGF0KTsKLQotb3V0X3VubG9jazoKIAlzcGlu
X3VubG9jaygmYXAtPmhvc3Rfc2V0LT5sb2NrKTsKIAlzcGluX2xvY2soc2hvc3QtPmhvc3Rf
bG9jayk7CiAJcmV0dXJuIDA7Cl8K
--------------060203030901080204030501--
