Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0069C30CDBC
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 05:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790229250; cv=none; b=Aho1HZsFXXtBLIh1vKvtm/9TLMoVNwqiaHmLmWxZLNlxdTLQQKrHgHkWwxp+Yc2DVLJ7+FzZj0gv70c8LeZB9WXZMjWRb0VWwlzaB3n143GneufYdwI4dDk86PUT0pyUSVen6LTBmNL7ZkdNrle8kGR1MNsCvM7QRPswvA6iOWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790229250; c=relaxed/simple;
	bh=N667sl3uu0XEGSwOTIsVXnLMvFAx9txmOGmTEjqW64o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sP+tWKjTLMeLYDILQzz60Z0Jd0Fo1r7QGq0REr9l11xC7Ck0hzLuRHmNtX+sN78sau9fgnHex86vseIl4CBrru3C1NrfixHmtXnV59BXRMBmG+s3p509BdY0j6Y2vFJFfXfoTMfMLAfP38hzSEqF1L7A8Pyt1knIAfmsifO7Da0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ke7vz6zV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ke7vz6zV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783651F000FF;
	Thu, 24 Sep 2026 05:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790229248;
	bh=f6ds/GHbKvkNR86HgvkNp9T2noO1CJ3B0ULjUQ7S5Sc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ke7vz6zVfb6Ob+APHO7eLcduYT/9++GjKCEx4wZCest5m6AJW6nccdm7JkOf3101M
	 bx4kT/eP5MLVIg36lTKF1Z9OJKZ0DGl61iQQmPqPcuMEp5AUzxfjys6FJi7yrpG7xc
	 ko1n1skJXOgBcFBduwZIYN6HUHY009WpYe+QfFL42luH0ESYXa1JpGFbbedq9s/hrN
	 IU7L2TcVYlHmWd/3hNz4kWOln/mhgU6eUv2mgrZ2jf5OnWwVmBxwl9H6O4/oep/n1Z
	 FFqmlkJQz4hXjSBVbAOHVEaT8eNrmGpi07GlYhlHRvhCgTOFOugCgn34RI/KRP9bx/
	 Zy2qWLkiiwo4A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: sg: finish request on error in sg_read()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hui Peng" <benquike@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260924054625.2282544-1-benquike@gmail.com>
References: <69218179-d750-4880-8be0-2ccab7d76a6d@linux.dev>
 <20260924054625.2282544-1-benquike@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 05:54:07 +0000
Message-Id: <20260924055408.783651F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] sg: compilation error due to undefined label free_old_hdr
--

commit 016a191c362e931770f582b73bf2ede9e57bbb56
Author: Hui Peng <benquike@gmail.com>

scsi: sg: finish request on error in sg_read()

This commit modifies sg_read() to ensure that orphaned requests are properly
finished and removed when an error occurs. It does this by introducing a new
label to call the necessary cleanup functions before returning.

> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 3f9e08725602c..581419e1695fc 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
[ ... ]
> @@ -543,10 +545,10 @@ sg_read(struct file *filp, char __user *buf, size_t=
 count, loff_t * ppos)
>  		}
>  	} else
>  		count =3D (old_hdr->result =3D=3D 0) ? 0 : -EIO;
> +	retval =3D count;
> +finish_req:
>  	sg_finish_rem_req(srp);
>  	sg_remove_request(sfp, srp);
> -	retval =3D count;
> -free_old_hdr:

[Severity: Low]
Because the free_old_hdr label is removed here, does this cause a
"label used but not defined" compilation error in sg_read()?

The error paths earlier in the function still try to jump to this deleted
label upon copy_to_user() failure and sg_read_oxfer() failure:

    if (copy_to_user(buf, old_hdr, SZ_SG_HEADER)) {
        retval =3D -EFAULT;
        goto free_old_hdr;
    }
    ...
    if (sg_read_oxfer(srp, buf, count - SZ_SG_HEADER)) {
        retval =3D -EFAULT;
        goto free_old_hdr;
    }

Should those goto statements be updated to jump to finish_req instead?

>  	kfree(old_hdr);
>  	return retval;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924054625.2282=
544-1-benquike@gmail.com?part=3D1
