Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A9E2EB5B8
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 01:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791942737; cv=pass; b=blZJEI1m+8eXTkjF+ekHRJEAd1U+L3yMCnbFM8UMlSzf3SUkoaLlU7O5UnqdjxOOPWRsAQ8pIR6QNFBKdHlNX3BS7IH/AxcGUY/ic68ec6mTdIjrzT/IS1SkJX5VNxI+O10pnjqWy4NOuxZVDWrxRnLa6Zn8mbtju+WMmRjoBrg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791942737; c=relaxed/simple;
	bh=EEEjk9MG/UD4DoUmd+wnI9Y+tNbgFUHy0YlZniMZh2w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I2PK2EioNBszgZVaaHUpw6f/ehS/RXTWyU1KYjJehkLnpmyTJ42oEIvkiR+qBud2qbgBHlpTi68lG3oB/ah1Ijh7KbZooDZyk+6aPRXchILFZWo65c0VF4SNYCFsD63gwCieVImrxUn7AhXAvrS3u4NNY2Mkt7sGNUd/Js0ih1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a+IrdKFc; arc=pass smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a+IrdKFc"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c315729ad50so592344266b.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 18:52:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791942734; cv=none;
        d=google.com; s=arc-20260327;
        b=DZQu012YD2M1KpkkmIOPICIoMmZqTz12ooHUFl/PuR1sYUvFpBAgqZJmodai/60PUF
         qkcun0hP2JKg/NI9702XLfLbOq/0xs5XeyREx9rlEzwp0eGa7lIhG3lPzav33QsJmb8X
         0sVdNEH/VE7yJjszQg6wIIPZmljeigIGQaGr/r8E3wH78W/BfDRHBk9dhF+csE0TUaaD
         uuKnN83OqmkNbvIRsN7N7AsJXCE//CLY0UKvippA8e+MZOwNu1HW6D89mWRIfGm2RhbA
         QXLzj85cc5qudwc6bZvyM6mOiyDDhNQt5qZfNP/PSh/8GRankaNQQVY6JnkAWXrYzrYm
         OvDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rkMAgQXWZDAintSsYHcrTB6xg3LKmrPgJ6U+eSBtHvw=;
        fh=Rnt4aDFTYDKnjShSr4PBEiS1KqCx9a3e+zUrlMMesTM=;
        b=eFCqU5po6TmISoBAM9AagGkiuFsck6/w7TFOY1i1FccDb6bmIARdcu4pS2QiO48T07
         np0OR5dmaF+ifhN5hFLDJnGJpXknvKIcV33Zrly810EJLBLfAaYe56Cz5QTwvaG9HwsX
         knJ09QkJtV9HvnUzNHTFetK1Cg4u0dksjNd5EgBPUkijyoBcsoe1K43Bvu0ZemANjS9S
         WOnRy27mFgPTwjQBMOR0lqtsfP11Mje7yWyhJqn6PNA5hut2JHTbZQqlSW0AHoW117h7
         VvjAOOWRYbihhTPfsc8N7zV3dy6DJapWhyeeqMa7LhIktgf3plO76VwZ3UAMNLrEnm7+
         o4dA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791942734; x=1792547534; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rkMAgQXWZDAintSsYHcrTB6xg3LKmrPgJ6U+eSBtHvw=;
        b=a+IrdKFckll5Quc8wwwREWJPy1nJ9rUL24P5kOS2/pRT5YPq9VrdOiXwKLRi5U2AZZ
         Lihde6i7k8AfSChQg0lF0qb5hrti6IN4Glb1dWkEjvZq7WEofTwObW9BwDLCbOEv3HAL
         uPZ40H0K/EiD1oXSIIYJyCSlF94HJxrlGMS+wZRXygzrFMEZ7hjwAQmVcAUG+issr/eX
         CfnIBWjwX68YFSiufd/P89N8XYmGwzNVh0NWwygvkozDCAMg8bB9E9DfEJsiczhJpqez
         SaHO+SZ74YA/UOnx2e6RmHyCQIiC72uZ9jBqoH2X3N5AdoM68/n+Q5coPcM4AuVWRGr1
         1nqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791942734; x=1792547534;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rkMAgQXWZDAintSsYHcrTB6xg3LKmrPgJ6U+eSBtHvw=;
        b=CrUm1yOxobBZu+GE1cEu8hc5vjvKSr6FNMh2FJ2Z/qJZeyS1CKdWd7jDunmFImTq1l
         K/HzbiKjXCaS7b+qNbughLg8xDXHBqBlue/B5F8FGjNXAtstbB9lD+G7+O35pqHA7bWT
         4uX3oYncl7Mnb+YyazhTBGqx+HBh3yDW2Dm9v31xjf/jXGP4ruqQQyW74fvo9LZqJ3vE
         khm/17fhmiP2GFSr6+fhNdulat/gQQ8ZKy3YCivS8OvhPClpwZrbTcVjiWOmCAPERWI2
         0jLKbVZ3D/GTZNLvlDGCMqkWm17wjHy099G5y6x4mEW4VOXF1u3QLxS5eolLZeSvW5Lu
         MuWg==
X-Gm-Message-State: AFq9FYJVQNEEw/dZcuBWzGuPVnGyDf3rSvciGjJAQvPtDhCU5EnAtNjL
	yT9tLiu9vRHkhSnNIpMKiFPFxu5vhHzSM4BMokx5zpIJCij6oSK1eHWv081mSDr9/SPGpGoGJA2
	XNWzJkDdvMTMhqzWUsyMU+ILM1/+p/BTC7Qpd
X-Gm-Gg: AYBFou0L4M+8sKODolCfOXWuT1W0j64TzuRKzdOUDpvs9npp53EdplvQGuRj0IiTdd6
	ve9ZEaIe3FYaYrCCqLgxlazG1eFP/tsVlwJzKUQBCM3P+skmAOFnBU3t7ALJWhG1HnqNaANFV4n
	zMcLFUcl7D/f4uUaDggA1xJIzq44iY/i+Cx+LTRhUd9AgF9ZZNzh3KKpJ2NbO/pFV9v4QJA4udU
	CkjRH44JNKYPxQ4iiOziChgUaUasHRlh3NnyqTgLMEGWiVnrVtsR/NrFNPT5v2h9WynkxB6kWcU
	hbfo+VQ2BhSR4gKzVwgIzF6KqV6u/k1K9TvhQsULp3GZtanLddZqmQ0=
X-Received: by 2002:a17:907:1997:b0:c2d:c98f:4824 with SMTP id
 a640c23a62f3a-c31aa057064mr1319744266b.30.1791942734070; Tue, 13 Oct 2026
 18:52:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261013001648.62289-1-nkirkland2304@gmail.com>
In-Reply-To: <20261013001648.62289-1-nkirkland2304@gmail.com>
From: Nigel Kirkland <nkirkland2304@gmail.com>
Date: Tue, 13 Oct 2026 18:52:01 -0700
X-Gm-Features: AclHuK_lU9OuKIaZRG13SM5dD4JP-Z4_K0s7_Hbt20eVUQxydhIOG-qAa_bsT_Y
Message-ID: <CACnqm7-ksDgqLcZiDGkdcBqQ8czi20fvrA_7W6QdKX66z5_HCg@mail.gmail.com>
Subject: Re: [PATCH v6 0/8] lpfc: Update lpfc to revision 15.0.0.1
To: linux-scsi@vger.kernel.org, nigel.kirkland@broadcom.com
Cc: jsmart833426@gmail.com, paul.ely@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 12, 2026 at 4:53=E2=80=AFPM Nigel Kirkland <nkirkland2304@gmail=
.com> wrote:
>
> This patch set contains important bug fixes related to cleanup
> handling in both normal and error paths, and refactoring of
> duplicate code.
>

Regarding sashiko-bot findings for v6:
  - 1/8, The finding appears to be a false positive. There is no path that =
makes
            a request with command SLI_CTAS_DALLAPP_ID, so the command
            will not be seen in the completion path. We plan to remove the =
dead
            code in a future patch set.
  - Our analysis is that the 2/8, 3/8, 5/8 and 7/8 findings are
actually preexisting
     flaws. In fact many were called out as such in the v3 patch set.
We note many
     of the findings were not reported against intervening patch sets.
     Our plan is to address these in a future patch set.

This patch set contains important fixes that address real world crashes. In=
 some
cases the window is significantly narrowed, but a theoretical small
risk may remain.
The changes have undergone many months of extensive testing without issue.

> The patches were cut against Martin's 7.4/scsi-queue tree.
>
> Nigel Kirkland (8):
>   lpfc: Fix use-after-free in lpfc_cmpl_ct_cmd_vmid
>   lpfc: Early return out of lpfc_els_abort when HBA_SETUP flag is not
>     set
>   lpfc: Fix kernel oops when unmapping scsi dma buffers for an aborted
>     cmd
>   lpfc: Check fc4_xpt_flags before decrementing ndlp kref on FDISC error
>   lpfc: Rework I/O flush ordering when unloading driver
>   lpfc: Refactor calls on fc_disctmo to lpfc_set_disctmo in RSCN handler
>   lpfc: Update correct ndlp refcnt when rejecting an unsolicited PLOGI
>   lpfc: Update lpfc version to 15.0.0.1
>
> Changes since v5:
>   - Two patches have been dropped from the set pending analysis of
>     sashiko feedback. The patches will be resubmitted in a future
>     patch set after additional testing.
>   - Updated patch 4 to address sashiko comment.
>
> Changes since v4:
>   - 4 patches have been dropped from the set for review of sashiko
>     comment and soak testing of any necessary changes. The patches
>     will be resubmitted in a future patch set.
>   - Updated patch 6 to address sashiko comments.
>
>
>  drivers/scsi/lpfc/lpfc_ct.c        |  2 -
>  drivers/scsi/lpfc/lpfc_els.c       | 80 ++++++++++++++++++++----------
>  drivers/scsi/lpfc/lpfc_hbadisc.c   |  7 +++
>  drivers/scsi/lpfc/lpfc_init.c      | 16 +++++-
>  drivers/scsi/lpfc/lpfc_nportdisc.c | 30 ++++++++++-
>  drivers/scsi/lpfc/lpfc_sli.c       |  8 ++-
>  drivers/scsi/lpfc/lpfc_version.h   |  2 +-
>  7 files changed, 111 insertions(+), 34 deletions(-)
>
> --
> 2.38.0
>
