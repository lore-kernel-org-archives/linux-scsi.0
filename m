Received: from mail-ej2-f40.google.com (mail-ej2-f40.google.com [74.125.228.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D61389E04
	for <linux-scsi@vger.kernel.org>; Thu,  1 Oct 2026 18:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790878352; cv=pass; b=nOXVriBvnJLsLVA3JRBkrI0ivKWEwFDzvbr8/u6GGz1Xm2Bd91TnyHgIpjf7f11GgCTIGqNKPK7GkobCJVeDh1Vj8JRt6+VPfbDS7H84Uw983wJjYMYHbs7evagPSWCh/qpowLvOWW0QxnVfpyrF4AarDfbv8JcJAxECs7t6pwM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790878352; c=relaxed/simple;
	bh=Poodaht5L9IhwquMet8HlxYIE57MMAabGxQCSa6e0uc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GJ64nYGEW5070fx0SODsj6kLgpcXSpYM8kNKAJcmA0AE8f2ETj1obNgYPnt/DGCjcYDUkKyjLjA+1NSp9wQvjfcYgd7HEkPPIxx1eoWn0/+toStXKV1DkNffJlFRiB5roMritwC53C2+wYhAxdcqxV3UlKfB1xuOjMTSSGHUhnQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PviQjAZm; arc=pass smtp.client-ip=74.125.228.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PviQjAZm"
Received: by mail-ej2-f40.google.com with SMTP id a640c23a62f3a-c2e402001e8so138345166b.2
        for <linux-scsi@vger.kernel.org>; Thu, 01 Oct 2026 11:12:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790878346; cv=none;
        d=google.com; s=arc-20260327;
        b=Ky6h9FGBWO9cs/z6KLq46Ddt+sWHy489xnPMb/Ug+4zRvtmy2BcY2HNBu93MAobNfY
         0OsuIwV1c0gj0pGZ3MZuKlkJvV/7njLjJwcZoP1ftXt630LUdq8rzhkcJeqKgIYGYJXR
         ZyhPyhuW3j/c7n4EHtMdpK0piDL2euHAjC2ncXfoIH52B8GD1/bXnblZ2drPPmDEQ9Ln
         dgp84IZ5iMeKhCRZaastiSu96RVRhbDNHC1KoW0yuJ4T3LSA1X4QfBQt3c4Fpd8cclg8
         RItsxbo57JInl+xjRsZ1h4hqq3YzTTulopgY1MyoQXsyrQVy2445zBqo9kztTtURHMU3
         XLKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZOgZ8ItT+mDGbnIjqDG5uV+tKRAev99+tRvKDSNbx8w=;
        fh=EmhP1HCqta23iwc1un51CtNb/ZNNmxToI7M4twW/mzk=;
        b=Kb85/a/L+EDi2v25y4zgLr6phdfpo1cp0EdvrZZCXlihSHQ9rNYE+Mzxic920mrnKX
         9m8UGAbJofj5BJJUWQEOPZ/OGJJxYg5P9S8qMgwDwo1zI9r0PXCBs2FEhnY1MYvDykGJ
         2cYNKYNvqo1EQQ5CM5y+AX5ZpoN6gKeEVapIKsQ5VwN44T7yqTo2gau3byHkmXfJvmhg
         aYtvAKXWqCHAi9frLURLQRDb1kNirkY3pCflClrLznUPoXnkheH1uHV2owGByew4NJ+c
         Yz9JkOjLOlVtaIPSCiNtYWax889Nwxva+YO6of00jwANSdNareQoKsohJoYynKmZbM59
         6xHA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790878346; x=1791483146; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZOgZ8ItT+mDGbnIjqDG5uV+tKRAev99+tRvKDSNbx8w=;
        b=PviQjAZm0Vu17n6yqgGUbjQPMgeSfTv4V1tomvFYPXQ9ACg7yN8CId7x4VRHzuNvj8
         +mqg8N1PzggX0hw3hItHHf1KUxa2R/E4cXFznCOZGnh09dv82cdatFupoP0BOONmik9J
         ALW2/2jot48DnVCtCJSAuaniL+pDj1wjX2sqNlUpQVulO2B809p2he66bwDECfqvofCk
         elFuL/TqGric9t/oX2H5zatvdSmgTZ7+q11SeCARnZMYD+va25EyJod+26MiYl2RZDbc
         TugTcZqYXeGJN7FXmH+qmzz4fZvlD+MYMMaJGXHzP6gsnj+tz6mET6YFiAKcXXOHtGoA
         Nrxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790878346; x=1791483146;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZOgZ8ItT+mDGbnIjqDG5uV+tKRAev99+tRvKDSNbx8w=;
        b=dw0kjLPtb8K7P6a+UZ1ZPxOgwRCnTRZZ374N/QRhQfpbam2IvrSiD0lJcBiqlnwzvX
         AbiVaC4/QT6HJy5tT1EwT2tMASceGBebLyHO0d2xYqN6PHi9BCGo3L8UvLi9HluApqYm
         mchLqTq1LIyj8NLLzEDj2ex5Ulg5r8T2AgFYhiLSpDU3CJXvB39ONwVftGSMjVdFsT8p
         4GX2Gu9Z0Zji1qLp6Efz4xV9B6aw/S+JigHL3HrE4bVkPlz6g+3kiFGeKgv5MYu9v0/v
         bVlH1Cb7zJ2h7r2ODKo1jJcRilkThrLSk32HO2DEweUICooC/PqdY53kWzS5/+cI6di2
         vEoQ==
X-Gm-Message-State: AFuF++l4kf/4Jm0KpTxXy+1DmsBS3j8hdTZjosf5Qo4Ae1h9FW3Ei2r3
	fV7zzLH8BHs1I63qVkmj7qMa9lu4LkLU7zpbvNUvWYL6qVBCEJAl4ouXniLG8RvyWAkSaxGozDP
	glVlZLY4cuIVs6c0uLgrtDQDw0Qu1H/Dcxo/p
X-Gm-Gg: AYBFou2wMz0GPptybRAxpS+QHtMaC7rL/8/Rh/0sI2jMtGdoBe/CSUaqjNElfAoyWmo
	k/WoLvaUZlzhG3bqgihhPbiI1+W2Er5AyN0zRAz3hM81n1XN8Dn1/s4MojWO6Rr/5NwagF4xjN2
	7s485g/SdBwBKOn851gU8pjF6QDZY+kSQhMQvzxpRwHetWWOgvJ56GOsfS8W+/HT6gnar1M1j0V
	vlPl1UbDG41gXVlqDpMVBRT0604SRkRLxTbvCF53QEdRd+Kl9kT1UyjQ6kdD+/xXXBIOKW7zeUS
	I2Qp+MbNzXV370LOySpjQ30l7I7VNJQ45OSwSBuSlpB2MOCvTiuPPhlr
X-Received: by 2002:a17:907:c312:b0:c25:2a78:15ed with SMTP id
 a640c23a62f3a-c2e4a9b37f8mr38540766b.6.1790878346274; Thu, 01 Oct 2026
 11:12:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260928181757.21959-1-nkirkland2304@gmail.com>
In-Reply-To: <20260928181757.21959-1-nkirkland2304@gmail.com>
From: Nigel Kirkland <nkirkland2304@gmail.com>
Date: Thu, 1 Oct 2026 11:12:12 -0700
X-Gm-Features: AclHuK-dDODYmP-ayDTUt_YqsBAXnyjeL8ZMsbGmeDWUPmuCLUlmAQz4vQQ6PcA
Message-ID: <CACnqm7-_BNCBC9uHrRAWiWjEQoinSH_LK8hQjR6wmpjPEYJK0w@mail.gmail.com>
Subject: Re: [PATCH v5 00/10] lpfc: Update lpfc to revision 15.0.0.1
To: linux-scsi@vger.kernel.org, nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 28, 2026 at 10:54=E2=80=AFAM Nigel Kirkland <nkirkland2304@gmai=
l.com> wrote:
>
> Update lpfc to revision 15.0.0.1
>
> This patch set contains bug fixes related to cleanup handling in both
> normal and error paths, and refactoring of duplicate code.
>
> The patches were cut against Martin's 7.4/scsi-queue tree.
>
> Nigel Kirkland (10):
>   lpfc: Fix use-after-free in lpfc_cmpl_ct_cmd_vmid
>   lpfc: Early return out of lpfc_els_abort when HBA_SETUP flag is not
>     set
>   lpfc: Fix kernel oops when unmapping scsi dma buffers for an aborted
>     cmd
>   lpfc: Check fc4_xpt_flags before decrementing ndlp kref on FDISC error

Responses to sashiko-bot findings inline

patch 4 - new finding (was not reported against v4) - will fix

>   lpfc: Add handling for when PLOGI or PRLI is dropped during link
>     failure

patch 5 - companion patch was erroneously omitted, will fix

>   lpfc: Fix ndlp use-after-free during repeated RSCN and rediscovery
>     sequence

patch 6 - some findings are not a regression - however, will be improved
in next submission

>   lpfc: Rework I/O flush ordering when unloading driver

patch 7 - we believe the fix is valid. There is longstanding scope for
future hardening. We plan to address separately in a future patch
set.

>   lpfc: Refactor calls on fc_disctmo to lpfc_set_disctmo in RSCN handler
>   lpfc: Update correct ndlp refcnt when rejecting an unsolicited PLOGI

patch 9 - we believe the fix is valid and it is well tested. There is scope
for additional hardening. We plan to address separately in a future
patch set.

>   lpfc: Update lpfc version to 15.0.0.1
>
>  drivers/scsi/lpfc/lpfc_ct.c        |   2 -
>  drivers/scsi/lpfc/lpfc_disc.h      |   5 +-
>  drivers/scsi/lpfc/lpfc_els.c       | 109 +++++++++++++-----
>  drivers/scsi/lpfc/lpfc_hbadisc.c   | 170 +++++++++++++++++------------
>  drivers/scsi/lpfc/lpfc_init.c      |  16 ++-
>  drivers/scsi/lpfc/lpfc_nportdisc.c |  30 ++++-
>  drivers/scsi/lpfc/lpfc_nvme.c      |   9 ++
>  drivers/scsi/lpfc/lpfc_sli.c       |   8 +-
>  drivers/scsi/lpfc/lpfc_version.h   |   2 +-
>  9 files changed, 242 insertions(+), 109 deletions(-)
>
> --
> 2.38.0
>
