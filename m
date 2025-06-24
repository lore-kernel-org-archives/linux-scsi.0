Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5105F770E2
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2025 16:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750781491; cv=none; b=M3xCaldg6AaZkADhwOo91hGzwShbixTHe7CvPkrZGFMzYH12JETx2BTsZtjCW1mpM8PR1QIIOZAv6nNbk/fv8VveA9124tyijzQfx+W4+wa7ckDejfg4L4XDSZNQC+5AwyzZFHvMGbcWX9LwraALMGTu/cT0GMryx4QCe7Cavas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750781491; c=relaxed/simple;
	bh=rpyrgzPqYdwj0KtWllHYX+bkm3/xQH68qnPbDJoG8UA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nX+/lgn8kkKU3r7X6X0lZOPvV2Vsh8vZKW5eI47nTLY5nfnCKGxP1TZUeDIEUpJqdVji5QdqvcOc7uMlI+LwOaRZaN6BQAh/utDOdjtJaG19Zi6yu41BCw+RDUzVQUc1uIf7BhKPIhgPeF/GK5edWDJ6wTFp+k3/aTFUTxB0W2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LasX+SQG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LasX+SQG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750781489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/vAplsu0koS/gXiH5wLf6N4Z+Ah3uxNPhjuFlpZhWyo=;
	b=LasX+SQGU/vqa14xObAEY0c3n0LOmzaxg4V0HHCcJtEdTMV6B8B071+Qb/PGlf6ty1BjRt
	NquHr5sVRLt7ALPRjmKTswMIvWE9RfxOtQ7usD2dUoTdvecyQuFEP5kQcdTmtfUwIs3uRV
	inGFe2FelPdQBgVMqhX8CHBg/5iGlzk=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-578-BtmH2RT7NLaALgmT4nCtQg-1; Tue, 24 Jun 2025 12:11:25 -0400
X-MC-Unique: BtmH2RT7NLaALgmT4nCtQg-1
X-Mimecast-MFC-AGG-ID: BtmH2RT7NLaALgmT4nCtQg_1750781485
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6fac216872cso111159136d6.2
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2025 09:11:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750781485; x=1751386285;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/vAplsu0koS/gXiH5wLf6N4Z+Ah3uxNPhjuFlpZhWyo=;
        b=l5fO1Z58i/LxhwhyHmUp8VMiW3e8BUH8GgLixBrGFKD1yGc5I0bL8IGMlKVNV0ATNS
         V3ScinGa2uSxQ/RHX9BAD9kwmnb1zCXZz/MYsd4Y4bV18OA8owwE4FzSavKSoCXe9GZb
         PETuidvLgEff4CLgLEB07NwhkBsJbpvthWzVmrBL4H8Q9caOCkfqYYLsLM+cOMk7TZuJ
         xBOdYPjjU55DjcSm5v7n6zWjdXhRuA927iz0Irufvi+yg/lG87FhV2hoxEd50anBxKbC
         Jer2MfWAdd4HQ/Y3jM1Favh1X0Rj7l0UkkiAeYXbeuQtgm3eGSHYjGTgjpV53OLXW22c
         qjpA==
X-Forwarded-Encrypted: i=1; AJvYcCWmWnMXHxmj0i1XEM7/tVVWnJqgEpu+y2Nn+TTROslmGF67PaPsxaq2NaggSoWrd7XcNaHh0NmvpZqh@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi2+KmSDczZzRbEcS2ke5L7XAXKzEMExl+zYudZoRQNa55hKpd
	0ew1lJ8SuAUyvToO0WBLGIrrHCQud8lnT+wpfFohkcF3PjfE6JJsAasVZMlCRMspXRZflOlH/Kb
	y3nwKEcIjrnntMVdA5otH8vKSvZuAYT8c+KeKAOCZ/yGFfxXGH8Ye2CmqFnWEM/k=
X-Gm-Gg: ASbGncvHhdxBNGQq4/gTmlURPtG2ytuMbynOLVJG09r7tOylJQDOmlBdmE+7EI2dp34
	o/ceMaKIo4dDb97EPL9KbV0iOAEzI8LQOom/ccc/kdvqYDhZcTccW/mTaW3KClzdrSqAzSr89RM
	g4KgOx8dSfwTAc5bhHhE5PlL/JMdu4RT47ReudcFc6/1qAw31lsE/DsI1USuFObl3LwGqHEP6Gf
	Q+CoNeRIYdmyKt66vbVCDgoT464y3xRtUzx8//w8vmAqtUX1b+7SQUAo6aYEOYfHIuUA/tt+hg7
	Q4xiWIBVj+h6tYLn+09QuJrkE3Thi/vHXCj1+BrqGuCeCEcRqGPAdlkTNnQrpFKjd+N8Mw9qUln
	TG5vLo1gyUpW40qzr
X-Received: by 2002:a05:6214:509c:b0:6fa:c054:1628 with SMTP id 6a1803df08f44-6fd0a54dc0emr331829186d6.23.1750781484657;
        Tue, 24 Jun 2025 09:11:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwO+fys6xaB3QgCvBNDb3NtvnbriukxpK0WFjoLSLnIQz+mQojAEJiClWr0nrT4Mndrjbm/g==
X-Received: by 2002:a05:6214:509c:b0:6fa:c054:1628 with SMTP id 6a1803df08f44-6fd0a54dc0emr331828566d6.23.1750781484146;
        Tue, 24 Jun 2025 09:11:24 -0700 (PDT)
Received: from syn-2600-6c64-4e7f-603b-9b92-b2ac-3267-27e9.biz6.spectrum.com ([2600:6c64:4e7f:603b:9b92:b2ac:3267:27e9])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d3f99efaa9sm517427385a.58.2025.06.24.09.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 09:11:23 -0700 (PDT)
Message-ID: <487a4646387595383bf8ae24584c5b54ec6aa179.camel@redhat.com>
Subject: Re: fix virt_boundary_mask handling in SCSI
From: Laurence Oberman <loberman@redhat.com>
To: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen"
	 <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Ming Lei <ming.lei@redhat.com>, 
	"K. Y. Srinivasan"
	 <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu
	 <wei.liu@kernel.org>, "Ewan D. Milne" <emilne@redhat.com>, 
	linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-block@vger.kernel.org
Date: Tue, 24 Jun 2025 12:11:22 -0400
In-Reply-To: <a665dead67bf4f3432cf1bddf29d2c573ab71673.camel@redhat.com>
References: <20250623080326.48714-1-hch@lst.de>
	 <a665dead67bf4f3432cf1bddf29d2c573ab71673.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-11.el9) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 2025-06-24 at 10:21 -0400, Laurence Oberman wrote:
> On Mon, 2025-06-23 at 10:02 +0200, Christoph Hellwig wrote:
> > Hi all,
> > 
> > this series fixes a corruption when drivers using
> > virt_boundary_mask
> > set
> > a limited max_segment_size by accident, which Red Hat reported as
> > causing
> > data corruption with storvsc.  I did audit the tree and also found
> > that
> > this can affect SRP and iSER as well.
> > 
> > Note that I've dropped the Tested-by from Laurence because the
> > patch
> > changed very slightly from the last version.
> > 
> > Diffstat:
> >  infiniband/ulp/srp/ib_srp.c |    5 +++--
> >  scsi/hosts.c                |   20 +++++++++++++-------
> >  2 files changed, 16 insertions(+), 9 deletions(-)
> > 
> Grabbing latest and will test tomorrow and reply
> 
For the series looks good.
Same testing shows no corruptions on storvsc for the REDO so passed.
For SRP initiators generic testing done with fio and passed, unable to
test SRP LUNS with Oracle REDO at this time.

Here it is, enough reviewers already so just the testing
Patches were applied to a 9.6 kernel because I needed such a kernel for
Oracle compatiility.

tested-by: Laurence Oberman <oberman@redhat.com>



