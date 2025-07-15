Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8EE24397B
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2025 19:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752608566; cv=none; b=oOFovxynZRoUvYpqpxCA1Jml6hQHiRmu9bSVK3sRVRADIjEnITsfOBnLwM2OQjFMvZwQpDN/dTShCmL7cZEppsXbwlfzCH0k+CXGL/oANyWkI9vS8lc3YbgUpd0G2uarwz3q8FIEOLysVOULzypwQ+uJ6MGqbDAbyut9c6dj6/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752608566; c=relaxed/simple;
	bh=tVG3IIvG/6yVEU7XaAofMKbChPYj4oEC+QCF9w8z8bI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YyKiudIxuEzNatW0GQUJ9BbIMbWF2tmFo+HvgSvUS122wAQRoNT2IPmBzajS7KgTJVg12ix+BcleOg77ACBO2wwFH66R88BuyJfSPv9lnPLei3C58LNuxpSZzHe7dE8E33W6i8m4RZ2N6cLbt27NRZVhR5Am/DeSh7MVnJIoM5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gaCYW+5I; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gaCYW+5I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752608563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zkY7jaGGEMaqb4h0ytVqk5X4FiTk2+djHhAkhMNzR/E=;
	b=gaCYW+5IZC2FI33sqCAzl2oS+7CYi30UsnArMO1f7vO6oecAvFWUbTNkDtsIUGhm/h58pw
	y2w4s6mt0fNW5toLUcErGAtyaCePe+q1fhffxlED0ePlQzL8HMZwc7kVK7fOrFjcZ9ajrh
	Q4tQvc0SbwqW9qz+DMy8oBM/L7Gqc34=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-43-KbK-_ZNlN86KYo4VSBO_pg-1; Tue,
 15 Jul 2025 15:42:38 -0400
X-MC-Unique: KbK-_ZNlN86KYo4VSBO_pg-1
X-Mimecast-MFC-AGG-ID: KbK-_ZNlN86KYo4VSBO_pg_1752608556
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F30218002AA;
	Tue, 15 Jul 2025 19:42:36 +0000 (UTC)
Received: from [10.22.88.94] (unknown [10.22.88.94])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C1C7018002B1;
	Tue, 15 Jul 2025 19:42:33 +0000 (UTC)
Message-ID: <35738598-0733-408c-8597-20c3599a8973@redhat.com>
Date: Tue, 15 Jul 2025 15:42:32 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 7/8] nvme: sysfs: emit the marginal path state in
 show_state()
To: Keith Busch <kbusch@kernel.org>, Bryan Gurney <bgurney@redhat.com>
Cc: linux-nvme@lists.infradead.org, hch@lst.de, sagi@grimberg.me,
 axboe@kernel.dk, james.smart@broadcom.com, dick.kennedy@broadcom.com,
 njavali@marvell.com, linux-scsi@vger.kernel.org, hare@suse.de
References: <20250709211919.49100-1-bgurney@redhat.com>
 <20250709211919.49100-8-bgurney@redhat.com> <aG7pSA6TOAANYrru@kbusch-mbp>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <aG7pSA6TOAANYrru@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 7/9/25 6:12 PM, Keith Busch wrote:
> On Wed, Jul 09, 2025 at 05:19:18PM -0400, Bryan Gurney wrote:
>> If a controller has received a link integrity or congestion event, and
>> has the NVME_CTRL_MARGINAL flag set, emit "marginal" in the state
>> instead of "live", to identify the marginal paths.
> 
> IMO, this attribute looks more aligned to report in the ana_state
> instead of overriding the controller's state.
> 

We can't really do this because the ANA state is a documented protocol state.

The linux controller state is purely a linux software defined state.  Unless I am wrong, there is nothing in the NVMe specification which defines the nvme_ctrl_state.

This is purely a linux definition and we should be able to change is any way we want.

We debated adding a new NVME_CTRL_MARGINAL state to this data structure,

enum nvme_ctrl_state {
         NVME_CTRL_NEW,
         NVME_CTRL_LIVE,
         NVME_CTRL_RESETTING,
         NVME_CTRL_CONNECTING,
         NVME_CTRL_DELETING,
         NVME_CTRL_DELETING_NOIO,
         NVME_CTRL_DEAD,
};

If you don't like the flag we can do that. However, that doesn't seem worth the effort since Hannes has this working now with a flag.

/John

