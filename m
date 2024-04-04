Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1706212D1EF
	for <linux-scsi@vger.kernel.org>; Thu,  4 Apr 2024 21:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712267606; cv=none; b=YOtUWlpGVnjzXV1NrhdHcJh2ue7mbRMXiejrq4eW57V4kAXcAlebFWLpve/wLtjXNlwqXFNzK4H1NlRlQp3HqJN11VJSKKWVVtQdAEz/9iI8fd7m94AuH7VOSocFDJJgIuMW3kDvCR5AOhzv4G4B5xt5TvMGM0R68CGRJJBHC+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712267606; c=relaxed/simple;
	bh=qvuse+JI0WC/+oJA2ocx7xcO3l64efil1MyjASMhEDk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EQj/m/fgwPYBrSPq1C43pKSV6ZMmUmDRZxGFNiF7WG3Ci31HHdMmWefiFCGiYiwg1m7IqzjMPEcMJGL+49Qa9CxB3g7mI/GmZKi6xFCPZ4dlYBxVptaXSnwFJeviRZ94y2wcNbTab1WOiMeofjv5X+LCn01t18JxcvG1EAh+zcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=nedrbwV+; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=DJOKGPSA; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="nedrbwV+";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="DJOKGPSA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1712267603;
	bh=qvuse+JI0WC/+oJA2ocx7xcO3l64efil1MyjASMhEDk=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=nedrbwV+8udQLGnHBnt+QVmGLUwUCfo7pzHAWHyog38UyFQKAObj26gUTCzj8+MQ9
	 TLn/3qlDpQWRRp0HVDuQOMw2AYcNLhVKqw5BWKY56YY3ek2hRr6O3mu41iC/2Sym8Q
	 IzU4jzG/f0yC1iMjhFmtWjP6Ud+aRSJqFG0skb8o=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 2D7491280BEA;
	Thu,  4 Apr 2024 17:53:23 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id QcYsxbqsoZ15; Thu,  4 Apr 2024 17:53:23 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1712267602;
	bh=qvuse+JI0WC/+oJA2ocx7xcO3l64efil1MyjASMhEDk=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=DJOKGPSAdXfldCSNM67gXslTcqw+xmVcGc0smaRrMpE3B67ryECyUA3U4WQSRo4oF
	 eOkWhQs/0Jv2I+6So1cH0zhB05sKAREDZwFY6W9ULko5qJWe9pWuZWW2oVvNq1bMVa
	 BOj9Y6/EPEZSz6P0XcZTcHrMqwjCUieE4oOwF+Iw=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 5F0061280BDD;
	Thu,  4 Apr 2024 17:53:22 -0400 (EDT)
Message-ID: <5ac64c472d739a15d513ad21ca1ae7f8543ad91c.camel@HansenPartnership.com>
Subject: Re: startup BUG at lib/string_helpers.c from scsi fusion mptsas
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Justin Stitt <justinstitt@google.com>, Charles Bertsch <cbertsch@cox.net>
Cc: linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com
Date: Thu, 04 Apr 2024 17:53:20 -0400
In-Reply-To: <CAFhGd8pTAKGcu2uLzUDDxto1sk5-9zQevsrXp-xL0cdPcGYaGg@mail.gmail.com>
References: <5445ba0f-3e27-4d43-a9ba-0cc22ada2fce@cox.net>
	 <CAFhGd8pTAKGcu2uLzUDDxto1sk5-9zQevsrXp-xL0cdPcGYaGg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2024-04-04 at 14:38 -0700, Justin Stitt wrote:
[...]
> I am not sure how my patch [1] is triggering this fortify panic. I
> didn't modify this printk or the string arguments (ioc->name), also
> the change from strncpy to strscpy did not introduce any strnlen()'s
> which seems to be the thing fortify is upset about:
> "2024-04-01T19:18:28.000000+00:00 zGMT kernel - - - detected buffer
> overflow in strnlen"
> or
> "2024-04-01T22:23:45.000000+00:00 zGMT kernel - - - strnlen: detected
> buffer overflow: 9 byte read of buffer size 8"

it's sitting in the definition of sized_strscpy in fortify-string.h

Since the fields in question aren't zero terminated there's a bad
assumption that you can do strnlen on the source field.

James

