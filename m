From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [RFC] Simlify dif_verify routines and fixup fileio protection
 information code.
Date: Wed, 15 Apr 2015 08:52:17 +0900
Message-ID: <CAC5umyj9FsnumRhvNrzqE=Rtpy3O32SBw43ZP9M8H5B3htbRpw@mail.gmail.com>
References: <1428945575-30839-1-git-send-email-sagig@mellanox.com>
	<CAC5umygZ_qCu0x3RfTQs21R1Poa6A10FkhmGak7ccc2HvY4ROQ@mail.gmail.com>
	<552D4C7B.9000402@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11c373dcb66f6f0513b7ebfa
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <552D4C7B.9000402@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Sagi Grimberg <sagig@mellanox.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

--001a11c373dcb66f6f0513b7ebfa
Content-Type: text/plain; charset=UTF-8

2015-04-15 2:20 GMT+09:00 Sagi Grimberg <sagig@dev.mellanox.co.il>:
> On 4/14/2015 3:17 PM, Akinobu Mita wrote:
>>
>> 2015-04-14 2:19 GMT+09:00 Sagi Grimberg <sagig@mellanox.com>:
>>>
>>> Hey All,
>>>
>>> This set follows the patchset from Akinobu Mita that addresses
>>> DIF bounce buffer sgl construction. Instead of trying to fix these
>>> bugs, this removes it altogether and work with cmd->t_prot_sg
>>> directly.
>>>
>>> The first patch is a simplification of the DIF verify varius
>>> routines leaving a single generic sbc_dif_verify that handles
>>> the protection information sgl we are working on.
>>>
>>> The second patch uses this simplification to remove the local
>>> prot_fd bounce buffer altogether.
>>>
>>> This passed minimal IO testing.
>>
>>
>> Looks good...
>>
>> I'll test with these patches and check if the problems I met
>> disappear.
>
>
> Thanks Akinobu,
>
> Waiting to hear your verdict before sending a formal patchset.

I hit a original bug in sbc_dif_verify() which is not introduced by
your patch set, though.  Please consider to include attached patch.
I'm still seeing another problem and trying to find out a root cause,
but it seems like it's caused by other change in -next.

--001a11c373dcb66f6f0513b7ebfa
Content-Type: text/x-patch; charset=US-ASCII; name="fix-sbc_dif_verify.patch"
Content-Disposition: attachment; filename="fix-sbc_dif_verify.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i8hyr0gv0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3NiYy5jIGIvZHJpdmVycy90
YXJnZXQvdGFyZ2V0X2NvcmVfc2JjLmMKaW5kZXggM2Q4OGMwMC4uNjVhMGI1ZiAxMDA2NDQKLS0t
IGEvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfc2JjLmMKKysrIGIvZHJpdmVycy90YXJnZXQv
dGFyZ2V0X2NvcmVfc2JjLmMKQEAgLTEzMTEsNyArMTMxMSw3IEBAIHNiY19kaWZfdmVyaWZ5KHN0
cnVjdCBzZV9jbWQgKmNtZCwgc2VjdG9yX3Qgc3RhcnQsIHVuc2lnbmVkIGludCBzZWN0b3JzLAog
CiAJZm9yX2VhY2hfc2coY21kLT50X2RhdGFfc2csIGRzZywgY21kLT50X2RhdGFfbmVudHMsIGkp
IHsKIAkJZGFkZHIgPSBrbWFwX2F0b21pYyhzZ19wYWdlKGRzZykpICsgZHNnLT5vZmZzZXQ7Ci0J
CXBhZGRyID0ga21hcF9hdG9taWMoc2dfcGFnZShwc2cpKSArIHNnLT5vZmZzZXQ7CisJCXBhZGRy
ID0ga21hcF9hdG9taWMoc2dfcGFnZShwc2cpKSArIHBzZy0+b2Zmc2V0OwogCiAJCWZvciAoaiA9
IDA7IGogPCBkc2ctPmxlbmd0aDsgaiArPSBkZXYtPmRldl9hdHRyaWIuYmxvY2tfc2l6ZSkgewog
Cg==
--001a11c373dcb66f6f0513b7ebfa--
