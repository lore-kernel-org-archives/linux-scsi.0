Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B927260D
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2025 09:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.163
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753780567; cv=pass; b=NVWeO5gL8XZdxMO/jIDQ8jj6T+EsxZd16xX1vwEKVrk9IJRZ+LzyfHOeMMFPihmYIYlIw9C5fYu16L8SlSujtc9tDJd3YOJjagLZbJ/mKgX6+6OxSh53PJ4Gy+wRWKDAs6fqjSC1OiSgeA1/oSRn0PW6E2GRLxBr82PChBZx9MI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753780567; c=relaxed/simple;
	bh=gnxLK+Idk1X7eBdv0h4lN+uGShYIHJKhajpWUIvbYTA=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:From:To:Cc:
	 References:In-Reply-To; b=RwrrrG950XfMJdH5hndyHZ8C7erwD2sNmmDMxFGz6Vfr6Can9T1caeciffojXFIl1xPOJOXGIsjT1eVgn/AAs97uLOijDWDhhVhlI9rOzz4Z+zgQboiGAnB7H4PKLtalSNJadQ5wz5vVe/cxbiI2EmT+eJWbPyxa83Ynsz7ASxc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=garloff.de; spf=none smtp.mailfrom=garloff.de; dkim=pass (2048-bit key) header.d=garloff.de header.i=@garloff.de header.b=s1XU+9jZ; dkim=permerror (0-bit key) header.d=garloff.de header.i=@garloff.de header.b=PMdzP16p; arc=pass smtp.client-ip=81.169.146.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=garloff.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=garloff.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=garloff.de header.i=@garloff.de header.b="s1XU+9jZ";
	dkim=permerror (0-bit key) header.d=garloff.de header.i=@garloff.de header.b="PMdzP16p"
ARC-Seal: i=1; a=rsa-sha256; t=1753780556; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=FgsM0kDtezG17vfqaE3zEgCaPT/IvpGZLRjGGg3PhSS+7MMAoDu17qWK+jPhVS47vN
    w4pGRqyzHffmyVYVEl0tMGoqJXs06kC47KQR2M0ygnC021uZM9KBtPLX7ZJ7JTfg6uMO
    1KvgZxMIo5vDb580cRB5ptHNWDpioxO4yekPMCb505V7gtJWUV032+s2u0P6tageGXcY
    /WyL9t0NwwBQGIUbVVFw7tZJpOSVjvAxTIMWTZ/hu+Xtvu9+RKUj0lmrapIuTXRaYNkO
    UI+OAewJt6bNr/KIr/96LyUdBi6SELHP9N7lECj0q4nIkW9tUbSRT49bTVdBpXreJnl5
    ++gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1753780556;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:References:Cc:To:From:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=cPfjSrBbrejbczsKmpAosvyRWJ0Sv7+00YYfwRyrrBM=;
    b=e+nTmcTCnosAnOJzPWKJt2oPgTX73GDgI6PPNG3h6/DNsNRUhGVQ7wMJH9qduclBhl
    4waJ87RzBigqYUu9EY+ClKy3Qmef4dxRCtU5Kef3WXN90FyhbPMP6gNucVn6Spvy9kaO
    QLi1TZFk0B0PZ4wcEX5DPptte1T/MeyXntPJGrBqd8tr3DHhllB54B8yIGEkLOor18kg
    cMsWdPJliHCWhJJuMY1QpvABAYPQuKo9BKUc/2+brcY4yAefO4Q1gQy48zVhWn90u7PO
    CKpCBoci7WdFnC8/TYajLrgDx+4wSub9DWlws4p9B2uPrfy2wS0Xbh9+zR7AOjB1/PHx
    bWsg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1753780556;
    s=strato-dkim-0002; d=garloff.de;
    h=In-Reply-To:References:Cc:To:From:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=cPfjSrBbrejbczsKmpAosvyRWJ0Sv7+00YYfwRyrrBM=;
    b=s1XU+9jZdAeAxrog/E7VRzEPW3+YEB25Dqg8q3ep+FVbLvs4VknpKMC3xx8bOXsmxS
    sdriO1e69n7itEUhsEHXatNM7MMyOUXFmmXDiqlSqhJgFzd71fiJPjanO7yJkPppLkpW
    TyfSr3G9614OT4jqmTZGvshfHsXad1y5wbvuXMJddrgS8qDmv9mC/V3KeG32roBucMbT
    6RRSuxgSyJfW4kE5oUXcDxUtyvA06i7lFjN63V7kpz3HTQv/4LGgwTed1QMwL/sXY5SB
    TUu5zAcpxpK8J7qfa3IZhHnaO4Ko8FvmiW+xn9wLBPtSLlLTptmhQZRGw+EgnVQcag7I
    iS2w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1753780556;
    s=strato-dkim-0003; d=garloff.de;
    h=In-Reply-To:References:Cc:To:From:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=cPfjSrBbrejbczsKmpAosvyRWJ0Sv7+00YYfwRyrrBM=;
    b=PMdzP16pQ5f5/dkXfil5pjLhdNPSORDlOJCCqqVICPKl9hGrC+DBWH+6qYTYIECg3m
    25sE5cKOJC/ARG5KS+Bg==
X-RZG-AUTH: ":J3kWYWCveu3U88BfwGxYwcN+YZ41GOdzUdLW+J8VEEt2iJSgSWY4hojoXxE="
Received: from mail.garloff.de
    by smtp.strato.de (RZmta 52.1.2 DYNA|AUTH)
    with ESMTPSA id L60c3716T9FthUS
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 29 Jul 2025 11:15:55 +0200 (CEST)
Received: from [192.168.155.137] (ap5.garloff.de [192.168.155.10])
	by mail.garloff.de (Postfix) with ESMTPSA id 5456562481;
	Tue, 29 Jul 2025 11:15:55 +0200 (CEST)
Content-Type: multipart/mixed; boundary="------------2XvFPTgBa1cicjtBzo4xTSVk"
Message-ID: <10f05317-4282-4d1d-be6d-ea110ce2d54f@garloff.de>
Date: Tue, 29 Jul 2025 11:15:53 +0200
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
Cc: linux-scsi@vger.kernel.org
References: <936a460e-eacd-40a8-834a-76021bf3ce8c@garloff.de>
 <yq1ms8nlhtk.fsf@ca-mkp.ca.oracle.com>
 <ccc3be81-1c8a-4960-a340-bd424749de55@garloff.de>
Content-Language: en-US
Autocrypt: addr=kurt@garloff.de; keydata=
 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
In-Reply-To: <ccc3be81-1c8a-4960-a340-bd424749de55@garloff.de>
Content-Transfer-Encoding: 7bit

This is a multi-part message in MIME format.
--------------2XvFPTgBa1cicjtBzo4xTSVk
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 29.07.25 09:32, Kurt Garloff wrote:
> Remaining question is whether we'd recommend users to use
> a set of udev rules to fix up or whether we have a sd_mod
> parameter to ignore LBPME (if LBPU/LBPWS/LBPWS10 are set)
> or even ignore it by default (and only provide an opt-out
> parameter).

I should probably mention that doing it via udev is complex.

ACTION!="add", GOTO="usb_nvme_end"
SUBSYSTEM=="usb_device", GOTO="usb_nvme_start"
SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", GOTO="usb_nvme_start"
GOTO="usb_nvme_end"

LABEL="usb_nvme_start"
# Realtek 9210 USB-NVMe bridge
ATTR{idVendor}=="0bda", ATTR{idProduct}=="9210", 
RUN="/usr/local/sbin/set-unmap.sh"
# More USB IDs to follow here

LABEL="usb_nvme_end"

with attached script in /usr/local/sbin/set-unmap.sh*
*It's somewhat error proof, but probably would not have hit the mark
yet for inclusion into a Linux distro.*
*

Patching sd would seem easier ...*
*

-- 
Kurt Garloff <kurt@garloff.de>, Cologne

--------------2XvFPTgBa1cicjtBzo4xTSVk
Content-Type: application/x-shellscript; name="set-unmap.sh"
Content-Disposition: attachment; filename="set-unmap.sh"
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKIyAKIyB1ZGV2IGhlbHBlciB0byBzZXQgcHJvdmlzaW9uaW5nX21vZGUg
dG8gdW5tYXAvd3JpdGVzYW1lXyoKIyBmb3IgTlZNZSBkaXNrcyBmcm9tIGEgVVNCIGVuY2xv
c3VyZS4gVGhlIE5WTWUtU0NTSSB0cmFuc2xhdGlvbgojIGRvZXMgbm90IHNldCBMQlBNRSBh
bmQgdGh1cyB0aGUgU0QgZHJpdmVyIGRvZXMgbm90IHJlc3BlY3QKIyB0aGUgdW5tYXAvd3Jp
dGVzYW1lXyogY2FwYWJpbGl0aWVzLgojIFdlIGNhbiByZXRyaWV2ZSB0aGUgTEJQViBWUEQg
cGFnZSBvdXJzZWx2ZXMgYW5kIHNldCB0aGUgZmxhZ3MKIyBhY2NvcmRpbmdseSwgY29tcGVu
c2F0aW5nIGZvciBTRCBub3QgdHJ1c3RpbmcgTEJQVS9MQlBXUyovTEJQUlouCiMKIyAoYykg
S3VydCBHYXJsb2ZmIDxrdXJ0QGdhcmxvZmYuZGU+LCA3LzIwMjUKIyBTUERYLUxpY2Vuc2Ut
SWRlbnRpZmllcjogR1BMLTIuMC1vci1sYXRlcgojCmNkIC9zeXMvJERFVlBBVEgKQk5NPSQo
YmFzZW5hbWUgJERFVlBBVEgpCiMgRGVidWdnaW5nCiNzZXQgPiAvcm9vdC9zZXQtdW5tYXAu
ZGVidWcKZGVidWcoKQp7CgkjIGVjaG8gLWUgIiRAIiA+PiAvcm9vdC9zZXQtdW5tYXAuZGVi
dWcKfQoKIyBFeHRyYWN0IHZhbHVlIGZyb20gVlBEIGR1bXAgaW4gIiQyKyIgZm9yIGZsYWcg
IiQxIiBhbmQgc2V0IGVudiAkMQpwYXJzZV92cGQoKQp7CglGTEc9IiQxIgoJc2hpZnQKCVZB
TD0kKGVjaG8gIiRAIiB8IGdyZXAgIigkRkxHKToiIHwgc2VkICJzL14uKigkRkxHKTogXChb
XiBdKlwpLipcJC9cMS8iKQoJZXZhbCAkRkxHPSRWQUwKfQoKIyBTZXQgcHJvdmlzaW9uaW5n
IG1vZGUgdG8gJDEgYWNjb3JkaW5nIHRvIHZhcnMgTEJNUFUsIExCUFdTLCBMQlBXUzEwLCBM
QlBSWgpzZXRfcHJvdigpCnsKCWlmIHRlc3QgIiRMQlBVIiA9ICIxIjsgdGhlbgoJCWVjaG8g
InVubWFwIiA+ICQxCgkJZGVidWcgdW5tYXAgJDEKCWVsaWYgdGVzdCAiJExCUFdTIiA9ICIx
IjsgdGhlbgoJCWVjaG8gIndyaXRlc2FtZV8xNiIgPiAkMQoJCWRlYnVnIHdzMTYgJDEKCWVs
aWYgdGVzdCAiJExCUFdTMTAiID0gIjEiOyB0aGVuCgkJZWNobyAid3JpdGVzYW1lXzEwIiA+
ICQxCgkJZGVidWcgd3MxMCAkMQoJZWxpZiB0ZXN0ICIkTEJQUloiID0gIjEiOyB0aGVuCgkJ
ZWNobyAid3JpdGVzYW1lX3plcm8iID4gJDEKCQlkZWJ1ZyB3c3ogJDEKCWZpCn0KCnByb2Nl
c3NfZGV2cygpCnsKCWZvciBjaGlsZCBpbiAke0JOTX0qOyBkbwoJCWZvciBob3N0IGluICR7
Y2hpbGR9L2hvc3QqOyBkbwoJCQlmb3IgdGd0IGluICR7aG9zdH0vdGFyZ2V0KjsgZG8KCQkJ
CWZvciBsdW4gaW4gJHt0Z3R9LypcOipcOipcOio7IGRvCgkJCQkJaWYgdGVzdCAhIC1kICRs
dW4vc2NzaV9kaXNrOyB0aGVuIGNvbnRpbnVlOyBmaQoJCQkJCWZvciBkc2sgaW4gJGx1bi9z
Y3NpX2Rpc2svKlw6Klw6Klw6KjsgZG8KCQkJCQkJI2RlYnVnIERpc2sgJGRzawoJCQkJCQly
ZWFkIHRoaW4gPCAkZHNrL3RoaW5fcHJvdmlzaW9uaW5nCgkJCQkJCXJlYWQgcHJvdiA8ICRk
c2svcHJvdmlzaW9uaW5nX21vZGUKCQkJCQkJZGVidWcgJGRzayAkdGhpbiAkcHJvdgoJCQkJ
CQlpZiB0ZXN0ICIkdGhpbiIgPSAiMSI7IHRoZW4gY29udGludWU7IGZpCgkJCQkJCWlmIHRl
c3QgIiRwcm92IiAhPSAiZGlzYWJsZWQiIC1hICRwcm92ICE9ICJmdWxsIjsgdGhlbiBjb250
aW51ZTsgZmkKCQkJCQkJc2dkZXY9JChiYXNlbmFtZSAkbHVuL3Njc2lfZ2VuZXJpYy9zZyop
CgkJCQkJCUxCUFY9JChzZ192cGQgLXAgbGJwdiAvZGV2LyRzZ2RldikKCQkJCQkJcGFyc2Vf
dnBkIExCUFUgIiRMQlBWIgoJCQkJCQlwYXJzZV92cGQgTEJQV1MgIiRMQlBWIgoJCQkJCQlw
YXJzZV92cGQgTEJQV1MxMCAiJExCUFYiCgkJCQkJCXBhcnNlX3ZwZCBMQlBSWiAiJExCUFYi
CgkJCQkJCWRlYnVnICRzZ2RldiAkTEJQVSAkTEJQV1MgJExCUFdTMTAgJExCUFJaICJcbiIg
IiRMQlBWIgoJCQkJCQlzZXRfcHJvdiAkZHNrL3Byb3Zpc2lvbmluZ19tb2RlCgkJCQkJZG9u
ZQoJCQkJZG9uZQoJCQlkb25lCgkJZG9uZQoJZG9uZQp9CgojIE5lZWQgdG8gd2FpdCBmb3Ig
U0QgZHJpdmVyIHRvIGF0dGFjaApzbGVlcCAxMApwcm9jZXNzX2RldnMKCg==

--------------2XvFPTgBa1cicjtBzo4xTSVk--
