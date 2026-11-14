Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794686371;
	b=tL/X32nle2l23c8mKkvk+x1h7kcb+6ph0vY31BvI49LHTYS4eS+HiVGApOKLZnJZzvqV
	 Yhpfk/hyfqH4jyhizxnC8VYBbaw2or4mDu45o7eAWUgfBcKybyGQMWjghzGqKP9OR2MXU
	 tSzSCcm/czZ+DZ4zjrRw+92NqX6tmpnkaEsZlY3DfiDlYzkLYYt/+5+682OuO9E2s+ajs
	 64OQMIUvwOr8z2aRi7ujpcHi3ePOkg5wzF1tiYDn6MeuQbCaUUBtZ9LEqKLuewHEZ478Z
	 qyPb3Zx2BjCSSI7Yr9EBjvl7RL1CGNkojUGRVOlxSw/Yzp6ohlS2HKExrdgbmLxZ71Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794686371;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=uFXNoy6gP0yH6T4s0vbljgaUMgktLJ38QS3jqGJ3hsM=;
	b=ImOJ9AmOP2d6fp+dvSjvD+Au9KNGIlQfZZyKfpH54QtrEl7YhhIsJxKbn4N5QoLko1LD
	 96mFxYNW08GR9Z0JsVAs6jm2qV8nLo+hnuaLRAt8ZbsIjYvU3RTUuVmPm65+GVG2Ip14r
	 0W0BdzA2FwhT5IDx+mJiDEzTHHgVAVi6xAhUzk2EHVWwXf1q0VHbR6AkjsG9I+pRhyhO7
	 8vffsFWSbgcpC8t/S3/rmbi2z/Tj5V0qnQJgV7xHOFfHnk6/oWYgU5WckFGugySzxtzpI
	 go8D91DfaAqZX7pgkKvGg/Pq2JoisHIXU8znbNzbohf4jUO65vHwT0zEdpDyqpPRqKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=borgmneH;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=P5V6fBTK;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBCC606A32D
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 19:59:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCBCC606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=borgmneH;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=P5V6fBTK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794686366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uFXNoy6gP0yH6T4s0vbljgaUMgktLJ38QS3jqGJ3hsM=;
	b=borgmneHUsduweAVn+S8+BkGGNJMobUejoy0K2PkGoB5DIFj4y0vN12kvRCdNAPBZIiF16
	4ZVHJ5pOF5dZUBpT6ZlFPPs1P2eg9wiNNl7mt4KJPyv4BuAB6LHijZX52bguwKwgK5HOYB
	MvrlQgLWAOwd0x7+Zzg1AWNDFHiD/7Y=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-StJYhIXjM-y2o_ypObWsXA-1; Sat, 14 Nov 2026 14:59:22 -0500
X-MC-Unique: StJYhIXjM-y2o_ypObWsXA-1
X-Mimecast-MFC-AGG-ID: StJYhIXjM-y2o_ypObWsXA_1794686362
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-55c826e557fso15055311cf.1
        for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 11:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794686362; x=1795291162; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=uFXNoy6gP0yH6T4s0vbljgaUMgktLJ38QS3jqGJ3hsM=;
        b=P5V6fBTK7VdWzN/be1MLHNR1qSMg4DPN8t+6WbDe1RHkr46luupbdXdUt6b7Xb+3lA
         xv+AdhBRupTYpaDP+Hy6MWD1xFGvV/MqmcygjGULZdFGLlmBL8wlfBBsoJuuVTuzF8kB
         hjHiHVtKc1aTxM6ABP18uPHq7SF27OUJ8ZxLFuVvTYRfcCqwLtpjyjhIrILSYkk25/p2
         Wavrfwb6aDrctMkPmuvnI1fT1N1kCmfvoi05QDEKOt39+Wiie9OQ6pp7wuE1B3gavx/J
         RhsSQUW6Ji0rt5/v2hpnuUQxZjfVkRWMdPAVDfreq17tUtYZjq8iex//ByD6WMCDjJ4m
         aDxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686362; x=1795291162;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uFXNoy6gP0yH6T4s0vbljgaUMgktLJ38QS3jqGJ3hsM=;
        b=Bqo/PJTXoduHi3fjc0royL6sJUr64WECt3q6H9fVaORQsgdOo7/PZIF7Nf1gRQrcxC
         F4J9xvTH7K8F1ludcq0cyDkVbSkmoAH+p7OF7EkX3DU7Gm91DJbtHRUI0AT/vdlcLUOD
         3BpzCH6EAqI5o4MDN9oYM+JMPqPndympbFE5aSsEnoH3k4peyyEeISsNZVt9fUm0VL+D
         m+lxZIoMlTH/8AytqCyYNcYQdTA12oyDN54FP0h48qwCrMOEykdjeZcjL4sqTvJuparv
         bdUtKmcuT3SFyn+1gyqHaOuVSsaTerOgOEbDQoZBxzb1w0oj0eEF1sUWRjxA/vx/UgHg
         2GBA==
X-Forwarded-Encrypted: i=1; AL+hErG8w9c4l+9l8yQ5GSbNZO0BU4DFpbLus2YZ6juu2/76R+fhv20zc6+HLSPAeUE8hbvocctXz8PkX8ys@vger.kernel.org
X-Gm-Message-State: APuU4Z9F6Kp3Y1D6yR/ZUCDToksisuRgiYP5N3EDfW10+c0f5IOLp6Hr
	b8/PFWsTFuIfvYOgNoo9wSZ9Ue29tfvJLNrQsjlF3hXhRog6iTFO6W5KXqygfWm3V+IENg9bCYU
	mbPjNf3OFbXVekZAa0dOXNyXF1QCJMb+qgXLfFuQe0QcPxwsNLA+loMvjMKhGy24=
X-Gm-Gg: AYBFou1OfJ4ba5yXZcz91n49l++TpEsmw6cIT7+8k3g514XsCa1PnQ3bwjUB1K25Sul
	4vyvLSX7MV8V8+JKfD5LGxOO01sAf9PbvC/QMKPQSumIBkJLzZC1lECsig/4xp8aVigHq4tgS3a
	mRCeIO5X5QX0xdNYAJRBETvb1Vvmr5nqRZf5SreF3chhGbciSQuz0YGLONR3Kxkv/gIR2ZnIyjy
	+Le8PIb5t+2mWwWxTmvsGGUX/5YwHH3CKmQn+vx+wud9GplAnMt88NaHCGipehUiNxH1YVjsESu
	mzfj/TlMqLhBmXkTXctnbASrLPQ4NVkbZy+hKEOPkBtYwpGk3hUUXs0nMZ4IGjI7533xx/F1lFg
	keQixnTr6YNVcHUxqvrMjDdVxWUZZb0vKLcI0HE1bNHDQGLx9KMQwipc6AsrvLdoswOYqnUVYwE
	rmaEUJBICgwvTMKwXYfFB9SuQKanJ3kBh1YkV14DR6GdgmY6grvrOp9TCmko3LkYBPxO/iIQ==
X-Received: by 2002:a05:622a:598e:b0:55c:f671:99be with SMTP id d75a77b69052e-55cf6719b5bmr26849021cf.47.1794686361886;
        Sat, 14 Nov 2026 11:59:21 -0800 (PST)
X-Received: by 2002:a05:622a:598e:b0:55c:f671:99be with SMTP id d75a77b69052e-55cf6719b5bmr26848801cf.47.1794686361370;
        Sat, 14 Nov 2026 11:59:21 -0800 (PST)
Received: from loberman-thinkpadp1gen5.rmtusma.csb ([2600:6c65:2440:d8c:929c:b769:6def:faa3])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55ad043f2f7sm46189161cf.5.2026.11.14.11.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 11:59:20 -0800 (PST)
Message-ID: <74d88ab7faf32dbcfd22e508defa695c217c0a67.camel@redhat.com>
Subject: Re: [PATCH v9 00/29] Native SCSI Multipath support
From: Laurence Oberman <loberman@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, John Garry
	 <john.garry@linux.dev>
Cc: hare@suse.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, 	snitzer@kernel.org, jmeneghi@redhat.com,
 dm-devel@lists.linux.dev, hch@lst.de, 	michael.christie@oracle.com, "James
 E.J. Bottomley"	 <James.Bottomley@HansenPartnership.com>, mkp@kernel.org,
 Benjamin Marzinski	 <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>
Date: Sat, 14 Nov 2026 14:59:19 -0500
In-Reply-To: <72c69ee88f292a008173bb84a7335330d3415b71.camel@redhat.com>
References: <20261108204733.557995-1-john.garry@linux.dev>
		 <9b90edc29d5b3be49f5bd0e0ecec5f1701e089bf.camel@redhat.com>
		 <3332329d-b922-45a4-8333-e8353e983885@linux.dev>
		 <00e03246-95dc-46dd-a2f9-89ad88f177d1@gmail.com>
	 <72c69ee88f292a008173bb84a7335330d3415b71.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

T24gU2F0LCAyMDI2LTExLTE0IGF0IDExOjI5IC0wNTAwLCBMYXVyZW5jZSBPYmVybWFuIHdyb3Rl
Ogo+IE9uIFNhdCwgMjAyNi0xMS0xNCBhdCAxNDowMyArMDEwMCwgWG9zZSBWYXpxdWV6IFBlcmV6
IHdyb3RlOgo+ID4gT24gMTEvMTAvMjYgMTA6MDUgQU0sIEpvaG4gR2Fycnkgd3JvdGU6Cj4gPiAK
PiA+ID4gT24gMTEvOS8yNiAyMDoxOSwgTGF1cmVuY2UgT2Jlcm1hbiB3cm90ZToKPiA+ID4gPiAz
LiBTbWFsbGVyIHBvaW50cwo+ID4gPiA+IAo+ID4gPiA+IC0gbnVtYSB3aXRoIGVxdWFsIE5VTUEg
ZGlzdGFuY2UgdXNlcyBvbmUgcGF0aCBwZXIgTFVOLCBzbyB3aXRoCj4gPiA+ID4gdHdvIEFPCj4g
PiA+ID4gwqDCoCBwYXRocyB0aHJvdWdoIHR3byBIQkFzLCBoYWxmIHRoZSBvcHRpbWl6ZWQgYmFu
ZHdpZHRoIGlzIGlkbGUKPiA+ID4gPiAoc2RsOjIKPiA+ID4gPiDCoMKgIGFib3ZlIHVuZGVyIG51
bWEpLiBUaGF0IG1hdGNoZXMgTlZNZSwgYnV0IHVzZXJzIGNvbWluZyBmcm9tCj4gPiA+ID4gwqDC
oCBkbS1tdWx0aXBhdGggc2VydmljZS10aW1lIHdpbGwgbm90aWNlLiBXb3VsZCByb3VuZC1yb2Jp
biBvcgo+ID4gPiA+IMKgwqAgcXVldWUtZGVwdGggYmUgYSBiZXR0ZXIgZGVmYXVsdCBmb3IgU0NT
ST8KPiA+ID4gCj4gPiA+IE1heWJlLCBidXQgcm91bmQtcm9iaW4gbWF5IG5vdCBiZSBhbHdheXMg
aWRlYWwgY29uc2lkZXJpbmcgb25seSBhCj4gPiA+IGJpbyBtb2RlIG9mIG9wZXJhdGlvbiBpcyBz
dXBwb3J0ZWQgYW5kIG5vIG1lcmdpbmcgbGlrZSBkbS1tcGF0aAo+ID4gPiBSUQo+ID4gPiBtb2Rl
Lgo+ID4gCj4gPiBpb3BvbGljeSBjYW4gZWFzaWx5IGJlIGN1c3RvbWl6ZWQgcGVyIGFycmF5L2Rl
dmljZSB2aWEgdWRldiBydWxlcy4KPiA+IEp1c3QgbGlrZSBpdCdzIGRvbmUgZm9yIE5WTWU6Cj4g
PiBodHRwczovL2dpdGh1Yi5jb20vbGludXgtbnZtZS9udm1lLWNsaS9ibG9iL21hc3Rlci9udm1m
LWF1dG9jb25uZWN0L3VkZXYtcnVsZXMvNzEtbnZtZi1ocGUucnVsZXMuaW4KPiA+IAo+ID4gQWRk
aXRpb25hbGx5LCAic2VydmljZS10aW1lIiBhbmQgImxhdGVuY3kiIEkvTyBwb2xpY2llcyBhcmUK
PiA+IGN1cnJlbnRseQo+ID4gdW5kZXIKPiA+IGRldmVsb3BtZW50Ogo+ID4gaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvbGludXgtbnZtZS8yMDI2MTAyNjExMTAxOS4zNzI0NDY1LTEta2FuaWVAbGlu
dXguYWxpYmFiYS5jb20vVC8KPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LW52bWUv
MjAyNjA4MTUxNzM1MDIuMTE4NTkyOS0xLW5pbGF5QGxpbnV4LmlibS5jb20vVC8KPiA+IAo+ID4g
PiA+IC0gVGhlcmUgaXMgbm8gdXNlcnNwYWNlIHRvb2wgeWV0IHRvIHNob3cgaGVhZHMsIHBhdGhz
IGFuZCBBTFVBCj4gPiA+ID4gc3RhdGUKPiA+ID4gPiDCoMKgICh0aGUgZXF1aXZhbGVudCBvZiBt
dWx0aXBhdGggLWxsIG9yIG52bWUgbGlzdC1zdWJzeXMpLiBJCj4gPiA+ID4gdXNlZAo+ID4gPiA+
IGEKPiA+ID4gPiDCoMKgIHNtYWxsIHN5c2ZzIHNjcmlwdCBmb3IgdGhpcyB0ZXN0aW5nLiBCZW4s
IGlzIG5hdGl2ZSBTQ1NJCj4gPiA+ID4gbXVsdGlwYXRoCj4gPiA+ID4gwqDCoCBzdXBwb3J0IGlu
IG11bHRpcGF0aC10b29scyBwbGFubmVkPwo+ID4gPiAKPiA+ID4gV2VsbCwgdGhlIHdob2xlIHBv
aW50IGlzIHRoYXQgd2UgZG9uJ3QgbmVlZCB1c2Vyc3BhY2UgdG9vbHMuCj4gPiA+IEhvd2V2ZXIs
IEkgYXBwcmVjaWF0ZSB0aGF0IHRoZXJlIGlzIG5vIGdlbmVyYWwgU0NTSSB0b29saW5nIHdoaWNo
Cj4gPiA+IGNvdWxkIGhlbHAgaGVyZS4gSSBrbm93IHRoYXQgSGltYW5zaHUgTSBkaWQgd29yayBv
biBhIFNDU0kKPiA+ID4gdmVyc2lvbgo+ID4gPiBvZiAKPiA+ID4gbnZtZS1jbGkgdG9vbCBwcmV2
aW91c2x5LiBNYXJ0aW4gbWF5IGtub3cgdGhlIHN0YXR1cyBvZiB0aGF0Lgo+ID4gCj4gPiBBZ3Jl
ZWQgdGhhdCB1c2Vyc3BhY2UgdG9vbHMgYXJlIG5vdCBzdHJpY3RseSBuZWVkZWQgZm9yCj4gPiBj
b25maWd1cmF0aW9uLCBidXQKPiA+IG9ic2VydmFiaWxpdHkgaXMga2V5Lgo+ID4gQSBzdGFuZGFy
ZCB1dGlsaXR5IHRvIHZpc3VhbGl6ZSB0aGUgZGV2aWNlIHRvcG9sb2d5LCBwYXRoIGhlYWx0aAo+
ID4gYW5kCj4gPiBBTFVBCj4gPiBzdGF0ZXMgYXQgYSBnbGFuY2UsIHNpbWlsYXIgdG8gd2hhdCBt
dWx0aXBhdGgtdG9vbHMgcHJvdmlkZXMsIHdvdWxkCj4gPiBzYXZlIGEKPiA+IGxvdCBvZiBmcmlj
dGlvbiBmb3Igc3lzYWRtaW5zIG1pZ3JhdGluZyBhd2F5IGZyb20gZG0tbXVsdGlwYXRoLgo+ID4g
UmVseWluZyBzb2xlbHkgb24gYWQtaG9jIHNjcmlwdHMgb3IgbWFudWFsIHN5c2ZzIHBhcnNpbmcg
Y2FuIGJlY29tZQo+ID4gcXVpdGUKPiA+IHRlZGlvdXMgaW4gcHJvZHVjdGlvbiBlbnZpcm9ubWVu
dHMuCj4gSGVsbG8gWG9zZQo+IAo+IEkgaGF2ZSBhIHdvcmtpbmcgcnVzdCBiYXNlZCB1c2Vyc3Bh
Y2UgdG9vbCBmb3IgdGhpcy4gSXQgc3RhcnRlZCBhcyBhCj4gcGF0aCBhbmQgSU9QUyBtb25pdG9y
IGFuZCB3b3JrcyB3ZWxsLiBJIGFtIGNsZWFuaW5nIGl0IHVwIHRoaXMKPiB3ZWVrZW5kCj4gYW5k
IHdpbGwgc2hhcmUgYSByZXBvIG5leHQgd2Vlay4KPiAKPiBUaGUgZW1haWwgY2xpZW50IHdyYXBz
IHRoZSBsaW5lcywgbG9va3MgYmV0dGVyIG9uIHRoZSB3aWRlciBzY3JlZW4KPiAKPiAKPiA9PT0g
TlZNZSBQZXItUGF0aCBNb25pdG9yID09PQo+IAo+IG52bWUtc3Vic3lzMMKgwqDCoMKgIE5RTjog
bG9iZQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlvcG9saWN5OiBudW1hCj4g
Cj4gU2FtcGxlIGludGVydmFsOiAxcyB8IGxhdGVuY3k6IGF2ZXJhZ2UgcGVyIGNvbXBsZXRlZCBJ
L08gaW4gdGhpcwo+IGludGVydmFsCj4gCj4gUEFUSMKgwqDCoMKgwqDCoMKgwqDCoMKgIENUUkzC
oMKgwqDCoMKgwqAgQU5BIFNUQVRFwqDCoMKgwqDCoCBUUkFOU1BPUlTCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIFIKPiBJT1BTwqDCoCBXIElPUFPCoCBSIEFWRyBMQVTCoCBXIEFW
RyBMQVTCoMKgwqDCoMKgIFJFQUQgQlfCoMKgwqDCoCBXUklURSBCVwo+IOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgAo+IOKUgOKUgAo+IAo+IOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgAo+IG52bWUwYzFu
McKgwqDCoMKgwqAgbnZtZTHCoMKgwqDCoMKgIG9wdGltaXplZMKgwqDCoMKgwqAgcmRtYToxOTIu
MTY4LjIuMjU0OjQ0MjDCoMKgwqAgCj4gNTkuNUvCoMKgwqAgNTkuNkvCoMKgwqAgMTcuODJtc8Kg
wqDCoCAxNS43Nm1zwqDCoCAyMzIuMyBNQi9zwqDCoCAyMzIuOCBNQi9zCj4gbnZtZTBjMm4xwqDC
oMKgwqDCoCBudm1lMsKgwqDCoMKgwqAgb3B0aW1pemVkwqDCoMKgwqDCoCByZG1hOjE5Mi4xNjgu
MS4yNTQ6NDQyMMKgwqDCoMKgwqAKPiAwwqDCoMKgwqDCoMKgwqAgMMKgwqDCoMKgwqDCoMKgwqDC
oCAtwqDCoMKgwqDCoMKgwqDCoMKgIC3CoMKgwqDCoMKgwqDCoCAwIEIvc8KgwqDCoMKgwqDCoMKg
IDAgQi9zCj4gCj4gQ2hhbmdlIHRvIHJvdW5kLXJvYmluCj4gCj4gPT09IE5WTWUgUGVyLVBhdGgg
TW9uaXRvciA9PT0KPiAKPiBudm1lLXN1YnN5czDCoMKgwqDCoCBOUU46IGxvYmUKPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpb3BvbGljeTogcm91bmQtcm9iaW4KPiAKPiBTYW1w
bGUgaW50ZXJ2YWw6IDFzIHwgbGF0ZW5jeTogYXZlcmFnZSBwZXIgY29tcGxldGVkIEkvTyBpbiB0
aGlzCj4gaW50ZXJ2YWwKPiAKPiBQQVRIwqDCoMKgwqDCoMKgwqDCoMKgwqAgQ1RSTMKgwqDCoMKg
wqDCoCBBTkEgU1RBVEXCoMKgwqDCoMKgIFRSQU5TUE9SVMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgUgo+IElPUFPCoMKgIFcgSU9QU8KgIFIgQVZHIExBVMKgIFcgQVZHIExBVMKg
wqDCoMKgwqAgUkVBRCBCV8KgwqDCoMKgIFdSSVRFIEJXCj4g4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSACj4g4pSA4pSACj4gCj4g4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSACj4gbnZtZTBjMW4xwqDCoMKg
wqDCoCBudm1lMcKgwqDCoMKgwqAgb3B0aW1pemVkwqDCoMKgwqDCoCByZG1hOjE5Mi4xNjguMi4y
NTQ6NDQyMMKgwqDCoCAKPiAxNS4yS8KgwqDCoCAxNS4yS8KgwqDCoCAxMy41Mm1zwqDCoMKgIDEx
LjA0bXPCoMKgIDExOC44IE1CL3PCoMKgIDExOC42IE1CL3MKPiBudm1lMGMybjHCoMKgwqDCoMKg
IG52bWUywqDCoMKgwqDCoCBvcHRpbWl6ZWTCoMKgwqDCoMKgIHJkbWE6MTkyLjE2OC4xLjI1NDo0
NDIwwqDCoMKgIAo+IDE0LjlLwqDCoMKgIDE1LjVLwqDCoMKgIDU0LjIybXPCoMKgwqAgNjMuMjNt
c8KgwqAgMTE2LjYgTUIvc8KgwqAgMTIxLjEgTUIvcwo+IAo+IFRoYW5rcwo+IExhdXJlbmNlCgpT
ZWUgdGhlIFJFQURNRS5tZCwgbmVlZHMgY2FyZ28vcnVzdCB0byBidWlsZCBpdC4KCmdpdCBjbG9u
ZSBodHRwczovL2dpdGh1Yi5jb20vbG9iZXJtYW4vbnZtZS1zY3NpLXBhdGgtaW9wcy5naXQKY2Qg
bnZtZS1zY3NpLXBhdGgtaW9wcwpjYXJnbyBidWlsZCAtLXJlbGVhc2UKQmluYXJ5IHdpbGwgYmUg
aW4gdGFyZ2V0L3JlbGVhc2UvbnZtZS1wYXRoLWlvcHMKClRoaXMgaXMgd29ya2luZyB3ZWxsIGZv
ciBtZSB3aXRoIG5hdGl2ZSBudm1lIG11bHRpcGF0aCBhbmQgbmF0aXZlIHNjc2kKbXVsdGlwYXRo
LgoKTGV0IG1lIGtub3cgaWYgeW91IGxpa2UgaXQuCgpodHRwczovL2dpdGh1Yi5jb20vbG9iZXJt
YW4vbnZtZS1zY3NpLXBhdGgtaW9wcy5naXQK

