Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794686762;
	b=UtO5JDFs3UG+CRqCSmhYuoQUPsChknR4LeSWFbD1d1HvNar/hc0kZlMQbpV3iLJvXQCr
	 FyY9BqixIdfNLAhBLdxCPPcRYY0eEaZZyL4Vop25sNRT8lwoHKM3z7ECTFSxtDl19gR6A
	 hlAOU66KNLwHeb66JWmvoM0huAgWahoY8dJJQdLsPLNLCp7XkajBlGvoyuvNTHiuvrsCm
	 jFiPB4cNTevrV508a/heXwHUNYuTyj17FRV/bitTmhvEZK6zD4kyIDmYlfbAmOIknGAWb
	 GGPftRoETY7tkhk18sMaLjwCvuJdqtd8m0ONYyKaY2zQpJDILgvoS23aLuvq98tkdWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794686762;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=L9fh6nGpkdQ3PKE1Pv6VuACg3WWhS00/MicQv00SggM=;
	b=Kb4FgfWVq1PYd+5vNLLN+GbOvR5FsJqnUvjHgbQ3Op8JuNo/iZxJ4cayoijlKeKxw7S8
	 Q0gN0jJ/KTDl2H0UTdnL37SpeeQy6ypaWRxJp2PF3DbBYCEnzWxZGB1HfFpgwEitEYShi
	 pVojUSDFZu413mrXQU7HkF3//PDaCJYb2d9vZNIcv3VPJveCCvfCwkCctwul9gEnT17WD
	 4l4V9XzTfj1whf9d+PH/voSByGyhlBuJcbIkzLGaJb/DlMeMkE8B+WT+KUdzvkV6ZKVBY
	 2EBUPcj1XS3Akn4b/wNEuY/0gGIkgtvPFvv7/LjNJgtKexvehYWCD/GUfMrwLBHHbEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=WyNKKpAN;
	arc=none smtp.remote-ip=209.85.215.169
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D9C60A380C
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 20:06:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2D9C60A380C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=WyNKKpAN
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cddc597d062so1621216a12.3
        for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 12:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686761; x=1795291561; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L9fh6nGpkdQ3PKE1Pv6VuACg3WWhS00/MicQv00SggM=;
        b=WyNKKpANsG5sdrHWGAt+Y38DvSIGt+WnCUyNYCZoBM4YbSq3wCVAHI95jQ8BFTGgLn
         +vM7af/q0i5zrzjZXXnriwzXN4L/RbeBg/iztvO0eyeIXYNiQp/OYlS5LD9yZqr2gKgm
         1I+5A88e/cV4J0nLZfgp0f7sQwj9jY0Q4quBE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686761; x=1795291561;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L9fh6nGpkdQ3PKE1Pv6VuACg3WWhS00/MicQv00SggM=;
        b=JfEUzB2GJyJrlKyYUOCVsUyUarIritQtOjivJ8vO7uwKKqgvhjdEbb2t+t58wgIsMb
         Anly9ugEi0E2sVxrhBKTG8bzvxeNyrWVuGdkwgiB2UWi5RvF+/0Nyuj2dGxWWW5MSbrr
         9+snhJtc2WIfPRQzjpg2tEEp6OttBs078OKQ1b01Oe/yDRB7xBCrTBAaTxMftcme5Q6u
         ++gP4tcUHeuS/aQ462DtsOSuip1akkrvk/kRjqkyqCHCR1frjtF0adfVeZFuycQhPbEg
         qxDY/NdOoBuqiYDnx91FBDWogwnw/Ji7Tyw8gP8DB7ujM84EVFykxRLffTqKnfanI7l6
         DfhQ==
X-Forwarded-Encrypted: i=1; AL+hErFecYieP5oo8Fg8qjBc69Kz4UWoMQbr0TTxzHIMKupxbZ91ESpO+D9MDSdp3X6OFZMeiT4i+EAGn2L1@vger.kernel.org
X-Gm-Message-State: APuU4Z81qjf6M6Eg1M0WlsAr0mjBiTW+I7iHUSLgz1m4mAOsvRSp+8FZ
	roqIqMxzyBQMJp0lOd9mH1aipWUoF+EWpinke8H5Qm4Y4UgEBxe2485tx10D9oO8Hyk=
X-Gm-Gg: AYBFou1E1gLPKwizNJbr7mwNtAtxV6uBNiz+a8cg81rHa9jwm3nqTURIBQfU8zrCWgL
	A9RsTXNurb2F2UwRO1HqbEuDUwuSKAQDOrpTVQ1vDs0IEp/vTTP1SPV3qn+9tBYffAmHUZPzd6j
	frGj6vr/30VIGWNiPSejx933jPslSHq+Q1JCjvUSgvrm0lhLaYKVOdJXAW+C+0JUJM7OKoPUTr/
	+vdgVDDc+0lzGoyMYIZnOqlOcCbjLpKJgdOw5r9cBgMHCfWH3osXb/MdPNvBoDWbMg2UYw/oe0b
	52SIHZz4qgzKyz0Q9q5ZCqRXjpnKHNPiOQ6Kzn0J4dhCnRl/RJmGW3GrDatxIhr0EGMVx+8uVjV
	AdghPabSGgQEoXCrroOLjLX2mMsTBei1pYKfd2QTpE18dm0/9crrk+nbb5SZa2solBv8amsn7GN
	kMRX4ZzADDoy3CIz74aU99uvLWx7jklru8ofqT5+4ZE0UKRF/rlY55obq4TgQaD09n5OAdSiQHt
	3QF366TBASsUmVGyI5Hxd25DZ0P6YAyNzRGl/qwcTGXtYyxgdDWsUbDTK8F0wOPZBsSldQEDTaJ
	daurkdM4SdssVKagHOEnUvZsYgDVBS981LolRWDQ57dTNKkVGpvt93/cLYvdsTy0HzlR9vRnVjj
	cf4MC7G736zYLKD9uWJc4s3VIjeWWwuo9aIIua9yjlur11wjMti7GfIywbBm+X51hWmhXg8k70b
	fHFpYVHWUTS8fdvuq1Wd/9vvEpfAbP1TFCgSyb9wm0mBXK66RiPJ+cBDHq
X-Received: by 2002:a17:90b:2584:b0:3ac:9f00:3bc7 with SMTP id 98e67ed59e1d1-3b1b0ba61famr5629200a91.33.1794686761104;
        Sat, 14 Nov 2026 12:06:01 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b1e9ef15sm5258887a91.0.2026.11.14.12.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 12:06:00 -0800 (PST)
Date: Sat, 14 Nov 2026 12:05:57 -0800
From: Chris Down <chris@chrisdown.name>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC v2 33/42] fs: add file_check_backing()
In-Reply-To: <20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
	<20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114120557.4bc1eb6e57218cdc@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Christian,

Christian Brauner writes:
>+	/* Look through stacking filesystems at the inode with the data. */
>+	if (d_real_inode(file->f_path.dentry)->i_sb->s_iflags & SB_I_PSEUDO)
>+		return -EINVAL;

This looks good in general, but what the bots said about O_PATH files
here is real. With FMODE_PATH this is reached for a file that was never
opened, so on overlayfs nothing has been through ovl_open() to look up
the lowerdata of a metacopy file yet. ovl_d_real() then does the lookup
itself, and when that fails it hits the WARN(1) at its end and returns
the overlayfs dentry, so the check passes as well.

Only fuse passes FMODE_PATH, so it takes CAP_SYS_ADMIN to get there, but
it's easy to trigger with that. From a quick test with a metacopy file
whose redirect into a data-only layer points at nothing, registering an
O_PATH fd of it with FUSE_DEV_IOC_BACKING_OPEN gives

     ovl_d_real(/f, 0): real dentry not found
     WARNING: fs/overlayfs/super.c:79 at ovl_d_real+0xc9/0x210
     [...]
      file_check_backing+0x308/0x5e0
      fuse_backing_new+0x219/0x4a0
      fuse_backing_open+0xe8/0x390
      fuse_dev_ioctl+0x53a/0x7d0

and the ioctl still succeeds. A normal open of that file fails with
ENOENT, so nothing could have used it as a backing file anyway, but with
panic_on_warn this is now a panic.

Maybe ovl_d_real() should just stop warning when the lookup fails, now
that it has a caller that isn't trace_uprobe? The check would still pass
for an O_PATH file whose lowerdata couldn't be looked up at that point,
though.

Thanks!

Chris
