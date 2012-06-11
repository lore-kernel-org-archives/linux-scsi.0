From: Muthu Kumar <muthu.lkml@gmail.com>
Subject: Re: [PATCH UPDATED] block: In blk_execute_rq_nowait, init rq->end_io
 before checking for dead queue.
Date: Mon, 11 Jun 2012 14:23:23 -0700
Message-ID: <CAFR8uefK+nByiJ8tw5_KF1qEJs4du2mDdU36gg1_2nRNZXN5Fw@mail.gmail.com>
References: <CAFR8uecFzcrAYSy2ieJM5vWjNLSO3bjg20cy+B4cimHZ4RLktA@mail.gmail.com>
	<4FD345DC.6020405@acm.org>
	<CAFR8ueca-MQWRipE+3OQSpqmJ40HKJEY7jWt6PQ+zTCQ9Bh=5Q@mail.gmail.com>
	<4FD4DC26.5080902@acm.org>
	<CAFR8uecF0LwbV8FvYob5m34sVbKqafrNoYOrcRUQCEOymGnYRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf3071caa6b7634204c238f5dd
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFR8uecF0LwbV8FvYob5m34sVbKqafrNoYOrcRUQCEOymGnYRA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Jej B <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--20cf3071caa6b7634204c238f5dd
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Jun 11, 2012 at 10:33 AM, Muthu Kumar <muthu.lkml@gmail.com> wrote:
> On Sun, Jun 10, 2012 at 10:40 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>> On 06/09/12 23:57, Muthu Kumar wrote:
>>
>>> Locking change is the one you posted already (the link above). Anyway,
>>> I have the attached patch *including* the locking change. Original
>>> mail has attachment without locking change. Please use whatever you
>>> need.
>>
>>
>> While we are at it ... the rq->rq_disk and rq->end_io assignments can be
>> performed safely before the spinlock is taken, isn't it ?
>>
>
> Yes.. that spinlock is to protect the q.
>

Attached patch with assignment performed before taking the spinlock.




>
>> Bart.

--20cf3071caa6b7634204c238f5dd
Content-Type: application/octet-stream;
	name="blk-exec-assign-endio-to-bart-v2.patch"
Content-Disposition: attachment;
	filename="blk-exec-assign-endio-to-bart-v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h39s5yoj0

ZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay1leGVjLmMgYi9ibG9jay9ibGstZXhlYy5jCmluZGV4IGZi
MmNiZDUuLjAwYTcyZGEgMTAwNjQ0Ci0tLSBhL2Jsb2NrL2Jsay1leGVjLmMKKysrIGIvYmxvY2sv
YmxrLWV4ZWMuYwpAQCAtNTEsNiArNTEsMTAgQEAgdm9pZCBibGtfZXhlY3V0ZV9ycV9ub3dhaXQo
c3RydWN0IHJlcXVlc3RfcXVldWUgKnEsIHN0cnVjdCBnZW5kaXNrICpiZF9kaXNrLAogCWludCB3
aGVyZSA9IGF0X2hlYWQgPyBFTEVWQVRPUl9JTlNFUlRfRlJPTlQgOiBFTEVWQVRPUl9JTlNFUlRf
QkFDSzsKIAogCVdBUk5fT04oaXJxc19kaXNhYmxlZCgpKTsKKworCXJxLT5ycV9kaXNrID0gYmRf
ZGlzazsKKwlycS0+ZW5kX2lvID0gZG9uZTsKKwogCXNwaW5fbG9ja19pcnEocS0+cXVldWVfbG9j
ayk7CiAKIAlpZiAodW5saWtlbHkoYmxrX3F1ZXVlX2RlYWQocSkpKSB7CkBAIC02MSw4ICs2NSw2
IEBAIHZvaWQgYmxrX2V4ZWN1dGVfcnFfbm93YWl0KHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBz
dHJ1Y3QgZ2VuZGlzayAqYmRfZGlzaywKIAkJcmV0dXJuOwogCX0KIAotCXJxLT5ycV9kaXNrID0g
YmRfZGlzazsKLQlycS0+ZW5kX2lvID0gZG9uZTsKIAlfX2Vsdl9hZGRfcmVxdWVzdChxLCBycSwg
d2hlcmUpOwogCV9fYmxrX3J1bl9xdWV1ZShxKTsKIAkvKiB0aGUgcXVldWUgaXMgc3RvcHBlZCBz
byBpdCB3b24ndCBiZSBydW4gKi8K
--20cf3071caa6b7634204c238f5dd--
