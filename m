Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234C7C2E9
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 01:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719365982; cv=none; b=i+PFgkCgAt59scYm7lhermeS7mxZYPHFxYy+hm34x4JciHojm8+LKRcaaOP35CCEqIa7cWNoZskJpISanAMMIVfWe2qsVI6PaoGbPoGW6KURngOiU6FxWUj1nLX0sF0oFl1s3JojzsaL98VqgWCqxQxmtVrbtewvK3C2VpzJ3v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719365982; c=relaxed/simple;
	bh=FdNfVHadqwtRDM9CQwNFGEaKTy6lPpVpiQe4T6vU98Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 Cc:Content-Type; b=nOWMyzzG5bv5h2tetfjyrzcn4bqX/sV/0knicSBHn+WXn/TVLWideJeV3q2woAV0AFm2SE7o8TrQuJr7mxnSes24gIJd88yqtFTjT8EBt/CBR8VbeugY3RHrHgRhlsTWN/cu64ci/zp08nHrrDiTBNNjOiw1Wkbf/3s25TEnO4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CTIxRUWa; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CTIxRUWa"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-645808a3294so24558977b3.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2024 18:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719365980; x=1719970780; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FdNfVHadqwtRDM9CQwNFGEaKTy6lPpVpiQe4T6vU98Q=;
        b=CTIxRUWa1BIsrYu6n5Q6KKgZvdZ0dcPXcUPNMwGNX3tEuEGXFbS5DvLqnokd0Q8FbV
         PM43LTYInV9/4ZtzF9HYmD3pjLgAxOUjrRKTSsDWcBES6rEaWxTTOlpqhLKnbccHFved
         C1qcCliOugs7lYadki90UbVVGJfwQyrHBYKd2wWKf/GmVMWyV6UDc+cNlG1RL8tz8y/x
         sTAQ5CE90PYIXzA7rknhYaYLFTAaCQ1mwCq4faIGJGxHqMRMVGT12YEe1l4f1LuuyzFY
         9ju4g0LU53fvifjozqQVhg/iuAXwrAVK/k7cWPeaYIDRM6A47tESIdzDYYNHu3jsW5d8
         ZJDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719365980; x=1719970780;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FdNfVHadqwtRDM9CQwNFGEaKTy6lPpVpiQe4T6vU98Q=;
        b=a5y27HSpvlj+QJzHHF1guQkWbvfx1nPVl2uOi8akMxH+7rTUnb1Zd4hz27YRFZj6/7
         DTo+vSuSFrF8puAD/LsW5M555M/oyh7KZ1bQrf12im0YJIISoEfKePCKVVUSd6droGLT
         SvH2nQIcKerYVeqcwTH9tTtLvHD0jxaJplfdtLg2zD4u+loSiL8w/Yj3+pvvlyRIOT9i
         HmjWJ+D/3VgUmsrkx6m66hFkpvsFddaTNgnYvReIBdi2WkPNLWDg+bcpp/xlaWN4bSzP
         3v+LqvB1/PuO+ZpXMOSCGeJZi4X7XnpNzkgTsRU2yZzbV8IJZDvcoVdl/val5G1BST1q
         rkIg==
X-Gm-Message-State: AOJu0YzefTlTiPXPInI5A8HbChZS3c4lggjIlOH28B4s7+pRJ0V1TreK
	aSt8Gv6bkp8xyb06dazjksC/YVmns5+luqAGWvbYhCKm/LIh6IZm3zuqMm+Q6gm4eNynfphjCLv
	dZjbt38LtGncov8h7qmp9COGraytkxQ==
X-Google-Smtp-Source: AGHT+IFizDViR1ncMaZrWaL0heqd8cvPQAmCJ46qehP3jLRAhvRvV+yic0jQY8lYHr2gr1JEDcSNcMhsStZj2rlYySs=
X-Received: by 2002:a81:8a42:0:b0:625:1090:b54f with SMTP id
 00721157ae682-64340ea9a6cmr83060727b3.39.1719365979897; Tue, 25 Jun 2024
 18:39:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240625165643.1310399-1-prabhakar.pujeri@gmail.com>
 <1ac9f910-c361-44eb-9fa8-d587a8796980@acm.org> <CAB=RiWAJyrywUhYo9yQ_qbaiokf_HnJkRmLHCQw5f61Fn4m5Bg@mail.gmail.com>
In-Reply-To: <CAB=RiWAJyrywUhYo9yQ_qbaiokf_HnJkRmLHCQw5f61Fn4m5Bg@mail.gmail.com>
From: prabhakar pujeri <prabhakar.pujeri@gmail.com>
Date: Wed, 26 Jun 2024 07:09:04 +0530
Message-ID: <CAB=RiWBsDbcpQooWFOqRXSNNfinRxAgkeLncTu8AH0HJ86X3JQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Simplify minimum value calculations in
 lpfc_init and lpfc_nvme
Cc: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> On Wed, Jun 26, 2024 at 4:57=E2=80=AFAM Bart Van Assche <bvanassche@acm.o=
rg> wrote:
>
> On 6/25/24 9:56 AM, Prabhakar Pujeri wrote:
> > This patch simplifies the calculation of minimum values in the
> > lpfc_sli4_driver_resource_setup and lpfc_nvme_prep_io_cmd functions
> > by using the min macro. This change improves code readability and
> > maintainability.
>
> How has this patch been generated? If it has been generated with a
> Coccinelle script, please include that script in the patch description.
>
> Bart.

 Yes, I am using Coccinelle for these patches. I will include the
Coccinelle scripts in my upcoming patches.
