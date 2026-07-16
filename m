Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9EF334C3C;
	Thu, 16 Jul 2026 11:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784200544; cv=none; b=DWwitvM2Cy+FDwbUbmB9mpXwL9qX4sMivnlxv0OtkbQrw+dBgud8rmF5trv0AJpJqjD9rdfs6mwn1jiGbStYn61nc31bR+5L8a7Yic235tjBMqO1nflw54XNn+FmTfpmI+3nRYnc5et11+U1BxM+AI/1JMjcF6QdM9tiM3bn3vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784200544; c=relaxed/simple;
	bh=Btmb1XeTBgBy2fNJUcD7E30W9WNy4gFsbODvVTRbkHk=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=UVRZnCvJpi73QRtqex8mv/0NukXljYi05FEH45/KIeJ6Itg9V0sGHch03N73vK0yUXfFU3VqbIUpTafw4w6UuLTKZAzpa5pPGarlWSJe6njYpCVNELXg4lBBTE1LQ03IOv/4/quTuSEvh1mKg20SuXkM29b+TocLLCpm9dL68os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lylBx5mX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lylBx5mX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0ED1F000E9;
	Thu, 16 Jul 2026 11:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784200543;
	bh=zWPzKaDIXTB5hQFzVtEim1Yg21f39RdjyxB/OMddJPw=;
	h=Date:From:To:CC:Subject:In-Reply-To:References;
	b=lylBx5mXAnVXVhflTBOLyAZ2OuNd3Z2lhgsyn9E4eScYSJ/fyRAtx6GUfoB28Rung
	 7AG5brfS0He+2/2Bg2gpmTaiZfAiERZX0sIHgxJoKRhJP4w4+3Cl5wfc3AHT/6ikE6
	 NAYLNJVKC2FdW/M9PjqREhx/gMHON4EjEsaPMLdAa+crwoqYAsFITH1uK92+63SuHx
	 Ua0DOK5s5jL+S6nbfEq+h4nqUA9X+z28M273HhdWt48X21el8YHU/bIY3lRZadecUv
	 UwJC9IhUNDJpaiquelWAbs2pW5ikE/lAyuZiplPGeJYcd9s3qB+rR9ZJJVA4erj6ir
	 IDBQi9p0sHGQw==
Date: Thu, 16 Jul 2026 13:15:39 +0200
From: Niklas Cassel <cassel@kernel.org>
To: sashiko-reviews@lists.linux.dev, sashiko-bot@kernel.org,
 Damien Le Moal <dlemoal@kernel.org>
CC: dlemoal@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4_1/2=5D_ata=3A_libata-scsi=3A_t?=
 =?US-ASCII?Q?erminate_deferred_commands_on_time_out?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260715092017.05CBF1F000E9@smtp.kernel.org>
References: <20260715085824.854200-1-dlemoal@kernel.org> <20260715085824.854200-2-dlemoal@kernel.org> <20260715092017.05CBF1F000E9@smtp.kernel.org>
Message-ID: <19CECED4-8BC0-4028-914B-2EF1C55C729D@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 15 July 2026 11:20:16 CEST, sashiko-bot@kernel=2Eorg wrote:
>Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>- [High] Deferred commands retried via `ata_eh_retry_deferred_qc` will be=
 erroneously processed as ghost timeouts during SCSI EH, leading to lost re=
tries or erroneous `DRIVER_TIMEOUT` failures for unissued commands, and `ho=
st_failed` underflows=2E
>--
>
>--- Patch [1]: [PATCH v4 1/2] ata: libata-scsi: terminate deferred comman=
ds on time out ---
>commit 40daf934a62cbe822fdf8ae16b1ee66e4ac23f37
>Author: Damien Le Moal <dlemoal@kernel=2Eorg>
>
>ata: libata-scsi: terminate deferred commands on time out
>
>This patch introduces ata_scsi_eh_timed_out() to immediately schedule a r=
etry
>of all waiting deferred QCs using the eh_timed_out SCSI host template
>operation=2E It implements ata_eh_retry_deferred_qc() to schedule the ret=
ry
>through libata EH with ata_qc_schedule_eh() and flags waiting QCs with
>ATA_QCFLAG_RETRY=2E
>
>Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation"=
)
>
>> diff --git a/drivers/ata/libata-eh=2Ec b/drivers/ata/libata-eh=2Ec
>> index 05df7ea6954a9=2E=2E5c56e1dd580b6 100644
>> --- a/drivers/ata/libata-eh=2Ec
>> +++ b/drivers/ata/libata-eh=2Ec
>> @@ -546,6 +546,27 @@ static void ata_eh_unload(struct ata_port *ap)
>>  	spin_unlock_irqrestore(ap->lock, flags);
>>  }
>> =20
>> +void ata_eh_retry_deferred_qc(struct ata_port *ap,
>> +			      struct scsi_cmnd *timedout_scmd)
>> +{
>> +	struct ata_queued_cmd *qc;
>> +	struct ata_link *link;
>> +
>> +	lockdep_assert_held(ap->lock);
>> +
>> +	/* Trigger EH for retrying any deferred qc that has not timed out=2E =
*/
>> +	ata_for_each_link(link, ap, PMP_FIRST) {
>> +		qc =3D link->deferred_qc;
>> +		if (!qc || qc->scsicmd =3D=3D timedout_scmd)
>> +			continue;
>> +
>> +		link->deferred_qc =3D NULL;
>> +		cancel_work(&link->deferred_qc_work);
>> +		qc->flags |=3D ATA_QCFLAG_RETRY;
>
>[Severity: High]
>Does clearing link->deferred_qc here break the deferred QC lookup in
>ata_scsi_cmd_error_handler()?
>
>When the SCSI EH thread runs ata_scsi_cmd_error_handler(), it attempts to
>identify the deferred QC:
>
>drivers/ata/libata-eh=2Ec:ata_scsi_cmd_error_handler() {
>    =2E=2E=2E
>    if ((qc->flags & ATA_QCFLAG_ACTIVE) ||
>        qc =3D=3D qc->dev->link->deferred_qc)
>        break;
>    =2E=2E=2E
>}
>
>Because ATA_QCFLAG_ACTIVE is not set on deferred commands and we have alr=
eady
>cleared link->deferred_qc to NULL above, the condition fails=2E The loop
>finishes without breaking and falls through to the ghost timeout branch:
>
>drivers/ata/libata-eh=2Ec:ata_scsi_cmd_error_handler() {
>    =2E=2E=2E
>    } else {
>        /* Normal completion occurred after
>         * SCSI timeout but before this point=2E
>         * Successfully complete it=2E
>         */
>        scmd->retries =3D scmd->allowed;
>        scsi_eh_finish_cmd(scmd, &ap->eh_done_q);
>    }
>}
>
>Will this cause the retry budget for the deferred command to be artificia=
lly
>exhausted, resulting in erroneous DRIVER_TIMEOUT failures for unissued
>commands?
>
>Additionally, when libata EH later processes this same qc in ata_eh_finis=
h()
>and calls ata_eh_qc_retry(), it will execute __ata_eh_qc_complete() and c=
all
>scsi_eh_finish_cmd() a second time for the same command=2E Could this dou=
ble
>completion cause host_failed to underflow and corrupt the SCSI EH state
>machine

I'm on vacation mode, so not thinking clearly,
but does Sashiko have a point here?

You modify __ata_eh_qc_complete(), so it will NOT call __ata_qc_complete()
if ((qc->flags & ATA_QCFLAG_RETRY) && !(qc->flags & ATA_QCFLAG_ACTIVE))

But __ata_eh_qc_complete() will still call scsi_eh_finish_cmd()=2E So it t=
here a chance that=20
scsi_eh_finish_cmd() will be called twice?

Do we perhaps need a QC flag anyway, so that an "aborted" deferred QC does=
 not call scsi_eh_finish_cmd() in ata_scsi_cmd_error_handler()? (Such that =
the=20
scsi_eh_finish_cmd() in __ata_eh_qc_complete() is the only one that will b=
e called=2E)


Kind regards,
Niklas

