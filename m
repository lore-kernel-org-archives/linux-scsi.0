Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G0EEqzLT"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAC019A9
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 11:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701200350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kWvoxnWJMHOj2mcCzJeOHQgkpElatWVFL0MsVsy6RuA=;
	b=G0EEqzLTXMP7W+An+nbQDFnHm9Rsy3xg57DKq9UvodWI5r29Aa6IK8p4gPp3rYvbPay+wD
	6gFuyIxDhPHnFTOFydFda7LbYwIHzp7nz5Dk7tWVZVWYgj/vazGUR3gZORElcBlP/vPsO2
	e79ivr12mdzztQLf7GCYcX3jZxlv7ss=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353-Mt_anEfgMdyN_azUS5EXDA-1; Tue, 28 Nov 2023 14:39:06 -0500
X-MC-Unique: Mt_anEfgMdyN_azUS5EXDA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8412185A783;
	Tue, 28 Nov 2023 19:39:05 +0000 (UTC)
Received: from [192.168.37.1] (ovpn-0-14.rdu2.redhat.com [10.22.0.14])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6EF8F285A;
	Tue, 28 Nov 2023 19:39:05 +0000 (UTC)
From: Benjamin Coddington <bcodding@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Subject: Re: READ CAPACITY for unregistered while PR EARO
Date: Tue, 28 Nov 2023 14:39:04 -0500
Message-ID: <0D2BAB08-6C99-4155-8DBC-21938896A833@redhat.com>
In-Reply-To: <E48201E1-BCCD-4D1D-8354-3EBB45BAC199@redhat.com>
References: <E48201E1-BCCD-4D1D-8354-3EBB45BAC199@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

On 28 Nov 2023, at 10:30, Benjamin Coddington wrote:

> Hey SCSI experts,
>
> Am I right to assume that /all/ SBC commands (I'm interested in READ
> CAPACITY) should return CONFLICT to an unregistered I_T nexus when the
> device server has Persistent Reservation, Exclusive Access - Registrants
> Only?
>
> I have access to SPC-4; table 66 only talks about SPC commands.
>
> If so, I think it might make sense to call sd_revalidate_disk() directly
> after a successful pr_register.

I found that SBC-4 specifies that READ CAPACITY should be allowed for all
reservation types, so it seems my issue is with the LIO target driver.

Ben

