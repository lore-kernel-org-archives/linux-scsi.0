Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794673789;
	b=djKxpp7TJMJixJEMAeoOhAq2choV7vyZbfuCyFQzb2iL6jceHRQoZrkRK4gWBnu6j0kP
	 ZM6mAGOiKlpuvmz1A4MtVuXNHvKZtoUyBh2phLhTjCUsZalhD26Z+CXySbJW+ObHWirxm
	 SKePEj5Qa1oJ04A13x2LgjKjiy3o7Q4kWYp5ldKTy2+TcWYemwruWkZT8OIkcfHSmxuJg
	 Duv/ZtlZ2ez3p2o8XobNJJYN5kXUkJKzi0KDIl5mRfZb3gqOp0rq0eJ0Z63EBNlipFJC/
	 6BwpfhH2x89IUPqFhrlm15dn/n1wwhZEpuubOfOcpVQNSeSIEuyBXix2KioU6hMlPxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794673789;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=n2A4Bzesj8lSex24jcQa4eIw8NYUbc0vDdMOEEExUHk=;
	b=yPVC8JPfXji1EbNwJaVGJLcRGyYE/D9tK7ZkrcER+mUcQrZACXouqIZ3R6nd5KmOo8vT
	 23L1ohXX9DkfoN/RO4u1DLjmWbBARw/Z1zcpqJ9EDH0VvDOm/ADbHtcam6N9IV7xPn32x
	 RDDvrUVd6BTr+mtHTuXsEtgX85sK91eWfgA05lZ2Dvf1DxagQp0E83qPmjvQbltMAM4rr
	 2V1tJwwlrA42UtXbuz1eY0RJ+UZLbiPA0zOL/ql2i26QVvqWDb3z6GuXjZNibxG2VmGXM
	 Q5obVVYnA1ktzHq0/UEFMJxhT9/Lc3+kaEnpZPPh0nokIpZsQkWaW7oKhuT1jTqtSyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=FWTmrb22;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=XLh9n5eg;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B9B606A885
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 16:29:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8B9B606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=FWTmrb22;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=XLh9n5eg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794673787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n2A4Bzesj8lSex24jcQa4eIw8NYUbc0vDdMOEEExUHk=;
	b=FWTmrb22rWwHJit/J5xIk/lI+m5d3d39zFIHqlGnmhSzkrynClUpOgJj3YbsioeJphFgzK
	C0sURtdHo3ELmegAvMN1197XsXbqIdnwdGfqxfgTdxIabaI3djdBvJYthCKoV95coViYre
	/OQOmVMpXCGItvV/K2r28wtwovZ49aA=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-164-GVGFiecQM1Gx3Wvdj3C4BQ-1; Sat, 14 Nov 2026 11:29:46 -0500
X-MC-Unique: GVGFiecQM1Gx3Wvdj3C4BQ-1
X-Mimecast-MFC-AGG-ID: GVGFiecQM1Gx3Wvdj3C4BQ_1794673786
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-54af6c38073so48900661cf.1
        for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 08:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794673785; x=1795278585; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=n2A4Bzesj8lSex24jcQa4eIw8NYUbc0vDdMOEEExUHk=;
        b=XLh9n5egP3d24HEk110Mtb2c59R6jhr+FRjowd3xXFPMBfYcrgjQY73J1dmTZ3UwRP
         5KfzLvlEZDJYrl8jxflyy2CfUiFHxvU9/bDtSWTyetSLAUFgVvvx7ekX87Rn1rLwn4he
         73Y6blT1SodfJ/ihPjlzR532Kbcl1z/g5FHYyoKIvP1ehYodTkxnJcyq1hVHld73Wv2+
         51MOUw6SnA2V0Xy+cAqVD+wVnoDuJJBMtDHIomoXmvfzb/3bSlZM4j7ACZ299mS7g4Uz
         fOGPozXs/1EYnUH6hHVmjsAhQMZMEBEOtRxs7jYX05feASaK8R4ao14ymzFPF9XIyUF+
         GELg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794673785; x=1795278585;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n2A4Bzesj8lSex24jcQa4eIw8NYUbc0vDdMOEEExUHk=;
        b=wyVfh84PASLDF11MviuLa5Q/+E2v6epR0Hi7jPZGWXsGD5djnDo7yy92kHJxNc1D6s
         nnLDNRw028cgS037yH2W8sJtrG/RH7CpAO1zvaY8KifqOodxLyzVoEuSgr/U5v2TR3Ob
         XDJMaksaYbaROPIC9iyyxl+fQ8S0W16qw/YHaIwnLeZAkV8xaXoQL4oyFWyDiMTyOqod
         PNU2gy/8c26IsW8R10vyAkvY9FGB/4afxT/PXeiRPvu7ho9+q6q6fhXXPWacfyxdLExH
         h4QIuLfSwiJCWdblKP6iU09CS25Y4+RnDCmKJ9ICyvg/LrtR5uwIlK/0EIQ5yYvmSuM1
         O9ag==
X-Forwarded-Encrypted: i=1; AL+hErED17aPX3ZUMoAUmNSdF7UNG8tm23z8nA5pv5iXF3VQjq9uFVOcRluBL9REfypCWgCjKfdcH9jIdpOm@vger.kernel.org
X-Gm-Message-State: APuU4Z/xo1THPShK+4lMblQIPmTln0oGR+w9ooANR8Vn8HOSvSBXNxew
	Fx/A8xmHpXLKnUHiBoxhjEleFpUI6ROmW5EuXk6BCbJvCgrh4i05doH+3y1I3g/RULHfT+KhEjD
	PjxOEzVF1pEAAPSMxQKoBIFAl4XMRgUZgFiF0ePtLz9qRi8hodgcRvncjWJKmieo=
X-Gm-Gg: AYBFou3H/T8ooNQCT8ly6FRoTShnh8bqt6JL5UMxWmaUoHzRGgYOEiI4aFZHxNtYYYz
	BEHBRceSWvTsVoI9Id7v6BfLZCd7fC3+lH8FANxKkCdHG/JmJV3UiO4lZ/1ast5SVnJHKp/KzMX
	+5jLxGz6AWH14i0Tp8wIqR35UV8kAtMbDlgr4Wo10Vd/2+N+TTwnGfcEtb7E+b0pD+4E4jspIlP
	Tr7Ke9DNQRkq3rnq8Xt8EcBKhBRfe29hACzU9k2LZjjfKwVW12+/kMtV02msKE0o3AiJI37eDM+
	fznuimPM+VOC2juMYwpObKkkZcmFWX+SHj0QIbX0zq2maNUCtlLFksFM/8YxxOsfA5iypc+1ypk
	AlUZqXrlkG7KbN0ItliuEwbo11ydjUgkTxMdU/s3fGDcCS0Epz61nOs1ERRZckl0yhomlSOQcyJ
	watQN335cgdnwLangy48B0c2eab8V2mhPVoCQMP+UiZMX/Q2NTY5eatwsuH/QgcKt5O+LAcg==
X-Received: by 2002:ac8:5d4b:0:b0:533:95c1:fb11 with SMTP id d75a77b69052e-55956e5d97cmr146589431cf.28.1794673785376;
        Sat, 14 Nov 2026 08:29:45 -0800 (PST)
X-Received: by 2002:ac8:5d4b:0:b0:533:95c1:fb11 with SMTP id d75a77b69052e-55956e5d97cmr146589201cf.28.1794673784936;
        Sat, 14 Nov 2026 08:29:44 -0800 (PST)
Received: from loberman-thinkpadp1gen5.rmtusma.csb ([2600:6c65:2440:d8c:929c:b769:6def:faa3])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d453casm46039086d6.10.2026.11.14.08.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 08:29:44 -0800 (PST)
Message-ID: <72c69ee88f292a008173bb84a7335330d3415b71.camel@redhat.com>
Subject: Re: [PATCH v9 00/29] Native SCSI Multipath support
From: Laurence Oberman <loberman@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, John Garry
	 <john.garry@linux.dev>
Cc: hare@suse.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, 	snitzer@kernel.org, jmeneghi@redhat.com,
 dm-devel@lists.linux.dev, hch@lst.de, 	michael.christie@oracle.com, "James
 E.J. Bottomley"	 <James.Bottomley@HansenPartnership.com>, mkp@kernel.org,
 Benjamin Marzinski	 <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>
Date: Sat, 14 Nov 2026 11:29:43 -0500
In-Reply-To: <00e03246-95dc-46dd-a2f9-89ad88f177d1@gmail.com>
References: <20261108204733.557995-1-john.garry@linux.dev>
	 <9b90edc29d5b3be49f5bd0e0ecec5f1701e089bf.camel@redhat.com>
	 <3332329d-b922-45a4-8333-e8353e983885@linux.dev>
	 <00e03246-95dc-46dd-a2f9-89ad88f177d1@gmail.com>
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

T24gU2F0LCAyMDI2LTExLTE0IGF0IDE0OjAzICswMTAwLCBYb3NlIFZhenF1ZXogUGVyZXogd3Jv
dGU6Cj4gT24gMTEvMTAvMjYgMTA6MDUgQU0sIEpvaG4gR2Fycnkgd3JvdGU6Cj4gCj4gPiBPbiAx
MS85LzI2IDIwOjE5LCBMYXVyZW5jZSBPYmVybWFuIHdyb3RlOgo+ID4gPiAzLiBTbWFsbGVyIHBv
aW50cwo+ID4gPiAKPiA+ID4gLSBudW1hIHdpdGggZXF1YWwgTlVNQSBkaXN0YW5jZSB1c2VzIG9u
ZSBwYXRoIHBlciBMVU4sIHNvIHdpdGgKPiA+ID4gdHdvIEFPCj4gPiA+IMKgwqAgcGF0aHMgdGhy
b3VnaCB0d28gSEJBcywgaGFsZiB0aGUgb3B0aW1pemVkIGJhbmR3aWR0aCBpcyBpZGxlCj4gPiA+
IChzZGw6Mgo+ID4gPiDCoMKgIGFib3ZlIHVuZGVyIG51bWEpLiBUaGF0IG1hdGNoZXMgTlZNZSwg
YnV0IHVzZXJzIGNvbWluZyBmcm9tCj4gPiA+IMKgwqAgZG0tbXVsdGlwYXRoIHNlcnZpY2UtdGlt
ZSB3aWxsIG5vdGljZS4gV291bGQgcm91bmQtcm9iaW4gb3IKPiA+ID4gwqDCoCBxdWV1ZS1kZXB0
aCBiZSBhIGJldHRlciBkZWZhdWx0IGZvciBTQ1NJPwo+ID4gCj4gPiBNYXliZSwgYnV0IHJvdW5k
LXJvYmluIG1heSBub3QgYmUgYWx3YXlzIGlkZWFsIGNvbnNpZGVyaW5nIG9ubHkgYQo+ID4gYmlv
IG1vZGUgb2Ygb3BlcmF0aW9uIGlzIHN1cHBvcnRlZCBhbmQgbm8gbWVyZ2luZyBsaWtlIGRtLW1w
YXRoIFJRCj4gPiBtb2RlLgo+IAo+IGlvcG9saWN5IGNhbiBlYXNpbHkgYmUgY3VzdG9taXplZCBw
ZXIgYXJyYXkvZGV2aWNlIHZpYSB1ZGV2IHJ1bGVzLgo+IEp1c3QgbGlrZSBpdCdzIGRvbmUgZm9y
IE5WTWU6Cj4gaHR0cHM6Ly9naXRodWIuY29tL2xpbnV4LW52bWUvbnZtZS1jbGkvYmxvYi9tYXN0
ZXIvbnZtZi1hdXRvY29ubmVjdC91ZGV2LXJ1bGVzLzcxLW52bWYtaHBlLnJ1bGVzLmluCj4gCj4g
QWRkaXRpb25hbGx5LCAic2VydmljZS10aW1lIiBhbmQgImxhdGVuY3kiIEkvTyBwb2xpY2llcyBh
cmUgY3VycmVudGx5Cj4gdW5kZXIKPiBkZXZlbG9wbWVudDoKPiBodHRwczovL2xvcmUua2VybmVs
Lm9yZy9saW51eC1udm1lLzIwMjYxMDI2MTExMDE5LjM3MjQ0NjUtMS1rYW5pZUBsaW51eC5hbGli
YWJhLmNvbS9ULwo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LW52bWUvMjAyNjA4MTUx
NzM1MDIuMTE4NTkyOS0xLW5pbGF5QGxpbnV4LmlibS5jb20vVC8KPiAKPiA+ID4gLSBUaGVyZSBp
cyBubyB1c2Vyc3BhY2UgdG9vbCB5ZXQgdG8gc2hvdyBoZWFkcywgcGF0aHMgYW5kIEFMVUEKPiA+
ID4gc3RhdGUKPiA+ID4gwqDCoCAodGhlIGVxdWl2YWxlbnQgb2YgbXVsdGlwYXRoIC1sbCBvciBu
dm1lIGxpc3Qtc3Vic3lzKS4gSSB1c2VkCj4gPiA+IGEKPiA+ID4gwqDCoCBzbWFsbCBzeXNmcyBz
Y3JpcHQgZm9yIHRoaXMgdGVzdGluZy4gQmVuLCBpcyBuYXRpdmUgU0NTSQo+ID4gPiBtdWx0aXBh
dGgKPiA+ID4gwqDCoCBzdXBwb3J0IGluIG11bHRpcGF0aC10b29scyBwbGFubmVkPwo+ID4gCj4g
PiBXZWxsLCB0aGUgd2hvbGUgcG9pbnQgaXMgdGhhdCB3ZSBkb24ndCBuZWVkIHVzZXJzcGFjZSB0
b29scy4KPiA+IEhvd2V2ZXIsIEkgYXBwcmVjaWF0ZSB0aGF0IHRoZXJlIGlzIG5vIGdlbmVyYWwg
U0NTSSB0b29saW5nIHdoaWNoCj4gPiBjb3VsZCBoZWxwIGhlcmUuIEkga25vdyB0aGF0IEhpbWFu
c2h1IE0gZGlkIHdvcmsgb24gYSBTQ1NJIHZlcnNpb24KPiA+IG9mIAo+ID4gbnZtZS1jbGkgdG9v
bCBwcmV2aW91c2x5LiBNYXJ0aW4gbWF5IGtub3cgdGhlIHN0YXR1cyBvZiB0aGF0Lgo+IAo+IEFn
cmVlZCB0aGF0IHVzZXJzcGFjZSB0b29scyBhcmUgbm90IHN0cmljdGx5IG5lZWRlZCBmb3IKPiBj
b25maWd1cmF0aW9uLCBidXQKPiBvYnNlcnZhYmlsaXR5IGlzIGtleS4KPiBBIHN0YW5kYXJkIHV0
aWxpdHkgdG8gdmlzdWFsaXplIHRoZSBkZXZpY2UgdG9wb2xvZ3ksIHBhdGggaGVhbHRoIGFuZAo+
IEFMVUEKPiBzdGF0ZXMgYXQgYSBnbGFuY2UsIHNpbWlsYXIgdG8gd2hhdCBtdWx0aXBhdGgtdG9v
bHMgcHJvdmlkZXMsIHdvdWxkCj4gc2F2ZSBhCj4gbG90IG9mIGZyaWN0aW9uIGZvciBzeXNhZG1p
bnMgbWlncmF0aW5nIGF3YXkgZnJvbSBkbS1tdWx0aXBhdGguCj4gUmVseWluZyBzb2xlbHkgb24g
YWQtaG9jIHNjcmlwdHMgb3IgbWFudWFsIHN5c2ZzIHBhcnNpbmcgY2FuIGJlY29tZQo+IHF1aXRl
Cj4gdGVkaW91cyBpbiBwcm9kdWN0aW9uIGVudmlyb25tZW50cy4KSGVsbG8gWG9zZQoKSSBoYXZl
IGEgd29ya2luZyBydXN0IGJhc2VkIHVzZXJzcGFjZSB0b29sIGZvciB0aGlzLiBJdCBzdGFydGVk
IGFzIGEKcGF0aCBhbmQgSU9QUyBtb25pdG9yIGFuZCB3b3JrcyB3ZWxsLiBJIGFtIGNsZWFuaW5n
IGl0IHVwIHRoaXMgd2Vla2VuZAphbmQgd2lsbCBzaGFyZSBhIHJlcG8gbmV4dCB3ZWVrLgoKVGhl
IGVtYWlsIGNsaWVudCB3cmFwcyB0aGUgbGluZXMsIGxvb2tzIGJldHRlciBvbiB0aGUgd2lkZXIg
c2NyZWVuCgoKPT09IE5WTWUgUGVyLVBhdGggTW9uaXRvciA9PT0KCm52bWUtc3Vic3lzMCAgICAg
TlFOOiBsb2JlCiAgICAgICAgICAgICAgICAgaW9wb2xpY3k6IG51bWEKClNhbXBsZSBpbnRlcnZh
bDogMXMgfCBsYXRlbmN5OiBhdmVyYWdlIHBlciBjb21wbGV0ZWQgSS9PIGluIHRoaXMKaW50ZXJ2
YWwKClBBVEggICAgICAgICAgIENUUkwgICAgICAgQU5BIFNUQVRFICAgICAgVFJBTlNQT1JUICAg
ICAgICAgICAgICAgICAgUgpJT1BTICAgVyBJT1BTICBSIEFWRyBMQVQgIFcgQVZHIExBVCAgICAg
IFJFQUQgQlcgICAgIFdSSVRFIEJXCuKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgAoK4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSACm52bWUwYzFuMSAgICAgIG52bWUxICAgICAgb3B0aW1pemVkICAg
ICAgcmRtYToxOTIuMTY4LjIuMjU0OjQ0MjAgICAgCjU5LjVLICAgIDU5LjZLICAgIDE3LjgybXMg
ICAgMTUuNzZtcyAgIDIzMi4zIE1CL3MgICAyMzIuOCBNQi9zCm52bWUwYzJuMSAgICAgIG52bWUy
ICAgICAgb3B0aW1pemVkICAgICAgcmRtYToxOTIuMTY4LjEuMjU0OjQ0MjAgICAgICAKMCAgICAg
ICAgMCAgICAgICAgICAtICAgICAgICAgIC0gICAgICAgIDAgQi9zICAgICAgICAwIEIvcwoKQ2hh
bmdlIHRvIHJvdW5kLXJvYmluCgo9PT0gTlZNZSBQZXItUGF0aCBNb25pdG9yID09PQoKbnZtZS1z
dWJzeXMwICAgICBOUU46IGxvYmUKICAgICAgICAgICAgICAgICBpb3BvbGljeTogcm91bmQtcm9i
aW4KClNhbXBsZSBpbnRlcnZhbDogMXMgfCBsYXRlbmN5OiBhdmVyYWdlIHBlciBjb21wbGV0ZWQg
SS9PIGluIHRoaXMKaW50ZXJ2YWwKClBBVEggICAgICAgICAgIENUUkwgICAgICAgQU5BIFNUQVRF
ICAgICAgVFJBTlNQT1JUICAgICAgICAgICAgICAgICAgUgpJT1BTICAgVyBJT1BTICBSIEFWRyBM
QVQgIFcgQVZHIExBVCAgICAgIFJFQUQgQlcgICAgIFdSSVRFIEJXCuKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgAoK4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSACm52bWUwYzFuMSAgICAgIG52bWUx
ICAgICAgb3B0aW1pemVkICAgICAgcmRtYToxOTIuMTY4LjIuMjU0OjQ0MjAgICAgCjE1LjJLICAg
IDE1LjJLICAgIDEzLjUybXMgICAgMTEuMDRtcyAgIDExOC44IE1CL3MgICAxMTguNiBNQi9zCm52
bWUwYzJuMSAgICAgIG52bWUyICAgICAgb3B0aW1pemVkICAgICAgcmRtYToxOTIuMTY4LjEuMjU0
OjQ0MjAgICAgCjE0LjlLICAgIDE1LjVLICAgIDU0LjIybXMgICAgNjMuMjNtcyAgIDExNi42IE1C
L3MgICAxMjEuMSBNQi9zCgpUaGFua3MKTGF1cmVuY2UK

