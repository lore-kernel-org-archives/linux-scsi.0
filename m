Received: from fgw21-4.mail.saunalahti.fi (fgw21-4.mail.saunalahti.fi [62.142.5.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA4F286A1
	for <linux-scsi@vger.kernel.org>; Thu, 14 Nov 2024 16:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731603097; cv=none; b=qruOL9K/3WGFeMFVLhMT0sHSAeJaMrzTHz0+fSVUSba7QAclIUeEzKUIC/4w1vba3Y1y6KNYi7eAIfMGQC2o2IPbIyGs2WwtnajL2jQvykQC7maMZrNyLEsG7jL/UdvkJm+aZFi7n5yE6Fe1g4l6CBdmMgcEA4KbaW+eTbsbhD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731603097; c=relaxed/simple;
	bh=wky8RpdE+VYnPm/AtpmisfsXGR9PjbT+EjKoQ/J4thc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=kylmOULVtjzcGoDKHdWNHu1/9gg3I/eOMUltSFpuvHcEkxU7xcQMWGQ4S8sUy4E2GhTAhOqMFBr8Qz6t3GPKM3QtsozldvLY+7ERLU67+WBysT8y1Hg+49j/l0kTWkyb2tlDxbwNPus1vUk+4c/X10LJPwm2DwgitfcsmUM9/gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=OTIF8vWs; arc=none smtp.client-ip=62.142.5.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="OTIF8vWs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=IQXUzmgfy+FiOrsRboDxxJga6IRKVCTyBje40BcsOoU=;
	b=OTIF8vWsomo6Fqq1nE+QO/45ZKRTJ8+8Z8sk4Zj+ZZ1I5laW0YxOcFuTmQ3tzQaempC3XOSyJEfoo
	 BnQQV6RGUCLEnHou8N1p5YrWBrC+AbxJ2fzhBzhFpUsh5Af4E95oVbXyTvqEACID94i5ieZXeVzikm
	 m9dynkD9M5Lp2FIGliZnqDdsOmQxhdzy/OAqN9sUlOflm2Vw+oEgTL4h9UgBSfRW3o1c/g9xU/+3l7
	 n8ipByiusPCp0IrULiUuX0a2vC32jU0ToqHhvK7+KABSlRhoHIgw5mzWvFh7nliWJFNn4PKsrcHNlo
	 sGoeGIFFbE6c7FiSI8cMPwLhbcKgmlg==
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw23.mail.saunalahti.fi (Halon) with ESMTPSA
	id b2ee6020-a2a8-11ef-a0cd-005056bdfda7;
	Thu, 14 Nov 2024 18:51:31 +0200 (EET)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH 2/3] scsi: st: clear was_reset when CHKRES_NEW_SESSION
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <67da1859-cfd2-45f0-951b-258ebdf6fd5f@redhat.com>
Date: Thu, 14 Nov 2024 18:51:21 +0200
Cc: linux-scsi@vger.kernel.org,
 loberman@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <01385357-3D40-4720-82ED-AF8EEAFE7351@kolumbus.fi>
References: <20241031010032.117296-1-jmeneghi@redhat.com>
 <20241031010032.117296-3-jmeneghi@redhat.com>
 <5046E716-BB3D-45A6-B320-6810F5C792EC@kolumbus.fi>
 <67da1859-cfd2-45f0-951b-258ebdf6fd5f@redhat.com>
To: John Meneghini <jmeneghi@redhat.com>
X-Mailer: Apple Mail (2.3826.200.121)



> On 7. Nov 2024, at 18.05, John Meneghini <jmeneghi@redhat.com> wrote:
>=20
> On 11/3/24 13:32, "Kai M=C3=A4kisara (Kolumbus)" wrote:
>>> On 31. Oct 2024, at 3.00, John Meneghini <jmeneghi@redhat.com> =
wrote:
>>>=20
>>> Be sure to clear was_reset when ever we clear pos_unknown. If we =
don't
>>> then the code in st_chk_result() will turn on pos_unknown again.
>>>=20
>>>        STp->pos_unknown |=3D STp->device->was_reset;
>>>=20
>>> This results in confusion as future commands fail unexpectedly.
>> This brings in my mind (again) the question: is the hack using =
was_reset set
>> by scsi_error to detect device reset necessary any more? It was =
introduced
>> as a temporary method somewhere between 1.3.20 and 1.3.30 (in 1995)
>> when the POR (power on/reset) UAs (Unit Attention) were not passed to =
st.
>> The worst problem with this hack is clearing was_reset. St should not =
clear
>> something set by error handling (layering violation).
>=20
> OK. I wasn't aware of the history here... but I agree we want to get =
rid of the layering violation.
>=20
I have read code and done experiments. I think I now know how the POR =
UAs were lost
in 1990s. And why that does not happen now.

In 1.3.30, scsi.c handled resets. When resetting, it set the =
device->expecting_cc_ua flag.
If UA was received when expecting_cc_ua was set, the command was retried =
if
retries were allowed. St allowed five retries for TEST UNIT READY and so =
the POR UA
was left in the midlevel. (If expecting_cc_ua was zero, UA:s were =
returned to the upper
level.)

Now, st does allow zero retries. In addition to this, the requests use =
either REQ_OP_DRV_IN
or REQ_OP_DRV_OUT and these requests are not retried. So, now POR UAs =
reach
st (as the experiments have indicated).

>> Your earlier patch added code to st to set pos_unknown when a POR UA
>> was found. So, is this now alone enough to catch the resets?
>=20
> As long at the tape device actually sends a UA, no I don't think we =
need the was_reset code anymore.
> We should remove the device->was_reset code from st.c.
>=20
Using device->was_reset has the advantage that it does not depend on the
drives sending UA. However, I think that a probability of a working =
drive
not sending UA after reset is minimal.

>> I now did some experiments with scsi_debug and in those experiments
>> reset initiated using sg_reset did result in st getting POR UA.
>> But this was just a simple and somewhat artificial test.
>=20
> Yes, I've noticed that not all of the different emulators out there =
like MHVTL and scsi_debug
> will reliably send a POR UA following sg_reset. Especially scsi_debug. =
The tape emulation in
> scsi_debug is inadequate when it comes to resets AFAIAC.
>=20
> I'll see if I can develop some further tests for MHVLT, but scsi_debug =
isn't worth the
> trouble (for me) and I've told our QE group here at Red Hat to stop =
testing the st driver
> with scsi_debug.  Doing this has led to too many false positives and =
passing tests. That's
> why I finally purchased a tape drive and started testing this myself.

I have a more positive view about scsi_debug. Its tape support is =
minimal, but it can be
useful if you consider what it does support and what it doesn't support.

A real drive is better, of course.

> If you want to remove the device->was_reset from the st driver I can =
help by running
> the patch through my tests with the tape device.

I will send patches tomorrow. The patches will also include a fix to =
another problem:
some parameters should be restored after reset in case of some =
operations like rewind:
the partition, density and block size should be restored to the values =
set before reset.

Thanks for your testing (so far and in future).

Kai

