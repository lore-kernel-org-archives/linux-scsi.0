Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A59C285416;
	Tue, 22 Apr 2025 14:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745331211; cv=none; b=EYAZB0YoQ3SeG/0zA7yEa+dpNy1uWd/sooGRuFpHLOpXwFliOnBBkNfIVqHjNxRwxMfe8FH24miZDEYNZuTdEBL9Ki7GuCD/TFs0MWC0407c+lxkmhwuzAXykFr9Y6xIvcBZxoTxuCeX5DEejEfTaz7tRu20+ZjrF2+aCustXRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745331211; c=relaxed/simple;
	bh=N+wdbTfCe3pulHAjMAeA/Nrw5rRU/mIV5dnjhmJiWyQ=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Cc:Content-Type; b=jZPpkp0Mvxl9AQiX+EkH7s1tjPfCnwIMBsxcHcfzIqFRphwkkixVaZ9WYf9GE23OySPCw3DnhCP3GWy2A8Ty+DwsB6pPLmNaLyTf4YGU/R42YsZKwgq03MFIhCCkB9Zi9sgXBmmIUOfZ9XViMOa8ZU6mDy405eMISoJSgM2kvMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JN19oTqL; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JN19oTqL"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-39c1efbefc6so3223728f8f.1;
        Tue, 22 Apr 2025 07:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745331208; x=1745936008; darn=vger.kernel.org;
        h=cc:subject:to:autocrypt:from:content-language:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N+wdbTfCe3pulHAjMAeA/Nrw5rRU/mIV5dnjhmJiWyQ=;
        b=JN19oTqLLYqk+MRIPKKeT3Hf+YVQt6Kk6N+SN1lkEB/w5pTRG6/eykHhnY1F3z2eEz
         EK5HZUp0jMILsPPs+W4LAG/QfTbG4X5jiiieK9k6A+u8O7mISsEb7I64IufrOwZrJTgW
         tBGOY0sx5uY/ORZ25BmqbUW5aXmuSun0pqKFwmBKD2aKeDNw910DzBSsi858ozOjU9nY
         KYlweVjgfFmnXzb80qwu96kMWVkLrd7YhMoAMaxxJKSboqTgR0Xiwp77bn0ZIonG/Vjz
         N2qlPrB4UXt0ECd2GWbFkSO/pMYe6r6tiAa8RG5YEkeUgIncdrqkVMyyxMATB7Ra35pz
         rKFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745331208; x=1745936008;
        h=cc:subject:to:autocrypt:from:content-language:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N+wdbTfCe3pulHAjMAeA/Nrw5rRU/mIV5dnjhmJiWyQ=;
        b=C6CqVxWwhUxS7V5FV9G0XTdUzgbDLawK7F9S8VfpUNVD7LzTWD/TbZM/uURO8oUOIJ
         qpglRxmTglkPuaw075tFjcfdN0H3sbm1SS57OVwiqe71grWEGdPAwitA98ccAnbtuk+r
         BRcQm0Sld3drvNdb11NTHBoYS/zxhRyoxGpoG4Ky6gb4QvCuJmNdBgty2PFtVIH0dFdy
         taKCgne+z6ct2syEyRaA7d2MjDZy0M945Pnhb96REXGA269GSkWyfmdhlE13Qqly0Qqq
         pEcwLm8lCkm0YUvgU2Xe7JHWCbz4HF++48Pnn8s5vDD/ncullXIz5g/INaXFqz3lVvEb
         zSqg==
X-Forwarded-Encrypted: i=1; AJvYcCUgDO43Qqcg5ZictvAHdGK3p06SMqK/NFCeL0dpZ4pnoDjEa4cvkdDjgCs+exMqQiSNnUSWJf7IuPomdHU=@vger.kernel.org, AJvYcCWvapfXV4xl7EuYPzKyMvPy02JR0wgx44QCWrLK6WG3MT0EZ8J2ZMXOFG68+WmtfFF34oAhopqWJUciiw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwGeGVbGELnxCRo/zSur9lBmny42FXU9AX+1rAyTDtl9pv9F7a4
	ySzzRqkYsJfz2Vog6VrTqYp/0YDG0iFT7kxcoE6kjru0xVNImQxA
X-Gm-Gg: ASbGncv8KfcKhfnSV3TSIS8s8WgLYrYRY7gkQXLA3ehZR0qXHmeDdfBnmKaDsoIVZxr
	EwCm0vDC0TKWpoZPKCqY9MWzmBYUhq8fBPp2Wzx5AyABzd3VzU5yG2YUvM8QtW4m1Jdc7qzf4bN
	JuZeF2w3uvnooqvNSizijqC5aFujmceDkWhzHFiAXoItmdUmNm2JE68QN5ZpTQ8oq77s1ZdgbhV
	Y0nmMBhVoPiSfCQHckCGGdt8eqsN54PdIv30xWUHplm1U4nw11yOVuB4Kbs0zXxWxdD1j7x+Z7W
	P2Vl5obOUzIpIliR6pOxva/fcOhGZVt3glRO1M8/90gphAk52g==
X-Google-Smtp-Source: AGHT+IES85isoI/6BBnHAFwEN+NJQzhCavxWhOgvDa+dQyi3CbKn7XR8HelnL5UbaP2mHPqAx+3wnw==
X-Received: by 2002:a5d:5f49:0:b0:39e:cbe3:881 with SMTP id ffacd0b85a97d-39efba246e0mr11850634f8f.12.1745331207403;
        Tue, 22 Apr 2025 07:13:27 -0700 (PDT)
Received: from [192.168.1.248] ([194.120.133.58])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-39efa4207e6sm15246957f8f.7.2025.04.22.07.13.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 07:13:26 -0700 (PDT)
Message-ID: <10d77cb9-a5fe-462a-9339-e2df845958c5@gmail.com>
Date: Tue, 22 Apr 2025 15:13:19 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: "Colin King (gmail)" <colin.i.king@gmail.com>
Autocrypt: addr=colin.i.king@gmail.com; keydata=
 xsFNBE6TJCgBEACo6nMNvy06zNKj5tiwDsXXS+LhT+LwtEsy9EnraKYXAf2xwazcICSjX06e
 fanlyhB0figzQO0n/tP7BcfMVNG7n1+DC71mSyRK1ZERcG1523ajvdZOxbBCTvTitYOy3bjs
 +LXKqeVMhK3mRvdTjjmVpWnWqJ1LL+Hn12ysDVVfkbtuIm2NoaSEC8Ae8LSSyCMecd22d9Pn
 LR4UeFgrWEkQsqROq6ZDJT9pBLGe1ZS0pVGhkRyBP9GP65oPev39SmfAx9R92SYJygCy0pPv
 BMWKvEZS/7bpetPNx6l2xu9UvwoeEbpzUvH26PHO3DDAv0ynJugPCoxlGPVf3zcfGQxy3oty
 dNTWkP6Wh3Q85m+AlifgKZudjZLrO6c+fAw/jFu1UMjNuyhgShtFU7NvEzL3RqzFf9O1qM2m
 uj83IeFQ1FZ65QAiCdTa3npz1vHc7N4uEQBUxyXgXfCI+A5yDnjHwzU0Y3RYS52TA3nfa08y
 LGPLTf5wyAREkFYou20vh5vRvPASoXx6auVf1MuxokDShVhxLpryBnlKCobs4voxN54BUO7m
 zuERXN8kadsxGFzItAyfKYzEiJrpUB1yhm78AecDyiPlMjl99xXk0zs9lcKriaByVUv/NsyJ
 FQj/kmdxox3XHi9K29kopFszm1tFiDwCFr/xumbZcMY17Yi2bQARAQABzSdDb2xpbiBJYW4g
 S2luZyA8Y29saW4uaS5raW5nQGdtYWlsLmNvbT7CwZEEEwEIADsCGwMFCwkIBwMFFQoJCAsF
 FgIDAQACHgECF4AWIQRwYtqk8AG5xmFnAM9owoffxqgCJgUCY8GcawIZAQAKCRBowoffxqgC
 Jtd/EACIWcaxfVt/MH4qqo5ELsjCFPVp+RhVpQDWy8v9Np2YbTcZ4AY2Zj4Pq/HrZ3F/Bh02
 v85C6mNv8BDTKev6Qcq3BYw0iqw6/xLNvRcSFHM81mQI9xtnAWIWfI9k5hpX19QooPIIP3GO
 MdMc1uRUGTxTgTFAAsAswRY3kMzo6k7arQnUs9zbiZ9SmS43qWOIxzGnvneekHHDAcomc/oh
 o7kgj6rKp/f9qRrhForkgVQwdj6iBlW934yRXzeFVF3wr7Lk5GQNIEkJiNQPZs54ojBS/Kx6
 3UTLT1HgOp6UY9RPEi9wubmUR+J6YjLRZMr5PCcA86EYmRoysnnJ8Q/SlBVD8nppGVEcuvrb
 H3MBfhmwOPDc3RyLkEtKfSTB92k1hsmRkx9zkyuUzhcSnqQnpWGJD+xtKHvcHRT7Uxaa+SDw
 UDM36BjkyVcZQy8c+Is2jA55uwNgPpiA7n82pTeT+FRGd+7iCLQHaryu6FO6DNDv09RbPBjI
 iC/q814aeKJaSILP1ld9/PEBrLPdm+6lG6OKOt9DDV6jPmfR96FydjxcmI1cgZVgPomSxv2J
 B1erOggB8rmX4hhWYsVQl1AXZs3LdEpJ6clmCPspn/ufZxHslgR9/WR1EvPMQc8XtssF55p8
 ehRIcVSXDRcMFr3ZuqMTXcL68YbDmv5OGS95O1Gs4c7BTQROkyQoARAAxfoc/nNKhdEefA8I
 jPDPz6KcxbuYnrQaZdI1M4JWioTGSilu5QK+Kc3hOD4CeGcEHdHUpMet4UajPetxXt+Yl663
 oJacGcYG2xpbkSaaHqBls7lKVxOmXtANpyAhS5O/WmB7BUcJysqJfTNAMmRwrwV4tRwHY9e4
 l3qwmDf2SCw+UjtHQ4kJee9P9Uad3dc9Jdeg7gpyvl9yOxk/GfQd1gK+igkYj9Bq76KY8cJI
 +GdfdZj/2rn9aqVj1xADy1QL7uaDO3ZUyMV+3WGun8JXJtbqG2b5rV3gxLhyd05GxYER62cL
 oedBjC4LhtUI4SD15cxO/zwULM4ecxsT4/HEfNbcbOiv9BhkZyKz4QiJTqE1PC/gXp8WRd9b
 rrXUnB8NRAIAegLEXcHXfGvQEfl3YRxs0HpfJBsgaeDAO+dPIodC/fjAT7gq0rHHI8Fffpn7
 E7M622aLCIVaQWnhza1DKYcBXvR2xlMEHkurTq/qcmzrTVB3oieWlNzaaN3mZFlRnjz9juL6
 /K41UNcWTCFgNfMVGi071Umq1e/yKoy29LjE8+jYO0nHqo7IMTuCd+aTzghvIMvOU5neTSnu
 OitcRrDRts8310OnDZKH1MkBRlWywrXX0Mlle/nYFJzpz4a0yqRXyeZZ1qS6c3tC38ltNwqV
 sfceMjJcHLyBcNoS2jkAEQEAAcLBXwQYAQgACQUCTpMkKAIbDAAKCRBowoffxqgCJniWD/43
 aaTHm+wGZyxlV3fKzewiwbXzDpFwlmjlIYzEQGO3VSDIhdYj2XOkoIojErHRuySYTIzLi08Q
 NJF9mej9PunWZTuGwzijCL+JzRoYEo/TbkiiT0Ysolyig/8DZz11RXQWbKB5xFxsgBRp4nbu
 Ci1CSIkpuLRyXaDJNGWiUpsLdHbcrbgtSFh/HiGlaPwIehcQms50c7xjRcfvTn3HO/mjGdeX
 ZIPV2oDrog2df6+lbhMPaL55A0+B+QQLMrMaP6spF+F0NkUEmPz97XfVjS3ly77dWiTUXMHC
 BCoGeQDt2EGxCbdXRHwlO0wCokabI5wv4kIkBxrdiLzXIvKGZjNxEBIu8mag9OwOnaRk50av
 TkO3xoY9Ekvfcmb6KB93wSBwNi0br4XwwIE66W1NMC75ACKNE9m/UqEQlfBRKR70dm/OjW01
 OVjeHqmUGwG58Qu7SaepC8dmZ9rkDL310X50vUdY2nrb6ZN4exfq/0QAIfhL4LD1DWokSUUS
 73/W8U0GYZja8O/XiBTbESJLZ4i8qJiX9vljzlBAs4dZXy6nvcorlCr/pubgGpV3WsoYj26f
 yR7NRA0YEqt7YoqzrCq4fyjKcM/9tqhjEQYxcGAYX+qM4Lo5j5TuQ1Rbc38DsnczZV05Mu7e
 FVPMkxl2UyaayDvhrO9kNXvl1SKCpdzCMQ==
To: Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>,
 Jamie Lenehan <lenehan@twibble.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: scsi: dc395x: enabling debug causes build to fail
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------DgjxzZJeDQxaqEshSAPh35AG"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------DgjxzZJeDQxaqEshSAPh35AG
Content-Type: multipart/mixed; boundary="------------mfTeWsuMzdjboZhexsZNX6HZ";
 protected-headers="v1"
From: "Colin King (gmail)" <colin.i.king@gmail.com>
To: Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>,
 Jamie Lenehan <lenehan@twibble.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <10d77cb9-a5fe-462a-9339-e2df845958c5@gmail.com>
Subject: scsi: dc395x: enabling debug causes build to fail

--------------mfTeWsuMzdjboZhexsZNX6HZ
Content-Type: multipart/mixed; boundary="------------SOKwDOVCKvGrFhUwlVgIdmu1"

--------------SOKwDOVCKvGrFhUwlVgIdmu1
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGksDQoNCkVuYWJsaW5nIGRlYnVnIGluIGRyaXZlcnMvc2NzaS9kYzM5NXguYyBzdWNoIGFz
IHRoZSBmb2xsb3dpbmcuLg0KDQojZGVmaW5lICBERUJVR19NQVNLICAgIERCR18wDQoNCi4u
Y2F1c2VzIHRoZSBidWlsZCB0byBmYWlsLiBUaGlzIHNlZW1zIHRvIGZhaWwgcHJlLSBsaW51
eCB2Ni4wLCBzbyBpdCdzIA0KYmVlbiBicm9rZW4gYSB2ZXJ5IGxvbmcgdGltZS4NCg0KbWFr
ZSBkcml2ZXJzL3Njc2kvZGMzOTV4Lm8gLWogMjggLWsNCiAgIERFU0NFTkQgb2JqdG9vbA0K
ICAgSU5TVEFMTCBsaWJzdWJjbWRfaGVhZGVycw0KICAgVVBEICAgICBpbmNsdWRlL2NvbmZp
Zy9rZXJuZWwucmVsZWFzZQ0KICAgVVBEICAgICBpbmNsdWRlL2dlbmVyYXRlZC91dHNyZWxl
YXNlLmgNCiAgIENBTEwgICAgc2NyaXB0cy9jaGVja3N5c2NhbGxzLnNoDQogICBDQyBbTV0g
IGRyaXZlcnMvc2NzaS9kYzM5NXgubw0KSW4gZmlsZSBpbmNsdWRlZCBmcm9tIC4vaW5jbHVk
ZS9hc20tZ2VuZXJpYy9idWcuaDoyMywNCiAgICAgICAgICAgICAgICAgIGZyb20gLi9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS9idWcuaDoxMTQsDQogICAgICAgICAgICAgICAgICBmcm9tIC4v
aW5jbHVkZS9saW51eC9idWcuaDo1LA0KICAgICAgICAgICAgICAgICAgZnJvbSAuL2FyY2gv
eDg2L2luY2x1ZGUvYXNtL3BhcmF2aXJ0Lmg6MTksDQogICAgICAgICAgICAgICAgICBmcm9t
IC4vYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1aWQvYXBpLmg6NTcsDQogICAgICAgICAgICAg
ICAgICBmcm9tIC4vYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1aWQuaDo2LA0KICAgICAgICAg
ICAgICAgICAgZnJvbSAuL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Byb2Nlc3Nvci5oOjE5LA0K
ICAgICAgICAgICAgICAgICAgZnJvbSAuL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RpbWV4Lmg6
NSwNCiAgICAgICAgICAgICAgICAgIGZyb20gLi9pbmNsdWRlL2xpbnV4L3RpbWV4Lmg6Njcs
DQogICAgICAgICAgICAgICAgICBmcm9tIC4vaW5jbHVkZS9saW51eC90aW1lMzIuaDoxMywN
CiAgICAgICAgICAgICAgICAgIGZyb20gLi9pbmNsdWRlL2xpbnV4L3RpbWUuaDo2MCwNCiAg
ICAgICAgICAgICAgICAgIGZyb20gLi9pbmNsdWRlL2xpbnV4L3N0YXQuaDoxOSwNCiAgICAg
ICAgICAgICAgICAgIGZyb20gLi9pbmNsdWRlL2xpbnV4L21vZHVsZS5oOjEzLA0KICAgICAg
ICAgICAgICAgICAgZnJvbSBkcml2ZXJzL3Njc2kvZGMzOTV4LmM6NDk6DQpkcml2ZXJzL3Nj
c2kvZGMzOTV4LmM6IEluIGZ1bmN0aW9uIOKAmGJ1aWxkX3NyYuKAmToNCmRyaXZlcnMvc2Nz
aS9kYzM5NXguYzo4OTM6MzE6IGVycm9yOiDigJhzdHJ1Y3Qgc2NzaV9jbW5k4oCZIGhhcyBu
byBtZW1iZXIgDQpuYW1lZCDigJhidWZmbGVu4oCZDQogICA4OTMgfCAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBjbWQtPmJ1ZmZsZW4sIHNjc2lfc2dsaXN0KGNtZCksIA0Kc2NzaV9z
Z19jb3VudChjbWQpLA0KICAgICAgIHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
Xn4NCi4vaW5jbHVkZS9saW51eC9wcmludGsuaDo0Nzk6MzM6IG5vdGU6IGluIGRlZmluaXRp
b24gb2YgbWFjcm8gDQrigJhwcmludGtfaW5kZXhfd3JhcOKAmQ0KICAgNDc5IHwgICAgICAg
ICAgICAgICAgIF9wX2Z1bmMoX2ZtdCwgIyNfX1ZBX0FSR1NfXyk7IA0KICAgICAgICAgXA0K
ICAgICAgIHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefn5+fn5+fn5+fg0K
ZHJpdmVycy9zY3NpL2RjMzk1eC5jOjExMzo1OiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFj
cm8g4oCYcHJpbnRr4oCZDQogICAxMTMgfCAgICAgcHJpbnRrKGxldmVsIERDMzk1WF9OQU1F
ICI6ICIgZm9ybWF0ICwgIyMgYXJnKQ0KICAgICAgIHwgICAgIF5+fn5+fg0KZHJpdmVycy9z
Y3NpL2RjMzk1eC5jOjEyNjoyNTogbm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3JvIOKAmGRw
cmludGts4oCZDQogICAxMjYgfCAgICAgICAgICAgICAgICAgICAgICAgICBkcHJpbnRrbChL
RVJOX0RFQlVHICwgZm9ybWF0ICwgIyMgYXJnKTsgXA0KICAgICAgIHwgICAgICAgICAgICAg
ICAgICAgICAgICAgXn5+fn5+fn4NCmRyaXZlcnMvc2NzaS9kYzM5NXguYzo4OTE6MTc6IG5v
dGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybyDigJhkcHJpbnRrZGJn4oCZDQogICA4OTEgfCAg
ICAgICAgICAgICAgICAgZHByaW50a2RiZyhEQkdfMCwNCiAgICAgICB8ICAgICAgICAgICAg
ICAgICBefn5+fn5+fn5+DQouL2luY2x1ZGUvbGludXgva2Vybl9sZXZlbHMuaDo1OjI1OiBl
cnJvcjogZm9ybWF0IOKAmCV44oCZIGV4cGVjdHMgYXJndW1lbnQgDQpvZiB0eXBlIOKAmHVu
c2lnbmVkIGludOKAmSwgYnV0IGFyZ3VtZW50IDMgaGFzIHR5cGUg4oCYZG1hX2FkZHJfdOKA
mSB7YWthIOKAmGxvbmcgDQpsb25nIHVuc2lnbmVkIGludOKAmX0gWy1XZXJyb3I9Zm9ybWF0
PV0NCiAgICAgNSB8ICNkZWZpbmUgS0VSTl9TT0ggICAgICAgICJcMDAxIiAgICAgICAgICAv
KiBBU0NJSSBTdGFydCBPZiBIZWFkZXIgKi8NCiAgICAgICB8ICAgICAgICAgICAgICAgICAg
ICAgICAgIF5+fn5+fg0KLi9pbmNsdWRlL2xpbnV4L3ByaW50ay5oOjQ3OToyNTogbm90ZTog
aW4gZGVmaW5pdGlvbiBvZiBtYWNybyANCuKAmHByaW50a19pbmRleF93cmFw4oCZDQogICA0
NzkgfCAgICAgICAgICAgICAgICAgX3BfZnVuYyhfZm10LCAjI19fVkFfQVJHU19fKTsgDQog
ICAgICAgICBcDQogICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICBefn5+DQpkcml2
ZXJzL3Njc2kvZGMzOTV4LmM6MTEzOjU6IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybyDi
gJhwcmludGvigJkNCiAgIDExMyB8ICAgICBwcmludGsobGV2ZWwgREMzOTVYX05BTUUgIjog
IiBmb3JtYXQgLCAjIyBhcmcpDQogICAgICAgfCAgICAgXn5+fn5+DQoNCi4uLiBldGMNCg0K
DQpJIHN0dW1ibGVkIHVwb24gdGhpcyBiZWNhdXNlIG9mIGEgc3BlbGxpbmcgbWlzdGFrZSBp
biB0aGUgZm9sbG93aW5nIGxpbmUgDQppbiBmdW5jdGlvbiBzcmJfZG9uZSgpOg0KDQogICAg
ICAgICBkcHJpbnRrZGJnKERCR19TRywgInNyYl9kb25lOiBzcmI9JXAgc2c9JWkoJWkvJWkp
IGJ1Zj0lcFxuIiwNCiAgICAgICAgICAgICAgICAgICAgc3JiLCBzY3NpX3NnX2NvdW50KGNt
ZCksIHNyYi0+c2dfaW5kZXgsIHNyYi0+c2dfY291bnQsDQogICAgICAgICAgICAgICAgICAg
IHNjc2lfc2d0YWxiZShjbWQpKTsNCg0Kc2NzaV9zZ3RhbGJlIHNob3VsZCBiZSBzY3NpX3Nn
dGFibGUoKSwgYW5kIHRoaXMgd2FzIGludHJvZHVjZWQgaW50byB0aGUgDQpkcml2ZXIgYmFj
ayBpbiBjb21taXQ6DQoNCmE4NjJlYTMxNjU1YTMgKEZVSklUQSBUb21vbm9yaSAgICAgICAy
MDA3LTA1LTI2IDAyOjA3OjA5ICswOTAwIDMxNjINCg0KDQpDb2xpbg0K
--------------SOKwDOVCKvGrFhUwlVgIdmu1
Content-Type: application/pgp-keys; name="OpenPGP_0x68C287DFC6A80226.asc"
Content-Disposition: attachment; filename="OpenPGP_0x68C287DFC6A80226.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsFNBE6TJCgBEACo6nMNvy06zNKj5tiwDsXXS+LhT+LwtEsy9EnraKYXAf2xwazc
ICSjX06efanlyhB0figzQO0n/tP7BcfMVNG7n1+DC71mSyRK1ZERcG1523ajvdZO
xbBCTvTitYOy3bjs+LXKqeVMhK3mRvdTjjmVpWnWqJ1LL+Hn12ysDVVfkbtuIm2N
oaSEC8Ae8LSSyCMecd22d9PnLR4UeFgrWEkQsqROq6ZDJT9pBLGe1ZS0pVGhkRyB
P9GP65oPev39SmfAx9R92SYJygCy0pPvBMWKvEZS/7bpetPNx6l2xu9UvwoeEbpz
UvH26PHO3DDAv0ynJugPCoxlGPVf3zcfGQxy3otydNTWkP6Wh3Q85m+AlifgKZud
jZLrO6c+fAw/jFu1UMjNuyhgShtFU7NvEzL3RqzFf9O1qM2muj83IeFQ1FZ65QAi
CdTa3npz1vHc7N4uEQBUxyXgXfCI+A5yDnjHwzU0Y3RYS52TA3nfa08yLGPLTf5w
yAREkFYou20vh5vRvPASoXx6auVf1MuxokDShVhxLpryBnlKCobs4voxN54BUO7m
zuERXN8kadsxGFzItAyfKYzEiJrpUB1yhm78AecDyiPlMjl99xXk0zs9lcKriaBy
VUv/NsyJFQj/kmdxox3XHi9K29kopFszm1tFiDwCFr/xumbZcMY17Yi2bQARAQAB
zSdDb2xpbiBJYW4gS2luZyA8Y29saW4uaS5raW5nQGdtYWlsLmNvbT7CwZEEEwEI
ADsCGwMFCwkIBwMFFQoJCAsFFgIDAQACHgECF4AWIQRwYtqk8AG5xmFnAM9owoff
xqgCJgUCY8GcawIZAQAKCRBowoffxqgCJtd/EACIWcaxfVt/MH4qqo5ELsjCFPVp
+RhVpQDWy8v9Np2YbTcZ4AY2Zj4Pq/HrZ3F/Bh02v85C6mNv8BDTKev6Qcq3BYw0
iqw6/xLNvRcSFHM81mQI9xtnAWIWfI9k5hpX19QooPIIP3GOMdMc1uRUGTxTgTFA
AsAswRY3kMzo6k7arQnUs9zbiZ9SmS43qWOIxzGnvneekHHDAcomc/oho7kgj6rK
p/f9qRrhForkgVQwdj6iBlW934yRXzeFVF3wr7Lk5GQNIEkJiNQPZs54ojBS/Kx6
3UTLT1HgOp6UY9RPEi9wubmUR+J6YjLRZMr5PCcA86EYmRoysnnJ8Q/SlBVD8npp
GVEcuvrbH3MBfhmwOPDc3RyLkEtKfSTB92k1hsmRkx9zkyuUzhcSnqQnpWGJD+xt
KHvcHRT7Uxaa+SDwUDM36BjkyVcZQy8c+Is2jA55uwNgPpiA7n82pTeT+FRGd+7i
CLQHaryu6FO6DNDv09RbPBjIiC/q814aeKJaSILP1ld9/PEBrLPdm+6lG6OKOt9D
DV6jPmfR96FydjxcmI1cgZVgPomSxv2JB1erOggB8rmX4hhWYsVQl1AXZs3LdEpJ
6clmCPspn/ufZxHslgR9/WR1EvPMQc8XtssF55p8ehRIcVSXDRcMFr3ZuqMTXcL6
8YbDmv5OGS95O1Gs4c0iQ29saW4gS2luZyA8Y29saW4ua2luZ0B1YnVudHUuY29t
PsLBdwQTAQgAIQUCTwq47wIbAwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgAAKCRBo
woffxqgCJo1bD/4gPIQ0Muy5TGHqTQ/bSiQ9oWjS5rAQvsrsVwcm2Ka7Uo8LzG8e
grZrYieJxn3Qc22b98TiT6/5+sMa3XxhxBZ9FvALve175NPOz+2pQsAV88tR5NWk
5YSzhrpzi7+klkWEVAB71hKFZcT0qNlDSeg9NXfbXOyCVNPDJQJfrtOPEuutuRuU
hrXziaRchqmlhmszKZGHWybmPWnDQEAJdRs2Twwsi68WgScqapqd1vq2+5vWqzUT
JcoHrxVOnlBq0e0IlbrpkxnmxhfQ+tx/Sw9BP9RITgOEFh6tf7uwly6/aqNWMgFL
WACArNMMkWyOsFj8ouSMjk4lglT96ksVeCUfKqvCYRhMMUuXxAe+q/lxsXC+6qok
Jlcd25I5U+hZ52pz3A+0bDDgIDXKXn7VbKooJxTwN1x2g3nsOLffXn/sCsIoslO4
6nbr0rfGpi1YqeXcTdU2Cqlj2riBy9xNgCiCrqrGfX7VCdzVwpQHyNxBzzGG6JOm
9OJ2UlpgbbSh6/GJFReW+I62mzC5VaAoPgxmH38g0mA8MvRT7yVpLep331F3Inmq
4nkpRxLd39dgj6ejjkfMhWVpSEmCnQ/Tw81z/ZCWExFp6+3Q933hGSvifTecKQlO
x736wORwjjCYH/A3H7HK4/R9kKfL2xKzD+42ejmGqQjleTGUulue8JRtpM1AQ29s
aW4gSWFuIEtpbmcgKEludGVsIENvbGluIElhbiBLaW5nIGtleSkgPGNvbGluLmtp
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
=3DQKm6
-----END PGP PUBLIC KEY BLOCK-----

--------------SOKwDOVCKvGrFhUwlVgIdmu1--

--------------mfTeWsuMzdjboZhexsZNX6HZ--

--------------DgjxzZJeDQxaqEshSAPh35AG
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEcGLapPABucZhZwDPaMKH38aoAiYFAmgHpAAFAwAAAAAACgkQaMKH38aoAia7
BQ//RL7Ngr9JjDrC0Xs5DiScK9PY02RGr+SIu5+Cb3xWMmZmOYb9zsKS7f7S3/QuGRCz3k2OYvL/
8p1pPMk2wGYwUrlIT5UFTyBugl1ZYc3QtFd2e6PuNvrTZ0jjrxU7d4BxnNUVpayqa8FpdlNJV9k/
HqVOl+TtI25Osy6odP16EDnQqNjfun5F4SOl4Vt38/EFhBi/KalbNaik42I7tsB3LVhCbSlql+LF
na+FSdkQD3qId52qFhyJirO2ra1x8PtrWrseG94LdWXZFfcGHVqZ6Z5odb1P3dFdPfz8DHAKq0Pj
DFAedumuTtdOrfQPYrpQztJzvDLVJ65ekGpT7paTx3qDpHGxSxXSR74SoCwx+wPBPEZTU6nz6tB4
iiwdwSTN5wsD2L7Q09fgsNd/OuDQzKRZLBBRhJ8h4vMZMPopzD5iurtjhSChXg1MnCrO4jR98vRU
ZHqq4hSRTVZ5C3kSJC7IO1PHsHu+mHhyihX271ruPid9MJlXMry7wYjcghopIQ1l4WjEx6dt0SO5
bD/hvM8TgEAPs3IFrZZLhuTQcQBRx7MVocFYydVwWlsvlCtXS+kz3V6hlAKZpfHlvopgK8jq7Ojt
PvZg/6zjJeyw0Kd1wcVUU3PNcTaMWiTSQmFfwd4zSQD/3kPq1O4hUMZPsOxKU646MYGStYdgt4Mt
l2E=
=l4z3
-----END PGP SIGNATURE-----

--------------DgjxzZJeDQxaqEshSAPh35AG--
