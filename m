From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] [SCSI]: libsas failure to revalidate domain for anything
 but the first expander child.
Date: Wed, 7 Sep 2011 12:26:02 -0700
Message-ID: <CAA9_cmcRFvvOtQTBhYDj6HFbGwn_FsTFwYg=d+A_phBKEgCtCw@mail.gmail.com>
References: <20110730002509.28735.82590.stgit@localhost6.localdomain6>
	<FC1F9E38C0703341A1A750524E2525A901853EC8@XYUS-EX22.xyus.xyratex.com>
	<FC1F9E38C0703341A1A750524E2525A901853F74@XYUS-EX22.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=bcaec520f2b330f2a304ac5eeaf2
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39727 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab1IGT0E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2011 15:26:04 -0400
Received: by gxk21 with SMTP id 21so172011gxk.5
        for <linux-scsi@vger.kernel.org>; Wed, 07 Sep 2011 12:26:03 -0700 (PDT)
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A901853F74@XYUS-EX22.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
Cc: linux-scsi@vger.kernel.org, Luben Tuikov <ltuikov@yahoo.com>, Darrick J Wong <djwong@us.ibm.com>, James Bottomley <jbottomley@parallels.com>, Xiangliang Yu <yuxiangl@marvell.com>, Jack Wang <jack_wang@usish.com>

--bcaec520f2b330f2a304ac5eeaf2
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Sep 1, 2011 at 6:11 AM, Mark Salyzyn
<mark_salyzyn@us.xyratex.com> wrote:
> In an enclosure model where there are chaining expanders to a large body
> of storage, it was discovered that libsas, responding to a broadcast
> event change, would only revalidate the domain of first child expander
> in the list.
>
> The issue is that the pointer value to the discovered source device was
> used to break out of the loop, rather than the content of the pointer.
>
> This still remains non-compliant as the revalidate domain code is
> supposed to loop through all child expanders, and not stop at the first
> one it finds that reports a change count. However, the design of this
> routine does not allow multiple device discoveries and that would be a
> more complicated set of patches reserved for another day. We are fixing
> the glaring bug rather than refactoring the code.
>
> Please note, as I am *stuck* on Outlook as per company policy, the
> following inline content will likely not patch clean even emailed as
> 'Plain Text', the enclosed attached file should do the job.

Yeah, Outlook helped you out with some line wrapping.  The attachment
is missing "From:", "Subject::" and the rest of the changelog, I went
ahead and attached a revised version.

> I have Cc'd
> all the folks that originated the files in libsas, as there was no
> listed MAINTAINERs.

I wouldn't mind being cc'd on all libsas patches, probably all the
other libsas lldd maintainers would like to be cc'd as well (added
Xiangliang (mvsas) and Jack (pm8001))

> Checkpatch.pl reports clean. Patch applies cleanly to a WIDE variety of
> kernels up to latest.
>
> Sincerely -- Mark Salyzyn
>
> Cc: Luben Tuikov <tuikov@yahoo.com>
> Cc: Darrick J Wong <djwong@us.ibm.com>
> Cc: James Bottomley <jbottomley@parallels.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

--bcaec520f2b330f2a304ac5eeaf2
Content-Type: text/x-patch; charset=US-ASCII; name="expander_bug.patch"
Content-Disposition: attachment; filename="expander_bug.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gsap5iyx1

RnJvbSBlMzU2OWNmNmU3MWY5NDM1YWY4NDc2YzY3Mjk2MjRjZjMyODcwMzI2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJrIFNhbHl6eW4gPG1hcmtfc2FseXp5bkB1cy54eXJhdGV4
LmNvbT4KRGF0ZTogVGh1LCAxIFNlcCAyMDExIDA2OjExOjE3IC0wNzAwClN1YmplY3Q6IFtQQVRD
SF0gbGlic2FzOiBmYWlsdXJlIHRvIHJldmFsaWRhdGUgZG9tYWluIGZvciBhbnl0aGluZyBidXQg
dGhlCiBmaXJzdCBleHBhbmRlciBjaGlsZAoKSW4gYW4gZW5jbG9zdXJlIG1vZGVsIHdoZXJlIHRo
ZXJlIGFyZSBjaGFpbmluZyBleHBhbmRlcnMgdG8gYSBsYXJnZSBib2R5Cm9mIHN0b3JhZ2UsIGl0
IHdhcyBkaXNjb3ZlcmVkIHRoYXQgbGlic2FzLCByZXNwb25kaW5nIHRvIGEgYnJvYWRjYXN0CmV2
ZW50IGNoYW5nZSwgd291bGQgb25seSByZXZhbGlkYXRlIHRoZSBkb21haW4gb2YgZmlyc3QgY2hp
bGQgZXhwYW5kZXIKaW4gdGhlIGxpc3QuCgpUaGUgaXNzdWUgaXMgdGhhdCB0aGUgcG9pbnRlciB2
YWx1ZSB0byB0aGUgZGlzY292ZXJlZCBzb3VyY2UgZGV2aWNlIHdhcwp1c2VkIHRvIGJyZWFrIG91
dCBvZiB0aGUgbG9vcCwgcmF0aGVyIHRoYW4gdGhlIGNvbnRlbnQgb2YgdGhlIHBvaW50ZXIuCgpU
aGlzIHN0aWxsIHJlbWFpbnMgbm9uLWNvbXBsaWFudCBhcyB0aGUgcmV2YWxpZGF0ZSBkb21haW4g
Y29kZSBpcwpzdXBwb3NlZCB0byBsb29wIHRocm91Z2ggYWxsIGNoaWxkIGV4cGFuZGVycywgYW5k
IG5vdCBzdG9wIGF0IHRoZSBmaXJzdApvbmUgaXQgZmluZHMgdGhhdCByZXBvcnRzIGEgY2hhbmdl
IGNvdW50LiBIb3dldmVyLCB0aGUgZGVzaWduIG9mIHRoaXMKcm91dGluZSBkb2VzIG5vdCBhbGxv
dyBtdWx0aXBsZSBkZXZpY2UgZGlzY292ZXJpZXMgYW5kIHRoYXQgd291bGQgYmUgYQptb3JlIGNv
bXBsaWNhdGVkIHNldCBvZiBwYXRjaGVzIHJlc2VydmVkIGZvciBhbm90aGVyIGRheS4gV2UgYXJl
IGZpeGluZwp0aGUgZ2xhcmluZyBidWcgcmF0aGVyIHRoYW4gcmVmYWN0b3JpbmcgdGhlIGNvZGUu
CgpDYzogTHViZW4gVHVpa292IDx0dWlrb3ZAeWFob28uY29tPgpDYzogRGFycmljayBKIFdvbmcg
PGRqd29uZ0B1cy5pYm0uY29tPgpDYzogSmFtZXMgQm90dG9tbGV5IDxqYm90dG9tbGV5QHBhcmFs
bGVscy5jb20+ClJldmlld2VkLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVs
LmNvbT4KU2lnbmVkLW9mZi1ieTogTWFyayBTYWx5enluIDxtc2FseXp5bkB1cy54eXJhdGV4LmNv
bT4KLS0tCiBkcml2ZXJzL3Njc2kvbGlic2FzL3Nhc19leHBhbmRlci5jIHwgICAgMiArLQogMSBm
aWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zY3NpL2xpYnNhcy9zYXNfZXhwYW5kZXIuYyBiL2RyaXZlcnMvc2NzaS9saWJz
YXMvc2FzX2V4cGFuZGVyLmMKaW5kZXggODc0ZTI5ZC4uN2Q2ODUxNyAxMDA2NDQKLS0tIGEvZHJp
dmVycy9zY3NpL2xpYnNhcy9zYXNfZXhwYW5kZXIuYworKysgYi9kcml2ZXJzL3Njc2kvbGlic2Fz
L3Nhc19leHBhbmRlci5jCkBAIC0xNzE4LDcgKzE3MTgsNyBAQCBzdGF0aWMgaW50IHNhc19maW5k
X2JjYXN0X2RldihzdHJ1Y3QgZG9tYWluX2RldmljZSAqZGV2LAogCWxpc3RfZm9yX2VhY2hfZW50
cnkoY2gsICZleC0+Y2hpbGRyZW4sIHNpYmxpbmdzKSB7CiAJCWlmIChjaC0+ZGV2X3R5cGUgPT0g
RURHRV9ERVYgfHwgY2gtPmRldl90eXBlID09IEZBTk9VVF9ERVYpIHsKIAkJCXJlcyA9IHNhc19m
aW5kX2JjYXN0X2RldihjaCwgc3JjX2Rldik7Ci0JCQlpZiAoc3JjX2RldikKKwkJCWlmICgqc3Jj
X2RldikKIAkJCQlyZXR1cm4gcmVzOwogCQl9CiAJfQotLSAKMS43LjYKCg==
--bcaec520f2b330f2a304ac5eeaf2--
