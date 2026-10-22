Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.79.88.28
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792709177;
	b=Gyi6giRyxxY3XPYWfp0NascUpdjgQ9xarYPbAylPpLS2RD3y9CirLVGMwHh6OcKvkwLz
	 BZJ12Vfg0aKnkuGWKCLi2buURkN38TZO56sNd6V4FTqg+L3zJ59GdWAvgM8mZKjBtYKEh
	 MITcXR5rQ00+9I4vPnRw8X8XTL8wldVM0suWxmLW3jmmcbsys33BonsH2dT4O/PD8e+0f
	 2/deDpuqZo6lPKTnk+BvaR9u5QGSd6g/KNDumetzAgENCtqZsLUAnbwqfsBGqa33yY1fA
	 /oC1XyWZQ+aveiBV8YHaG/UTpgBzlfOWoXbt1gJZR5ndDjtjcgMEK+PobtxVRRgK/pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792709177;
	h=DMARC-Filter:DKIM-Filter:DKIM-Signature:Received:From:To:Cc:Subject:
	 In-Reply-To:References:Date:Message-ID:MIME-Version:Content-Type;
	bh=pygFZ9vqYBILhtMeY66ELPOJ+MRQd/5b0EPAclzFcAQ=;
	b=rQ/wvFpl8qDY8Z5Qhc1m+r7ET3/Q5W1JRFfIFtBWE0ZBokL2fzD8Lu/yasHg6nGfPcF/
	 QqKuLBBg2Slu0Tglk0BB38IotIwQKzPSSwAKEC52s3gnsHaBn+aRHEDaLW3zubEls86fc
	 7Q8T71epFOgRDcMaPj3ga4zotUMWneJIyl/RNzy0Vcr248KdaY7vWpdyZjM87VtK6GVBm
	 fBopbETIamoyir9M9erq08adpfH5ufbNGUMFgrTT1ctSWWbegzX2bAOifyrFOBjLv0slZ
	 Pp9TPnEG0/yyam9B7CEaSTymAOv/jkzGDgvwZzwfpKu2OLN2MSMGWT/TIrSIripOdbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lwn.net;
	spf=pass smtp.mailfrom=lwn.net;
	dkim=pass header.d=lwn.net header.i=@lwn.net header.a=rsa-sha256 header.s=20201203 header.b=plLRNEg3;
	arc=none smtp.remote-ip=45.79.88.28
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10101606A31A;
	Thu, 22 Oct 2026 22:46:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10101606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=lwn.net header.i=@lwn.net header.a=rsa-sha256 header.s=20201203 header.b=plLRNEg3
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net DD0BC40430
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1792709176; bh=pygFZ9vqYBILhtMeY66ELPOJ+MRQd/5b0EPAclzFcAQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=plLRNEg3aJjupC8b2HPHX07IUAuKggNyhASz34cMN0inqcrig8adFsrs8N/dfsjIs
	 MFDyCm4sURsK/JHkkA7d9fZkGmY/kI6GClTtLv98Ydckveh5TIRZvvBwebS8OcRFa5
	 /YaPbQjXNjF/cVWJF+BMvUmTI7KSsrs8RJTbS8Q3q89WZNGwdkb4XPXgVN1cqis9pV
	 psoisvUuwdgJqFLyzzdcvgt5Ho+xrlKILQh4KA68LMmUdr0coPmJzMlqUj4bbNa65y
	 Kbr8imsXyi4/RCIvtWA4J8MuSULVUPlDlHNQe59/7NmmOo4yn2U/POVPDiABl97q62
	 zhVbF6mMzmBRA==
Received: from localhost (unknown [IPv6:2601:280:4600:814::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id DD0BC40430;
	Thu, 22 Oct 2026 22:46:15 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Breno Rodrigues Alves <breno3011alves@gmail.com>
Cc: linux@armlinux.org.uk, Bart Van Assche <bvanassche@acm.org>,
 James.Bottomley@HansenPartnership.com, mkp@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, Breno Rodrigues Alves
 <breno3011alves@gmail.com>
Subject: Re: [PATCH v4] scsi: arm: Convert acornscsi-io.S to C
In-Reply-To: <20261022222819.92507-1-breno3011alves@gmail.com>
References: <20261022183658.58090-1-breno3011alves@gmail.com>
 <20261022185224.60700-1-breno3011alves@gmail.com>
 <20261022185224.60700-2-breno3011alves@gmail.com>
 <871p9h1kc7.fsf@trenco.lwn.net> <87wlr9z8iq.fsf@trenco.lwn.net>
 <20261022222819.92507-1-breno3011alves@gmail.com>
Date: Thu, 22 Oct 2026 16:46:14 -0600
Message-ID: <87o6clz749.fsf@trenco.lwn.net>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Breno Rodrigues Alves <breno3011alves@gmail.com> writes:

> You are also right about the broader point: "assembly to C" on its own
> is not a justification.  The kernel's assembly is there for reasons, and
> translating it for its own sake is churn that reviewers have to pay for.
> I have been approaching this as a translation exercise, and that is not
> the right frame.  I will not propose further conversions of that kind
> without a concrete functional benefit - something that fixes a bug that
> can actually be hit, or enables a change that cannot be done in assembly.

Note that conversion to C can be justified if it eases the maintenance
of the file in question.  In this case, there's not really been any need
for maintenance, so (in my mind) little need for translation.

> Bart's Reviewed-by: stands on the technical merits of the change as a
> change (the C code is equivalent to the assembly for even lengths and
> correct for odd ones).  Your concern is a different question - whether
> the change should exist at all.  Both are valid, and the decision
> belongs to the SCSI maintainers, not to me.

Bart's word outweighs mine here, just to be clear.

jon
