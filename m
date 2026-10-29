Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793236995;
	b=bjc+S7Y/inR5iySNLtNnm7+qvraRsQNHdp7CKGnZLMM86eTjRNWB9sThYBz8q7PccLYO
	 Cqg5ahCsmYqCpVnDrm1tpj3XHuUkJ3G+hvAqFHWJ400Rf9HJn8t/bxH1hbpimI3g7+pjT
	 gknswj0sZPBFxjXciVBjpXSRnZrs+cCyjkcbsHcMgF0jx2RHJVXL8zsrpqRfm10nN3Pi4
	 Z1SNiXiU2ye3Pnc62pdTzpERBJa7dFFvfCbk4LJh+OVLqMjT4q42mDnrj42dhdVyyxUAB
	 56LTmw4OK6QAlp4Nw64YaU0C+9Eq0iB394M2YufUlXVXVJK2q3WcfXvvaSLnpMJ+fHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793236995;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=gDbGnzb+ub3AbALGhlvIHitL/lsQ64vUwv0Xos0Y2k8=;
	b=zaYP24sUfRbm+/AITQc2kkNEoXBAyIdiB0tD33VhcMHg8oFvXwxdN7rPXC6ORzjefQgt
	 W374J9gE/BveA3XBEQFePcVWQjyMHJwuw7Y05efqsKAtw69Et+qcyrqlZNnypu/tT4x3s
	 oKlHjV7PPFqql881QdBbsTTRg4yEeehCWnPM6WXnPAtPWQUg8GAhcgzvtKF9yk+h4crPF
	 kibsau1iiZDXH4AqcuGeSiXyDpVpe6DKkKYkKG4MdUX4eUPpQUZNljzGZYwcyOUGlzeFB
	 JFg8l/l0rb/nk2vTMKi1xCgOOJj5bAhBPyfm4dG6vxX32w+Vo/iSZxLzvNzrXtGYyDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iAyVhdy6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03449606A31C;
	Thu, 29 Oct 2026 01:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iAyVhdy6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2071F01825;
	Thu, 29 Oct 2026 01:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793236994;
	bh=gDbGnzb+ub3AbALGhlvIHitL/lsQ64vUwv0Xos0Y2k8=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=iAyVhdy6hUmKeh/Pr7Pm++F7LyoEHrmLNvHvrXiWTPs3JqBTEYLvn4mP0lr6zvJSe
	 VZGfuoSc2iR2QUaBVMsbDAYqJNbDYvHlBnxCTJnFG2Anhfi0vIOj2QjZm4Od8ExJrG
	 +Vsa30tKxDCLQNFyI01+QF1bTAvnrusQLHDmYKzg9pwyJebcZduADr/Vht1SYqCd9q
	 YFyoOeDsPLZ2FgJhtgx6bbOaH2hZvsyFNNgr/HN0GPQksv/UNJbzumsgbQFihsia3t
	 PgPiqbxBsTRfaHJXFfx+Hio2Q9mlxI0++i/NhrhOoVaVNj/7L6Yl1b+gvQmNuLuYE/
	 3UJgot1elDDaw==
To: Giuseppe Piscitelli <ooonea@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin
 K. Petersen" <mkp@kernel.org>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_debug: Drain target cleanup before module exit
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261026202342.668361-1-ooonea@gmail.com>
Message-ID: <yq133tp5mh5.fsf@mail.kernel.org>
References: <20261026202342.668361-1-ooonea@gmail.com>
Date: Wed, 28 Oct 2026 21:23:13 -0400
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


Giuseppe,

> Target destruction queues cleanup in an exclusive async domain. The
> module loader's async_synchronize_full() does not wait for exclusive
> domains. Wait for target cleanup after removing the hosts and before
> removing the debugfs root and returning from module exit.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
