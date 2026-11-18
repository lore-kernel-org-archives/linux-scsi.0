Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043613;
	b=STB209z6wCBnJy7MbsEiojCfRgeRlDEOT85tjVs9TCEgNUbbM8JxX39k88NVT483rv5u
	 RZEv54vxkHSVp9+5p5hynBhBapma2kZAsL+uNDmmj6/bEM0KnO1NbdC4OrGujo3HrSU13
	 /opWQU2ir65ZfzhCHE2uT2CrbGyxZ0OzEjUOOMshhrz0pZ+kTpDYlQVrosnzag54hmQWX
	 ki+9w4xHyBF7uRCMCiUUkWTgG+zBTvbo6lkOJnIT3BF2Tnn3EiM20b66++iQnlCo4+ZH1
	 Po/Body1x7wG07bkSbAB1lb+q6cHKkgyk+cVMOViH9Di8N4E19SNlwpZK6v9KbOIPaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043613;
	h=Received:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=L5L2RpNo9+tNFhyAI8rYTU86HyKo3m9kMSby1I3auvw=;
	b=3+o7foZo4Cv7wOZaiG//VRwchUZFFJj92Mjcydzziv0pcilQYV8D+lJNLJXwR2bgZmZm
	 JhXja+IVyz20hx5gHtAa89FwBajBC8uUF26L1qQqnKDJ9ZHzA/ihSemSvacfGs7v+7fVL
	 GBSRYtdTHds/yuO0Rd0ZpQ/HomzReFOgUysjQsoxIHv0cnlf844rFCnkofw5ZAMP7plNH
	 X7TQTnPhD2RIp93PC/SjHmQEE83QZeFPDunJd6Qv3y//EgEZnxdHv9c/mOkRQ8FLGIx7J
	 3ZRaBD5bCtFgDa2byIIIbliKnRqKVxXdReI18Aq1MA11FQ9ryUD2EBJVl+c/ULFmDxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ofpMRYHl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8134F606A320;
	Wed, 18 Nov 2026 23:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ofpMRYHl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4BA1F000C4;
	Wed, 18 Nov 2026 23:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795043613;
	bh=L5L2RpNo9+tNFhyAI8rYTU86HyKo3m9kMSby1I3auvw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ofpMRYHlnuogyeQXKSAYB+a0ClyDoAVBLi5Xhg2qsyKoyvOcOfrCSYm6VLcarpPnZ
	 WVYP4BrHoIlfcWIgfke0Mp2+EQYUBDQiN43sU6m9aV0qMlPBcUjrbNnxEpY7Ig/BuE
	 WsPljm7kI+3LtAZ4+es+4XuOVxxR1IZrT5aNKnVwXecVXo/uj3K9rv+8RE+S8URiEV
	 wvLONbdp5+xoI+nb1aLyeuMnKSqmih+xtikd2czTCDwzbhd7gtNphjztWWwpx83mGB
	 a4GH0EtL3RdlRmC2+7NBWrndYnyx/O++m98LkibCYdnqckd1HdQsCPkhN0bSbxvDcE
	 Rv5nfHJ/T0f2w==
Message-ID: <bf68a8f608bf24c9b85b3078957ffed6b9addbf1.camel@kernel.org>
Subject: Re: [PATCH v3 00/11] scsi: mpt3sas: Fix delayed not-responding
 block deadlock and related bugs
From: Jeff Layton <jlayton@kernel.org>
To: Sathya Prakash <sathya.prakash@broadcom.com>, Sreekanth Reddy	
 <sreekanth.reddy@broadcom.com>, Suganath Prabu Subramani	
 <suganath-prabu.subramani@broadcom.com>, Ranjan Kumar	
 <ranjan.kumar@broadcom.com>, "James E.J. Bottomley"	
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <mkp@kernel.org>,  Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
 James Bottomley <JBottomley@Parallels.com>
Cc: Keith Busch <kbusch@kernel.org>, Sreekanth Reddy
 <Sreekanth.Reddy@lsi.com>, 	MPT-FusionLinux.pdl@broadcom.com,
 linux-scsi@vger.kernel.org, 	linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2026 15:13:32 -0800
In-Reply-To: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
References: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Wed, 2026-11-18 at 15:09 -0800, Jeff Layton wrote:
> I posted v2 some time ago. Since then, I did a lot of adversarial review
> with AI agents. The review found a large number of bugs. Many of these
> bugs were preexisting.
>=20
> This series fixes a deadlock that occurs regularly in Meta's fleet. The
> fix unblocks sdevs after a timeout, and this breaks the deadlock.
>=20
> I don't do much SCSI driver work, but this problem came to me. I
> relied heavily on AI agents for this series.
>=20
> If this series is acceptable, I would like to see it in linux-next
> soon.
>=20
> Thanks,
> Jeff
>=20
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
> Changes in v3:
> - New patches 1-8 and 10 fix pre-existing bugs in the code that this
>   series changes:
>   - 1-2: fix UAFs and refcounting in the cleanup of the fw event queue.
>     Do not leave requeued events pending at teardown.
>   - 3: requeue topology events only for busy devices. Do not requeue
>     them for devices that the driver cannot add.
>   - 4-7: fix these TUR polling bugs:
>     - a pcie_device leak
>     - a lost unblock retry
>     - polling that continues after the scan is cancelled
>     - a retry count that is not per device
>   - 8: cache the missing delays that the IOC actually uses
>   - 10: do not use freed hostdata while the driver polls devices
> - Patch 9: also publish sdev->hostdata under ioc->block_lock in
>   scsih_sdev_init()
> - Patch 11:
>   - Use the PCIe missing delay (from PCIe IO Unit Page 1) for NVMe
>     devices.
>   - Arm dnr_unblock_work for the earliest deadline.
>   - Skip the timed unblock during host reset, but not during SCSI EH.
>   - Clear the deadline of an sdev under ioc->block_lock before the fw
>     event worker polls the sdev.
>   - Do not put a timed block on offline sdevs.
>   - When a hard reset cancels polling, give new deadlines to the sdevs
>     that stay blocked.
>   - Give deadlines to the sdevs that a broadcast primitive pass blocks.
>     Prevent dnr_unblock_work from unblocking them while the pass runs.
>   - A repeat DNR restarts the deadline, at most
>     MPT3SAS_DNR_BLOCK_MAX_EXTENDS times.
>   - At the next worker unblock, do a TUR check on expired sdevs.
>   - Keep the blocks that the driver makes during polling.
>   - Use system_dfl_wq instead of system_wq.
> - Link to v2: https://lore.kernel.org/r/20261102-sas-abba-v2-0-b3b9ba874b=
5a@kernel.org
>=20
> Changes in v2:
> - New patch 1: use a new ioc->block_lock to serialize the
>   interrupt-time sdev block with the hostdata teardown in
>   scsih_sdev_destroy(). This fixes a pre-existing UAF.
> - Do the timed unblock under ioc->block_lock. This prevents a race with
>   an interrupt-time block.
> - Clear block_deadline before the fw event worker polls a returning
>   device with TURs. Then dnr_unblock_work cannot unblock the device
>   during the poll.
> - Link to v1: https://lore.kernel.org/r/20261030-sas-abba-v1-1-b8cdd714a3=
7c@kernel.org
>=20
> ---
> Jeff Layton (11):
>       scsi: mpt3sas: Don't leave requeued firmware events pending at tear=
down
>       scsi: mpt3sas: Hold event references while cleaning up the event qu=
eue
>       scsi: mpt3sas: Requeue topology events only for busy devices
>       scsi: mpt3sas: Fix pcie_device leak in _scsih_ublock_io_device_wait=
()
>       scsi: mpt3sas: Restore unblock retry in _scsih_ublock_io_device_wai=
t()
>       scsi: mpt3sas: Stop polling devices when the unresponding scan is c=
ancelled
>       scsi: mpt3sas: Reset the TUR retry count for each device
>       scsi: mpt3sas: Cache the missing delays the IOC actually uses
>       scsi: mpt3sas: Serialize interrupt-time sdev block with hostdata te=
ardown
>       scsi: mpt3sas: Don't use freed hostdata while polling devices
>       scsi: mpt3sas: Time out delayed not-responding device blocks
>=20
>  drivers/scsi/mpt3sas/mpt3sas_base.c  |  62 ++-
>  drivers/scsi/mpt3sas/mpt3sas_base.h  |  25 +
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 869 +++++++++++++++++++++++++++++=
------
>  3 files changed, 810 insertions(+), 146 deletions(-)
> ---
> base-commit: e8017d29067fd1310a65c3494ce1a1b492adbac6
> change-id: 20261030-sas-abba-eacfcc45fe36
>=20
> Best regards,

My apologies, this should have been sent as v4 of the series. I had
forgotten that I had sent a v3 a couple of weeks ago. Please treat this
series as a v4. The v3 series is here:

https://lore.kernel.org/linux-scsi/20261102-sas-abba-v2-0-b3b9ba874b5a@kern=
el.org/

--=20
Jeff Layton <jlayton@kernel.org>
