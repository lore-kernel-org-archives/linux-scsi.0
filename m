Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649511A76BB
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2025 09:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753782197; cv=pass; b=LuKafbv6eM+8wwFpwZmU2o9yhl1q92Aq5HfJJCC0j0e0Y4zIbD++UkCSlCpPn0aMGh19xbV87FMil4VoXgBLbK9DDL6by63a2iz8y1w5IZ+vpJxKDQIHZ6pH+dduGx2aMHCg29nWAbHIrysPlIUmdg5UOQBBJ1jMUPl3WZ4qmOA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753782197; c=relaxed/simple;
	bh=/8FNLYmU3Y+SldEx5dHrhpue5/hGTJJKb9AuzxJbu+U=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:Cc:
	 In-Reply-To:Content-Type; b=BjrUTtUoUv4z1xFyDKCKa6MVlxAMwSjTPURvRFuyPFb5NCpISYsZw5SvUzdVyf+OWzf2xkvht5ARlHAzTbCyR05fNA9eEus2agu+Z/gSGYH5Pd7xcZjZfDgqcJu4JhLsZHlMXs3MWXN2TWsn8/fRBCEVZuDUV0X/GNnNa2recq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=garloff.de; spf=none smtp.mailfrom=garloff.de; dkim=pass (2048-bit key) header.d=garloff.de header.i=@garloff.de header.b=ZRR9gIUw; dkim=permerror (0-bit key) header.d=garloff.de header.i=@garloff.de header.b=CYct/AKu; arc=pass smtp.client-ip=85.215.255.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=garloff.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=garloff.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=garloff.de header.i=@garloff.de header.b="ZRR9gIUw";
	dkim=permerror (0-bit key) header.d=garloff.de header.i=@garloff.de header.b="CYct/AKu"
ARC-Seal: i=1; a=rsa-sha256; t=1753781830; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=VDETIZj02B97LWKVuGFRCV/VLSTKrSTWVW+D+/sw0oRWc2DbqjMIMoBfmbayLIRix+
    qSNfXucPrkErGj7BXjZZGzovNY1APdMUgdtao7UNwd8zfOAfttY88+YVB3ruFnUee9Zl
    hXSPCo3U44yI77Hw6E9xapybGNcmMSxq/ywaoZHfVWDl95557TY2t+MymbZsuuQRTkKV
    w1Owki7v5BL5Gw1IKoWXLD7bPPVw2uz0DYvl8XDfsCyPIdQh5flY+w1PochckTtKhoNE
    YTWGpt7zWPA8xjL9Yo+qkk2ffeL54bKXSXTQQ540nWDq5PIEK9tRqCCnQx55B4dB1+Nq
    vqjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1753781830;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:Cc:References:To:From:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=8iItuTREvtrZA5OfdSVjpdZ+QrxhITdbyG9UcPtlYV4=;
    b=e1TdkcYwjK9/TAA7fda0LEFqk49z5nwA0mI+l/glUHD6rxonC+QXgWTDzVEougDRfW
    SUbHkiSDYB6PKu7vRUW3+AIp1bN3/SXtjnz7eKx3+Ch6juau+oL7tqDV6VYpPNGwgVA0
    q25IkEvkY5JG6t9vsmIo59KziY55m1xRntWgVUGBKtRfmI3rS9O7fm8uNi5CDzBZ+tOY
    +ufZFKVi5xbOgz22dTBxmTw8iJkdFTIiHl9apFmxtW5ws4/r/RaPICtT0Sm9i9cR3kvh
    2Ct94ormm5/V9eDwwsHLoTXLpotV8PN4T+NmlWMXrwX4KOtTNTeejwYiG76shxzi9Gwx
    8QSA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1753781830;
    s=strato-dkim-0002; d=garloff.de;
    h=In-Reply-To:Cc:References:To:From:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=8iItuTREvtrZA5OfdSVjpdZ+QrxhITdbyG9UcPtlYV4=;
    b=ZRR9gIUw5y5SoFII+3F8q+9+dxsX12XUJYWlzyTUjAc/sPlLAOuEwXK6S75nu5b5Dg
    JIKIQg3Q0azFVALsztOG6CMQKpr31Rt6XPAvmacJ3aL4Dw64sZ/iltJK5aLuEWk/MCmb
    ofMw+XZkdTS0CReFUJEuRXsK2FDSEa9eTIZxiDaNAGaeCdr2vkWbbnHPUq7YJ/ocojuE
    rhHNUBmWT0dRLIS98g0CByLb8TtRd1cuLZ3Y4Y+NmM2r3WXJhTlT8qdKoXsre7tA2mYy
    G652/hEVY3tdBY+/7ZKOlB95h3192R4Nlzidq2ce2WVHdHC2NSCZwEjLsTjjUNdvrGzV
    yLhg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1753781830;
    s=strato-dkim-0003; d=garloff.de;
    h=In-Reply-To:Cc:References:To:From:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=8iItuTREvtrZA5OfdSVjpdZ+QrxhITdbyG9UcPtlYV4=;
    b=CYct/AKuLuVICKCLsQcn7GdsKBRhVN0KusCsh9Srr7VCUoQbMz8NH+090Ad+aI+Upp
    HBIOn4FqF6AlCcY+WNAw==
X-RZG-AUTH: ":J3kWYWCveu3U88BfwGxYwcN+YZ41GOdzUdLW+J8VEEt2iJSgSWY4hojoXxE="
Received: from mail.garloff.de
    by smtp.strato.de (RZmta 52.1.2 DYNA|AUTH)
    with ESMTPSA id L60c3716T9bAhax
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 29 Jul 2025 11:37:10 +0200 (CEST)
Received: from [192.168.155.137] (ap5.garloff.de [192.168.155.10])
	by mail.garloff.de (Postfix) with ESMTPSA id 1239462481;
	Tue, 29 Jul 2025 11:37:10 +0200 (CEST)
Message-ID: <1b21d928-7b4d-4f97-b0c1-7cf9536f393a@garloff.de>
Date: Tue, 29 Jul 2025 11:37:07 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Patch [0/3] Support eager_unmap for non ldpme sd devs
From: Kurt Garloff <kurt@garloff.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <936a460e-eacd-40a8-834a-76021bf3ce8c@garloff.de>
 <yq1ms8nlhtk.fsf@ca-mkp.ca.oracle.com>
 <ccc3be81-1c8a-4960-a340-bd424749de55@garloff.de>
 <10f05317-4282-4d1d-be6d-ea110ce2d54f@garloff.de>
Content-Language: en-US
Cc: linux-scsi@vger.kernel.org
Autocrypt: addr=kurt@garloff.de; keydata=
 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
In-Reply-To: <10f05317-4282-4d1d-be6d-ea110ce2d54f@garloff.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 29.07.25 11:15, Kurt Garloff wrote:
> with attached script in /usr/local/sbin/set-unmap.sh*
> *It's somewhat error proof, but probably would not have hit the mark
> yet for inclusion into a Linux distro.*

Well, and add a true into the debug function.
Apparently bash thinks that an empty function is illegal.

Cheers,

-- 
Kurt Garloff <kurt@garloff.de>, Cologne

