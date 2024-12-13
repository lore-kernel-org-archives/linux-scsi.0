Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449441DEFC1
	for <linux-scsi@vger.kernel.org>; Fri, 13 Dec 2024 15:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734102581; cv=none; b=CvJVrJiyGCy5vlMg9uczRXT6Rwrlue46Z4EYvvZuiqVViSJ+XXN79VNkHw3EwaQ9WuknhxWpzDdq7HNcrnznnxMAnblvQHvJCGFkf7TqP5dyUp/tlK+WpVa2xGBuN+Li1lemIjFmf+IaQqVQPicsb9LiCp3aBn7Ht6DhjmTT4H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734102581; c=relaxed/simple;
	bh=EJGewS6OdHc/PbvS/ACO7WhoWoTmPoONm84jej13k6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oAOm9ESZlw0ZDmkchPjuXFlNSEQd+hcy9+KzMeF1WdM8+TuDzuuT5fVH9FAseVZ9Ob/0M5X3jF0xssLCafTCkQhB4Ei8Ii7O0ksCpdN0ZXHtQmE30puOxc8RLm+j38oqYkubghOO2GloDet9ChQ+Pnwa4LBfjipNWTzCrbrkNQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AJkiBSRD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AJkiBSRD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734102578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pdp6rCuPMg5ZaFRP7Gc8pJHm8hkRgF1rmzt0puZjvV4=;
	b=AJkiBSRD57kTDCNgXL0UolTuVRIi+h8koAuokLBgdMiFk93fgD9GaatEVNoExubA5dCyP8
	DCT9rzrVm+LrPkR3vg7JpSq9GEKnjHnUN7lV+llc1oUjxNGfTBiOcdl30Zmu8aB4xPGdyZ
	6xlhTXEGG0QDgw2DRR55MOflu5lNxck=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-296-asSzEQJqM1yEBem235DP6g-1; Fri,
 13 Dec 2024 10:09:36 -0500
X-MC-Unique: asSzEQJqM1yEBem235DP6g-1
X-Mimecast-MFC-AGG-ID: asSzEQJqM1yEBem235DP6g
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A95A1956069;
	Fri, 13 Dec 2024 15:09:35 +0000 (UTC)
Received: from [10.22.64.187] (unknown [10.22.64.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7F5EC1956089;
	Fri, 13 Dec 2024 15:09:33 +0000 (UTC)
Message-ID: <46598e48-26a8-4062-afb1-677ff7295335@redhat.com>
Date: Fri, 13 Dec 2024 10:09:32 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] scsi: st: scsi_error: More reset patches
To: =?UTF-8?Q?Kai_M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 "James.Bottomley@hansenpartnership.com"
 <James.Bottomley@HansenPartnership.com>, loberman@redhat.com
References: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
 <0c6e699b-8f77-411f-b73d-e6762c6ad286@redhat.com>
 <8B3169CC-BD8A-46B5-B9B0-140047A44661@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <8B3169CC-BD8A-46B5-B9B0-140047A44661@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On 12/12/24 13:27, "Kai Mäkisara (Kolumbus)" wrote:
> I previously suspected that the first POR UA is caught by scsi scanning when it issues
> MAINTENANCE_IN to get the supported opcodes. This happens when scanning calls
> scsi_cdl_check(). However, this function does not do anything if Scsi level is less than
> SPC-5 (ANSi 7). Scsi_debug claims SPC-5 and so scsi_cdl_check() gets the UA
> before the st device exists. Your drive probably is reporting a level less than SPC-5
> and so the UA is not received by the scanning code.

No, I don't have a problem with the tape drive. Everything works correctly with the tape drive.  You can see the test results 
log for my latest test with the tape drive at:

https://bugzilla.kernel.org/show_bug.cgi?id=219419#c22

This isn't the issue. The issue of the first POR/UA not being reported to the st driver is only seen when using the scsi_debug 
driver with tape emulation.

/John

