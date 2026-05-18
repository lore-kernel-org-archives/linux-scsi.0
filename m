Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C3932143D
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 23:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779146586; cv=pass; b=aCXWpfRtO8SGkhixL23V5fXzsN5jlKNr7Q+oKTVlwoY+nL8XKyFZ/t/S/6hTV6y7W2oi+tYYix96TnuRbfEbw8wm986BJmLbpmunCnkQTm9nxAehGBGPOsbkLrA6haPOq8y7mGAlQjB2lo95VyaUls2adJl5c2Z9JrkaCAcRWkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779146586; c=relaxed/simple;
	bh=fHv9nb6iULfu1kpZZZ3/tja1IfLrDwnxvWfhWvPh78Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fs5LKiUUm4jDSLfstyemNivImjH2XCa8dNUJ2BxwiU0PNWYmG+3ZvXYzmPHn0XuMZCdIhlpQQfZaFUOaUej3M5rGmbEdvAGQH/711MalXS0bSrwCiPXpYNXroSx227aw7Oa+etXcHAJwTdT/rOxoeYCsXAh+nxOaIbdCMG0vZ/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=def7eKdt; arc=pass smtp.client-ip=74.125.224.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="def7eKdt"
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-65890a6ca20so3244380d50.0
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 16:23:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779146584; cv=none;
        d=google.com; s=arc-20240605;
        b=XiQAw1wmuwrAynaAiNVUUiTkxLP8D/yQybSLqdrfgLeB9agSXT62AvGceL2tBfQ+io
         6ncKW6cI+AmAoBQqIqv71qpjxuO+K9dFYqe8NkQQqi25TbfEKB7hv1jnn2y4iCZ22FYj
         69bO0k4pTY6ltruC/gpHqf0zfMf0RRzrJKAYyVsQk/pA9hB7RDbIbiS2kCatLJ25vS3H
         pe6IkotcT1uPWMnYXunTW9f/jmJY85rjNyI2bKQBtKWjvgBnzj4QIVgz3XaJH7L9Cj9O
         iADBGDx1IIqiuBrkueUnHDdojfnxGcPMvEau9dmtxiRK7hxt+7/Bqwv4HNOZY71P66pZ
         TvLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=whXJS7vOoJNpViQnsykoSQi+3tpMsWSRBjO6ajJAbGg=;
        fh=foS8qn2KhgR4jM/wfDCv1YsoC8gabI2/J53ePlGS+Rk=;
        b=KN6YX3vxRs5aK6FpVXNh+ZqvhiNHDBSbL+iy/8K0ea6BrE8S2pq39fKlhwwLxiLI9y
         hCSH0WYSXu0sEbDdX9L4cfHNLAYOjKlmLzEysFDqIQxdsZNNU++VyMVDkx8j50kC3prb
         udctTftBEBtNxBceiQ7ToQfqbxoU3NKCdQQpQKDZ0i7Aa9VPeJsYAHWeUYChtnHpYRjq
         uuoQa5ZjRzGy4JVScI6NrtklIfJytB2bc97XxN3V78hFqEWWV2PFV9OdCZf0mf1ufVXl
         JWEqtrBl9pEjD/BWPPMaoV2FyFpVovjXla1az0du3DVzt/bwrT5Wvxl99lQfq1z0LXlF
         IB2Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1779146584; x=1779751384; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=whXJS7vOoJNpViQnsykoSQi+3tpMsWSRBjO6ajJAbGg=;
        b=def7eKdt7Gh7glxtnfZ5Cc1HaYw8eiAWU8bfVnk5d6ZAsUrqUQSPqITUziDA/mY+vS
         SmbYiPdc4t5+XZS+bN9qi/CV+hmCsbLTmBeiTQhzZTrZnh4vpd1254IJNtHaPyeYitj5
         G9vJGq411pvSeSu1mDYYKr6ur3Cnm+zSnMDZ9IVjTyl7i+gi9ewY3/z0HxnCcoBq/HSg
         uDEIqOed4Z4por91il98FIJmP5mVAe4UdIMNBlf5k61azk7buH9Gmj+g6XYnmPg3nPcT
         Kz9dFqhR9sXmr0R7y1AAd6/Hj0qc55PZIKvDkiVNDZ4SA0sZBVdtNceImG03ZyU9m7AE
         Cl2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779146584; x=1779751384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=whXJS7vOoJNpViQnsykoSQi+3tpMsWSRBjO6ajJAbGg=;
        b=papHekJpVE1wsBKyQ++/eRFQc8qVhILVk7sPBQ3YDtQZP/8ouDlLD/LvKnHIc6gxyf
         S9lB6IchQj/rC/ZcYulVU1z/QGkfhoPB7OT3WpRVSRPgwc2NS/SUJbcGl+DZZ29aSr+j
         ZbIR/Dv4sHi4Ej2DNEY28xq0gpgn5oOrP/AEGzQ1DVtkdDBUa1neB5xafRGTZRSGGwlY
         Vxfl3dywm85y79LqWbTE6rOSzd2dWH8QIWatxihZOBQLS9jhlIxHLcCLrmQ9zR9oRrIT
         V/mQXVcaeelRbN8qdVQlmzw0FRWzVEWKUICGV8XFT6LrexOiTf2QHhNn8M1zE9rno+w8
         oqwA==
X-Forwarded-Encrypted: i=1; AFNElJ/aNX+STf/SSndKaj5lKJ/SWJ6Cwv+bkGGRx+sN13VgY5NmdjYoAN2QqV8gUq03j5iEzuG3kBzF8aB/@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6csMFn93UYHRikechjGxKfAVXSgkobYcVhWvsYoR3FK6ZaeWs
	xRJDjI2JiFRpjnw0j+8SYSo5jF9GkLCiOHwKFaf4T8nhXeKpOnCCkc+ofSZnGspoHMOB8J92Hol
	omBI1oAE3fLW8KDGzm4IVXMpW2aax1T9mEThtH1asyQ==
X-Gm-Gg: Acq92OHtaBLkHk/KS9QyIEDllZjvqRr1CVNDkbcBEGY6/lGhlnzJ5qM7xRzHw4PYT8U
	3RGq4TOU5ZBA56+gg3IlvtOJmQLnuJp5usK1kABkEy8XEKpclceP3NXHfOK+M1brXdfuKFScLCX
	ePPuSTMHaTKfMU3XMyMe3XcFJgzlk21eEim1DXP6PCNWyBTnIuahIICbrvRctrTgQTvAWyoHdBU
	Z9jN444ZNipbgQKFauWSfLRpE7IcDlwX9UaFctHsC6bCom/bmGEeeMd0QGSq+ZZIzCHhon6ekGb
	oc+UQM5Y28bPM5rhysjo
X-Received: by 2002:a05:690e:d4c:b0:651:bacc:77c with SMTP id
 956f58d0204a3-65e227046a4mr14553366d50.26.1779146584210; Mon, 18 May 2026
 16:23:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260515135946.2238888-1-vineeth@bitbyteword.org>
 <9fde73e7-0108-48d7-a1a0-ccc9776beb5c@acm.org> <20260515145048.1c021bc9@gandalf.local.home>
 <ebdc020e-419d-458a-9211-36f22af0c1d9@acm.org>
In-Reply-To: <ebdc020e-419d-458a-9211-36f22af0c1d9@acm.org>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Mon, 18 May 2026 19:22:53 -0400
X-Gm-Features: AVHnY4J2BTXARqZMS-S-7ea43B88qOe7-XZuDC_7_fnPjVKwEJzab2MdP2OY_Cg
Message-ID: <CAO7JXPhMTKpC_8e-C8M13wdqrC3Re6Ad_DqkzGjKrVuH8YNh8g@mail.gmail.com>
Subject: Re: [PATCH v3 08/11] scsi: ufs: Use trace_call__##name() at guarded
 tracepoint call sites
To: Bart Van Assche <bvanassche@acm.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2026 at 3:22=E2=80=AFPM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> On 5/15/26 11:50 AM, Steven Rostedt wrote:
> > On Fri, 15 May 2026 08:27:27 -0700
> > Bart Van Assche <bvanassche@acm.org> wrote:
> >
> >> On 5/15/26 6:59 AM, Vineeth Pillai (Google) wrote:
> >>>    static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba,
> >>> @@ -432,8 +432,8 @@ static void ufshcd_add_query_upiu_trace(struct uf=
s_hba *hba,
> >>>     if (!trace_ufshcd_upiu_enabled())
> >>>             return;
> >>>
> >>> -   trace_ufshcd_upiu(hba, str_t, &rq_rsp->header,
> >>> -                     &rq_rsp->qr, UFS_TSF_OSF);
> >>> +   trace_call__ufshcd_upiu(hba, str_t, &rq_rsp->header,
> >>> +                          &rq_rsp->qr, UFS_TSF_OSF);
> >>>    }
> >>
> >> Instead of making this change, please remove the
> >> trace_ufshcd_upiu_enabled() call because it is redundant.
> >
> > You mean to remove the ufshcd_add_query_upiu_trace() function and just =
use
> > a tracepoint where it is called?
>
> That would be even better.
>
Will do.

> >>>    static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned=
 int tag,
> >>> @@ -445,15 +445,15 @@ static void ufshcd_add_tm_upiu_trace(struct ufs=
_hba *hba, unsigned int tag,
> >>>             return;
> >>>
> >>>     if (str_t =3D=3D UFS_TM_SEND)
> >>> -           trace_ufshcd_upiu(hba, str_t,
> >>> -                             &descp->upiu_req.req_header,
> >>> -                             &descp->upiu_req.input_param1,
> >>> -                             UFS_TSF_TM_INPUT);
> >>> +           trace_call__ufshcd_upiu(hba, str_t,
> >>> +                                   &descp->upiu_req.req_header,
> >>> +                                   &descp->upiu_req.input_param1,
> >>> +                                   UFS_TSF_TM_INPUT);
> >>>     else
> >>> -           trace_ufshcd_upiu(hba, str_t,
> >>> -                             &descp->upiu_rsp.rsp_header,
> >>> -                             &descp->upiu_rsp.output_param1,
> >>> -                             UFS_TSF_TM_OUTPUT);
> >>> +           trace_call__ufshcd_upiu(hba, str_t,
> >>> +                                   &descp->upiu_rsp.rsp_header,
> >>> +                                   &descp->upiu_rsp.output_param1,
> >>> +                                   UFS_TSF_TM_OUTPUT);
> >>>    }
> >>
> >> Same comment here: I think it would be better to remove the
> >> trace_ufshcd_upiu_enabled() call rather than
> >> changing trace_ufshcd_upiu() into trace_call__ufshcd_upiu().
> >
> > Well, removing it here would mean placing the if (str =3D=3D UFS_TM_SEN=
D) into
> > the code and processing it even when tracing is disabled. With the
> > trace_*_enabled() helper, it's all a nop.
>
> The ufshcd_add_tm_upiu_trace() function is only called from the UFS
> error handler and hence is not performance sensitive. The execution of
> an additional if-test in this function is not a concern at all.
>
Sure, I shall change this.

Thanks,
Vineeth
