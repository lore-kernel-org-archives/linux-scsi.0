Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2949610D
	for <linux-scsi@vger.kernel.org>; Sun, 27 Jul 2025 18:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753639606; cv=pass; b=oH81aE+2CLz33Q9Sr+I9toS9A3o4wPeAOIgq6XF2ICXTvB8LyBoN/VMGiNcOVBA0+vDRBAUSV5pvhHunK7y+w+UhWWiy4z89Q0rcvzGF6uFSVw/Qm2A7HBeXfVyER44ekuh/S4CsyyiyauebuqzJi5/XUxgbyEWhWYrS1GPg5EE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753639606; c=relaxed/simple;
	bh=p0KNEe8E+fzDlhJpSHPwOfC7judgBKjRrta1bCUBO58=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=bxNWbR0JjY+QGaC1b4sDxj3C5B3MABUE9RhRdOw5VcyNaYpDfvZn1+RUtl4nrVVejz/QCB54dbOE1VROr821LylID6NNtmoRKQ/epgEcBS5wBYJ3IJpJCt5RkaE7Ileg2gWe0zF4B4mEvGm/hrArejkgz03CtCPNYWpU9VA9Rls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=garloff.de; spf=none smtp.mailfrom=garloff.de; dkim=pass (2048-bit key) header.d=garloff.de header.i=@garloff.de header.b=EInEXTUv; dkim=permerror (0-bit key) header.d=garloff.de header.i=@garloff.de header.b=GhksvSse; arc=pass smtp.client-ip=85.215.255.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=garloff.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=garloff.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=garloff.de header.i=@garloff.de header.b="EInEXTUv";
	dkim=permerror (0-bit key) header.d=garloff.de header.i=@garloff.de header.b="GhksvSse"
ARC-Seal: i=1; a=rsa-sha256; t=1753639601; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=rmnLYcz2U+Qp03AEAUehYZ+XXQbausVtH4NGRya7dl7P8YJC5g0H9MCNQzTayuxDNp
    bY4FWnMfhS5P57HukpqryobD0D0n8oxhhG8Ul7Rb3BINsWkyxDWKv1jh3wOWt3t7LJY4
    CHCuePWnq2qI6HkMbGZTNRlqX1bARG0QpTM6vDZmJ/q0Kwj0BW9+1spoQT2txAWQteui
    HxUnSiGYpCpPl+FTAy6SRKq54TWtLNtCfXEq3PLlpbrnX6ZXzWLVEjQp9EAIR93wdqDP
    rKpEVnKqru4dy3vwPEIXZMbDiijeUSXmsnT4rAU0oscAyHoog3ygqzCVPHoWS0mbvoXC
    ygAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1753639601;
    s=strato-dkim-0002; d=strato.com;
    h=Subject:From:To:Date:Message-ID:Cc:Date:From:Subject:Sender;
    bh=0J5JV5wr8LRcgkj8Qv57bDe3YKMXirdEo4W8bmBAs+w=;
    b=gKQ2wp/l7TyIspxuD7QLgLd2HoSXOAiG1Y+TJhgh8f/LRXEDigdEo8sWpx9Ez+qVYe
    SuNfV4kt6rwOZwxK1JY5wYiug3Oy9PhmJ2xksp+/vduwlAmeam+gr851MAvE6xhw5z6w
    lGzjz0KDb5wObnJvlePULa7r02FD2zLdCHuwhHlxlMsNHvZqgR+6qw+ODAJl0pFhXWAo
    6r5IMCjPPjWmAemG+fRpqhZKzb7s42lI3IBgpmJg9sTQcSVqQjWtCRtK/8xIV6kbeba4
    ri0yRoqGP92E25/OUPZv1GW/qNK7oRfJ3JrB2qHu3ml7HJ8K8ahy/OM5JbkAreHgCxPq
    7GXg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1753639601;
    s=strato-dkim-0002; d=garloff.de;
    h=Subject:From:To:Date:Message-ID:Cc:Date:From:Subject:Sender;
    bh=0J5JV5wr8LRcgkj8Qv57bDe3YKMXirdEo4W8bmBAs+w=;
    b=EInEXTUvLv2+5gNkxVs1s2TUuE+eeAYb11fqQOQRR6hTcYBRKvjqlc0Yh+fvpJnEeI
    jfPYAxqFwzKnJlhGz0apEoQhqcJXkjZbWhxRaIwNxS4ZcD5ewEKlEAogZDyqdieOeNFn
    lJRhtLSQe4CZqX8ZtD7b6p3cNurBe0aNwMoDFafAIrweBSGCKMJuw0EdCdW2ZkN5Rqs0
    ADBg5f0msINBbfNy7vIhRXQIpuyz7T6eU4wyRj+jX/D+5NX65M2/9VSjIXmNeOXRyOJ0
    vGWeaE5CDs303WsOcrODMvQwv0Aiz79gqqSqImTegeHXY6D9vqsrZPajfP4/kG1xkSZG
    Xkhw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1753639601;
    s=strato-dkim-0003; d=garloff.de;
    h=Subject:From:To:Date:Message-ID:Cc:Date:From:Subject:Sender;
    bh=0J5JV5wr8LRcgkj8Qv57bDe3YKMXirdEo4W8bmBAs+w=;
    b=GhksvSseMUaocu0Wl8C/3qu85zTfbbIKjQ+PUQSxXyzR1MSPNSH6yJiNIufT8DKfmV
    Qzv3uzpBD180JeYbfHCA==
X-RZG-AUTH: ":J3kWYWCveu3U88BfwGxYwcN+YZ41GOdzUdLW+J8VEEt2iJSgSWY/glqoxjGO"
Received: from mail.garloff.de
    by smtp.strato.de (RZmta 52.1.2 DYNA|AUTH)
    with ESMTPSA id L60c3716RI6fbCU
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate)
    for <linux-scsi@vger.kernel.org>;
    Sun, 27 Jul 2025 20:06:41 +0200 (CEST)
Received: from [192.168.155.137] (ap5.garloff.de [192.168.155.10])
	by mail.garloff.de (Postfix) with ESMTPSA id 32F9C62479
	for <linux-scsi@vger.kernel.org>; Sun, 27 Jul 2025 20:06:41 +0200 (CEST)
Message-ID: <936a460e-eacd-40a8-834a-76021bf3ce8c@garloff.de>
Date: Sun, 27 Jul 2025 20:06:38 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-scsi@vger.kernel.org
From: Kurt Garloff <kurt@garloff.de>
Subject: Patch [0/3] Support eager_unmap for non ldpme sd devs
Autocrypt: addr=kurt@garloff.de; keydata=
 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
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

(Resent, the original message was not text/plain only. It's too long
that I have interacted with linux MLs, sorry.)

I had to do some rearrangement of NVMe drives over several of my
machines recently. I was using a few USB NVMe enclosures for this.
One of the things that was annoying was that I had no way to discard
free space using fstrim (or with blkdiscard or mkfs / mkswap options).

The SCSI disk driver (sd_mod) would just claim that discard is not
supported. It's not true. The NVMes support it as do the enclosures.
I have a few, though all have variants of RTL9210 chips.

But sd was too conservative to let me do it.

Attached series of patches address this. (Patches are against 6.16.0-rc7.)

1/3: Introduces an eager_unmap module parameter which lets the sd driver
      unmap/ws16/ws10 capabilities and issue these commands even for
      devices without ldpme support (thin provisioning). The VPD pages are
      being queried for all devices advertising SBC >= 3 to avoid breaking
      old hardware that might barf of being asked for VPDs.
2/3: Makes the approach more conservative by guarding the requesting of
      VPD pages also on eager_unmap being set. With this patch, the default
      behavior is the same as before the eager_unmap patches unless the
      parameter is set to non-zero.
3/3: This changes the default of eager_unmap to 1. It should be safe based
      on the SBC >= 3 protection, but it's hard to know for sure with all
      the possible broken hardware out there. So leave the parameter for
      admins that need to set it to 0. In case we have significant fallout,
      this is the one patch that would need to get reverted.

I have been running kernels with variants of these patches for over a year
now.

PS: Please copy me one responses, I have stopped being subscribed to
LKML and linux-scsi a long time ago. Sorry!

-- 
Kurt Garloff <kurt@garloff.de>, Cologne

