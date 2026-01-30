Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DA02E88BD
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jan 2026 10:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769768778; cv=none; b=bNOplyPluB+L8StYmLx6JWq5lQ60Xk64qw/61Fj4RSSxC+4sS8wwUdv3SPpUmf60nYBLO/YEDrfTu/D7SLtCbfK7vyW304Y7FoRCbqSqKaTEhUkN+SgODrakc0Rqnrrc1H8eMAfBk52CbMIoiK88fdC/3L39UZs87AaQ0NSt30Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769768778; c=relaxed/simple;
	bh=KmYz0oNxeQVadBzjVShsDQKy5NXY02pVfuF5hsbrBto=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dyoC7o7DrK/WUFzqplyBdzoFZZBlGo3+DIdP0hrqyFOYW2hQU3JGHUlT4Ze/eQlzzI2ekaylOdg03hEuDDzGkNihNdHOs2kZ+bTof0fVHBfV1awZWbXlHr92Gd23/hwDQxfqcmChp3LfLWfVa1wriWTfe60DKBKixmiuvsoVLx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dWzkMG+8; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dWzkMG+8"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b883787268fso290365466b.3
        for <linux-scsi@vger.kernel.org>; Fri, 30 Jan 2026 02:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769768776; x=1770373576; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KmYz0oNxeQVadBzjVShsDQKy5NXY02pVfuF5hsbrBto=;
        b=dWzkMG+8kDTPFWfTmAk6JQL3bjvjBybiWqiptqusFFERItdVxAKC5KOdZpGfkVzj3V
         PBTBWJ9xjPUTkfXWi0Ti8uI8OxZmsqUIabFv35ef/dJJNUiyvFG0CcA+XdMPTUqQnWjx
         iL0+Lm85xp2o3bmqJh5bfwGuAYHFbEYPv0pG9KmZE9cPdWGckYsDzIJJKMyIQyIpusQJ
         SGxZNQkA/shXlIvtyDmafQgaaoK2Z1O/rVbPtYMla+WR2SJtVT29Tbc8eR9Q10xZdNlL
         XAzUXTtanszpsUSzAXOHpjZNfWjk8AxBEdpWr/U99LL/4GA/fyIqv7N601V5h/8midut
         gNBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769768776; x=1770373576;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KmYz0oNxeQVadBzjVShsDQKy5NXY02pVfuF5hsbrBto=;
        b=spJda4rkLuQe33Nv2k+utVCfryCgAa/KpFgfsomCX4vek2i+O0CfB5ztB7mTPDf26n
         QIZ/TG6MwU+/a2tEnlUmlNlHifL30OvX5TuXw6SQoDyZBiJvSmRK9f/CZD+ts4uQh7vC
         mxtNZVL0NiYPSvHwuX7n8QkKTQ2+DWtBt7rp7tDEdwk0l+H9PIPCwfirYWyK6JHOTQ7B
         Bp5r50O2uhv3g7Ky08H5R+SBiRry/Rk30I1KijOT/zCWsUneQkJXfltnB6fz+vrwYteK
         Q8jLsFapauefQIaVVD3J27SlQ96RCKFtksr+6IEZsWJJXHkpRNRWh2+/A6hTojJOrn8K
         dc3g==
X-Forwarded-Encrypted: i=1; AJvYcCWULtOJc0qpx5ZfNRoEvlcZnmNnaPQoeKWUya4RdKUXjmlSdNw+1WHGHSUvYts+/a8LJgS84sUq4c9K@vger.kernel.org
X-Gm-Message-State: AOJu0YxwfNeG+YkpGuED8if6mV/KAm5tmCzALO8fjhtvIxjD/iYfM/qo
	m/0dIuV0l51ws7GXI1GZJ6NsYuKLaCKD7dNCEW7mLWzGNCNYD22561tO
X-Gm-Gg: AZuq6aLKT0t9Uhtvgjg53DxyfoWPjHMoFEerFIJmEr4hdixOzQG8SUMMrpX8cShFPvU
	WMR9ExiX5oDJTG+iKsQoxYFi0/cGk57mkbhN+3iUAsGqRBjTgE5o9oo9o/HO3q8rbj3dmsqSKPr
	FiJUkzviH+i/d+hRjywZup+d9369lvkC5omGbiLLezKPEaQKfUCqinbi1RXHHz58EqKZAuoWLoG
	QU+IERr8Arc89vmOU5tFXLdRvasqG3jDpNQ1uTTBa7BnA/2usqP/AKDwyXNwUgcw65QFZoDa/53
	dYyw+4bC362Qpd7ChFDIvvMc5FzBPJLuSr0G6SkMJ3Rupj4wb09TQGo3PM+lSQmjEZjd81CGlEm
	jqazvpZILECHMYIM2GguCWcDQ2BieINTm5CzaGszcR64C7wpKQG5sJ+TKVmgTGEBwx5UlxVsFa3
	vmzt7xc0AfJzc5tA==
X-Received: by 2002:a17:906:4783:b0:b83:1376:2bb6 with SMTP id a640c23a62f3a-b8dff7a3553mr150244566b.40.1769768775373;
        Fri, 30 Jan 2026 02:26:15 -0800 (PST)
Received: from [10.176.235.211] ([137.201.254.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8e04be76afsm86664466b.36.2026.01.30.02.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 02:26:14 -0800 (PST)
Message-ID: <ad7e2d0e5b219b4b2ef2aa7ab342513a2c66171f.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix RPMB region size detection for UFS
 2.2
From: Bean Huo <huobean@gmail.com>
To: Alexey Charkov <alchark@flipper.net>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@wdc.com>,  Bart Van Assche <bvanassche@acm.org>, "James E.J.
 Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Bean Huo <beanhuo@micron.com>, Can Guo
 <can.guo@oss.qualcomm.com>,  linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Fri, 30 Jan 2026 11:26:13 +0100
In-Reply-To: <CAKTNdwG=He3iJ8cPo4fFbcEwQQRrt_SGzoviMhi2a3kMXAO8hA@mail.gmail.com>
References: <20260129-ufs-rpmb-v1-1-691534ab723f@flipper.net>
	 <8149b8cb5a7b36a1543ca05666f33a6373674e0e.camel@gmail.com>
	 <CAKTNdwG=He3iJ8cPo4fFbcEwQQRrt_SGzoviMhi2a3kMXAO8hA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gVGh1LCAyMDI2LTAxLTI5IGF0IDIxOjEwICswNDAwLCBBbGV4ZXkgQ2hhcmtvdiB3cm90ZToK
PiBPbiBUaHUsIEphbiAyOSwgMjAyNiBhdCA4OjUz4oCvUE0gQmVhbiBIdW8gPGh1b2JlYW5AZ21h
aWwuY29tPiB3cm90ZToKPiA+IAo+ID4gT24gVGh1LCAyMDI2LTAxLTI5IGF0IDExOjM4ICswNDAw
LCBBbGV4ZXkgQ2hhcmtvdiB3cm90ZToKPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGhiYS0+ZGV2X2luZm8ucnBtYl9yZWdpb25fc2l6ZVswXSA9Cj4g
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgZ2V0X3VuYWxpZ25lZF9iZTY0KGRlc2NfYnVmCj4gPiA+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgICsKPiA+ID4gUlBNQl9VTklUX0RFU0NfUEFSQU1fTE9HSUNBTF9CTEtfQ09VTlQpCj4g
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgPDwKPiA+ID4gZGVzY19idWZbUlBNQl9VTklUX0RFU0NfUEFSQU1fTE9HSUNBTF9C
TEtfU0laRV0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCA+PiAxNzsgLyogY29udmVydCB0byAxMjgga0J5dGVzIHVuaXRz
ICovCj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH0KPiA+ID4gwqDCoMKgwqDC
oMKgwqDCoCB9Cj4gPiAKPiA+IEhpIEFsZXhleSwKPiA+IAo+ID4gdGhhbmtzIGZvciB5b3VyIGZp
eCwgSSBkaWRuJ3Qgbm90aWNlIHRoZXJlIGlzIFVGUyAyLnggb24gdGhlIG1hcmtldCB3aGljaAo+
ID4gd2lsbAo+ID4gdXNlIFVGUyBPUC1URUUgUlBNQiBmcmFtZXdvcmsuCj4gCj4gSGkgQmVhbiwg
aXQgdHVybnMgb3V0IG1hbnkgb2YgdGhlIFVGUyBtb2R1bGVzIGZvciBSb2NrY2hpcCBSSzM1NzYK
PiBiYXNlZCBkZXZpY2VzIGFyZSAyLjIuIEknbSBwb2tpbmcgYXJvdW5kIHRoZSBPUC1URUUgc3Vw
cG9ydCBvbiB0aGF0Cj4gcGxhdGZvcm0sIGFuZCBkaXNjb3ZlcmVkIHRoYXQgdGhlIGV4aXN0aW5n
IGRyaXZlciBkaWRuJ3Qgc2VlIHRoZSBSUE1CCj4gYXQgYWxsLCBzcGVudCBxdWl0ZSBhIGJpdCBv
ZiB0aW1lIHRyeWluZyB0byBmaWd1cmUgaXQgb3V0IGJlZm9yZQo+IHNwb3R0aW5nIHRoZSBkaWZm
ZXJlbmNlIGJldHdlZW4gdGhlIHR3byBzcGVjIHZlcnNpb25zIDopCj4gCj4gPiBoZXJlIGlzIHBv
dGVudGlhbCB1OCBPdmVyZmxvdywgc2luY2UgZm9yIHRoZSBVRlMzLngrLCBpdCBpcyB1OCBpbiB1
bml0Cj4gPiBkZXNjcmlwdG9yLCBidXQKPiA+IAo+ID4gCj4gPiBUaGUgY2FsY3VsYXRpb24gY2Fu
IG92ZXJmbG93IGZvciBsYXJnZXIgUlBNQiByZWdpb25zICg+MzJNQik6Cj4gPiDCoMKgIC0gQSB1
OCBjYW4gb25seSByZXByZXNlbnQgdXAgdG8gMjU1IMOXIDEyOEtCID0gfjMyTUIKPiA+IMKgwqAg
LSBUaGUgc2hpZnQgcmVzdWx0IGlzIGFzc2lnbmVkIGRpcmVjdGx5IHdpdGhvdXQgYm91bmRzIGNo
ZWNraW5nCj4gCj4gVGhlIHNwZWMgc2F5cyBpdCBjYW4gb25seSBiZSB1cCB0byAxNk1CIG1heGlt
dW0gKHNlZSBzZWN0aW9uIDEyLjQuMy4xCj4gUlBNQiBSZXNvdXJjZXMpLCBzbyBpdCBzaG91bGQg
YWx3YXlzIGZpdC4gSGFwcHkgdG8gYWRkIGEgY29tbWVudCBhYm91dAo+IHRoYXQuCj4gCj4gQmVz
dCByZWdhcmRzLAo+IEFsZXhleQoKSGkgQWxleGV5LAoKVGhhbmtzIGZvciB0aGUgY2xhcmlmaWNh
dGlvbiBvbiB0aGUgMTZNQiBSUE1CIGxpbWl0IC0gdGhhdCBhZGRyZXNzZXMgdGhlCm92ZXJmbG93
IGNvbmNlcm4uCgoKSW4geW91ciBhYm92ZSBvcGVyYXRpb24sIHdoeSBub3QgdXNlIFNaXzEyOEsg
dG8gYXZvaWQgdGhlIG1hZ2ljIG51bWJlcj8KQlRXLCBwbGVhc2UgdXBkYXRlIHlvdXIgY29tbWVu
dC4KCgoKS2luZCByZWdhcmRzLApCZWFuCgo=

