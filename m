Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532BC37269B;
	Thu, 17 Sep 2026 02:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789612122; cv=none; b=SayzsOFR9kqWyF8q4bffCsTi7xcrDYZl2LlXvMOtn4RtTwneAp0UfXF3ip1cSL2ifHhmbU3wr92ZSWbVqDopgDEKCUDwPPvj/o50nFD0ck17b7OcAA866Iuzv4hndT5iZlir8s9YMN7w/Dc1WLd9CZHPeTWRCrgC8f4GbCkPJ4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789612122; c=relaxed/simple;
	bh=8SrHlElkovf72EomispvKfzIZnuVogNrKf0fsnIbg6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P+q16FcoJVKNBNbXx2ivdfbp9ntACp1Bfa1AYKhcionq+STTLSxsinTqSAzyvjIAjaNpX3LA6X8pNvj2hgedF94VtiMbCvSJgU13TqseIqO7HseOmAqoh2RESj6x8KAh1S2LuaLBz7793//hP1JFz0vv+L9jMyPgmZHHgixqDOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ia2/+UwZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ia2/+UwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12C91F000FF;
	Thu, 17 Sep 2026 02:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789612108;
	bh=iIX8pAC/rdkAgeb8dsPlGjy9nEa5b/Uy1Tm1BWmSj5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ia2/+UwZlO4yH0lndDjG06S1cJRAylprEGO6eKfgocK882vLZt8wlUYZbU5QWZ/5F
	 FKetcgY/0cxwlPa5tOUNlqlxb4pay4BLVxWKfkJuRflBfkj2WSFhjm7GoDpoZhuZt/
	 wmoZbRfwGlrDzp6uUfpUnsP8SYEDPgtED2vqRruDu6DVBXJ6IBsgzjtkiDpSR3JXf1
	 1v1ZDNjljfWfJUgvjfId0ortmWUjQzmnxR1bxTJItG02WpjWhy15QgcB5NwMgwgWJO
	 gxdt64jbP/2EGKNgDaiTPoCkfNb8RGkchv+ETBABl5/d1PgrocCQyBCeKAq4oUuNRX
	 744fN8mQ3O5OA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Alberto Carboneri <acarboneri@drivesec.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	Flavian Dei <fdei@drivesec.com>,
	Willy Tarreau <w@1wt.eu>,
	Hannes Reinecke <hare@suse.de>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: core: Validate MODE SENSE lengths in scsi_cdl_enable()
Date: Wed, 16 Sep 2026 22:28:12 -0400
Message-ID: <178961190584.3672510.3661745613686534930.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904135410.360314-1-acarboneri@drivesec.com>
References: <20260904135410.360314-1-acarboneri@drivesec.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 04 Sep 2026 13:54:37 +0000, Alberto Carboneri wrote:

> scsi_cdl_enable() uses length fields returned by MODE SENSE to locate the
> ATA feature mode page in a 64-byte stack buffer. A target can report a
> total length shorter than its mode header and block descriptors. The
> unsigned subtraction used for the MODE SELECT length can wrap, and the
> separately computed buf_data can point beyond buf.
> 
> During automatic scan, enable is false, so the read-modify-write of
> buf_data[4] can clear the low two bits of a target-selected out-of-bounds
> stack byte. scsi_mode_select() can then copy up to 64 bytes from outside
> the buffer into the outgoing MODE SELECT payload, disclosing stack contents
> to the target.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: core: Validate MODE SENSE lengths in scsi_cdl_enable()
      https://git.kernel.org/mkp/scsi/c/3d676e458fe0

-- 
Martin K. Petersen
