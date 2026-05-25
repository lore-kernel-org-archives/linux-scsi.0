Received: from mta.al2klimov.de (mta.al2klimov.de [162.55.223.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E9F35E1C0;
	Mon, 25 May 2026 07:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.55.223.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779695517; cv=none; b=dlxmzhaYU9G3XRJ7/TLcrq3RBHgNKLVpBjQm03apIDtcZAcaVvTrfhZSK4dDtPJDNEUgzWcLEJChLMJ7tkLq0GJyv6T0UY7jqhonJTnzPaVw4pKXYoCEXxZ3VppOvfP3XFiaNCxZtgdKJdyiFlDm7wB+ymfhALwNvmEn7oWzfsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779695517; c=relaxed/simple;
	bh=7vkntJXCJbvdd3VSxEyyNk+9+yRI/+MYuJIjWKOAguQ=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:References:To:
	 Cc:From:In-Reply-To; b=UvMqFCYnqqz6trYBz+wK9ivfIaPikpOOdRyA2i5hhPA4FI2HXjUTzqBpXVuiJwEjWIoYTdHXIUmsax4vtbLuCLc7JQf8cwLEu84fLFqCNb+55mwAVOhR2v+bnkmBKIqvBZ+kgPPEAHGzyzkV1jA3FW/hJgQUD3O+rUhoJ9Vfh44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=al2klimov.de; spf=pass smtp.mailfrom=al2klimov.de; dkim=pass (2048-bit key) header.d=al2klimov.de header.i=@al2klimov.de header.b=cVBvBqPj; arc=none smtp.client-ip=162.55.223.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=al2klimov.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=al2klimov.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=al2klimov.de header.i=@al2klimov.de header.b="cVBvBqPj"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; s=default; bh=7vkntJXCJbvd
	d3VSxEyyNk+9+yRI/+MYuJIjWKOAguQ=; h=in-reply-to:from:cc:to:references:
	subject:date; d=al2klimov.de; b=cVBvBqPjYdLBBSHQ1cl3QjteXcHGBWjOIPlaxA
	YZuCgL8fn4p33ga0Q3bzATuH233KzTACuOWeP50vkKfLVYpSQJYqCSS9tAtQ6ZSCRNuieO
	8KiqU1eHWSgUhKuWPEQkv65oVevFq+fUuKS7Nbj/sS2YBaJjPHmKZlAZ79Nl4UNRilWKzm
	CNoSzDv1A2KUE2puv9AUie+LdN1EhjFXUzCN72WhL9opFhumTuXKWNl1Ay0HLW6F25iuUc
	6gh4Q7eiPfdJhHwgGL9ul76rTWoRKo3dIvFNZ/upBwDU4ZzZjovGOG8egp8yeV4T7Q7ofE
	Rv1hTNtpJsX05SNziuBkBnZA==
Received: from [IPV6:2a02:2455:18e9:e011:4d8a:aad2:c25c:50e5] (2a02-2455-18e9-e011-4d8a-aad2-c25c-50e5.dyn6.pyur.net [2a02:2455:18e9:e011:4d8a:aad2:c25c:50e5])
	by mta.al2klimov.de (OpenSMTPD) with ESMTPSA id 569f89b0 (TLSv1.3:TLS_CHACHA20_POLY1305_SHA256:256:NO);
	Mon, 25 May 2026 07:51:47 +0000 (UTC)
Content-Type: multipart/mixed; boundary="------------0DzForRFz63YNg76telrfgRq"
Message-ID: <d382af7b-787c-4932-bec6-fea959cba512@al2klimov.de>
Date: Mon, 25 May 2026 09:51:46 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: qla2xxx: fix NULL deref, check user input
References: <df1ab843efe10888@mta.al2klimov.de>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "open list:QLOGIC QLA2XXX FC-SCSI DRIVER" <linux-scsi@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: "Alexander A. Klimov" <grandmaster@al2klimov.de>
In-Reply-To: <df1ab843efe10888@mta.al2klimov.de>
X-Forwarded-Message-Id: <df1ab843efe10888@mta.al2klimov.de>

This is a multi-part message in MIME format.
--------------0DzForRFz63YNg76telrfgRq
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I hate when this happens...


-------- Forwarded Message --------
Subject: Delivery status notification: failed
Date: Sun, 24 May 2026 18:04:33 +0000 (UTC)
From: Mailer Daemon <MAILER-DAEMON@mta.al2klimov.de>
To: grandmaster@al2klimov.de

     Hi!

     This is the MAILER-DAEMON, please DO NOT REPLY to this email.

     An error has occurred while attempting to deliver a message for
     the following list of recipients:

himanshu.madhani@oracle.com: Envelope expired
GR-QLogic-Storage-Upstream@marvell.com: Envelope expired
njavali@marvell.com: Envelope expired
martin.petersen@oracle.com: Envelope expired
qutran@marvell.com: Envelope expired

     Below is a copy of the original message:

--------------0DzForRFz63YNg76telrfgRq
Content-Type: message/delivery-status; name="Attached Message Part.tmp"
Content-Disposition: attachment; filename="Attached Message Part.tmp"
Content-Transfer-Encoding: 7bit

Reporting-MTA: dns; mta.al2klimov.de

Final-Recipient: rfc822; himanshu.madhani@oracle.com
Action: failed
Status: 5.4.7

Final-Recipient: rfc822; GR-QLogic-Storage-Upstream@marvell.com
Action: failed
Status: 5.4.7

Final-Recipient: rfc822; njavali@marvell.com
Action: failed
Status: 5.4.7

Final-Recipient: rfc822; martin.petersen@oracle.com
Action: failed
Status: 5.4.7

Final-Recipient: rfc822; qutran@marvell.com
Action: failed
Status: 5.4.7

--------------0DzForRFz63YNg76telrfgRq
Content-Type: text/rfc822-headers; charset=UTF-8; name="Attached Message
 Part.tmp"
Content-Disposition: attachment; filename="Attached Message Part.tmp"
Content-Transfer-Encoding: base64

REtJTS1TaWduYXR1cmU6IHY9MTsgYT1yc2Etc2hhMjU2OyBjPXNpbXBsZS9zaW1wbGU7IHM9
ZGVmYXVsdDsgYmg9WkErbEVFRG5jeW5sCglXdWNTS2RUYVRDSDJ0bjlwdG9XU0RxSmF5dlVY
bGNFPTsgaD1kYXRlOnN1YmplY3Q6Y2M6dG86ZnJvbTsKCWQ9YWwya2xpbW92LmRlOyBiPWpl
dUUzcWFTc1kyQmVsdzAyMldyU3RsN2hmRlRjSWRoTmo5Y3VGOUJhblJuTXRTWUZRWGYKCW9l
SThtOHFSTkJibTQ4NGtSSWRMMUkwbHRIN2NVNWpaaUZiM0l3b1VqTjVXNUVSdDkraW1RRUZW
Skx1N2xOUVFiLzFoN3IKCUZMTk5rRzFJbERiU0k5NXlFeTh4anVGL0FvT0c5MStMa1VyM2VW
MVZybEFDQVpZejNFdW40aXY5bitCdFNleWpmc0d4ODQKCXNEZ2NXNitqY1pHNmJxSmNaeHpD
R0JPVDd3VHV0KzFHNTJ6UWtYUVRzRzhadUJlc0czcEpZNjZMTDZWMzhJcktFb1BLVkUKCXE0
bEdLcmdHTm9FZmpkYVJvemdrRytaVWZKUzRQM25ZWEN4SmdXdWZVSVdhU0d3QUY0aWh6Rngv
ZThZaUx1QXhSV0MraDgKCTVoRkR0WTArV1E9PQpSZWNlaXZlZDogZnJvbSBjYWNoeS1hayAo
MmEwMi0yNDU1LTE4ZTktZTAxMS00ZDhhLWFhZDItYzI1Yy01MGU1LmR5bjYucHl1ci5uZXQg
WzJhMDI6MjQ1NToxOGU5OmUwMTE6NGQ4YTphYWQyOmMyNWM6NTBlNV0pCglieSBtdGEuYWwy
a2xpbW92LmRlIChPcGVuU01UUEQpIHdpdGggRVNNVFBTQSBpZCAwZWRkYjhjZCAoVExTdjEu
MzpUTFNfQ0hBQ0hBMjBfUE9MWTEzMDVfU0hBMjU2OjI1NjpOTyk7CglXZWQsIDIwIE1heSAy
MDI2IDE4OjA0OjMyICswMDAwIChVVEMpCkZyb206ICJBbGV4YW5kZXIgQS4gS2xpbW92IiA8
Z3JhbmRtYXN0ZXJAYWwya2xpbW92LmRlPgpUbzogTmlsZXNoIEphdmFsaSA8bmphdmFsaUBt
YXJ2ZWxsLmNvbT4sCglHUi1RTG9naWMtU3RvcmFnZS1VcHN0cmVhbUBtYXJ2ZWxsLmNvbSAo
bWFpbnRhaW5lcjpRTE9HSUMgUUxBMlhYWCBGQy1TQ1NJIERSSVZFUiksCgkiSmFtZXMgRS5K
LiBCb3R0b21sZXkiIDxKYW1lcy5Cb3R0b21sZXlASGFuc2VuUGFydG5lcnNoaXAuY29tPiwK
CSJNYXJ0aW4gSy4gUGV0ZXJzZW4iIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4sCglR
dWlubiBUcmFuIDxxdXRyYW5AbWFydmVsbC5jb20+LAoJSGltYW5zaHUgTWFkaGFuaSA8aGlt
YW5zaHUubWFkaGFuaUBvcmFjbGUuY29tPiwKCWxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3Jn
IChvcGVuIGxpc3Q6UUxPR0lDIFFMQTJYWFggRkMtU0NTSSBEUklWRVIpLAoJbGludXgta2Vy
bmVsQHZnZXIua2VybmVsLm9yZyAob3BlbiBsaXN0KQpDYzogIkFsZXhhbmRlciBBLiBLbGlt
b3YiIDxncmFuZG1hc3RlckBhbDJrbGltb3YuZGU+ClN1YmplY3Q6IFtQQVRDSF0gc2NzaTog
cWxhMnh4eDogZml4IE5VTEwgZGVyZWYsIGNoZWNrIHVzZXIgaW5wdXQKRGF0ZTogV2VkLCAy
MCBNYXkgMjAyNiAyMDowMzo1NyArMDIwMApNZXNzYWdlLUlEOiA8MjAyNjA1MjAxODA0MDEu
NTM5MjE1LTEtZ3JhbmRtYXN0ZXJAYWwya2xpbW92LmRlPgpYLU1haWxlcjogZ2l0LXNlbmQt
ZW1haWwgMi41NC4wCk1JTUUtVmVyc2lvbjogMS4wCkNvbnRlbnQtVHJhbnNmZXItRW5jb2Rp
bmc6IDhiaXQKCg==

--------------0DzForRFz63YNg76telrfgRq--
