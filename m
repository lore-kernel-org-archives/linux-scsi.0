Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FA63783C1
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 05:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785821326; cv=none; b=lBRqiEUrsD+EzyEgpF5ggwmRBOb4F1pWiaGbUXQ7nwZMG0KFsFPVqCzYIaL0uSoI1zAiESNgnfkDZ4KLSV4/B+FTlA5i/RdpFMiEmFBfcmbTIj8OMZnZeeQ4p2UZB8jxj5n29KuqBDMts0HhtM2WIes847wuCSKqmv95XugwBBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785821326; c=relaxed/simple;
	bh=4/vMW/1HFM7SyH5fpmucQ8Nb4G8+PMXZCPKScqC7vqk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=WtP6mgl3TqNzRWdr5S28x9rRS+cOiSyT13ebHyW8w60yDtDnpYKpRmQEZo2T0rSdGqvBI8HZf3c0x8z4BjD0leGrAob/SIy5ekwLYZWYQivYkiGHpB1uKzkwdi8ZwHPeT8sB/v/Tr5FfRgq/WM/Ut79zKW9d/VCcmGiISRfRNjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Xo6qp2BX; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Xo6qp2BX"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-38e08baf860so3635051a91.2
        for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2026 22:28:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785821324; x=1786426124;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4/vMW/1HFM7SyH5fpmucQ8Nb4G8+PMXZCPKScqC7vqk=;
        b=VbWos2zzNssTPxEnq1Sm+kf6PDyWku/Z48qFi45OY+NqpR+ByvFX3JW5Y1J++myl0C
         6Gu3s15CdID0GvGbSCIVc90mFWHx5XodugBWcxcIRl8BrI1oeFA1kkM/PwqdcSJ4M/R0
         rveCKXGnDPKFDZrYenY+dRgrhT6PHdMoY35oLb7J+33zP7U/WJ5K/EOGoyb5WN89vqSe
         6y9H+JR+g6C5zyy/h9oxCJYrIYqzrSAmjwsjtRdCvOVwQ7ODbT5LypR0Mwtbq5AIW0rT
         yKyDcrZ48oqQN3s1jq/I5KButgdBZVTjmx9Nsxmr4KtcPFEElx2UTNKcIfRIajH+5iJh
         cAxA==
X-Gm-Message-State: AOJu0YyzeNc0T5skpEtDhqcqGcfw73T63iIIuOAnesy27s3lhLvx+ILi
	pir4Bw/StsVXBrlBP/+bKNd8ychgIha+JbOtQzZg0iM7n7ze3/CZSQlamSxPzc4GXxq8pOf1BPd
	VktboLlXXQo0MV/X3vQQFNwMTPKHuy+J+Ql2DT8yYxmBXTXeXfQZiJ0X5lAGKlusUgxiiS8YkNM
	XEO1zhCkGaTQI6FjkRuFTookibkFQyK4IV4FIH2HdEwbNVhkAm1qEVQxD4zTIJYsRT0PH+vPxNp
	neRfBWM8GuKjyJJDW0=
X-Gm-Gg: AR+sD12q059t1vZ21E/q9Dyz+6WntVHoEmxjIkOdGE5hV0AjSsk9eVQN3Cscrk7RzyU
	OsYIkGsYNivJBYSqjhWDnzMQZMwic9qBH8drGeL6QcFsNTc3iZcgcJSfygSe2Ig3R1KrVtRmNzp
	UA6xeWxnkLuE3jvgbe9f46phBAx7VxdppG1BpWnlaNRxDrIDHpTYEatHHeAruxIQDD2TpMQMhMv
	CTNf0FvII4Xeg6tX9Z1SN3M8vUAqEfC11oOIJGhCv2ILNwkG6h5GatE7un5WdfOOU000wkgWUvl
	KHCxc8wKBD60lPnJZVdp4RGzP1q93x1ngiv1cZCZpJ9Nmt+9oxJQtEkT8E0ZpghNe9/WB1eLx8F
	GQuHW5vuYFzWuWRD788rL+lC5KeMyjpfl9YZd8X9B01+oTmw9S0JIf/TkqBdaBwGfkr++Ojp+G8
	qOGtu5bO/iz3E3x/3VuZ6xVSUmc7DUpbIwYrjGBg==
X-Received: by 2002:a17:90b:268d:b0:381:bc6c:25b9 with SMTP id 98e67ed59e1d1-38fbc4fceaemr11866514a91.31.1785821324048;
        Mon, 03 Aug 2026 22:28:44 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-22.dlp.protect.broadcom.com. [144.49.247.22])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-38febf35042sm161101a91.8.2026.08.03.22.28.43
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Aug 2026 22:28:44 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-92ac0a54110so442178585a.2
        for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2026 22:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785821322; x=1786426122; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4/vMW/1HFM7SyH5fpmucQ8Nb4G8+PMXZCPKScqC7vqk=;
        b=Xo6qp2BXUL1NwFAEyGuq5m9dLyaGEYOQTQJThh5pn/EBL03XlRewkFWWY82fCZsUkv
         HEefP+Cf4FFJxG2T47xiKP7kceFgd2U8KKpQm2y6aFwLUaa8qQIOdg4TNemZ4/LwjMV8
         mt702z6nqxdLRn05l3xj89fDMBSC+Sj59FsbU=
X-Received: by 2002:a05:620a:468e:b0:92e:4a4a:4478 with SMTP id af79cd13be357-934a095b89emr2101921685a.31.1785821322665;
        Mon, 03 Aug 2026 22:28:42 -0700 (PDT)
X-Received: by 2002:a05:620a:468e:b0:92e:4a4a:4478 with SMTP id
 af79cd13be357-934a095b89emr2101920185a.31.1785821322219; Mon, 03 Aug 2026
 22:28:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Nigel Kirkland <nigel.kirkland@broadcom.com>
Date: Mon, 3 Aug 2026 22:28:05 -0700
X-Gm-Features: AUfX_mwrOeBmdlTLo1X-3WMiBRcvqup068cPKCUr7Nd0zIoyU4crS_177apefMo
Message-ID: <CAJcBD+H=DkqtrV3GwEpidDxX9_2DFXY2zC0tD_9Wc0ma_nAHbg@mail.gmail.com>
Subject: Subject: [PATCH 4/5] scsi: lpfc: Replace strlcat() with seq_buf in
 the debugfs dump helpers
To: Ian Bridges <icb@fastmail.org>, Paul Ely <paul.ely@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>, 
	Nigel Kirkland <nigel.kirkland@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000096a9ac065831eded"

--00000000000096a9ac065831eded
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Nigel Kirkland <nigel.kirkland@broadcom.com>

--00000000000096a9ac065831eded
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
9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDgwNDA1Mjg0MlowXAYJKoZIhvcNAQkPMU8wTTALBglg
hkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBACoyUbDz9AQTadSVS/Q6mZ4J4em+uwjx
U5hzUp+8yhc4Au0RJQb+6XRDCnmkl6zNVIh/uCFNI1vryiMZRgWmijXqtm48MMsFZmlFS6xnNdWQ
tV0qFYRDlxmySfTidzQVU3XxSeLCtGk0BvEEeboyUGAIfwxYawC5wdFoLSQFXKobVoJewv9gwKim
SWLzSJcvfuKw216CnxlJeoKlK/xikqMU4iQ6wlAmIolokAngamgtmqqRYNVZzelFXsUICeH6XZ4c
KMvUsyYBioSYOI5LdGybjoDBu6qcquf3L5i8dItia1UkcctUFenH01PAlNbUwoo7sRJ4qv2eg8Tb
QY4ajU0=
--00000000000096a9ac065831eded--
