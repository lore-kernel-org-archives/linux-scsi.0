Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407AB156257
	for <linux-scsi@vger.kernel.org>; Mon, 16 Sep 2024 13:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726494921; cv=none; b=ndoaJ32QXSZehMm6/m44tEqY6CZNfSzkllM50ODpQWLwS6ioLWxAQ9/HkS1wHzVLiiAlWGa8qOjFkPg270sAQl84PkfOpexO+AQvfz8zHVPAG0TCRDqlSq+an/jichZ9thqqjpHmzDRNif1vaEaYjaruEPjXSxfv+Sh8Pc5eMPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726494921; c=relaxed/simple;
	bh=TQ9Z28VrXmhpoS/+5Enj8vZt41wK2AKLp3BMB68Uvjg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=az4HSJhyJq9cryEte83B0PziIa0RnP8UlDOvYjdM2VrL3y1V2WrVsHcyYl6KEjODPMKbdfE7ocJziuQlB6vVFAIMyH1ov/hUGAMEq5AXb4/984lr/p2t5xCf4ZbZ/nXqqRm0w7L/WyqgVnGGanzW+uljzQ5FPIpQaZmC4WWAQbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jdmvRJLs; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jdmvRJLs"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2f758f84dfbso35442931fa.0
        for <linux-scsi@vger.kernel.org>; Mon, 16 Sep 2024 06:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726494917; x=1727099717; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TnAR93o+K7zzH5nWKB/vrO+A6k82QdGsUv8h9VnrLk4=;
        b=jdmvRJLsJCJxVVKdgHF0DVDTx3zZE3kBbYdqDEZeTOdl4x+eK1MhPeTt3sGXGtxCLM
         jv9KHMZIiqD/9JCrUjruclHxsBQnjS2W66LerIe22dFe2qYQcQZe3zBYxWQeDjmaLuQM
         /7n7OsbySDH3MOjc3W0WzNJOBPeK/n74HhFnyyo0tIEYuUMtN1k9i/DTWIuZhAtasCe9
         KGr+41/+lVWziTSd/9QumbVt0c9UAH3/Sbzw92d179XG6jHONH9RUdvWWXGRAPH4E0Bz
         AmMv/1+z/HQ/dJLk0yZhFRv9SL+nvz09uUOxukbfGq1L8CaLZBhwQcJ/zh1wOLmeYtfa
         0jrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726494917; x=1727099717;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TnAR93o+K7zzH5nWKB/vrO+A6k82QdGsUv8h9VnrLk4=;
        b=nqntIE3jpUjy60VsAQ/iBdqHgsBwacFd//Fn6Cp6S2X56KyuSu7Jnfor9WbipqoU9O
         b/045l7FpPmS54NpDOQmH/SicqPPDLtCCU/3wYt2LhfC9oTVHOzVYxHmwKwIUuMj/d3G
         B1OAKj9Y+haX+1q7a8SmupoCXjbJup1jfN6NJw9IagqDVeP7YQoR88x5ikxXUjKQcOn2
         s1Buwjd7HXiIKZ2w0n/51ZhA294iUQQoklhdA+9QJIz9YBK09Qr4vmSVXYfnqZil/Ddc
         YtHF9vFTQVwFU/pRVLKxSh/3u4uLhKLoOux3XmIZis/sGnVY2aD+jDmfHHMPn0G9jDuv
         Dq1A==
X-Forwarded-Encrypted: i=1; AJvYcCWSK9/7dpIxYxJXmTIa9APK41esjD6wIQ5eXf/J+7oWoIDXOkdVVJkp4TmHLnyN2mA1B0IDUnHPexsK@vger.kernel.org
X-Gm-Message-State: AOJu0YxAIbIAJxWilmakBNx/BP3GXrBZJhWE2yLKRj4N3cmKI3Jdf2TL
	84xqByBi9Qy7ol3MlqzDli0xsdMv3f+/EcENo7B05RYqw206uR+13Ptxght2VEaLLE9xysrVDEN
	SPUftXKfBSFsaW1KN3Rssqrnucli3uS35hXOW
X-Google-Smtp-Source: AGHT+IESKzBfl8rPNdiysY8g7h5xJa5N0rTSdQ0+gs1+b7V0l+3gMcjbyAmed0AAQW8lIUuMnSOAF7oIevPTu4bOqwI=
X-Received: by 2002:a05:651c:b22:b0:2f7:65b0:ff28 with SMTP id
 38308e7fff4ca-2f787f5098dmr80304861fa.39.1726494916930; Mon, 16 Sep 2024
 06:55:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <00000000000039fb2d05f3c7d0ed@google.com> <8e13233a-2eb6-6d92-e94f-b94db8b518ed@acm.org>
 <CACT4Y+ZvEjpX8a9VW4tS1YSP8RE6xjb8C9ae6PcSa0rr-q+62g@mail.gmail.com> <da2d3fb8-b4b0-457a-80fa-a3eae5c8e1fc@acm.org>
In-Reply-To: <da2d3fb8-b4b0-457a-80fa-a3eae5c8e1fc@acm.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 16 Sep 2024 15:55:05 +0200
Message-ID: <CACT4Y+bmJAKw8J=oJgp5gh_-Tz1e-VkgtvKF4QFGcD-Ovffm8Q@mail.gmail.com>
Subject: Re: [syzbot] [ext4?] INFO: task hung in ext4_evict_ea_inode
To: Bart Van Assche <bvanassche@acm.org>
Cc: syzbot <syzbot+38e6635a03c83c76297a@syzkaller.appspotmail.com>, 
	adilger.kernel@dilger.ca, alim.akhtar@samsung.com, avri.altman@wdc.com, 
	beanhuo@micron.com, hdanton@sina.com, jejb@linux.ibm.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, martin.petersen@oracle.com, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu, 
	wsa+renesas@sang-engineering.com, syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Sept 2024 at 15:41, 'Bart Van Assche' via syzkaller
<syzkaller@googlegroups.com> wrote:
>
> On 9/16/24 6:28 AM, Dmitry Vyukov wrote:
> > On Fri, 3 Feb 2023 at 19:11, Bart Van Assche <bvanassche@acm.org> wrote:
> >>
> >> On 2/3/23 00:53, syzbot wrote:
> >>> syzbot has bisected this issue to:
> >>>
> >>> commit 82ede9c19839079e7953a47895729852a440080c
> >>> Author: Wolfram Sang <wsa+renesas@sang-engineering.com>
> >>> Date:   Tue Jun 21 14:46:53 2022 +0000
> >>>
> >>>       scsi: ufs: core: Fix typos in error messages
> >>
> >> To the syzbot maintainers: I think this is a good example of a bisection
> >> result that is wrong. It is unlikely that fixing typos in kernel
> >> messages would affect whether or not the kernel hangs. Additionally, as
> >> far as I know, the systems used by syzbot (Google Compute Engine virtual
> >> machines) do trigger any code in the UFS driver.
> >
> > Hi Bart,
> >
> > syzbot has logic to detect commits that don't affect builds.
> > It hashes SHF_ALLOC vmlinux sections to check if the commit actually
> > has any effect on the binary:
> > https://github.com/google/syzkaller/blob/c673ca06b23cea94091ab496ef62c3513e434585/pkg/build/linux.go#L253-L286
> >
> > Bug CONFIG_UFS_FS is enabled on syzbot, it has some coverage for it,
> > and strings affect the binary (can actually be the root cause for
> > bugs). So I don't see what else can be done here automatically.
>
> CONFIG_UFS_FS controls whether or not the UFS filesystem is enabled
> (fs/ufs/). The UFS driver is unrelated to the UFS filesystem and is
> controlled by CONFIG_SCSI_UFSHCD. Support for the UFS driver has been
> added recently in Qemu. Does that mean that it should be possible to
> test the UFS driver with syzbot? See also
> https://patchew.org/QEMU/20230616065816epcms2p82787f1aeb410ec4b8ab6ffedb6edf4d2@epcms2p8/

Oh, I see. Added this example to the issue:
https://github.com/google/syzkaller/issues/2297#issuecomment-2352986387

I've tried to follow all guidelines from reproducible builds:
https://docs.kernel.org/kbuild/reproducible-builds.html

https://github.com/google/syzkaller/blob/c673ca06b23cea94091ab496ef62c3513e434585/pkg/build/linux.go#L165-L176
https://github.com/google/syzkaller/blob/c673ca06b23cea94091ab496ef62c3513e434585/pkg/build/linux.go#L85-L102

Yet this commit still somehow affected the build:
culprit signature:
c1512384fd0e6d2bd48b3a1ce2034eb5c0de195562eca27cd2c0c6ac58cd4863
parent  signature:
1f86ef314029ed6e1f240aae874259f4bb0f7978f8b38b29d6c184b82965b331

I've debugged and fixed some of these non-determinism bugs, but it
seems something is still broken (not sure if it's the compiler, or
kbuild, or how we do deterministic build).
