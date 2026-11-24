Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.152
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795515548;
	b=PFz3cecJGttHXYk/ytenWKuryDQzYrqz2bA/NON7CsbV9ErcA7jDn5KMZQm9RM/RxM1d
	 BXorFAMgpVmj+EaBetGQj/SOEvjPZpGoR/JPCXtyKoLRm7YqmlBMYohrOFHYgynHrtPKx
	 3zHQ2vvGrV9KNyz6AYsv6MnE3rvpDQ6f98NNFg9Nn/wFErMciKDKa7eflDoEv5akpmQs0
	 R0u9H6oWMtSes64ZcRGUOB8yVg+a4ym+ZiXJKfJZajRVKFbjqXfZopOLeZYxGU2autrdP
	 2HoNrLhdbTrH0GAxDKsMlHEGnLU2d+XC9gFZOP4Ai5oLrIOqwghvNaKdDmchVU997rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795515548;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=7gjY4lDtLDfFEG5jJ5KcBJdaWkzeeLrZAoxzAjd597Y=;
	b=rMDH4qeNr6FpRWJWFb+nqr3Yn1SwN7iYKIxGDSm0LePJgTYY0psTG6NroNUMI5A3I5qu
	 6Ydb6t1/O8zgk7XysN83T8fypbsIGbXprnA5MFIr/7UJv8JEaPL6egn3grVFDNtQx3QOG
	 aiDX6TMWr8JAO2FZffe5qkkcrh21zIfdOerEZKG6NhZZNprEPfTUERUGJqTrJoq4aXeu8
	 WhyRidN8p9UP2SQWjhlU/lcOpK82OtqTqmpM75ex/ruOgsqfk/nFQZ2YEutWA8cK+VZqb
	 Fc1JqTRMn0omL4BhCqiodSx1OiRQlcenY+tUipmo0nk61IIrLDBBo2E0HOzwmLFNG8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arndb.de;
	spf=pass smtp.mailfrom=arndb.de;
	dkim=pass header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=NUQP8SMT;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=WVtOEF13;
	arc=none smtp.remote-ip=202.12.124.152
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704D4606A32C
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 10:19:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 704D4606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=NUQP8SMT;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=WVtOEF13
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.stl.internal (Postfix) with ESMTP id AB6BD7A0512
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 05:19:07 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Tue, 24 Nov 2026 05:19:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795515540;
	 x=1795601940; bh=7gjY4lDtLDfFEG5jJ5KcBJdaWkzeeLrZAoxzAjd597Y=; b=
	NUQP8SMTJJO2xYrI7tEgPVG5raOGrS5KJO/y1UVzLLDu++nNkEPWcYYIpHFz5CHH
	Bt06yni1WxTSSj8M9iC7u6QRMoX39AGxyk48nCNCotTqNb1hYQ20IZ2FZWgPg6sE
	ce8pyABeVwGBzJaePWfQnm6N5QoROCoLuD0a0ix+cieFQt5rVfCsmyJuvKdQ2TGM
	5gkFzMOw2BzMdFQRPg2p/yQLQlOv13whwIafgnqBhwQjwgRKYkkckZqe/uEDosMv
	/tiWfi5+A1osgfTCTGXA5L9C4okJGA4Pq0x1fZkzKvPRe9a61hRUDt2nn4GSZHpl
	6RbrEVDJka3GNJUBvgccbA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795515540; x=
	1795601940; bh=7gjY4lDtLDfFEG5jJ5KcBJdaWkzeeLrZAoxzAjd597Y=; b=W
	VtOEF132H5uWki6l2Ru28rRWg4vWi0XKaGCDnGOLFJcIHoiqjPSDbGIxfJwcVUka
	Sb7w4L5K9gf8qAb9Xf/kOvCvFU6fSptTAHbvRRLxCWZFNC1sM5IK5ksLACM/aXuH
	cKFWihJ4zPYTLUu+SVE4XkevJQUPZw1RfOPDWZ+iyZp7BStaBoxJSAJQGUrDRHYE
	UMlX1OIZXn2sVVPdA8z6gixM3R0uzu0TNTzYPgpXL6QtjzZe3BLO9nk5HS35PhMR
	CXkosoGvZDkGIeikhiar3PZXBhdT7coTol6DHTs8IYk746XdPwGSJpuBTtxYnj37
	+AzTKqxsICbcHbCIQkgCA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795515540; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+;
	rt=PGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:GHdVqV7z/Y0J07COmNwoubypZSL/+EiQE2V/cZyxaQhZ+k+
	gmZXHjGvKld2cFIQh/7sGgxILi63475Eua13BK+JzFGKiq/9g0n2+XHy90Wp9PRY
	1K5iLui74zXJxnLu2HjxIF6+I2+wdCPHlGmSVKVDkvklP0e4y6LmA75hZRS+6nae
	vpBhAm1lejQ1sTpg8ie8B812Z6rjQY56pdtxLrdVOSqHyXYwhoD9NjbLJpSGgSrl
	GHs0fDeUvaLwr6w+cufBAX6avCfPSi0J2EA59HmxUNRVYZRznBE26mtW1f3SkdzF
	B7N/g3sP8jaZ2iIKBRp9+6LVoKYQgwB8U5S8s3w==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:evu2coAKmqt10MejIF/MF6J1JUOAfzXa2aFUsNMHDfo=:8EAuTrDt+pUZRs4Ox1H9GsvUkNKrKWTAO4Nvlr7LLpo=;
X-ME-Sender: <xms:j2QFa-exXqcv-ie1Eimjrwaj3K2VLfOJ28HYUmgmezGh2SWOHvlbUw>
    <xme:j2QFazAdqoUPfL43hGoH9E92CyAXFQSJ40mqWfGWOwnkXSAlG7k0X2bkjIkkimcZp
    l4Fd_qZ4UhXYYQLmcAaevSo7CaKr2fzDPRB2wD-dVgPzRdCow1RX6I>
X-ME-Proxy-Cause: dmFkZTEqiB9KxNkD/hivQQxMU5DgBt1slxhzcdhbvgIORfhac26QuPWf63hf1/R++71Pim
    5azqrwqBfB1py4LmV722M7QD6PFyEk6Ixdjn/QflFqoqWipQwW6kJN4sYp01yaYHgVD7K6
    Xa8a+ILm7gJWEFw40WRO+GG/s3KSd1yb6wOgkmPcZLKldWLvmGbR6dDuEO3odqVSlY8rpv
    uVclCjY4Ti51XLLxmrS+jT4f9qoQVpsHdcT/zSSmTOvLCzuCV50WMc+fnUN3yi+I3Epgns
    qZvq9gjumcathY/Wuxt4dhuKutl4hLM3BWabseitw6P2tKQ29LSg1T2ecr0wTFj8pwXQsx
    mZP+RrPvqUwdWJNTNuO+8Krq2Ye4nXZJYIHXvuEc+bHS2TP4nOCbAevlcWHCUnYdaADXjv
    l8W0iLhHlw7/RtaXn4jV/6HqWU9wwyrLVBSv1lItvQiNTf5plD5XQzy+0nAMHax3hb3VPB
    BIeMiefIrH5uy73Wvqa6I+2ruS9stNLKqfP4nB6fEX7jnoZePsLhCGOx0JPF6RUlU11s24
    6UvHB27mJhLSI+o2DNgX0jsF/L5dbO9PM2z4RdnwL243/jwf5yOmyb9H6rT3dbvXoLXYOW
    4Ni/txbPBGcG4ll3RckBUwURTeDt09Jeh9s1sFBDz4WPubRKbEEU0mcqUAVA
X-ME-Proxy: <xmx:kWQFa6kHDoQWVP4PWHxgWE7-q7WRBbD-YxNoJPOfbqaps0O0Pvacvw>
    <xmx:kWQFa9qD2C-KW7tWeGWQUtxUPdNfZiHGNlXAZi_t7X9D9eXKrRArwg>
    <xmx:kWQFa0A570bfVYCqGLpqhN-CnVqxfxBwu6TKpYeYqGNpjrireVhrAA>
    <xmx:kWQFa4Ed-ZoKV6-E_N3e60gxeNDoN2mgf1QxlUxncg191eicvwEJRQ>
    <xmx:lGQFa3W64BKTLBDlmNJ3Yj1c2IRnuCSE2pi3dSgENWny66Cks7aEu6y3>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 2BF9232A009F; Tue, 24 Nov 2026 05:18:55 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: AzzadY2dYG8o
Date: Tue, 24 Nov 2026 11:18:19 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Finn Thain" <fthain@linux-m68k.org>,
 "Bart Van Assche" <bvanassche@acm.org>
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>,
 "kernel test robot" <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
 linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
 "Linux Memory Management List" <linux-mm@kvack.org>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, scsi <linux-scsi@vger.kernel.org>
Message-Id: <f0ec2845-245d-43ac-9c96-242e0d1d11ea@app.fastmail.com>
In-Reply-To: <85e103fe-acca-0880-1be3-cb1e7f79f9a4@linux-m68k.org>
References: <20261121034304.2dPxVKzk-lkp@intel.com>
 <0b947a72-7a68-9bde-8b0b-adb539f09a8c@linux-m68k.org>
 <CAMuHMdUxYwD2t8zrqs4QBCtATOtf9xE83Djo0g7qbNFGSCWAQA@mail.gmail.com>
 <669b9ce8-bb33-f7ee-1087-88c1e9d3b610@linux-m68k.org>
 <8a0f78e3-5483-42a2-ae27-473bbb6de915@acm.org>
 <85e103fe-acca-0880-1be3-cb1e7f79f9a4@linux-m68k.org>
Subject: Re: include/linux/compiler_types.h:631:45: error: call to
 '__compiletime_assert_433' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
 sizeof(*u)
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, Nov 24, 2026, at 04:31, Finn Thain wrote:
> On Mon, 23 Nov 2026, Bart Van Assche wrote:
>
>> On 11/23/26 3:05 PM, Finn Thain wrote:
>> > Yes, two alternative solutions were submitted in March (either remove the
>> > assertion or rework it). The build bot reported the problem again in
>> > September so I resubmitted the "rework" alternative. Sashiko-bot didn't
>> > have much praise for that*, so now I'm leaning towards the "remove"
>> > alternative. I have been advised to keep re-submitting, and I will do so
>> > after a suitable back-off in retry rate i.e. 2027 or 2028.
>> > 
>> > *
>> > https://lore.kernel.org/r/93e35f60-e465-7f76-0043-f997fe2ec8c7@linux-m68k.org
>> 
>> What an LLM came up with after I asked it to fix 
>> https://lore.kernel.org/lkml/202603030747.VX0v4otS-lkp@intel.com/ can be 
>> found below. One of the comments of the LLM is "This is essentially Finn 
>> Thain's "Rework BUILD_BUG_ON() assertion" patch with your two review 
>> comments from this morning applied". Sashiko reports "No issues found" 
>> for the patch below. No Signed-off-by from me because I think Finn 
>> should be credited for his work instead of I.
>> 
>
> Thanks, Bart. I'll take that as a vote for "rework". There is an 
> associated risk though: I can't test the patch as I don't have access to 
> suitable hardware. (Perhaps someone with such access will volunteer.) 
>
> Whereas, the "remove" alternative doesn't require testing as it doesn't 
> risk a regression.
>
> I have a question for your LLM. Sashiko-bot said, in response to my patch:
>
>     Similarly, get_datalen_for_atio() accesses the array out-of-bounds 
>     when len > 0:
>
>     drivers/scsi/qla2xxx/qla_target.h:get_datalen_for_atio() {
>     ...
>         return get_unaligned_be32(&atio->u.isp24.fcp_cmnd.add_cdb[len * 4]);
>     ...
>     }
>
> I don't understand why the patch from your LLM did not raise the same OOB 
> access concerns.

I suspect that is just from Bart specifically calling it out in the changelog
already as a known limitation "Do not modify the memcpy() call in
qlt_queue_unknown_atio(), which still writes past the end of the 'atio'
member.".

> Adding a flex array to struct qla_tgt_sess_op can prevent new struct 
> members being added in the wrong spot in that struct but can't prevent new 
> struct members being added to struct atio7_fcp_cmnd. Neither does the 
> assertion. So the "remove" alternative doesn't have all the disadvantages 
> that you might expect.

This is probably just a difference in perception: atio_from_isp and
everything inside is clearly marked as a hardware structure that is
meant to align exactly to the 64 byte cacheline, so it would not
make any sense to change its layout and add more members here.
qla_tgt_sess_op on the other hand is clearly not a hardware structure
but an in-kernel one, so it is quite unexpected that one of its members
extends past the end, especially when the other three instances of
atio_from_isp in data structures don't seem to do that.

>> @@ -227,7 +224,7 @@ static void qlt_queue_unknown_atio(scsi_qla_host_t *vha,
>>   		add_cdb_len =
>>   			((unsigned int) atio->u.isp24.fcp_cmnd.add_cdb_len) * 4;
>> 
>> -	u = kzalloc(sizeof(*u) + add_cdb_len, GFP_ATOMIC);
>> +	u = kzalloc_flex(*u, extra_cdb, add_cdb_len, GFP_ATOMIC);
>>   	if (u == NULL)
>>  		goto out_term;

While this does make the current implementation more correct by having
the correct length, I'm worried that it just ends up establishing
the complexity more in the sense that extra_cdb extends both into
the padding and beyond qla_tgt_sess_op.

If the driver is still actively maintained, it would be nice to
reduce the complexity instead, in one of two ways:

a) make atio_from_isp naturally aligned by dropping the bogus
   __packed attribute, so it is actually at the end of qla_tgt_sess_op
   as the driver was written to expect. Note that having the
   outer structure as __packed but the union and the inner
   structs as aligned is itself problematic and can lead to
   undefined behavior, if some code ever takes a pointer to
   one of the inner aggregates and expects it to be aligned.
   The only effect that I see from the __packed annotation is
   that it forces expensive byte access on dma-coherent memory
   despite it being fully aligned.

b) rework the driver more broadly to never actually do any
   accesses beyond a struct boundary and make it work with
   sanitizers enabled. One way to do this would be to
   have a separate isp24 atio structure that is not in the
   union but that encloses the actual maximum length.
   Not sure how this would actually be done, but it appears
   that the current design keeps causing problems, see e.g.
   091719c21d5a ("scsi: qla2xxx: target: Fix invalid memory
   access with big CDBs") which adds more complexity around
   keeping an extra copy for it.

      Arnd
