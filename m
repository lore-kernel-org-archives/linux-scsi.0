Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDDA4CB8B0
	for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2026 15:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791215157; cv=pass; b=JpuDxTOEUW3MhvoKAL4juhqPbTB+qLhhp7ARAQlbGKhGrvR0gi5vOo7lZnlAJu1UQ3r37n8WJev5ntRnNCHbDra78w6nFytSedLoilvXaVoBTLn1PGZ0w7xX1dRpRlRtUPkF61U1EYFtgvC4Zumep1+dL6GAYtwRb5Iyq8FRFxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791215157; c=relaxed/simple;
	bh=qH589Eati1pjOXOcBnGXShBFqiglBE/4FOHESK73PA0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zvd528Qqmdh4r2CGbXSjInX+od7qpcK1yFGP4uKnQyiOjgR2Ln8/ShTF8RkcIOOgILmJWhFCw8R9kQSWsCAySJVKk4dk0tIwCY/2/S6v06mkmr7bCPM3M3EOdB2Eu5Ctu1hlhQ7GNImsHBGBgmTuyehY+lr13U3MlIHjadWoj/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BcF+s0QX; arc=pass smtp.client-ip=74.125.228.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BcF+s0QX"
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2a1f611461so135032066b.1
        for <linux-scsi@vger.kernel.org>; Mon, 05 Oct 2026 08:45:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791215151; cv=none;
        d=google.com; s=arc-20260327;
        b=TFKh9KaG64d7N6+pTvC6vMxiAC0wvNaPak9ZwF9snn/5dOVVrQKaifXVNoLJpv0B1s
         wYzfH6kWkFPKPydP1GTMYG0Qiv9m7GgZ+m+NJkcfgGZI2hkbgQSxA9YB+S0ya1Ht/b98
         J4Ez+FbjRG1N85fI1phXF/WQuOWtnWiDNrE6Mcf++wLdmHFBMTGQDvEHc8gPWrlp7+q6
         2c/v2Fi48TkTYqboqrQhVbW0aA11wPaRJf//Vih93eZdSVc9sJyUnj85yzlkb8jzffWD
         GBgRnlHQP+lAXKCM6vyiOHrUuo3i/ccjLHKYIimQmzEcjIm3LQYqcql7KSMIxFt++Qrp
         0T8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=qH589Eati1pjOXOcBnGXShBFqiglBE/4FOHESK73PA0=;
        fh=WWA4JP6oRLMkRRan6sbjBNP0Nxic21M7742pPPUIYBQ=;
        b=pTHc3Wq416BLUIlaDiM5v5nGYSDyNKGReoQaDDG6FeSHHqUvNKy6kmHW1WweJaRGe6
         ++7lW5pTJ76CYVFG9pDiGjJl0BCYN/IEK++wA8WyeL8Kw981QiGeFvjEmeG8wW2axElt
         +QpaPewNSrDn3jvJAmjPaGwLHAkpGB04CCYNueM3TcAljQEXFlqkVxd98NBVt/vcvPaK
         SLQPi87Q6aEIxX6/3zaskG7/vkD4qQV2vzST1dU96C+pTI1+aW416/Qv6o6D07fDUK5v
         jXIM3/7pQPLqynJYENrG0IUqtv7OGcr8PrECOsDXFdK0m7Y71Zmp0y1z0wBF+bGg4N4+
         0fiw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791215151; x=1791819951; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qH589Eati1pjOXOcBnGXShBFqiglBE/4FOHESK73PA0=;
        b=BcF+s0QXXaRAqj8Dprk3wqcsmVi/zAFp8tM7idpQpz3pzcdh32N3KPFAr+5oBK2VSC
         b9i+KjrOQpgMs87ivBlk2gldNCX/+K75CU2QMy5u+3g4d1CyC7fSqm8e8o1YvssdTPD6
         p4OxbQCORL3IqjjMupDM8GwUlcqDToCXEVIpwfy525mGqbrYfpvHLLQHnJGCHpBD/4pG
         gIDwKe6JJoljgbx3hJ0j9f1ZEuE2RkFG2yWXmrxtMD6R5N7nRRdW4dHl22A+BvexZ/1U
         6YIlYenKps9kayfCSq5YkNtYDT+eFFkDClP+c4MKQKL8jWbLiDPc534MeAmtNTnNjxAE
         ox6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791215151; x=1791819951;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qH589Eati1pjOXOcBnGXShBFqiglBE/4FOHESK73PA0=;
        b=sDggj0Bixtsy2zXsPr2NGHI3a94+0oxfkqhUUPBVIxktaUfqraMLX8Dxsbg/3GKH+m
         wp50ScHaujnUtW1OnsZyh5reSh3LaDW4In9LpzlVHwg9iU7HDw/0HZMph0R6JC4UfHd+
         XH5WbPKZybUiesNFIHoT+4AOdCBh1Hq65Nh4Q+XuLyXfZS/TtU/6ovzE3PTTxHK+e6OL
         eX/9Aw8XonjiemVYAL4xEOz23AsvQw7E8ta8iqukBj61QJ+nCYhhETdclvJeQQe/9sdw
         ua/6WNJboAvcGYzgA4qbH5T4Zprec0FN4QG5k/ILaO82GrzkSUhzTYhP9b92ciM5rTnX
         TsqA==
X-Forwarded-Encrypted: i=1; AKwUvByBIiIznEsMMehdl7l+336FcQDqK+WN57xGRZSKBt9CXmCetF1Jb476S6SZFoJi8cWUiNvqAtN8xBRu@vger.kernel.org
X-Gm-Message-State: AFuF++nNMV9ibgNTV8ac3vZen19P7vMZ2WKUZof7bu/URTS7OfHGKLRl
	CACdK8qlZ6RkfRXnbtUxyqAohHvhTiHi7xL5ErsSv98JqNmJqSyZQYU6qhA0YRm6XpX3y0DFzPS
	O0j6L6xrr9y7tcAp2hQEtiWxdLlUSCAZTp8Yk4zk5
X-Gm-Gg: AYBFou1UlN3bpYZ487kYUqp4fCK5rmdTXfIFUzudu6bd8juNvA3lbyH5tIN3yT16LAn
	dIHEZyDN9KElZl+c2X7uynDQq/35NV4exsikSuFjKun3NDKsbdGqPs6YBG5C3g4iibisk4NLQm2
	l7bF1tgLHgpXcb5sPxSZs9S2OJ1NlORG2zDf9xXrxgcNoGl/H/BohOLTtly/qL1OrEO2/LKtSQG
	mihcvZLq0fYp3ZlzYBTOenA18wmWD25US0yLTCX8TlwPUpK85ZAlHz986Cfb80cAqA2ifu0Nzhm
	8JgKvDqcc9RnmddKYSjpv5JrUkk0ZmLTS6TbCzEDLygnYVzCt8tUhUnq
X-Received: by 2002:a17:907:3f14:b0:c25:f7db:4beb with SMTP id
 a640c23a62f3a-c3160f1d01fmr894266b.17.1791215150701; Mon, 05 Oct 2026
 08:45:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260914085148.136429-1-peter.wang@mediatek.com> <yq1jyo8pwwc.fsf@mail.kernel.org>
In-Reply-To: <yq1jyo8pwwc.fsf@mail.kernel.org>
From: Sandeep Dhavale <dhavale@google.com>
Date: Mon, 5 Oct 2026 08:45:39 -0700
X-Gm-Features: AclHuK82KgNqsjE8F2p-fNUCpJ_mW3iXi9stcn4dXlH9FUwkkuZqdBeXATzDN5I
Message-ID: <CAB=BE-QT1oy=XD_MFWaR+VvKG_Kpk3jszDpAtUy=EyK9uU5fbQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] ufs: fix POST_CHANGE pairing and AHIT race condition
To: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
Cc: peter.wang@mediatek.com, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, avri.altman@sandisk.com, alim.akhtar@samsung.com, 
	bvanassche@acm.org, santosh.sy@samsung.com, h.vinayak@samsung.com, 
	wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org, 
	chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com, 
	chaotian.jing@mediatek.com, tun-yu.yu@mediatek.com, naomi.chu@mediatek.com, 
	ed.tsai@mediatek.com
Content-Type: text/plain; charset="UTF-8"

>
> Applied to 7.4/scsi-staging, thanks!
>
> --
> Martin K. Petersen

Hi Martin,
I don't see this series in in 7.4/scsi-staging at [1], or perhaps just
push is missing?

Thanks,
Sandeep.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/log/?h=7.4/scsi-staging
