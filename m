From: Peter Chang <dpf@google.com>
Subject: Re: question about DID_RESET handling
Date: Thu, 28 Oct 2010 15:57:44 -0700
Message-ID: <AANLkTi=BWdTMGEuMk-u5mQP7VpBd3k2PLKrdq==A_unw@mail.gmail.com>
References: <20101028162239.10346b0ye9g07iww@webmail.meer.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016364d30276735600493b546f5
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:47265 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379Ab0J1W6K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 18:58:10 -0400
Received: from kpbe12.cbf.corp.google.com (kpbe12.cbf.corp.google.com [172.25.105.76])
	by smtp-out.google.com with ESMTP id o9SMw8Se032116
	for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2010 15:58:08 -0700
Received: from qwf7 (qwf7.prod.google.com [10.241.194.71])
	by kpbe12.cbf.corp.google.com with ESMTP id o9SMvc38005272
	for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2010 15:58:06 -0700
Received: by qwf7 with SMTP id 7so1723397qwf.33
        for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2010 15:58:06 -0700 (PDT)
In-Reply-To: <20101028162239.10346b0ye9g07iww@webmail.meer.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--0016364d30276735600493b546f5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Le 28 octobre 2010 13:22, weasel@meer.net <weasel@meer.net> a =E9crit :
> scsi_decide_disposition() looking at a command w/ DID_RESET returns
> SUCCESS and then scsi_io_completion() unconditionally retries the
> command. w/ our injector setup to corrupt alternating data frames i can
> induce an 'infinite loop' in the case where the controller's reset works
> and then the scsi READ(10) fails.
>
> anyway, i'd like to avoid this loop regardless of 'odd' controller
> behavior so am asking about the two possible fixes i see and to see if
> there's some other way.
>
> - make scsi_decide_disposition()'s handling of DID_RESET just use the
> =A0maybe_retry logic.
>
> =A0however, (being new to this area) scsi_io_completion() calls
> =A0scsi_end_request() in case some data actually got read. i don't see th=
at
> =A0a request w/ DID_RESET set can have data, but if it really can, then..=
.
>
> - copy retry logic to scsi_io_completion() in the DID_RESET case. using
> =A0cmd->retries seems safe here since it won't ahve gotten updated in
> =A0scsi_decide_disposition(), but maybe a comment there might be nice.

in the hopes that i can get a fix pushed upstream of us, i've attached
patches for my two alternatives listed above.

i realize that my error is now artificially induced, but it did
startoff as a real error where something as simple as 'mount /dev/sdb1
/mnt/foo' went off into the weeds. yes, the controller can do better,
but i think we already have the infrastructure in place to avoid this.

\p

--0016364d30276735600493b546f5
Content-Type: application/octet-stream; name="scsi_decide_disposition.diff"
Content-Disposition: attachment; filename="scsi_decide_disposition.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gfu8d9zz0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3NpX2Vycm9yLmMgYi9kcml2ZXJzL3Njc2kvc2Nz
aV9lcnJvci5jCmluZGV4IDdhZDUzZmEuLjQ0OWNjYzkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2Nz
aS9zY3NpX2Vycm9yLmMKKysrIGIvZHJpdmVycy9zY3NpL3Njc2lfZXJyb3IuYwpAQCAtMTQ0Niw3
ICsxNDQ2LDcgQEAgaW50IHNjc2lfZGVjaWRlX2Rpc3Bvc2l0aW9uKHN0cnVjdCBzY3NpX2NtbmQg
KnNjbWQpCiAJCQlyZXR1cm4gRkFJTEVEOwogCQl9CiAJY2FzZSBESURfUkVTRVQ6Ci0JCXJldHVy
biBTVUNDRVNTOworCQlnb3RvIG1heWJlX3JldHJ5OwogCWRlZmF1bHQ6CiAJCXJldHVybiBGQUlM
RUQ7CiAJfQo=
--0016364d30276735600493b546f5
Content-Type: application/octet-stream; name="scsi_io_completion.diff"
Content-Disposition: attachment; filename="scsi_io_completion.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gfu8dhuf1

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3NpX2xpYi5jIGIvZHJpdmVycy9zY3NpL3Njc2lf
bGliLmMKaW5kZXggMTY0NmZlNy4uYjk5Yzg3YyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL3Nj
c2lfbGliLmMKKysrIGIvZHJpdmVycy9zY3NpL3Njc2lfbGliLmMKQEAgLTc5OSwxMCArNzk5LDEz
IEBAIHZvaWQgc2NzaV9pb19jb21wbGV0aW9uKHN0cnVjdCBzY3NpX2NtbmQgKmNtZCwgdW5zaWdu
ZWQgaW50IGdvb2RfYnl0ZXMpCiAKIAlpZiAoaG9zdF9ieXRlKHJlc3VsdCkgPT0gRElEX1JFU0VU
KSB7CiAJCS8qIFRoaXJkIHBhcnR5IGJ1cyByZXNldCBvciByZXNldCBmb3IgZXJyb3IgcmVjb3Zl
cnkKLQkJICogcmVhc29ucy4gIEp1c3QgcmV0cnkgdGhlIGNvbW1hbmQgYW5kIHNlZSB3aGF0Ci0J
CSAqIGhhcHBlbnMuCisJCSAqIHJlYXNvbnMuIHNjc2lfZGVjaWRlX2Rpc3Bvc2l0aW9uKCkgZG9l
c24ndCBoYW5kbGUKKwkJICogdGhlIHJldHJ5IGxvZ2ljIGJlY2F1c2UgKGluIHRoZW9yeSkgd2Ug
bWlnaHQgaGF2ZQorCQkgKiBoYWQgc29tZXRoaW5nIGZvciBzY3NpX2VuZF9yZXF1ZXN0KCkgYWJv
dmUuCiAJCSAqLwotCQlhY3Rpb24gPSBBQ1RJT05fUkVUUlk7CisJCWFjdGlvbiA9ICgrK2NtZC0+
cmV0cmllcykgPD0gY21kLT5hbGxvd2VkCisJCQk/IEFDVElPTl9SRVRSWQorCQkJOiBBQ1RJT05f
RkFJTDsKIAl9IGVsc2UgaWYgKHNlbnNlX3ZhbGlkICYmICFzZW5zZV9kZWZlcnJlZCkgewogCQlz
d2l0Y2ggKHNzaGRyLnNlbnNlX2tleSkgewogCQljYXNlIFVOSVRfQVRURU5USU9OOgo=
--0016364d30276735600493b546f5--
