Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF084FC330
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 16:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792167109; cv=none; b=CMrR2CjAteXgP4bhzvfGH3fEYYGsnPNBM6guLZ+TjKPyCf7QpEz35orZjXmI6gDHsX7hUi2pLF8p+ok9kBna60cGCUicq+ppPYiPifdsxmZn2dvGzhjvwzMLZ8Q7P8Mzcr4i5Fs+rL8sX8e6p9iQmks1JlRulKB03cl36IHR/4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792167109; c=relaxed/simple;
	bh=ydTrmRk8edZTgf7y/1Wl0ruYEF6mo2iZWv8TZfyBpVA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=LesVLcfRQWXXftW0mu9/xJZtpm4hxugCk8WIvO6OzrMlJ7eH6ztKe2QArZF/tlGFrijr4k9R3wYuW0dT4veaRcCOEvebiyAUj4Qx3pf5G2fnb4Qa5M+38qGrjcvGXoDkjmsIjzwlCN2E9mKOwPykYTg2Zq37ww2A+0ZbfV0Dj7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PTOSTbNt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PTOSTbNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C888D1F000C4;
	Fri, 16 Oct 2026 16:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792167101;
	bh=QkteZhfbS4ahFm+dxdPOZg40M/jtQpsRFcTR4LvayPw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PTOSTbNtb7pz2Rq6TtqoQttdXJNerV+UbbdX0hIW3GmGRDpiEMBqx13K966bb7tWL
	 yvuflVeRKxcTK74PPAEwsoPrzX17bdZ93gU8gSrHfags0F4qVMQZt3I89UrZLUs7l1
	 IHDS1hvdzp6Eot5qyYsiYJenREwNSp9L5x/9HsG/tzr8mB1Ku2byeh/UicrU3m6qJd
	 I3a6Bm7oe3BwvAiYxUY3/ZbbddgmI9hmZLOmC3l904FVJFXirpTYB8PAwTVNiyEvyv
	 Jmsn0U7Oej7YPfhfxvb/pVwvuUvJ16Wp46Jj6EYUy/6aviYpuVB63bzSfrJPLLzr7a
	 DWYy3+cWhU6XQ==
Message-ID: <sashiko-outbox-174607@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/3] scsi: bfa: drop unsolicited frames shorter than
 the headers they must hold
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261016155441.1607196-3-yhlee@isslab.korea.ac.kr>
References: <20261016155441.1607196-1-yhlee@isslab.korea.ac.kr>
 <20261016155441.1607196-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 16:11:41 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: bfa: OOB read of ELS command code due to missing payload bou=
nds check
--

commit 31f50cb105260d95a224555b9e6f894b5a59692b
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: bfa: drop unsolicited frames shorter than the headers they must hold

bfa_fcs_uf_recv() keeps the received frame length in a u16 and hands it,
with a pointer to the frame, to every unsolicited frame consumer. Two
lengths are never checked.

> diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
> index 9b57312f43f50..8bb92f935a40f 100644
> --- a/drivers/scsi/bfa/bfa_fcs.c
> +++ b/drivers/scsi/bfa/bfa_fcs.c
> @@ -1527,6 +1527,14 @@ bfa_fcs_uf_recv(void *cbarg, struct bfa_uf_s *uf)
>  	struct fc_vft_s *vft;
>  	struct bfa_fcs_fabric_s *fabric;
> =20
> +	/*
> +	 * every consumer reads the FC header, so the frame has to hold one
> +	 */
> +	if (len < sizeof(struct fchs_s)) {
> +		bfa_uf_free(uf);
> +		return;
> +	}
> +

[Severity: High]
Does this check need to account for the payload length when processing ELS
commands?

If a remote device sends an unsolicited FC frame of exactly 24 bytes with
fchs->type =3D=3D FC_TYPE_ELS, can this cause a regression where the driver=
 reads
beyond the verified length?

For example, in drivers/scsi/bfa/bfa_fcs.c:bfa_fcs_fabric_uf_recv():

    struct fc_els_cmd_s *els_cmd =3D (struct fc_els_cmd_s *) (fchs + 1);
    ...
    if ((pid =3D=3D bfa_ntoh3b(FC_FABRIC_PORT)) &&
        (els_cmd->els_code =3D=3D FC_ELS_FLOGI) && ...

And similarly in drivers/scsi/bfa/bfa_fcs_lport.c:bfa_fcs_lport_uf_recv():

    struct fc_els_cmd_s *els_cmd =3D (struct fc_els_cmd_s *) (fchs + 1);
    ...
    if ((fchs->type =3D=3D FC_TYPE_ELS) &&
        (els_cmd->els_code =3D=3D FC_ELS_PLOGI)) {

Because the driver recycles DMA buffers without zeroing them, the hardware =
DMA
writes only 24 bytes, leaving the old payload intact in the buffer. Could t=
he
driver read the stale els_code and process the stale payload as a new comma=
nd?

Should there be an additional length verification before accessing
els_cmd->els_code?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016155441.1607=
196-1-yhlee@isslab.korea.ac.kr?part=3D2
