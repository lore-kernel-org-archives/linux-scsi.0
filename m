Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF2025B1C7;
	Thu,  6 Nov 2025 15:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762444598; cv=none; b=dBvYAIl1E+ihJq3EjFOeRIZr9uIsxlptR2N0MNcSg3bSUmlpIjVa8RuRxliIFjEnKT+VYn91azNrLrhZDMBzveXHRWCPNuLq/wepto4s607yqSauLZOT/86e70Cl9Il1rreLVwY/eUoIYlWg4Oi3jW7gufpIVdP2TIYZoVY/Hug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762444598; c=relaxed/simple;
	bh=ZIrAMRpKTwPwwGigH3+detINYuwsZkTlnKbiEXElk14=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=s5WIeoRzgl/C8pFplvWLZTVMJcE7Drt8oN5hcIC+0plzgjsHC1zYnRE3jH8/ywWynNTsZUZro9IgVmd+vahhZxR5C/LGjpOMMSiVLhvqogFSa4jGH6e1Cjh1mDe1tDci99VsLtPzNV3ARQ832IvaMUbUVUunj4S7Eew9rjHNa0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=d+g5ukqv; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="d+g5ukqv"
Received: from smtpclient.apple (d172-218-74-200.bchsia.telus.net [172.218.74.200])
	by linux.microsoft.com (Postfix) with ESMTPSA id BFADA211FEB9;
	Thu,  6 Nov 2025 07:56:35 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BFADA211FEB9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1762444596;
	bh=Oz+gDVJqirbWPHrnV87yG/Sh6p36IVbnHT4ZPTHOSk8=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=d+g5ukqvR0RUqZJHihJNc2BRM5Vez0835DmJe36I0/SzdnjKXqpFt46HHoAX33d6t
	 SU4yJUmSp+ht/tcbP6v+d6h9cKoI/wGMU/KySRS1Gjw+0J2re7ddp8NhvVHU5A7z3l
	 Xr/n5Jb4gdMG2VFYrx8jNW0FGlOZVPjF5lL/0xzk=
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH] scsi: target: tcm_loop: fix segfault in
 tcm_loop_tpg_address_show()
From: Allen Pais <apais@linux.microsoft.com>
In-Reply-To: <1762370746-6304-1-git-send-email-hamzamahfooz@linux.microsoft.com>
Date: Thu, 6 Nov 2025 07:56:24 -0800
Cc: linux-kernel@vger.kernel.org,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Guixin Liu <kanie@linux.alibaba.com>,
 Nicholas Bellinger <nab@linux-iscsi.org>,
 Sheng Yang <sheng@yasker.org>,
 linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C4A5B08B-27E4-4ACF-96E4-9351F0BFF320@linux.microsoft.com>
References: <1762370746-6304-1-git-send-email-hamzamahfooz@linux.microsoft.com>
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
X-Mailer: Apple Mail (2.3826.700.81)



> On Nov 5, 2025, at 11:25=E2=80=AFAM, Hamza Mahfooz =
<hamzamahfooz@linux.microsoft.com> wrote:
>=20
> If the allocation of tl_hba->sh fails in tcm_loop_driver_probe() and =
we
> attempt to dereference it in tcm_loop_tpg_address_show() we will get a
> segfault, see below for an example. So, check tl_hba->sh before
> dereferencing it.
>=20
> Unable to allocate struct scsi_host
> BUG: kernel NULL pointer dereference, address: 0000000000000194
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 0 P4D 0
> Oops: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 1 PID: 8356 Comm: tokio-runtime-w Not tainted 6.6.104.2-4.azl3 #1
> Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, =
BIOS Hyper-V UEFI Release v4.1 09/28/2024
> RIP: 0010:tcm_loop_tpg_address_show+0x2e/0x50 [tcm_loop]
> ...
> Call Trace:
>  <TASK>
>  configfs_read_iter+0x12d/0x1d0 [configfs]
>  vfs_read+0x1b5/0x300
>  ksys_read+0x6f/0xf0
> ...
>=20
> Cc: stable@vger.kernel.org
> Fixes: 2628b352c3d4 ("tcm_loop: Show address of tpg in configfs")
> Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>

Reviewed-by: Allen Pais <apais@linux.microsoft.com =
<mailto:apais@linux.microsoft.com>>

> ---
> drivers/target/loopback/tcm_loop.c | 3 +++
> 1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/target/loopback/tcm_loop.c =
b/drivers/target/loopback/tcm_loop.c
> index c7b7da629741..01a8e349dc4d 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -894,6 +894,9 @@ static ssize_t tcm_loop_tpg_address_show(struct =
config_item *item,
> struct tcm_loop_tpg, tl_se_tpg);
> struct tcm_loop_hba *tl_hba =3D tl_tpg->tl_hba;
>=20
> + if (!tl_hba->sh)
> + return -ENODEV;
> +
> return snprintf(page, PAGE_SIZE, "%d:0:%d\n",
> tl_hba->sh->host_no, tl_tpg->tl_tpgt);
> }
> --=20
> 2.49.0

