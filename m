Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A866136E
	for <linux-scsi@vger.kernel.org>; Sat, 22 Mar 2025 18:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742668718; cv=none; b=TYjeSLZLvIxHaGXLb3Igl5ucUaGtj52SySibOXTs2aAU/vaRECY36DwufpNjn5cx4+YmcYrOPMk/vnKe33sCfyEHarY3zOpRO9elPLgOVVBjZs0vGjRoBOopNZmMVQsWvNEr8U6pMeJfq+7s5zmAvwa0mKHGnD2AilNavWp5o4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742668718; c=relaxed/simple;
	bh=2Ayc82LXvMOitT2jBk391etxSUK8WFv7mTX48LTjfRo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=VigXGX7SFQXS1Q2QutCc+dOS5QlznIZgq07QvzqzEADrwHHUI+tzVLvztvyp+Co8r4pBfwWulQfvfyd0/Gaw5ChdixLAh9sl8fZ8zwA5kz49z9E5lEyGkJNekNfWtkOjnBIBBUq6Fd28H0IwHFG/fTLnKsPduVwgA4EuVUUy+8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YMiLw/ca; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YMiLw/ca"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742668715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HjmqsZic8F6pok1V8tPNcP29PcZzKCFUUUgtorZkTac=;
	b=YMiLw/caQXK7SY2ZqgkfznucV3YYZHmtQRlRWqjjHWGvCBVsgds1OcoJWpib80FGJeDUW8
	hP7/2uMO6nnMsAz+zPQh1KJvTopUs/Zk+AnfPjRnY8Pqdl2ehpfB0CMBLH1OzANZEhycNv
	xMNZj+K8SFe6J1s9T2mAziPPRVmt/i8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-612-gWEwZ-fsO9qqTGUezswOEQ-1; Sat,
 22 Mar 2025 14:38:33 -0400
X-MC-Unique: gWEwZ-fsO9qqTGUezswOEQ-1
X-Mimecast-MFC-AGG-ID: gWEwZ-fsO9qqTGUezswOEQ_1742668712
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9642B1903081;
	Sat, 22 Mar 2025 18:38:32 +0000 (UTC)
Received: from [10.22.80.230] (unknown [10.22.80.230])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 97621180B486;
	Sat, 22 Mar 2025 18:38:30 +0000 (UTC)
Message-ID: <6fc92ed7-5656-4cef-9f36-fd2d37e56e12@redhat.com>
Date: Sat, 22 Mar 2025 14:38:29 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
Subject: [LSF/MM/BPF TOPIC] Multipath bio vs. request
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 dm-devel@lists.linux.dev
Cc: Samuel Petrovic <spetrovi@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

I will be presenting on this topic at LSF/MM/BPF this year, in the IO track.

Here's an introduction for my talk.

DMMP currently supports two different kernel IO interfaces: the BIO interface[1] (struct bio) and the Request interface[2] (struct request).
By default DMMP uses the Request interface and over the years much work has been done test and improve the performance of the DMMP Request
interface. DMMP can also be manually configured to use the BIO interface. The DMMP BIO interface is supported but little work has been done
to test and improve its performance. DMMP is currently the only upstream component which continues to use the Request interface for submitting IO.

At the ALPSS 2024 conference last October we discussed the possibility of deprecating and eventually removing support the Request interface
as kernel API. Such a change could impact DMMP so I was asked if Red Hat would be willing to support the effort by measuring the performance
of DMMP's BIO interface[3] and comparing it to its Request based performance. Having such a comparative performance analysis would be very helpful
in determining what further changes might be needed to move DMMP away from using the Request interface. This would help with the overall effort
to improve BIO interface performance and eventually remove support for Request based IO as a kernel API.

In this presentation I will share the preliminary results of Red Hat's DMMP BIO vs Request performance tests[4] and discuss what the next possible
steps could be for moving forward.

The tests and performance graphs in this presentation were developed and run by Samuel Petrovic <spetrovi@redhat.com>.
Credit goes to Samuel for creating these performance tests and many thanks to Benjamin Marzinski <bmarzins@redhat.com>,
Mikulas Patocka <mpatocka@redhat.com> and others on the Red Hat DMMP and Performance teams who contributed to this work.

[1] https://lwn.net/Articles/736534/
[2] https://lwn.net/Articles/738449/
[3] https://lore.kernel.org/linux-scsi/643e61a8-b0cb-4c9d-831a-879aa86d888e@redhat.com
[4] https://people.redhat.com/jmeneghi/LSFMM_2025/DMMP_BIOvsRequest/

-- 
John A. Meneghini
Senior Principal Platform Storage Engineer
RHEL SST - Platform Storage Group
jmeneghi@redhat.com

