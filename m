Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4512B9A4
	for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2026 06:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785737383; cv=pass; b=i3b7nbzwTIHQgzsEdUvth/cvS0Hq8C3ZXo94ieFdhKwz8IXfmmY1mJdOSokXu6Rzac9XRCCy9pxcAPcw/VL2DTw4N1rI+zgLKYjtGK8cLmgJCzhKlG8bVszdxlmTsskJ7PepMluRy6WmkGAhCvWEhB8pYX0umSZFTde/95oJIFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785737383; c=relaxed/simple;
	bh=TUv476vUgJUp0yBFUE3RA7rYICsI+ABvKxDUKjHLaoU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hrOpjUEMbkSoJeO5mYHNO9yrRJsfejVHyQyTzAushtxpJrqplPiwZHRiL5g7IoZ5Skji9/tMAWQ+RwUJ5+hA1HkczZ4u3ETdmCkv1fnxSkja0F6U5HvpbEpyWQ6iAp3j67cf0pqLOx/I/wcYJpXIoE8sg5FpXDaXkf8cBkmVJqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=g4Sj333Z; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="g4Sj333Z"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c15fc4707f5so47498066b.3
        for <linux-scsi@vger.kernel.org>; Sun, 02 Aug 2026 23:09:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785737379; cv=none;
        d=google.com; s=arc-20260327;
        b=F31FbYgnnKs/m/hUg/ce3Jtifkz12rvSuW+GQg0ylzBMHVN5RCcAr+bbjTtlK2JK8/
         nH1+jqlgvpIPnRBI29M2+f7P0E6GWBcMZAJNIpBgOA1suhxe/++4Rm3V23pFaVbXdM4F
         CfOa9gvRvQRJU9ErOyMKhe89o8A3epJk8Xuyk9jURUgiOni9MzvmiEdI38D24IFI+I4X
         h/+QOA/z977o2TnBTIC7Ho4g35S+GwyhnoysNySLSh92nh77ANzbddylyPfimHMJEeRL
         S8x0nWjT/m9Unb5GSajmnaDLgRAYQjHbbKj3IZas1wx/6NHAVtzMcSEZoZR7rkLMZPzh
         tyvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wTJg/4nDP7MYTEpGxDNKe29PaMdaG90e8BuLEarpdo8=;
        fh=8/oL0s8lWiPsv2G2Snovbu8PCsZaCzlyiR4DnTejI6k=;
        b=LlQQYj0PA4ceTSJ2854TVvo5VV9owtiJbdWGYlybfQOLJjoXsmEoDG90SIw7RSTskg
         DfA7f6dfs8wEzBZP6UXZKwtRBUDUCLxrAGvPVoUb52qvLFjF0oP5wgy1NWivuRkxjhSc
         vPhtMT7RzQDAwC7gTG6dLCSUKXbt6Urw31yBVQwhQgwW3BKnYrZvV/BUgkXLZpAoZW42
         kPvwwbspzI1NTYr73+qnah2FVDzDsXBDATjszoaad8hpbeI7jbmIqMWpUJBi2TIlCcq8
         VOlJfp99gAvmvk55kjAIm2jlbTnOOQaTJfomU+NDvD6i66hmbp+b1hpO/4qNUTbpQB9F
         SZlA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1785737379; x=1786342179; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wTJg/4nDP7MYTEpGxDNKe29PaMdaG90e8BuLEarpdo8=;
        b=g4Sj333ZGBtNj/dVZiEWd+d/n6Qu81QQj5M43X5SDpC1kpQ9y8JFC1c4zXk8c8wrI6
         plJeZ4go353/w0s2Fr7RtTcLVXyaZVI+l6hegM2IrXRzRO4EPOpCmtS0a8wudgTrkKBo
         JQj56j9Z8rY08pT29msvmxnL9grEy+0V33CpedA/fLo0bh+hREKau2jAfgO+rOqoR0Zr
         zm3Bq4pyFSmsZhBSIUG1qHMSi2DM4ca21UyWLhAAhXnHxJhRyAeo9cGbCMMvxzKn8YKY
         3ahfHaRy4ZIZHX6US5iGZ8JfvF0hef1jtwBQ/k3At63clcx73lDGzW1FhY6ayiDNOU9b
         rr7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785737379; x=1786342179;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wTJg/4nDP7MYTEpGxDNKe29PaMdaG90e8BuLEarpdo8=;
        b=CAW0dxvaKz8i4prxjDDvJXHUaS7hgoYuZlCL8Ilq1poiOp9WVPpJyz37XAwItFs4ux
         BhbW0UEExFdNXfiz73UDqwkJj9Z4ayFGASaYHr58V7gL+ScaTIsyaVJ1MrXi2TxjGzc3
         b7nqnlTcThj1ki1wgctE5T1XlARmN9Sz2Jywx6bBZIV5vU6o2YPcrKNG2SEDco6qE51D
         iP7b2gHy2YxUlinvCrHuoNLtuGJJbedYyycQpNtsdzN0qkADn2tVEeLCekWJ33z+Fulx
         fpwpYXQ54VPo/1PyH8kwQw+pJWzLmMGxxDZjV78ykb4K3/JiuWWDT211TrpZxy/HTdiY
         MObQ==
X-Forwarded-Encrypted: i=1; AHgh+RptCY3dl3paQrNBAWHrHne476Ep/5EidiDXesQIrTia0PRhyFClcB2lTqiQx77uJFQE7hsrRHI78PRu@vger.kernel.org
X-Gm-Message-State: AOJu0YwcOkPxAAWtYR7UodVoaPK1gZW/PMoAZWrFe2FkMpQHjj9IziIA
	EhCbCcLpuALbpumS6wjiGlZxk8Y1K9HdKPjKAAb5cb6oUWKSi0s/wQdE7zfGPOortzFFjOoQ0sk
	5O7153suPCJFHd/kI/Vn4wGir2+k0CUhGWJfUV4f4bA==
X-Gm-Gg: AR+sD11g+Blm7nxsemEKkOH8FEWRuwVdYD1wyMFC4xdB2NbK2mKf+WSS41SuPlcAgvW
	bhXslEmWusYptVo6kLKse4QVIFfqcgxJzAg5XDTAXj1almhrdsQvnj/3diK1e1l/unNI91ROu57
	wrOUrGg68MUP+jn68ZTeSy4cZ46LkFXq2do85L6gNCZoW8MrOq/11/q8YyNV8nvsd5nrkNjmkDB
	7QdFib5v/byjb5HrAHQ3ovYRdjiZ2aTI4ZdKfnqVtrFp4UxI2C4x5GtTAhk54TxSTtOabquWGVp
	vTCirdiFkGxcaoHBKpp6+1GMBPECEx0yOcekz2YI/ikkmGR30miZDhJ8FSUavGUWZHO0DpUW+Zd
	osA==
X-Received: by 2002:a17:906:f049:b0:c12:6db4:4bf4 with SMTP id
 a640c23a62f3a-c1fe7c6b920mr429176766b.0.1785737378619; Sun, 02 Aug 2026
 23:09:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785451174.git.bvanassche@acm.org> <6371196646d5f6222a6d8e55de2a351aa9caf967.1785451174.git.bvanassche@acm.org>
In-Reply-To: <6371196646d5f6222a6d8e55de2a351aa9caf967.1785451174.git.bvanassche@acm.org>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Mon, 3 Aug 2026 08:09:27 +0200
X-Gm-Features: AUfX_mwrtUIfoXSAnYTt282sOto0IZDEAfzQZNswn2XRV7G3kTEiF3LNQljkJqc
Message-ID: <CAMGffEmzMiFgtD2MxRqnu=36PbSR11wt7UBComgbOi-7m8k4SQ@mail.gmail.com>
Subject: Re: [PATCH v3 44/57] scsi: pm8001: Enable lock context analysis
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Marco Elver <elver@google.com>, 
	linux-scsi@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 31, 2026 at 12:48=E2=80=AFAM Bart Van Assche <bvanassche@acm.or=
g> wrote:
>
> Document locking requirements with __must_hold().
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/Makefile     | 1 +
>  drivers/scsi/pm8001/pm80xx_hwi.c | 2 ++
>  2 files changed, 3 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/Makefile b/drivers/scsi/pm8001/Makefile
> index bbb51b7312f1..b236359810fe 100644
> --- a/drivers/scsi/pm8001/Makefile
> +++ b/drivers/scsi/pm8001/Makefile
> @@ -4,6 +4,7 @@
>  #
>  # Copyright (C) 2008-2009  USI Co., Ltd.
>
> +CONTEXT_ANALYSIS :=3D y
>
>  obj-$(CONFIG_SCSI_PM8001) +=3D pm80xx.o
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
> index 7a348f0194bd..ff6fdb761a70 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -2294,6 +2294,7 @@ static void mpi_ssp_event(struct pm8001_hba_info *p=
m8001_ha, void *piomb)
>  static void
>  mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
>                 struct outbound_queue_table *circularQ, void *piomb)
> +       __must_hold(&circularQ->oq_lock)
>  {
>         struct sas_task *t;
>         struct pm8001_ccb_info *ccb;
> @@ -3858,6 +3859,7 @@ static int ssp_coalesced_comp_resp(struct pm8001_hb=
a_info *pm8001_ha,
>   */
>  static void process_one_iomb(struct pm8001_hba_info *pm8001_ha,
>                 struct outbound_queue_table *circularQ, void *piomb)
> +       __must_hold(&circularQ->oq_lock)
>  {
>         __le32 pHeader =3D *(__le32 *)piomb;
>         u32 opc =3D (u32)((le32_to_cpu(pHeader)) & 0xFFF);
