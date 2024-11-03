Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8151A29A0
	for <linux-scsi@vger.kernel.org>; Sun,  3 Nov 2024 18:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730658831; cv=none; b=RBdF7C9LVPQura2jvCzhYA0g8WqwkZAqssIN3kMGikJLmnbmOvQiNNPHQ9RMpOuH4T3Tim3YTHRmuD8krb72VNzSyHBG+YRYMNtwtedn63aCX3Q7OSjNl3ZuWlkHZqpV/93zbP9qFUZXntgUFdpDkn/0YNge0NQljgzDY9LO20I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730658831; c=relaxed/simple;
	bh=eWGw6aXIt8c1+2fT4ZaQ6f4980KHhrjJP/TAGzyiU+o=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=usBv1iWYampT+4o1mmN4cSLytKdRvKpD/+nIrzpyOCVjTKO9TRdQaDWKbruBe/t7lUoKGhxuuwTeOgF8YlGIK9E3tj779WrhbpJ9xvIv5FU6h1PtaWgrSfDN9kbl2FRNgpCUhB670wiQcLvDJ6h9kbQwzxMK7mrGZAWItXZPv7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=BosoDlCr; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="BosoDlCr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=Q9PjYQDLxI9MrVuAf/iosMqr8wo9Kw9Ot1QleNltFRY=;
	b=BosoDlCrsAz5cbPjhLKX6QCoJbRxU3x20cjrfCgCeSooLjFeHoMzlhad6gg41kKVfppylLC9/k7fS
	 FWA/uf/ql33MAS/YOAGWue8/ELuAuVvEPH8nzZpc0bnhRC42240OLSXG7kTOaiaw7MPT7HwPCZ1I7L
	 ZYAGoCadt+YaxIOqgkzVXlgQHIkRQLI1bgtUwX/URDt7nrtqmmZ/LptrRhrZmeCHfbFKaXjBhqBr5a
	 jURuXTOyq2n+47mS4vroZJ3gUaQ8+d0yLioQ9newCereLz+9pe5bIZF7/WD61sUG8MC4ax/Wqg3YOX
	 ZwmXzZWGI6hFBgnSZZ3r0/WHDyLk//Q==
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
	id 00542882-9a12-11ef-9aab-005056bd6ce9;
	Sun, 03 Nov 2024 20:32:38 +0200 (EET)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH 2/3] scsi: st: clear was_reset when CHKRES_NEW_SESSION
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <20241031010032.117296-3-jmeneghi@redhat.com>
Date: Sun, 3 Nov 2024 20:32:27 +0200
Cc: linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com,
 "James.Bottomley@hansenpartnership.com" <James.Bottomley@HansenPartnership.com>,
 loberman@redhat.com
Content-Transfer-Encoding: 7bit
Message-Id: <5046E716-BB3D-45A6-B320-6810F5C792EC@kolumbus.fi>
References: <20241031010032.117296-1-jmeneghi@redhat.com>
 <20241031010032.117296-3-jmeneghi@redhat.com>
To: John Meneghini <jmeneghi@redhat.com>
X-Mailer: Apple Mail (2.3826.200.121)



> On 31. Oct 2024, at 3.00, John Meneghini <jmeneghi@redhat.com> wrote:
> 
> Be sure to clear was_reset when ever we clear pos_unknown. If we don't
> then the code in st_chk_result() will turn on pos_unknown again.
> 
>        STp->pos_unknown |= STp->device->was_reset;
> 
> This results in confusion as future commands fail unexpectedly.

This brings in my mind (again) the question: is the hack using was_reset set
by scsi_error to detect device reset necessary any more? It was introduced
as a temporary method somewhere between 1.3.20 and 1.3.30 (in 1995)
when the POR (power on/reset) UAs (Unit Attention) were not passed to st.
The worst problem with this hack is clearing was_reset. St should not clear
something set by error handling (layering violation).

Your earlier patch added code to st to set pos_unknown when a POR UA
was found. So, is this now alone enough to catch the resets?

I now did some experiments with scsi_debug and in those experiments
reset initiated using sg_reset did result in st getting POR UA.
But this was just a simple and somewhat artificial test.

