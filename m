Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F411EF0A1
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 20:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730837899; cv=none; b=DZcca3qi01pS7aFP0QXkUrqk4CvFBNmFMynzuDtzVrfN8cQ3iKXlYNPAcCwtmms39VFMDCZDZWKArhhGhDZ8a6XalYKJsS+KCRBdiCE09/Cbii/E0vA6tz0ZindZpngd0cZwHWMo5DIQg+V400axj2f2EyYxex6eu6SWem6Ic7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730837899; c=relaxed/simple;
	bh=3jieFVTCt0QTd8pdn0caoPDbZBF1dIo/2N6YGrgX1nI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g7k7iI9Jht8j4yG7oY8twsdMMwKDJnDXQ1jRnzhpGN+OyUA7SxNb5KP3nCdP9/6rDlMpjs11jY4N6XiOZvdt9tfVzVEbYbspvVVbY+JlQolmydBy0RuvYK6Oz+uQ+61Jxw5vMO25cyySKs+DwfJdzZ/srHBmkIKOJo4xlVDInM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gVclqSV6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gVclqSV6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730837895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+lABxB7p4Ks38SXfCdjslLdYFXoQ5tl7YWXNgrh2A/s=;
	b=gVclqSV6PN5xAkx7w34+HkHZQFKHiGRdhLdvma6t1x9tyh58qqg2/7Cfo18Dk6WngeBNpF
	89MpoSYG712XDKv/KoKs3tzjDTkGRkf7422qiWvwjotZTwzFDcqN53VpPxMosMmrmfi9j3
	wlRpdem8Jxkoi7oJJ4332iYo9r271rg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-484-ur0TY7DPPOulMWJEddDDeQ-1; Tue,
 05 Nov 2024 15:18:12 -0500
X-MC-Unique: ur0TY7DPPOulMWJEddDDeQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4AC5B1955EE7;
	Tue,  5 Nov 2024 20:18:11 +0000 (UTC)
Received: from [10.22.88.108] (unknown [10.22.88.108])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 91B65300018D;
	Tue,  5 Nov 2024 20:18:09 +0000 (UTC)
Message-ID: <55016e46-e772-43b8-bc7b-c0f14eed44bd@redhat.com>
Date: Tue, 5 Nov 2024 15:18:08 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] scsi: st: Device reset patches
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
 loberman@redhat.com
References: <20241104112623.2675-1-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20241104112623.2675-1-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Thanks for the fix Kai.

While testing these changes with a tape drive I came across one more issue.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219419#c14

I'll send a follow on patch which I think might address that issue.

Martin, please merge these patches... we have a number of customers waiting for this fix.

/John

On 11/4/24 06:26, Kai Mäkisara wrote:
> These two patches were developed in response to Bugzilla report
> https://bugzilla.kernel.org/show_bug.cgi?id=219419
> 
> After device reset, the tape driver allows only operations tha don't
> write or read anything from tape. The reason for this is that many
> (most ?) drives rewind the tape after reset and the subsequent reads
> or writes would not be at the tape location the user expects. Reading
> and writing is allowed again when the user does something to position the
> tape (e.g., rewind).
> 
> The Bugzilla report considers the case when a user, after reset, tries
> to read the drive status with MTIOCGET ioctl, but it fails. MTIOCGET
> does not return much useful data after reset, but it can be allowed.
> MTLOAD positions the tape and it should be allowed. The second patch
> adds these to the set of allowed operations after device reset.
> 
> The first patch fixes a bug seen when developing the second patch.
> 
> Kai Mäkisara (2):
>    scsi: st: Don't modify unknown block number in MTIOCGET
>    scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed after device reset
> 
>   drivers/scsi/st.c | 31 ++++++++++++++++++++++---------
>   1 file changed, 22 insertions(+), 9 deletions(-)
> 

