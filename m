Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E56215F58
	for <linux-scsi@vger.kernel.org>; Thu,  7 Nov 2024 16:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730995517; cv=none; b=QBP+vu3NUH1VLkRwWPYewEm65jlfRzajuhBYsV772skLnYxzxASfhs5ZLeVhcJRSGDefZSFLFxcpmonPd/8hZBgKe4IYaoXYPO6Ih509YCkujeo0DD5rz5jyo0t8FJsP38N7TnvT8Gm3h8EO2KujtWoKxkBDT+e/SOCml0W4LMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730995517; c=relaxed/simple;
	bh=ib3VD+kz/UeLjXQQ3nPi127rk9Px3L6+fI+LsHtyYk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rxq/kq2rmKuBJWU9lu2vRmEBsF5Yvndrr39QbjITdMvz/QCU+TkM74WdHiQlO4fxJ5lhd/2SNtz/mhxf3Vy5SdALTSnlW2ygI7pog4U65xpMzpM0ocm/YjPqVBSiYoZaPS5yItlhrrmzHMve09wEDUNP2spgk/9jpHFJGlyBC8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O2qOuk0i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O2qOuk0i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730995512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0GL7EY0Lj2wHCiysg6FdJa7+z5p54GgZ3DTXs60yVY0=;
	b=O2qOuk0i8EV3BhwHT+Pv7GOlQNF0TlB9GSEhaquI13QD8hXLIN4cAtD4FkVGJGWzDjx3Up
	yLyxHCrQKt+tpHn2D2l53YiF2eyOa9f10vE8su3dz2S/EAjEPMK2ccxZvdXVh+yV/qmpwY
	QTsWgjDuGMDnAg7AbZcd5Il1uFlq7jM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-73-NIPhwC1GNG6zmc97l2E9Kw-1; Thu,
 07 Nov 2024 11:05:09 -0500
X-MC-Unique: NIPhwC1GNG6zmc97l2E9Kw-1
X-Mimecast-MFC-AGG-ID: NIPhwC1GNG6zmc97l2E9Kw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F1A571954B1E;
	Thu,  7 Nov 2024 16:05:05 +0000 (UTC)
Received: from [10.22.88.108] (unknown [10.22.88.108])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9A4751955F3D;
	Thu,  7 Nov 2024 16:05:04 +0000 (UTC)
Message-ID: <67da1859-cfd2-45f0-951b-258ebdf6fd5f@redhat.com>
Date: Thu, 7 Nov 2024 11:05:03 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] scsi: st: clear was_reset when CHKRES_NEW_SESSION
To: =?UTF-8?Q?Kai_M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 "James.Bottomley@hansenpartnership.com"
 <James.Bottomley@HansenPartnership.com>, loberman@redhat.com
References: <20241031010032.117296-1-jmeneghi@redhat.com>
 <20241031010032.117296-3-jmeneghi@redhat.com>
 <5046E716-BB3D-45A6-B320-6810F5C792EC@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <5046E716-BB3D-45A6-B320-6810F5C792EC@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On 11/3/24 13:32, "Kai Mäkisara (Kolumbus)" wrote:
>> On 31. Oct 2024, at 3.00, John Meneghini <jmeneghi@redhat.com> wrote:
>>
>> Be sure to clear was_reset when ever we clear pos_unknown. If we don't
>> then the code in st_chk_result() will turn on pos_unknown again.
>>
>>         STp->pos_unknown |= STp->device->was_reset;
>>
>> This results in confusion as future commands fail unexpectedly.
> 
> This brings in my mind (again) the question: is the hack using was_reset set
> by scsi_error to detect device reset necessary any more? It was introduced
> as a temporary method somewhere between 1.3.20 and 1.3.30 (in 1995)
> when the POR (power on/reset) UAs (Unit Attention) were not passed to st.
> The worst problem with this hack is clearing was_reset. St should not clear
> something set by error handling (layering violation).

OK. I wasn't aware of the history here... but I agree we want to get rid of the layering violation.

> Your earlier patch added code to st to set pos_unknown when a POR UA
> was found. So, is this now alone enough to catch the resets?

As long at the tape device actually sends a UA, no I don't think we need the was_reset code anymore.
We should remove the device->was_reset code from st.c.

> I now did some experiments with scsi_debug and in those experiments
> reset initiated using sg_reset did result in st getting POR UA.
> But this was just a simple and somewhat artificial test.

Yes, I've noticed that not all of the different emulators out there like MHVTL and scsi_debug
will reliably send a POR UA following sg_reset. Especially scsi_debug. The tape emulation in
scsi_debug is inadequate when it comes to resets AFAIAC.

I'll see if I can develop some further tests for MHVLT, but scsi_debug isn't worth the
trouble (for me) and I've told our QE group here at Red Hat to stop testing the st driver
with scsi_debug.  Doing this has led to too many false positives and passing tests. That's
why I finally purchased a tape drive and started testing this myself.

If you want to remove the device->was_reset from the st driver I can help by running
the patch through my tests with the tape device.

-- 
John A. Meneghini
Senior Principal Platform Storage Engineer
RHEL SST - Platform Storage Group
jmeneghi@redhat.com

