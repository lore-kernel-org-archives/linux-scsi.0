Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794655512;
	b=NbfoQa9APQxuJYIFt2Rxg1544JXx7W1J0DAY7Tkku54G3Yczdu3QjTOeeL1vuyWDxSWZ
	 LJLqWqdVM1HA+g/qQ1nl21qQBldp6c3JC1xJGW5duDeqEJo25sKp3QOCKjXMSCgV+tMg+
	 pAHe2MH+xn9Ww263Apg0n6f94DgGJ8OjYP+KNJwWtaQ/iRnJkwOeA5xtZTuNVn3+bfRzv
	 nBdcaRLaHcdI1hbBImfYfAlzhSkXXlYu75g+7Z0iXl5DC1X1E2vAPhl7oRtv6uIsaBmto
	 MCnjkT/z5rby2oZqSPfs1rfK8EY7xU+IqOQIdV3wR4z0pQ594WyACoeNY1+HSeLwhkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794655512;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QsiTmvnYi1/bC68aKEXBe6BBwV5VctGfUYNCz+WL7/I=;
	b=pxt7zTLZgBXsi8FCUBCxdIYF1AHyq4NUfD/Y9y5TRA9pu3PBAALwaAsKWBWZvrE+UMsA
	 OSVkA2hyyGqWeU+NXjmLLuTse70JGT+ajQ7O/y8TEDXwLg34opIXYHq1T02rozE5S6HK/
	 A25bKvotkhfFEeLwT2YPV83d/fnC3r29AhqxNWvZCFivhM0ldVcK0oEja8W4kAAH9qKB/
	 xL99l61T8/V5DXK93tq/wDy1Dg5j+fPqRK5GWgvKkGDFgRinXL8Un2rdoj9f8RNQYMhan
	 aIOHan71I4QS4QaJloGyzZlezMk8MOy8XTnMcFAPt+FAQGY+fZ60Jqz93xRzyglKwgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nXTlg0XX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA255606A327;
	Sat, 14 Nov 2026 11:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nXTlg0XX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1453E1F000C4;
	Sat, 14 Nov 2026 11:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794655511;
	bh=QsiTmvnYi1/bC68aKEXBe6BBwV5VctGfUYNCz+WL7/I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nXTlg0XXpFR1qLAj2e9TfeRX3ojYfW9/jjS5N9GtQOGat1zYW3n2QceCk7ahKutlw
	 sEuN/hiTMQAhCFTeIyOCQws+H0C2F3p6vhVq6iUXP7AjKgyT+mTdkHbJwzIJAxoKqF
	 cgkRMXyF6KU4+gBQlWnIKuuv5tSxc6t1KEAKuhtDIknDp3hHqtTRNco42Xbx7WbhWm
	 Px9ClZL9ROLtuMMCpeuSbGLlJaNqtaDnDtSYkS7DdcFUr11qDjHNxgzVkrqJFxJ32X
	 IabH4+B6mjMIO3YSoy0Hic0xwlLuJsyAetRr2WhpoKMFt3AKxOre4A71ja2TFhHuNJ
	 XJKVeSg48xf0g==
Message-ID: <sashiko-outbox-214401@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 04/12] target: fileio: don't free the aio command under
 the filesystem
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, bpf@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <20261114-work-fs-frozen_writes-v1-4-f5ae61c898b1@kernel.org>
References: <20261114-work-fs-frozen_writes-v1-0-f5ae61c898b1@kernel.org>
 <20261114-work-fs-frozen_writes-v1-4-f5ae61c898b1@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 11:25:10 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] target: fileio: premature target_complete_cmd() in
  cmd_rw_aio_complete()
--

commit 6e1a6f1140a7e9133b9c8d928debaca48c4124cf
Author: Christian Brauner <brauner@kernel.org>

target: fileio: don't free the aio command under the filesystem

This commit adds a reference count to struct target_core_file_cmd so that
the command and its embedded kiocb are not freed before ->read_iter() or
->write_iter() return.

> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_co=
re_file.c
> index ab9824a4852f1..4dace29b6d662 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
[ ... ]
> @@ -244,10 +245,17 @@ static void fd_destroy_device(struct se_device *dev)
>  struct target_core_file_cmd {
>  	unsigned long	len;
>  	struct se_cmd	*cmd;
> +	refcount_t	ref;
>  	struct kiocb	iocb;
>  	struct bio_vec	bvecs[];
>  };
> =20
> +static void cmd_rw_aio_put(struct target_core_file_cmd *cmd)
> +{
> +	if (refcount_dec_and_test(&cmd->ref))
> +		kfree(cmd);
> +}
> +
>  static void cmd_rw_aio_complete(struct kiocb *iocb, long ret)
>  {
>  	struct target_core_file_cmd *cmd;
> @@ -259,7 +267,7 @@ static void cmd_rw_aio_complete(struct kiocb *iocb, l=
ong ret)
>  	else
>  		target_complete_cmd(cmd->cmd, SAM_STAT_GOOD);
> =20
> -	kfree(cmd);
> +	cmd_rw_aio_put(cmd);
>  }

[Severity: Medium]
Should target_complete_cmd() also wait until the final reference drops in
cmd_rw_aio_put(), as loop, zloop, and target_core_iblock do?

fd_execute_rw_aio() sets aio_cmd->iocb.ki_filp to fd_dev->fd_file without
get_file(), relying on the in-flight se_cmd to hold se_lun->lun_ref and
keep the backend device alive.  Calling target_complete_cmd() before
->read_iter() or ->write_iter() returns drops lun_ref early, which allows
concurrent LUN unlinking and device removal to close fd_dev->fd_file while
the filesystem is still using iocb->ki_filp:

CPU0                              CPU1
fd_execute_rw_aio()
  ext4_dio_read_iter()
    ...
      submit_bio()
                                  cmd_rw_aio_complete()
                                    target_complete_cmd()
                                      ...
                                        percpu_ref_put(&lun->lun_ref)
                                  core_tpg_remove_lun()
                                  target_free_device()
                                    fd_destroy_device()
                                      filp_close(fd_dev->fd_file, NULL)
    file_accessed(iocb->ki_filp)  <-- use-after-free

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114-work-fs-fr=
ozen_writes-v1-0-f5ae61c898b1@kernel.org?part=3D4
