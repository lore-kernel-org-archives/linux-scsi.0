Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6980981751
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 14:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730384322; cv=none; b=ZpJ9QyTW8LuWqpOxIe6tzLCIUlwkpQ5MX8hzLqMmUCa9sXHfeSumngF55NgWd8SLBPYkFgkqkYIOOV+SL0yiz3kXbOYktGZE6QlPR9mHJGl0RtbTdIdGmM1ETdryc4JY9pm1tyze50zESsK85tiDNw3cPihkdvDFhgKO4wzDLt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730384322; c=relaxed/simple;
	bh=PPhXSxL1L/SGuMFwoOwJXkbPAiRZYP42jywtuTfVmT8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=UAOix8bZeqOUraxYPeYjMvGP5XMCZAb6mdupT2uVQilPBSS4Z9fiKMyuWFLCgFtcJAaT6QuzQMH3QdKvUl/XAZAYx+oEDhK0xtk1lGE6vEalwpsjfwkOb+uRgqmh03hVJAXI2l/y4ttlLhsEndgk3ZlzFwbrM9+4N9QhDnBdIgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=greNBCaD; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="greNBCaD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=7tRpwrd+4LG+GrdwMekwaayKoafKY5xPgsypup/nk6k=;
	b=greNBCaDQ073nkv1rZXvXjdiJw/W+tEJ+KAZJ5kvAOKzLMbVsU4b8G4hWCLk+S1cQFqSrvDJLzYeL
	 r5yO5e72Dww59CXo9FMeZUfEt1UqKzLAZfp5r/f6sJ3zHqGgWX8ZA5G7+TrTY+T4N7u8esZvCICu8E
	 wjct+M4rhYB8mG0+E1Yi2J9PZa0Bu9FqR34RoxsDM5kFRe3uRZF7ZqLsrh8Htvh2rE2BMj3pi4LgQa
	 /GGCnoHR+bXdoziJq2BrNGzVBx3qoKwtaWfHaFeXuIkdrZwhinv8nuWV9Si1mteBvmxZRcvx56m59o
	 TU7SVWGhChAF8T16w0jOO3IVVAO62bg==
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id da99d9d2-9792-11ef-8870-005056bdd08f;
	Thu, 31 Oct 2024 16:17:26 +0200 (EET)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH 3/3] scsi: st: clear pos_unknown when the por ua is
 expected
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <20241031010032.117296-4-jmeneghi@redhat.com>
Date: Thu, 31 Oct 2024 16:17:15 +0200
Cc: linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com,
 "James.Bottomley@hansenpartnership.com" <James.Bottomley@HansenPartnership.com>,
 loberman@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <3BCF79DE-1CF8-436D-A611-24387F976F68@kolumbus.fi>
References: <20241031010032.117296-1-jmeneghi@redhat.com>
 <20241031010032.117296-4-jmeneghi@redhat.com>
To: John Meneghini <jmeneghi@redhat.com>
X-Mailer: Apple Mail (2.3826.200.121)

On 31. Oct 2024, at 3.00, John Meneghini <jmeneghi@redhat.com> wrote:
>=20
> From: Kai Makisara <kai.makisara@kolumbus.fi>
>=20

The patch in this message is a WIP patch discussed in Bugzilla. It is =
not
meant to be submitted as such. (In addition to changes, it contains a =
bug
fix not related to the changes.) Those interested in the progress can =
look
at the Bugzilla entry shown below.

> Fixes: 3d882cca73be ("scsi: st: Fix input/output error on empty drive =
reset")
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D219419
> Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
I have NOT signed of this patch.

> Tested-by: John Meneghini <jmeneghi@redhat.com>

John has done extensive tests to see if the patch works.

> ---
> drivers/scsi/st.c | 31 ++++++++++++++++++++++---------
> 1 file changed, 22 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index e9d1cb6c8a86..0260361d19fa 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
...

