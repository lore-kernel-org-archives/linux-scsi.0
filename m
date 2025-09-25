Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F561A0B15
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 12:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758804597; cv=none; b=U88Lvx3w1tGeVmjrD0FEXLF9qq4qWn9O8RvSIZWz3WBbQJ8Sp1n1Dj3iooUbYMEw38Z5TPS5jjHKoRZ9+FAnRD25H26GmyJHKUDQdK7KSsUqtqMWAU3Lwe0cCX0ROOsam5Zgu1X/zwKtC38M6bwNkgcg7f/jYEH1KhMucuTJX6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758804597; c=relaxed/simple;
	bh=MF54MGCuDfi8gReEhm6Ls7UVrLmOKS7TeRw9elzcLcQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OGlPQGGb6ZYl5IVtDZsqeVCueyjonzF+bHa3v6+H6LYmbaK3+7DB7q3TJpAbfdVVCAWZd5FDUqHHDotbLTIAXYoTIa7etOpBEmCcPIS2xHYNkNhPdD00vvCrSreCij+MpLZGkofpp5oRFm32X1orGx4yWUpvwyHjIf3hKcflGhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A8CmWYcb; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A8CmWYcb"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46e38bd65faso374545e9.2
        for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 05:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758804594; x=1759409394; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uDHkDpnwsvXEtA5926rNuw5z8tqEQhjcHTKI7hITw3g=;
        b=A8CmWYcbs7J+eaUMRhy/EpGN/Zxtp0fG2sJ5usJeQBUhcph4/piPijJT+AgMs1pjV9
         iDGJTwRiIEAnIhrJJEXWLfFMuwRG+YQsMHnp5DR4LptAmDyubFZsiuJdcMQueP9FWzKg
         b9puH6pI4G+R2VP/i+afwnGPTRETsgihqiSzJkS2El5IaNJuxLaixaMN7sXiWKNgyO1f
         eeJcNs2YdDvghSLUnUrm++t3VLK2Egies46b22P0Ff+EfxzsL/6VptO2sqL3VmECTaDd
         GCKfZ+LGrnC2fbqdaPqltYch+G5MBg9qXqjqjhJ1Dlk7fk1JUNghnpSuizHZZl6CZ7ip
         mwEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758804594; x=1759409394;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uDHkDpnwsvXEtA5926rNuw5z8tqEQhjcHTKI7hITw3g=;
        b=bxfsyWndCImkha0UbaFYp4UxFQRK2fWzofZO1nFkMIVilnAzJgDQJMPwvWS7cUh2qM
         Jt67KFCygwJVZ+W6gjXW/S60cyP1ZJs6RPEqXdnO8S2Tk6AqfY8diZOhqd1d5eFw7INL
         BvNWVTPUGrgY91EmI1Aq3rFmvptihgoMLhZ0fZdHECshMv+8o4lXPG9ehSDmpsOuOTeG
         +LThOnrXfJS/oRi48jwn9UCHdNnVB1sQz+onOknwfwamtRr5Pg9zw4qte8391MzoRsDe
         WzDnTtX8TJc7VsQF2j7o8tqWqgAofKW64P1c5SEBJkKj6mB6AF4W2cgYL2fH0AeqhuhO
         UW7w==
X-Gm-Message-State: AOJu0Yz1fN2NjK1PtQIABhWRim+2h9jJ4PjPZseigck3dgHd+X3kVS4X
	rJTq7Pofsl8lOOaDo4NISZYiSSz3JWsbFnBBjPtB5lO6NmwliorFbbIw3cYEr/RAIH0Y
X-Gm-Gg: ASbGncv4cd8o2F1RCMm2bh5Y3W7CIU/Zg2JJbRKWKBubaAiXlOUvNhBROaLq8d5EMMS
	xk0Y5OAFBCrDhDSvdGSF9MCEXW3fUpYBMxqATGqcHFosNwpoAR8X1fYU+B49nDMRVrxmgbrgb4D
	8rse24H+stf+PfvQAITlGNYISKv2iN2jxk9j1JpL1Lsay5LqNl81jpl9qqSxzZrd1WzfCGo3qQ7
	uhna3aquB1exwir0GuZ66HI6mj4ojet4Wd469nZZmQXOXCmc41eAKGrx2x2pTP+bSq3EmYrYMdj
	bhR2LMQxskz+8VKnLIvc/NYTpi5/m78NwqqsGEQsSOcXSVCZyvD4hEbyyQ/ZrPUrP/LvNy3Dl8/
	CfCUN0uYvB8WptEyXXfAcDIJL6uA6boJSOFLyY9bKTUM/yE2zXyGormLbcAfO
X-Google-Smtp-Source: AGHT+IGRbKrVkaHhQiDxnGP95SsqRWK4KznirLakvgFxIIq9h6bEbsYldjuEYHWl6BnbYeAb+ou3WQ==
X-Received: by 2002:a05:6000:2a89:b0:3ec:db87:e8a9 with SMTP id ffacd0b85a97d-40e3ab888bfmr1523246f8f.0.1758804593967;
        Thu, 25 Sep 2025 05:49:53 -0700 (PDT)
Received: from localhost (20.red-80-39-32.staticip.rima-tde.net. [80.39.32.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e32bf61b1sm18914565e9.2.2025.09.25.05.49.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 05:49:53 -0700 (PDT)
Message-ID: <0669b097-0bf1-4895-9c2a-5e953aebbfab@gmail.com>
Date: Thu, 25 Sep 2025 14:49:52 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 14/15] scsi: qla2xxx: add back SRR support
To: Tony Battersby <tonyb@cybernetics.com>,
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 adadasdasdasasd@adasdasasdasdasdas
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net, KERNEL ML <linux-kernel@vger.kernel.org>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
 <2cc10189-6953-428e-b34e-b1c714fc0eae@cybernetics.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <2cc10189-6953-428e-b34e-b1c714fc0eae@cybernetics.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/8/25 9:10 PM, Tony Battersby wrote:

> (target mode)

> [...]

> I ran into some HBA firmware bugs with QLE2694L firmware 9.06.02 -
> 9.08.02 where a SRR would cause the HBA to misbehave badly.  Since SRRs
> are rare and therefore difficult to test, I figured it would be worth
> checking for the buggy firmware and disabling SLER with a warning
> instead of letting others run into the same problem on the rare
> occasion that they get a SRR.  This turned out to be difficult because
> the firmware version isn't known in the normal NVRAM config routine, so
> I added a second NVRAM config routine that is called after the firmware
> version is known.  It may be necessary to add checks for additional
> buggy firmware versions or additional chips that I was not able to
> test.
> 
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> ---
>   drivers/scsi/qla2xxx/qla_dbg.c     |    1 +
>   drivers/scsi/qla2xxx/qla_init.c    |    1 +
>   drivers/scsi/qla2xxx/qla_target.c  | 1030 ++++++++++++++++++++++++++++
>   drivers/scsi/qla2xxx/qla_target.h  |   81 +++
>   drivers/scsi/qla2xxx/tcm_qla2xxx.c |   15 +
>   5 files changed, 1128 insertions(+)

> [...]

> + * Return true if the HBA firmware version is known to have bugs that
> + * prevent Sequence Level Error Recovery (SLER) / Sequence Retransmission
> + * Request (SRR) from working.
> + */
> +static bool qlt_has_sler_fw_bug(struct qla_hw_data *ha)
> +{
> +	bool has_sler_fw_bug = false;
> +
> +	if (IS_QLA2071(ha)) {
> +		/*
> +		 * QLE2694L known bad firmware:
> +		 *   9.06.02
> +		 *   9.07.00
> +		 *   9.08.02
> +		 *   SRRs trigger hundreds of bogus entries in the response
> +		 *   queue and various other problems.
> +		 *
> +		 * QLE2694L known good firmware:
> +		 *   8.08.05
> +		 *   9.09.00
> +		 *
> +		 * QLE2694L unknown firmware:
> +		 *   9.00.00 - 9.05.xx
> +		 */
> +		if (ha->fw_major_version == 9 &&
> +		    ha->fw_minor_version >= 6 &&
> +		    ha->fw_minor_version <= 8)
> +			has_sler_fw_bug = true;
> +	}
> +
> +	return has_sler_fw_bug;
> +}

> [...]

 > +/* Update any settings that depend on ha->fw_*_version. */> +void
> +qlt_config_nvram_with_fw_version(struct scsi_qla_host *vha)
> +{
> +	struct qla_hw_data *ha = vha->hw;
> +
> +	if (!QLA_TGT_MODE_ENABLED())
> +		return;
> +
> +	if (ql2xtgt_tape_enable && qlt_has_sler_fw_bug(ha)) {
> +		ql_log(ql_log_warn, vha, 0x11036,
> +		    "WARNING: ignoring ql2xtgt_tape_enable due to buggy HBA firmware; please upgrade FW\n");
> +
> +		/* Disable FC Tape support */
> +		if (ha->isp_ops->nvram_config == qla81xx_nvram_config) {
> +			struct init_cb_81xx *icb =
> +				(struct init_cb_81xx *)ha->init_cb;
> +			icb->firmware_options_2 &= cpu_to_le32(~BIT_12);
> +		} else {
> +			struct init_cb_24xx *icb =
> +				(struct init_cb_24xx *)ha->init_cb;
> +			icb->firmware_options_2 &= cpu_to_le32(~BIT_12);
> +		}
> +	}
> +}

If you want to review the firmware changelog, mainly: FCD-1183 (FCD-371, ER147301), FCD-259, ER146998
(from 9.00.00 to 9.15.05 [06/10/25]):
https://www.marvell.com/content/dam/marvell/en/drivers/2025-06-10-release/fw_release_notes/Fibre_Channel_Firmware_Release_Notes.pdf

It's look like all 2{678}xx devices/chips are affected by this bug.
Perhaps the Marvel crew could provide more information on this.
