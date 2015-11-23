From: Ming Lei <ming.lei@canonical.com>
Subject: Re: kernel BUG at drivers/scsi/scsi_lib.c:1096!
Date: Mon, 23 Nov 2015 10:46:20 +0800
Message-ID: <CACVXFVPWBnm8H4BgQ_=V-Z-NLrkt+TE7T_RpEctNrjEwpRpJhw@mail.gmail.com>
References: <1447838334.1564.2.camel@ellerman.id.au>
	<1447855399.3974.24.camel@redhat.com>
	<1447894964.15206.0.camel@ellerman.id.au>
	<20151119082325.GA11419@infradead.org>
	<1448021448.14769.7.camel@ellerman.id.au>
	<565055C6.5040801@linux.vnet.ibm.com>
	<20151122005635.1b9ffbe1@tom-T450>
	<1448234410.8209.3.camel@redhat.com>
	<CACVXFVMAm1niRvXqQXjOXW=ryy41d-ne09wSNbJUq3b9o6vJ7w@mail.gmail.com>
	<1448243411.8209.36.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11c30f78e8f5c005252c3a21
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:39916 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbbKWCqX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2015 21:46:23 -0500
In-Reply-To: <1448243411.8209.36.camel@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salter <msalter@redhat.com>
Cc: Laurent Dufour <ldufour@linux.vnet.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Christoph Hellwig <hch@infradead.org>, "James E. J. Bottomley" <JBottomley@odin.com>, brking <brking@us.ibm.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org, linux-block@vger.kernel.org

--001a11c30f78e8f5c005252c3a21
Content-Type: text/plain; charset=UTF-8

Hi Mark,

On Mon, Nov 23, 2015 at 9:50 AM, Mark Salter <msalter@redhat.com> wrote:
> On Mon, 2015-11-23 at 08:36 +0800, Ming Lei wrote:
>> On Mon, Nov 23, 2015 at 7:20 AM, Mark Salter <msalter@redhat.com> wrote:
>> > On Sun, 2015-11-22 at 00:56 +0800, Ming Lei wrote:
>> > > On Sat, 21 Nov 2015 12:30:14 +0100
>> > > Laurent Dufour <ldufour@linux.vnet.ibm.com> wrote:
>> > >
>> > > > On 20/11/2015 13:10, Michael Ellerman wrote:
>> > > > > On Thu, 2015-11-19 at 00:23 -0800, Christoph Hellwig wrote:
>> > > > >
>> > > > > > It's pretty much guaranteed a block layer bug, most likely in the
>> > > > > > merge bios to request infrastucture where we don't obey the merging
>> > > > > > limits properly.
>> > > > > >
>> > > > > > Does either of you have a known good and first known bad kernel?
>> > > > >
>> > > > > Not me, I've only hit it one or two times. All I can say is I have hit it in
>> > > > > 4.4-rc1.
>> > > > >
>> > > > > Laurent, can you narrow it down at all?
>> > > >
>> > > > It seems that the panic is triggered by the commit bdced438acd8 ("block:
>> > > > setup bi_phys_segments after splitting") which has been pulled by the
>> > > > merge d9734e0d1ccf ("Merge branch 'for-4.4/core' of
>> > > > git://git.kernel.dk/linux-block").
>> > > >
>> > > > My system is panicing promptly when running a kernel built at
>> > > > d9734e0d1ccf, while reverting the commit bdced438acd8, it can run hours
>> > > > without panicing.
>> > > >
>> > > > This being said, I can't explain what's going wrong.
>> > > >
>> > > > May Ming shed some light here ?
>> > >
>> > > Laurent, looks there is one bug in blk_bio_segment_split(), would you
>> > > mind testing the following patch to see if it fixes your issue?
>> > >
>> > > ---
>> > > From 6fc701231dcc000bc8bc4b9105583380d9aa31f4 Mon Sep 17 00:00:00 2001
>> > > From: Ming Lei <ming.lei@canonical.com>
>> > > Date: Sun, 22 Nov 2015 00:47:13 +0800
>> > > Subject: [PATCH] block: fix segment split
>> > >
>> > > Inside blk_bio_segment_split(), previous bvec pointer('bvprvp')
>> > > always points to the iterator local variable, which is obviously
>> > > wrong, so fix it by pointing to the local variable of 'bvprv'.
>> > >
>> > > Signed-off-by: Ming Lei <ming.lei@canonical.com>
>> > > ---
>> > >  block/blk-merge.c | 4 ++--
>> > >  1 file changed, 2 insertions(+), 2 deletions(-)
>> > >
>> > > diff --git a/block/blk-merge.c b/block/blk-merge.c
>> > > index de5716d8..f2efe8a 100644
>> > > --- a/block/blk-merge.c
>> > > +++ b/block/blk-merge.c
>> > > @@ -98,7 +98,7 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
>> > >
>> > >                       seg_size += bv.bv_len;
>> > >                       bvprv = bv;
>> > > -                     bvprvp = &bv;
>> > > +                     bvprvp = &bvprv;
>> > >                       sectors += bv.bv_len >> 9;
>> > >                       continue;
>> > >               }
>> > > @@ -108,7 +108,7 @@ new_segment:
>> > >
>> > >               nsegs++;
>> > >               bvprv = bv;
>> > > -             bvprvp = &bv;
>> > > +             bvprvp = &bvprv;
>> > >               seg_size = bv.bv_len;
>> > >               sectors += bv.bv_len >> 9;
>> > >       }
>> >
>> > I'm still hitting the BUG even with this patch applied on top of 4.4-rc1.
>>
>> OK, looks there are still other bugs, care to share us how to reproduce
>> it on arm64?
>>
>> thanks,
>> Ming
>
> Unfortunately, the best reproducer I have is to boot the platform. I have seen the
> BUG a few times post-boot, but I don't have a consistant reproducer. I am using
> upstream 4.4-rc1 with this config:
>
>   http://people.redhat.com/msalter/fh_defconfig
>
> With 4.4-rc1 on an APM Mustang platform, I see the BUG about once every 6-7 boots.
> On an AMD Seattle platform, about every 9 boots.

Thanks for the input, and I will try to reproduce the issue on mustang with
your kernel config.

>
> I have a script that loops through an ssh command to reboot the platform under test.
> I manually install test kernels and then run the script and wait for failure. While
> debugging, I have tried more minimal configs with which I have been unable to
> reproduce the problem even after several hours of reboots. With the above mentioned
> fh_defconfig, I have been able to get a failure within 20 or so boots with most
> kernel builds but at certain kernel commits, the failure has taken a longer time to
> reproduce.
>
> From my POV, I can't say which commit causes the problem. So far, I have not been
> able to reproduce at all before commit d9734e0d1ccf but I am currently trying to
> reproduce with commit 0d51ce9ca1116 (one merge earlier than d9734e0d1ccf).

The patch for fixing 'bvprvp' is better to be included for test,
because that issue
may have a big effect on computing physical seg count.

Also I appreciate if you, Laurent or anyone may provide debug log which
can be captured with the attached debug patch when this issue is trigered .


Thanks,

--001a11c30f78e8f5c005252c3a21
Content-Type: text/x-patch; charset=US-ASCII; name="dbg_scsi_blk_merge.patch"
Content-Disposition: attachment; filename="dbg_scsi_blk_merge.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ihbcpskq0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3NpX2xpYi5jIGIvZHJpdmVycy9zY3NpL3Njc2lf
bGliLmMKaW5kZXggZGQ4YWQyYS4uYTBkYjFmZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL3Nj
c2lfbGliLmMKKysrIGIvZHJpdmVycy9zY3NpL3Njc2lfbGliLmMKQEAgLTEwNzcsMTQgKzEwNzcs
MzEgQEAgdm9pZCBzY3NpX2lvX2NvbXBsZXRpb24oc3RydWN0IHNjc2lfY21uZCAqY21kLCB1bnNp
Z25lZCBpbnQgZ29vZF9ieXRlcykKIAl9CiB9CiAKK3N0YXRpYyB2b2lkIHNjc2lfZHVtcF9yZXEo
c3RydWN0IHJlcXVlc3QgKnJlcSkKK3sKKwlzdHJ1Y3QgYmlvX3ZlYyBidmVjOworCXN0cnVjdCBi
aW8gKmJpbzsKKwlzdHJ1Y3QgYnZlY19pdGVyIGl0ZXI7CisJaW50IGkgPSAwOworCisJX19ycV9m
b3JfZWFjaF9iaW8oYmlvLCByZXEpIHsKKwkJcHJpbnRrKCIlZC0lcFxuIiwgaSwgYmlvKTsKKwkJ
YmlvX2Zvcl9lYWNoX3NlZ21lbnQoYnZlYywgYmlvLCBpdGVyKSB7CisJCQlwcmludGsoIlx0ICVw
ICV1ICV1XG4iLCBidmVjLmJ2X3BhZ2UsCisJCQkJCWJ2ZWMuYnZfb2Zmc2V0LCBidmVjLmJ2X2xl
bik7CisJCX0KKwl9Cit9CisKIHN0YXRpYyBpbnQgc2NzaV9pbml0X3NndGFibGUoc3RydWN0IHJl
cXVlc3QgKnJlcSwgc3RydWN0IHNjc2lfZGF0YV9idWZmZXIgKnNkYikKIHsKLQlpbnQgY291bnQ7
CisJaW50IGNvdW50LCBwcmVfY291bnQgPSByZXEtPm5yX3BoeXNfc2VnbWVudHM7CisJaW50IGFs
bG9jX2NudCA9IHF1ZXVlX21heF9zZWdtZW50cyhyZXEtPnEpOwogCiAJLyoKIAkgKiBJZiBzZyB0
YWJsZSBhbGxvY2F0aW9uIGZhaWxzLCByZXF1ZXVlIHJlcXVlc3QgbGF0ZXIuCiAJICovCi0JaWYg
KHVubGlrZWx5KHNjc2lfYWxsb2Nfc2d0YWJsZShzZGIsIHJlcS0+bnJfcGh5c19zZWdtZW50cywK
KwlpZiAodW5saWtlbHkoc2NzaV9hbGxvY19zZ3RhYmxlKHNkYiwgYWxsb2NfY250LAogCQkJCQly
ZXEtPm1xX2N0eCAhPSBOVUxMKSkpCiAJCXJldHVybiBCTEtQUkVQX0RFRkVSOwogCkBAIC0xMDkz
LDYgKzExMTAsMTEgQEAgc3RhdGljIGludCBzY3NpX2luaXRfc2d0YWJsZShzdHJ1Y3QgcmVxdWVz
dCAqcmVxLCBzdHJ1Y3Qgc2NzaV9kYXRhX2J1ZmZlciAqc2RiKQogCSAqIGVhY2ggc2VnbWVudC4K
IAkgKi8KIAljb3VudCA9IGJsa19ycV9tYXBfc2cocmVxLT5xLCByZXEsIHNkYi0+dGFibGUuc2ds
KTsKKworCWlmIChjb3VudCA+IHNkYi0+dGFibGUubmVudHMpIHsKKwkJcHJpbnRrKCIlcyBwcmV2
IHZzLiBub3c6ICVkLSVkXG4iLCBfX2Z1bmNfXywgcHJlX2NvdW50LCBjb3VudCk7CisJCXNjc2lf
ZHVtcF9yZXEocmVxKTsKKwl9CiAJQlVHX09OKGNvdW50ID4gc2RiLT50YWJsZS5uZW50cyk7CiAJ
c2RiLT50YWJsZS5uZW50cyA9IGNvdW50OwogCXNkYi0+bGVuZ3RoID0gYmxrX3JxX2J5dGVzKHJl
cSk7Cg==
--001a11c30f78e8f5c005252c3a21--
