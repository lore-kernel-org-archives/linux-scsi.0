Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795201263;
	b=A/ND+i/uSKpnn4MtmC3P81yn3DHhFfI5Lz2k4jDENdMbEi7ujZpANd6VxuG9ogMMyZml
	 qjqDE1V8Ck+roDy2/y+bMxYX/+5xTz1SVsYpx6qHWwVFbmzXULNSM5tEQJkl3oxi76oDB
	 AyxgUFi6fjXj+fjy3/FaU2hm6rnBaZi6TqlmcOTL0FYPLjAY2PrPkBn9VG3QXyRclq6KA
	 XEyK85VeQKoH+VBe7fu4omLxgZQa9bedSfNuVFz5EKLH41wUhQ6WkDTon2PhTWK7wYEYn
	 B/+6HNxqsy/WaEqBVZOyhdav01ELbV/eztwO7pKpnYP0AbCkpugSi/7fYE4c0DLia6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795201263;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=x/cJrK5hJQJmQXtcIXag07pJ6jf6c/C/z5CdzDpNgrk=;
	b=XBmUvSd6EUTDe0OnzxW+nWCphED8HhAdXunBaMXMVuvnxmv69GhtXx4GwDXE0SnOS6fl
	 JqbG+P8VJ2F8WDrDx4Zk7DoBwWSiAZJmjAtmj6nLvWyq46Yf9ASJwqDPxpJOGSqPYmVV+
	 3kO5uDmsI4XNAUqksvCncM1EkCqnlbjz50OA3wKCz/WA0QoIC6MvFKyDX1/FUrvr5LfDW
	 15/w6P5UW+iQbDCiE1+MGywO3DPxal1Mt2AilFi3yzJXTtxb6rw0mLIyppWT/yutMgR3l
	 bA4yqjQUAJ0BTO5mGXSx9XEyyjJLkyBD64PysAhtUzuXJUd6o4JPAERxIkQuqw0AZUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=AmhXsJnY;
	arc=none smtp.remote-ip=74.125.82.69
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E07A60A2617
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 19:01:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E07A60A2617
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=AmhXsJnY
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-1b3b5b49cabso1200648c88.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795201261; x=1795806061; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x/cJrK5hJQJmQXtcIXag07pJ6jf6c/C/z5CdzDpNgrk=;
        b=AmhXsJnY8o3C56RbAlXbU+Bi0XX/gdu1MWR/y4VMv5sQCrOu3hNJnl5dqiBWXp6qP0
         MsuTOKUN7kYipxQ6RWlHsw7mtKXz1pg6LKef0PfQHJ4vNxBw7c3Etf6+I0ZqnN3Gg0mi
         qZuZ1jNqj+m+ZMSrUcSPjPHt273G1iVvHT8xJW4cYJSn76s2akkXu9uTLIzMyhq58G61
         HJL7isCTiXNyii/pX82R3AMby4hSQGuN0jpOTvkTq6Q4I0wZVHtg0QfmknIUXvPSYBZi
         v3D9MpadfuHQx+ISWDzy4YFb9fKMQA1xsIS05Z5xMp3I4Ksqo/spvBrG/L7Z6QKjK4FY
         yzkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795201261; x=1795806061;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x/cJrK5hJQJmQXtcIXag07pJ6jf6c/C/z5CdzDpNgrk=;
        b=jidf2GDtFJFgi6l6rl6iagOx/fqZ0hqHsclSQlr1k/4fNhDJ7nx1nQX2iVTsgRNMJl
         mMw9EyegBRBuuGceJn3XLgGEuSvTmCew1KH6eo7M7yP9cLFJyEUnjp93TqRWB+FM/gEI
         dAYQK9DQsojT88Ji2rDncY1U3atUsrYMJjNLyO92KBg7qwuzFnmGZVlI52zKXa39A/EB
         y9gzQVPAyLhdjJUq15jVdy56ctzrr+FPqN+eeJ1TPJj9z1mwOCI6tKKS+0rTcHFw7Z98
         WoidvD4XAlAmtoYgFIyWJXnqmSBTKvc4QdZjHaNySOmv0SZdvk69kyK9qj7oebQO9vp7
         HQvg==
X-Forwarded-Encrypted: i=1; AL+hErFY0sFNnB1UF0rWjxcNB7KgpW6J4RCkA2UEc7VgsMW/L3nFdyFe7ylzeULWtdanckSURvYvMrP/AOs4@vger.kernel.org
X-Gm-Message-State: APuU4Z+P4FQb7doQhsUysSE0rFBqD/RWHSGBIABnqW+p/LBh6Xz+sdTq
	ZCJ5kNUjl3yyUjvh2VwCYuJPIwnqEjf3UMT0WMkAy6xiQhQ5BDvo9x9E83wkj/GzTkoJfdYNuGS
	qmNcj3tJu4w==
X-Received: from dlbtu1.prod.google.com ([2002:a05:7022:3c01:b0:197:f679:f62d])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:e882:b0:1b5:481:ff0f
 with SMTP id a92af1059eb24-1b55692fd20mr3946544c88.32.1795201259386; Fri, 20
 Nov 2026 11:00:59 -0800 (PST)
Date: Fri, 20 Nov 2026 11:00:31 -0800
In-Reply-To: <20261120190031.1587531-1-irogers@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261120190031.1587531-1-irogers@google.com>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261120190031.1587531-4-irogers@google.com>
Subject: [PATCH v2 3/3] scsi: mpi3mr: Avoid ready_timeout underflow in mpi3mr_bring_ioc_ready()
From: Ian Rogers <irogers@google.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Laurence Oberman <loberman@redhat.com>, mpi3mr-linuxdrv.pdl@broadcom.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, Elkin Cruz <elkin@google.com>, Ian Rogers <irogers@google.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Commit 9634bb07083c ("scsi: mpi3mr: Enhance the Enable Controller retry
logic") caps cumulative enable retries at 'mrioc->ready_timeout - 60'
(510 seconds on firmware advertising a 570-second ready timeout) so a
retry is not started with less than 60 seconds remaining.

Because mrioc->ready_timeout is a u32 read from the controller's
ioc_information register, any value below 60 (for example 0 from a
broken or disconnected controller) wraps around in 32-bit unsigned
arithmetic (e.g. 0xffffffc4) before zero-extending to u64 for the
comparison with elapsed_time_sec, spuriously retrying instead of
aborting.

Rewrite the check as 'elapsed_time_sec + 60 < mrioc->ready_timeout' to
avoid unsigned underflow while preserving the 60-second margin when
ready_timeout >= 60. (Note that if any firmware legitimately advertises
ready_timeout < 60, no retries will be attempted.)

Found during code inspection alongside a Clang warning audit with AI
coding assistant help. Verified with a standalone C reproducer under
UBSan and by building drivers/scsi/mpi3mr/mpi3mr_fw.o with LLVM=1 W=1
(-Werror); not runtime-tested on MPI3 hardware.

Fixes: 9634bb07083c ("scsi: mpi3mr: Enhance the Enable Controller retry logic")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Rogers <irogers@google.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 1aeae8a55b1b..45544ad21a6e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1734,7 +1734,7 @@ retry_bring_ioc_ready:
 
 out_failed:
 	elapsed_time_sec = jiffies_to_msecs(jiffies - start_time)/1000;
-	if ((retry < 2) && (elapsed_time_sec < (mrioc->ready_timeout - 60))) {
+	if (retry < 2 && elapsed_time_sec + 60 < mrioc->ready_timeout) {
 		retry++;
 
 		ioc_warn(mrioc, "retrying to bring IOC ready, retry_count:%d\n"
-- 
2.56.1.750.gf70dc682cf-goog

