Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2ED7502AB;
	Fri, 12 Apr 2024 08:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712910461; cv=none; b=rmgWXbDA2jC9JEJOH3YEMyPw9yUoqOF6Kt9Xq5n1RaEf/wbzZ8E9iAPV1nJcjjGvkCFo2wdPTkvsMp/215/BgbWASfwWML51qMdafbv0AAsqQD3Z5lwZfKJE9c1EmzVlMw84oVJYbEmgQI+iYsac+6Av8I6cV18sJymDeIuEW7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712910461; c=relaxed/simple;
	bh=3Xop4E5zNWIXJwUPdfY7uI/WL139zi5c0x4Nj85Rp48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eSYu1uDJLwGJI5uLjGfcW95GOQYiLxbjVquBu82p2iV+n7NfVGffSHEePkgRezQt12NeqpbgkK/Ixji8Itd+6KQnVS9Sd4mSnqQJXN5/Ng9p0Mgu5WFNmGkxELeYnurWUVz0gRaxlrvZsZyC6a463ezRGno896cB0wxNIwy/pzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uABKaOSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uABKaOSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F3CC2BD11;
	Fri, 12 Apr 2024 08:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712910460;
	bh=3Xop4E5zNWIXJwUPdfY7uI/WL139zi5c0x4Nj85Rp48=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uABKaOSAg9pTsBI+KMOCL5UAak8ntwTd6oF8KNNF/+vNQDyoLihaM9gnHESYA5rP0
	 DJ63+socbJaVdwcAJvCy7NTPTArCVRb7DyDVRcPHUb9k12+Gh/rluIpyA1sEScjHky
	 vWFiOIZM1ELKVux451+64c4+9LqICdb6Q/RFbzKw=
Date: Fri, 12 Apr 2024 10:27:37 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Chris Rankin <rankincj@gmail.com>, linux-scsi@vger.kernel.org,
	Linux Stable <stable@vger.kernel.org>
Subject: Re: Fwd: [PATCH 6.8 000/143] 6.8.6-rc1 review
Message-ID: <2024041213-tarmac-wreckage-bfd3@gregkh>
References: <CAK2bqV+kpG5cm5py24TusikZYO=_vWg7CVEN3oTywVhnq1mhjQ@mail.gmail.com>
 <2024041125-surgery-pending-cd06@gregkh>
 <CAK2bqVJcsjZE8k87_xNU-mQ3xXm58eCFMdouSVEMkkT57wCQFg@mail.gmail.com>
 <CAK2bqV+d-ffQB_nHEnCcTp9mjHAq-LOb3WtaqXZK2Bk64UywNQ@mail.gmail.com>
 <yq1ttk8ks5f.fsf@ca-mkp.ca.oracle.com>
 <yq1a5lzjpx7.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1a5lzjpx7.fsf@ca-mkp.ca.oracle.com>

On Thu, Apr 11, 2024 at 10:09:40PM -0400, Martin K. Petersen wrote:
> 
> >>> scsi: sg: Avoid sg device teardown race
> >>> [ Upstream commit 27f58c04a8f438078583041468ec60597841284d ]
> >>
> >> I think I have hit this issue in 6.8.4. Is there a patch ready for
> >> this bug yet please?
> 
> Commit d4e655c49f47 ("scsi: sg: Avoid race in error handling & drop
> bogus warn") is now in Linus' tree and should be applied on top of all
> branches which contain a backport of upstream commit 27f58c04a8f4
> ("scsi: sg: Avoid sg device teardown race").

No stable branches or queues have that commit in it yet, so all should
be fine.

thanks,

greg k-h
