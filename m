Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68597361DD5
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 02:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789612122; cv=none; b=Y1YyE9pXqYWd5GhTTKHdki6AznGc0DMvHAtRerid4+L82tI1Rqi91YzbzH1/Sh8853B5eJyqaVINlEiwXdAm75Ah5MG7Nvm1fL6QNblJzANmzorWexUYgX1fEAemBUrTXZPsayT4StkoSwLxVR3ofINhAo85K/Pt2azFULO8tUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789612122; c=relaxed/simple;
	bh=VoB6em2UL0AKZEuShmaK6XlsYd2wsXNS33kH4rr2/m4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sK682UiObSZ0KtrZgKfPEf+h/r773VBldXQFebfsLt4ZhqIosDuuGiEdTd/hitajeWzig9UHCPbrDLYL80E4A3w8tqxG4ai89S8++hRFrifmXJj7eo+meOGE3/iU1XG+kEu+9n2ivAuGtjpVCXb/PW94qpMJ6SqoG4ivH+HgihI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PfpoFLiG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PfpoFLiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D421F00893;
	Thu, 17 Sep 2026 02:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789612110;
	bh=EG3KDLARYh+yEhwLBXDxYcUVdnU3zQPoVFZ+t6Y6jnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PfpoFLiGbgfUvw7eORG6uzpZu2xaHam1+Jxfdv7I1CuqgmnGSP0KWVo9FZqSuceur
	 bwLR9Y2Zzil8AC0X1RafD1y7LNY2erknqv68zwOVakuOpFz1T84i6NQ/EuPhtGewAc
	 lNJJMyo2juDOnwViPyosShzYhNlEre7sKOTuLO+vbC4DRFMr7QXLvijt19XB9hNvVp
	 CWDw8B8+qwqUySqbHMQY4VzfnA9MP15RoJT57NzLt2N8bmJEWvT+P87ghYgw0oCOga
	 7Kvj0xVu5oBNW+FlwuiZKN5DPUqQL45r2/PS/KISyJ83/2jMgxxVSjvqdOMsauAHgU
	 FwcDLVBzBfsKA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: sebaddel@cisco.com,
	Arun Easi <aeasi@cisco.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	arulponn@cisco.com,
	djhawar@cisco.com,
	gcboffa@cisco.com,
	mkai2@cisco.com,
	satishkh@cisco.com,
	kartilak@cisco.com,
	jejb@linux.ibm.com,
	linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com,
	revers@redhat.com,
	loberman@redhat.com,
	adakopou@redhat.com,
	lduncan@suse.com
Subject: Re: [PATCH] scsi: fnic: Fix missed link-up when a critical IRQ targets an offline CPU
Date: Wed, 16 Sep 2026 22:28:13 -0400
Message-ID: <178961190582.3672510.16879030014737848098.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903175547.57971-1-aeasi@cisco.com>
References: <20260903175547.57971-1-aeasi@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 03 Sep 2026 10:55:47 -0700, Arun Easi wrote:

> When CPU Hyper-Threading is disabled, sibling CPUs remain present but
> are reported offline. Managed MSI-X IRQs can still receive affinity
> masks that include those offline CPUs. If a driver-critical vector is
> managed, it can be parked on an offline CPU and the driver may miss
> critical events such as link-up.
> 
> Keep driver-critical vectors unmanaged so they can be migrated by the
> IRQ core when their target CPU is offlined.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: fnic: Fix missed link-up when a critical IRQ targets an offline CPU
      https://git.kernel.org/mkp/scsi/c/0cb1fd924126

-- 
Martin K. Petersen
