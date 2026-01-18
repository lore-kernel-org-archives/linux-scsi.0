Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA0419004A
	for <linux-scsi@vger.kernel.org>; Sun, 18 Jan 2026 08:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768726012; cv=pass; b=U7+EGNBXnPOIJk+3xlnBcWzTaJBhMxuN1DIDePtSqLeA8quvMwxWjMDjSAB+mcndQFAareYbyxo8F168fQF/7nLU3h9ZkxG5POi+vJImePSVfWj2BloGwCMa+nYYlzOrpsmks6GgVIMC9VAGscfUL0B0Gk7jDViIdZefsbMcUPk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768726012; c=relaxed/simple;
	bh=CQ1QGsg/zF0GFZtRQgFqsWlHm4b20DrZArHORynBWKg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JQH2gjIYhdZGQLwtUHSJ2B25/mm0LvExFBXjBaHzu036JDPN36wF/0JgV3KFQKSonCs1uzSo6aHuHTvNztHS4osriDqCYzzdmnOD5gCZx5yvWxtpsa8hxmZtIRVgNQMNBPIEVSyc1w+k7T6eiQC/xfrNZjbwEdhBroMSrlZXR54=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VSKRFlIE; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VSKRFlIE"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-655b5094119so405270a12.2
        for <linux-scsi@vger.kernel.org>; Sun, 18 Jan 2026 00:46:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768726009; cv=none;
        d=google.com; s=arc-20240605;
        b=K2CRZD2OnYuEH/rFGSgIedhvL3S9BivTKEyTvswB7S8hei/qmUDRa6MeIjdfwxzj5R
         dMGMWH6lKX2g4WeP7CmNd1tW7FAH+5ER5NoV559iOpk8bpgJ82W9wO0mvLKjiot3LuGs
         546aSJDYOV/UTecnsyqWuUd6+tLNp8kEY4RrnzsfaKUAOnSALQdqgP2CzOULMOT7ZTuW
         SLL5t98Dc1EkHbJ3bfrhORi9cQieADClV1q8d8Ryl+hG2e67l2oUJHploqwkBUrGMBYO
         xQqqQBmqUYWsi77wbzus633kat1jqB1EuVGY+sp83f1qY4d5Uss5WtCTSh0q5wU2wOiv
         nbLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=CQ1QGsg/zF0GFZtRQgFqsWlHm4b20DrZArHORynBWKg=;
        fh=foyCPyZ/p7YCL0HodHF3aoivjJJzh2yV0UntYZHNlSQ=;
        b=j8whePO4ireVnzUS5jrLOaZPmLFjSu+54Nij1GLH1K0R5IRu3890UdQaDi3crzk4Fw
         ayhzjQUBVALSM3OdRNnIZaPXDUbHcqMdLTFELWUGDeKix9WqW5IkqKmiE7puZdkKfrkV
         MilpuxC7XHzwdL0ueYa8RuM2Z1hKKG0PI1uczULILBL/T+yz8I9ltiHBcBo7NpziSvkZ
         sTQIzK3CUziuvO2wuyFnyNko0G1frqtPkDwup5H3iQxSJDJI0uf0wokwXmazYqICniK3
         Z8wgi1kPd+Be/5OkNDwpuvm10CslGL2L6YW8bXFmYZMy7PfuGKb1xE0GHxO3uUIcZC4a
         uYPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768726009; x=1769330809; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CQ1QGsg/zF0GFZtRQgFqsWlHm4b20DrZArHORynBWKg=;
        b=VSKRFlIEiOry7RKJNl6ok8tI6G5eDU66h0wQOgp6x5wfVm7gguXHyF7ElQb48ir6kK
         Mpj4HQ4DA38CisQxz1YqZ9zI1Gqmhi/soc5ag8ApYjixEySWr376YT0IFlT1pZNzDFbd
         Vl+L7770dtpd4w204eFFFY0cN94/3LXNs4wefoAgLNMfwrARrxipe25X8EU0AyoRBWrC
         v0humHan/iKeoOqpqXH6IhlPKkmBheQFK+WK3IuMlp7KlA2koulRHT30e/Ba1s+1dxNp
         ZQfAOa62r5IwuH1L7jUlSJRhrfuV0sBl1iK6YIQecx/i4nsLy5ETxJFllWiQZE6DXywv
         mWkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768726009; x=1769330809;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CQ1QGsg/zF0GFZtRQgFqsWlHm4b20DrZArHORynBWKg=;
        b=hIVC9jlact6Kxmwes7okLyjDRXo6RJdWR1phBN51c5TFhOfodZKbYxa8iLIcYjVMee
         FAdlY2T6c4x76G79TmntpQ1LwDZpYDizVjIFyg26PY2A+1R5Ib1uunPIcRfXkChihaDG
         vWDWqFilGa/x6DoAdwbthF6rjkNQrDo17GDaDdDK6P2DPU/T63SlmTmxKsOiU2rY+De0
         rAjQtVxpRsfRVtYqRoB52Yw5KSxRb9+fgavCABdxB4hpM3834nnVoufA0yht9qxc2L3l
         f+3LHsTa52smKnray95V4gJHWqMaBqRv/IUHz1eIdOYXg09YNHAQUnINbsULZw9O+g0x
         //kw==
X-Gm-Message-State: AOJu0YzFKQC5Gc82RvQrRuYECdwyCEl9yHyuUVrFRZSwscJBm5LuZ1i2
	yxonOJAlcSCaWHrYgghkijXn+IvqxoKIGAEQSMzaCPMeVo3Wl4IVIImEzI6e/B73XzJC8BT6uVc
	Hzqu0tVYm4XkNMN8OW9TT03hxCKcCyo8=
X-Gm-Gg: AY/fxX7v0My8D98UTQiZHS3uLuUzuwN25BPR5EOH0hJPliydLG9tQ5KoQZAPaS9hEOi
	/95xRfpWAUn2duq7IegpCn1cGLDsT/ayUjAK8xVqrVqLnbBU7zowH177rLc1yp+GyE1zFUWJoK5
	2XQTVGsiGMuzwwIkWURY9yJVSIVyEiFX2WhHc8TtapRxmdBnx0GeF05+wP4ZP86snWa83TLGWoO
	wyEOok2B68pbIYUgGs9x3VcYovOLX835Qz97kIU8n2yeW+9qkKdbaJqb4wdlU23d19g7S2LsdYp
	C/JqKQ==
X-Received: by 2002:a05:6402:146d:b0:64d:521e:161a with SMTP id
 4fb4d7f45d1cf-65452ad1475mr3783772a12.5.1768726009419; Sun, 18 Jan 2026
 00:46:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260118070256.321184-1-dg573847474@gmail.com> <92c065e1-ff38-4e38-859b-ae67b60cba4c@web.de>
In-Reply-To: <92c065e1-ff38-4e38-859b-ae67b60cba4c@web.de>
From: Chengfeng Ye <dg573847474@gmail.com>
Date: Sun, 18 Jan 2026 16:46:38 +0800
X-Gm-Features: AZwV_QgpwjB5paxTPAuiSHWMvwKESd6uYJzE9JfR_5WydzaiyQGO6RcZWpnxhdI
Message-ID: <CAAo+4rVWOzkz+HMc99c2D8tf2ZuwYHq39+jejaXWxD-PvUAuOA@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: mpt3sas: Fix use-after-free race in event log access
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, 
	James Bottomley <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Sathya Prakash <sathya.prakash@broadcom.com>, 
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

> Some contributors would appreciate patch version descriptions.
> https://lore.kernel.org/all/?q=%22This+looks+like+a+new+version+of+a+previously+submitted+patch%22
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.19-rc5#n310

No problem, resend the patch with the change log included.

Best regards,
Chengfeng
