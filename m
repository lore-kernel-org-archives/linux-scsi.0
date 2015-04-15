From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [RFC] Simlify dif_verify routines and fixup fileio protection
 information code.
Date: Wed, 15 Apr 2015 23:16:04 +0900
Message-ID: <CAC5umygGG4BTs0u35eVi6dLhoDuDshGNPsQaWq2kO5YexWDP+Q@mail.gmail.com>
References: <1428945575-30839-1-git-send-email-sagig@mellanox.com>
	<CAC5umygZ_qCu0x3RfTQs21R1Poa6A10FkhmGak7ccc2HvY4ROQ@mail.gmail.com>
	<552D4C7B.9000402@dev.mellanox.co.il>
	<CAC5umyj9FsnumRhvNrzqE=Rtpy3O32SBw43ZP9M8H5B3htbRpw@mail.gmail.com>
	<552E384F.3030203@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1134668ad998920513c3fc53
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <552E384F.3030203@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

--001a1134668ad998920513c3fc53
Content-Type: text/plain; charset=UTF-8

2015-04-15 19:07 GMT+09:00 Sagi Grimberg <sagig@dev.mellanox.co.il>:
> On 4/15/2015 2:52 AM, Akinobu Mita wrote:
>
>>>>
>>>> Looks good...
>>>>
>>>> I'll test with these patches and check if the problems I met
>>>> disappear.
>>>
>>>
>>>
>>> Thanks Akinobu,
>>>
>>> Waiting to hear your verdict before sending a formal patchset.
>>
>>
>> I hit a original bug in sbc_dif_verify() which is not introduced by
>> your patch set, though.
>
>
> What is this original bug?

I meant to say about the problem I fixed by fix-sbc_dif_verify.patch.

>>  Please consider to include attached patch.
>
>
> I'll include it. thanks.
>
>> I'm still seeing another problem and trying to find out a root cause,
>> but it seems like it's caused by other change in -next.
>>
>
> care to elaborate?

When mounting ext4 filesystem at the first time after mkfs, a lot of
WRITE_SAME commands are issued for lazy initialization or something.

By the commit 436f4a0a ("loopback: Add fabric_prot_type attribute
support"), When WRITE_SAME command with WRPROTECT=0 is executed,
sbc_dif_generate() is called but cmd->t_prot_sg is NULL as block layer
didn't allocate it for WRITE_SAME.

I could work around with the attached patch, as the WRITE_SAME command
will fail after all when protection info is enabled with FILEIO, we only need to
avoid null pointer dereference.  But I need to ask Nic about the right
way to fix.

For this patch set, please feel free to add:

Tested-by: Akinobu Mita <akinobu.mita@gmail.com>

--001a1134668ad998920513c3fc53
Content-Type: text/x-patch; charset=US-ASCII; name="fix-sbc_dif_generate.patch"
Content-Disposition: attachment; filename="fix-sbc_dif_generate.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i8itdnby0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3NiYy5jIGIvZHJpdmVycy90
YXJnZXQvdGFyZ2V0X2NvcmVfc2JjLmMKaW5kZXggM2Q4OGMwMC4uZDhkNjI2NyAxMDA2NDQKLS0t
IGEvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfc2JjLmMKKysrIGIvZHJpdmVycy90YXJnZXQv
dGFyZ2V0X2NvcmVfc2JjLmMKQEAgLTExODMsNiArMTE4Myw5IEBAIHNiY19kaWZfZ2VuZXJhdGUo
c3RydWN0IHNlX2NtZCAqY21kKQogCXZvaWQgKmRhZGRyLCAqcGFkZHI7CiAJaW50IGksIGosIG9m
ZnNldCA9IDA7CiAKKwlpZiAoIXBzZykKKwkJcmV0dXJuOworCiAJZm9yX2VhY2hfc2coY21kLT50
X2RhdGFfc2csIGRzZywgY21kLT50X2RhdGFfbmVudHMsIGkpIHsKIAkJZGFkZHIgPSBrbWFwX2F0
b21pYyhzZ19wYWdlKGRzZykpICsgZHNnLT5vZmZzZXQ7CiAJCXBhZGRyID0ga21hcF9hdG9taWMo
c2dfcGFnZShwc2cpKSArIHBzZy0+b2Zmc2V0Owo=
--001a1134668ad998920513c3fc53--
