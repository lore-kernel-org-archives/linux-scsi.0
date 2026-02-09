Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B600238F223
	for <linux-scsi@vger.kernel.org>; Mon,  9 Feb 2026 19:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770665514; cv=none; b=qoOFDHDNkkgxiEJlWh8igrilTCD7gllBGsD33C6IrIdXWKaJnN2wToKAGnmfQDHWB7FZfsEQgaw0XlWoNdPd3eodSG6jf5ITRTN3yplEKp8TKM0KVXRZ6i5+qqvZJaJPP/mmKPoh2CILdHYMwEE/ycLw4bHST4lcvINifNtLhIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770665514; c=relaxed/simple;
	bh=NMMjrph8bNLMAw02ZraHdiK+pEZZUMZxT3K+AuWZRZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IIHNLmH1W0WR9t4nzkSp1qn4qQu9Iv+HGy5qskhLrCKqz4xNw2ioKviSNby0ITocW8qCC+OoMNPLOpNr31xFBW4nbcfpSsCaZtghDRxCuCHxkb34azjtkYjEkGKDdX2WxhZ1/nT1hVZvgMlQUYCP5Wz3Xl5q7c0Lhzr3PzOAqFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lr4QbNsG; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lr4QbNsG"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2aad8123335so10505ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Feb 2026 11:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770665514; x=1771270314; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L9rHFvDcYDJ5I2XeyKJgfwKYtF6xJ5jOPGzWKqUMlyY=;
        b=lr4QbNsGLRm9OYgccT+9NZAIwNtZbD/VWJ0t4X/j7Ter4ZV2JLaWMa2b1ccXZZr8Iw
         a41XBf+g5opQSgW2AIba3h1O3A4Iu1Z4990I96glDlpi2lDuA1c46GBfZniTgjEW2Gp6
         febFoFpul8se0HjpAKLaylfDzf+b/Z31sUWWSMdrarmVe0zVxL8rC7dI3vQxv1G551wf
         PgNwOHBZcHWgAErYiUZmRddipCo/sECt7njm7Th3XPOC89BXruZNVSyDDNHTwzBcHxI/
         4VunwDr6WQf7tb+AaNzCP1CgYuPUsmGzxcTmb4e/mCuw6qPvWwiZaOJzv432nwBR8umY
         LX2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770665514; x=1771270314;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L9rHFvDcYDJ5I2XeyKJgfwKYtF6xJ5jOPGzWKqUMlyY=;
        b=hUKTq0pN7/gpFgiUCNg2in+Bp+vMySpQgpKW0KZ3i8NSo/rLXXYGxAtO4a13UBgMuk
         7bE8vQJTDBztDblrJfeMwO2juIrTjeARsGyK9iALREypxSvNbnQqz1mIgvPyU9z2rC0o
         W5vlGCHpJZsc2t+n+k2kWVZv+YM56d+lb13fIK3yIbdBSmXUhtFMN5TI3olgZNUt4j3o
         OnmoEi9Da8aQZefPgkpuMURfJyWyJJZwbzxmEWJu/8Y7lAKbc78Dh+XGmZ6/BcTxuFlJ
         N4pOh3rvf1bArMEkRoYGawsFJvSZcc3oxWg4Yv0ozFZv/bOozw4vFzyHufH7QoAq9Uns
         KEag==
X-Forwarded-Encrypted: i=1; AJvYcCUT1ZtONi2NeiOKsIyov69btAbPb9u1RawQbsAzTz+LyGK46aNq+ZoZ0UwD1yjODxGQIilTWHfCXOzw@vger.kernel.org
X-Gm-Message-State: AOJu0YyRMt4WtAy4sgHw0U1Tf2iDzZ36N/ExJO/E+Sqg+PblinrrDR8h
	ytbUkd9qzql20FppSrdhq0IdDCFltMZ271R22VCn22RBX5QumxNbSmk1l0ZPRaGnpWB8Unqh+2r
	U2hQfwA==
X-Gm-Gg: AZuq6aI4Ay7DriSCsL9lfwNoOLGnQ19Oel6sZf5GmoMc185uJWDGm5LeqezX5cfcPR5
	dWck4cop8ajUjOWCJp3gfIIRFMvdeiOjq/FACEtV5r3xzes2G19AlOV8/tg9OljNDpA+ttaEndG
	qTF36P3ueP4wBsbt1jA2Y/UZuo2DMy4k8EhIRD4+HNJNOjWwyuU/3Y3MC52N1MsVNPIfp/elGwN
	VBWTBQiBGjI+8gV4UK0ELmb2kbMVf5dE7O0XIfwLVizOSUjZRJ+qXcQt6rhRpHfJts8an7xk3v/
	/ssxjVSXcTLx+yltHlTdw+HEuk3qv7FB6q8hpD1tI1ZthoqLGuBCNDFy1LzJ5uAdbaEEyOlBX4d
	5lhd7CnY6NkDStB84jXbpr8DAFLiYdkrVLh8hSPWZav9vFlqU3pyschOdAGylZl6pJJLjH/Scb9
	PYUrQYwYsodR3iA8MEv3mI3Id22o8gWjTzszwQOFlgVQ4hlil3og==
X-Received: by 2002:a17:902:7c93:b0:271:9873:80d9 with SMTP id d9443c01a7336-2ab0ea1940dmr290255ad.7.1770665513647;
        Mon, 09 Feb 2026 11:31:53 -0800 (PST)
Received: from google.com (185.29.127.34.bc.googleusercontent.com. [34.127.29.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a951ca59f4sm112387565ad.43.2026.02.09.11.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 11:31:53 -0800 (PST)
Date: Mon, 9 Feb 2026 11:31:48 -0800
From: Igor Pylypiv <ipylypiv@google.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v2] scsi: core: Add 'serial' sysfs attribute for
 SCSI/SATA
Message-ID: <aYo2JBW76jH44lAU@google.com>
References: <20260205180015.2215143-1-ipylypiv@google.com>
 <430f606d-9305-41d9-9a49-b9ab6894cd61@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <430f606d-9305-41d9-9a49-b9ab6894cd61@acm.org>

On Mon, Feb 09, 2026 at 09:31:39AM -0800, Bart Van Assche wrote:
> On 2/5/26 10:00 AM, Igor Pylypiv wrote:
> > +	return sysfs_emit(buf, "%s\n", buf);
> 
> Since many snprintf() variants do not allow to specify the output buffer as
> input argument, the above seems risky to me. Has it been considered to
> replace the above statement with the following?
> 
> 	return sysfs_emit_at(buf, strlen(buf), "\n");

Thank you for pointing this out, Bart! I've now realized that you
pointed out this in V1 as well but I misunderstood your comment.

sysfs_emit_at() returns number of characters written starting at &buf[at]
so it would return 1 for the added newline. We can add the number of
characters written by scsi_vpd_lun_serial() to return the correct number
of characters:

	return ret + sysfs_emit_at(buf, ret, "\n");

This looks a bit too complicated/ugly to me. Instead, I will put a newline
manually and return the correct number of characters. PAGE_SIZE is passed
to scsi_vpd_lun_serial() so we don't sysfs_emit_at() to check it again.

	buf[ret] = '\n';
	return ret + 1;

Let me know if this sounds good to you.

Thank you!
Igor

> 
> Thanks,
> 
> Bart.
> 
