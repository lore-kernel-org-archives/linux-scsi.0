Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D884B331EA4;
	Wed, 30 Sep 2026 08:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790758568; cv=none; b=k70UHIbFRbkxZrxs8iAeDPv1ZAuIGM8Rw/CiqLMN3lAudaTJ+da2c3rhS2wlg6g7oI8UYIwk/VJCk9tYd6aAePV9kaqY8h6pzdexZ6yPwPMUEPVfjDYGKQ8I8ZfJD/aY/76OvqPsA96PFYdFeH2huwYMW44rczR8CNJ5e1FUWb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790758568; c=relaxed/simple;
	bh=OtlmDjEzOhdqKstpXY7dfzcR7Nv+cf6VxH4Hvby8RD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hbXyZxHbeGF07zY57MLx9uLZouIlDo5r/mOHN9l2or+xfyihpYwgQSJtY+7t/9TffzmoXXB0iia9umP+Hm1Z9HzlkBZde/tp9YQVaRH3mGPojKAzFkWJ+IHIKjHedOcuoz6D3nM77I9+XuOs6jpfqGn6VEUqRuJtlBEDc12uo6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SqFHVofN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SqFHVofN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833BA1F000FF;
	Wed, 30 Sep 2026 08:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790758566;
	bh=sYPjnCbAgZIi3AiT+FWm5Nd5exsKvc5ZrIAbenlDVCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SqFHVofNhmK4pHxg9u2KPmfAkp9FMXNocokWn1aNa+EWPttpDkZ/LjUIxEt4lzNCO
	 kQ3BVp9f2EIlrYBo1PoPSZ08FrFQ72PCRULosHZFVWPf5sbiXbxg+PO0sOq9r41rra
	 NWeXBlsj2MH7JmtUWZ/jGMhntq29eT9OaZQ4ysTgN8c87TbLPg+6ssG13OQrissyuU
	 8Om2M0pb6ikSkSDcbj6R1NwIkoibsoVvXZW12Gu5Hx1r/vaiyEO2y2D6qjsgKwwGSv
	 xbJScNoKqO95qaF0QhpsDNBln2+g5AucGvgHqURIt311uuoKjYKzJcrrgORnUtEvuT
	 /IKjgyZirMYLQ==
From: Niklas Cassel <cassel@kernel.org>
To: dlemoal@kernel.org,
	hengyul@cs.unc.edu
Cc: Niklas Cassel <cassel@kernel.org>,
	mkp@kernel.org,
	ipylypiv@google.com,
	linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] ata: libata-scsi: do not lose CHECK CONDITION for failed ATAPI commands
Date: Wed, 30 Sep 2026 10:55:21 +0200
Message-ID: <179075848958.1151028.10537312460612176838.b4-ty@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929164135.266708-1-hengyul@cs.unc.edu>
References: <20260929164135.266708-1-hengyul@cs.unc.edu>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1331; i=cassel@kernel.org; h=from:subject:message-id; bh=OtlmDjEzOhdqKstpXY7dfzcR7Nv+cf6VxH4Hvby8RD4=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLL2nKtyiO9apCEuz1cY1+7wP+W35bTH9xdvO+mg1/Pza A/rAv+/HaUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZgIxzpGhr/va+3NvUvnnV9u O0Xyw/aNnApffqcXyt92vr/qKYt3zE6G/7XLFrn65Ag21DJY/fm2TvPN82dN2iWF7q8+qbXslAr ayA8A
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

On Tue, 29 Sep 2026 12:41:35 -0400, hengyul@cs.unc.edu wrote:
> Since commit 2e1d2e65e773 ("ata: libata-scsi: terminate deferred commands
> on time out"), atapi_qc_complete() sets SAM_STAT_CHECK_CONDITION for a
> failed command only if cmd->result is zero, so that the DID_TIME_OUT or
> DID_REQUEUE host byte of a terminated command is preserved.
> 
> However, cmd->result can also be non-zero for a regular failed ATAPI
> command completed through libata EH: ata_eh_analyze_tf() calls
> ata_eh_decide_disposition(), that is, scsi_check_sense(), on the sense
> data obtained with REQUEST SENSE, and scsi_check_sense() sets the SCSI
> midlayer internal byte of the result for some sense codes, e.g.
> SCSIML_STAT_TGT_FAILURE for ILLEGAL REQUEST with ASC 0x20 (INVALID
> COMMAND OPERATION CODE) or 0x24 (INVALID FIELD IN CDB), or
> SCSIML_STAT_MED_ERROR for MEDIUM ERROR with ASC 0x11 (UNRECOVERED READ
> ERROR). For such commands, atapi_qc_complete() keeps the result as is and
> the command completes with a GOOD status byte, even though it failed and
> valid sense data is available.
> 
> [...]

Applied to libata/linux.git (for-7.3-fixes), thanks!

[1/1] ata: libata-scsi: do not lose CHECK CONDITION for failed ATAPI commands
      https://git.kernel.org/libata/linux/c/bc8ce2ce

Kind regards,
Niklas
