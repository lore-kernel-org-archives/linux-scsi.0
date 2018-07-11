From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Re: [GIT PULL] SCSI fixes for 4.18-rc3
Date: Tue, 10 Jul 2018 17:40:29 -0700
Message-ID: <CA+55aFxDgwKMFTBdxGAYN__zCC=tQjZN1nRHZh5m891Av8V=JA@mail.gmail.com>
References: <1530913134.3135.2.camel@HansenPartnership.com>
 <CA+55aFy-o3fRtkQnJU=0zv7CPUtgfKiwhfQi_05K25Y_-mx+_w@mail.gmail.com>
 <CA+55aFxQ8QzGTWsVdVQVok9cLbgZDFjG2g3JZtWJd+G9jHkYoQ@mail.gmail.com>
 <CA+55aFxAy__3hE1OoUFPKZfptLT1cXuoujsnSGXBMzJPQ+Qjzg@mail.gmail.com>
 <1530940958.3135.4.camel@HansenPartnership.com> <CA+55aFwg-2GP4ASTdd1pusmZkF7c8AN9febVDCaioDxzYJSLfw@mail.gmail.com>
 <70d566f0-2dda-60c2-7c7a-e09e371f8607@cybernetics.com> <CA+55aFxdkGTQ-djy6Z4D52xzHhwWdqQyfVgKweTiUfRpvYoztw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="000000000000fc3d8f0570ae7e02"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxdkGTQ-djy6Z4D52xzHhwWdqQyfVgKweTiUfRpvYoztw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tonyb@cybernetics.com
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--000000000000fc3d8f0570ae7e02
Content-Type: text/plain; charset="UTF-8"

On Tue, Jul 10, 2018 at 3:24 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So /dev/sg really has serious issues. Not just the read/write part,
> but even the SG_IO part is broken right now (sg_new_write() actually
> does do blk_verify_command(), but only for read-only opens for some
> reason).

Looking more at this, it's even more broken than that.

Look at SCSI_IOCTL_SEND_COMMAND. It will do a sg_scsi_ioctl(), but
before that it does the same crazy sg_allow_access() case - and only
for read-only opens.

But that's *doubly* wrong, because

 (a) it's racy, and does the command check on a local copy that might
not be the final one.

 (b) it's pointless, because sg_scsi_ioctl() actually does the proper
command check on the final command as it was copied from user space.

And yes, sg_scsi_ioctl() itself has a slight race in that first it
reads the first byte of the command ("opcode") in order to look up the
size of the command, and then it reads the whole command - including
the first byte - again. So it has the same "read twice, use possibly
inconsistent data" issue, but the actual command that is checked is
the final one that matches the command that is actually submitted. So
all you can do is confuse "cmdlen" and then get timeouts and retry
attempts based on the "fist command" value, but the actually sent
command is fine.

I'm not even going to bother with the sg_scsi_ioctl() race, because
it's harmless, but the drivers/scsi/sg.c code is just pointless and
confusing and should be removed.

Something like the attached?

Please, can we try to at least just de-crapify some of this code?

There's that other "sg_allow_access()" that I also think is wrong and
should just use blk_verify_command() directly and even when opened for
read, but that whole "read or TYPE_SCANNER" is presumably some special
crazy hack for some odd SCSI device.

                  Linus

--000000000000fc3d8f0570ae7e02
Content-Type: text/x-patch; charset="US-ASCII";
	name="0001-scsi-sg-remove-incorrect-scsi-command-checking-logic.patch"
Content-Disposition: attachment;
	filename="0001-scsi-sg-remove-incorrect-scsi-command-checking-logic.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jjgedvj10>
X-Attachment-Id: f_jjgedvj10

RnJvbSBmMDc1ZGNlNjZjNjAzOWJiOTdiNzYyYjU5MmE2ZGI2ZDc5ZTQzNTBhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRh
dGlvbi5vcmc+CkRhdGU6IFR1ZSwgMTAgSnVsIDIwMTggMTc6MDI6MTcgLTA3MDAKU3ViamVjdDog
W1BBVENIXSBzY3NpIHNnOiByZW1vdmUgaW5jb3JyZWN0IHNjc2kgY29tbWFuZCBjaGVja2luZyBs
b2dpYwoKVGhlIFNDU0lfSU9DVExfU0VORF9DT01NQU5EIGlvY3RsIGhhcyBpbnRlcmVzdGluZyBz
Y3NpIGNvbW1hbmQKInNlY3VyaXR5IiBjaGVja2luZy4KCklmIHRoZSBmaWxlIHdhcyBvcGVuZWQg
cmVhZC1vbmx5IChidXQgb25seSBpbiB0aGF0IGNhc2UpLCBpdCB3aWxsCmZldGNoIHRoZSBmaXJz
dCBieXRlIG9mIHRoZSBjb21tYW5kIGZyb20gdXNlciBzcGFjZSwgYW5kIGRvCiJzZ19hbGxvd19h
Y2Nlc3MoKSIgb24gaXQuICBUaGF0LCBpbiB0dXJuLCB3aWxsIGNoZWNrIHRoYXQKImJsa192ZXJp
ZnlfY29tbWFuZCgpIiBpcyBvayB3aXRoIHRoYXQgY29tbWFuZCBieXRlLgoKSWYgdGhhdCBwYXNz
ZXMsIGl0IHdpbGwgdGhlbiBkbyBjYWxsICJzZ19zY3NpX2lvY3RsKCkiIHRvIGV4ZWN1dGUKdGhl
IGNvbW1hbmQuCgpUaGlzIGlzIGVudGlyZWx5IG5vbnNlbnNpY2FsIGZvciBzZXZlcmFsIHJlYXNv
bnMuCgpJdCdzIG5vbnNlbnNpY2FsIHNpbXBseSBiZWNhdXNlIGl0J3MgcmFjeTogYWZ0ZXIgaXQg
Y29waWVzIHRoZSBjb21tYW5kCmJ5dGUgZnJvbSB1c2VyIG1vZGUgdG8gY2hlY2sgaXQsIHVzZXIg
bW9kZSBjb3VsZCBqdXN0IGNoYW5nZSB0aGUgYnl0ZQpiZWZvcmUgaXQgaXMgYWN0dWFsbHkgc3Vi
bWl0dGVkIGxhdGVyIGJ5ICJzZ19zY3NpX2lvY3RsKCkiLgoKQnV0IGl0IGlzIG5vbnNlbnNpY2Fs
IGFsc28gYmVjYXVzZSAic2dfc2NzaV9pb2N0bCgpIiBpdHNlbGYgYWxyZWFkeSBkb2VzCmJsa192
ZXJpZnlfY29tbWFuZCgpIG9uIHRoZSBjb21tYW5kIHByb3Blcmx5IGFmdGVyIGl0IGhhcyBiZWVu
IGNvcGllZApmcm9tIHVzZXIgc3BhY2UuCgpTbyBpdCBpcyBhbiBpbmNvcnJlY3QgaW1wbGVtZW50
YXRpb24gb2YgYSBwb2ludGxlc3MgY2hlY2suIFJlbW92ZSBpdC4KClNpZ25lZC1vZmYtYnk6IExp
bnVzIFRvcnZhbGRzIDx0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZz4KLS0tCiBkcml2ZXJz
L3Njc2kvc2cuYyB8IDkgLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgOSBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc2cuYyBiL2RyaXZlcnMvc2NzaS9zZy5jCmluZGV4
IGNkMmZkYWMwMDBjOS4uNGYzNDUwNzkzMjczIDEwMDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvc2cu
YworKysgYi9kcml2ZXJzL3Njc2kvc2cuYwpAQCAtMTEwMywxNSArMTEwMyw2IEBAIHNnX2lvY3Rs
KHN0cnVjdCBmaWxlICpmaWxwLCB1bnNpZ25lZCBpbnQgY21kX2luLCB1bnNpZ25lZCBsb25nIGFy
ZykKIAljYXNlIFNDU0lfSU9DVExfU0VORF9DT01NQU5EOgogCQlpZiAoYXRvbWljX3JlYWQoJnNk
cC0+ZGV0YWNoaW5nKSkKIAkJCXJldHVybiAtRU5PREVWOwotCQlpZiAocmVhZF9vbmx5KSB7Ci0J
CQl1bnNpZ25lZCBjaGFyIG9wY29kZSA9IFdSSVRFXzY7Ci0JCQlTY3NpX0lvY3RsX0NvbW1hbmQg
X191c2VyICpzaW9jcCA9IHA7Ci0KLQkJCWlmIChjb3B5X2Zyb21fdXNlcigmb3Bjb2RlLCBzaW9j
cC0+ZGF0YSwgMSkpCi0JCQkJcmV0dXJuIC1FRkFVTFQ7Ci0JCQlpZiAoc2dfYWxsb3dfYWNjZXNz
KGZpbHAsICZvcGNvZGUpKQotCQkJCXJldHVybiAtRVBFUk07Ci0JCX0KIAkJcmV0dXJuIHNnX3Nj
c2lfaW9jdGwoc2RwLT5kZXZpY2UtPnJlcXVlc3RfcXVldWUsIE5VTEwsIGZpbHAtPmZfbW9kZSwg
cCk7CiAJY2FzZSBTR19TRVRfREVCVUc6CiAJCXJlc3VsdCA9IGdldF91c2VyKHZhbCwgaXApOwot
LSAKMi4xOC4wLjEzMi5nOTVlZGEzZDg2Cgo=
--000000000000fc3d8f0570ae7e02--
