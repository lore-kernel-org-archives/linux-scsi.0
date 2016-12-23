From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 06/10] qla2xxx: Fix crash due to null pointer access.
Date: Fri, 23 Dec 2016 08:47:36 +0000
Message-ID: <1482482835.3510.7.camel@sandisk.com>
References: <1482357459-31079-1-git-send-email-himanshu.madhani@cavium.com>
         <1482357459-31079-7-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0075.outbound.protection.outlook.com ([104.47.32.75]:34261
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750855AbcLWIrr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Dec 2016 03:47:47 -0500
In-Reply-To: <1482357459-31079-7-git-send-email-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <0D4328879396634692FD846FA14965C6@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>

T24gV2VkLCAyMDE2LTEyLTIxIGF0IDEzOjU3IC0wODAwLCBIaW1hbnNodSBNYWRoYW5pIHdyb3Rl
Og0KPiBGcm9tOiBRdWlubiBUcmFuIDxxdWlubi50cmFuQGNhdml1bS5jb20+DQo+IA0KPiBUaGlz
IHBhdGNoIGZpeGVzIGNyYXNoIGR1ZSB0byBOVUxMIHBvaW50ZXIgYWNjZXNzLg0KPiANCj4gRm9s
bG93aW5nIHN0YWNrIHRyYWNlIHdpbGwgYmUgc2Vlbi4NCj4gDQo+IFsxNDY5ODc3Ljc5NzMxNV0g
Q2FsbCBUcmFjZToNCj4gWzE0Njk4NzcuNzk5OTQwXSAgWzxmZmZmZmZmZmEwM2FiNmU5Pl0gcWxh
MngwMF9tZW1fYWxsb2MrMHhiMDkvMHgxMGMwIFtxbGEyeHh4XQ0KPiBbMTQ2OTg3Ny44MDY5ODBd
ICBbPGZmZmZmZmZmYTAzYWM1MGE+XSBxbGEyeDAwX3Byb2JlX29uZSsweDg2YS8weDFiNTAgW3Fs
YTJ4eHhdDQo+IFsxNDY5ODc3LjgxNDAxM10gIFs8ZmZmZmZmZmY4MTNiNmQwMT5dID8gX19wbV9y
dW50aW1lX3Jlc3VtZSsweDUxLzB4YTANCj4gWzE0Njk4NzcuODIwMjY1XSAgWzxmZmZmZmZmZjgx
NTdjMWY1Pl0gPyBfcmF3X3NwaW5fbG9ja19pcnFzYXZlKzB4MjUvMHg5MA0KPiBbMTQ2OTg3Ny44
MjY3NzZdICBbPGZmZmZmZmZmODE1N2NkMmQ+XSA/IF9yYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9y
ZSsweDZkLzB4ODANCj4gWzE0Njk4NzcuODMzNzIwXSAgWzxmZmZmZmZmZjgxMDc0MWQxPl0gPyBw
cmVlbXB0X2NvdW50X3N1YisweGIxLzB4MTAwDQo+IFsxNDY5ODc3LjgzOTg4NV0gIFs8ZmZmZmZm
ZmY4MTU3Y2QwYz5dID8gX3Jhd19zcGluX3VubG9ja19pcnFyZXN0b3JlKzB4NGMvMHg4MA0KPiBb
MTQ2OTg3Ny44NDY4MzBdICBbPGZmZmZmZmZmODEzMTliOWM+XSBsb2NhbF9wY2lfcHJvYmUrMHg0
Yy8weGIwDQo+IFsxNDY5ODc3Ljg1MjU2Ml0gIFs8ZmZmZmZmZmY4MTA3NDFkMT5dID8gcHJlZW1w
dF9jb3VudF9zdWIrMHhiMS8weDEwMA0KPiBbMTQ2OTg3Ny44NTg3MjddICBbPGZmZmZmZmZmODEz
MTljODk+XSBwY2lfY2FsbF9wcm9iZSsweDg5LzB4YjANCg0KVGhpcyBwYXRjaCBuZWVkcyBhIG1v
cmUgZGV0YWlsZWQgZGVzY3JpcHRpb24uIFRoZXJlIGFyZSBtYW55IGNoYW5nZXMgaW4gdGhpcw0K
cGF0Y2guIFdoYXQgY2hhbmdlcyBhcmUgdGhlIGNoYW5nZXMgdGhhdCBwcmV2ZW50IHRoZSBOVUxM
IHBvaW50ZXIgZGVyZWZlcmVuY2U/DQpXaGF0IGNoYW5nZXMgKGlmIGFueSkgd2VyZSBtYWRlIGFz
IHRoZSByZXN1bHQgb2YgY29kZSBpbnNwZWN0aW9uPw0KDQpCYXJ0Lg==
