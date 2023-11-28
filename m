Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xm8HXq+/"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE60D1
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 07:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701185445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=plbTzwyMhJ41SLppjKGiEX4DtMPkhfBHXUgJR5Y1Gg8=;
	b=Xm8HXq+/tH4bKbPAbHUlo30aYuvUcM0ZSsGGjBATA451yPjX7oT8zJxCygw7DBG6hKJfE4
	ox9rBCrbOMp/fiHjqlDY94EQafPJyhvc1VBGbrNq7I+QRXUvh8XhHYeVNQb+00Njbr3Kma
	MQu/wM1vd3egswBmOsbIIYqUUWqFUDE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-IxZQTw_POue1O7ClPkA8TA-1; Tue, 28 Nov 2023 10:30:43 -0500
X-MC-Unique: IxZQTw_POue1O7ClPkA8TA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E478101A529;
	Tue, 28 Nov 2023 15:30:43 +0000 (UTC)
Received: from [192.168.37.1] (ovpn-0-14.rdu2.redhat.com [10.22.0.14])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D40312166B26;
	Tue, 28 Nov 2023 15:30:42 +0000 (UTC)
From: Benjamin Coddington <bcodding@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Subject: READ CAPACITY for unregistered while PR EARO
Date: Tue, 28 Nov 2023 10:30:41 -0500
Message-ID: <E48201E1-BCCD-4D1D-8354-3EBB45BAC199@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Hey SCSI experts,

Am I right to assume that /all/ SBC commands (I'm interested in READ
CAPACITY) should return CONFLICT to an unregistered I_T nexus when the
device server has Persistent Reservation, Exclusive Access - Registrants
Only?

I have access to SPC-4; table 66 only talks about SPC commands.

If so, I think it might make sense to call sd_revalidate_disk() directly
after a successful pr_register.

Ben

