Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794196585;
	b=SEvJITLolCwhkf8zMN3bB0GupwY9lxtUo9F/P+4oss1FzZ87xzCK959v9zFoOfHgrCQh
	 W4qInGfGVgF1lSbuhfxrVh16DwfJvPfxg4hLGCloiuSl9AyIxWdFehJAb8nltWyEj4r8J
	 TW8uCCdpcgO+7xh5qt5D4bxSnihGIRZXSALgy4GGpleufTDBAIWtgjwZLnC7Rq0+dAIAy
	 uzsBZiNlODRLyUwUG0PHHiWSVq7w8iftfAqMIDWOWvz+6x5QyCFtYdC9Sh0sLE98ck37I
	 xSqNkd/iJmEIbo8/oDQLEcK93pYGr9YVfesqukEWghV6cdSu0yxf5JMQnhgpa24XZKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794196585;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=OiIeaAvHhhOlloIb+gR27qqdqY9AmGsP8oj7QShMmvI=;
	b=v/tjm8up8aIrKUmh1heMu7dlHSJkJlC0vVj/H82QwMDK0VhnljTO20P9D8+sp+q850y1
	 ZHBzMva1glVGMX1Fpvd9gm/dINSB26H7I2PInL7GWwPPNl4ESYjD6bkElH48f8vmacrAJ
	 GTP833u8VrMCEfd1bv6j0f0ErkAebi1GF4Z/hcu+e/Uyxhhjj8bELDYlBTjDHmjbWfiRP
	 hOgnwv4BmPWLO9u2bsJKxXXoPiILYIyCO/UaOu1sWKGgl9W6Qe7v8wfrMiP9q1jwfU/ro
	 SJh+WjiuuYQrlniqJOXBJqycRJIb20qvJxFvI9r8bisLdqeDoOpWAKnNnEvQOw0zPeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YWoXHYct;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D583D606A32A
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 03:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YWoXHYct
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5831F0089F;
	Mon,  9 Nov 2026 03:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794196584;
	bh=OiIeaAvHhhOlloIb+gR27qqdqY9AmGsP8oj7QShMmvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YWoXHYctP/RrYZZ7D7/kua5h8zJ6gvVbyj3/OKVWZxJ/oSYD1exGYsF4Po2SdSRCG
	 HvlMSWE8ieAmPhQmqAiR4TjAfWcggd6nEMc77fE+t4yRRI/yamIMkVCDJq4R7gfdzx
	 p0PZfmZODa4pgSSl95M5MXug8MXg8kxtsMEgsGdOLQof2FSziLshMsZ1E0X+M+bi3z
	 7aVQh6G1qEt6uGyRjRTbD5FV8BwUowI0VZzjnNM6qbDF7h2fUZ2BETbY39DyW9esfX
	 cutoOUngbeAr2Lhklu3Y6SDvopo0FIrmy6o4ygdNSIP7rp6+maI+wA9FevuKeOrTba
	 NqpVO2b9Or0fg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org,
	Alexey Charkov <alchark@flipper.net>
Subject: Re: [PATCH 0/5] Recover from persistent UNIT ATTENTION conditions
Date: Sun,  8 Nov 2026 22:56:13 -0500
Message-ID: <179419636236.1941631.5063803447359416286.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793400000.git.bvanassche@acm.org>
References: <cover.1793400000.git.bvanassche@acm.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 30 Oct 2026 15:42:34 -0700, Bart Van Assche wrote:

> Some SCSI targets do not clear a power-on or reset UNIT ATTENTION
> condition for all commands. BIWIN BWU2A05* UFS devices, for example,
> keep reporting UNIT ATTENTION for WRITE commands while TEST UNIT READY,
> READ and SYNCHRONIZE CACHE clear the condition. Today such WRITE
> commands are retried until the command runtime limit is exceeded. A
> quirk has been proposed for these devices [1]. This patch series instead
> makes the SCSI core recover from persistent UNIT ATTENTION conditions,
> so that no per-device quirk list has to be maintained:
> - Patches 1 and 2 prepare the SCSI error handler for the changes in
>   the later patches.
> - Patch 3 makes the SCSI error handler send TEST UNIT READY to clear
>   UNIT ATTENTION conditions before it falls back to resetting the
>   device.
> - Patch 4 makes scsi_decide_disposition() invoke the error handler if
>   a command receives the same UNIT ATTENTION repeatedly. The behavior
>   of the exported scsi_check_sense() function, used by libata, is not
>   changed.
> - Patch 5 limits the number of retries in scsi_io_completion_action()
>   of commands that keep receiving UNIT ATTENTION.
> 
> [...]

Applied to 7.5/scsi-queue, thanks!

[1/5] scsi: core: Introduce scsi_cmd_needs_stu()
      https://git.kernel.org/mkp/scsi/c/b7545895b1c9
[2/5] scsi: core: Simplify scsi_eh_ready_devs()
      https://git.kernel.org/mkp/scsi/c/099fb3376bb7
[3/5] scsi: core: Clear UNIT ATTENTION conditions with TEST UNIT READY
      https://git.kernel.org/mkp/scsi/c/d54e68b5c31c
[4/5] scsi: core: Escalate persistent UNIT ATTENTION conditions
      https://git.kernel.org/mkp/scsi/c/49da33f60992
[5/5] scsi: core: Limit retries of commands that receive UNIT ATTENTION
      https://git.kernel.org/mkp/scsi/c/c14818f4d2b4

-- 
Martin K. Petersen
