Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229C31096F
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781264212; cv=none; b=UDKgdPyAmhAE+vx8cOV/FAnasNq01ULRYI/HvuDLLxD5FxuIMUc+ALyGY0IqHBgIQ2I0v+x/o+aV/h33byWRd2QBVe9o44q1ZWZd6yUKsJNlnK71uEjVe3Dv+5PppNEIxKBYEftniZe1Jl0ep2NhvEeZegn2DCgfvNHAs+WAGCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781264212; c=relaxed/simple;
	bh=z+D6p2an1veaVRwTkYOz08QW/CwvqlFjIwnWciLS3qQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PrJjyyouiFdrlBiUor7dOD6tCxoztQFlsrT+cr30zfq0rnqDbkSJDXC/OmR6HtW3QEraT2/YArVw8PR2Bcm25LPi185MP3zz1cGbEHOQUDP1DQmdsHC4ko4HGMPi675gvd8Up541kEEhtnbi0qnSv/46k5UpuNrkc8O1Mfhr+7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Uza/huYa; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Uza/huYa"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490c1915793so7192115e9.2
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 04:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781264207; x=1781869007; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZDxDKhuxXGqr+OSinvwhbnpKYCwVePF5suf1RLLViFg=;
        b=Uza/huYabTkGKxwreVY7UG2NfpdS/9iSQJ/fzvJgdy0cm1BjWuyhGPsUaD9p5+i4i5
         vb1zolxVtd14sHVidDhv8Z2lRIvWvq88Gushy2Z78Mjt3kqbcKyPh1sMaZYHmfMjAW5G
         j+Xri1ClfFbVG62f0B/s0SCYrdfC5Kd0+MAjR8lysd3HJ9pF+2Zmqrj1kmFp/2y4eIIm
         DGrsNRRdXQyChMt0JIX8heRoWscmPPlb6hW6C4CuMEdOVevS4RWVWetKOTbTpbj+ebCp
         utjIWCOe1jowhmNIYDh2WV3dCFFBt29UODIhttyqMZdLEx93GLh63BnxYajz/v2z6mLH
         yumQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781264207; x=1781869007;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZDxDKhuxXGqr+OSinvwhbnpKYCwVePF5suf1RLLViFg=;
        b=QOM7WK1GHS/5bx0ljaZZ2l7jZjUMPjZujpG/8NIjct5srtQZdgt2S7S1VCrpNFE6AU
         ZJ8g+Ir56zlmoL546DCncuwUnnRP6y8SI6omxKmcNr96FCFb81glR3bDcGfGh5GcQl/l
         tzngndI7LKp6Tdg1njMvPCod9Ux6x0gotcMasSgKJNoVIRA2ceKn0ZrG5W2LYHIazDoa
         Q6I27qkudYIoBevrkNJcUeVl9quYB5NQ4z1PxlJ7bXOaYZYXENwwRH/A559J7Da9GaIu
         BXJ3SDBKXNde5LUcZ8x5ZEJMBAKcap94nObU2DtbRTkRNs3OHeTcDZhNWjO6841cisqY
         X5Wg==
X-Gm-Message-State: AOJu0Yy0tAW6P5RPuPwQ66Ih5LP5Y6AjJSeCBenfYW1Pqfwe2evzf22x
	7OWuIxsU2uZW96XuRStpm7RcniWV2TcTIjMcACun+sIGTtxTWKB4uzbthBXULLzuw4c=
X-Gm-Gg: Acq92OEXdRcdgOLzb8Y6P/XGkRd36uovUCrPoOZmJFv54ZBj7tQn9YNjVZ1EZ3kzJhX
	fBF9BSs5A4BYWwMV2qzJuRT3PDPEP4OH/TwSA6LVeiueDEXwIPdfqBt9MjjBctgX8lTfBLTcFEh
	dxPe9vVuABmgLludF6pEvAjpCH2z3aUU9raVMIXsUyYsOrjmedBBTOdXHuCPGioUHTHzS8rfyZ9
	gZ/lSUOAhbwpY3R25O/3CSN1qlA91uK5Bq1nnYmK2R6Nqchafv4dat0CjT/yUE85NepUQrow6Jl
	t7achAf+nOfFyE3ZnDJm5oxZyQWTmwzElwuoMyjCzAlMbh/UnBkJO88NtFh1lTYr8SrED1rHcfZ
	dktCX33vT3hyaiv2vuVMS+EQga84GzSMCxjoL9BHdnulpBipZ4oEYaiqTxD+5FqQE/h2dHrnGYk
	XX13rtwtGqkJy018SObTTJCBgilwLpPTrXCyVH6mvufW4cIwLF43S37eao
X-Received: by 2002:a05:600d:644a:10b0:490:44eb:c1d9 with SMTP id 5b1f17b1804b1-490ec50a39bmr22341955e9.28.1781264207167;
        Fri, 12 Jun 2026 04:36:47 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f263923sm5134612f8f.2.2026.06.12.04.36.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 04:36:46 -0700 (PDT)
Message-ID: <b9b5b0de-fe39-4aca-8be7-eebf36cd9103@suse.com>
Date: Fri, 12 Jun 2026 13:36:46 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 27/60] scsi: qla2xxx: Refactor marker IOCB handling for
 29xx series
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-28-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-28-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> Rework __qla2x00_marker() and qla_marker_iocb() for QLA29XX extended
> marker IOCB (128-byte) support.  The extended layout (mrk_entry_24xx_ext)
> overlays mrk_entry_24xx through 'lun', so the common header fields
> (entry_type, modifier, nport_handle, lun, handle) are written through a
> single struct mrk_entry_24xx pointer; only vp_index, which differs in
> width (u8 in 24xx vs __le16 in the ext layout), needs a stride-aware
> IS_QLA29XX() branch.
> 
>   - Allocate the IOCB once via __qla2x00_alloc_iocbs() and cast to
>     struct mrk_entry_24xx, eliminating duplicated alloc/error paths.
>   - Branch only on vp_index assignment where layout diverges.
>   - Update qla_marker_iocb_entry() in qla_isr.c to accept void *pkt
>     so it handles both 64-byte and 128-byte marker completions.
>   - Add BUILD_BUG_ON size checks for mrk_entry_ext_t (128) and
>     struct mrk_entry_24xx_ext (128).
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_def.h  |  2 +-
>   drivers/scsi/qla2xxx/qla_iocb.c | 84 ++++++++++++++++-----------------
>   drivers/scsi/qla2xxx/qla_isr.c  |  7 +--
>   drivers/scsi/qla2xxx/qla_os.c   |  1 +
>   4 files changed, 48 insertions(+), 46 deletions(-)
> 
Why do you need to refactor code which you just have submitted?

Please merge with patch #12.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
