Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C90192D75
	for <linux-scsi@vger.kernel.org>; Sat, 14 Dec 2024 13:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734184005; cv=none; b=R4srJohGf5SuXy3b3WGWoVxeakNIjh4CHGxhpG/WWrae3pvB/NBJETcFhFAsfZkVHSPUtw2fv8z9W7wYgri+Q95t5Fvq7PcQkTR29qbXzHo7HUt7pmMya5wV9qRQkIp05kqIYSiVT6+eXvdbEolyoU0YJnz9QbyIyd2ohtTEwY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734184005; c=relaxed/simple;
	bh=q/sK8ijRBlacoiz6RcEIMlI2nJlhoOg9iKpuHDcOqDE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=op5JgqrjX8GDR7pUIexXE3DrlURiNStdsMAbKwcPEXJQfnjy3RWgDlbmDV/fe9DHZwWm4CIKIQsYfoQh1Q3iP3qVr5TWEu0P4xQ0q25T9GtbbyuJGAmcAZc9KEsqyibXnz1C2Ejcc30SLmre/i1RqguzWOKZbRorAM3Nec/XKq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=OD9jnK23; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="OD9jnK23"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=VXmlN5ocrNMXqEA2QbbSAXkOMXctaSgwZIESVJ7BKOI=;
	b=OD9jnK23zTlxVc/JjqNN7zEEsq7gdHwlLxJcbcy5bFJxiAUTIBzzu9jGYmyRB49YC9v+FsFeMQcJI
	 bwYLjPiqiDGmUvHWuWD6xqcqVF+Yx6j2ieRS/psoT4x0chKh3VYCgnCrvuqpbcOqfxRv/fFlYd+7rv
	 VozzMd5tQSDcm9QlMyCgvEVxH1jc5EzoA6MQYYO72XEopoeN70cdJf2/JlkMpo+zynsvx5fX1G6JT9
	 q0nk+Iev4cu/oebt7f2zUcOoduG6sYpIq3ttAZ0Y4XelrERetLNdpBQFSjJpdAvnLe+PJo5citHw/G
	 kn+lZKoaabQhzRg6gID+dJnvL9R04Dg==
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
	id d3f104c9-ba21-11ef-9c21-005056bd6ce9;
	Sat, 14 Dec 2024 15:46:33 +0200 (EET)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.300.87.4.3\))
Subject: Re: [PATCH v2 0/4] scsi: st: scsi_error: More reset patches
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <ad401bf6-e4a6-4372-8205-22e923900e5e@redhat.com>
Date: Sat, 14 Dec 2024 15:46:22 +0200
Cc: linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com,
 "James.Bottomley@hansenpartnership.com" <James.Bottomley@HansenPartnership.com>,
 loberman@redhat.com,
 Bryan Gurney <bgurney@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <2201CF73-4795-4D3B-9A79-6EE5215CF58D@kolumbus.fi>
References: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
 <0c6e699b-8f77-411f-b73d-e6762c6ad286@redhat.com>
 <8B3169CC-BD8A-46B5-B9B0-140047A44661@kolumbus.fi>
 <964CF609-B7DB-44CF-80A2-2955E73561EF@kolumbus.fi>
 <ad401bf6-e4a6-4372-8205-22e923900e5e@redhat.com>
To: John Meneghini <jmeneghi@redhat.com>
X-Mailer: Apple Mail (2.3826.300.87.4.3)



> On 13. Dec 2024, at 19.32, John Meneghini <jmeneghi@redhat.com> wrote:
>=20
> On 12/13/24 08:09, "Kai M=C3=A4kisara (Kolumbus)" wrote:
>>> On 12. Dec 2024, at 20.27, Kai M=C3=A4kisara (Kolumbus) =
<kai.makisara@kolumbus.fi> wrote:
>>>=20
>>> While doing some detective work, I found a serious problem. So, =
please hold these patches again.
>>> More about the reason below.
>> ...
>>> The problem is that no driver options for the device can be set =
before something has
>>> been done to clear the blocking. For instance, the stinit tool is a =
recommended method
>>> to set the options based on a configuration file, but it fails.
>=20
> And "the blocking" is because pos_unknown is set?
>=20
>>> Note that this problem has existed since commit =
9604eea5bd3ae1fa3c098294f4fc29ad687141ea
>>> (for version 6.6) that added recognition of POR UA as an additional =
method to detect
>>> resets. Nobody seems to have noticed this problem in the "real =
world". (Using
>>> was_reset was not problematic because it caught only resets =
initiated by the midlevel.)
>=20
> Just to be clear. People in the real world did notice this problem. We =
have multiple customers who have reported "regressions" in the st =
driver, all of whom starting using a version of our distribution which =
had commit 9604eea5bd3a. The changes for
> 9604eea5bd3a (scsi: st: Add third party poweron reset handling) were =
necessary to fix a real customer reported problem, but there were a =
number of regressions introduced by this change and it looks like we =
haven't gotten to the bottom of these regressions. Basically, we had so =
many customer complaints about this that we reverted commit 9604eea5bd3a =
in rhel-8.

This sounds puzzling. The patch 9604eea5bd3a has been signed off by you. =
Now you say that=20
there were a number of regressions, so that you have reverted the commit =
in rhel-8. Yet, there
have been no reports of regressions in linux-scsi. Or have I missed =
something?


I have made some experiments with st.c from v6.4 (before the commit) and =
v6.7 after the
commit. My (slightly tuned) scsi_debug was started with option =
'scsi_level=3D6'. The
test used the stinit tool that can be used to set st parameters after a =
drive has been
detected (using, e.g., udev). (And I think  that any decently configured =
Linux system
with tape drives should set the proper parameters for the drives.)

The test uses modprobe to load scsi_debug (and this loads also st). =
After that
the tools mentioned above were tried:

st.c from v6.4:
- stinit succeeds
- 'dd if=3D/dev/nst0 of=3D/dev/null bs=3D10240 count=3D10' succeeds

st.c from v6.7:
- stinit fails
- dd fails


So, there is are clear regressions caused by commit =
9604eea5bd3ae1fa3c098294f4fc29ad687141ea
and this must be fixed. One method is, of course, to revert the commit. =
Another alternative is to do
something to solve the problems created by the commit.

Modifying st to accept what stinit uses even is pos_unknown is true =
fixes the stinit problem,
but dd still fails. Not setting pos_unknown after the initial POR UA =
fixes both problems.

