Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C064DC77B60
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Apr 2023 12:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240059AbjDZMsn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Apr 2023 08:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240672AbjDZMsm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Apr 2023 08:48:42 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA2F619A
        for <linux-scsi@vger.kernel.org>; Wed, 26 Apr 2023 05:48:11 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9536df4b907so1325144966b.0
        for <linux-scsi@vger.kernel.org>; Wed, 26 Apr 2023 05:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682513289; x=1685105289;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=38FpTAVnOdMQ8xFx5pNPgvyqDaAnYIfkDAvBt3vc7VU=;
        b=FYAxt7BA5Sh7JzNB4vkErjelpcfeMqwNbkRbwOtSpzsF/aMy29x14Hs3pU3wmJ0IBl
         9oRTIgd4f1UiZcotk5td9fILd4fYbW5nmB33fPPQ9lL/teV0S1ndbSXrGetTvgLzihX4
         04cwuyU6haw2xiOoT97K9dVXG72zzHBiFVXie2JyFF8NFvqD6us0/p/6uv3tsKjBV6iV
         eupSr12iA+2duEdkyIh1DlPQqxBSJwS56inE55oFLo2V+xyZ7XQsZtjYc0dKY/0+epx2
         cmPVWNQ4eMihaZVS5y53wtPC8fTKOf+kyQUkMTjQb2i3LNEATXQrXgjfznqfvK9JUkzq
         S/+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682513289; x=1685105289;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=38FpTAVnOdMQ8xFx5pNPgvyqDaAnYIfkDAvBt3vc7VU=;
        b=FvSBt7lYUi/oK5g5jJ9kaybd/VcQP/NmfAw0YcsnUX0DALPQ3p30YDxaGgdQoNkn4e
         2J2SA4OOren4hwRDdaJtnxAQZMax6xUGEmwPFAKaOzGCUwo1E38QlkLt+2aPv0irVhxV
         RkMPyYntLkYZOzSyg/KUeq+nQb3DMlsxI1OJUvsF86D4CmikBQEoHPRz6E1dnNzZRYfz
         GEyq5E5/IkUZZ2qr46/iJfhyByU3vK84663TtyZxAlrEKhsk2T2NU8NtfFoKN0L6kfQF
         MlGA4KrcuhUpZGXDQnyCmQEGuVjmwqrUbJ/f4x7sM4C0yZW+W/B2vhepPsy1dLk3DfS2
         A/sQ==
X-Gm-Message-State: AAQBX9dodvBIccr/ivtC68luZSfFSyhYUl63mCZ4N4cDCADG2JfT4I+i
        STi8sxvCG/MnQg2BQ0d3FVs=
X-Google-Smtp-Source: AKy350ZcEvF7zJtn+b4C/d3GFn0sbZiCozc8GR1syazspQwPc5HPX7AYaKCkiLq8Wf1LpikZ+kBMoA==
X-Received: by 2002:a17:907:6d24:b0:94a:9f9a:b3c4 with SMTP id sa36-20020a1709076d2400b0094a9f9ab3c4mr18037723ejc.49.1682513289242;
        Wed, 26 Apr 2023 05:48:09 -0700 (PDT)
Received: from [10.176.234.233] ([165.225.203.148])
        by smtp.gmail.com with ESMTPSA id rp22-20020a170906d97600b0094f3e169ca5sm8152296ejb.158.2023.04.26.05.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 05:48:08 -0700 (PDT)
Message-ID: <59bdf91413e75b96c67480823507caaf22ae24cd.camel@gmail.com>
Subject: Re: [PATCH 2/4] scsi: ufs: Fix handling of lrbp->cmd
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Santosh Y <santoshsy@gmail.com>
Date:   Wed, 26 Apr 2023 14:48:07 +0200
In-Reply-To: <20230425232954.1229916-3-bvanassche@acm.org>
References: <20230425232954.1229916-1-bvanassche@acm.org>
         <20230425232954.1229916-3-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDIzLTA0LTI1IGF0IDE2OjI5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gdWZzaGNkX3F1ZXVlY29tbWFuZCgpIG1heSBiZSBjYWxsZWQgdHdvIHRpbWVzIGluIGEgcm93
IGZvciBhIFNDU0kKPiBjb21tYW5kIGJlZm9yZSBpdCBpcyBjb21wbGV0ZWQuIEhlbmNlIG1ha2Ug
dGhlIGZvbGxvd2luZyBjaGFuZ2VzOgo+IC0gSW4gdGhlIGZ1bmN0aW9ucyB0aGF0IHN1Ym1pdCBh
IGNvbW1hbmQsIGRvIG5vdCBjaGVjayB0aGUgb2xkIHZhbHVlCj4gb2YKPiDCoCBscmJwLT5jbWQg
bm9yIGNsZWFyIGxyYnAtPmNtZCBpbiBlcnJvciBwYXRocy4KPiAtIEluIHVmc2hjZF9yZWxlYXNl
X3Njc2lfY21kKCksIGRvIG5vdCBjbGVhciBscmJwLT5jbWQuCj4gCj4gU2VlIGFsc28gc2NzaV9z
ZW5kX2VoX2NtbmQoKS4KPiAKPiBUaGlzIHBhdGNoIHByZXZlbnRzIHRoYXQgdGhlIGZvbGxvd2lu
ZyBhcHBlYXJzIGlmIGEgY29tbWFuZCB0aW1lcwo+IG91dDoKPiAKCkJhcnQsIAoKbHJicC0+Y21k
IHdpbGwgYWx3YXlzIGJlIG5vbi1OVUxMIGFmdGVyIHRoaXMgc2xvdCBpbiB0aGUgcXVldWUgaGFz
IGJlZW4KdXNlZCBvbmNlPwoKIAo+IFdBUk5JTkc6IGF0IGRyaXZlcnMvdWZzL2NvcmUvdWZzaGNk
LmM6Mjk2NQo+IHVmc2hjZF9xdWV1ZWNvbW1hbmQrMHg2ZjgvMHg5YTgKPiBDYWxsIHRyYWNlOgo+
IMKgdWZzaGNkX3F1ZXVlY29tbWFuZCsweDZmOC8weDlhOAo+IMKgc2NzaV9zZW5kX2VoX2NtbmQr
MHgyYzAvMHg5NjAKPiDCoHNjc2lfZWhfdGVzdF9kZXZpY2VzKzB4MTAwLzB4MzE0Cj4gwqBzY3Np
X2VoX3JlYWR5X2RldnMrMHhkOTAvMHgxMTRjCj4gwqBzY3NpX2Vycm9yX2hhbmRsZXIrMHgyYjQv
MHhiNzAKPiDCoGt0aHJlYWQrMHgxNmMvMHgxZTAKPiAKPiBGaXhlczogNWEwYjBjYjliZWU3ICgi
W1NDU0ldIHVmczogQWRkIHN1cHBvcnQgZm9yIHNlbmRpbmcgTk9QIE9VVAo+IFVQSVUiKQo+IFNp
Z25lZC1vZmYtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPgo+IC0tLQo+
IMKgZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyB8IDUgLS0tLS0KPiDCoDEgZmlsZSBjaGFuZ2Vk
LCA1IGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hj
ZC5jIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYwo+IGluZGV4IDBlMmEwNjU2ODU4YS4uYzY5
MWRkZjA5Njk4IDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMKPiArKysg
Yi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jCj4gQEAgLTI5NTIsNyArMjk1Miw2IEBAIHN0YXRp
YyBpbnQgdWZzaGNkX3F1ZXVlY29tbWFuZChzdHJ1Y3QgU2NzaV9Ib3N0Cj4gKmhvc3QsIHN0cnVj
dCBzY3NpX2NtbmQgKmNtZCkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoChoYmEt
PmNsa19nYXRpbmcuc3RhdGUgIT0gQ0xLU19PTikpOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoGxy
YnAgPSAmaGJhLT5scmJbdGFnXTsKPiAtwqDCoMKgwqDCoMKgwqBXQVJOX09OKGxyYnAtPmNtZCk7
Cj4gwqDCoMKgwqDCoMKgwqDCoGxyYnAtPmNtZCA9IGNtZDsKPiDCoMKgwqDCoMKgwqDCoMKgbHJi
cC0+dGFza190YWcgPSB0YWc7Cj4gwqDCoMKgwqDCoMKgwqDCoGxyYnAtPmx1biA9IHVmc2hjZF9z
Y3NpX3RvX3VwaXVfbHVuKGNtZC0+ZGV2aWNlLT5sdW4pOwo+IEBAIC0yOTY4LDcgKzI5NjcsNiBA
QCBzdGF0aWMgaW50IHVmc2hjZF9xdWV1ZWNvbW1hbmQoc3RydWN0IFNjc2lfSG9zdAo+ICpob3N0
LCBzdHJ1Y3Qgc2NzaV9jbW5kICpjbWQpCj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgZXJyID0gdWZz
aGNkX21hcF9zZyhoYmEsIGxyYnApOwo+IMKgwqDCoMKgwqDCoMKgwqBpZiAoZXJyKSB7Cj4gLcKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGxyYnAtPmNtZCA9IE5VTEw7Cj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB1ZnNoY2RfcmVsZWFzZShoYmEpOwo+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBvdXQ7Cj4gwqDCoMKgwqDCoMKgwqDCoH0KPiBAQCAt
NTQyOSw3ICs1NDI3LDYgQEAgc3RhdGljIHZvaWQgdWZzaGNkX3JlbGVhc2Vfc2NzaV9jbWQoc3Ry
dWN0Cj4gdWZzX2hiYSAqaGJhLAo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qgc2NzaV9jbW5kICpj
bWQgPSBscmJwLT5jbWQ7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgc2NzaV9kbWFfdW5tYXAoY21k
KTsKPiAtwqDCoMKgwqDCoMKgwqBscmJwLT5jbWQgPSBOVUxMO8KgwqDCoMKgwqDCoMKgLyogTWFy
ayB0aGUgY29tbWFuZCBhcyBjb21wbGV0ZWQuICovCj4gwqDCoMKgwqDCoMKgwqDCoHVmc2hjZF9y
ZWxlYXNlKGhiYSk7Cj4gwqDCoMKgwqDCoMKgwqDCoHVmc2hjZF9jbGtfc2NhbGluZ191cGRhdGVf
YnVzeShoYmEpOwo+IMKgfQo+IEBAIC03MDQ0LDcgKzcwNDEsNiBAQCBzdGF0aWMgaW50IHVmc2hj
ZF9pc3N1ZV9kZXZtYW5fdXBpdV9jbWQoc3RydWN0Cj4gdWZzX2hiYSAqaGJhLAo+IMKgwqDCoMKg
wqDCoMKgwqBkb3duX3JlYWQoJmhiYS0+Y2xrX3NjYWxpbmdfbG9jayk7Cj4gwqAKPiDCoMKgwqDC
oMKgwqDCoMKgbHJicCA9ICZoYmEtPmxyYlt0YWddOwo+IC3CoMKgwqDCoMKgwqDCoFdBUk5fT04o
bHJicC0+Y21kKTsKPiDCoMKgwqDCoMKgwqDCoMKgbHJicC0+Y21kID0gTlVMTDsKPiDCoMKgwqDC
oMKgwqDCoMKgbHJicC0+dGFza190YWcgPSB0YWc7Cj4gwqDCoMKgwqDCoMKgwqDCoGxyYnAtPmx1
biA9IDA7Cj4gQEAgLTcyMTYsNyArNzIxMiw2IEBAIGludCB1ZnNoY2RfYWR2YW5jZWRfcnBtYl9y
ZXFfaGFuZGxlcihzdHJ1Y3QKPiB1ZnNfaGJhICpoYmEsIHN0cnVjdCB1dHBfdXBpdV9yZXEgKnIK
PiDCoMKgwqDCoMKgwqDCoMKgZG93bl9yZWFkKCZoYmEtPmNsa19zY2FsaW5nX2xvY2spOwo+IMKg
Cj4gwqDCoMKgwqDCoMKgwqDCoGxyYnAgPSAmaGJhLT5scmJbdGFnXTsKPiAtwqDCoMKgwqDCoMKg
wqBXQVJOX09OKGxyYnAtPmNtZCk7Cj4gwqDCoMKgwqDCoMKgwqDCoGxyYnAtPmNtZCA9IE5VTEw7
Cj4gwqDCoMKgwqDCoMKgwqDCoGxyYnAtPnRhc2tfdGFnID0gdGFnOwo+IMKgwqDCoMKgwqDCoMKg
wqBscmJwLT5sdW4gPSBVRlNfVVBJVV9SUE1CX1dMVU47Cgo=

