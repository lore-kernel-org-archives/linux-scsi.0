Received: from fgw21-4.mail.saunalahti.fi (fgw21-4.mail.saunalahti.fi [62.142.5.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E882223C57
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 18:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734028428; cv=none; b=NAWE6W3pWo39M2sKlCp/ZbpvzPoWU0Scw8I3/NmpuyCWyczcBWLZmFH/hpy61B5CqDXw54zLfwkB6iXB6HFUaxaSsZBbzg5kZYXEMnQDCekiGVksDc61H9sDkXmWvx0FWsF0SqnDTjmI4dE5peZjtDQ1SOHyRP7gJwE8uydnqgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734028428; c=relaxed/simple;
	bh=vqWYTvyRNuySyRTt0fcTcq6Kv2k+oOywGqy5nFG3rB0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=aShdI8uOXGcy2vdVXryo4yYOqonkoUa9ZhaFtyFNkxC7UYYN7Um9CCvFODuUxkHKeDCrfsUd24eM011KBhNalmlKMsd5vvR5eK4BDsH8jMLeT4OrcYPXXui4gcvKjeqJWiCsfupxFmw16oEqCgx4fXVq0LQO4TYp4cRB/EDbXlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=sIXjtb6H; arc=none smtp.client-ip=62.142.5.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="sIXjtb6H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=vqWYTvyRNuySyRTt0fcTcq6Kv2k+oOywGqy5nFG3rB0=;
	b=sIXjtb6H/My9eUFE3yFI3TKdelfx96td9zNDOdjVpWOF4tU3Usk+6aLtSXHi7LwdwcLb/3imbqRvW
	 sz+30CjPQPNxNADDULuFXVimz4gUXxkhpHhdXMR7uqaQst+bSVl7EH6CQ+oTc87w2u0fcoBTl0XsXR
	 sz7/WidfZsxKKqbXCmI3bVgXiADOCfvlfJAmMcDYg2ACDkU2xETDOwqi+cvpCbY2gZZknuUOsBfyHb
	 P4aLKTAlhYDeUuryJU0+cMUMKPR95Aw8b7CGPEF77Aq4pK/ysdZkMhpxa2Vmh6YACKZuI6ih4O4Xm5
	 GWxWfr60W6WwGtaRhpnNwhMyCqfh0VA==
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id 9bdb49dc-b8b7-11ef-888c-005056bdd08f;
	Thu, 12 Dec 2024 20:33:41 +0200 (EET)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.300.87.4.3\))
Subject: Re: [PATCH v2 2/4] scsi: scsi_error: Add counters for New Media and
 Power On/Reset UNIT ATTENTIONs
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <2e21a7f9-f59c-4f8c-a942-ced71cace6df@acm.org>
Date: Thu, 12 Dec 2024 20:33:30 +0200
Cc: linux-scsi@vger.kernel.org,
 jmeneghi@redhat.com,
 martin.petersen@oracle.com,
 "James.Bottomley@hansenpartnership.com" <James.Bottomley@HansenPartnership.com>,
 loberman@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <FAAC229D-CC44-4365-B8B1-0844CA584303@kolumbus.fi>
References: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
 <20241125140301.3912-3-Kai.Makisara@kolumbus.fi>
 <2e21a7f9-f59c-4f8c-a942-ced71cace6df@acm.org>
To: Bart Van Assche <bvanassche@acm.org>
X-Mailer: Apple Mail (2.3826.300.87.4.3)



> On 12. Dec 2024, at 0.14, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> On 11/25/24 6:02 AM, Kai M=C3=A4kisara wrote:
>> + unsigned char ua_new_media_ctr; /* Counter for New Media UNIT =
ATTENTIONs */
>> + unsigned char ua_por_ctr; /* Counter for Power On / Reset UAs */
>=20
> Why unsigned char instead of e.g. u16 or u32? With one of the latter =
two data types, no cast would be necessary in the macros below.

The purpose was to save memory. (Because of the alignment rules, =
probably nothing is saved now compared to u16.)
I will change teh counters to u16.

The const casts are there to prevent the users to use the macros to =
change the counter values.

>=20
>> +/* Macros to access the UNIT ATTENTION counters */
>> +#define scsi_get_ua_new_media_ctr(sdev) \
>> + ((const unsigned int)(sdev->ua_new_media_ctr))
>> +#define scsi_get_ua_por_ctr(sdev) \
>> + ((const unsigned int)(sdev->ua_por_ctr))
>=20
> Please introduce macros in the patch that introduces the first user of =
these macros. I don't see any users of these macros in this patch?

The idea was to introduce the mechanism in one patch and the user in the =
next. But I will move the macros to the next patch.

Thanks,
Kai

