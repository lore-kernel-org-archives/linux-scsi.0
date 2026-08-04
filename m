Received: from mail-qv1-f98.google.com (mail-qv1-f98.google.com [209.85.219.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCA025B30D
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 05:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785821782; cv=none; b=CrGAhCgIsjTo06ycj7YJMVpPKPnyU+7Wo/AKzT5KDbTV4uC5JT008z7qtFdb6mS2s4vS0M2KW50gstPMS0zlWtdG4zFz5L/U3uPYKEwRnjOLUloeBBGtWuZU0XNBXygjOfoHY9unO1i+5oynZa48QZ0fixAw8oyKGY8dUTyE5Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785821782; c=relaxed/simple;
	bh=RcDJ12ATH5E/YmEtuxdOzU7qG4mMlDWby6OWYeWnLKE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=VttIYvsZcu+oAfJAbXan03XRl8QDI3GHgTz8hKRCI88iGR+63LOPqi6pzHRt3Fm+mRXEoOggHc8NHCUAZxFqOEQLUiR2NUBxe/vJruLV1knmV3Q2imTovxDAUlRHGXIHXsXdkaM7hbEyX1ZvZvzLD5chHerDLd9pu3UXjva9e/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=FYfcgSir; arc=none smtp.client-ip=209.85.219.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="FYfcgSir"
Received: by mail-qv1-f98.google.com with SMTP id 6a1803df08f44-9030f8ea3b3so37129296d6.1
        for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2026 22:36:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785821779; x=1786426579;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RcDJ12ATH5E/YmEtuxdOzU7qG4mMlDWby6OWYeWnLKE=;
        b=MBi03OkNbGfKvMYPW2QGc482Lp2Sv5BIgTDwqezUhbY0luxJLVgqayzXUedb3bDgaI
         jQ1mKk8U018RAcVj/mFtxrlD3Rod46dsIjUGoPfH9+zwQG/LRfmAVEbl7B6aPSIXnqMM
         4bvl9ehT3ZYDSZIZB7CT/Kwfv+cYr1NUO06C8jmnNnGWrnZ9uAKpX6sCge5Fy60R9t/y
         HPTH7irOLj0HWoqVTFLxQ27giR9iZoar38M+G19+7ZCAnfdGhSQCB60fXIJEigedSNqz
         /0LLR0XZg4xJTTZhp/QBDDGUb79kg6/cf9oFTIq6eZKSSh+QvUfo6YRjObYOuiI5cVAz
         u6kA==
X-Gm-Message-State: AOJu0YxDQ74Xd61VRhY6vmBCrkA97ChHLd2oJi/z7uIYHB7UjHmYdzRX
	fnLpnzSd0rVDL0uO4HVkEHr4yPg7VZu92I0SEQm3aN/pbyngH07qGXWe3MotSO9wJqMSlR4G0gk
	XXvU8OG0vw4nHd/qDByrhbF0dsK0AaWn5xXdfL3FPqQhBlG5F8og6ZUpFA6eBxoSByIl1lZ72JX
	4fbnSgVZfKqI6IeiZlTrDh2O6X3miGcwwlZsFiRyeL13e9hZ0/3UpPUjRggLtHAQRCQH7gmwWOP
	Bf34e6QU1i+/qOFYa0=
X-Gm-Gg: AR+sD110LMBFUqkcNepUZmmCGKXeVHn1yFY8KVbpapfNdRXgiuHqC8UO6j3lpd2YMcD
	iNOxVbHqMUdfzwJ6XyAC8XfrBa1r9BbP+fsOt0fgNUTcLjOzVLTn99q3TQO+JoT57Pck8i5oh+5
	VokR5XB0071r/7nsLQwx8x+lj2bBK7409RAPKvvQMhdV0pdj7Q53atVeDmKTzTIJadSrO6QYlcx
	XH3Q1pkUubMDzuapvynRY2vSQj7dl/mAQUbZvmJ3GifSdRfEHFVM/E+WdvCmb1YjcvYGXuDAGf6
	sXFUlgrJ6QfzUSVarGPiast5sngVtdH/iqXWSVpKhk7Ahp06bXXbzZCLXyE0xPZxWcAmtW9+v8V
	kyvbstZdcYO83igk2JMC30T3W7wSmhURwIe2ABgrcMnS2vz0fXvK5YAdWp3H/Geu+3jbIHWqcOA
	BBGAzGs0r+4eIfXmB3icz/pCqgbFjGRZtFgYuphw==
X-Received: by 2002:a05:6214:54c8:b0:8ff:650d:2b99 with SMTP id 6a1803df08f44-90849457e03mr312739656d6.0.1785821779352;
        Mon, 03 Aug 2026 22:36:19 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-9085703f7a4sm4799666d6.12.2026.08.03.22.36.19
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Aug 2026 22:36:19 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-744dc532943so3699522137.3
        for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2026 22:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785821779; x=1786426579; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RcDJ12ATH5E/YmEtuxdOzU7qG4mMlDWby6OWYeWnLKE=;
        b=FYfcgSir5ayYHkE3QLjO8wO/eCdYvpXAVTE9p26R8JVUjnKI3qIlYo8bWbooSy/Rwj
         AVsghi8juxArqSfbM9y/JhUx2losqOB2FLgfewXv2/LewO8usSlvo5eQ0ZdniZs2gl7n
         9l1J1iwCcI3kcv55BZ0JTCNjalDkHNTmLzipk=
X-Received: by 2002:a05:6102:2c86:b0:745:1c72:cf72 with SMTP id ada2fe7eead31-75b2406f27bmr9883101137.13.1785821778874;
        Mon, 03 Aug 2026 22:36:18 -0700 (PDT)
X-Received: by 2002:a05:620a:6847:b0:930:f35d:41ba with SMTP id
 af79cd13be357-934a0a95344mr2421093285a.36.1785821301674; Mon, 03 Aug 2026
 22:28:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Nigel Kirkland <nigel.kirkland@broadcom.com>
Date: Mon, 3 Aug 2026 22:27:43 -0700
X-Gm-Features: AUfX_mxeD7cRw0oePDTaUAWRFSGo75iB-6wSpFm88tvf1tcil0HSQnhjwbyxTlI
Message-ID: <CAJcBD+FxLMPXzkenRcrW0648EYZiPpaTJJvOdTpr3OR=odskUw@mail.gmail.com>
Subject: Subject: [PATCH 5/5] scsi: lpfc: Replace strlcat() with
 sysfs_emit_at() in the sysfs show functions
To: Ian Bridges <icb@fastmail.org>, Paul Ely <paul.ely@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>, 
	Nigel Kirkland <nigel.kirkland@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000c7079e06583208fd"

--000000000000c7079e06583208fd
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Nigel Kirkland <nigel.kirkland@broadcom.com>

--000000000000c7079e06583208fd
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
jYSlgy5DSdwOHRopf+pv+QS0X7yv1IY0zvc3MdBwIA64y6S7wLpr5F7gdUrq8Fl5LCjVgxPQ/Ty2
3P2tfeP2KcMiZJZkxM0a8fTBL3BNZvoUkrCJ0+9OLtDTeYyGpPJCe1uXfRQsdHlCWqvRLQectwvK
gVO8kkq10hxpHIoL4D7ReRqd0IGu2Q/sLEa8soR9l/4kzT7cqtRw2ObwRa5Lrpoj3ncE0GE8NQT/
VZNnTJUtoV7zM0Rsp9sMBHWLpuvkIS5e9TbhFVRiDRl96AsCAwEAAaOCAd8wggHbMA4GA1UdDwEB
/wQEAwIFoDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0
cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5
BggrBgEFBQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIz
MGUGA1UdIAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsG
AQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzBBBgNVHR8EOjA4
MDagNKAyhjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWltZWNhMjAyMy5jcmww
JgYDVR0RBB8wHYEbbmlnZWwua2lya2xhbmRAYnJvYWRjb20uY29tMBMGA1UdJQQMMAoGCCsGAQUF
BwMEMB8GA1UdIwQYMBaAFAApNp5ceroPry1QLdugI4UYsKCSMB0GA1UdDgQWBBThLteltIFAS7A/
sfVsQLkdu4rgaTANBgkqhkiG9w0BAQsFAAOCAgEAwJtA5Pst35/Z9Nq5qDfm2rXaz7h6wJWU5wqm
vVNO7qrNHFh9begX48kQA+L7rAViQkSZN518XXiXR+UyHLNS3wd44P13KPs4lMrfLKXqlGeD+VlX
Ax80pTsBA4y/0afIdFnIXqYT/EN0sHqlFtA/LjPo6rypmSNk17RrM6x0HlcHH52eJmxjntyTr/9z
blGf2VLGucQTBG6Bu6ATQuRV4h1SE40+9B1OVuPyiVMvedp4NgUMsx18K7eAvyrA9kDZcSuA69tO
aeB3nyuCyvayferpiA93m1sjIODoTkqQ9aH/I0n+B2rib5eeqMT61//fmEwRFFBHcP+QjiFrxbFY
e58YwBCOm+0AMj51ScI6rOT9geQuEK7vMP9+N7Sub0/7L69T/BTuz4kG5cFppnKXUL/9NfADDowH
IDhP42JB9i8PLQZ0MxlMLxhtGSF/3h6PJUV8Qd6o2Bi6QSO2g3MXG8pvKUK8OEJs/j5BjF/3IWVU
OGiPDn4Rwdcbj4Oi6ADue58oMYLZD5dxh1w89QSSBMRA3T877tunyHNlgsXvZE4Co/Z4t9D32ZA8
UHOn3Kh+T28i30BvDtxS6Cy8EU4/8gFHQ67PnAKdT5X+/ek4GnI2cUouZ6ykVSWvCCJ0gGviLWUn
oiR9Wl2Xgmc/2JkP0Q7ufuDWqhwkg+qVbBFCGiExggJXMIICUwIBATBiMFIxCzAJBgNVBAYTAkJF
MRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBSNiBT
TUlNRSBDQSAyMDIzAgxjf/M4aTgLfQ2a61wwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkE
MSIEIBSpqptX2WiCD3OkhtHKzImrpGzQLjwj0SdxRC8FtskxMBgGCSqGSIb3DQEJAzELBgkqhkiG
9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDgwNDA1MzYxOVowXAYJKoZIhvcNAQkPMU8wTTALBglg
hkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAEDsbTwUNr86Yss9q9AGFDqNKnXXrT2n
rp+EuiidPAFhjZZhq+SDkjNVrNLMvH9AXsgS7HJclQUiCixuphgnqt9PkRdJcmvyQ6fsD9I/297S
EFPhTJzgASNv4RGUy+OHIn7dH9TFrpWsIUBxPonaQvYCbifDqhroVYYFzvM+8UjuUSpO9YbL1ZwH
B3HfGGmvypbKAGp7d4nfmH5f8hzGnBZMYnBDi5AZaz071VITH+xkMfGuziGK7vJEY6hzgILO2gVr
vJycEBMuni4FHzAVT6geeUfL6h2jVS7yMbdxDdN68V2cveUTHFY/8f9Zu+XoGeQuKHZeMo2aqcMg
xVgfdho=
--000000000000c7079e06583208fd--
