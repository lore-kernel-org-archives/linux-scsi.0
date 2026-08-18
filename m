Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAB6243964
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 04:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787028707; cv=none; b=Hym/PyhqBGjHKqpzgqw69WfUAN9GmKCdErHJ/+JL0f5LGx6/D479xxuXc0uHDhAxJ6Jb7//LGKGCOspw97AlwVAlVzzxjy1QL3y2kw0ZRBEXiAu/+NGKt9SRJhHdkDzWiogr1Tzeem3fY30M8zHPdbVTX/WJf/QyB7yG3LAZruc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787028707; c=relaxed/simple;
	bh=X1DtbALC8lq/ghoiIC6r92wHhi4MIrtWASByGX/cqA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/aI+RFmYDD5A0gujVHgNmyxgJnVkD/ttRL/qiWBteWR8pNRde9qy1KAQ3E2yTG9x7fskGBv50CeGTuThT85QB9ipYySdAK8RS9FMUs8cv5jtyWYPbAtzeCZSMrLrcb1juqCwQQZktERX+IYQE7VPOSrydgKjmoIqt/Bd8bCE3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=gQAfjlXl; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="gQAfjlXl"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cace91f112so49128495ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 21:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1787028705; x=1787633505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ss7P/kgwCwj4T2j+XXbkDqzG57+Au+3YcauiAcKnt/Y=;
        b=gQAfjlXlTUlBKZE16gE8JOWeohyBJV7jhvM6EoSWDWhQC7SU8pcqRCDj9rLtqXNRNC
         X/lFJF0OFNlxVwRN0hEvnZNwvWEmuuxxmNR1oRJPFTx/3C41PswXF2F5fagcVx6tnQgT
         wnJBwKJyVmKOfnS4aMKvdI8BiEGmze9i9g3YvMV4/YDIlBGILvac+65I5YFU3ro32Shi
         fgtq5SdYGH3JxU1iGo9egQTNDyePRVxQZ5WL05VAv4HP2R8A+5xWx+D4bl8718ClMoW/
         EscYK7g2KaSVkfO35tFqE9sA10vLIf3v+MDBqOebvQLdSSRPBhEZQcwGzzcAWl4NVdYs
         +Zdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787028705; x=1787633505;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ss7P/kgwCwj4T2j+XXbkDqzG57+Au+3YcauiAcKnt/Y=;
        b=pkteGKJ/mqqpdcT4VFrj4MSfDZPFcBSJ+BaNdFeZE79IryaBK4FLwILYWqJ8xZAUUo
         c4WqXQbzZcEbRUr6+7ydpvs9pD6MDHTQUw81lPaqzfaKBoOyKT0GSOzY0w2Ep/icGSbZ
         7WOZIX7mtJvC4ffXM6dwupDUnsD2KXAfPuYMHGeBQT4iYkXxT/xNdLahMPIGYiX8FMZJ
         JW7ponNH9a6f6RwNH3Ulv8cGUI3D898sIUJzWGS+0rV8ISAlXVmpT3eBmlCtuMxnZphi
         q3nivXgQOkEDXnhaag02nJTiNJn2bC/Jixb43QcFBCdnR0+/weH9fgBwvy8+HnXa1wcJ
         jzug==
X-Forwarded-Encrypted: i=1; AHgh+RpzNySMUu/3fqrHKLM/ajYDC7fsfxM9Ik57X0D8DZCDmEV2e0vvp4sDqLBmua1YbR3S0rB1POtyTBuj@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs+if1lJ2iowVaKkUGDJCqCCx3rbEYtHB13P6q+lk8TZbWYtKl
	bbiFdAApY65DHXUI0OpSv3NEPQ72yvmUf2OhDidWdrYttK0bf3iJSR0uYDxKTphAwoyi0LjTf/D
	J734ET3E=
X-Gm-Gg: AR+sD11KLEARC8Nwd+jksxnSGfzYkM5SrTy11DuczGe49bSvcKZhC8rg+ACmS+7BMRs
	wxu247zoeFozpeH3pw1y426YQ3T2vDZmlXP5Jli4FtaKAneN6u+a8w9gy664m1cCXaAoIRU2MZY
	mVbmbrx8p/P6+1Qgjf5+RtXi1xJkOYHs+hyf0BigevD7FugS1ENoiOKtRj+CNKRZfyEv3RDpgq4
	offeuFOY8F4I4oLT4wJyJTGJc/KDZFF+dmBGgEWJRv5jMRuLl4B9a8azuqi81j3ZV4VmxY3Hp5G
	/ns8VXfWqEK1HKcvRfjIdO2uu/15Fj40bbtxD0iQ58euz6fKC8A+S2Rcftod80vYlgQcI5WcXvE
	Q+4lnAgs+49W1hRoDQHZlUlq3sgJp1JRN6A8ahVcsaRswFQuHhkK4S39jC25oO1kbyDyXM++vja
	v9l1Wq/S43UMFI8YUl+BGpURtMW2Lz2yaYTvMTaA88cUwa8JonrR02ien5KTnFqOUbNshZ
X-Received: by 2002:a17:902:fc4e:b0:2d5:2f49:b3de with SMTP id d9443c01a7336-2d52f49c24bmr311753835ad.0.1787028705457;
        Mon, 17 Aug 2026 21:51:45 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1f01787sm9515675ad.82.2026.08.17.21.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 21:51:45 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: bvanassche@acm.org
Cc: Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: check that the tag map is still there in scsi_host_find_tag()
Date: Tue, 18 Aug 2026 13:51:25 +0900
Message-ID: <20260818045125.539058-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <414a2b55-ee58-4975-a76a-49202b9c0302@acm.org>
References: <414a2b55-ee58-4975-a76a-49202b9c0302@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 8/15/26 2:27 AM, Bart Van Assche wrote:
> Thanks for the detailed report but I think this is the wrong way to fix
> the reported crash. Please help with testing this patch:

Tested.  With the replay target that reposts an SRP_RSP for a command it
has already answered, the crash appears in 5 of 5 runs on an unpatched
kernel and in 0 of 5 with your patch.  The target still delivered about
2680 unsolicited responses per run either way, so what went away is the
window, not the traffic.

I have sent your patch as 2/2 of a v2 series on linux-rdma:

https://lore.kernel.org/linux-rdma/20260818035229.505098-1-yhlee@isslab.korea.ac.kr/

Martin, please drop this patch.  The lookup it guards is not reachable
once srp_remove_target() is fixed, and the review point that the check is
lockless stands.

Tested-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Best regards,

Yehyeong Lee
